{*******************************************************************************
  作者: dmzn@163.com 2013-12-04
  描述: 模块业务对象
*******************************************************************************}
unit UWorkerBusinessCommander;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst;

type
  TBusWorkerQueryField = class(TBusinessWorkerBase)
  private
    FIn: TWorkerQueryFieldData;
    FOut: TWorkerQueryFieldData;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //执行业务
  end;

  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //错误码
    FDBConn: PDBWorker;
    //数据通道
    FDataIn,FDataOut: PBWDataBase;
    //入参出参
    FDataOutNeedUnPack: Boolean;
    //需要解包
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //出入参数
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //验证入参
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //数据业务
  public
    function DoWork(var nData: string): Boolean; override;
    //执行业务
    procedure WriteLog(const nEvent: string);
    //记录日志
  end;

  TStockParam = record
    FStockNO:   string;
    FStockName: string;

    FPrice : Double;
    FValue : Double;

    FIsExist : Boolean;
  end;
  TStockParams = array of TStockParam;

  TWorkerBusinessCommander = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCardUsed(var nData: string): Boolean;
    //获取卡片类型
    function Login(var nData: string):Boolean;
    function LogOut(var nData: string): Boolean;
    //登录注销，用于移动终端
    function GetServerNow(var nData: string): Boolean;
    //获取服务器时间
    function GetSerailID(var nData: string): Boolean;
    //获取串号
    function GetSerailIDByDate(var nData: string): Boolean;
    //根据时间时期获取串号
    function IsSystemExpired(var nData: string): Boolean;
    //系统是否已过期
    function AdjustCustomerMoney(var nData: string): Boolean;
    function GetCustomerValidMoney(var nData: string): Boolean;
    function GetTransportValidMoney(var nData: string): Boolean;
    //获取客户可用金
    function GetZhiKaValidMoney(var nData: string): Boolean;
    //获取订单可用金
    function GetCompensateMoney(var nData: string): Boolean;
    //获取返利账户可用金
    function CustomerHasMoney(var nData: string): Boolean;
    //验证客户是否有钱
    function SaveTruck(var nData: string): Boolean;
    //保存车辆到Truck表
    function GetTruckPoundData(var nData: string): Boolean;
    function SaveTruckPoundData(var nData: string): Boolean;
    //存取车辆称重数据

    function GetStockBatValue(var nData: string): Boolean;
    function GetStockBatcode(var nData: string): Boolean;
    function SaveStockBatcode(var nData: string): Boolean;
    //批次编号管理

    {$IFDEF SHXZY}
    function SaveStatisticsTrucks(var nData: string): Boolean;
    //车辆超重管理
    function SaveFactZhiKa(var nData: string):Boolean;
    //关联贸易公司订单
    function VerifyMYZhiKaMoney(var nData: string): Boolean;
    //验证贸易公司客户余额
    function SaveMYBills(var nData: string): Boolean;
    //保存贸易公司交易明细
    function DeleteMYBill(var nData: string):Boolean;
    {$ENDIF}
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

procedure AnalyseStockParams(const nData: string; var nItems: TStockParams);
//解析由业务对象返回的水泥编号数据
function CombineStockParams(const nItems: TStockParams): string;
//合并水泥编号数据为业务对象能处理的字符串

implementation

//------------------------------------------------------------------------------

procedure AnalyseStockParams(const nData: string; var nItems: TStockParams);
var nStr: string;
    nIdx,nInt: Integer;
    nListA, nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);

    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx := 0 to nListA.Count-1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);

      with nListB, nItems[nInt] do
      begin
        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;

        FStockNO   := Trim(Values['StockNo']);
        FStockName := Trim(Values['StockName']);

        FIsExist := False;
      end;

      Inc(nInt);
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

function CombineStockParams(const nItems: TStockParams): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      with nListB do
      begin
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

//------------------------------------------------------------------------------
class function TBusWorkerQueryField.FunctionName: string;
begin
  Result := sBus_GetQueryField;
end;

function TBusWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
  end;
end;

function TBusWorkerQueryField.DoWork(var nData: string): Boolean;
begin
  FOut.FData := '*';
  FPacker.UnPackIn(nData, @FIn);

  case FIn.FType of
   cQF_Bill: 
    FOut.FData := '*';
  end;

  Result := True;
  FOut.FBase.FResult := True;
  nData := FPacker.PackOut(@FOut);
end;

