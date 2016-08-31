{*******************************************************************************
  ����: fendou116688@163.com 2016/3/25
  ����: �����˻�����ҵ�����
*******************************************************************************}
unit UWorkerBusinessRefund;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst, UWorkerBusinessCommander, DateUtils, UWorkerSelfRemote;

type
  TWorkerBusinessRefund = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function SaveRefund(var nData: string): Boolean;
    //���������˻���
    function SaveRefundCard(var nData: string): Boolean;
    //���������˻��ſ�
    function ChangeRefundTruck(var nData: string): Boolean;
    //�޸������˻�����
    function DeleteRefund(var nData: string): Boolean;
    //ɾ�������˻���
    function GetPostItems(var nData: string): Boolean;
    //��ȡ��λ����
    function SavePostItems(var nData: string): Boolean;
    //�����λ����
    function VerifyBeforSave(var nData: string): Boolean;
    function GetCompanyID: string;
    function GetMasterCompanyID: string;
    //MIT����
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TWorkerBusinessRefund.CallMe(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessRefund.FunctionName: string;
begin
  Result := sBus_BusinessRefund;
end;

constructor TWorkerBusinessRefund.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessRefund.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessRefund.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessRefund.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2015-8-5
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessRefund.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_SaveRefund          : Result := SaveRefund(nData);
   cBC_SaveRefundCard      : Result := SaveRefundCard(nData);
   cBC_ModifyRefundTruck   : Result := ChangeRefundTruck(nData);
   cBC_DeleteRefund        : Result := DeleteRefund(nData);
   cBC_GetPostBills        : Result := GetPostItems(nData);
   cBC_SavePostBills       : Result := SavePostItems(nData);
   else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//Date: 2016/8/23
//Parm:
//Desc: ��ȡϵͳID
function TWorkerBusinessRefund.GetCompanyID: string;
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
function TWorkerBusinessRefund.GetMasterCompanyID: string;
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

function TWorkerBusinessRefund.VerifyBeforSave(var nData: string): Boolean;
var nInt: Integer;
    nStr: string;
    nOutFact, nToday: TDateTime;
begin
  Result := False;

  nStr := 'Select F_ID From %s Where F_Truck=''%s'' And F_OutFact Is Null';
  nStr := Format(nStr, [sTable_Refund, FListA.Values['Truck']]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nData := '����[ %s ]��δ��ɵ������˻�����[ %s ],���ȴ���.';
    nData := Format(nData, [FListA.Values['Truck'], Fields[0].AsString]);
    Exit;
  end;

  nStr := 'Select F_ID From %s Where F_LID=''%s''';
  nStr := Format(nStr, [sTable_Refund, FListA.Values['BillNO']]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nData := '�����[ %s ]����ɵ������˻�����[ %s ],�������ظ��˻�.';
    nData := Format(nData, [FListA.Values['BillNO'], Fields[0].AsString]);
    Exit;
  end;

  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FListA.Values['BillNO']]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr),FListA do
  begin
    Values['BillNO']   := FieldByName('L_ID').AsString;
    Values['BOutFact'] := FieldByName('L_OutFact').AsString;

    Values['CusID']    := FieldByName('L_CusID').AsString;
    Values['CusName']  := FieldByName('L_CusName').AsString;
    Values['CusType']  := FieldByName('L_CusType').AsString;
    Values['CusPY']    := FieldByName('L_CusPY').AsString;

    Values['SaleID']   := FieldByName('L_SaleID').AsString;
    Values['SaleMan']  := FieldByName('L_SaleMan').AsString;
    
    Values['Type']     := FieldByName('L_Type').AsString;
    Values['StockNo']  := FieldByName('L_StockNo').AsString;
    Values['StockName']:= FieldByName('L_StockName').AsString;

    Values['Price']    := FieldByName('L_Price').AsString;
    Values['LimValue'] := FieldByName('L_Value').AsString;

    Values['Paytype']  := FieldByName('L_Paytype').AsString;
    Values['Payment']  := FieldByName('L_Payment').AsString;

    Values['ZKType']   := FieldByName('L_ZKType').AsString;
    Values['ZhiKa']    := FieldByName('L_ZhiKa').AsString;
  end;

  if Length(FListA.Values['BOutFact']) < 1 then
  begin
    nData := '�����[ %s ]����δ����, ��ֹ�˻�.';
    nData := Format(nData, [FListA.Values['BillNO']]);
    Exit;
  end;

  if FloatRelation(StrToFloat(FListA.Values['Value']),
    StrToFloat(FListA.Values['LimValue']), rtGreater) then
  begin
    nData := '��ֹ�����[ %s ]�˻�������ԭ�����[ %s ]��.';
    nData := Format(nData, [FListA.Values['BillNO'], FListA.Values['LimValue']]);
    Exit;
  end;    

  nToday   := Today;
  nOutFact := Str2DateTime(FListA.Values['BOutFact']);

  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_OutOfRefund]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
       nInt := Fields[0].AsInteger
  else nInt := 30;
  //Ĭ��30��

  if DaysBetween(nOutFact, nToday) > nInt then
  begin
    nData := '�����[ %s ]����ʱ���ѳ����˻�ʱ������[ %d ]��,�������˻�.';
    nData := Format(nData, [FListA.Values['BillNO'], nInt]);
    Exit;
  end;

  Result := True;
  //verify done
