{*******************************************************************************
  作者: dmzn@163.com 2013-12-04
  描述: 模块业务对象
*******************************************************************************}
unit UWorkerBusinessOrders;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst, UWorkerBusinessCommander, UWorkerSelfRemote;

type
  TWorkerBusinessOrders = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton

    function SaveOrderBase(var nData: string):Boolean;
    function DeleteOrderBase(var nData: string):Boolean;
    function SaveOrder(var nData: string):Boolean;
    function DeleteOrder(var nData: string): Boolean;
    function SaveOrderCard(var nData: string): Boolean;
    function LogoffOrderCard(var nData: string): Boolean;
    function ChangeOrderTruck(var nData: string): Boolean;
    //修改车牌号
    function GetGYOrderValue(var nData: string): Boolean;
    //获取供应可收货量
    function SaveOrderDtlAdd(var nData: string):Boolean;

    function GetCompanyID: string;
    function GetMasterCompanyID: string;
    //MIT互访
    function GetPostOrderItems(var nData: string): Boolean;
    //获取岗位采购单
    function SavePostOrderItems(var nData: string): Boolean;
    //保存岗位采购单
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

//------------------------------------------------------------------------------
class function TWorkerBusinessOrders.FunctionName: string;
begin
  Result := sBus_BusinessPurchaseOrder;
end;

constructor TWorkerBusinessOrders.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessOrders.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessOrders.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessOrders.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2015-8-5
//Parm: 输入数据
//Desc: 执行nData业务指令
function TWorkerBusinessOrders.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_SaveOrder            : Result := SaveOrder(nData);
   cBC_DeleteOrder          : Result := DeleteOrder(nData);
   cBC_SaveOrderBase        : Result := SaveOrderBase(nData);
   cBC_DeleteOrderBase      : Result := DeleteOrderBase(nData);
   cBC_SaveOrderCard        : Result := SaveOrderCard(nData);
   cBC_LogoffOrderCard      : Result := LogoffOrderCard(nData);
   cBC_ModifyBillTruck      : Result := ChangeOrderTruck(nData);
   cBC_SaveOrderDtlAdd      : Result := SaveOrderDtlAdd(nData);
   cBC_GetPostOrders        : Result := GetPostOrderItems(nData);
   cBC_SavePostOrders       : Result := SavePostOrderItems(nData);
   cBC_GetGYOrderValue      : Result := GetGYOrderValue(nData);
   else
    begin
      Result := False;
      nData := '无效的业务代码(Invalid Command).';
    end;
  end;
end;

//Date: 2016/8/23
//Parm:
//Desc: 获取系统ID
function TWorkerBusinessOrders.GetCompanyID: string;
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
//Desc: 获取系统ID
function TWorkerBusinessOrders.GetMasterCompanyID: string;
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

