{*******************************************************************************
  ����: dmzn@163.com 2013-07-20
  ����: LEDС����ʾ
*******************************************************************************}
unit UMgrLEDDisp;

interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, USysLoger, UWaitItem,
  ULibFun, IdTCPConnection, IdTCPClient, IdGlobal, Forms,
  UYBLEDSDK, JclUnicode, Graphics;

const
  cDisp_KeepLong   = 30 * 1000;     //���ݱ���ʱ��
  cLED_YangBangKeJi = 'YBKJ';
  cLED_UnKnown      = 'UNKNOWN';

type
  TPTConnType = (ctTCP, ctCOM);
  //��·����: ����,����

  PLEDFont = ^TLEDFont;
  PComPort = ^TComPort;
  PHostPort = ^THostPort;
  PDispCard = ^TDispCard;

  TComPort = record
    FPort: string;                 //�˿�
    FRate: Integer;                //������
    FDatabit: Integer;             //����λ
    FStopbit: Integer;             //��ͣλ
    FParitybit: Boolean;           //У��λ
  end;

  THostPort = record
    FHost: string;
    FPort: Integer;
  end;

  TLEDFont = record
    FName: String;
    FSize: Integer;
    FBold: Boolean;
    FKeep: Integer;
    FSpeed: Integer;
    FEffect: Integer;
  end;

  TDispCard = record
    FID: string;
    FName: string;
    FShowDefault: Boolean;           //������ʾĬ����Ϣ

    FVer: String;                    //�汾����
    FType: string;                   //����
    FConn: TPTConnType;              //��·

    FAddr: Integer;                  //����ַ
    FKeepLong: Int64;
    FLastUpdate: Int64;              //������ʾʱ��

    FComPort: TComPort;
    FHostPort: THostPort;

    FWidth  : Integer;
    FHeight : Integer;
    FDataDA : Integer;
    FDataOE : Integer;

    FAllRect: TRect;
    FFontLED: TLEDFont;
  end;

  PDispContent = ^TDispContent;
  TDispContent = record
    FID: string;
    FText: string;
  end;

type
  TDisplayManager = class;
  TDisplayControler = class(TThread)
  private
    FOwner: TDisplayManager;
    //ӵ����
    FBuffer: TList;
    //��ʾ����
    FClient: TIdTCPClient;
    //������·
    FWaiter: TWaitObject;
    //�ȴ�����
    FFileOpt: TStrings;
    FFileUTF: TWideStringList;
    //�ļ�����
  protected
    procedure DoExuecte(const nCard: PDispCard);
    procedure Execute; override;
    //ִ���߳�
    procedure AddContent(const nContent: PDispContent);
    //�������
    procedure SendText(const nCard: PDispCard);
    procedure SendUnKnownTypeText(const nCard: PDispCard);
    procedure SendYBKJTypeText(const nCard: PDispCard; const nTxt: string='');
  public
    constructor Create(AOwner: TDisplayManager);
    destructor Destroy; override;
    //�����ͷ�
    procedure WakupMe;
    //�����߳�
    procedure StopMe;
    //ֹͣ�߳�
  end;

  TDisplayManager = class(TObject)
  private
    FControler: TDisplayControler;
    //��ʾ����
    FCards: array of TDispCard;
    //�豸�б�
    FEnabled: Boolean;
    FDefault: string;
    //Ĭ������
    FTempDir: string;
    //��ʱ�ļ���
    FBuffData: TList;
    //���ݻ���
    //FDLLHandle: THandle;
    FSyncLock: TCriticalSection;
    //ͬ����
  protected
    procedure ClearBuffer(const nList: TList; const nFree: Boolean = False);
    //������Դ
  public
    constructor Create;
    destructor Destroy; override;
    //�����ͷ�
    procedure LoadConfig(const nFile: string);
    //��ȡ����
    procedure StartDisplay;
    procedure StopDisplay;
    //��ͣ��ʾ
    procedure Display(const nID,nText: string);
    //��ʾ����

    property TempDir: string read FTempDir write FTempDir;
    //��ʱ�ļ���
    property DefaultTxt: string read FDefault write FDefault;
    //Ĭ����ʾ
  end;

var
  gDisplayManager: TDisplayManager = nil;
  //ȫ��ʹ��

implementation

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TDisplayManager, 'LED��ʾ����', nEvent);
end;

constructor TDisplayManager.Create;
begin
  FBuffData := TList.Create;
  FSyncLock := TCriticalSection.Create;
  //FDLLHandle := InitDLLResource(Application.Handle);
  FTempDir  := ExtractFilePath(ParamStr(0)) + 'Temp\';
end;

destructor TDisplayManager.Destroy;
begin
  StopDisplay;
  ClearBuffer(FBuffData, True);

  FSyncLock.Free;
  //FreeDLLResource;
  inherited;
end;

procedure TDisplayManager.ClearBuffer(const nList: TList; const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx := nList.Count - 1 downto 0 do
  begin
    Dispose(PDispContent(nList[nIdx]));
    nList.Delete(nIdx);
  end;

  if nFree then
    nList.Free;
  //xxxxx
end;

procedure TDisplayManager.StartDisplay;
begin
  if FEnabled and (Length(FCards) > 0) then
  begin
    if not Assigned(FControler) then
      FControler := TDisplayControler.Create(Self);
    FControler.WakupMe;
  end;
end;

procedure TDisplayManager.StopDisplay;
begin
  if Assigned(FControler) then
    FControler.StopMe;
  FControler := nil;
end;

//Date: 2013-07-20
//Parm: ��ʶ;����
//Desc: ��nID������ʾnText
procedure TDisplayManager.Display(const nID,nText: string);
var nItem: PDispContent;
begin
  if not Assigned(FControler) then Exit;
  //no controler

  FSyncLock.Enter;
  try
    New(nItem);
    FBuffData.Add(nItem);

    nItem.FID := nID;
    nItem.FText := nText;
    FControler.WakupMe;
  finally
    FSyncLock.Leave;
  end;   
end;

//Desc: ����nFile�����ļ�
procedure TDisplayManager.LoadConfig(const nFile: string);
var nNode,nTmp,nJmp: TXmlNode;
    nIdx,nInt: Integer;
    nXML: TNativeXml;
    nStr: string;
begin
  nXML := TNativeXml.Create;
  try
    nInt := 0;
    SetLength(FCards, 0);
    nXML.LoadFromFile(nFile);

    nNode := nXML.Root.NodeByName('config');
    FEnabled := nNode.NodeByName('enable').ValueAsString = '1';
    FDefault := nNode.NodeByName('default').ValueAsString;

    for nIdx:=nXML.Root.NodeCount - 1 downto 0 do
    begin
      nNode := nXML.Root.Nodes[nIdx];
      if CompareText(nNode.Name, 'card') <> 0 then Continue;

      nTmp := nNode.FindNode('enable');
      if (not Assigned(nTmp)) or (nTmp.ValueAsString <> '1') then Continue;
      //not valid card

      SetLength(FCards, nInt + 1);
      with FCards[nInt],nNode do
      begin
        FID := AttributeByName['ID'];
        FName := AttributeByName['Name'];
        FAddr := NodeByName('addr').ValueAsInteger;

        nTmp := FindNode('conn');
        if Assigned(nTmp) then
             nStr := nTmp.ValueAsString
        else nStr := 'com';

        if CompareText('tcp', nStr) = 0 then
             FConn := ctTCP
        else FConn := ctCOM;

        nTmp := FindNode('type');
        if Assigned(nTmp) then
             FType := nTmp.ValueAsString
        else FType := cLED_UnKnown;

        nTmp := FindNode('Version');
        if Assigned(nTmp) then
             FVer := nTmp.ValueAsString
        else FVer := cLED_UnKnown;

        nTmp := nNode.FindNode('hight');
        if Assigned(nTmp) then
             FHeight := nTmp.ValueAsInteger
        else FHeight := 240;

        nTmp := nNode.FindNode('width');
        if Assigned(nTmp) then
             FWidth := nTmp.ValueAsInteger
        else FWidth := 120;

        nTmp := nNode.FindNode('DataOE');
        if Assigned(nTmp) then
             FDataOE := nTmp.ValueAsInteger
        else FDataOE := 0;

        nTmp := nNode.FindNode('DataDA');
        if Assigned(nTmp) then
             FDataDA := nTmp.ValueAsInteger
        else FDataDA := 0;

        nTmp := nNode.FindNode('KeepLong');
        if Assigned(nTmp) then
             FKeepLong := nTmp.ValueAsInteger * 1000
        else FKeepLong := cDisp_KeepLong;

        case FConn of
          ctTCP:
          begin
            nTmp := FindNode('Host');
            with FHostPort do
            begin
              FHost := nTmp.NodeByName('ip').ValueAsString;
              FPort := nTmp.NodeByName('Port').ValueAsInteger;
            end;
          end;
          ctCom:
          begin
            nTmp := FindNode('com');
            with FComPort do
            begin
              FPort := nTmp.NodeByName('port').ValueAsString;
              FRate := nTmp.NodeByName('rate').ValueAsInteger;

              nJmp := nTmp.FindNode('databit');
              if Assigned(nJmp) then
                   FDatabit := nJmp.ValueAsInteger
              else FDatabit := 8;

              nJmp := nTmp.FindNode('stopbit');
              if Assigned(nJmp) then
                   FStopbit := nJmp.ValueAsInteger
              else FStopbit := 1;

              nJmp := nTmp.FindNode('paritybit');
              if Assigned(nJmp) then
                   FParitybit := nJmp.ValueAsString <> 'N'
              else FParitybit := False;
            end;
          end;
        end;

        nTmp := FindNode('font');
        if Assigned(nTmp) then
        begin
          nJmp := nTmp.FindNode('rect');
          if Assigned(nJmp) then
          with FAllRect,nJmp do
          begin
            Left := StrToInt(AttributeByName['L']);
            Top := StrToInt(AttributeByName['T']);
            Right := Left + StrToInt(AttributeByName['W']);
            Bottom := Top + StrToInt(AttributeByName['H']);
          end;

          FFontLED.FName := nTmp.NodeByName('name').ValueAsString;
          FFontLED.FSize := nTmp.NodeByName('size').ValueAsInteger;
          FFontLED.FBold := nTmp.NodeByName('bold').ValueAsInteger > 0;
          FFontLED.FKeep := nTmp.NodeByName('keep').ValueAsInteger;
          FFontLED.FSpeed := nTmp.NodeByName('speed').ValueAsInteger;
          FFontLED.FEffect := nTmp.NodeByName('effect').ValueAsInteger;
        end;

        FShowDefault:= True;
        FLastUpdate := 0;
        Inc(nInt);
      end;
    end;
  finally
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor TDisplayControler.Create(AOwner: TDisplayManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;

  FBuffer := TList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 2000;

  FClient := TIdTCPClient.Create;
  FClient.ReadTimeout := 5 * 1000;
  FClient.ConnectTimeout := 5 * 1000;

  FFileOpt := TStringList.Create;
  FFileUTF := TWideStringList.Create;
end;

destructor TDisplayControler.Destroy;
begin
  FClient.Disconnect;
  FClient.Free;

  FFileOpt.Free;
  FFileUTF.Free;

  FOwner.ClearBuffer(FBuffer, True);
  FWaiter.Free;
  inherited;
end;

procedure TDisplayControler.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TDisplayControler.WakupMe;
begin
  FWaiter.Wakeup;
end;

//Desc: ���������,���������
procedure TDisplayControler.AddContent(const nContent: PDispContent);
var nIdx: Integer;
    nItem: PDispContent;
begin
  for nIdx:=FBuffer.Count - 1 downto 0 do
  begin
    nItem := FBuffer[nIdx];
    if nItem.FID = nContent.FID then
    begin
      Dispose(nItem);
      FBuffer.Delete(nIdx);
    end;
  end;

  FBuffer.Add(nContent);
  //�����ʾ����

  for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
   if CompareText(FOwner.FCards[nIdx].FID, nContent.FID) = 0 then
    FOwner.FCards[nIdx].FLastUpdate := GetTickCount;
  //update status
end;

procedure TDisplayControler.Execute;
var nStr: string;
    nIdx: Integer;
    nContent: PDispContent;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FOwner.FSyncLock.Enter;
    try
      for nIdx:=0 to FOwner.FBuffData.Count - 1 do
        AddContent(FOwner.FBuffData[nIdx]);
      FOwner.FBuffData.Clear;
    finally
      FOwner.FSyncLock.Leave;
    end;

    for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
    if (GetTickCount - FOwner.FCards[nIdx].FLastUpdate >=
       FOwner.FCards[nIdx].FKeepLong) then
    begin
      if FOwner.FCards[nIdx].FShowDefault then Continue;
      FOwner.FCards[nIdx].FShowDefault := True;

      nStr := StringReplace(FOwner.FDefault, 'dt', Date2Str(Now),
              [rfReplaceAll, rfIgnoreCase]);
      //date item

      nStr := StringReplace(nStr, 'wk', Date2Week(),
              [rfReplaceAll, rfIgnoreCase]);
      //week item

      nStr := StringReplace(nStr, 'tm', Time2Str(Now),
              [rfReplaceAll, rfIgnoreCase]);
      //week item

      New(nContent);
      FBuffer.Add(nContent);

      nContent.FID := FOwner.FCards[nIdx].FID;
      nContent.FText := nStr;
      //default content
    end;

    if FBuffer.Count > 0 then
    try
      for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
        DoExuecte(@FOwner.FCards[nIdx]);
      //send contents
    finally
      FOwner.ClearBuffer(FBuffer);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Date: 2013-07-20
//Parm: �ַ�
//Desc: ��ȡnTxt������
function ConvertStr(const nTxt: WideString; var nBuf: TIdBytes): Integer;
var nStr: string;
    nIdx: Integer;
begin
  Result := 0;
  nStr := nTxt;
  SetLength(nBuf, Length(nStr));

  for nIdx:=1 to Length(nTxt) do
  begin
    nStr := nTxt[nIdx];
    nBuf[Result] := Ord(nStr[1]);
    Inc(Result);

    if Length(nStr) = 2 then
    begin
      nBuf[Result] := Ord(nStr[2]);
      Inc(Result);
    end;
  end;
end;

//Desc: ��ʾ����
procedure TDisplayControler.DoExuecte(const nCard: PDispCard);
begin
  if UpperCase(nCard.FType) = cLED_UnKnown then
       SendUnKnownTypeText(nCard)
  else SendText(nCard);
end;

procedure TDisplayControler.SendText(const nCard: PDispCard);
var nIdx: Integer;
    nContent: PDispContent;
begin
  if not Terminated then
  try
    if nCard.FType = cLED_YangBangKeJi then
    begin
      for nIdx:=FBuffer.Count - 1 downto 0 do
      begin
        nContent := FBuffer[nIdx];
        if CompareText(nContent.FID, nCard.FID) <> 0 then Continue;
        if CompareText(FOwner.FDefault, nContent.FText) <> 0 then
          nCard.FShowDefault := False;

        SendYBKJTypeText(nCard, nContent.FText);
        nCard.FLastUpdate := GetTickCount;
      end;
    end;
  finally
  end;
end;

procedure TDisplayControler.SendUnKnownTypeText(const nCard: PDispCard);
var nIdx: Integer;
    nBuf: TIdBytes;
    nContent: PDispContent;
begin
  if not Terminated then
  try
    if nCard.FConn <> ctTcp then Exit;
    //Ĭ��Ϊ���ڷ���

    if nCard.FHostPort.FHost = '' then Exit;
    //�������ַ

    if FClient.Connected and ((FClient.Host <> nCard.FHostPort.FHost) or (
       FClient.Port <> nCard.FHostPort.FPort)) then
    begin
      FClient.Disconnect;
      if Assigned(FClient.IOHandler) then
        FClient.IOHandler.InputBuffer.Clear;
      //try to swtich connection
    end;

    if not FClient.Connected then
    begin
      FClient.Host := nCard.FHostPort.FHost;
      FClient.Port := nCard.FHostPort.FPort;
      FClient.Connect;
    end;

    for nIdx:=FBuffer.Count - 1 downto 0 do
    begin
      nContent := FBuffer[nIdx];
      if CompareText(nContent.FID, nCard.FID) <> 0 then Continue;
      ConvertStr(Char($40) + Char(nCard.FAddr) + nContent.FText + #13, nBuf);
      FClient.Socket.Write(nBuf);

      nCard.FLastUpdate := GetTickCount;
    end;
  except
    FClient.Disconnect;
    if Assigned(FClient.IOHandler) then
      FClient.IOHandler.InputBuffer.Clear;
    //close connection

    WriteLog(Format('��С��[ %s ]������ʾ����ʧ��.', [nCard.FName]));
    //loged
  end;
end;

procedure TDisplayControler.SendYBKJTypeText(const nCard: PDispCard;
  const nTxt: string);
var nRes, nIdx, nType, nArea, nSendMode: Integer;
    nStr: String;
begin
  try
    nIdx := GetScreenControlIndex(nCard.FVer);
    if (nIdx < CONTROLLER_BX_5AT_INDEX) or (nIdx > CONTROLLER_BX_5QSP_INDEX) then
      Exit;

    nType:= GetScreenControlTypeValue(nIdx);

    case nCard.FConn of
    ctTCP: nSendMode := SEND_MODE_NET;
    ctCom: nSendMode := SEND_MODE_COMM;
    else
      Exit;
    end;

    try
      nRes := DeleteScreen(nCard.FAddr);
      if (nRes<>RETURN_NOERROR) and (nRes<>RETURN_ERROR_NOFIND_SCREENNO) then
      begin
        WriteLog(Format('DeleteScreen:%s', [GetErrorDesc(nRes)]));
        Exit;
      end;
    except
      //ignor any error
    end;

    nRes := AddScreen(nType, nCard.FAddr, nCard.FWidth, nCard.FHeight, 1, 2,
            nCard.FDataDA, nCard.FDataOE, 0, 0, PChar(nCard.FComPort.FPort),
            nCard.FComPort.FRate, PChar(nCard.FHostPort.FHost),
            nCard.FHostPort.FPort, PChar(nCard.FHostPort.FHost),
            nCard.FHostPort.FPort, nil);
    if nRes <> RETURN_NOERROR then
    begin
      WriteLog(Format('AddScreen:%s', [GetErrorDesc(nRes)]));
      Exit;
    end;

    nRes := AddScreenProgram(nCard.FAddr, 0, 0, 65535, 11, 26, 2011,
            11, 26, 1, 1, 1, 1, 1, 1, 1, 0, 0, 23, 59);
    if nRes <> RETURN_NOERROR then
    begin
      WriteLog(Format('AddScreenProgram:%s', [GetErrorDesc(nRes)]));
      Exit;
    end;

    with nCard.FAllRect do
     nRes := AddScreenProgramBmpTextArea(nCard.FAddr, 0, Left, Top,
             Right-Left, Bottom-Top);
    //xxxxx

    if nRes <> RETURN_NOERROR then
    begin
      WriteLog(Format('AddScreenProgramBmpTextArea:%s', [GetErrorDesc(nRes)]));
      Exit;
    end else nArea := 0; 

    if not DirectoryExists(FOwner.TempDir) then
      ForceDirectories(FOwner.TempDir);
    nStr := FOwner.TempDir + cSend_File;
    //normal txt file

    FFileOpt.Text := nTxt;
    FFileOpt.SaveToFile(nStr);
    Sleep(1000); //wait I/O

    with nCard.FFontLED do
    begin
      if FBold then
           nIdx := 1
      else nIdx := 0;

      nRes := AddScreenProgramAreaBmpTextFile(nCard.FAddr, 0, nArea,
              PChar(nStr), 1,
              PChar(FName), FSize, nIdx, clYellow, FEffect, FSpeed, FKeep);
              //PChar('����'), 14, 0, clYellow, 6, 23, 0)
      //xxxxx
    end;

    if nRes <> RETURN_NOERROR then
    begin
      WriteLog(Format('AddScreenProgramAreaBmpTextFile:%s', [GetErrorDesc(nRes)]));
      Exit;
    end;

    //--------------------------------------------------------------------------
    nRes := SendScreenInfo(nCard.FAddr, nSendMode, SEND_CMD_SENDALLPROGRAM, 0);
    if nRes <> RETURN_NOERROR then
      WriteLog(Format('SendScreenInfo:%s', [GetErrorDesc(nRes)]));
    //xxxxx

    {$IFDEF DEBUG}
    WriteLog('��Ļ:' + FNowItem.FName + '���ݷ������.');
    {$ENDIF}   
  except
    On E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;    

initialization
  gDisplayManager := TDisplayManager.Create;
finalization
  FreeAndNil(gDisplayManager);
end.