end;

//Date: 2016-02-27
//Desc: ���������˻���
function TWorkerBusinessRefund.SaveRefund(var nData: string): Boolean;
var nStr: string;
    nVal: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);
  {$IFNDEF MasterSys}
  if not VerifyBeforSave(nData) then Exit;
  {$ENDIF}

  with FListC do
  begin
    Clear;
    Values['Group'] :=sFlag_BusGroup;
    Values['Object'] := sFlag_RefundNo;
  end;

  if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
        FListC.Text, sFlag_Yes, @nOut) then  //to get serial no
  begin
    nData := nOut.FData;
    Exit;
  end;

  FOut.FData := nOut.FData;
  //id

  FDBConn.FConn.BeginTrans;
  with FListA do
  try
    nStr := MakeSQLByStr([SF('F_ID', nOut.FData),
            SF('F_LID', Values['BillNO']),
            SF('F_LOutFact', Values['BOutFact']),

            SF('F_ZhiKa', Values['ZhiKa']),
            SF('F_ZKType', Values['ZKType']),   
            SF('F_Paytype', Values['Paytype']),
            SF('F_Payment', Values['Payment']),

            SF('F_Truck', Values['Truck']),
            SF('F_CusID', Values['CusID']),
            SF('F_CusType', Values['CusType']),
            SF('F_CusName', Values['CusName']),
            SF('F_CusPY', Values['CusPY']),
            SF('F_SaleID', Values['SaleID']),
            SF('F_SaleMan', Values['SaleMan']),

            SF('F_Type', Values['Type']),
            SF('F_StockNo', Values['StockNo']),
            SF('F_StockName', Values['StockName']),
            SF('F_Value', StrToFloat(Values['Value']), sfVal),
            SF('F_Price', StrToFloat(Values['Price']), sfVal),
            SF('F_LimValue', StrToFloat(Values['LimValue']), sfVal),

            {$IFDEF MasterSys}
            SF('F_SrcCompany', Values['SrcCompany']),
            SF('F_SrcID', Values['SrcID']),
            {$ENDIF}

            SF('F_Status', sFlag_BillNew),
            SF('F_Man', FIn.FBase.FFrom.FUser),
            SF('F_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Refund, '', True);
    //xxxxx
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if Values['Type'] = sFlag_Dai then
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundIfDai]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
       if (RecordCount > 0) and (Fields[0].AsString = sFlag_No) then
       begin
         nStr := MakeSQLByStr([SF('F_Status', sFlag_TruckOut),
                  SF('F_InTime', sField_SQLServer_Now, sfVal),
                  SF('F_PValue', 1, sfVal),
                  SF('F_PDate', sField_SQLServer_Now, sfVal),
                  SF('F_PMan', FIn.FBase.FFrom.FUser),
                  SF('F_MValue', StrToFloat(Values['Value']) + 1, sfVal),
                  SF('F_MDate', sField_SQLServer_Now, sfVal),
                  SF('F_MMan', FIn.FBase.FFrom.FUser),
                  SF('F_LadeTime', sField_SQLServer_Now, sfVal),
                  SF('F_LadeMan', FIn.FBase.FFrom.FUser),
                  SF('F_OutFact', sField_SQLServer_Now, sfVal),
                  SF('F_OutMan', FIn.FBase.FFrom.FUser),
                  SF('F_Card', '')
                  ], sTable_Refund, SF('F_ID', nOut.FData), False);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nVal := StrToFloat(Values['Value']) * StrToFloat(Values['Price']);
          nVal := Float2Float(nVal, cPrecision, False);
          //�˻�ʱ

          if (Values['ZKType'] = sFlag_BillSZ) or
             (Values['ZKType'] = sFlag_BillMY) then
          begin
            nStr := 'Update %s Set A_RefundMoney=A_RefundMoney+%s ' +
                    'Where A_CID=''%s'' And A_Type=''%s''';
            nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nVal),
                    Values['CusID'], FListA.Values['Paytype']]);
            gDBConnManager.WorkerExec(FDBConn, nStr);
          end else

          if FListA.Values['ZKType'] = sFlag_BillFX then
          begin
            nStr := 'Update %s Set I_RefundMoney=I_RefundMoney+%s Where I_ID=''%s'' ' +
                    'And I_Enabled=''%s''';
            nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nVal),
                    Values['ZhiKa'], sFlag_Yes]);

            if gDBConnManager.WorkerExec(FDBConn, nStr) < 1 then
            begin
              nStr := 'Update %s Set I_RefundMoney=I_RefundMoney+%s, ' +
                      'I_BackMoney=I_BackMoney+%s ' +
                      'Where I_ID=''%s'' And I_Enabled<>''%s''';
              nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nVal),
                      FloatToStr(nVal), Values['ZhiKa'], sFlag_Yes]);
              gDBConnManager.WorkerExec(FDBConn, nStr);

              nStr := 'Update %s Set A_RefundMoney=A_RefundMoney+%s ' +
                      'Where A_CID=''%s'' And A_Type=''%s''';
              nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nVal),
                      Values['CusID'], FListA.Values['Paytype']]);
              gDBConnManager.WorkerExec(FDBConn, nStr);
              //����������ͣ�ã����ؿͻ��˻�
            end;
          end else

          if FListA.Values['ZKType'] = sFlag_BillFL then
          begin
            nStr := 'Update %s Set A_RefundMoney=A_RefundMoney+%s Where A_CID=''%s''';
            nStr := Format(nStr, [sTable_CompensateAccount, FloatToStr(nVal),
                    Values['CusID']]);
            gDBConnManager.WorkerExec(FDBConn, nStr);
          end;
       end;
    end else
    //��װ������

    begin
      {$IFNDEF MasterSys}
      FListA.Values['SrcID'] := nOut.FData;
      FListA.Values['SrcCompany'] := GetCompanyID;
      if not CallRemoteWorker(sCLI_BusinessRefund, PackerEncodeStr(FListA.Text), '',
        GetMasterCompanyID, @nOut, cBC_SaveRefund) then
        raise Exception.Create(nOut.FData);
      {$ENDIF}
    end;  

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end; 
end;

