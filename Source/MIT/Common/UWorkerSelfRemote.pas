{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: �ͻ���ҵ����������
*******************************************************************************}
unit UWorkerSelfRemote;

interface

uses
  Windows, SysUtils, Classes, UMgrChannel, UChannelChooser, UBusinessWorker,
  UBusinessConst, UBusinessPacker, ULibFun;

type
  TRemote2MITWorker = class(TBusinessWorkerBase)
  protected
    FRemoteMITID: string;
    //Զ��MIT���
    FListA,FListB: TStrings;
    //�ַ��б�
    procedure WriteLog(const nEvent: string);
    //��¼��־
    function ErrDescription(const nCode,nDesc: string;
      const nInclude: TDynamicStrArray): string;
    //��������
    function MITWork(var nData: string): Boolean;
    //ִ��ҵ��
    function GetFixedServiceURL: string; virtual;
    //�̶���ַ
  public
    constructor Create; override;
    destructor destroy; override;
    //�����ͷ�
    function DoWork(const nIn, nOut: Pointer): Boolean; override;
    //ִ��ҵ��
  end;

  TClientWorkerQueryField = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessCommand = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessSaleBill = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessPurchaseOrder = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessRefund = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessHardware = class(TRemote2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

function CallRemoteWorker(const nCLIWorkerName: string; const nData,nExt,nMITID: string;
 const nOut: PWorkerBusinessCommand; const nCmd: Integer; const nSelfID: string=''): Boolean;
//������Ч���� 

implementation

uses
  UFormWait, Forms, USysLoger, UMITConst, USysDB, MIT_Service_Intf,
  UMgrParam, UMgrDBConn;

//Date: 2014-09-15
//Parm: ����;����;����;����;���
//Desc: ���ص���ҵ�����
function CallRemoteWorker(const nCLIWorkerName: string; const nData,nExt,nMITID: string;
 const nOut: PWorkerBusinessCommand; const nCmd: Integer;const nSelfID: string=''): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;
    nIn.FBase.FParam := nMITID;
    nIn.FBase.FKey   := nSelfID;

    nWorker := gBusinessWorkerManager.LockWorker(nCLIWorkerName);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-3-11
//Parm: ��־����
//Desc: ��¼��־
procedure TRemote2MITWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(ClassType, 'MIT���񻥷�ҵ�����', nEvent);
end;

constructor TRemote2MITWorker.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  inherited;
end;

destructor TRemote2MITWorker.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  inherited;
end;

//Date: 2012-3-11
//Parm: ���;����
//Desc: ִ��ҵ�񲢶��쳣������
function TRemote2MITWorker.DoWork(const nIn, nOut: Pointer): Boolean;
var nStr: string;
    nArray: TDynamicStrArray;
begin
  with PBWDataBase(nIn)^ do
  begin
    FRemoteMITID := FParam;
    FPacker.InitData(nIn, True, False);
    
    with FFrom do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;
  end;

  nStr := FPacker.PackIn(nIn);
  Result := MITWork(nStr);

  if not Result then
  begin
    PWorkerBusinessCommand(nOut).FData := nStr;
    WriteLog(nStr);
    Exit;
  end;  

  FPacker.UnPackOut(nStr, nOut);
  with PBWDataBase(nOut)^ do
  begin
    nStr := 'User:[ %s ] FUN:[ %s ] TO:[ %s ] KP:[ %d ]';
    nStr := Format(nStr, [gSysParam.FAppFlag, FunctionName, FVia.FIP,
            GetTickCount - FWorkTimeInit]);

    Result := FResult;
    if Result then
    begin
      if FErrCode = sFlag_ForceHint then
      begin
        nStr := 'ҵ��ִ�гɹ�,��ʾ��Ϣ����: ' + #13#10#13#10 + FErrDesc;
        WriteLog(nStr);
      end;

      Exit;
    end;

    SetLength(nArray, 0);
    nStr := 'ҵ��ִ���쳣,��������: ' + #13#10#13#10 +

            ErrDescription(FErrCode, FErrDesc, nArray) +

            '������������������Ƿ���Ч,����ϵ����Ա!' + #32#32#32;
    WriteLog(nStr);
  end;
end;

//Date: 2012-3-20
//Parm: ����;����
//Desc: ��ʽ����������
function TRemote2MITWorker.ErrDescription(const nCode, nDesc: string;
  const nInclude: TDynamicStrArray): string;
var nIdx: Integer;
begin
  FListA.Text := StringReplace(nCode, #9, #13#10, [rfReplaceAll]);
  FListB.Text := StringReplace(nDesc, #9, #13#10, [rfReplaceAll]);

  if FListA.Count <> FListB.Count then
  begin
    Result := '��.����: ' + nCode + #13#10 +
              '   ����: ' + nDesc + #13#10#13#10;
  end else Result := '';

  for nIdx:=0 to FListA.Count - 1 do
  if (Length(nInclude) = 0) or (StrArrayIndex(FListA[nIdx], nInclude) > -1) then
  begin
    Result := Result + '��.����: ' + FListA[nIdx] + #13#10 +
                       '   ����: ' + FListB[nIdx] + #13#10#13#10;
  end;
end;

//Desc: ǿ��ָ�������ַ
function TRemote2MITWorker.GetFixedServiceURL: string;
var nWorker: PDBWorker;
    nErrNum: Integer;
    nStr: string;
begin
  Result := '';
  nWorker := nil;

  with gParamManager.ActiveParam^ do
  try
    nWorker := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nWorker) then
    begin
      nStr := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nWorker.FConn.Connected then
      nWorker.FConn.Connected := True;
    //conn db

    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_RmtMITSrvURL, FRemoteMITID]);
    with gDBConnManager.WorkerQuery(nWorker, nStr) do
    if RecordCount > 0 then
      Result := Fields[0].AsString;
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;
end;