//------------------------------------------------------------------------------
//Date: 2012-3-13
//Parm: 如参数护具
//Desc: 获取连接数据库所需的资源
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '连接数据库失败(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: 输出数据;结果
//Desc: 数据业务执行完毕后的收尾操作
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: 验证入参数据是否有效
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: 记录nEvent日志
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor TWorkerBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: 命令;数据;参数;输出
//Desc: 本地调用业务对象
class function TWorkerBusinessCommander.CallMe(const nCmd: Integer;
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

//Date: 2012-3-22
//Parm: 输入数据
//Desc: 执行nData业务指令
function TWorkerBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := '业务执行成功.';
  end;

  case FIn.FCommand of
   cBC_GetCardUsed         : Result := GetCardUsed(nData);
   cBC_ServerNow           : Result := GetServerNow(nData);
   cBC_GetSerialNO         : Result := GetSerailID(nData);
   cBC_GetSerialNOByDate   : Result := GetSerailIDByDate(nData);
   cBC_IsSystemExpired     : Result := IsSystemExpired(nData);
   cBC_GetCustomerMoney    : Result := GetCustomerValidMoney(nData);
   cBC_AdjustCustomerMoney : Result := AdjustCustomerMoney(nData);
   cBC_GetZhiKaMoney       : Result := GetZhiKaValidMoney(nData);
   cBC_GetCompensateMoney  : Result := GetCompensateMoney(nData);
   cBC_GetTransportMoney   : Result := GetTransportValidMoney(nData);
   cBC_CustomerHasMoney    : Result := CustomerHasMoney(nData);
   cBC_SaveTruckInfo       : Result := SaveTruck(nData);
   cBC_GetTruckPoundData   : Result := GetTruckPoundData(nData);
   cBC_SaveTruckPoundData  : Result := SaveTruckPoundData(nData);
   cBC_UserLogin           : Result := Login(nData);
   cBC_UserLogOut          : Result := LogOut(nData);

   cBC_GetStockBatValue    : Result := GetStockBatValue(nData);
   cBC_GetStockBatcode     : Result := GetStockBatcode(nData);
   cBC_SaveStockBatcode    : Result := SaveStockBatcode(nData);

   {$IFDEF SHXZY}
   cBC_StatisticsTrucks    : Result := SaveStatisticsTrucks(nData);
   cBC_SaveFactZhiKa       : Result := SaveFactZhiKa(nData);
   cBC_VerifyMYZhiKaMoney  : Result := VerifyMYZhiKaMoney(nData);
   cBC_SaveMYBills         : Result := SaveMYBills(nData);
   cBC_DeleteMYBill        : Result := DeleteMYBill(nData);
   {$ENDIF}
   else
    begin
      Result := False;
      nData := '无效的业务代码(Invalid Command).';
    end;
  end;
end;

//Date: 2014-09-05
//Desc: 获取卡片类型：销售S;采购P;其他O
function TWorkerBusinessCommander.GetCardUsed(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select C_Used From %s Where C_Card=''%s'' ' +
          'or C_Card3=''%s'' or C_Card2=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FData, FIn.FData, FIn.FData]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: 用户名，密码；返回用户数据
//Desc: 用户登录
function TWorkerBusinessCommander.Login(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  FListA.Clear;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Values['User']='' then Exit;
  //未传递用户名

  nStr := 'Select U_Password From %s Where U_Name=''%s''';
  nStr := Format(nStr, [sTable_User, FListA.Values['User']]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    nStr := Fields[0].AsString;
    if nStr<>FListA.Values['Password'] then Exit;

    Result := True;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: 用户名；验证数据
//Desc: 用户注销
function TWorkerBusinessCommander.LogOut(var nData: string): Boolean;
begin
  Result := True;
end;

//Date: 2014-09-05
//Desc: 获取服务器当前时间
function TWorkerBusinessCommander.GetServerNow(var nData: string): Boolean;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  //sql

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    FOut.FData := DateTime2Str(Fields[0].AsDateTime);
    Result := True;
  end;
end;

//Date: 2012-3-25
//Desc: 按规则生成序列编号
function TWorkerBusinessCommander.GetSerailID(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    Result := False;
    FListA.Text := FIn.FData;
    //param list

    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, FListA.Values['Group'],
            FListA.Values['Object']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            FListA.Values['Group'], FListA.Values['Object']]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '没有[ %s.%s ]的编码配置.';
        nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

        FDBConn.FConn.RollbackTrans;
        Exit;
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if FIn.FExtParam = sFlag_Yes then //按日期编码
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  FListA.Values['Group'], FListA.Values['Object']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        FOut.FData := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        FOut.FData := nP + nStr + nB;
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2012-3-25
//Desc: 按规则生成序列编号
function TWorkerBusinessCommander.GetSerailIDByDate(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  FListA.Text := FIn.FData;
  //param list

  nP := Copy(FListA.Values['DateTime'], 1, 10);
  nB := Copy(DateTime2Str(Now), 1, 10);

  if CompareText(nP, nB) = 0 then
  begin
    Result := CallMe(cBC_GetSerialNO, FListA.Text, sFlag_Yes, @nOut);

    if not Result then
         nData      := nOut.FData
    else FOut.FData := nOut.FData;
    Exit;
  end;  
  //判断如果是日期属于当天，则根据标准规则进行生成

  nStr := 'Select B_Prefix,B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase,
          FListA.Values['Group'], FListA.Values['Object']]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '没有[ %s.%s ]的编码配置.';
      nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

      Exit;
    end;

    nP := FieldByName('B_Prefix').AsString;
    nInt := FieldByName('B_IDLen').AsInteger;
  end;

  nB := '';
  if FIn.FExtParam = sFlag_Yes then
    nB := FormatDateTime('YYMMDD', Str2DateTime(FListA.Values['DateTime']));
  nInt := nInt - Length(nP) - Length(nB);

  nStr := 'Select Top 1 $F From $T Where $F Like ''$P$D%'' Order By $F DESC';
  nStr := MacroValue(nStr, [MI('$T', FListA.Values['Table']),
          MI('$F', FListA.Values['Field']),
          MI('$D', nB), MI('$P', nP)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    nStr := Copy(nStr, Length(nStr) - nInt + 1, nInt);

    if IsNumber(nStr, False) then
         nStr := IntToStr(StrToInt(nStr) + 1)
    else nStr := '1';
  end else nStr := '1';

  nStr := StringOfChar('0', nInt - Length(nStr)) + nStr;
  FOut.FData := nP + nB + nStr;

  Result := True;
end;

//Date: 2014-09-05
//Desc: 验证系统是否已过期
function TWorkerBusinessCommander.IsSystemExpired(var nData: string): Boolean;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  Result := nInt > 0;

  if nInt <= 0 then
  begin
    nStr := '系统已过期 %d 天,请联系管理员!!';
    nData := Format(nStr, [-nInt]);
    Exit;
  end;

  FOut.FData := IntToStr(nInt);
  //last days

  if nInt <= 7 then
  begin
    nStr := Format('系统在 %d 天后过期', [nInt]);
    FOut.FBase.FErrDesc := nStr;
    FOut.FBase.FErrCode := sFlag_ForceHint;
  end;
end;

//Date: 2014-09-05
//Desc: 获取指定客户的可用金额
function TWorkerBusinessCommander.GetCustomerValidMoney(var nData: string): Boolean;
var nStr, nType, nCID: string;
    nVal,nCredit: Double;
    nPos: Integer;
begin
  nPos := Pos(sFlag_Delimater, FIn.FData);
  if nPos>0 then
  begin
    nType:= Copy(FIn.FData, nPos + 1, Length(FIn.FData)-nPos);
    nCID := Copy(FIn.FData, 1, nPos-1);

    nStr := 'Select * From %s Where A_CID=''%s'' And A_Type=''%s''';
    nStr := Format(nStr, [sTable_CusAccDetail, nCID, nType]);
  end else
  begin
    nCID := FIn.FData;
    nStr := 'Select * From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nCID]);
  end;

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [nCID]);

      Result := False;
      Exit;
    end;

    nVal := FieldByName('A_BeginBalance').AsFloat +
            FieldByName('A_InMoney').AsFloat +
            FieldByName('A_RefundMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_CardUseMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat - //返利金额不参与正常发货
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    if FIn.FExtParam = sFlag_Yes then
      nVal := nVal + nCredit;
    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

    FOut.FData := FloatToStr(nVal);
    FOut.FExtParam := FloatToStr(nCredit);
    Result := True;
  end;
end;

//Date: 2014-10-14
//Desc: 获取指定订单的可用金额
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr, nCID: string;
    nVal,nMoney: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;

  if (FIn.FExtParam = sFlag_BillSZ) or (FIn.FExtParam = sFlag_BillMY) then
  begin
    if FIn.FExtParam = sFlag_BillMY then
         nStr := 'Select Z_Customer,Z_OnlyMoney,Z_FixedMoney,Z_PayType ' +
         'From $ZK zk ' +
         'Left join $MY my on my.M_FID=zk.Z_ID ' +
         'Where M_ID=''$ZID'''
    else nStr := 'Select Z_Customer,Z_OnlyMoney,Z_FixedMoney,Z_PayType ' +
         'From $ZK Where Z_ID=''$ZID''';

    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$MY', sTable_MYZhiKa),
            MI('$ZID', FIn.FData)]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的订单不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nStr := FieldByName('Z_Customer').AsString + sFlag_Delimater +
              FieldByName('Z_Paytype').AsString;
      if not TWorkerBusinessCommander.CallMe(cBC_GetCustomerMoney, nStr,
         sFlag_Yes, @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;

      nVal := StrToFloat(nOut.FData);
      FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
      nMoney := FieldByName('Z_FixedMoney').AsFloat;
                                
      if FOut.FExtParam = sFlag_Yes then
      begin
        if nMoney > nVal then
          nMoney := nVal;
        //enough money
      end else nMoney := nVal;

      FOut.FData := FloatToStr(nMoney);
      Result := True;
    end;

  end else

  if FIn.FExtParam = sFlag_BillFX then
  begin
    nStr := 'Select I_Money,I_OutMoney,I_FreezeMoney,I_BackMoney,I_RefundMoney ' +
            'From %s Where I_ID=''%s'' And I_Enabled=''%s'''; 
    nStr := Format(nStr, [sTable_FXZhiKa, FIn.FData, sFlag_Yes]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '分销订单[ %s ]不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nMoney := Float2Float(Fields[0].AsFloat + Fields[4].AsFloat -
                Fields[1].AsFloat - Fields[2].AsFloat - Fields[3].AsFloat,
                cPrecision, False);
      //xxxxx

      FOut.FData := FloatToStr(nMoney);
      FOut.FExtParam := sFlag_No;
      Result := True;
    end;

  end else

  if FIn.FExtParam = sFlag_BillFL then
  begin
    nStr := 'Select Z_Customer,Z_OnlyMoney,Z_FixedMoney From $ZK ' +
            'Where Z_ID=''$ZID''';

    nStr := MacroValue(nStr, [MI('$ZK', sTable_FLZhiKa),
            MI('$ZID', FIn.FData)]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的订单不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nCID := FieldByName('Z_Customer').AsString;
      nMoney := FieldByName('Z_FixedMoney').AsFloat;
      FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
    end;

    nStr := 'Select * From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nCID]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的客户账户不存在.';
        nData := Format(nData, [nCID]);

        Result := False;
        Exit;
      end;

      nVal := FieldByName('A_BeginBalance').AsFloat +
              FieldByName('A_InMoney').AsFloat +
              FieldByName('A_RefundMoney').AsFloat -
              FieldByName('A_OutMoney').AsFloat -
              FieldByName('A_CardUseMoney').AsFloat -
              FieldByName('A_Compensation').AsFloat - //返利金额不参与正常发货
              FieldByName('A_FreezeMoney').AsFloat;
      //xxxxx
      nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;
    end;
                                
    if FOut.FExtParam = sFlag_Yes then
    begin
      if nMoney > nVal then
        nMoney := nVal;
      //enough money
    end else nMoney := nVal;

    FOut.FData := FloatToStr(nMoney);
    Result := True;
  end;
  //获取纸卡限提金额
end;

//Date: 2015/11/28
//Parm: 
//Desc: 获取指定客户的运费可用金额
function TWorkerBusinessCommander.GetCompensateMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nCredit: Double;
begin
  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CompensateAccount, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;

    nVal := FieldByName('A_BeginBalance').AsFloat +
            FieldByName('A_InMoney').AsFloat +            
            FieldByName('A_RefundMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    if FIn.FExtParam = sFlag_Yes then
      nVal := nVal + nCredit;
    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

    FOut.FData := FloatToStr(nVal);
    FOut.FExtParam := FloatToStr(nCredit);
    Result := True;
  end;
end;

//Date: 2015/11/28
//Parm: 
//Desc: 获取指定客户的运费可用金额
function TWorkerBusinessCommander.GetTransportValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nCredit: Double;
begin
  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_TransAccount, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '编号为[ %s ]的客户账户不存在.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;

    nVal := FieldByName('A_BeginBalance').AsFloat +
            FieldByName('A_InMoney').AsFloat +            
            FieldByName('A_RefundMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    if FIn.FExtParam = sFlag_Yes then
      nVal := nVal + nCredit;
    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

    FOut.FData := FloatToStr(nVal);
    FOut.FExtParam := FloatToStr(nCredit);
    Result := True;
  end;
end;

//Date: 2014-09-05
//Desc: 验证客户是否有钱,以及信用是否过期
function TWorkerBusinessCommander.CustomerHasMoney(var nData: string): Boolean;
var nStr,nName: string;
    nM,nC: Double;
begin
  FIn.FExtParam := sFlag_No;
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;

  nM := StrToFloat(FOut.FData);
  FOut.FData := sFlag_Yes;
  if nM > 0 then Exit;

  nStr := 'Select C_Name From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Customer, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
         nName := Fields[0].AsString
    else nName := '已删除';
  end;

  nC := StrToFloat(FOut.FExtParam);
  if (nC <= 0) or (nC + nM <= 0) then
  begin
    nData := Format('客户[ %s ]的资金余额不足.', [nName]);
    Result := False;
    Exit;
  end;

  nStr := 'Select MAX(C_End) From %s Where C_CusID=''%s'' and C_Money>=0';
  nStr := Format(nStr, [sTable_CusCredit, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
     (Fields[0].AsDateTime < Date()) then
  begin
    nData := Format('客户[ %s ]的信用已过期.', [nName]);
    Result := False;
  end;
end;

function TWorkerBusinessCommander.GetStockBatValue(var nData: string): Boolean;
var nSQL, nSNO, nStr: string;
    nRValue: Double;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if Trim(FListA.Text) = '' then
  begin
    nData := '输入批次号为空!';
    Exit;
  end;
  nSNO := AdjustListStrFormat2(FListA, '''', True, ',', False);


  nSQL := 'Select * From $SR sr, $SE se Where R_SerialNO In ($SNO) ' +
          'and sr.R_ExtID=se.E_ID and Year(sr.R_Date)>=Year(GetDate()) ';
  nSQL := MacroValue(nSQL, [MI('$SR', sTable_StockRecord),
          MI('$SE', sTable_StockRecordExt), MI('$SNO', nSNO)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount>0 then
  begin
    First;

    FListC.Clear;
    while not Eof do
    begin
      nStr := FieldByName('R_SerialNO').AsString;

      nRValue := FieldByName('E_Plan').AsFloat + FieldByName('E_Rund').AsFloat -
                 FieldByName('E_Sent').AsFloat - FieldByName('E_Freeze').AsFloat;
      nRValue := Float2Float(nRValue, cPrecision, False);

      FListC.Values[nStr] := FloatToStr(nRValue);
      Next;
    end;

    FOut.FData := PackerEncodeStr(FListC.Text);
    Result := True;
  end else
  begin
    nData := '批次号 [ %s ] 不存在';
    nData := Format(nData, [FListA.Text]);
    Exit;
  end;
end;

{$IFDEF SHXZY}
function TWorkerBusinessCommander.GetStockBatcode(var nData: string): Boolean;
var nStr, nGroup, nWhere:string;
    nRest: Double;
begin
  Result := False;
  nStr := 'Select P_QLevel From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_StockParam, FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount>0 then
       nGroup := Fields[0].AsString
  else Exit;

  if nGroup='' then
       nWhere := 'E_Stock=''$NO'''
  else nWhere := '(E_Stock=''$NO'') or (E_Group=''$GP'')';
  nWhere := MacroValue(nWhere, [MI('$NO', FIn.FData), MI('$GP', nGroup)]);

  nStr := 'Select re.*,R_SerialNo,R_Date From $RE re,$SR sr ' +
          'Where ($WHERE) And re.E_ID=sr.R_ExtID ' +
          'And E_Status=''$Y'' And Year(sr.R_Date)>=Year(GetDate()) ' +
          'Order By sr.R_Date';
  nStr := MacroValue(nStr, [MI('$RE', sTable_StockRecordExt),
          MI('$SR', sTable_StockRecord),
          MI('$WHERE', nWhere), MI('$Y', sFlag_Yes)]);
  //xxxxx

  if FIn.FExtParam <> '' then
    FListA.Text := PackerDecodeStr(FIn.FExtParam);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount>0 then
  begin
    First;

    while not Eof do
    try
      nRest := FieldByName('E_Plan').AsFloat + FieldByName('E_Rund').AsFloat -
               FieldByName('E_Sent').AsFloat - FieldByName('E_Freeze').AsFloat;
      nRest := Float2Float(nRest, cPrecision, False);

      if FListA.Values['Verify'] = sFlag_Yes then
      begin
        if FloatRelation(nRest, StrToFloat(FListA.Values['Value']), rtGreater) then
        begin
          FOut.FData := FieldByName('R_SerialNo').AsString;
          Result := True;
          Exit;
        end;
      end else
      if FloatRelation(nRest, 0, rtGreater) then
      begin
        FOut.FData := FieldByName('R_SerialNo').AsString;
        Result := True;
        Exit;
      end;  
    finally
      Next;
    end;
  end
  else Exit;
end;

function TWorkerBusinessCommander.SaveStockBatcode(var nData: string): Boolean;
begin
  Result := True;
end;  
{$ELSE}
//Date: 2015-01-16
//Parm: 物料编号[FIn.FData]
//Desc: 获取指定物料号的编号
function TWorkerBusinessCommander.GetStockBatcode(var nData: string): Boolean;
var nStr,nP,nUBrand,nUBatchAuto, nUBatcode: string;
    nBrand, nBatchOld, nBatchNew, nSelect: string;
    nKDValue, nValue: Double;
    nInt,nVal: Integer;
begin
  Result := False;

  nStr := 'Select D_Memo, D_Value from %s Where D_Name=''%s'' and ' +
          '(D_Memo=''%s'' or D_Memo=''%s'' or D_Memo=''%s'')';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,
                        sFlag_BatchAuto, sFlag_BatchBrand, sFlag_BatchValid]);
  //xxxxxx

  nUBatchAuto := sFlag_Yes;
  nUBatcode := sFlag_No;
  nUBrand := sFlag_No;
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if Fields[0].AsString = sFlag_BatchAuto then
          nUBatchAuto := Fields[1].AsString;

        if Fields[0].AsString = sFlag_BatchBrand then
          nUBrand  := Fields[1].AsString;

        if Fields[0].AsString = sFlag_BatchValid then
          nUBatcode  := Fields[1].AsString;

        Next;
      end;
    end;

  if nUBatcode <> sFlag_Yes then
  begin
    FOut.FData := '';
    Result := True;
    Exit;
  end;

  if nUBatchAuto = sFlag_Yes then
  begin
    nStr := 'Select *,%s as B_Now From %s Where B_Stock=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_Batcode, FIn.FData]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := '物料[ %s ]批次配置不存在.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nStr := FieldByName('B_UseDate').AsString;
      if nStr = sFlag_Yes then
      begin
        nP := FieldByName('B_Prefix').AsString;
        nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);

        nInt := FieldByName('B_Length').AsInteger;
        nVal := Length(nP + nStr) - nInt;

        if nVal > 0 then
        begin
          System.Delete(nStr, 1, nVal);
          FOut.FData := nP + nStr;
        end else
        begin
          nStr := StringOfChar('0', -nVal) + nStr;
          FOut.FData := nP + nStr;
        end;

        Result := True;
        Exit;
      end;

      nVal := Trunc(FieldByName('B_Now').AsDateTime) -
              Trunc(FieldByName('B_LastDate').AsDateTime);
      //时间差(天数)

      nInt := FieldByName('B_Interval').AsInteger;
      if nInt < 1 then nInt := 1;
      nInt := Trunc(nVal / nInt);

      nVal := FieldByName('B_Incement').AsInteger;
      nInt := nInt * nVal;
      nVal := FieldByName('B_Base').AsInteger + nInt;

      nStr := FieldByName('B_Prefix').AsString + IntToStr(nVal);
      nStr := StringOfChar('0', FieldByName('B_Length').AsInteger - Length(nStr));

      FOut.FData := FieldByName('B_Prefix').AsString + nStr + IntToStr(nVal);
      Result := True;
      if nInt < 1 then Exit;

      nStr := 'Update %s Set B_Base=%d,B_LastDate=%s Where B_Stock=''%s''';
      nStr := Format(nStr, [sTable_Batcode, nVal, sField_SQLServer_Now, FIn.FData]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    Exit;
  end;
  //自动获取批次号

  FListA.Clear;
  FListA.Text := FIn.FExtParam;
  nBrand     := FListA.Values['Brand'];
  nBatchOld  := FListA.Values['Batch'];
  nKDValue   := StrToFloat(FListA.Values['Value']);

  nStr := 'Select * from %s Where D_Stock=''%s'' and D_Valid=''%s'' '+
          'Order By D_UseDate';
  nStr := Format(nStr, [sTable_BatcodeDoc, FIn.FData, sFlag_BatchInUse]);
  //xxxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '物料[ %s ]批次不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    First;
    nBatchNew:='';
    nSelect:=sFlag_No;

    while not Eof do
    begin
      nStr := FieldByName('D_Brand').AsString;
      if (nUBrand=sFlag_Yes) and (nStr<>nBrand) then
      begin
        Next;
        Continue;
      end;
      //使用品牌时，品牌不对

      nValue := FieldByName('D_Plan').AsFloat - FieldByName('D_Sent').AsFloat +
                FieldByName('D_Rund').AsFloat - FieldByName('D_Init').AsFloat;
      if (nValue<=0) or ((nValue>0) and(nValue<nKDValue)) then
      begin
        Next;
        Continue;
      end;
      //剩余量小于等于零，或者剩余量小于开单量

      nStr := FieldByName('D_ID').AsString;
      if (nBatchOld<>'') and (nBatchOld=nStr) then
      begin
        nBatchNew := nStr;
        nSelect   := sFlag_Yes; 

        Break;
      end;
      //判断如果与传入批次相同，则将该批次回传

      if nSelect <> sFlag_Yes then
      begin
        nBatchNew := nStr;
        nSelect   := sFlag_Yes;
      end;
      //每次选择第一个有效的批次号

      Next;
    end;

    if nSelect <> sFlag_Yes then
    begin
      nData := '满足条件的物料[ %s ]批次不存在.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;  

    FOut.FData := nBatchNew;
    Result := True;
  end;
  //根据品牌号获取批次号   
end;

//------------------------------------------------------------------------------
//Date: 2015/5/14
//Parm: 
//Desc: 更新物料批次信息
function TWorkerBusinessCommander.SaveStockBatcode(var nData: string): Boolean;
var nStr,nUBrand,nUBatchAuto,nBrand, nBatch, nUBatcode: string;
    nKDValue,nSentValue: Double;
begin
  Result := False;

  nStr := 'Select D_Memo, D_Value from %s Where D_Name=''%s'' and ' +
          '(D_Memo=''%s'' or D_Memo=''%s'' or D_Memo=''%s'')';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,
                        sFlag_BatchAuto, sFlag_BatchBrand, sFlag_BatchValid]);
  //xxxxxx

  nUBatchAuto := sFlag_Yes;
  nUBatcode := sFlag_No;
  nUBrand := sFlag_No;
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if Fields[0].AsString = sFlag_BatchAuto then
          nUBatchAuto := Fields[1].AsString;

        if Fields[0].AsString = sFlag_BatchBrand then
          nUBrand  := Fields[1].AsString;

        if Fields[0].AsString = sFlag_BatchValid then
          nUBatcode  := Fields[1].AsString;

        Next;
      end;
    end;

  if (nUBatcode <> sFlag_Yes) or (nUBatchAuto = sFlag_Yes) then
  begin
    FOut.FData := '';
    Result := True;
    Exit;
  end;
  //自动获取批次号，无需更新

  FListA.Clear;
  FListA.Text := FIn.FData;

  nBatch     := FListA.Values['Batch'];
  nBrand     := FListA.Values['Brand'];
  nKDValue   := StrToFloat(FListA.Values['Value']);

  nStr := 'Select * from %s Where D_ID=''%s'' and D_Valid=''%s'' ';
  nStr := Format(nStr, [sTable_BatcodeDoc, nBatch, sFlag_BatchInUse]);
  //xxxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '批次[ %s ]不存在.';
      nData := Format(nData, [nBatch]);
      Exit;
    end;

    nStr := FieldByName('D_Brand').AsString;
    if (nUBrand=sFlag_Yes) and (nBrand <> nStr) then
    begin
      nData := '批次[ %s ]与品牌[ %s ]不对应.';
      nData := Format(nData, [nBatch,nStr]);
      Exit;
    end;
    //品牌错误

    nSentValue := FieldByName('D_Sent').AsFloat;
    if FIn.FExtParam = sFlag_Yes then      //增加已开量
      nSentValue := nSentValue + nKDValue
    else if FIn.FExtParam = sFlag_No then  //删除已开量
      nSentValue := nSentValue - nKDValue;
  end;
  //根据品牌号获取批次号

  if nSentValue>=0 then
  begin
    nStr := 'Update %s Set D_Sent=%f Where D_ID=''%s'' ';
    nStr := Format(nStr, [sTable_BatcodeDoc, nSentValue, nBatch]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新批次号已发数量，
  end;

  nStr := 'Update %s Set D_Valid=''%s'' ' +
          'Where (D_ID=''%s'') and (D_Plan-D_Sent+D_Rund+D_Init) < D_Warn';
  nStr := Format(nStr, [sTable_BatcodeDoc, sFlag_BatchOutUse, nBatch]);
  gDBConnManager.WorkerExec(FDBConn, nStr);
  //超过预警则封存批次号

  nStr := 'Update %s Set D_LastDate=null Where D_Valid=''%s'' ' +
          'And D_LastDate is not NULL';
  nStr := Format(nStr, [sTable_BatcodeDoc, sFlag_BatchInUse]);
  gDBConnManager.WorkerExec(FDBConn, nStr);
  //启用状态的批次号，去掉终止时间

  Result := True;
end;
{$ENDIF}

//Date: 2014-10-02
//Parm: 车牌号[FIn.FData];
//Desc: 保存车辆到sTable_Truck表
function TWorkerBusinessCommander.SaveTruck(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FIn.FData := UpperCase(FIn.FData);
  
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FData]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, FIn.FData, GetPinYinOfStr(FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2014-09-25
//Parm: 车牌号[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.GetTruckPoundData(var nData: string): Boolean;
var nStr: string;
    nPound: TLadingBillItems;
begin
  SetLength(nPound, 1);
  FillChar(nPound[0], SizeOf(TLadingBillItem), #0);

  nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
          'P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, FIn.FData, sFlag_PoundPD]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),nPound[0] do
  begin
    if RecordCount > 0 then
    begin
      FCusID      := FieldByName('P_CusID').AsString;
      FCusName    := FieldByName('P_CusName').AsString;
      FTruck      := FieldByName('P_Truck').AsString;

      FType       := FieldByName('P_MType').AsString;
      FStockNo    := FieldByName('P_MID').AsString;
      FStockName  := FieldByName('P_MName').AsString;

      with FPData do
      begin
        FStation  := FieldByName('P_PStation').AsString;
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;  

      FFactory    := FieldByName('P_FactID').AsString;
      FPModel     := FieldByName('P_PModel').AsString;
      FPType      := FieldByName('P_Type').AsString;
      FPoundID    := FieldByName('P_ID').AsString;

      FStatus     := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;
      FSelected   := True;
    end else
    begin
      FTruck      := FIn.FData;
      FPModel     := sFlag_PoundPD;

      FStatus     := '';
      FNextStatus := sFlag_TruckBFP;
      FSelected   := True;
    end;
  end;

  FOut.FData := CombineBillItmes(nPound);
  Result := True;
end;

//Date: 2014-09-25
//Parm: 称重数据[FIn.FData]
//Desc: 获取指定车牌号的称皮数据(使用配对模式,未称重)
function TWorkerBusinessCommander.SaveTruckPoundData(var nData: string): Boolean;
var nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  AnalyseBillItems(FIn.FData, nPound);
  //解析数据

  with nPound[0] do
  begin
    if FPoundID = '' then
    begin
      TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FTruck, '', @nOut);
      //保存车牌号

      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FPoundID := nOut.FData;
      //new id

      if FPModel = sFlag_PoundLS then
           nStr := sFlag_Other
      else nStr := sFlag_Provide;

      nSQL := MakeSQLByStr([
              SF('P_ID', FPoundID),
              SF('P_Type', nStr),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', sFlag_San),
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
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end else
    begin
      nStr := SF('P_ID', FPoundID);
      //where

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
      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
      end;

      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    FOut.FData := FPoundID;
    Result := True;
  end;
end;

{$IFDEF SHXZY}
function TWorkerBusinessCommander.SaveStatisticsTrucks(var nData: string): Boolean;
var nStr, nSQL: string;
    nPValue, nMValue, nValue: Double;
begin
  Result := True;
  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  if FIn.FExtParam = sFlag_Sale then
  begin
    nSQL := 'select L_ID as ID, L_Truck as Truck, L_OutFact as OutFact, ' +
            'L_PValue As PValue, L_MValue As MValue , L_Value As NetValue, ' +
            'tk.T_PValue As PrePValue ' +
            'From $BL bl ' +
            'Left Join $TK tk on tk.T_Truck=bl.L_Truck ' +
            'where L_ID In ($IN) And L_Value>=7.0';//' And L_CusType=''$ZY''';
    nSQL := MacroValue(nSQL, [MI('$BL', sTable_Bill) , MI('$IN', nStr),
            MI('$TK', sTable_Truck) ,MI('$ZY', sFlag_CusZY)]);
  end  else

  if FIn.FExtParam = sFlag_Provide then
  begin
    nSQL := 'select D_ID as ID, ob.O_Truck as Truck, D_OutFact as OutFact, ' +
            'D_PValue As PValue, D_MValue As MValue , D_MValue-D_PValue as ' +
            'NetValue, tk.T_PValue As PrePValue ' +
            'From $BL bl Left join $OB ob on bl.D_OID=ob.O_ID ' +
            'Left join $BO bo on bo.B_ID=ob.O_BID ' +
            'Left Join $TK tk on tk.T_Truck=ob.O_Truck ' +
            'where D_ID In ($IN)';
    nSQL := MacroValue(nSQL, [MI('$BL', sTable_OrderDtl) ,
            MI('$BO', sTable_OrderBase) , MI('$PP', sTable_Provider) ,
            MI('$FZY', sFlag_CusZYF) , MI('$TK', sTable_Truck) ,
            MI('$OB', sTable_Order) ,MI('$IN', nStr)]);
  end;

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '单据编号[%s]无效';
      nData := Format(nData, [nStr]);
      Exit;
    end;

    if FieldByName('PValue').AsFloat >= 1 then
         nPValue := FieldByName('PValue').AsFloat
    else nPValue := FieldByName('PrePValue').AsFloat;

    nValue := FieldByName('NetValue').AsFloat;

    if FieldByName('MValue').AsFLoat<=1 then
         nMValue := nPValue + nValue
    else nMValue := FieldByName('MValue').AsFloat;

    nSQL := MakeSQLByStr([SF('L_BID', FieldByName('ID').AsString),
            SF('L_Truck', FieldByName('Truck').AsString),
            SF('L_OutFact', sField_SQLServer_Now, sfVal),
            SF('L_PValue', nPValue, sfVal),
            SF('L_MValue', nMValue, sfVal),
            SF('L_Value', nValue, sfVal),
            SF('L_Type', FIn.FExtParam)], sTable_TruckLog, '', True);
    //xxxxx

    gDBConnManager.WorkerExec(FDBConn, nSQL);
  end;
end;

function TWorkerBusinessCommander.SaveFactZhiKa(var nData: string): Boolean;
var nSQL, nFactID, nFactZhiKa, nOwnZhiKa: string;
    nCard, nCardNO, nPswd: string;
    nOut: TWorkerBusinessCommand;
    nDBWorker: PDBWorker;
    nIdx: Integer;
begin
  Result := False;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if Trim(FListA.Text) = '' then Exit;

  nFactID := Trim(FListA.Values['OwnFactID']);
  nOwnZhiKa := Trim(FListA.Values['OwnZhiKa']);
  nFactZhiKa:= Trim(FListA.Values['FactZhiKa']);

  if nFactID = '' then
  begin
    nData := '贸易公司编号不能为空!';
    Exit;
  end;

  if (nOwnZhiKa = '') or (nFactZhiKa = '') then
  begin
    nData := '订单编号不能为空!';
    Exit;
  end;

  nDBWorker := nil;
  try
    nSQL := MacroValue(sQuery_ZhiKa, [MI('$Table', sTable_ZhiKa),
            MI('$ZID', nFactZhiKa)]);
    with gDBConnManager.SQLQuery(nSQL, nDBWorker, sFlag_DB_Master) do
    begin
      if RecordCount<1 then
      begin
        nData := '工厂系统中,订单编号 [ %s ] 不存在';
        nData := Format(nData, [nFactZhiKa]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('工厂系统中,订单[ %s ]已被管理员冻结.', [nFactZhiKa]);
        Exit;
      end;

      if FieldByName('Z_InValid').AsString = sFlag_Yes then
      begin
        nData := Format('工厂系统中,订单[ %s ]已被管理员作废.', [nFactZhiKa]);
        Exit;
      end;

      nSQL := FieldByName('Z_TJStatus').AsString;
      if nSQL  <> '' then
      begin
        if nSQL = sFlag_TJOver then
             nData := '工厂系统中,订单[ %s ]已调价,请重新开单.'
        else nData := '工厂系统中,订单[ %s ]正在调价,请稍后.';

        nData := Format(nData, [nFactZhiKa]);
        Exit;
      end;
    end;

    nSQL := MacroValue(sQuery_ZhiKa, [MI('$Table', sTable_ZhiKa),
            MI('$ZID', nOwnZhiKa)]);
    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount<1 then
      begin
        nData := '订单编号 [ %s ] 不存在';
        nData := Format(nData, [nOwnZhiKa]);
        Exit;
      end;

      if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      begin
        nData := Format('工厂系统中,订单[ %s ]已被管理员冻结.', [nOwnZhiKa]);
        Exit;
      end;

      if FieldByName('Z_InValid').AsString = sFlag_Yes then
      begin
        nData := Format('工厂系统中,订单[ %s ]已被管理员作废.', [nOwnZhiKa]);
        Exit;
      end;

      nSQL := FieldByName('Z_TJStatus').AsString;
      if nSQL  <> '' then
      begin
        if nSQL = sFlag_TJOver then
             nData := '工厂系统中,订单[ %s ]已调价,请重新开单.'
        else nData := '工厂系统中,订单[ %s ]正在调价,请稍后.';

        nData := Format(nData, [nOwnZhiKa]);
        Exit;
      end;

      nCard   := FieldByName('Z_Card').AsString;
      nCardNO := FieldByName('Z_CardNO').AsString;
      nPswd   := FieldByName('Z_Password').AsString;
    end;

    nSQL := 'Select F_ZID From %s Where F_Card=''%s'' And F_ZType=''%s''';
    nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, sFlag_BillMY]);
    with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
    if RecordCount > 0 then
    begin
      nData := 'IC卡 [ %s ] 已经绑定订单 [%s] 。';
      nData := Format(nData, [nCard, Fields[0].AsString]);
      Exit;
    end;
    //一张IC卡，只能绑定一张同类型的订单。

    FListC.Clear;
    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_MYZhiKa;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FListB.Clear;
    //xxxxx

    nSQL := MakeSQLByStr([SF('M_ID', nOut.FData),
            SF('M_MID', nOwnZhiKa),
            SF('M_FID', nFactZhiKa),

            SF('M_Fact', nFactID),
            SF('M_Man', FIn.FBase.FFrom.FUser),
            SF('M_Date', sField_SQLServer_Now, sfVal)],
            sTable_MYZhiKa, '', True);
    FListB.Add(nSQL);

    nSQL := MakeSQLByStr([SF('F_ZID', nOut.FData),
          SF('F_ZType', sFlag_BillMY),

          SF('F_Card',  nCard),
          SF('F_CardNO', nCardNO),
          SF('F_Password', nPswd),

          SF('F_CardType', sFlag_ICCardM),
          SF('F_ParentCard', '')
          ], sTable_ICCardInfo, '', True);
    FListB.Add(nSQL);

    nDBWorker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListB.Count-1 do
        gDBConnManager.WorkerExec(nDBWorker, FListB[nIdx]);

      nDBWorker.FConn.CommitTrans;
      Result := True;
    except
      nDBWorker.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

end;

function TWorkerBusinessCommander.VerifyMYZhiKaMoney(var nData: string): Boolean;
var nSQL, nStr, nFact, nDBID, nMYZK, nType: string;
    nMon1, nMon2, nCredit: Double;
    nItems: TStockParams;
    nDBWorker: PDBWorker;
    nIdx: Integer;
begin
  Result := False;
  AnalyseStockParams(FIn.FData, nItems);
  if Length(nItems) < 1 then Exit;
  //xxxxx

  nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
  nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
          MI('$ID', FIn.FExtParam)]);
  //Get Factory ID

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '贸易公司订单编号[ %s ]不存在!';
      nData := Format(nData, [FIn.FExtParam]);
      Exit;
    end;

    nFact := FieldByName('M_Fact').AsString;
    nMYZK := FieldByName('M_MID').AsString;
  end;

  nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
  //Get Factory DB ID

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '贸易公司编号[ %s ]数据库不存在!';
      nData := Format(nData, [nFact]);
      Exit;
    end;

    nDBID := Fields[0].AsString;
  end;

  nDBWorker := nil;
  try
    nSQL := 'Select Z_Customer,Z_Paytype,D_Price,D_StockNo From $ZK zk ' +
            'Left join $ZD zd on zd.D_ZID=zk.Z_ID ' +
            'Where Z_ID=''$ID''';
    nSQL := MacroValue(nSQL, [MI('$ZK', sTable_ZhiKa),
            MI('$ZD', sTable_ZhiKaDtl), MI('$ID', nMYZK)]);
    with gDBConnManager.SQLQuery(nSQL, nDBWorker, nDBID) do
    begin
      if RecordCount < 1 then
      begin
        nData := '贸易公司中不存在订单编号 [%s]';
        nData := Format(nData, [nMYZK]);
        Exit;
      end;

      First;
      while not Eof do
      try
        nStr := FieldByName('D_StockNO').AsString;

        for nIdx := Low(nItems) to High(nItems) do
        with nItems[nIdx] do
        if CompareText(FStockNO, nStr)=0 then
        begin
          FPrice   := FieldByName('D_Price').AsFloat;
          FIsExist := True;
        end;

        nStr := FieldByName('Z_Customer').AsString;
        nType:= FieldByName('Z_Paytype').AsString;
      finally
        Next;
      end;

      nMon1 := 0;
      for nIdx := Low(nItems) to High(nItems) do
      with nItems[nIdx] do
      if not FIsExist then
      begin
        nData := '贸易公司订单[%s]中不包含[%s]的品种!';
        nData := Format(nData, [nMYZK, FStockName]);
        Exit;
      end else nMon1 := nMon1 + Float2Float(FPrice * FValue, cPrecision, True);

      nSQL := 'Select * From %s Where A_CID=''%s'' And A_Type=''%s''';
      nSQL := Format(nSQL, [sTable_CusAccDetail, nStr, nType]);
    end;

    with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '编号为[ %s ]的客户账户不存在.';
        nData := Format(nData, [nStr]);
        Exit;
      end;      
      
      nMon2 :=FieldByName('A_BeginBalance').AsFloat +
                FieldByName('A_InMoney').AsFloat +
                FieldByName('A_RefundMoney').AsFloat -
                FieldByName('A_OutMoney').AsFloat -
                FieldByName('A_CardUseMoney').AsFloat -
                FieldByName('A_Compensation').AsFloat - //返利金额不参与正常发货
                FieldByName('A_FreezeMoney').AsFloat;
        //xxxxx        

      nCredit := FieldByName('A_CreditLimit').AsFloat;
      nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

      nMon2 := nMon2 + nCredit;
      nMon2 := Float2PInt(nMon2, cPrecision, False) / cPrecision;
    end;

    if FloatRelation(nMon1, nMon2, rtGreater) then
    begin
      nData := '贸易公司中,客户[%s]余额不足,须补交金额[%s]';
      nData := Format(nData, [nStr,
               FloatToStr(Float2Float(nMon1-nMon2, cPrecision, True))]);
      Exit;
    end;

    Result := True;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

function TWorkerBusinessCommander.SaveMYBills(var nData: string): Boolean;
var nSQL, nStr, nFact, nDBID, nMYZK: string;
    nItems: TLadingBillItems;
    nDBWorker: PDBWorker;
    nPrice, nVal: Double;
    nIdx, nJdx: Integer;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nItems);
  if Length(nItems) < 1 then Exit;
  //xxxxx

  nDBID := '';
  FListA.Clear;
  //SQL List

  nDBWorker := nil;
  try
    nJdx := -1;
    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if FZKType <> sFlag_BillMY then Continue;

      nJdx := nIdx;
      Break;
    end;
    //获取贸易公司订单索引

    if nJdx<Low(nItems) then
    begin
      nData := '不包含贸易公司订单!';
      Exit;
    end;

    with nItems[nJdx] do
    begin
      nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
      nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
              MI('$ID', FZhiKa)]);
      //Get Factory ID

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      begin
        if RecordCount < 1 then
        begin
          nData := '贸易公司订单编号[ %s ]不存在!';
          nData := Format(nData, [FZhiKa]);
          Exit;
        end;

        nFact := FieldByName('M_Fact').AsString;
        nMYZK := FieldByName('M_MID').AsString;
      end;

      nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
      //Get Factory DB ID

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      begin
        if RecordCount < 1 then
        begin
          nData := '贸易公司编号[ %s ]数据库不存在!';
          nData := Format(nData, [nFact]);
          Exit;
        end;

        nDBID := Fields[0].AsString;
      end;

      nSQL := 'Select * From %s Where Z_ID=''%s''';
      nSQL := Format(nSQL, [sTable_ZhiKa, nMYZK]);

      with gDBConnManager.SQLQuery(nSQL, nDBWorker, nDBID) do
      begin
        if RecordCount < 1 then
        begin
          nData := '贸易公司中,订单编号 [%s]不存在.';
          nData := Format(nData, [nMYZK]);
          Exit;
        end;
      end;
    end;
    //获取贸易公司数据库连接

    if FIn.FExtParam = sFlag_BillNew then   //新增
    begin
      for nIdx:=Low(nItems) to High(nItems) do
      with nItems[nIdx] do
      begin
        if FZKType <> sFlag_BillMY then Continue;

        nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
        nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
                MI('$ID', FZhiKa)]);
        //Get Factory ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司订单编号[ %s ]不存在!';
            nData := Format(nData, [FZhiKa]);
            Exit;
          end;

          nFact := FieldByName('M_Fact').AsString;
          nMYZK := FieldByName('M_MID').AsString;
        end;

        nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
        nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
        //Get Factory DB ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司编号[ %s ]数据库不存在!';
            nData := Format(nData, [nFact]);
            Exit;
          end;

          nStr := Fields[0].AsString;
          if (nDBID<>'') and (nStr<>nDBID) then
          begin
            nData := '不同贸易公司禁止拼单,详情如下:' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]';
            nData := Format(nData, [nItems[nIdx-1].FID, nDBID,
                     FID, nStr]);

            Exit;
          end;
        end;

        nSQL := 'Select zk.*,zd.*,' +
                'ht.C_Area,cus.C_Type,cus.C_Name,cus.C_PY,sm.S_Name ' +
                'From $ZK zk ' +
                ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
                ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
                ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
                ' Left Join $ZD zd On zd.D_ZID=Z_ID ' +
                'Where Z_ID=''$ZID'' And D_StockNo=''$SN''';

        nSQL := MacroValue(nSQL, [MI('$ZK', sTable_ZhiKa),
                MI('$HT', sTable_SaleContract),
                MI('$Cus', sTable_Customer),
                MI('$SM', sTable_Salesman),
                MI('$ZD', sTable_ZhiKaDtl),
                MI('$SN', FStockNo),
                MI('$ZID', nMYZK)]);
        //订单信息

        with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司中,订单编号 [%s] 或者 物料 [%s] 不存在.';
            nData := Format(nData, [nMYZK, FStockName]);
            Exit;
          end;

          if FieldByName('Z_Freeze').AsString = sFlag_Yes then
          begin
            nData := Format('订单[ %s ]已被管理员冻结.', [nMYZK]);
            Exit;
          end;

          if FieldByName('Z_InValid').AsString = sFlag_Yes then
          begin
            nData := Format('订单[ %s ]已被管理员作废.', [nMYZK]);
            Exit;
          end;

          nStr := FieldByName('Z_TJStatus').AsString;
          if nStr  <> '' then
          begin
            if nStr = sFlag_TJOver then
                 nData := '订单[ %s ]已调价,请重新开单.'
            else nData := '订单[ %s ]正在调价,请稍后.';

            nData := Format(nData, [nMYZK]);
            Exit;
          end;

          nPrice := FieldByName('D_Price').AsFloat;
          nVal   := Float2Float(nPrice * FValue, cPrecision, True);

          nSQL := MakeSQLByStr([SF('L_ID', FID),
                  SF('L_ZhiKa', FieldByName('Z_ID').AsString),
                  SF('L_Project', FieldByName('Z_Project').AsString),
                  SF('L_Area', FieldByName('C_Area').AsString),
                  SF('L_CusID', FieldByName('Z_Customer').AsString),
                  SF('L_CusType', FieldByName('C_Type').AsString),
                  SF('L_CusName', FieldByName('C_Name').AsString),
                  SF('L_CusPY', FieldByName('C_PY').AsString),
                  SF('L_SaleID', FieldByName('Z_SaleMan').AsString),
                  SF('L_SaleMan', FieldByName('S_Name').AsString),
                  SF('L_ICC', FieldByName('Z_CardNO').AsString),

                  SF('L_Paytype', FieldByName('Z_Paytype').AsString),
                  SF('L_Payment', FieldByName('Z_Payment').AsString),

                  SF('L_Seal', FSeal),
                  SF('L_Type', FType),
                  SF('L_StockNo', FStockNo),
                  SF('L_StockName', FStockName),
                  SF('L_Value', FValue, sfVal),
                  SF('L_Price', nPrice, sfVal),

                  SF('L_ZKMoney', FieldByName('Z_OnlyMoney').AsString),
                  SF('L_Truck', FTruck),
                  SF('L_Status', sFlag_BillNew)
                  ], sTable_Bill, '', True);
          FListA.Add(nSQL);

          nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) ' +
                  'Where A_CID=''%s'' And A_Type=''%s''';
          nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal),
                  FieldByName('Z_Customer').AsString,
                  FieldByName('Z_Paytype').AsString]);
          FListA.Add(nSQL);
        end;
      end;
    end else

    if FIn.FExtParam = sFlag_BillEdit then  //修改
    begin
      for nIdx:=Low(nItems) to High(nItems) do
      with nItems[nIdx] do
      begin
        if FZKType <> sFlag_BillMY then Continue;

        nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
        nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
                MI('$ID', FZhiKa)]);
        //Get Factory ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司订单编号[ %s ]不存在!';
            nData := Format(nData, [FZhiKa]);
            Exit;
          end;

          nFact := FieldByName('M_Fact').AsString;
          nMYZK := FieldByName('M_MID').AsString;
        end;

        nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
        nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
        //Get Factory DB ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司编号[ %s ]数据库不存在!';
            nData := Format(nData, [nFact]);
            Exit;
          end;

          nStr := Fields[0].AsString;
          if (nDBID<>'') and (nStr<>nDBID) then
          begin
            nData := '不同贸易公司禁止拼单,详情如下:' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]';
            nData := Format(nData, [nItems[nIdx-1].FID, nDBID,
                     FID, nStr]);

            Exit;
          end;
        end;

        nSQL := 'Select * From %s Where L_ID=''%s''';
        nSQL := Format(nSQL, [sTable_Bill, FID]);

        with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司中提货单号 [%s] 不存在';
            nData := Format(nData, [FID]);
            Exit;
          end;

          nPrice := FieldByName('L_Price').AsFloat;
          nVal   := -Float2Float(nPrice * FKZValue, cPrecision, False);

          nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal)
                  ], sTable_Bill, SF('L_ID', FID), False);
          FListA.Add(nSQL);

          nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) ' +
                  'Where A_CID=''%s'' And A_Type=''%s''';
          nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal),
                  FieldByName('L_CusID').AsString,
                  FieldByName('L_Paytype').AsString]);
          FListA.Add(nSQL); //更新纸卡冻结
        end;
      end;
    end else

    if FIn.FExtParam = sFlag_BillDone then   //完成
    begin
      for nIdx:=Low(nItems) to High(nItems) do
      with nItems[nIdx] do
      Begin
        if FZKType <> sFlag_BillMY then Continue;

        nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
        nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
                MI('$ID', FZhiKa)]);
        //Get Factory ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司订单编号[ %s ]不存在!';
            nData := Format(nData, [FZhiKa]);
            Exit;
          end;

          nFact := FieldByName('M_Fact').AsString;
          nMYZK := FieldByName('M_MID').AsString;
        end;

        nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
        nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
        //Get Factory DB ID

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司编号[ %s ]数据库不存在!';
            nData := Format(nData, [nFact]);
            Exit;
          end;

          nStr := Fields[0].AsString;
          if (nDBID<>'') and (nStr<>nDBID) then
          begin
            nData := '不同贸易公司禁止拼单,详情如下:' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]' + #13#10 +
                     '提货单号:[%s] 贸易公司编号:[%s]';
            nData := Format(nData, [nItems[nIdx-1].FID, nDBID,
                     FID, nStr]);

            Exit;
          end;
        end;

        nSQL := 'Select * From %s Where L_ID=''%s''';
        nSQL := Format(nSQL, [sTable_Bill, FID]);

        with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '提货单号 [%s] 不存在';
            nData := Format(nData, [FID]);
            Exit;
          end;

          nStr := MakeSQLByStr([
                  SF('L_Status', sFlag_TruckOut),
                  SF('L_NextStatus', ''),

                  SF('L_InTime', FieldByName('L_InTime').AsString),
                  SF('L_InMan', FieldByName('L_InMan').AsString),

                  SF('L_PValue', FieldByName('L_PValue').AsFloat, sfVal),
                  SF('L_PDate', FieldByName('L_PDate').AsString),
                  SF('L_PMan', FieldByName('L_PMan').AsString),

                  SF('L_LadeTime', FieldByName('L_LadeTime').AsString),
                  SF('L_LadeMan', FieldByName('L_LadeMan').AsString),

                  SF('L_MValue', FieldByName('L_PValue').AsFloat, sfVal),
                  SF('L_MDate', FieldByName('L_PDate').AsString),
                  SF('L_MMan', FieldByName('L_MMan').AsString),

                  SF('L_Card', ''),
                  SF('L_OutFact', sField_SQLServer_Now, sfVal),
                  SF('L_OutMan', FIn.FBase.FFrom.FUser)
                  ], sTable_Bill, SF('L_ID', FID), False);
          FListA.Add(nStr); //更新交货单
        end;
        //更新状态

        with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
        begin
          if RecordCount < 1 then
          begin
            nData := '贸易公司中提货单号 [%s] 不存在';
            nData := Format(nData, [FID]);
            Exit;
          end;

          nPrice := FieldByName('L_Price').AsFloat;
          nVal   := Float2Float(nPrice * FValue, cPrecision, False);

          nSQL := 'Update %s Set A_OutMoney=A_OutMoney+(%s),' +
                  'A_FreezeMoney=A_FreezeMoney-(%s) ' +
                  'Where A_CID=''%s'' And A_Type=''%s''';
          nSQL := Format(nSQL, [sTable_CusAccDetail, FloatToStr(nVal), FloatToStr(nVal),
                  FieldByName('L_CusID').AsString, FieldByName('L_Paytype').AsString]);
          FListA.Add(nSQL); //更新客户资金(可能不同客户)
        end;
      end;
    end;

    nDBWorker.FConn.BeginTrans;
    try
      for nJdx:=0 to FListA.Count-1 do
        gDBConnManager.WorkerExec(nDBWorker, FListA[nJdx]);

      nDBWorker.FConn.CommitTrans;
      Result := True;
    except
      nDBWorker.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