//Date: 2016-02-27
//Parm: ����[FIn.FData];�ſ�[FIn.FExtParam]
//Desc: ���������˻����ſ�
function TWorkerBusinessRefund.SaveRefundCard(var nData: string): Boolean;
var nStr,nTruck,nInData, nSrcCompany: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := False;

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //�������
  
  {$IFDEF MasterSys}
  nStr := 'Select F_ID From %s Where F_SrcID=''%s'' And F_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Refund, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('�˹���[ %s ]�Ѷ�ʧ.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessRefund, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_SaveRefund, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  nStr := 'Select F_Card,F_Truck From %s Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '�����˻�����[ %s ]�Ѷ�ʧ.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    FListA.Clear;
    nTruck := Fields[1].AsString;
    
    if Fields[0].AsString <> '' then
    begin
      nStr := 'Update %s set C_TruckNo=Null,C_Status=''%s'' Where C_Card=''%s''';
      nStr := Format(nStr, [sTable_Card, sFlag_CardIdle, Fields[0].AsString]);
      FListA.Add(nStr); //�ſ�״̬
    end;
  end;

  nStr := 'Update %s Set F_Card=''%s'' Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, FIn.FExtParam, nInData]);
  FListA.Add(nStr);

  nStr := 'Select Count(*) From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
            SF('C_Status', sFlag_CardUsed),
            SF('C_Used', sFlag_Refund),
            SF('C_TruckNo', nTruck),
            SF('C_Freeze', sFlag_No),
            SF('C_Man', FIn.FBase.FFrom.FUser),
            SF('C_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Card, '', True);
    FListA.Add(nStr);
  end else
  begin
    nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
    nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
            SF('C_Used', sFlag_Refund),
            SF('C_TruckNo', nTruck),
            SF('C_Freeze', sFlag_No),
            SF('C_Man', FIn.FBase.FFrom.FUser),
            SF('C_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Card, nStr, False);
    FListA.Add(nStr);
  end;

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=FListA.Count - 1 downto 0 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      FDBConn.FConn.RollbackTrans;
      nData := E.Message;
    end;
  end;
end;

//Date: 2016-02-27
//Parm: �����˻���[FIn.FData];���ƺ�[FIn.FExtParm]
//Desc: �޸ĵ��ݵĳ���
function TWorkerBusinessRefund.ChangeRefundTruck(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := False;
  nStr := 'Select F_PDate,F_MDate,F_Card From %s Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '�����˻�����[ %s ]�Ѷ�ʧ.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    FListA.Clear;
    if (Fields[0].AsFloat > 0) or (Fields[1].AsFloat > 0) then
    begin
      nStr := 'Update %s set P_Truck=''%s'' Where P_Bill=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, FIn.FExtParam, FIn.FData]);
      FListA.Add(nStr); //���ؼ�¼
    end;

    if Fields[2].AsString <> '' then
    begin
      nStr := 'Update %s set C_TruckNo=''%s'' Where C_Card=''%s''';
      nStr := Format(nStr, [sTable_Card, FIn.FExtParam, Fields[2].AsString]);
      FListA.Add(nStr); //�ſ���¼
    end;
  end;

  nStr := 'Update %s set F_Truck=''%s'' Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, FIn.FExtParam, FIn.FData]);
  FListA.Add(nStr);

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=FListA.Count - 1 downto 0 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      FDBConn.FConn.RollbackTrans;
      nData := E.Message;
    end;
  end;
end;

//Date: 2016-02-27
//Parm: �����˻���[FIn.FData]
//Desc: ɾ�������˻���
function TWorkerBusinessRefund.DeleteRefund(var nData: string): Boolean;
var nStr,nP,nInData,nSrcCompany: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := False;

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //init

  {$IFDEF MasterSys}
  nStr := 'Select F_ID From %s ' +
          'Where F_SrcID=''%s'' And F_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Refund, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('�˹���[ %s ]�Ѷ�ʧ.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessRefund, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_DeleteRefund, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  nStr := 'Select F_Card From %s Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '�����˻�����[ %s ]�Ѷ�ʧ.';
      nData := Format(nData, [nInData]);
      Exit;
    end;

    FListA.Clear;
    if Fields[0].AsString <> '' then
    begin
      nStr := 'Update %s set C_TruckNo=Null,C_Status=''%s'' Where C_Card=''%s''';
      nStr := Format(nStr, [sTable_Card, sFlag_CardIdle, Fields[0].AsString]);
      FListA.Add(nStr); //�ſ�״̬
    end; 
  end;

  //--------------------------------------------------------------------------
  {$IFNDEF MasterSys}
  nStr := Format('Select * From %s Where 1<>1', [sTable_Refund]);
  //only for fields
  nP := '';

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    for nIdx:=0 to FieldCount - 1 do
     if (Fields[nIdx].DataType <> ftAutoInc) and
        (Pos('F_Del', Fields[nIdx].FieldName) < 1) then
      nP := nP + Fields[nIdx].FieldName + ',';
    //�����ֶ�,������ɾ��

    System.Delete(nP, Length(nP), 1);
  end;

  nStr := 'Insert Into $RB($FL,F_DelMan,F_DelDate) ' +
          'Select $FL,''$User'',$Now From $RF Where F_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$RB', sTable_RefundBak),
          MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
          MI('$Now', sField_SQLServer_Now),
          MI('$RF', sTable_Refund), MI('$ID', nInData)]);
  FListA.Add(nStr);
  {$ENDIF}

  nStr := 'Delete From %s Where F_ID=''%s''';
  nStr := Format(nStr, [sTable_Refund, nInData]);
  FListA.Add(nStr);

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      FDBConn.FConn.RollbackTrans;
      nData := E.Message;
    end;
  end;
