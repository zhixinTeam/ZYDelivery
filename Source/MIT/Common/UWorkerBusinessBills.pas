{*******************************************************************************
  ����: dmzn@163.com 2013-12-04
  ����: ģ��ҵ�����
*******************************************************************************}
unit UWorkerBusinessBills;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,  
  UWorkerBusinessCommander, UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, 
  ULibFun, UFormCtrl, USysLoger, USysDB, UMITConst, UWorkerSelfRemote;

type
  TStockMatchItem = record
    FStock: string;         //Ʒ��
    FGroup: string;         //����
    FRecord: string;        //��¼
  end;

  TBillLadingLine = record
    FBill: string;          //������
    FLine: string;          //װ����
    FName: string;          //������
    FPerW: Integer;         //����
    FTotal: Integer;        //�ܴ���
    FNormal: Integer;       //����
    FBuCha: Integer;        //����
    FHKBills: string;       //�Ͽ���
  end;

  TWorkerBusinessBills = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD,FListE: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    //io
    FSanMultiBill: Boolean;
    //ɢװ�൥
    FStockItems: array of TStockMatchItem;
    FMatchItems: array of TStockMatchItem;
    //����ƥ��
    FBillLines: array of TBillLadingLine;
    //װ����
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetStockGroup(const nStock: string): string;
    function GetMatchRecord(const nStock: string): string;
    //���Ϸ���
    function GetCompanyID: string;
    function GetMasterCompanyID: string;
    //MIT����
    function AllowedSanMultiBill: Boolean;    
    function VerifyBeforSave(var nData: string): Boolean;
    function SaveZhiKa(var nData: string): Boolean;
    //����ֽ��(����)
    function DeleteZhiKa(var nData: string): Boolean;
    //ɾ��ֽ��(����)
    function SaveFLZhiKa(var nData: string): Boolean;
    //����ֽ��(����)
    function DeleteFLZhiKa(var nData: string): Boolean;
    //ɾ��ֽ��(����)
    function SaveICCard(var nData: string): Boolean;
    //��IC��
    function DeleteICCard(var nData: string): Boolean;
    //ע��IC��
    function SaveBills(var nData: string): Boolean;
    //���潻����
    function DeleteBill(var nData: string): Boolean;
    //ɾ��������
    function ChangeBillTruck(var nData: string): Boolean;
    //�޸ĳ��ƺ�
    function ChangeBillValue(var nData: string): Boolean;
    //�޸������
    function SyncBillLineInfo(var nData: string): Boolean;
    //ͬ�������ͨ����Ϣ
    function BillSaleAdjust(var nData: string): Boolean;
    //���۵���
    function SaveBillCard(var nData: string): Boolean;
    //�󶨴ſ�
    function LogoffCard(var nData: string): Boolean;
    //ע���ſ�
    function GetPostBillItems(var nData: string): Boolean;
    //��ȡ��λ������
    function SavePostBillItems(var nData: string): Boolean;
    //�����λ������
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function VerifyTruckNO(nTruck: string; var nData: string): Boolean;
    //��֤�����Ƿ���Ч
  end;

implementation

//------------------------------------------------------------------------------
class function TWorkerBusinessBills.FunctionName: string;
begin
  Result := sBus_BusinessSaleBill;
end;

constructor TWorkerBusinessBills.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessBills.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  FreeAndNil(FListE);
  inherited;
end;

function TWorkerBusinessBills.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessBills.GetInOutData(var nIn, nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessBills.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_SaveZhiKa           : Result := SaveZhiKa(nData);
   cBC_DeleteZhiKa         : Result := DeleteZhiKa(nData);
   cBC_SaveFLZhiKa         : Result := SaveFLZhiKa(nData);
   cBC_DeleteFLZhiKa       : Result := DeleteFLZhiKa(nData);
   cBC_SaveBills           : Result := SaveBills(nData);
   cBC_DeleteBill          : Result := DeleteBill(nData);
   cBC_SaveICCInfo         : Result := SaveICCard(nData);
   cBC_DeleteICCInfo       : Result := DeleteICCard(nData);
   cBC_ModifyBillTruck     : Result := ChangeBillTruck(nData);
   cBC_ModifyBillValue     : Result := ChangeBillValue(nData);
   cBC_ModifyBillLine      : Result := SyncBillLineInfo(nData);
   cBC_SaleAdjust          : Result := BillSaleAdjust(nData);
   cBC_SaveBillCard        : Result := SaveBillCard(nData);
   cBC_LogoffCard          : Result := LogoffCard(nData);
   cBC_GetPostBills        : Result := GetPostBillItems(nData);
   cBC_SavePostBills       : Result := SavePostBillItems(nData);
   else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����nStock��Ӧ�����Ϸ���
function TWorkerBusinessBills.GetStockGroup(const nStock: string): string;
var nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FStockItems) to High(FStockItems) do
  if FStockItems[nIdx].FStock = nStock then
  begin
    Result := FStockItems[nIdx].FGroup;
    Exit;
  end;
end;

//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����������������nStockͬƷ��,��ͬ��ļ�¼
function TWorkerBusinessBills.GetMatchRecord(const nStock: string): string;
var nStr: string;
    nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FStock = nStock then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;

  nStr := GetStockGroup(nStock);
  if nStr = '' then Exit;  

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FGroup = nStr then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;
end;

//Date: 2014-09-16
//Parm: ���ƺ�;
//Desc: ��֤nTruck�Ƿ���Ч
class function TWorkerBusinessBills.VerifyTruckNO(nTruck: string;
  var nData: string): Boolean;
var nIdx: Integer;
    nWStr: WideString;
begin
  Result := False;
  nIdx := Length(nTruck);
  if (nIdx < 3) or (nIdx > 10) then
  begin
    nData := '��Ч�ĳ��ƺų���Ϊ3-10.';
    Exit;
  end;

  nWStr := LowerCase(nTruck);
  //lower
  
  for nIdx:=1 to Length(nWStr) do
  begin
    case Ord(nWStr[nIdx]) of
     Ord('-'): Continue;
     Ord('0')..Ord('9'): Continue;
     Ord('a')..Ord('z'): Continue;
    end;

    if nIdx > 1 then
    begin
      nData := Format('���ƺ�[ %s ]��Ч.', [nTruck]);
      Exit;
    end;
  end;

  Result := True;
end;

//Date: 2014-10-07
//Desc: ����ɢװ�൥
function TWorkerBusinessBills.AllowedSanMultiBill: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SanMultiBill]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString = sFlag_Yes;
  end;
end;

//Date: 2016/8/23
//Parm:
//Desc: ��ȡϵͳID
function TWorkerBusinessBills.GetCompanyID: string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SystemCompanyID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

//Date: 2016/8/23
//Parm:
//Desc: ��ȡϵͳID
function TWorkerBusinessBills.GetMasterCompanyID: string;
var nStr: string;
begin
  Result := '';
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_MasterCompanyID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
  end;
end;