function TWorkerBusinessCommander.DeleteMYBill(var nData: string): Boolean;
var nSQL, nFact, nDBID, nMYZK, nP: string;
    nZK, nCus, nFix: string;
    nMoney, nVal: Double;
    nDBWorker: PDBWorker;
    nHasOut: Boolean;
    nIdx: Integer;
begin
  FListA.Clear;
  Result := False;
  //xxxxx

  nDBWorker := nil;
  try
    nSQL := 'Select * From $MYZhiKa Where M_ID=''$ID''';
    nSQL := MacroValue(nSQL, [MI('$MYZhiKa', sTable_MYZhiKa),
            MI('$ID', FIn.FExtParam)]);
    //Get Factory ID

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '贸易公司订单编号[ %s ]不存在!';
        nData := Format(nData, [FIn.FExtParam]);
        Exit;
      end;

      nFact := FieldByName('M_Fact').AsString;
      nMYZK := FieldByName('M_MID').AsString;
    end;

    nSQL := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nSQL := Format(nSQL, [sTable_SysDict, sFlag_SysParam, nFact]);
    //Get Factory DB ID

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      if RecordCount < 1 then
      begin
        nData := '贸易公司编号[ %s ]数据库不存在!';
        nData := Format(nData, [nFact]);
        Exit;
      end;
      nDBID := Fields[0].AsString;
    end;

    nSQL := 'Select L_ZhiKa,L_Value,L_Price,L_CusID,L_OutFact,L_Paytype,L_ZKMoney ' +
            'From %s Where L_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Bill, FIn.FData]);

    with gDBConnManager.SQLQuery(nSQL, nDBWorker, nDBID) do
    begin
      if RecordCount < 1 then
      begin
        nData := '交货单[ %s ]已无效.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;

      nHasOut := FieldByName('L_OutFact').AsString <> '';
      //已出厂

      {if nHasOut then
      begin
        nData := '交货单[ %s ]已出厂,不允许删除.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;   }

      nP   := FieldByName('L_Paytype').AsString;
      nZK  := FieldByName('L_ZhiKa').AsString;
      nCus := FieldByName('L_CusID').AsString;
      nFix := FieldByName('L_ZKMoney').AsString;

      nVal := FieldByName('L_Value').AsFloat;
      nMoney := Float2Float(nVal*FieldByName('L_Price').AsFloat, cPrecision, True);
    end;

    if nHasOut then
    begin
      nSQL := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nSQL := Format(nSQL, [sTable_CusAccDetail, nMoney, nCus, nP]);

      FListA.Add(nSQL);
      //释放出金
    end else
    begin
      nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%.2f) ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nSQL := Format(nSQL, [sTable_CusAccDetail, nMoney, nCus, nP]);

      FListA.Add(nSQL);
      //释放冻结金
    end;

    if nFix = sFlag_Yes then
    begin
      nSQL := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nSQL := Format(nSQL, [sTable_ZhiKa, nMoney, nZK]);
      FListA.Add(nSQL);
      //释放限提金额
    end;
    
    //--------------------------------------------------------------------------
    nSQL := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(nDBWorker, nSQL) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nSQL := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nSQL := MacroValue(nSQL, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', FIn.FData)]);
    FListA.Add(nSQL);

    nSQL := 'Delete From %s Where L_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Bill, FIn.FData]);
    FListA.Add(nSQL);

    nDBWorker.FConn.BeginTrans;
    try
      for nIdx:=0 to FListA.Count-1 do
        gDBConnManager.WorkerExec(nDBWorker, FListA[nIdx]);

      nDBWorker.FConn.CommitTrans;
      Result := True;
    except
      nDBWorker.FConn.RollbackTrans;
      raise;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;
{$ENDIF}

//Date: 2015/11/21
//Parm: 客户编号[FIn.FData];矫正已过期订单[FIn.FExtParam]
//Desc: 
function TWorkerBusinessCommander.AdjustCustomerMoney(var nData: string): Boolean;
begin
  Result := True;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
end.
