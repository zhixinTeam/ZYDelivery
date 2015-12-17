{*******************************************************************************
  作者: fendou116688@163.com 2015/12/5
  描述: 读IC卡
*******************************************************************************}
unit UFormReadICCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxRadioGroup, cxMaskEdit,
  cxDropDownEdit;

type
  TfFormReadICCard = class(TfFormNormal)
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    BtnRead: TButton;
    dxLayout1Item5: TdxLayoutItem;
    EditCardType: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    EditCardNO: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditBillType: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditBillNO: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure BtnReadClick(Sender: TObject);
    procedure EditBillNOPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FICDevice: LongInt;
    FICBeep  : Boolean;
    FCommandType : LongInt;
    //接收缓冲
    FParam: PFormCommandParam;
    procedure InitFormData;
    procedure LoadCardInfo(nCard: string);
    procedure ActionComPort(const nStop: Boolean);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

  TCardInfo = record
    FCard    : String; //磁卡编号
    FCardNO  : string; //卡序列号
    FCardType: string; //卡类型

    FZKID    : string; //订单编号
    FZKType  : string; //订单类型
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB,
  UMgrURFR300_Head, UDataModule, UAdjustForm;

var
  gCards: array of TCardInfo;

class function TfFormReadICCard.FormID: integer;
begin
  Result := cFI_FormReadICCard;
end;