//Date: 2014-09-15
//Desc: ��֤�ܷ񿪵�
function TWorkerBusinessBills.VerifyBeforSave(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
begin
  Result := False;
  nTruck := FListA.Values['Truck'];
  if not VerifyTruckNO(nTruck, nData) then Exit;

  //----------------------------------------------------------------------------
  {$IFDEF MasterSys}
  SetLength(FStockItems, 0);
  SetLength(FMatchItems, 0);
  //init

  FSanMultiBill := AllowedSanMultiBill;
  //ɢװ�����൥

  nStr := 'Select M_ID,M_Group From %s Where M_Status=''%s'' ';
  nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes]);
  //Ʒ�ַ���ƥ��

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FStockItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      FStockItems[nIdx].FStock := Fields[0].AsString;
      FStockItems[nIdx].FGroup := Fields[1].AsString;

      Inc(nIdx);
      Next;
    end;
  end;

  nStr := 'Select R_ID,T_Bill,T_StockNo,T_Type,T_InFact,T_Valid From %s ' +
          'Where T_Truck=''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);
  //���ڶ����г���

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FMatchItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      if (FieldByName('T_Type').AsString = sFlag_San) and (not FSanMultiBill) And
         (FieldByName('T_InFact').AsString <> '') then
      begin
        nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end else

      if (FieldByName('T_Type').AsString = sFlag_Dai) and
         (FieldByName('T_InFact').AsString <> '') then
      begin
        nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end else

      if FieldByName('T_Valid').AsString = sFlag_No then
      begin
        nStr := '����[ %s ]���ѳ��ӵĽ�����[ %s ],���ȴ���.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end; 

      with FMatchItems[nIdx] do
      begin
        FStock := FieldByName('T_StockNo').AsString;
        FGroup := GetStockGroup(FStock);
        FRecord := FieldByName('R_ID').AsString;
      end;

      Inc(nIdx);
      Next;
    end;
  end;
  {$ELSE}

  //----------------------------------------------------------------------------
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nData := Format('���ƺ�[ %s ]����������.', [nTruck]);
    Exit;
  end;

  //----------------------------------------------------------------------------
  if FListA.Values['ZKType'] = sFlag_BillSZ then
  begin
    nStr := 'Select zk.*,ht.C_Area,cus.C_Type,cus.C_Name,cus.C_PY,sm.S_Name ' +
            'From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where Z_ID=''$ZID''';
  end else

  if FListA.Values['ZKType'] = sFlag_BillFX then
  begin
    nStr := 'Select zk.*,fx.*,ht.C_Area,cus.C_Type,cus.C_Name,cus.C_PY,sm.S_Name ' +
            'From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            ' Left Join $FX fx on zk.Z_ID = fx.I_ZID ' +
            'Where I_ID=''$ZID''';
  end else

  if FListA.Values['ZKType'] = sFlag_BillMY then
  begin
    nStr := 'Select zk.*,ht.C_Area,cus.C_Type,cus.C_Name,cus.C_PY,sm.S_Name ' +
            'From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            ' Left Join $MY my on zk.Z_ID = my.M_FID ' +
            'Where M_ID=''$ZID''';
  end else

  if FListA.Values['ZKType'] = sFlag_BillFL then
  begin
    nStr := 'Select zk.*,ht.C_Area,cus.C_Type,cus.C_Name,cus.C_PY,sm.S_Name ' +
            'From $FL zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where Z_ID=''$ZID''';
  end;

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$HT', sTable_SaleContract),
          MI('$Cus', sTable_Customer),
          MI('$SM', sTable_Salesman),
          MI('$FX', sTable_FXZhiKa),
          MI('$MY', sTable_MYZhiKa),
          MI('$FL', sTable_FLZhiKa),
          MI('$ZID', FListA.Values['ZhiKa'])]);
  //������Ϣ

  with gDBConnManager.WorkerQuery(FDBConn, nStr),FListA do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('����[ %s ]�Ѷ�ʧ.', [Values['ZhiKa']]);
      Exit;
    end;

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
    begin
      nData := Format('����[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
      Exit;
    end;

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
    begin
      nData := Format('����[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
      Exit;
    end;

    nStr := FieldByName('Z_TJStatus').AsString;
    if (nStr  <> '') and (FListA.Values['ZKType'] = sFlag_BillSZ) then
    begin
      if nStr = sFlag_TJOver then
           nData := '����[ %s ]�ѵ���,�����¿���.'
      else nData := '����[ %s ]���ڵ���,���Ժ�.';

      nData := Format(nData, [Values['ZhiKa']]);
      Exit;
    end;

    if (FListA.Values['ZKType'] = sFlag_BillFX) then
    begin
      if (FieldByName('I_Enabled').AsString = sFlag_No) then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
        Exit;
      end;

      nStr := FieldByName('I_TJStatus').AsString;
      if nStr  <> '' then
      begin
        if nStr = sFlag_TJOver then
             nData := '����[ %s ]�ѵ���,�����¿���.'
        else nData := '����[ %s ]���ڵ���,���Ժ�.';

        nData := Format(nData, [Values['ZhiKa']]);
        Exit;
      end;
    end;

    Values['Project'] := FieldByName('Z_Project').AsString;
    Values['Area'] := FieldByName('C_Area').AsString;
    Values['CusID'] := FieldByName('Z_Customer').AsString;
    Values['CusType'] := FieldByName('C_Type').AsString;
    Values['CusName'] := FieldByName('C_Name').AsString;
    Values['CusPY'] := FieldByName('C_PY').AsString;
    Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
    Values['SaleMan'] := FieldByName('S_Name').AsString;
    Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
    Values['PayType'] := FieldByName('Z_Paytype').AsString;
    Values['Payment'] := FieldByName('Z_Payment').AsString;
  end;
  {$ENDIF}

  Result := True;
  //verify done
end;

//Date: 2015/11/20
//Desc: ����ֽ��(����)
function TWorkerBusinessBills.SaveZhiKa(var nData: string): Boolean;
var nZID, nInZID, nSQL, nZData, nCusID, nWhere: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin 
  FListA.Clear;
  FListB.Text := PackerDecodeStr(FIn.FData);

  nInZID := FListB.Values['Z_ID'];
  nZData := FListB.Values['Z_Data'];
  nCusID := FListB.Values['Z_Customer'];

  if nInZID <> '' then  nZID := nInZID
  else
  begin
    FListC.Clear;
    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_ZhiKa;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    nZID := nOut.FData;
  end;

  if nInZID = '' then
       nWhere := ''
  else nWhere := SF('Z_ID', nZID);

  nSQL := MakeSQLByStr([SF('Z_Name', FListB.Values['Z_Name']),
          SF('Z_Project', FListB.Values['Z_Project']),
          SF('Z_ID', nZID),

          SF('Z_Customer', FListB.Values['Z_Customer']),
          SF('Z_SaleMan', FListB.Values['Z_SaleMan']),
          SF('Z_CID', FListB.Values['Z_CID']),

          SF('Z_Paytype', FListB.Values['Z_Paytype']),
          SF('Z_Payment', FListB.Values['Z_Payment']),
          SF('Z_Lading', FListB.Values['Z_Lading']),

          SF('Z_Verified', FListB.Values['Z_Verified']),
          SF('Z_Date', sField_SQLServer_Now, sfVal),
          SF('Z_Man', FListB.Values['Z_Man']),

          SF('Z_YFMoney', FListB.Values['Z_YFMoney'], sfVal)
          ], sTable_ZhiKa, nWhere, nWhere='');
  //xxxx
  FListA.Add(nSQL);

  if nInZID <> '' then
  begin
    nSQL := 'Delete From %s Where D_ZID=''%s''';
    nSQL := Format(nSQL, [sTable_ZhiKaDtl, nZID]);
    FListA.Add(nSQL);
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nZData);

  for nIdx:=0 to FListB.Count-1 do
  begin
    FListC.Clear;
    FListC.Text := PackerDecodeStr(FListB[nIdx]);

    with FListC do
    begin
      nSQL := MakeSQLByStr([SF('D_ZID', nZID),
              SF('D_Type', Values['D_Type']),
              SF('D_StockNo', Values['D_StockNo']),
              SF('D_StockName', Values['D_StockName']),
              SF('D_Price', StrToFloat(Values['D_Price']), sfVal),
              SF('D_Value', StrToFloat(Values['D_Value']), sfVal)
              ], sTable_ZhiKaDtl, '', True);
      //xxxxx
      FListA.Add(nSQL);
    end;
  end;
  //zhika detail

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    FOut.FData := nZID;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015/11/20
//Desc: ɾ��ֽ��(����)
function TWorkerBusinessBills.DeleteZhiKa(var nData: string): Boolean;
var nSQL, nZID: string;
    nIdx : Integer;
begin
  FListA.Clear;
  Result := False;
  nZID   := FIn.FData;
  //init

  nSQL := 'Select * From %s zk inner join %s zd on zk.Z_ID=zd.D_ZID ' +
          'Where Z_ID=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKa, sTable_ZhiKaDtl, nZID]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount<1 then
  begin
    nData := '����[%s]������,���֤�����';
    nData := Format(nSQL, [nZID]);

    Exit;
  end;

  nSQL := 'Delete From %s Where Z_ID=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKa, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Delete From %s Where D_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_ZhiKaDtl, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Update %s Set M_ZID=M_ZID+''_d'' Where M_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_InOutMoney, nZID]);
  FListA.Add(nSQL);

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015/11/20
//Desc: ����ֽ��(����)
function TWorkerBusinessBills.SaveFLZhiKa(var nData: string): Boolean;
var nZID, nInZID, nSQL, nZData, nCusID, nWhere: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin 
  FListA.Clear;
  FListB.Text := PackerDecodeStr(FIn.FData);

  nInZID := FListB.Values['Z_ID'];
  nZData := FListB.Values['Z_Data'];
  nCusID := FListB.Values['Z_Customer'];

  if nInZID <> '' then  nZID := nInZID
  else
  begin
    FListC.Clear;
    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_FLZhiKa;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    nZID := nOut.FData;
  end;

  if nInZID = '' then
       nWhere := ''
  else nWhere := SF('Z_ID', nZID);

  nSQL := MakeSQLByStr([SF('Z_Name', FListB.Values['Z_Name']),
          SF('Z_Project', FListB.Values['Z_Project']),
          SF('Z_ID', nZID),

          SF('Z_Customer', FListB.Values['Z_Customer']),
          SF('Z_SaleMan', FListB.Values['Z_SaleMan']),
          SF('Z_CID', FListB.Values['Z_CID']),

          SF('Z_Payment', FListB.Values['Z_Payment']),
          SF('Z_Lading', FListB.Values['Z_Lading']),

          SF('Z_Verified', FListB.Values['Z_Verified']),
          SF('Z_Date', sField_SQLServer_Now, sfVal),
          SF('Z_Man', FListB.Values['Z_Man']),

          SF('Z_YFMoney', FListB.Values['Z_YFMoney'], sfVal)
          ], sTable_FLZhiKa, nWhere, nWhere='');
  //xxxx
  FListA.Add(nSQL);

  if nInZID <> '' then
  begin
    nSQL := 'Delete From %s Where D_ZID=''%s''';
    nSQL := Format(nSQL, [sTable_FLZhiKaDtl, nZID]);
    FListA.Add(nSQL);
  end;

  FListB.Clear;
  FListB.Text := PackerDecodeStr(nZData);

  for nIdx:=0 to FListB.Count-1 do
  begin
    FListC.Clear;
    FListC.Text := PackerDecodeStr(FListB[nIdx]);

    with FListC do
    begin
      nSQL := MakeSQLByStr([SF('D_ZID', nZID),
              SF('D_Type', Values['D_Type']),
              SF('D_StockNo', Values['D_StockNo']),
              SF('D_StockName', Values['D_StockName']),
              SF('D_Price', StrToFloat(Values['D_Price']), sfVal),
              SF('D_Value', StrToFloat(Values['D_Value']), sfVal)
              ], sTable_FLZhiKaDtl, '', True);
      //xxxxx
      FListA.Add(nSQL);
    end;
  end;
  //zhika detail

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    FOut.FData := nZID;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015/11/20
//Desc: ɾ��ֽ��(����)
function TWorkerBusinessBills.DeleteFLZhiKa(var nData: string): Boolean;
var nSQL, nZID: string;
    nIdx : Integer;
begin
  FListA.Clear;
  Result := False;
  nZID   := FIn.FData;
  //init

  nSQL := 'Select * From %s zk inner join %s zd on zk.Z_ID=zd.D_ZID ' +
          'Where Z_ID=''%s''';
  nSQL := Format(nSQL, [sTable_FLZhiKa, sTable_FLZhiKaDtl, nZID]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount<1 then
  begin
    nData := '����[%s]������,���֤�����';
    nData := Format(nSQL, [nZID]);

    Exit;
  end;

  nSQL := 'Delete From %s Where Z_ID=''%s''';
  nSQL := Format(nSQL, [sTable_FLZhiKa, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Delete From %s Where D_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_FLZhiKaDtl, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Delete From %s Where F_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_ICCardInfo, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Update %s Set M_ZID=M_ZID+''_d'' Where M_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_CompensateInOutMoney, nZID]);
  FListA.Add(nSQL);

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessBills.SaveICCard(var nData: string): Boolean;
var nSQL: string;
    nIdx: Integer;
begin
  Result := False;
  FListB.Text := PackerDecodeStr(FIn.FData);

  nSQL := 'Select F_ZID From %s Where F_Card=''%s'' And F_ZType=''%s''';
  nSQL := Format(nSQL, [sTable_ICCardInfo, FListB.Values['F_Card'],
          FListB.Values['F_ZType']]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    nData := 'IC�� [ %s ] �Ѿ��󶨶��� [%s] ��';
    nData := Format(nData, [FListB.Values['F_Card'], Fields[0].AsString]);
    Exit;
  end;
  //һ��IC����ֻ�ܰ�һ��ͬ���͵Ķ�����

  FListA.Clear;

  nSQL := MakeSQLByStr([SF('F_ZID', FListB.Values['F_ZID']),
          SF('F_ZType', FListB.Values['F_ZType']),
          SF('F_Card', FListB.Values['F_Card']),
          SF('F_CardNO', FListB.Values['F_CardNO']),
          SF('F_Password', FListB.Values['F_Password']),
          SF('F_CardType', FListB.Values['F_CardType']),
          SF('F_ParentCard', FListB.Values['F_ParentCard'])
          ], sTable_ICCardInfo, '', True);
  FListA.Add(nSQL);

  nSQL := 'Update $Table Set $Field1=''$Card'', $Field2=''$NO'' Where ' +
          '$Field3=''$ID''';

  if FListB.Values['F_ZType'] = sFlag_BillSZ then //��׼����
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_ZhiKa),
            MI('$Field1', 'Z_Card'), MI('$Field2', 'Z_CardNO'),
            MI('$Field3', 'Z_ID'), MI('$Card', FListB.Values['F_Card']),
            MI('$NO', FListB.Values['F_CardNO']),
            MI('$ID', FListB.Values['F_ZID'])]);

  end else

  if FListB.Values['F_ZType'] = sFlag_BillFX then //��������
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_FXZhiKa),
            MI('$Field1', 'I_Card'), MI('$Field2', 'I_CardNO'),
            MI('$Field3', 'I_ID'), MI('$Card', FListB.Values['F_Card']),
            MI('$NO', FListB.Values['F_CardNO']),
            MI('$ID', FListB.Values['F_ZID'])]);

  end else

  if FListB.Values['F_ZType'] = sFlag_BillFL then //��������
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_FLZhiKa),
            MI('$Field1', 'Z_Card'), MI('$Field2', 'Z_CardNO'),
            MI('$Field3', 'Z_ID'), MI('$Card', FListB.Values['F_Card']),
            MI('$NO', FListB.Values['F_CardNO']),
            MI('$ID', FListB.Values['F_ZID'])]);

  end;
  FListA.Add(nSQL);

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessBills.DeleteICCard(var nData: string): Boolean;
var nSQL, nCard, nZID, nZType: string;
    nDBWorker: PDBWorker;
    nIdx: Integer;