//Date: 2012-3-9
//Parm: �������
//Desc: ����MITִ�о���ҵ��
function TRemote2MITWorker.MITWork(var nData: string): Boolean;
var nChannel: PChannelItem;
begin
  Result := False;
  nChannel := nil;
  try
    nChannel := gChannelManager.LockChannel(cBus_Channel_Business);
    if not Assigned(nChannel) then
    begin
      nData := '����MIT����ʧ��(BUS-MIT No Channel).';
      Exit;
    end;

    with nChannel^ do
    while True do
    try
      if not Assigned(FChannel) then
        FChannel := CoSrvBusiness.Create(FMsg, FHttp);
      //xxxxx

      if GetFixedServiceURL = '' then
      begin
        nData := 'δ����Զ��MIT�����ַ.';
        Exit;
      end
      else FHttp.TargetURL := GetFixedServiceURL;

      Result := ISrvBusiness(FChannel).Action(GetFlagStr(cWorker_GetMITName),
                                              nData);
      //call mit funciton
      Break;
    except
      on E:Exception do
      begin
        if (GetFixedServiceURL <> '') or
           (gChannelChoolser.GetChannelURL = FHttp.TargetURL) then
        begin
          nData := Format('%s(BY %s ).', [E.Message, gSysParam.FLocalName]);
          WriteLog('Function:[ ' + FunctionName + ' ]' + E.Message);
          Exit;
        end;
      end;
    end;
  finally
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerQueryField.FunctionName: string;
begin
  Result := sCLI_GetQueryField;
end;

function TClientWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
   cWorker_GetMITName    : Result := sBus_GetQueryField;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessCommand.FunctionName: string;
begin
  Result := sCLI_BusinessCommand;
end;

function TClientBusinessCommand.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessCommand;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessSaleBill.FunctionName: string;
begin
  Result := sCLI_BusinessSaleBill;
end;

function TClientBusinessSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessPurchaseOrder.FunctionName: string;
begin
  Result := sCLI_BusinessPurchaseOrder;
end;

function TClientBusinessPurchaseOrder.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessPurchaseOrder;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessRefund.FunctionName: string;
begin
  Result := sCLI_BusinessRefund;
end;

function TClientBusinessRefund.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessRefund;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessHardware.FunctionName: string;
begin
  Result := sCLI_HardwareCommand;
end;

function TClientBusinessHardware.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_HardwareCommand;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TClientWorkerQueryField, sPlug_ModuleRemote);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessCommand, sPlug_ModuleRemote);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessSaleBill, sPlug_ModuleRemote);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessHardware, sPlug_ModuleRemote);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessRefund, sPlug_ModuleRemote);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessPurchaseOrder, sPlug_ModuleRemote);
end.