class function TfFormReadICCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormReadICCard.Create(Application) do
  try
    if not Assigned(nParam) then
    begin
      New(FParam);
      FillChar(FParam, SizeOf(TFormCommandParam), #0);
    end else FParam := nParam;

    InitFormData;
    ActionComPort(False);

    FCommandType := FParam.FParamA;

    case FCommandType of
    cCmd_AddData:
    begin
      Caption := '办理IC卡';
      SetCtrlData(EditCardType, FParam.FParamB);
      SetCtrlData(EditBillType, FParam.FParamD);
      EditBillNO.Text := FParam.FParamC;
    end;
    cCmd_ViewData:
    begin
      Caption := '读取IC卡';
    end;  
    else
    Close;
    end;

    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA := ShowModal;
    FParam.FParamB := Trim(EditCard.Text);
    FParam.FParamC := Trim(EditCardNO.Text);
    FParam.FParamD := Trim(EditBillNO.Text);
    FParam.FParamE := GetCtrlData(EditBillType);
    FParam.FParamF := GetCtrlData(EditCardType);
  finally
    if not Assigned(nParam) then Dispose(FParam);
    Free;
  end;
end;

procedure TfFormReadICCard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActionComPort(True);
end;

procedure TfFormReadICCard.InitFormData;
var nStr: string;
begin
  if EditBillType.Properties.Items.Count<1 then
  begin
    nStr := 'D_Memo=Select D_Value,D_Memo From %s Where D_Name=''%s'' ' +
            'And D_Index>=0 Order By D_Index DESC';
    nStr := Format(nStr, [sTable_SysDict, sFlag_ZhiKaItem]);
    //订单类型

    AdjustStringsItem(EditBillType.Properties.Items, True);
    FDM.FillStringsData(EditBillType.Properties.Items, nStr, -1, '.',
      DSA(['D_Memo']));
  
    AdjustStringsItem(EditBillType.Properties.Items, False);

    if EditBillType.Properties.Items.Count>0 then
      EditBillType.ItemIndex := 0;
  end;

  if EditCardType.Properties.Items.Count<1 then
  begin
    nStr := 'D_Memo=Select D_Value,D_Memo From %s Where D_Name=''%s'' ' +
            'And D_Index>=0 Order By D_Index';
    nStr := Format(nStr, [sTable_SysDict, sFlag_ICCardItem]);
    //订单类型

    AdjustStringsItem(EditCardType.Properties.Items, True);
    FDM.FillStringsData(EditCardType.Properties.Items, nStr, -1, '.',
      DSA(['D_Memo']));
  
    AdjustStringsItem(EditCardType.Properties.Items, False);

    if EditCardType.Properties.Items.Count>0 then
      EditCardType.ItemIndex := 0;
  end;

  ActiveControl := EditCard;
end;

//Desc: 串口操作
procedure TfFormReadICCard.ActionComPort(const nStop: Boolean);
var nInt: Integer;
    nIni: TIniFile;
    nStatus:Array[0..18]of Char;
begin
  if nStop then
  begin
    if FICDevice>0 then rf_exit(FICDevice);
    FICDevice := 0;
    Exit;
  end;

  FICDevice := 0;
  nIni := TIniFile.Create(gPath + 'ICReader.Ini');

  try
    nInt := nIni.ReadInteger('Param', 'Enable', 0);
    if nInt <> 1 then Exit;
    FICBeep := nIni.ReadInteger('Param', 'Beep', 0) = 1;

    FICDevice := rf_init(0,115200);
    if FICDevice <=0 then
    begin
      ShowMsg('打开IC读卡器失败', sHint);
      Exit;
    end;

    nInt := rf_get_status(FICDevice, @nStatus);
    if nInt <> 0 then
    begin
      ShowMsg('IC读卡器初始化失败', sHint);
      Exit;
    end;  
  finally
    nIni.Free;
  end;
end;

procedure TfFormReadICCard.EditCardKeyPress(Sender: TObject; var Key: Char);
var nCard: string;
begin
  if Key = #13 then
  begin
    Key := #0;

    if FCommandType <> cCmd_ViewData then Exit;
    //仅只有读取磁卡时，才能匹配
    
    nCard := Trim(EditCard.Text);
    if Length(nCard) < 6 then Exit;

    LoadCardInfo(nCard);

  end else OnCtrlKeyPress(Sender, Key);
end;

procedure TfFormReadICCard.LoadCardInfo(nCard: string);
var nSQL: string;
    nInt: Integer;
begin
  nCard := Trim(nCard);
  if nCard = '' then Exit;

  nSQL := 'Select * From %s Where (F_Card = ''%s'') or ' +
          '(F_CardNO = ''%s'') ';
  nSQL := Format(nSQL, [sTable_ICCardInfo, nCard, nCard]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount>0 then
  begin
    SetLength(gCards, RecordCount);
    EditBillNO.Properties.Items.Clear;

    nInt := Low(gCards);
    while not Eof do
    try
      with gCards[nInt] do
      begin
        FCard     := FieldByName('F_Card').AsString;
        FCardNO   := FieldByName('F_CardNO').AsString;
        FCardType := FieldByName('F_CardType').AsString;

        FZKID     := FieldByName('F_ZID').AsString;
        FZKType   := FieldByName('F_ZType').AsString;
      end;

      EditCard.Text := gCards[nInt].FCard;
      EditCardNO.Text:= gCards[nInt].FCardNO;

      EditBillNO.Properties.Items.AddObject(gCards[nInt].FZKID, Pointer(nInt));

      Inc(nInt);
    finally
      Next;
    end;

    if EditBillNO.Properties.Items.Count>0 then
      EditBillNO.ItemIndex := 0;

    SetCtrlData(EditCardType, gCards[0].FCardType);   
  end;
end;

//Desc: 保存磁卡
procedure TfFormReadICCard.BtnOKClick(Sender: TObject);
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    ActiveControl := EditCard;
    EditCard.SelectAll;

    ShowMsg('请输入有效卡号', sHint);
    Exit;
  end;

  ModalResult := mrOk;
  //done
end;

procedure TfFormReadICCard.BtnReadClick(Sender: TObject);
var nRet, nCard: LongInt;
begin
  inherited;
  if FICDevice<=0 then Exit;

  nRet := rf_card(FICDevice, 1, @nCard);
  if (nRet = 0) and FICBeep then rf_beep(FICDevice, 10);
  if nRet = 0 then EditCard.Text := IntToStr(nCard);

  LoadCardInfo(EditCard.Text);
end;

procedure TfFormReadICCard.EditBillNOPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditBillNO.ItemIndex < 0 then Exit;
  nIdx := Integer(EditBillNO.Properties.Items.Objects[EditBillNO.ItemIndex]);
  SetCtrlData(EditBillType, gCards[nIdx].FZKType);
  SetCtrlData(EditCardType, gCards[nIdx].FCardType);
end;

initialization
  gControlManager.RegCtrl(TfFormReadICCard, TfFormReadICCard.FormID);
end.