begin
  Result := True;
  nCard  := FIn.FData;
  nZID   := FIn.FExtParam;
  if nCard = '' then Exit;

  nSQL := 'Select F_ZType From %s Where F_Card=''%s'' And F_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, nZID]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount < 1 then
  begin
    nData := 'IC�� [ %s ] δ�󶨶��� [%s] ��';
    nData := Format(nData, [nCard, nZID]);
    Exit;
  end else nZType := Fields[0].AsString;
  //һ��IC����ֻ�ܰ�һ��ͬ���͵Ķ�����

  FListA.Clear;

  nSQL := 'Delete From %s Where F_Card=''%s'' And F_ZID=''%s''';
  nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, nZID]);
  FListA.Add(nSQL);

  nSQL := 'Update $Table Set $Field1='''', $Field2='''' Where ' +
          '$Field3=''$ID''';

  if nZType = sFlag_BillSZ then //��׼����
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_ZhiKa),
            MI('$Field1', 'Z_Card'), MI('$Field2', 'Z_CardNO'),
            MI('$Field3', 'Z_ID'),MI('$ID', nZID)]);

  end else

  if nZType = sFlag_BillFX then //��������
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_FXZhiKa),
            MI('$Field1', 'I_Card'), MI('$Field2', 'I_CardNO'),
            MI('$Field3', 'I_ID'),MI('$ID', nZID)]);

  end else

  if nZType = sFlag_BillFL then //��������
  begin

    nSQL := MacroValue(nSQL, [MI('$Table', sTable_FLZhiKa),
            MI('$Field1', 'Z_Card'), MI('$Field2', 'Z_CardNO'),
            MI('$Field3', 'Z_ID'), MI('$ID', nZID)]);

  end;
  FListA.Add(nSQL);

  {$IFDEF MYGS}
  nSQL := 'Select F_ZID From %s Where F_Card=''%s'' And F_ZType=''%s''';
  nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, sFlag_BillMY]);

  nZID := '';
  nDBWorker := nil;
  try
    with gDBConnManager.SQLQuery(nSQL, nDBWorker, sFlag_DB_Master) do
    if RecordCount > 0 then
    begin
      nZID := Fields[0].AsString;

      nSQL := 'Delete From %s Where F_Card=''%s'' And F_ZID=''%s''';
      nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, nZID]);
      gDBConnManager.WorkerExec(nDBWorker, nSQL);

      //nSQL := 'Delete From %s Where M_ID=''%s''';
      //nSQL := Format(nSQL, [sTable_MYZhiKa, nZID]);
      //gDBConnManager.WorkerExec(nDBWorker, nSQL);
    end;
    //һ��IC����ֻ�ܰ�һ��ͬ���͵Ķ�����
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  {$ENDIF}

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;  