function TWorkerBusinessOrders.SaveOrderBase(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nOut: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  //unpack Order

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderBase;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('B_ID', nOut.FData),
            SF('B_BStatus', FListA.Values['IsValid']),

            SF('B_Project', FListA.Values['Project']),
            SF('B_Area', FListA.Values['Area']),
            SF('B_XuNi', FListA.Values['IsXuNi']),

            SF('B_Value', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_RestValue', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_LimValue', StrToFloat(FListA.Values['LimValue']),sfVal),
            SF('B_WarnValue', StrToFloat(FListA.Values['WarnValue']),sfVal),

            SF('B_SentValue', 0,sfVal),
            SF('B_FreezeValue', 0,sfVal),

            SF('B_ProID', FListA.Values['ProviderID']),
            SF('B_ProName', FListA.Values['ProviderName']),
            SF('B_ProType', FListA.Values['ProviderType']),
            SF('B_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('B_SaleID', FListA.Values['SaleID']),
            SF('B_SaleMan', FListA.Values['SaleMan']),
            SF('B_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('B_StockType', sFlag_San),
            SF('B_StockNo', FListA.Values['StockNO']),
            SF('B_StockName', FListA.Values['StockName']),

            SF('B_Man', FIn.FBase.FFrom.FUser),
            SF('B_Date', sField_SQLServer_Now, sfVal)
            ], sTable_OrderBase, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

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
end;
//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: 删除采购申请单
function TWorkerBusinessOrders.DeleteOrderBase(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
begin
  Result := False;
  //init

  nStr := 'Select Count(*) From %s Where O_BID=''%s''';
  nStr := Format(nStr, [sTable_Order, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '采购申请单[ %s ]已使用.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_OrderBase]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('B_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,B_DelMan,B_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where B_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBaseBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_OrderBase), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where B_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderBase, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/20
//Parm: 
//Desc: 获取供应可收货量
function TWorkerBusinessOrders.GetGYOrderValue(var nData: string): Boolean;
var nSQL: string;
    nVal, nSent, nLim, nWarn, nFreeze,nMax: Double;
begin
  Result := False;
  //init

  nSQL := 'Select B_Value,B_SentValue,B_RestValue, ' +
          'B_LimValue,B_WarnValue,B_FreezeValue ' +
          'From $OrderBase b1 inner join $Order o1 on b1.B_ID=o1.O_BID ' +
          'Where O_ID=''$ID''';
  nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
          MI('$Order', sTable_Order), MI('$ID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount<1 then
    begin
      nData := '采购申请单[%s]信息已丢失';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nVal    := FieldByName('B_Value').AsFloat;
    nSent   := FieldByName('B_SentValue').AsFloat;
    nLim    := FieldByName('B_LimValue').AsFloat;
    nWarn   := FieldByName('B_WarnValue').AsFloat;
    nFreeze := FieldByName('B_FreezeValue').AsFloat;

    nMax := nVal - nSent - nFreeze;
  end;  

  with FListB do
  begin
    Clear;

    if nVal>0 then
         Values['NOLimite'] := sFlag_No
    else Values['NOLimite'] := sFlag_Yes;

    Values['MaxValue']    := FloatToStr(nMax);
    Values['LimValue']    := FloatToStr(nLim);
    Values['WarnValue']   := FloatToStr(nWarn);
    Values['FreezeValue'] := FloatToStr(nFreeze);
  end;

  FOut.FData := PackerEncodeStr(FListB.Text);
  Result := True;
end;  


//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.SaveOrder(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nVal: Double;
    nOut: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  nVal := StrToFloat(FListA.Values['Value']);
  //unpack Order

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_Order;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('O_ID', nOut.FData),

            SF('O_CType', FListA.Values['CardType']),
            SF('O_Project', FListA.Values['Project']),
            SF('O_Area', FListA.Values['Area']),
            SF('O_XuNi', FListA.Values['XuNi']),

            SF('O_BID', FListA.Values['SQID']),
            SF('O_Value', nVal,sfVal),

            SF('O_ProID', FListA.Values['ProviderID']),
            SF('O_ProName', FListA.Values['ProviderName']),
            SF('O_ProType', FListA.Values['ProviderType']),
            SF('O_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('O_SaleID', FListA.Values['SaleID']),
            SF('O_SaleMan', FListA.Values['SaleMan']),
            SF('O_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('O_Type', sFlag_San),
            SF('O_StockNo', FListA.Values['StockNO']),
            SF('O_StockName', FListA.Values['StockName']),

            {$IFDEF MasterSys}
            SF('O_SrcCompany', FListA.Values['SrcCompany']),
            SF('O_SrcID', FListA.Values['SrcID']),
            {$ENDIF}

            SF('O_Truck', FListA.Values['Truck']),
            SF('O_Man', FIn.FBase.FFrom.FUser),
            SF('O_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Order, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if FListA.Values['CardType'] = sFlag_OrderCardL then
    begin
      nStr := 'Update %s Set B_FreezeValue=B_FreezeValue+%.2f ' +
              'Where B_ID = ''%s'' and B_Value>0';
      nStr := Format(nStr, [sTable_OrderBase, nVal,FListA.Values['SQID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    {$IFNDEF MasterSys}
    FListA.Values['SrcID'] := nOut.FData;
    FListA.Values['SrcCompany'] := GetCompanyID;
    if not CallRemoteWorker(sCLI_BusinessPurchaseOrder, PackerEncodeStr(FListA.Text), '',
      GetMasterCompanyID, @nOut, cBC_SaveOrder) then
      raise Exception.Create(nOut.FData);
    {$ENDIF}

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
end;

//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.DeleteOrder(var nData: string): Boolean;
var nStr,nP,nInData,nSrcCompany: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := False;
  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //init

  {$IFDEF MasterSys}
  nStr := 'Select O_ID From %s ' +
          'Where O_SrcID=''%s'' And O_SrcCompany=''%s''';
  nStr := Format(nStr, [sTable_Order, nInData, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('采购单[ %s ]已丢失.', [nInData]);
      Exit;
    end;

    nInData := Fields[0].AsString;
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessPurchaseOrder, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_DeleteOrder, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  nStr := 'Select Count(*) From %s Where D_OID=''%s''';
  nStr := Format(nStr, [sTable_OrderDtl, nInData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '采购单[ %s ]已使用.';
      nData := Format(nData, [nInData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    {$IFNDEF MasterSys}
    nStr := Format('Select * From %s Where 1<>1', [sTable_Order]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('O_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,O_DelMan,O_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where O_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_Order), MI('$ID', nInData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    {$ENDIF}

    nStr := 'Delete From %s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, nInData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: 采购订单[FIn.FData];磁卡号[FIn.FExtParam]
//Desc: 为采购单绑定磁卡
function TWorkerBusinessOrders.SaveOrderCard(var nData: string): Boolean;
var nStr,nSQL,nTruck,nInData,nSrcCompany: string;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  Result := False;
  nTruck := '';
  //init

  nInData := FIn.FData;
  nSrcCompany := FIn.FBase.FKey;
  //工厂编号
  
  {$IFDEF MasterSys}
  nStr := AdjustListStrFormat(nInData, '''', True, ',', False);
  //采购单列表
  nSQL := 'Select O_ID From %s ' +
          'Where O_SrcID In (%s) And O_SrcCompany=''%s''';
  nSQL := Format(nSQL, [sTable_Order, nStr, nSrcCompany]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('采购单[ %s ]已丢失.', [nInData]);
      Exit;
    end;

    nInData := '';
    First;

    while not Eof do
    begin
      nInData := nInData + Fields[0].AsString + ',';
      Next;
    end;

    nIdx := Length(nInData);
    if Copy(nInData, nIdx, 1) = ',' then
      System.Delete(nInData, nIdx, 1);
    //xxxxx
  end;
  {$ELSE}
  if not CallRemoteWorker(sCLI_BusinessPurchaseOrder, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_SaveOrderCard, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;  
  {$ENDIF}

  FListB.Text := FIn.FExtParam;
  //磁卡列表
  nStr := AdjustListStrFormat(nInData, '''', True, ',', False);
  //采购单列表

  nSQL := 'Select O_ID,O_Card,O_Truck From %s Where O_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Order, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('采购订单[ %s ]已丢失.', [nInData]);
      Exit;
    end;

    First;
    while not Eof do
    begin
      nStr := FieldByName('O_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '采购单[ %s ]的车牌号不一致,不能并单.' + #13#10#13#10 +
                 '*.本单车牌: %s' + #13#10 +
                 '*.其它车牌: %s' + #13#10#13#10 +
                 '相同牌号才能并单,请修改车牌号,或者单独办卡.';
        nData := Format(nData, [FieldByName('O_ID').AsString, nStr, nTruck]);
        Exit;
      end;

      if nTruck = '' then
        nTruck := nStr;
      //xxxxx

      nStr := FieldByName('O_Card').AsString;
      //正在使用的磁卡
        
      if (nStr <> '') and (FListB.IndexOf(nStr) < 0) then
        FListB.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------

  FDBConn.FConn.BeginTrans;
  try
    if nInData <> '' then
    begin
      nSQL := 'Update %s Set O_Card=Null Where O_Card=''%s''';
      nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set D_Card=Null Where D_Card=''%s''';
      nSQL := Format(nSQL, [sTable_OrderDtl, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
      nSQL := Format(nSQL, [sTable_Card, sFlag_CardInvalid, FIn.FExtParam]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nStr := AdjustListStrFormat(nInData, '''', True, ',', False);
      //重新计算列表

      nSQL := 'Update %s Set O_Card=''%s'' Where O_ID In(%s)';
      nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set D_Card=''%s'' Where D_OID In(%s) and D_OutFact Is NULL';
      nSQL := Format(nSQL, [sTable_OrderDtl, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
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

//Date: 2015-8-5
//Desc: 保存采购单
function TWorkerBusinessOrders.LogoffOrderCard(var nData: string): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  //init

  {$IFNDEF MasterSys}
  if not CallRemoteWorker(sCLI_BusinessPurchaseOrder, FIn.FData, FIn.FExtParam,
    GetMasterCompanyID, @nOut, cBC_LogOffOrderCard, GetCompanyID) then
  begin
    nData := nOut.FData;
    Exit;
  end;
  {$ENDIF}

  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Card=Null Where O_Card=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set D_Card=Null Where D_Card=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, FIn.FData]);
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

function TWorkerBusinessOrders.ChangeOrderTruck(var nData: string): Boolean;
var nStr: string;
begin
  //Result := False;
  //Init

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Truck=''%s'' Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FExtParam, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新修改信息

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessOrders.SaveOrderDtlAdd(var nData: string):Boolean;
var nStr, nOrder, nDtlID, nPoundID: string;
    nVal, nPVal, nMVal, nKZVal: Double;
    nOut: TWorkerBusinessCommand;
    nIdx: Integer;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  //unpack Order
  nPVal := StrToFloat(FListA.Values['SQ_PValue']);
  nMVal := StrToFloat(FListA.Values['SQ_MValue']);
  nKZVal := StrToFloat(FListA.Values['SQ_KZValue']);

  FListC.Clear;
  FListC.Values['Group'] :=sFlag_BusGroup;
  FListC.Values['Object'] := sFlag_Order;
  FListC.Values['Table']  := sTable_Order;
  FListC.Values['Field']  := 'O_ID';
  FListC.Values['DateTime']  := FListA.Values['SQ_MDate'];
  //to get serial no

  if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNOByDate,
        FListC.Text, sFlag_Yes, @nOut) then
    raise Exception.Create(nOut.FData);
  //xxxxx

  nOrder := nOut.FData;
  //采购订单编号

  FListC.Clear;
  FListC.Values['Group'] :=sFlag_BusGroup;
  FListC.Values['Object'] := sFlag_OrderDtl;
  FListC.Values['Table']  := sTable_OrderDtl;
  FListC.Values['Field']  := 'D_ID';
  FListC.Values['DateTime']  := FListA.Values['SQ_MDate'];
  //to get serial no

  if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNOByDate,
        FListC.Text, sFlag_Yes, @nOut) then
    raise Exception.Create(nOut.FData);
  //xxxxx

  nDtlID := nOut.FData;
  //采购明细编号

  FListC.Clear;
  FListC.Values['Group'] :=sFlag_BusGroup;
  FListC.Values['Object'] := sFlag_PoundID;
  FListC.Values['Table']  := sTable_PoundLog;
  FListC.Values['Field']  := 'P_ID';
  FListC.Values['DateTime']  := FListA.Values['SQ_MDate'];
  //to get serial no

  if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNOByDate,
        FListC.Text, sFlag_Yes, @nOut) then
    raise Exception.Create(nOut.FData);
  //xxxxx

  nPoundID := nOut.FData;
  //采购磅单编号

  FListB.Clear;
  //SQL List
  nVal := Float2Float(nMVal-nPVal, cPrecision, False);

  nStr := MakeSQLByStr([SF('O_ID', nOrder),

          SF('O_CType', sFlag_OrderCardG),
          SF('O_Project', FListA.Values['SQ_Project']),
          SF('O_Area', FListA.Values['SQ_Area']),
          SF('O_XuNi', FListA.Values['SQ_XuNi']),

          SF('O_BID', FListA.Values['SQ_ID']),
          SF('O_Value', nVal,sfVal),

          SF('O_ProID', FListA.Values['SQ_ProID']),
          SF('O_ProName', FListA.Values['SQ_ProName']),
          SF('O_ProType', FListA.Values['SQ_ProType']),
          SF('O_ProPY', GetPinYinOfStr(FListA.Values['SQ_ProName'])),

          SF('O_SaleID', FListA.Values['SQ_SaleID']),
          SF('O_SaleMan', FListA.Values['SQ_SaleMan']),
          SF('O_SalePY', GetPinYinOfStr(FListA.Values['SQ_SaleMan'])),

          SF('O_Type', sFlag_San),
          SF('O_StockNo', FListA.Values['SQ_StockNO']),
          SF('O_StockName', FListA.Values['SQ_StockName']),

          SF('O_Truck', FListA.Values['SQ_Truck']),
          SF('O_Man', FIn.FBase.FFrom.FUser),
          SF('O_Date', FListA.Values['SQ_MDate'])
          ], sTable_Order, '', True);
  FListB.Add(nStr);

  nVal := Float2Float(nMVal-nPVal-nKZVal, cPrecision, False);
  nStr := MakeSQLByStr([
          SF('D_ID', nDtlID),
          SF('D_Card', ''),
          SF('D_OID', nOrder),
          SF('D_Value', nVal, sfVal),

          SF('D_XuNi', FListA.Values['SQ_XuNi']),
          SF('D_ProID', FListA.Values['SQ_ProID']),
          SF('D_ProName', FListA.Values['SQ_ProName']),
          SF('D_ProType', FListA.Values['SQ_ProType']),

          SF('D_Type', sFlag_San),
          SF('D_StockNo', FListA.Values['SQ_StockNO']),
          SF('D_StockName', FListA.Values['SQ_StockName']),

          SF('D_Truck', FListA.Values['SQ_Truck']),
          SF('D_Status', sFlag_TruckOut),
          SF('D_NextStatus', ''),
          SF('D_InMan', FIn.FBase.FFrom.FUser),
          SF('D_InTime', FListA.Values['SQ_MDate']),

          SF('D_PValue', nPVal, sfVal),
          SF('D_PDate', FListA.Values['SQ_PDate']),
          SF('D_PMan', FListA.Values['SQ_PMan']),

          SF('D_MValue', nMVal, sfVal),
          SF('D_MDate', FListA.Values['SQ_MDate']),
          SF('D_MMan', FListA.Values['SQ_MMan']),

          SF('D_YTime', FListA.Values['SQ_YSDate']),
          SF('D_YMan', FListA.Values['SQ_YSMan']),
          SF('D_KZValue', nKZVal, sfVal),
          SF('D_YSResult', sFlag_Yes),
          SF('D_Memo', FListA.Values['SQ_Memo']),

          SF('D_OutFact', FListA.Values['SQ_PDate']),
          SF('D_OutMan', FIn.FBase.FFrom.FUser)
          ], sTable_OrderDtl, '', True);
  FListB.Add(nStr);

  nStr := MakeSQLByStr([
          SF('P_ID', nPoundID),
          SF('P_Type', sFlag_Provide),
          SF('P_Order', nDtlID),

          SF('P_Truck', FListA.Values['SQ_Truck']),
          SF('P_CusID', FListA.Values['SQ_ProID']),
          SF('P_CusName', FListA.Values['SQ_ProName']),

          SF('P_MID', FListA.Values['SQ_StockNO']),
          SF('P_MName', FListA.Values['SQ_StockName']),
          SF('P_MType', sFlag_San),

          SF('P_LimValue', 0),
          SF('P_KZValue', nKZVal, sfVal),

          SF('P_PValue', nPVal, sfVal),
          SF('P_PDate', FListA.Values['SQ_PDate']),
          SF('P_PMan', FListA.Values['SQ_PMan']),

          SF('P_MValue', nMVal, sfVal),
          SF('P_MDate', FListA.Values['SQ_PDate']),
          SF('P_MMan', FListA.Values['SQ_PMan']),

          SF('P_Direction', '进厂'),
          SF('P_PModel', sFlag_PoundPD),

          SF('P_Status', sFlag_TruckBFM),
          SF('P_Valid', sFlag_Yes),
          SF('P_PrintNum', 1, sfVal)
          ], sTable_PoundLog, '', True);
  FListB.Add(nStr);

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx := 0 to FListB.Count-1 do
      gDBConnManager.WorkerExec(FDBConn, FListB[nIdx]);

    FDBConn.FConn.CommitTrans;
    FOut.FData := nDtlID;  //返回打印
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;  

//Date: 2014-09-17
//Parm: 磁卡号[FIn.FData];岗位[FIn.FExtParam]
//Desc: 获取特定岗位所需要的交货单列表
function TWorkerBusinessOrders.GetPostOrderItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsOrder: Boolean;
    nBills: TLadingBillItems;
begin
  Result := False;
  nIsOrder := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_Order]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsOrder := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //前缀和长度都满足采购单编码规则,则视为采购单号
  end;

  if not nIsOrder then
  begin
    nStr := 'Select C_Status,C_Freeze From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('磁卡[ %s ]信息已丢失.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '磁卡[ %s ]当前状态为[ %s ],无法提货.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '磁卡[ %s ]已被冻结,无法提货.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
    end;
  end;

  nStr := 'Select O_ID,O_Card,O_ProType,O_ProID,O_ProName,O_Type,O_StockNo,' +
          'O_StockName,O_Truck,O_Value,O_XuNi ' +
          'From $OO oo ';
  //xxxxx

  if nIsOrder then
       nStr := nStr + 'Where O_ID=''$CD'''
  else nStr := nStr + 'Where O_Card=''$CD''';

  nStr := MacroValue(nStr, [MI('$OO', sTable_Order),MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if nIsOrder then
           nData := '采购单[ %s ]已无效.'
      else nData := '磁卡号[ %s ]无订单';

      nData := Format(nData, [FIn.FData]);
      Exit;
    end else
    with FListA do
    begin
      Clear;

      Values['O_ID']         := FieldByName('O_ID').AsString;
      Values['O_ProType']    := FieldByName('O_ProType').AsString;
      Values['O_ProID']      := FieldByName('O_ProID').AsString;
      Values['O_ProName']    := FieldByName('O_ProName').AsString;
      Values['O_Truck']      := FieldByName('O_Truck').AsString;

      Values['O_XuNi']       := FieldByName('O_XuNi').AsString;
      Values['O_Type']       := FieldByName('O_Type').AsString;
      Values['O_StockNo']    := FieldByName('O_StockNo').AsString;
      Values['O_StockName']  := FieldByName('O_StockName').AsString;

      Values['O_Card']       := FieldByName('O_Card').AsString;
      Values['O_Value']      := FloatToStr(FieldByName('O_Value').AsFloat);
    end;
  end;

  nStr := 'Select D_ID,D_OID,D_PID,D_YLine,D_Status,D_NextStatus,' +
          'D_KZValue,D_Memo,D_YSResult,' +
          'P_PStation,P_PValue,P_PDate,P_PMan,' +
          'P_MStation,P_MValue,P_MDate,P_MMan ' +
          'From $OD od Left join $PD pd on pd.P_Order=od.D_ID ' +
          'Where D_OutFact Is Null And D_OID=''$OID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$OD', sTable_OrderDtl),
                            MI('$PD', sTable_PoundLog),
                            MI('$OID', FListA.Values['O_ID'])]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then
    begin
      SetLength(nBills, 1);

      with nBills[0], FListA do
      begin
        FZhiKa      := Values['O_ID'];
        FCusID      := Values['O_ProID'];
        FCusName    := Values['O_ProName'];
        FCusType    := Values['O_ProType'];
        FTruck      := Values['O_Truck'];
        FZKType     := Values['O_XuNi'];

        FType       := Values['O_Type'];
        FStockNo    := Values['O_StockNo'];
        FStockName  := Values['O_StockName'];
        FValue      := StrToFloat(Values['O_Value']);

        FCard       := Values['O_Card'];
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;

        FSelected := True;
      end;  
    end else
    begin
      SetLength(nBills, RecordCount);

      nIdx := 0;

      First; 
      while not Eof do
      with nBills[nIdx], FListA do
      begin
        FID         := FieldByName('D_ID').AsString;
        FZhiKa      := FieldByName('D_OID').AsString;
        FPoundID    := FieldByName('D_PID').AsString;

        FCusID      := Values['O_ProID'];
        FCusName    := Values['O_ProName'];
        FCusType    := Values['O_ProType'];
        FTruck      := Values['O_Truck'];

        FType       := Values['O_Type'];
        FStockNo    := Values['O_StockNo'];
        FStockName  := Values['O_StockName'];
        FValue      := StrToFloat(Values['O_Value']);

        FCard       := Values['O_Card'];
        FStatus     := FieldByName('D_Status').AsString;
        FNextStatus := FieldByName('D_NextStatus').AsString;

        if (FStatus = '') or (FStatus = sFlag_BillNew) then
        begin
          FStatus     := sFlag_TruckNone;
          FNextStatus := sFlag_TruckNone;
        end;

        with FPData do
        begin
          FStation  := FieldByName('P_PStation').AsString;
          FValue    := FieldByName('P_PValue').AsFloat;
          FDate     := FieldByName('P_PDate').AsDateTime;
          FOperator := FieldByName('P_PMan').AsString;
        end;

        with FMData do
        begin
          FStation  := FieldByName('P_MStation').AsString;
          FValue    := FieldByName('P_MValue').AsFloat;
          FDate     := FieldByName('P_MDate').AsDateTime;
          FOperator := FieldByName('P_MMan').AsString;
        end;

        FKZValue  := FieldByName('D_KZValue').AsFloat;
        FMemo     := FieldByName('D_Memo').AsString;
        FYSValid  := FieldByName('D_YSResult').AsString;
        FSelected := True;

        Inc(nIdx);
        Next;
      end;
    end;    
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2014-09-18
//Parm: 交货单[FIn.FData];岗位[FIn.FExtParam]
//Desc: 保存指定岗位提交的交货单列表
function TWorkerBusinessOrders.SavePostOrderItems(var nData: string): Boolean;
var nVal, nNet: Double;
    nIdx: Integer;
    nStr,nSQL,nTmp: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nPound);
  //解析数据

  {$IFDEF MasterSys}
  nTmp := '';
  for nIdx := Low(nPound) to High(nPound) do
  begin
    if FIn.FExtParam = sFlag_TruckIn then
    begin
      nSQL := 'Select O_SrcID, O_SrcCompany From %s Where O_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Order, nPound[nIdx].FZhiKa]);
    end else

    begin
      nSQL := 'Select D_SrcID, D_SrcCompany From %s Where D_ID=''%s''';
      nSQL := Format(nSQL, [sTable_OrderDtl, nPound[nIdx].FID]);
    end;    


    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '岗位[ %s ]提交的单据编号[ %s ]不存在.';
        nData := Format(nData, [PostTypeToStr(FIn.FExtParam), nPound[nIdx].FID]);
        Exit;
      end;

      if (nTmp <> '') and (nTmp <> Fields[1].AsString) then
      begin
        nData := '不同工厂不能合单.';
        Exit;
      end;

      nTmp := Fields[1].AsString;

      if FIn.FExtParam = sFlag_TruckIn then
           nPound[nIdx].FZhiKa := Fields[0].AsString
      else nPound[nIdx].FID := Fields[0].AsString;
    end;
  end;

  nStr := CombineBillItmes(nPound);
  if not CallRemoteWorker(sCLI_BusinessPurchaseOrder, nStr, FIn.FExtParam, nTmp,
    @nOut, cBC_SavePostOrders) then
  begin
    nData := nOut.FData;
    Exit;
  end;

  nStr := nOut.FData;
  AnalyseBillItems(FIn.FData, nPound);
  {$ENDIF}

  FListA.Clear;
  //用于存储SQL列表

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //进厂
  begin
    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderDtl;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
        FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := nOut.FData;

    with nPound[0] do
    begin
      nSQL := MakeSQLByStr([
            SF('D_ID', nOut.FData),
            SF('D_Card', FCard),
            SF('D_OID', FZhiKa),

            SF('D_XuNi', FZKType), //资源综合利用
            SF('D_ProID', FCusID),
            SF('D_ProName', FCusName),
            SF('D_ProType', FCusType),

            SF('D_Type', FType),
            SF('D_StockNo', FStockNo),
            SF('D_StockName', FStockName),

            {$IFDEF MasterSys}
            SF('D_SrcID', nStr),
            SF('D_SrcCompany', nTmp),
            {$ENDIF}

            SF('D_Truck', FTruck),
            SF('D_Status', sFlag_TruckIn),
            SF('D_NextStatus', sFlag_TruckBFP),
            SF('D_InMan', FIn.FBase.FFrom.FUser),
            SF('D_InTime', sField_SQLServer_Now, sfVal)
            ], sTable_OrderDtl, '', True);
      FListA.Add(nSQL);
    end;  
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //称量皮重
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

    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := nOut.FData;
    //返回榜单号,用于拍照绑定
    with nPound[0] do
    begin
      FStatus := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckXH;

      if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM;
      //现场不发货直接过重

      nSQL := MakeSQLByStr([
            SF('P_ID', nOut.FData),
            SF('P_Type', sFlag_Provide),
            SF('P_Order', FID),
            SF('P_Truck', FTruck),
            SF('P_CusID', FCusID),
            SF('P_CusName', FCusName),
            SF('P_MID', FStockNo),
            SF('P_MName', FStockName),
            SF('P_MType', FType),
            SF('P_LimValue', 0),
            SF('P_PValue', FPData.FValue, sfVal),
            SF('P_PDate', sField_SQLServer_Now, sfVal),
            SF('P_PMan', FIn.FBase.FFrom.FUser),
            SF('P_FactID', FFactory),
            SF('P_PStation', FPData.FStation),
            SF('P_Direction', '进厂'),
            SF('P_PModel', FPModel),
            SF('P_Status', sFlag_TruckBFP),
            SF('P_Valid', sFlag_Yes),
            SF('P_PrintNum', 1, sfVal)
            ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_PValue', FPData.FValue, sfVal),
              SF('D_PDate', sField_SQLServer_Now, sfVal),
              SF('D_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
    end;  

  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckXH then //验收现场
  begin
    with nPound[0] do
    begin
      FStatus := sFlag_TruckXH;
      FNextStatus := sFlag_TruckBFM;

      nStr := SF('P_Order', FID);
      //where
      nSQL := MakeSQLByStr([
                SF('P_KZValue', FKZValue, sfVal)
                ], sTable_PoundLog, nStr, False);
      //验收扣杂
     FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_YTime', sField_SQLServer_Now, sfVal),
              SF('D_YMan', FIn.FBase.FFrom.FUser),
              SF('D_KZValue', FKZValue, sfVal),
              SF('D_YSResult', FYSValid),
              SF('D_Memo', FMemo)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //称量毛重
  begin
    with nPound[0] do
    begin
      {$IFDEF MasterSys}
      if not CallRemoteWorker(sCLI_BusinessCommand, FTruck, '', nTmp, @nOut,
        cBC_GetTruckCGHZValue) then
      begin
        nData := nOut.FData;
        Exit;
      end;

      nVal := StrToFloat(nOut.FData);
      {$ELSE}
      nStr := 'Select T_CGHZValue From %s Where T_Truck=''%s''';
      nStr := Format(nStr, [sTable_Truck, FTruck]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount>0 then
           nVal := FieldByName('T_CGHZValue').AsFloat
      else nVal := 0;
      {$ENDIF}

      if nVal > 0 then
      begin
        {$IFNDEF MasterSys}
        nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Value=''%s''';
        nStr := Format(nStr, [sTable_SysDict, sFlag_NoPoundStock, FStockNo]);
        //判断超发卸货
        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        if RecordCount>0 then
        begin
          if (FMData.FValue > FPData.FValue) and (FMData.FValue > nVal) then
            nNet := FMData.FValue - nVal else
          if (FPData.FValue > FMData.FValue) and (FPData.FValue > nVal) then
            nNet := FPData.FValue - nVal else nNet := 0;

          if FloatRelation(nNet, 0, rtGreater, cPrecision) then
          begin
            nData := '车辆[ %s ]已超出核载量[ %s ]吨,请卸料!';
            nData := Format(nData, [FTruck, FloatToStr(nNet)]);
            Exit;
          end;
        end;
        {$ENDIF}

        if (FMData.FValue > FPData.FValue) and (FMData.FValue > nVal) then
          FMData.FValue := nVal
        else if (FPData.FValue > FMData.FValue) and (FPData.FValue > nVal) then
          FPData.FValue := nVal;
      end;  

      nStr := 'Select D_CusID,D_Value,D_Type From %s ' +
              'Where D_Stock=''%s'' And D_Valid=''%s''';
      nStr := Format(nStr, [sTable_Deduct, FStockNo, sFlag_Yes]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          if FieldByName('D_CusID').AsString = FCusID then
            Break;
          //客户+物料参数优先

          Next;
        end;

        if Eof then First;
        //使用第一条规则

        if FMData.FValue > FPData.FValue then
             nNet := FMData.FValue - FPData.FValue
        else nNet := FPData.FValue - FMData.FValue;

        nVal := 0;
        //待扣减量
        nStr := FieldByName('D_Type').AsString;

        if nStr = sFlag_DeductFix then
          nVal := FieldByName('D_Value').AsFloat;
        //定值扣减

        if nStr = sFlag_DeductPer then
        begin
          nVal := FieldByName('D_Value').AsFloat;
          nVal := nNet * nVal;
        end; //比例扣减

        if (nVal > 0) and (nNet > nVal) then
        begin
          nVal := Float2Float(nVal, cPrecision, False);
          //将暗扣量扣减为2位小数;

          if FMData.FValue > FPData.FValue then
               FMData.FValue := (FMData.FValue*1000 - nVal*1000) / 1000
          else FPData.FValue := (FPData.FValue*1000 - nVal*1000) / 1000;
        end;
      end;

      nStr := SF('P_Order', FID);
      //where

      nVal := FMData.FValue - FPData.FValue -FKZValue;
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
                ], sTable_PoundLog, nStr, False);
        //称重时,由于皮重大,交换皮毛重数据
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_PValue', FPData.FValue, sfVal),
                SF('D_PDate', sField_SQLServer_Now, sfVal),
                SF('D_PMan', FIn.FBase.FFrom.FUser),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', DateTime2Str(FMData.FDate)),
                SF('D_MMan', FMData.FOperator),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);

      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', sField_SQLServer_Now, sfVal),
                SF('D_MMan', FMData.FOperator),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);
      end;

      if FYSValid <> sFlag_NO then  //验收成功，调整已收货量
      begin
        nSQL := 'Update $OrderBase Set B_SentValue=B_SentValue+$Val ' +
                'Where B_ID = (select O_BID From $Order Where O_ID=''$ID'')';
        nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
                MI('$Order', sTable_Order),MI('$ID', FZhiKa),
                MI('$Val', FloatToStr(nVal))]);
        FListA.Add(nSQL);
        //调整已收货；
      end;

      nSQL := 'Update $OrderBase Set B_FreezeValue=B_FreezeValue-$KDVal ' +
              'Where B_ID = (select O_BID From $Order Where O_ID=''$ID'''+
              ' And O_CType= ''L'') and B_Value>0';
      nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
              MI('$Order', sTable_Order),MI('$ID', FZhiKa),
              MI('$KDVal', FloatToStr(FValue))]);
      FListA.Add(nSQL);
      //调整冻结量
    end;

    nSQL := 'Select P_ID From %s Where P_Order=''%s'' And P_MValue Is Null';
    nSQL := Format(nSQL, [sTable_PoundLog, nPound[0].FID]);
    //未称毛重记录

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      FOut.FData := Fields[0].AsString;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    with nPound[0] do
    begin
      nSQL := MakeSQLByStr([SF('D_Status', sFlag_TruckOut),
              SF('D_NextStatus', ''),
              SF('D_Card', ''),
              SF('D_OutFact', sField_SQLServer_Now, sfVal),
              SF('D_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL); //更新采购单
    end;

    {$IFNDEF MasterSys}
    FListB.Clear;
    FListB.Add(nPound[0].FID);
    nStr := CombinStr(FListB, ',', True);
    if not TWorkerBusinessCommander.CallMe(cBC_StatisticsTrucks, nStr,
      sFlag_Provide, @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;
    {$ENDIF}

    nSQL := 'Select O_CType,O_Card From %s Where O_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Order, nPound[0].FZhiKa]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      nStr := FieldByName('O_Card').AsString;
      if FieldByName('O_CType').AsString = sFlag_OrderCardL then
      if not CallMe(cBC_LogOffOrderCard, nStr, '', @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
    end;
    //如果是临时卡片，则注销卡片

    {$IFDEF MasterSys}
    nSQL := 'Delete From %s Where P_Order=''%s''';
    nSQL := Format(nSQL, [sTable_PoundLog, nPound[0].FID]);
    FListA.Add(nSQL);

    nSQL := 'Delete From %s Where D_ID=''%s''';
    nSQL := Format(nSQL, [sTable_OrderDtl, nPound[0].FID]);
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

  if FIn.FExtParam = sFlag_TruckBFM then //称量毛重
  begin
    if Assigned(gHardShareData) then
      gHardShareData('TruckOut:' + nPound[0].FCard);
    //磅房处理自动出厂
  end;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TWorkerBusinessOrders.CallMe(const nCmd: Integer;
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

initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessOrders, sPlug_ModuleBus);
end.