end;

//Date: 2016-02-28
//Parm: �ſ���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ��ȡ�ض���λ����Ҫ�Ľ������б�
function TWorkerBusinessRefund.GetPostItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nBills: TLadingBillItems;
begin
  Result := False;
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
      nData := '�ſ�[ %s ]��ǰ״̬Ϊ[ %s ],�޷�ʹ��.';
      nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
      Exit;
    end;

    if Fields[1].AsString = sFlag_Yes then
    begin
      nData := '�ſ�[ %s ]�ѱ�����,�޷�ʹ��.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  nStr := 'Select b.*,p.P_ID,p.P_PStation ' +
          'From $Bill b ' +
          '  Left Join $Pound p on p.P_Bill=b.F_ID ' +
          'Where b.F_Card=''$CD''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$Bill', sTable_Refund),
          MI('$Pound', sTable_PoundLog),MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '�����˻��ſ�[ %s ]û�й�����Ч����.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    SetLength(nBills, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with nBills[nIdx] do
    begin
      FID         := FieldByName('F_ID').AsString;
      FCusID      := FieldByName('F_CusID').AsString;
      FCusName    := FieldByName('F_CusName').AsString;
      FTruck      := FieldByName('F_Truck').AsString;

      FValue      := FieldByName('F_Value').AsFloat;
      FPrice      := FieldByName('F_Price').AsFloat;
      FType       := FieldByName('F_Type').AsString;
      FStockNo    := FieldByName('F_StockNo').AsString;
      FStockName  := FieldByName('F_StockName').AsString;

      FCard       := FieldByName('F_Card').AsString;
      FStatus     := FieldByName('F_Status').AsString;
      FNextStatus := FieldByName('F_NextStatus').AsString;

      FZKType     := FieldByName('F_ZKType').AsString;
      FZhiKa      := FieldByName('F_ZhiKa').AsString;
      FPoundID    := FieldByName('P_ID').AsString;
      FPayType    := FieldByName('F_PayType').AsString;

      if FStatus = sFlag_BillNew then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      with FPData do
      begin
        FDate   := FieldByName('F_PDate').AsDateTime;
        FValue  := FieldByName('F_PValue').AsFloat;
        FStation:= FieldByName('P_PStation').AsString;
        FOperator := FieldByName('F_PMan').AsString;
      end;

      FSelected := True; 
      Inc(nIdx);
      Next;
    end;
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2016-02-28
//Parm: �����˻���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ����ָ����λ�ύ�Ľ������б�
function TWorkerBusinessRefund.SavePostItems(var nData: string): Boolean;
var nInt,nIdx: Integer;
    nSQL,nTmp: string;
    nVal: Double;
    nBills: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nBills);
  nInt := Length(nBills);
  //��������

  if nInt < 1 then
  begin
    nData := '��λ[ %s ]�ύ�ĵ���Ϊ��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  if nInt > 1 then
  begin
    nData := '��λ[ %s ]�ύ�������˻��ϵ�,��ҵ��ϵͳ��ʱ��֧��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  {$IFDEF MasterSys}
  nTmp := '';
  for nIdx := Low(nBills) to High(nBills) do
  begin
    nSQL := 'Select D_SrcID, D_SrcCompany From %s Where D_ID=''%s''';
    nSQL := Format(nSQL, [sTable_OrderDtl, nBills[nIdx].FID]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '��λ[ %s ]�ύ�ĵ��ݱ��[ %s ]������.';
        nData := Format(nData, [PostTypeToStr(FIn.FExtParam), nBills[nIdx].FID]);
        Exit;
      end;

      if (nTmp <> '') and (nTmp <> Fields[1].AsString) then
      begin
        nData := '��ͬ�������ܺϵ�.';
        Exit;
      end;

      nTmp := Fields[1].AsString;
      nBills[nIdx].FID := Fields[0].AsString;
    end;  
  end;

  nSQL := CombineBillItmes(nBills);
  if not CallRemoteWorker(sCLI_BusinessRefund, nSQL, FIn.FExtParam, nTmp,
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
  with nBills[0] do
  begin
    FStatus := sFlag_TruckIn;
    FNextStatus := sFlag_TruckBFP;

    nSQL := MakeSQLByStr([
            SF('F_Status', sFlag_TruckIn),
            SF('F_NextStatus', sFlag_TruckBFP),
            SF('F_InTime', sField_SQLServer_Now, sfVal),
            SF('F_InMan', FIn.FBase.FFrom.FUser)
            ], sTable_Refund, SF('F_ID', FID), False);
    FListA.Add(nSQL);
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //����Ƥ��
  begin
    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := nOut.FData;
    //���ذ񵥺�,�������հ�
    with nBills[0] do
    begin
      FStatus := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;

      nSQL := MakeSQLByStr([
            SF('P_ID', nOut.FData),
            SF('P_Type', sFlag_Refund),
            SF('P_Bill', FID),
            SF('P_Truck', FTruck),
            SF('P_CusID', FCusID),
            SF('P_CusName', FCusName),
            SF('P_MID', FStockNo),
            SF('P_MName', FStockName),
            SF('P_MType', FType),
            SF('P_LimValue', FValue),
            SF('P_PValue', FPData.FValue, sfVal),
            SF('P_PDate', sField_SQLServer_Now, sfVal),
            SF('P_PMan', FIn.FBase.FFrom.FUser),
            SF('P_FactID', FFactory),
            SF('P_PStation', FPData.FStation),
            SF('P_Direction', '�˻�'),
            SF('P_PModel', FPModel),
            SF('P_Status', sFlag_TruckBFP),
            SF('P_Valid', sFlag_Yes),
            SF('P_PrintNum', 1, sfVal)
            ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('F_Status', FStatus),
              SF('F_NextStatus', FNextStatus),
              SF('F_PValue', FPData.FValue, sfVal),
              SF('F_PDate', sField_SQLServer_Now, sfVal),
              SF('F_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Refund, SF('F_ID', FID), False);
      FListA.Add(nSQL);
    end; 
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    with nBills[0] do
    begin
      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);
        //����ʱ,����Ƥ�ش�,����Ƥë������

        nSQL := MakeSQLByStr([
                SF('F_Status', sFlag_TruckBFM),
                SF('F_NextStatus', sFlag_TruckOut),
                SF('F_PValue', FPData.FValue, sfVal),
                SF('F_PDate', sField_SQLServer_Now, sfVal),
                SF('F_PMan', FIn.FBase.FFrom.FUser),
                SF('F_MValue', FMData.FValue, sfVal),
                SF('F_MDate', DateTime2Str(FMData.FDate)),
                SF('F_MMan', FMData.FOperator)
                ], sTable_Refund, SF('F_ID', FID), False);
        FListA.Add(nSQL);

      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('F_Status', sFlag_TruckBFM),
                SF('F_NextStatus', sFlag_TruckOut),
                SF('F_MValue', FMData.FValue, sfVal),
                SF('F_MDate', sField_SQLServer_Now, sfVal),
                SF('F_MMan', FIn.FBase.FFrom.FUser)
                ], sTable_Refund, SF('F_ID', FID), False);
        FListA.Add(nSQL);
      end;

      if FType = sFlag_San then
      begin
        nVal := Float2Float(FMData.FValue-FPData.FValue, cPrecision, False);
        nSQL := 'Select F_LimValue, F_LID From %s Where F_ID=''%s''';
        nSQL := Format(nSQL, [sTable_Refund, FID]);

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '�˹�����[ %s ]�Ѷ�ʧ.';
            nData := Format(nData, [FID]);
            Exit;
          end;

          if FloatRelation(nVal, Fields[0].AsFloat, rtGreater) then
          begin
            nData := '�˹����ش���ԭ�������[ %s ]ʵ�������[ %.2f ]�����֤.';
            nData := Format(nData, [Fields[1].AsString, Fields[0].AsString]);
            Exit;
          end;  
        end;

        nSQL := MakeSQLByStr([
                SF('F_Value', nVal, sfVal)
                ], sTable_Refund, SF('F_ID', FID), False);
        FListA.Add(nSQL);
      end;   
    end;

    nSQL := 'Select P_ID From %s Where P_Bill=''%s'' And P_MValue Is Null';
    nSQL := Format(nSQL, [sTable_PoundLog, nBills[0].FID]);
    //δ��ë�ؼ�¼

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      FOut.FData := Fields[0].AsString;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  with nBills[0] do
  begin
    nSQL := MakeSQLByStr([SF('F_Status', sFlag_TruckOut),
            SF('F_NextStatus', ''),
            SF('F_Card', ''),
            SF('F_OutFact', sField_SQLServer_Now, sfVal),
            SF('F_OutMan', FIn.FBase.FFrom.FUser)
            ], sTable_Refund, SF('F_ID', FID), False);
    FListA.Add(nSQL);


    nSQL := 'Update %s Set C_Status=''%s'',C_TruckNo=Null Where C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_Card, sFlag_CardIdle, nBills[0].FCard]);
    FListA.Add(nSQL); //�ſ�

    nVal := Float2Float(FPrice * FValue, cPrecision, False);
    //�˻����
    if (FZKType=sFlag_BillSZ) or (FZKType=sFlag_BillMY) then
    begin
      nSQL := 'Update %s Set A_RefundMoney=A_RefundMoney+(%s) ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal), FCusID, FPayType]);
      FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
    end else

    if FZKType=sFlag_BillFX then
    begin
      nSQL := 'Update %s Set I_RefundMoney=I_RefundMoney+(%s) ' +
              'Where I_ID=''%s'' ';
      //        'Where I_ID=''%s'' And I_Enabled=''%s''';
      //nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(nVal), FZhiKa, sFlag_Yes]);
      nSQL := Format(nSQL, [sTable_FXZhiKa, FloatToStr(nVal), FZhiKa]);
      FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
    end else

    if FZKType=sFlag_BillFL then
    begin
      nSQL := 'Update %s Set A_RefundMoney=A_RefundMoney+(%s) ' +
              'Where A_CID=''%s''';
      nSQL := Format(nSQL, [sTable_CompensateAccount, FloatToStr(nVal), FCusID]);
      FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
    end;

    {$IFDEF MasterSys}
    nSQL := 'Delete From %s Where F_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Refund, nBills[0].FID]);
    FListA.Add(nSQL);
    {$ENDIF}
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
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessRefund, sPlug_ModuleBus);
end.