//Date: 2014-09-15
//Desc: ���潻����
function TWorkerBusinessBills.SaveBills(var nData: string): Boolean;
var nOut: TWorkerBusinessCommand;
    nStr,nSQL,nFixMoney: string;
    nStockItems: TStockParams;
    nBills: TLadingBillItems;
    nVal,nMoney: Double;
    nIdx: Integer;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if not VerifyBeforSave(nData) then Exit;

  FListB.Text := PackerDecodeStr(FListA.Values['Bills']);
  //unpack bill list

  {$IFNDEF MasterSys}
  if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
      FListA.Values['ZhiKa'], FListA.Values['ZKType'], @nOut) then
  begin
    nData := nOut.FData;
    Exit;
  end;

  nMoney := StrToFloat(nOut.FData);
  nFixMoney := nOut.FExtParam;
  //zhika money

  nVal := 0;
  SetLength(nStockItems, FListB.Count);
  //stockParams

  for nIdx:=0 to FListB.Count - 1 do
  begin
    FListC.Text := PackerDecodeStr(FListB[nIdx]);
    //get bill info

    with FListC do
      nVal := nVal + Float2Float(StrToFloat(Values['Price']) *
                     StrToFloat(Values['Value']), cPrecision, True);
    //xxxx

    with nStockItems[nIdx] do
    begin
      FStockNO := FListC.Values['StockNo'];
      FStockName := FListC.Values['StockName'];

      FValue := StrToFloat(FListC.Values['Value']);
      FPrice := StrToFloat(FListC.Values['Price']);
    end;
  end;

  if FloatRelation(nVal, nMoney, rtGreater) then
  begin
    nData := '�����[ %s ]��û���㹻�Ľ��,��������:' + #13#10#13#10 +
             '���ý��: %.2f' + #13#10 +
             '�������: %.2f' + #13#10#13#10 +
             '���С��������ٿ���.';
    nData := Format(nData, [FListA.Values['ICCard'], nMoney, nVal]);
    Exit;
  end;
  //У��������

  if FListA.Values['ZKType'] = sFlag_BillMY then
  begin
    nStr := CombineStockParams(nStockItems);

    if not TWorkerBusinessCommander.CallMe(cBC_VerifyMYZhiKaMoney,
         nStr, FListA.Values['ZhiKa'], @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
  end;  
  //У��ó�׹�˾�ͻ����

  FListD.Clear;
  for nIdx:=0 to FListB.Count - 1 do
  begin
    FListC.Text := PackerDecodeStr(FListB[nIdx]);

    nStr := Trim(FListC.Values['Seal']);
    if nStr = '' then
    begin
      nData := 'ˮ��Ʒ��[%s]�������κ�Ϊ��!';
      nData := Format(nData, [FListC.Values['StockName']]);
      Exit;
    end;
    FListD.Add(nStr);
    //xxxx
  end;

  if FListA.Values['CusType'] = sFlag_CusZY then
  begin
    if not TWorkerBusinessCommander.CallMe(cBC_GetStockBatValue,
              PackerEncodeStr(FListD.Text), '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    FListD.Text := PackerDecodeStr(nOut.FData);
    for nIdx:=0 to FListB.Count - 1 do
    begin
      FListC.Text := PackerDecodeStr(FListB[nIdx]);

      with FListC do
      if FloatRelation(StrToFloatDef(FListD.Values[Values['Seal']], 0),
         StrToFloat(Values['Value']), rtLess, cPrecision) then
      begin
        nData := '���κ�[ %s ]��������,��������:' + #13#10#13#10 +
                 '������: %.2f' + #13#10 +
                 '������: %.2f' + #13#10#13#10 +
                 '��������κź��ٿ���.';
        nData := Format(nData, [Values['Seal'],
                 StrToFloatDef(FListD.Values[Values['Seal']], 0),
                 StrToFloat(Values['Value'])]);
        Exit;
      end;  
      //xxxx
    end;
    //У�����κſ�����
  end; //��Դ��У������
  {$ENDIF}

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    SetLength(nBills, FListB.Count);
    //bills Item

    FListD.Clear;
    //SQL list

    FListE.Clear;
    //�ݴ�FListB��Ϣ

    for nIdx:=0 to FListB.Count - 1 do
    begin
      if FListA.Values['BuDan'] = sFlag_Yes then
      begin
        FListC.Clear;
        FListC.Values['Group'] :=sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_BillNo;
        FListC.Values['Table']  := sTable_Bill;
        FListC.Values['Field']  := 'L_ID';
        FListC.Values['DateTime']  := FListA.Values['PDate'];
        //to get serial no

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNOByDate,
              FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx
      end else

      begin
        FListC.Clear;
        FListC.Values['Group'] :=sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_BillNo;
        //to get serial no

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
              FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx
      end;

      FOut.FData := FOut.FData + nOut.FData + ',';
      //combine bill
      FListC.Text := PackerDecodeStr(FListB[nIdx]);
      //get bill info

      with nBills[nIdx] do
      begin
        FID     := nOut.FData;
        FZhiKa  := FListA.Values['ZhiKa'];
        FZKType := FListA.Values['ZKType'];

        FTruck  := FListA.Values['Truck'];
        FValue  := StrToFloat(FListC.Values['Value']);

        FSeal   := FListC.Values['Seal'];
        FType   := FListC.Values['Type'];
        FStockNo:= FListC.Values['StockNO'];
        FStockName := FListC.Values['StockName'];

        FSelected := True;
      end;

      nSQL := MakeSQLByStr([SF('L_ID', nBills[nIdx].FID),
              SF('L_ZhiKa', FListA.Values['ZhiKa']),
              SF('L_ZKType', FListA.Values['ZKType']),
              SF('L_Project', FListA.Values['Project']),
              SF('L_Area', FListA.Values['Area']),
              SF('L_CusID', FListA.Values['CusID']),
              SF('L_CusType', FListA.Values['CusType']),
              SF('L_CusName', FListA.Values['CusName']),
              SF('L_CusPY', FListA.Values['CusPY']),
              SF('L_SaleID', FListA.Values['SaleID']),
              SF('L_SaleMan', FListA.Values['SaleMan']),
              SF('L_ICC', FListA.Values['ICCard']),
              SF('L_ICCT', FListA.Values['ICCardType']),

              SF('L_Paytype', FListA.Values['Paytype']),
              SF('L_Payment', FListA.Values['Payment']),

              SF('L_Seal', FListC.Values['Seal']),
              SF('L_Type', FListC.Values['Type']),
              SF('L_StockNo', FListC.Values['StockNO']),
              SF('L_StockName', FListC.Values['StockName']),
              SF('L_Value', FListC.Values['Value'], sfVal),
              SF('L_Price', FListC.Values['Price'], sfVal),
              {$IFDEF MasterSys}
              SF('L_SrcCompany', FListC.Values['SrcCompany']),
              SF('L_SrcID', FListC.Values['SrcID']),
              {$ENDIF}

              SF('L_ZKMoney', nFixMoney),
              SF('L_Truck', FListA.Values['Truck']),
              SF('L_Status', sFlag_BillNew),
              SF('L_Lading', FListA.Values['Lading']),
              SF('L_IsVIP', FListA.Values['IsVIP']),
              SF('L_Man', FIn.FBase.FFrom.FUser),
              SF('L_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Bill, '', True);
      FListD.Add(nSQL);

      FListC.Values['SrcID'] := nBills[nIdx].FID;
      FListC.Values['SrcCompany'] := GetCompanyID; 
      FListE.Add(PackerEncodeStr(FListC.Text));
      //�ݴ�

      if FListA.Values['BuDan'] = sFlag_Yes then //����
      begin
        nSQL := MakeSQLByStr([
                SF('L_Status', sFlag_TruckOut),
                SF('L_InTime', FListA.Values['PDate']),
                SF('L_PValue', StrToFloat(FListA.Values['PValue']), sfVal),
                SF('L_PDate', FListA.Values['PDate']),
                SF('L_PMan', FListA.Values['PMan']),
                SF('L_MValue', FListA.Values['MValue'], sfVal),
                SF('L_MDate', FListA.Values['MDate']),
                SF('L_MMan', FListA.Values['MMan']),
                SF('L_OutFact', FListA.Values['MDate']),
                SF('L_OutMan', FIn.FBase.FFrom.FUser),
                SF('L_Date', FListA.Values['PDate']),
                SF('L_Card', '')
                ], sTable_Bill, SF('L_ID', nBills[nIdx].FID), False);
        FListD.Add(nSQL);

        FListC.Values['Group'] :=sFlag_BusGroup;
        FListC.Values['Object'] := sFlag_PoundID;
        FListC.Values['Table']  := sTable_PoundLog;
        FListC.Values['Field']  := 'P_ID';
        FListC.Values['DateTime']  := FListA.Values['PDate'];
        //to get serial no

        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNOByDate,
              FListC.Text, sFlag_Yes, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx

        nSQL := MakeSQLByStr([
                SF('P_ID', nOut.FData),
                SF('P_Type', sFlag_Sale),

                SF('P_Bill', nBills[nIdx].FID),
                SF('P_Truck', FListA.Values['Truck']),
                SF('P_CusID', FListA.Values['CusID']),
                SF('P_CusName', FListA.Values['CusName']),
                SF('P_LimValue', StrToFloat(FListC.Values['Value']), sfVal),

                SF('P_MType', FListC.Values['Type']),
                SF('P_MID', FListC.Values['StockNO']),
                SF('P_MName', FListC.Values['StockName']),

                SF('P_PMan', FListA.Values['PMan']),
                SF('P_PValue', StrToFloat(FListA.Values['PValue']), sfVal),
                SF('P_PDate', FListA.Values['PDate']),

                SF('P_MMan', FListA.Values['MMan']),
                SF('P_MValue', FListA.Values['MValue'], sfVal),
                SF('P_MDate', FListA.Values['MDate']),

                SF('P_Direction', '����'),
                SF('P_PModel', sFlag_PoundPD),
                SF('P_Status', sFlag_TruckBFM),
                SF('P_Valid', sFlag_Yes),
                SF('P_PrintNum', 1, sfVal)
                ], sTable_PoundLog, '', True);
        FListD.Add(nSQL);

        nSQL := 'Update %s Set E_Sent=E_Sent+%s ' +
                'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
                ' And Year(R_Date)>=Year(GetDate()))';
        nSQL := Format(nSQL, [sTable_StockRecordExt, FListC.Values['Value'],
                sTable_StockRecord, FListC.Values['Seal']]);
        if FListA.Values['CusType'] = sFlag_CusZY then
          FListD.Add(nSQL);
        //��Դ���������  
      end else
      begin
        {$IFDEF MasterSys}
        nStr := FListC.Values['StockNO'];
        nStr := GetMatchRecord(nStr);
        //��Ʒ����װ�������еļ�¼��

        if nStr <> '' then
        begin
          nSQL := 'Update $TK Set T_Value=T_Value + $Val,' +
                  'T_HKBills=T_HKBills+''$BL.'' Where R_ID=$RD';
          nSQL := MacroValue(nSQL, [MI('$TK', sTable_ZTTrucks),
                  MI('$RD', nStr), MI('$Val', FListC.Values['Value']),
                  MI('$BL', nBills[nIdx].FID)]);
          FListD.Add(nSQL);
        end else
        begin
          nSQL := MakeSQLByStr([
            SF('T_Truck'   , FListA.Values['Truck']),
            SF('T_StockNo' , FListC.Values['StockNO']),
            SF('T_Stock'   , FListC.Values['StockName']),
            SF('T_Type'    , FListC.Values['Type']),
            SF('T_InTime'  , sField_SQLServer_Now, sfVal),
            SF('T_Bill'    , nBills[nIdx].FID),
            SF('T_Valid'   , sFlag_Yes),
            SF('T_Value'   , FListC.Values['Value'], sfVal),
            SF('T_VIP'     , FListA.Values['IsVIP']),
            SF('T_HKBills' , nBills[nIdx].FID + '.')
            ], sTable_ZTTrucks, '', True);
          FListD.Add(nSQL);
        end;
        {$ENDIF}

        nSQL := 'Update %s Set E_Freeze=E_Freeze+%s ' +
                'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
                ' And Year(R_Date)>=Year(GetDate()))';
        nSQL := Format(nSQL, [sTable_StockRecordExt, FListC.Values['Value'],
                sTable_StockRecord, FListC.Values['Seal']]);

        if FListA.Values['CusType'] = sFlag_CusZY then
          FListD.Add(nSQL);
        //��Դ���������
      end;
    end;

    if FListA.Values['BuDan'] = sFlag_Yes then //����
    begin
      if (FListA.Values['ZKType'] = sFlag_BillSZ) or
         (FListA.Values['ZKType'] = sFlag_BillMY) then
      begin
        nSQL := 'Update %s Set A_OutMoney=A_OutMoney+%s ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal),
                FListA.Values['CusID'], FListA.Values['Paytype']]);
      end else

      if FListA.Values['ZKType'] = sFlag_BillFX then
      begin
        nSQL := 'Update %s Set I_OutMoney=I_OutMoney+%s Where I_ID=''%s'' ' +
                'And I_Enabled=''%s''';
        nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(nVal),
                FListA.Values['ZhiKa'], sFlag_Yes]);
      end else

      if FListA.Values['ZKType'] = sFlag_BillFL then
      begin
        nSQL := 'Update %s Set A_OutMoney=A_OutMoney+%s Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CompensateAccount, FloatToStr(nVal),
                FListA.Values['CusID']]);
      end;

      FListD.Add(nSQL);
      //freeze money from account
    end else
    begin
      if (FListA.Values['ZKType'] = sFlag_BillSZ) or
         (FListA.Values['ZKType'] = sFlag_BillMY) then
      begin
        nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%s ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal),
                FListA.Values['CusID'], FListA.Values['Paytype']]);
      end  else

      if FListA.Values['ZKType'] = sFlag_BillFX then
      begin
        nSQL := 'Update %s Set I_FreezeMoney=I_FreezeMoney+%s Where I_ID=''%s'' ' +
                'And I_Enabled=''%s''';
        nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(nVal),
                FListA.Values['ZhiKa'], sFlag_Yes]);
      end  else

      if FListA.Values['ZKType'] = sFlag_BillFL then
      begin
        nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%s Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CompensateAccount, FloatToStr(nVal),
                FListA.Values['CusID']]);
      end;

      FListD.Add(nSQL);
      //freeze money from account

      if FListA.Values['ZKType'] = sFlag_BillMY then
      begin
        nStr := CombineBillItmes(nBills);
        if not TWorkerBusinessCommander.CallMe(cBC_SaveMYBills,
              nStr, sFlag_BillNew, @nOut) then
          raise Exception.Create(nOut.FData);
        //xxxxx
      end;
    end;

    if nFixMoney = sFlag_Yes then
    begin
      nSQL := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%s Where Z_ID=''%s''';

      if FListA.Values['ZKType'] = sFlag_BillFL then
            nSQL := Format(nSQL, [sTable_FLZhiKa, FloatToStr(nVal),
                    FListA.Values['ZhiKa']])
      else  nSQL := Format(nSQL, [sTable_ZhiKa, FloatToStr(nVal),
                    FListA.Values['ZhiKa']]);
      //xxxxx
      FListD.Add(nSQL);
      //freeze money from zhika
    end;

    {$IFNDEF MasterSys}
    FListA.Values['Bills'] := PackerEncodeStr(FListE.Text);
    if not CallRemoteWorker(sCLI_BusinessSaleBill, PackerEncodeStr(FListA.Text), '',
      GetMasterCompanyID, @nOut, cBC_SaveBills) then
      raise Exception.Create(nOut.FData);
    {$ENDIF}

    for nIdx:=0 to FListD.Count-1 do
      gDBConnManager.WorkerExec(FDBConn, FListD[nIdx]);

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  {$IFDEF SHXZY}
  if FListA.Values['BuDan'] = sFlag_Yes then //����
  try
    nSQL := AdjustListStrFormat(FOut.FData, '''', True, ',', False);
    //bill list

    if not TWorkerBusinessCommander.CallMe(cBC_StatisticsTrucks, nSQL,
      sFlag_Sale, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx
  except
    nStr := 'Delete From %s Where L_ID In (%s)';
    nStr := Format(nStr, [sTable_Bill, nSQL]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    raise;
  end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------
//Date: 2014-09-16
//Parm: ������[FIn.FData];���ƺ�[FIn.FExtParam]
//Desc: �޸�ָ���������ĳ��ƺ�
function TWorkerBusinessBills.ChangeBillTruck(var nData: string): Boolean;
var nIdx: Integer;
    nOut: TWorkerBusinessCommand;
    nStr,nTruck,nInData,nSrcCompany: string;
begin
  Result := False;
  if not VerifyTruckNO(FIn.FExtParam, nData) then Exit;

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //�������

  {$IFDEF MasterSys}
  //�������б�
  nStr := 'Select L_ID From %s ' +
          'Where L_SrcID=''%s'' And L_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessSaleBill, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_ModifyBillTruck, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;
  {$ENDIF}

  nStr := 'Select L_Truck,L_InTime From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    if Fields[1].AsString <> '' then
    begin
      nData := '������[ %s ]�����,�޷��޸ĳ��ƺ�.';
      nData := Format(nData, [nInData]);
      Exit;
    end;


    nTruck := Fields[0].AsString;
  end;

  nStr := 'Select R_ID,T_HKBills From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      SplitStr(Fields[1].AsString, FListC, 0, '.');
      FListA.AddStrings(FListC);
      FListB.Add(Fields[0].AsString);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, nInData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //�����޸���Ϣ

    if (FListA.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListA.Count - 1 downto 0 do
      if CompareText(nInData, FListA[nIdx]) <> 0 then
      begin
        nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, FListA[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�
      end;
    end;

    if (FListB.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListB.Count - 1 downto 0 do
      begin
        nStr := 'Update %s Set T_Truck=''%s'' Where R_ID=%s';
        nStr := Format(nStr, [sTable_ZTTrucks, FIn.FExtParam, FListB[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014-09-16
//Parm: ������[FIn.FData];�������[FIn.FExtParam]
//Desc: �޸�ָ���������������
function TWorkerBusinessBills.ChangeBillValue(var nData: string): Boolean;
var nIdx: Integer;
    nOut: TWorkerBusinessCommand;
    nVal, nPrice, nMon1, nOVal, nMon2: Double;
    nStr, nZK, nZKType,nInData, nSrcCompany: string;
begin
  Result := False;
  FListA.Clear;
  //init

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //�������

  {$IFDEF MasterSys}
  //�������б�
  nStr := 'Select L_ID From %s ' +
          'Where L_SrcID=''%s'' And L_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessSaleBill, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_ModifyBillValue, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;
  {$ENDIF}

  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    if FieldByName('L_OutFact').AsString <> '' then
    begin
      nData := '�����[ %s ]�ѳ�������ֹ�޸������';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    if FieldByName('L_MDate').AsString <> '' then
    begin
      nData := '�����[ %s ]����ɶ��ι�������ֹ�޸������';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    if FieldByName('L_ZKType').AsString = sFlag_BillMY then
    begin
      nData := '��ֹ�޸�ó�׹�˾���������.';
      Exit;
    end;

    nVal := Float2Float(StrToFloat(FIn.FExtParam) , cPrecision, True);
    nOVal:= FieldByName('L_Value').AsFloat;
    nPrice:= FieldByName('L_Price').AsFloat;
    //xxxxx

    nZK     := FieldByName('L_ZhiKa').AsString;
    nZKType := FieldByName('L_ZKType').AsString;

    nVal := nVal - nOVal;
    nMon1 := Float2Float(nVal * nPrice, cPrecision, True);

    if nMon1 > 0 then
    begin
      {$IFDEF MasterSys}
      if not CallRemoteWorker(sCLI_BusinessCommand, nZK, nZKType,
        nSrcCompany, @nOut, cBC_GetZhiKaMoney) then
      begin
        nData := nOut.FData;
        Exit;
      end;
      {$ELSE}
      if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney, nZK,
        nZKType, @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
      {$ENDIF}

      nMon2 := StrToFloat(nOut.FData);
      if FloatRelation(nMon1, nMon2, rtGreater) then
      begin
        nData := '����[ %s ]�����˻�����, ��������:' + #13#10#13#10 +
                 '��.ʣ����: %.2fԪ' + #13#10 +
                 '��.������: %.2fԪ' + #13#10 +
                 '��.�벹�����: %.2fԪ';
        nData := Format(nData, [FieldByName('L_ZhiKa').AsString,
                 nMon2, nMon1, nMon1-nMon2]);
        Exit;
      end;
    end;

    {$IFNDEF MasterSys}
    nStr := 'Update %s Set E_Freeze=E_Freeze+(%s) ' +
            'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
            ' And Year(R_Date)>=Year(GetDate()))';
    nStr := Format(nStr, [sTable_StockRecordExt, FloatToStr(nVal),
            sTable_StockRecord, FieldByName('L_Seal').AsString]);

    if FieldByName('L_CusType').AsString = sFlag_CusZY then
      FListA.Add(nStr);
    //��Դ���������

    if (nZKType = sFlag_BillSZ) or (nZKType = sFlag_BillMY) then
    begin
      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nMon1),
              FieldByName('L_CusID').AsString, FieldByName('L_PayType').AsString]);
    end  else

    if nZKType = sFlag_BillFX then
    begin
      nStr := 'Update %s Set I_FreezeMoney=I_FreezeMoney+%s Where I_ID=''%s'' ' +
              'And I_Enabled=''%s''';
      nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nMon1),nZK, sFlag_Yes]);
    end  else

    if nZKType = sFlag_BillFL then
    begin
      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%s Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CompensateAccount, FloatToStr(nMon1),
              FieldByName('L_CusID').AsString]);
    end;

    FListA.Add(nStr);
    //���¶�����
    {$ENDIF}

    nStr := 'Update %s Set L_Value=%s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, nInData]);
    FListA.Add(nStr);
    //���������

    nStr := 'Update %s Set T_Value=T_Value+(%s) Where T_HKBills Like ''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, FloatToStr(nVal), nInData]);
    FListA.Add(nStr);
    //���¶����������
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx := 0 to FListA.Count-1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2016/8/28
//Parm: ������б�
//Desc: ���·�ϵͳ�е�ͨ����Ϣ
function TWorkerBusinessBills.SyncBillLineInfo(var nData: string): Boolean;
var nIdx: Integer;
    nSQL: String;
begin
  Result := True;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Count < 1 then Exit;

  FListC.Clear;
  for nIdx := 0 to FListA.Count - 1 do
  begin
    FListB.Text := PackerDecodeStr(FListA[nIdx]);

    nSQL := MakeSQLByStr([SF('L_LadeLine', FListB.Values['LadeLine']),
            SF('L_LineName', FListB.Values['LineName']),
            SF('L_DaiTotal', StrToInt(FListB.Values['DaiTotal']), sfVal),
            SF('L_DaiNormal', StrToInt(FListB.Values['DaiNormal']), sfVal),
            SF('L_DaiBuCha', StrToInt(FListB.Values['DaiBuCha']), sfVal)
            ], sTable_Bill, SF('L_ID', FListB.Values['ID']), False);
    FListC.Add(nSQL);
  end;  

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListC.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

end;  

//Date: 2014-09-30
//Parm: ��������[FIn.FData];�¶���[FIn.FExtParam]
//Desc: ���������������¶����Ŀͻ�
function TWorkerBusinessBills.BillSaleAdjust(var nData: string): Boolean;
var nIdx: Integer;
    nOut: TWorkerBusinessCommand;
    nStr, nNewZKType, nNewZK, nICType: string;
    nVal,nNewMon,nOldMon,nNewPrice,nOldPrice: Double;
begin
  Result := False;
  nNewZK := FIn.FExtParam;
  //init

  //----------------------------------------------------------------------------
  nStr := 'Select L_CusID,L_StockNo,L_StockName,L_Value,L_Price,L_ZhiKa,' +
          'L_ZKType, L_ZKMoney,L_OutFact,L_Paytype,L_Payment ' +
          'From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    if FieldByName('L_OutFact').AsString = '' then
    begin
      nData := '����������(������)���ܵ���.';
      Exit;
    end;

    FListB.Clear;
    with FListB do
    begin
      Values['CusID'] := FieldByName('L_CusID').AsString;
      Values['StockNo'] := FieldByName('L_StockNo').AsString;
      Values['StockName'] := FieldByName('L_StockName').AsString;
      Values['ZhiKa'] := FieldByName('L_ZhiKa').AsString;
      Values['ZKType']:= FieldByName('L_ZKType').AsString;
      Values['ZKMoney'] := FieldByName('L_ZKMoney').AsString;
      Values['Paytype'] := FieldByName('L_Paytype').AsString;
      Values['Payment'] := FieldByName('L_Payment').AsString;
    end;

    nVal      := FieldByName('L_Value').AsFloat;
    nOldPrice := FieldByName('L_Price').AsFloat;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select F_ZType,F_CardType From $ICTable Where F_ZID =''$NewZK''';
  nStr := MacroValue(nStr, [MI('$ICTable', sTable_ICCardInfo),
          MI('$NewZK', nNewZK)]);
          
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('����[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
      Exit;
    end;

    nNewZKType := Fields[0].AsString;
    nICType    := Fields[1].AsString;
  end;

  //----------------------------------------------------------------------------
  if nNewZKType = sFlag_BillSZ then
  begin

    //----------------------------------------------------------------------------
    nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where Z_ID=''$ZID''';
    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
            MI('$HT', sTable_SaleContract),
            MI('$Cus', sTable_Customer),
            MI('$SM', sTable_Salesman),
            MI('$ZID', nNewZK)]);
    //������Ϣ

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('����[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      if FieldByName('Z_InValid').AsString = sFlag_Yes then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      FListA.Clear;
      with FListA do
      begin
        Values['Project'] := FieldByName('Z_Project').AsString;
        Values['Area'] := FieldByName('C_Area').AsString;
        Values['CusID'] := FieldByName('Z_Customer').AsString;
        Values['CusName'] := FieldByName('C_Name').AsString;
        Values['CusPY'] := FieldByName('C_PY').AsString;
        Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
        Values['SaleMan'] := FieldByName('S_Name').AsString;
        Values['Card']    := FieldByName('Z_CardNO').AsString;
        Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
        Values['Paytype'] := FieldByName('Z_Paytype').AsString;
        Values['Payment'] := FieldByName('Z_Payment').AsString;
      end;
    end;

    //----------------------------------------------------------------------------
    nStr := 'Select D_Price From %s Where D_ZID=''%s'' And D_StockNo=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, FIn.FExtParam, FListB.Values['StockNo']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '����[ %s ]��û������Ϊ[ %s ]��Ʒ��.';
        nData := Format(nData, [FIn.FExtParam, FListB.Values['StockName']]);
        Exit;
      end;

      nNewPrice := Fields[0].AsFloat;
    end;

  end else

  if nNewZKType = sFlag_BillFX then
  begin

    //----------------------------------------------------------------------------
    nStr := 'Select fx.*,zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name ' +
            'From $FXK fx Left Join $ZK zk on fx.I_ZID=zk.Z_ID' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where I_ID=''$ZID''';
    nStr := MacroValue(nStr, [MI('$FXK', sTable_FXZhiKa),MI('$ZK', sTable_ZhiKa),
            MI('$HT', sTable_SaleContract),
            MI('$Cus', sTable_Customer),
            MI('$SM', sTable_Salesman),
            MI('$ZID', nNewZK)]);
    //������Ϣ

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('����[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      if (FieldByName('Z_InValid').AsString = sFlag_Yes) or
         (FieldByName('I_Enabled').AsString = sFlag_No)  then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      FListA.Clear;
      with FListA do
      begin
        Values['Project'] := FieldByName('Z_Project').AsString;
        Values['Area'] := FieldByName('C_Area').AsString;
        Values['CusID'] := FieldByName('Z_Customer').AsString;
        Values['CusName'] := FieldByName('C_Name').AsString;
        Values['CusPY'] := FieldByName('C_PY').AsString;
        Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
        Values['SaleMan'] := FieldByName('S_Name').AsString;
        Values['Card']    := FieldByName('I_CardNO').AsString;
        Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
        Values['StockNo'] := FieldByName('I_StockNo').AsString;
        Values['Paytype'] := FieldByName('Z_Paytype').AsString;
        Values['Payment'] := FieldByName('Z_Payment').AsString;

        nNewPrice := FieldByName('I_Price').AsFloat;
      end;
    end;

    if FListA.Values['StockNo'] <> FListB.Values['StockNo'] then
    begin
      nData := '����[ %s ]��û������Ϊ[ %s ]��Ʒ��.';
      nData := Format(nData, [FIn.FExtParam, FListB.Values['StockName']]);
      Exit;
    end;

  end else

  if nNewZKType = sFlag_BillFL then
  begin
    //----------------------------------------------------------------------------
    nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name From $ZK zk ' +
            ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
            'Where Z_ID=''$ZID''';
    nStr := MacroValue(nStr, [MI('$ZK', sTable_FLZhiKa),
            MI('$HT', sTable_SaleContract),
            MI('$Cus', sTable_Customer),
            MI('$SM', sTable_Salesman),
            MI('$ZID', nNewZK)]);
    //������Ϣ

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('����[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      if FieldByName('Z_InValid').AsString = sFlag_Yes then
      begin
        nData := Format('����[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
        Exit;
      end;

      FListA.Clear;
      with FListA do
      begin
        Values['Project'] := FieldByName('Z_Project').AsString;
        Values['Area'] := FieldByName('C_Area').AsString;
        Values['CusID'] := FieldByName('Z_Customer').AsString;
        Values['CusName'] := FieldByName('C_Name').AsString;
        Values['CusPY'] := FieldByName('C_PY').AsString;
        Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
        Values['SaleMan'] := FieldByName('S_Name').AsString;
        Values['Card']    := FieldByName('Z_CardNO').AsString;
        Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
        Values['Paytype'] := FieldByName('Z_Paytype').AsString;
        Values['Payment'] := FieldByName('Z_Payment').AsString;
      end;
    end;

    //----------------------------------------------------------------------------
    nStr := 'Select D_Price From %s Where D_ZID=''%s'' And D_StockNo=''%s''';
    nStr := Format(nStr, [sTable_FLZhiKaDtl, FIn.FExtParam, FListB.Values['StockNo']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '����[ %s ]��û������Ϊ[ %s ]��Ʒ��.';
        nData := Format(nData, [FIn.FExtParam, FListB.Values['StockName']]);
        Exit;
      end;

      nNewPrice := Fields[0].AsFloat;
    end;
  end else Exit;
  //У���Ƿ���Ե���

  //----------------------------------------------------------------------------
  nNewMon := nVal * nNewPrice;
  nNewMon := Float2Float(nNewMon, cPrecision, True);

  
  nOldMon := nVal * nOldPrice;
  nOldMon := Float2Float(nOldMon, cPrecision, True);

  if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
          nNewZK, nNewZKType, @nOut) then
  begin
    nData := nOut.FData;
    Exit;
  end;

  if FloatRelation(nNewMon, StrToFloat(nOut.FData), rtGreater, cPrecision) then
  begin
    nData := '�ͻ������[ %s.%s ]����,��������:' + #13#10#13#10 +
             '��.�������: %.2fԪ' + #13#10 +
             '��.��������: %.2fԪ' + #13#10 +
             '��.�� �� ��: %.2fԪ' + #13#10#13#10 +
             '�뵽�����Ұ���"��������"����,Ȼ���ٴε���.';
    nData := Format(nData, [FListA.Values['Card'], FListA.Values['CusName'],
             StrToFloat(nOut.FData), nNewMon,
             Float2Float(nNewMon - StrToFloat(nOut.FData), cPrecision, True)]);
    Exit;
  end;

  FListC.Clear;
  if FListB.Values['ZKType'] = sFlag_BillSZ then
  begin

    nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) ' +
            'Where A_CID=''%s'' And A_Type=''%s''';
    nStr := Format(nStr, [sTable_CusAccDetail, nOldMon,
            FListB.Values['CusID'], FListB.Values['Paytype']]);
    FListC.Add(nStr); //��ԭ���������

    if FListB.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) ' +
              'Where Z_ID=''%s'' And Z_OnlyMoney=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nOldMon,
              FListB.Values['ZhiKa'], sFlag_Yes]);
      FListC.Add(nStr); //��ԭ�����������
    end;

    //������ԭ�˻����
  end else

  if FListB.Values['ZKType'] = sFlag_BillFX then
  begin

    nStr := 'Update %s Set I_OutMoney=I_OutMoney-(%.2f) Where I_ID=''%s''';
    nStr := Format(nStr, [sTable_FXZhiKa, nOldMon, FListB.Values['ZhiKa']]);
    FListC.Add(nStr); //��ԭ���������

    //��������ԭ����������
  end else

  if FListB.Values['ZKType'] = sFlag_BillFL then
  begin
    nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nOldMon, FListB.Values['CusID']]);
    FListC.Add(nStr); //��ԭ���������

    if FListB.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) ' +
              'Where Z_ID=''%s'' And Z_OnlyMoney=''%s''';
      nStr := Format(nStr, [sTable_FLZhiKa, nOldMon,
              FListB.Values['ZhiKa'], sFlag_Yes]);
      FListC.Add(nStr); //��ԭ�����������
    end;

    //������ԭ�˻����
  end;
  //��ԭ����

  if nNewZKType = sFlag_BillSZ then
  begin

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+(%.2f) ' +
            'Where A_CID=''%s'' And A_Type=''%s''';
    nStr := Format(nStr, [sTable_CusAccDetail, nNewMon,
            FListA.Values['CusID'], FListA.Values['Paytype']]);
    FListC.Add(nStr); //���ӵ���������

    if FListA.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nNewMon, nNewZK]);
      FListC.Add(nStr); //�ۼ�������������
    end;

    //���������������û�����
  end else

  if nNewZKType = sFlag_BillFX then
  begin

    nStr := 'Update %s Set I_OutMoney=I_OutMoney+(%.2f) Where I_ID=''%s''';
    nStr := Format(nStr, [sTable_FXZhiKa, nNewMon, nNewZK]);
    FListC.Add(nStr); //��ԭ���������

    //���������ӵ�������������
  end else

  if nNewZKType = sFlag_BillFL then
  begin
    nStr := 'Update %s Set A_OutMoney=A_OutMoney+(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nNewMon, FListA.Values['CusID']]);
    FListC.Add(nStr); //���ӵ���������

    if FListA.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_FLZhiKa, nNewMon, nNewZK]);
      FListC.Add(nStr); //�ۼ�������������
    end;

    //���������������û�����
  end;
  //��ԭ����

  nStr := MakeSQLByStr([SF('L_ZhiKa', FIn.FExtParam),SF('L_ZKType', nNewZKType),
          SF('L_Project', FListA.Values['Project']),
          SF('L_Area', FListA.Values['Area']),
          SF('L_ICC', FListA.Values['Card']),
          SF('L_ICCT', nICType),

          SF('L_Paytype', FListA.Values['Paytype']),
          SF('L_Payment', FListA.Values['Payment']),

          SF('L_CusID', FListA.Values['CusID']),
          SF('L_CusName', FListA.Values['CusName']),
          SF('L_CusPY', FListA.Values['CusPY']),
          SF('L_SaleID', FListA.Values['SaleID']),
          SF('L_SaleMan', FListA.Values['SaleMan']),
          SF('L_Price', nNewPrice, sfVal),
          SF('L_ZKMoney', FListA.Values['ZKMoney'])
          ], sTable_Bill, SF('L_ID', FIn.FData), False);
  FListC.Add(nStr); //��������

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListC.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-16
//Parm: ��������[FIn.FData]
//Desc: ɾ��ָ��������
function TWorkerBusinessBills.DeleteBill(var nData: string): Boolean;
var nIdx: Integer;
    nHasOut,nD: Boolean;
    nVal,nMoney: Double;
    nInData, nSrcCompany: string;
    nOut: TWorkerBusinessCommand;
    nStr,nP,nFix,nRID,nCus,nBill,nCType,nZK,nZKType, nPaytype: string;
begin
  Result := False;
  //init

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //�������
  
  {$IFDEF MasterSys}
  nStr := 'Select L_ID From %s ' +
          'Where L_SrcID=''%s'' And L_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessSaleBill, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_DeleteBill, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  nD   := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_DeleteHasOut]);
  With gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then nD := Fields[0].AsString = sFlag_Yes;

  nStr := 'Select L_ZhiKa,L_Value,L_Price,L_CusID,L_OutFact,L_ZKMoney,' +
          'L_CusType,L_ICCT,L_ICC,L_Seal,L_ZKType,L_Paytype ' +
          'From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    nHasOut := FieldByName('L_OutFact').AsString <> '';
    //�ѳ���

    if nHasOut and (not nD) then
    begin
      nData := '������[ %s ]�ѳ���,������ɾ��.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    nCus := FieldByName('L_CusID').AsString;
    nZK  := FieldByName('L_ZhiKa').AsString;
    nFix := FieldByName('L_ZKMoney').AsString;
    nCType:=FieldByName('L_CusType').AsString;

    nVal := FieldByName('L_Value').AsFloat;
    nMoney := Float2Float(nVal*FieldByName('L_Price').AsFloat, cPrecision, True);

    nP      := FieldByName('L_Seal').AsString; 
    nZKType := FieldByName('L_ZKType').AsString;
    nPaytype:= FieldByName('L_Paytype').AsString;
  end;

  {$IFDEF MasterSys}
  nStr := 'Select R_ID,T_HKBills,T_Bill From %s ' +
          'Where T_HKBills Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_ZTTrucks, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]�����ڶ�����¼��,�쳣��ֹ!';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    nRID := Fields[0].AsString;
    nBill := Fields[2].AsString;
    SplitStr(Fields[1].AsString, FListA, 0, '.')
  end else
  begin
    nRID := '';
    FListA.Clear;
  end;
  {$ENDIF}

  if nZKType = sFlag_BillMY then
  begin
    if not TWorkerBusinessCommander.CallMe(cBC_DeleteMYBill,
              nInData, nZK, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
  end;  

  FDBConn.FConn.BeginTrans;
  try
    {$IFDEF MasterSys}
    if FListA.Count = 1 then
    begin
      nStr := 'Delete From %s Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nRID]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else

    if FListA.Count > 1 then
    begin
      nIdx := FListA.IndexOf(nInData);
      if nIdx >= 0 then
        FListA.Delete(nIdx);
      //�Ƴ��ϵ��б�

      if nBill = nInData then
        nBill := FListA[0];
      //����������

      nStr := 'Update %s Set T_Bill=''%s'',T_Value=T_Value-(%.2f),' +
              'T_HKBills=''%s'' Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nBill, nVal,
              CombinStr(FListA, '.'), nRID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //���ºϵ���Ϣ
    end;
    {$ENDIF}

    //--------------------------------------------------------------------------
    if nHasOut then
    begin
      if (nZKType = sFlag_BillSZ) or (nZKType = sFlag_BillMY) then
      begin
        nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nStr := Format(nStr, [sTable_CusAccDetail, nMoney, nCus, nPaytype]);
      end else

      if nZKType = sFlag_BillFX then
      begin
        nStr := 'Update %s Set I_OutMoney=I_OutMoney-(%.2f) ' +
                'Where I_ID=''%s''';
        nStr := Format(nStr, [sTable_FXZhiKa, nMoney, nZK]);
      end else

      if nZKType = sFlag_BillFL then
      begin
        nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CompensateAccount, nMoney, nCus]);
      end;

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷų���
    end else
    begin
      if (nZKType = sFlag_BillSZ) or (nZKType = sFlag_BillMY) then
      begin
        nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%s) ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nMoney), nCus, nPaytype]);
      end else

      if nZKType = sFlag_BillFX then
      begin
        nStr := 'Update %s Set I_FreezeMoney=I_FreezeMoney-(%s) ' +
                'Where I_ID=''%s''';
        nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nMoney), nZK]);
      end else

      if nZKType = sFlag_BillFL then
      begin
        nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%s) ' +
                'Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CompensateAccount, FloatToStr(nMoney), nCus]);
      end;

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷŶ����

      nStr := 'Update %s Set E_Freeze=E_Freeze-%s ' +
              'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
              ' And Year(R_Date)>=Year(GetDate()))';
      nStr := Format(nStr, [sTable_StockRecordExt, FloatToStr(nVal),
              sTable_StockRecord, nP]);
      if nCType = sFlag_CusZY then gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    if nFix = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%s) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, FloatToStr(nMoney), nZK]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
      //�ͷ�������
    end;
    
    //--------------------------------------------------------------------------
    {$IFNDEF MasterSys}
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //�����ֶ�,������ɾ��

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', nInData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    {$ENDIF}

    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nInData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    
    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: ������[FIn.FData];�ſ���[FIn.FExtParam]
//Desc: Ϊ�������󶨴ſ�
function TWorkerBusinessBills.SaveBillCard(var nData: string): Boolean;
var nStr,nSQL,nTruck,nType,nSrcCompany,nBills: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin  
  nType := '';
  nTruck := '';
  Result := False;

  nBills := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //�������
  
  {$IFDEF MasterSys}
  nStr := AdjustListStrFormat(nBills, '''', True, ',', False);
  //�������б�
  nSQL := 'Select L_ID From %s ' +
          'Where L_SrcID In (%s) And L_SrcCompany=''%s''';
  nSQL := Format(nSQL, [sTable_Bill, nStr, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [nBills]);
      Exit;
    end;

    nBills := '';
    First;

    while not Eof do
    begin
      nBills := nBills + Fields[0].AsString + ',';
      Next;
    end;

    nIdx := Length(nBills);
    if Copy(nBills, nIdx, 1) = ',' then
      System.Delete(nBills, nIdx, 1);
    //xxxxx
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessSaleBill, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_SaveBillCard, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  FListB.Text := FIn.FExtParam;
  //�ſ��б�
  nStr := AdjustListStrFormat(nBills, '''', True, ',', False);
  //�������б�

  nSQL := 'Select L_ID,L_Card,L_Type,L_Truck,L_OutFact From %s ' +
          'Where L_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    First;
    while not Eof do
    begin
      if FieldByName('L_OutFact').AsString <> '' then
      begin
        nData := '������[ %s ]�ѳ���,��ֹ�쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '������[ %s ]�ĳ��ƺŲ�һ��,���ܲ���.' + #13#10#13#10 +
                 '*.��������: %s' + #13#10 +
                 '*.��������: %s' + #13#10#13#10 +
                 '��ͬ�ƺŲ��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString, nStr, nTruck]);
        Exit;
      end;

      if nTruck = '' then
        nTruck := nStr;
      //xxxxx

      nStr := FieldByName('L_Type').AsString;
      if (nType <> '') and ((nStr <> nType) or (nStr = sFlag_San)) then
      begin
        if nStr = sFlag_San then
             nData := '������[ %s ]ͬΪɢװ,���ܲ���.'
        else nData := '������[ %s ]��ˮ�����Ͳ�һ��,���ܲ���.';
          
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      if nType = '' then
        nType := nStr;
      //xxxxx

      nStr := FieldByName('L_Card').AsString;
      //����ʹ�õĴſ�
        
      if (nStr <> '') and (FListB.IndexOf(nStr) < 0) then
        FListB.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  SplitStr(nBills, FListA, 0, ',');
  //�������б�
  nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
  //�ſ��б�

  nSQL := 'Select L_ID,L_Type,L_Truck From %s Where L_Card In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('L_Type').AsString;
      if (nType <> '') and (nStr <> nType) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,�޷�����.';
        nData := Format(nData, [FieldByName('L_Truck').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,��ͬ�ƺŲ��ܲ���.';
        nData := Format(nData, [nStr]);
        Exit;
      end;

      nStr := FieldByName('L_ID').AsString;
      if FListA.IndexOf(nStr) < 0 then
        FListA.Add(nStr);
      Next;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    if nBills <> '' then
    begin
      nStr := AdjustListStrFormat2(FListA, '''', True, ',', False);
      //���¼����б�

      nSQL := 'Update %s Set L_Card=''%s'', L_CDate=%s Where L_ID In(%s)';
      nSQL := Format(nSQL, [sTable_Bill, FIn.FExtParam, sField_SQLServer_Now, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Sale),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Freeze', sFlag_No),
              SF('C_Used', sFlag_Sale),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, nStr, False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData]
//Desc: ע���ſ�
function TWorkerBusinessBills.LogoffCard(var nData: string): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  FDBConn.FConn.BeginTrans;
  try
    {$IFNDEF MasterSys}
    if not CallRemoteWorker(sCLI_BusinessSaleBill, FIn.FData, FIn.FExtParam,
      GetMasterCompanyID, @nOut, cBC_LogoffCard, GetCompanyID) then
    begin
      nData := nOut.FData;
      Exit;
    end;
    {$ENDIF}

    nStr := 'Update %s Set L_Card=Null, L_CDate=Null Where L_Card=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ��ȡ�ض���λ����Ҫ�Ľ������б�
function TWorkerBusinessBills.GetPostBillItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsBill: Boolean;
    nBills: TLadingBillItems;
begin
  Result := False;
  nIsBill := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsBill := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //ǰ׺�ͳ��ȶ����㽻�����������,����Ϊ��������
  end;

  if not nIsBill then
  begin
    nStr := 'Select C_Status,C_Freeze From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('�ſ�[ %s ]��Ϣ�Ѷ�ʧ.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '�ſ�[ %s ]��ǰ״̬Ϊ[ %s ],�޷����.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '�ſ�[ %s ]�ѱ�����,�޷����.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
    end;
  end;

  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusType,L_CusName,L_Type,' +
          'L_StockNo,L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
          'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,L_Seal,L_ZKType,' +
          'L_PDate,L_Paytype, L_Payment ' +
          ' From $Bill b ';
  //xxxxx

  if nIsBill then
       nStr := nStr + 'Where L_ID=''$CD'''
  else nStr := nStr + 'Where L_Card=''$CD''';

  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if nIsBill then
           nData := '������[ %s ]����Ч.'
      else nData := '�ſ���[ %s ]û�н�����.';

      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    SetLength(nBills, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with nBills[nIdx] do
    begin
      FID         := FieldByName('L_ID').AsString;
      FZhiKa      := FieldByName('L_ZhiKa').AsString;
      FCusID      := FieldByName('L_CusID').AsString;
      FCusType    := FieldByName('L_CusType').AsString;
      FCusName    := FieldByName('L_CusName').AsString;
      FTruck      := FieldByName('L_Truck').AsString;

      FType       := FieldByName('L_Type').AsString;
      FStockNo    := FieldByName('L_StockNo').AsString;
      FStockName  := FieldByName('L_StockName').AsString;
      FValue      := FieldByName('L_Value').AsFloat;
      FPrice      := FieldByName('L_Price').AsFloat;

      FSeal       := FieldByName('L_Seal').AsString;
      FZKType     := FieldByName('L_ZKType').AsString;

      FCard       := FieldByName('L_Card').AsString;
      FIsVIP      := FieldByName('L_IsVIP').AsString;
      FStatus     := FieldByName('L_Status').AsString;
      FPayType    := FieldByName('L_Paytype').AsString;
      FNextStatus := FieldByName('L_NextStatus').AsString;

      if FIsVIP = sFlag_TypeShip then
      begin
        FStatus    := sFlag_TruckZT;
        FNextStatus := sFlag_TruckOut;
      end;

      if FStatus = sFlag_BillNew then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      FPData.FValue := FieldByName('L_PValue').AsFloat;
      FPData.FDate  := FieldByName('L_PDate').AsDateTime;
      FMData.FValue := FieldByName('L_MValue').AsFloat;
      FSelected := True;

      Inc(nIdx);
      Next;
    end;
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2014-09-18
//Parm: ������[FIn.FData];��λ[FIn.FExtParam]
//Desc: ����ָ����λ�ύ�Ľ������б�
function TWorkerBusinessBills.SavePostBillItems(var nData: string): Boolean;
var nStr,nSQL,nTmp: string;
    f,m,nVal,nMVal: Double;
    i,nIdx,nInt: Integer;
    nOut: TWorkerBusinessCommand;
    nBills: TLadingBillItems;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nBills);
  nInt := Length(nBills);

  if nInt < 1 then
  begin
    nData := '��λ[ %s ]�ύ�ĵ���Ϊ��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  {$IFDEF MasterSys}
  nTmp := '';
  for nIdx := Low(nBills) to High(nBills) do
  begin
    nSQL := 'Select L_SrcID, L_SrcCompany From %s Where L_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Bill, nBills[nIdx].FID]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '��λ[ %s ]�ύ�ĵ��ݱ��[ %s ]������.';
        nData := Format(nData, [PostTypeToStr(FIn.FExtParam), nBills[nIdx].FID]);
        Exit;
      end;

      if (nTmp <> '') And (nTmp <> Fields[1].AsString) then
      begin
        nData := '��ͬ������ֹƴ��';
        Exit;
      end;  

      nTmp := Fields[1].AsString;
      nBills[nIdx].FID := Fields[0].AsString;
    end;
  end;

  nStr := CombineBillItmes(nBills);
  if not CallRemoteWorker(sCLI_BusinessSaleBill, nStr, FIn.FExtParam, nTmp,
    @nOut, cBC_SavePostBills) then
  begin
    nData := nOut.FData;
    Exit;
  end;

  AnalyseBillItems(FIn.FData, nBills);
  {$ENDIF}

  FListA.Clear;
  //���ڴ洢SQL�б�

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //����
  begin
    with nBills[0] do
    begin
      FStatus := sFlag_TruckIn;
      FNextStatus := sFlag_TruckBFP;
    end;

    if nBills[0].FType = sFlag_Dai then
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundIfDai]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
       if (RecordCount > 0) and (Fields[0].AsString = sFlag_No) then
        nBills[0].FNextStatus := sFlag_TruckZT;
      //��װ������
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    begin
      nStr := SF('L_ID', nBills[nIdx].FID);
      nSQL := MakeSQLByStr([
              SF('L_Status', nBills[0].FStatus),
              SF('L_NextStatus', nBills[0].FNextStatus),
              SF('L_InTime', sField_SQLServer_Now, sfVal),
              SF('L_InMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InFact=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
              nBills[nIdx].FID]);
      FListA.Add(nSQL);
      //���¶��г�������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //����Ƥ��
  begin
    FListB.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        FListB.Add(Fields[0].AsString);
        Next;
      end;
    end;

    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��Ƥ������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckBFP;
      if FType = sFlag_Dai then
           FNextStatus := sFlag_TruckZT
      else FNextStatus := sFlag_TruckFH;

      if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM;
      //�ֳ�������ֱ�ӹ���

      nSQL := MakeSQLByStr([
              SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FOut.FData := nOut.FData;
      //���ذ񵥺�,�������հ�

      nSQL := MakeSQLByStr([
              SF('P_ID', nOut.FData),
              SF('P_Type', sFlag_Sale),
              SF('P_Bill', FID),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', FType),
              SF('P_LimValue', FValue),
              SF('P_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', nBills[nInt].FFactory),
              SF('P_PStation', nBills[nInt].FPData.FStation),
              SF('P_Direction', '����'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckZT then //ջ̨�ֳ�
  begin
    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPData.FValue > 0 then
    begin
      nInt := nIdx;
      Break;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckZT;
      if nInt >= 0 then //�ѳ�Ƥ
           FNextStatus := sFlag_TruckBFM
      else FNextStatus := sFlag_TruckOut;

      nSQL := MakeSQLByStr([SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_LadeMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬
    end;
  end else

  if FIn.FExtParam = sFlag_TruckFH then //�Ż��ֳ�
  begin
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckFH),
              SF('L_NextStatus', sFlag_TruckBFM),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_LadeMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    nInt := -1;
    nMVal := 0;
    
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nMVal := nBills[nIdx].FMData.FValue;
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��ë������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    {$IFDEF MasterSys}
    if not CallRemoteWorker(sCLI_BusinessCommand, nBills[nInt].FTruck, '',
      nTmp, @nOut, cBC_GetTruckCGHZValue) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    nVal := StrToFloat(nOut.FData);
    {$ELSE}
    nStr := 'Select T_CGHZValue From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nBills[nInt].FTruck]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount>0 then
         nVal := FieldByName('T_CGHZValue').AsFloat
    else nVal := 0;
    {$ENDIF}

    {$IFDEF SHXZY}
    if FloatRelation(nVal, 0, rtGreater, cPrecision) and
       FloatRelation(nVal, nMVal, rtLess, cPrecision) then
    begin
      nData := '����[ %s ]�ѳ���[ %s ]�֣���ж��!';
      nData := Format(nData, [nBills[nInt].FTruck,
                FloatToStr(Float2Float(nMVal-nVal, cPrecision, True))]);
      Exit;
    end;
    {$ENDIF}
    //��������ж��

    nVal := nMVal - nBills[nInt].FPData.FValue;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    if FType = sFlag_San then
    begin
      if nVal < 0 then FKZValue := FValue else
      if nVal < FValue then FKZValue := FValue - nVal
      else FKZValue := 0;

      nVal   := nVal - FValue;
      FValue := FValue - FKZValue;
    end;

    if (nBills[0].FType = sFlag_San) and
       (FloatRelation(nVal, 0, rtGreater, cPrecision)) then
    begin
      nData := '����[ %s ]�ѳ���������[ %s ]�֣���ж��!';
      nData := Format(nData, [nBills[nInt].FTruck,
                FloatToStr(nVal)]);
      Exit;
    end;
	
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    if (FType = sFlag_San) and (FKZValue > 0) then //ɢװ��
    begin
      m := -Float2Float(FKZValue * FPrice, cPrecision, False);

      if (FZKType=sFlag_BillSZ) or (FZKType=sFlag_BillMY) then
      begin
        nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(m), FCusID, FPayType]);
        FListA.Add(nSQL); //����ֽ������
      end else

      if FZKType=sFlag_BillFX then
      begin
        nSQL := 'Update %s Set I_FreezeMoney=I_FreezeMoney+(%s) ' +
                'Where I_ID=''%s'' And I_Enabled=''%s''';
        nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(m), FZhiKa, sFlag_Yes]);
        FListA.Add(nSQL); //����ֽ������
      end else

      if FZKType=sFlag_BillFL then
      begin
        nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) ' +
                'Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CompensateAccount, FloatToStr(m), FCusID]);
        FListA.Add(nSQL); //����ֽ������
      end;

      nSQL := 'Update %s Set E_Freeze=E_Freeze+(%s) ' +
              'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
              ' And Year(R_Date)>=Year(GetDate()))';
      nSQL := Format(nSQL, [sTable_StockRecordExt, FloatToStr(-FKZValue),
              sTable_StockRecord, FSeal]);

      if FCusType = sFlag_CusZY then
        FListA.Add(nSQL);
      //���ζ���������

      nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL); //���������
    end;

    nVal := 0;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nIdx < High(nBills) then
      begin
        FMData.FValue := FPData.FValue + FValue;
        nVal := nVal + FValue;
        //�ۼƾ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);
      end else
      begin
        FMData.FValue := nMVal - nVal;
        //�ۼ����ۼƵľ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);
      end;
    end;

    FListB.Clear;
    if nBills[nInt].FPModel <> sFlag_PoundCC then //����ģʽ,ë�ز���Ч
    begin
      nSQL := 'Select L_ID From %s Where L_Card=''%s'' And L_MValue Is Null';
      nSQL := Format(nSQL, [sTable_Bill, nBills[nInt].FCard]);
      //δ��ë�ؼ�¼

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          FListB.Add(Fields[0].AsString);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nBills[nInt].FPModel = sFlag_PoundCC then Continue;
      //����ģʽ,������״̬

      i := FListB.IndexOf(FID);
      if i >= 0 then
        FListB.Delete(i);
      //�ų����γ���

      nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal),
              SF('L_Status', sFlag_TruckBFM),
              SF('L_NextStatus', sFlag_TruckOut),
              SF('L_MValue', FMData.FValue , sfVal),
              SF('L_MDate', sField_SQLServer_Now, sfVal),
              SF('L_MMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);
    end;

    if FListB.Count > 0 then
    begin
      nTmp := AdjustListStrFormat2(FListB, '''', True, ',', False);
      //δ���ؽ������б�

      nStr := Format('L_ID In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('L_PValue', nMVal, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�ص������¼��Ƥ��,���ڱ��ε�ë��

      nStr := Format('P_Bill In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('P_PValue', nMVal, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_PStation', nBills[nInt].FMData.FStation)
              ], sTable_PoundLog, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�صĹ�����¼��Ƥ��,���ڱ��ε�ë��
    end;

    {$IFDEF SHXZY}
    with nBills[nInt] do
    if (FZKType = sFlag_BillMY) and (FType = sFlag_San) then
    begin
      nStr := CombineBillItmes(nBills);
      if not TWorkerBusinessCommander.CallMe(cBC_SaveMYBills, nStr,
        sFlag_BillEdit, @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
    end;
    {$ENDIF}

    nSQL := 'Select P_ID From %s Where P_Bill=''%s'' And P_MValue Is Null';
    nSQL := Format(nSQL, [sTable_PoundLog, nBills[nInt].FID]);
    //δ��ë�ؼ�¼

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      FOut.FData := Fields[0].AsString;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    FListB.Clear;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FListB.Add(FID);
      //�������б�
      
      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckOut),
              SF('L_NextStatus', ''),
              SF('L_Card', ''),
              SF('L_OutFact', sField_SQLServer_Now, sfVal),
              SF('L_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL); //���½�����

      nVal := Float2Float(FPrice * FValue, cPrecision, True);
      //������
      if (FZKType=sFlag_BillSZ) or (FZKType=sFlag_BillMY) then
      begin
        nSQL := 'Update %s Set A_OutMoney=A_OutMoney+(%s),' +
                'A_FreezeMoney=A_FreezeMoney-(%s) ' +
                'Where A_CID=''%s'' And A_Type=''%s''';
        nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal), FloatToStr(nVal), FCusID, FPayType]);
        FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
      end else

      if FZKType=sFlag_BillFX then
      begin
        nSQL := 'Update %s Set I_OutMoney=I_OutMoney+(%s),' +
                'I_FreezeMoney=I_FreezeMoney-(%s) ' +
                'Where I_ID=''%s'' And I_Enabled=''%s''';
        nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(nVal), FloatToStr(nVal), FZhiKa, sFlag_Yes]);
        FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
      end else

      if FZKType=sFlag_BillFL then
      begin
        nSQL := 'Update %s Set A_OutMoney=A_OutMoney+(%s),' +
                'A_FreezeMoney=A_FreezeMoney-(%s) ' +
                'Where A_CID=''%s''';
        nSQL := Format(nSQL, [sTable_CompensateAccount, FloatToStr(nVal), FloatToStr(nVal), FCusID]);
        FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
      end;

      nSQL := 'Update %s Set E_Freeze=E_Freeze-(%s), ' +
              'E_Sent=E_Sent+(%s) ' +
              'Where E_ID=(Select R_ExtID From %s Where R_SerialNO=''%s'' ' +
              ' And Year(R_Date)>=Year(GetDate()))';
      nSQL := Format(nSQL, [sTable_StockRecordExt, FloatToStr(FValue),
              FloatToStr(FValue),sTable_StockRecord, FSeal]);
      if FCusType = sFlag_CusZY then
        FListA.Add(nSQL);
    end;

    {$IFDEF SHXZY}
    nStr := CombineBillItmes(nBills);
    if nBills[0].FZKType = sFlag_BillMY then
    if not TWorkerBusinessCommander.CallMe(cBC_SaveMYBills, nStr,
      sFlag_BillDone, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    nStr := CombinStr(FListB, ',', True);
    if not TWorkerBusinessCommander.CallMe(cBC_StatisticsTrucks, nStr,
      sFlag_Sale, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
    {$ENDIF}

    nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_Card, sFlag_CardIdle, nBills[0].FCard]);
    FListA.Add(nSQL); //���´ſ�״̬

    nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
    //�������б�

    nSQL := 'Select T_Line,Z_Name as T_Name,T_Bill,T_PeerWeight,T_Total,' +
            'T_Normal,T_BuCha,T_HKBills From %s ' +
            ' Left Join %s On Z_ID = T_Line ' +
            'Where T_Bill In (%s)';
    nSQL := Format(nSQL, [sTable_ZTTrucks, sTable_ZTLines, nStr]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      SetLength(FBillLines, RecordCount);
      //init

      if RecordCount > 0 then
      begin
        nIdx := 0;
        First;

        while not Eof do
        begin
          with FBillLines[nIdx] do
          begin
            FBill    := FieldByName('T_Bill').AsString;
            FLine    := FieldByName('T_Line').AsString;
            FName    := FieldByName('T_Name').AsString;
            FPerW    := FieldByName('T_PeerWeight').AsInteger;
            FTotal   := FieldByName('T_Total').AsInteger;
            FNormal  := FieldByName('T_Normal').AsInteger;
            FBuCha   := FieldByName('T_BuCha').AsInteger;
            FHKBills := FieldByName('T_HKBills').AsString;
          end;

          Inc(nIdx);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if (Pos(FID, FBillLines[i].FHKBills) > 0) and
          (FID <> FBillLines[i].FBill) then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�,��������

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        if FPerW < 1 then Continue;
        //������Ч

        i := Trunc(FValue * 1000 / FPerW);
        //����

        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', i, sfVal),
                SF('L_DaiNormal', i, sfVal),
                SF('L_DaiBuCha', 0, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ

        FTotal := FTotal - i;
        FNormal := FNormal - i;
        //�ۼ��Ͽ�������װ����
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if FID = FBillLines[i].FBill then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�����

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', FTotal, sfVal),
                SF('L_DaiNormal', FNormal, sfVal),
                SF('L_DaiBuCha', FBuCha, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ
      end;
    end;

    nSQL := 'Delete From %s Where T_Bill In (%s)';
    nSQL := Format(nSQL, [sTable_ZTTrucks, nStr]);
    FListA.Add(nSQL); //����װ������
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    if Assigned(gHardShareData) then
      gHardShareData('TruckOut:' + nBills[0].FCard);
    //���������Զ�����
  end;

  {$IFDEF MasterSys}
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    nSQL := 'Select L_SrcID,L_LadeLine,L_LineName,L_DaiTotal,L_DaiNormal,L_DaiBuCha ' +
            'From %s Where L_ID In (%s)';
    nSQL := Format(nSQL, [sTable_Bill, nStr]);

    FListA.Clear;
    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then Exit;

      First;

      while not Eof do
      try
        FListB.Clear;
        FListB.Values['ID'] := FieldByName('L_SrcID').AsString;
        FListB.Values['LadeLine'] := FieldByName('L_LadeLine').AsString;
        FListB.Values['LineName'] := FieldByName('L_LineName').AsString;
        FListB.Values['DaiTotal'] := IntToStr(FieldByName('L_DaiTotal').AsInteger);
        FListB.Values['DaiBuCha'] := IntToStr(FieldByName('L_DaiBuCha').AsInteger);
        FListB.Values['DaiNormal'] := IntToStr(FieldByName('L_DaiNormal').AsInteger);

        FListA.Add(PackerEncodeStr(FListB.Text));
      finally
        Next;
      end;
    end;

    if FListA.Count > 0 then
      CallRemoteWorker(sCLI_BusinessSaleBill, PackerEncodeStr(FListA.Text), '',
        nTmp, @nOut, cBC_ModifyBillLine);

    nSQL := 'Delete From %s Where L_ID In (%s)';
    nSQL := Format(nSQL, [sTable_Bill, nStr]);
    gDBConnManager.WorkerExec(FDBConn, nSQL);
  end;
  {$ENDIF}
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessBills, sPlug_ModuleBus);
end.
