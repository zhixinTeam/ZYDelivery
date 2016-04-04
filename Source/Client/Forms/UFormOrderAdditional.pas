{*******************************************************************************
  ����: fendou116688@163.com 2015/12/20
  ����: ��¼�ɹ���
*******************************************************************************}
unit UFormOrderAdditional;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxMaskEdit,
  cxDropDownEdit, cxListView, cxTextEdit, cxMCListBox, dxLayoutControl,
  StdCtrls, cxButtonEdit, cxMemo, cxCalendar;

type
  TfFormOrderAdditional = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditPValue: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditPMan: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditMMan: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group9: TdxLayoutGroup;
    EditMemo: TcxMemo;
    dxLayout1Item17: TdxLayoutItem;
    EditPDate: TcxDateEdit;
    dxLayout1Item18: TdxLayoutItem;
    EditMDate: TcxDateEdit;
    dxLayout1Item19: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditYSMan: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditKZValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditYSDate: TcxDateEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    { Protected declarations }
    FPopedom: String;
    //Ȩ��
    FListData: TStrings;
    procedure LoadFormData(nData: string);
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst;

var
  gOrderBaseData: string;

class function TfFormOrderAdditional.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  try
    nP.FParamA := cCmd_ViewData;
    CreateBaseFormItem(cFI_FormGetPOrderBase, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    gOrderBaseData := PackerDecodeStr(nP.FParamB);
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormOrderAdditional.Create(Application) do
  try
    FPopedom := nPopedom;
    LoadFormData(gOrderBaseData);
    //try load data

    Caption := '���ɹ���';
    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormOrderAdditional.FormID: integer;
begin
  Result := cFI_FormOrderAdditional;
end;

procedure TfFormOrderAdditional.FormCreate(Sender: TObject);
begin
  LoadMCListBoxConfig(Name, ListInfo);
  FListData := TStringList.Create;
end;

procedure TfFormOrderAdditional.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, ListInfo);
  FreeAndNil(FListData);
end;

//Desc: �س���
procedure TfFormOrderAdditional.EditIDKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if (Sender = EditTruck) and (Key = Char(VK_SPACE)) then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����������
procedure TfFormOrderAdditional.LoadFormData(nData: string);
begin
  BtnOK.Enabled := nData<>'';
  if nData='' then Exit;
  //xxxxx

  FListData.Text := nData;
  LoadOrderBaseToMC(FListData, ListInfo.Items, ListInfo.Delimiter);
  EditID.Text := FListData.Values['SQ_ID'];

  EditPDate.Date := Now;
  EditMDate.Date := Now;
  EditYSDate.Date:= Now;
  ActiveControl := EditTruck;
end;

function TfFormOrderAdditional.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if (Sender = EditPValue) or (Sender = EditMValue) then
  begin
    nStr := (Sender as TcxTextEdit).Text;
    Result := IsNumber(nStr, True) and (StrToFloat(nStr)>0);
    nHint := '����Ӧ����0'
  end else

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '���ƺų���Ӧ����2λ';
  end;
end;

//Desc: ����
procedure TfFormOrderAdditional.BtnOKClick(Sender: TObject);
var nStr, nID: string;
    nVal: Double;
begin
  if not IsDataValid then Exit;

  if StrToFloat(EditPValue.Text) > StrToFloat(EditMValue.Text) then
  begin
    nStr := 'Ƥ�ش���ë�أ�����������';
    ShowMsg(nStr, sHint);
    Exit;
  end;

  with FListData do
  begin
    Values['SQ_Truck'] := Trim(EditTruck.Text);

    nVal := Float2Float(StrToFloat(EditPValue.Text), cPrecision, False);
    Values['SQ_PValue']:= FloatToStr(nVal);

    nVal := Float2Float(StrToFloat(EditMValue.Text), cPrecision, False);
    Values['SQ_MValue']:= FloatToStr(nVal);

    nVal := Float2Float(StrToFloat(EditKZValue.Text), cPrecision, False);
    Values['SQ_KZValue'] := FloatToStr(nVal);

    Values['SQ_PMan'] := Trim(EditPMan.Text);
    Values['SQ_MMan'] := Trim(EditMMan.Text);

    Values['SQ_PDate']:= DateTime2Str(EditPDate.Date);
    Values['SQ_MDate']:= DateTime2Str(EditMDate.Date);

    Values['SQ_YSMan']:= Trim(EditYSMan.Text);
    Values['SQ_YSDate']:= DateTime2Str(EditYSDate.Date);
    Values['SQ_Memo'] := Trim(EditMemo.Text);
  end;

  nID := SaveOrderDtlAdd(PackerEncodeStr(FListData.Text), nStr);
  if nID = '' then
  begin
    ShowMsg('�ɹ�������ʧ��:' + nStr, sHint);
    Exit;
  end;

  PrintOrderReport(nID, True);
  ModalResult := mrOk;
  ShowMsg('�ɹ�������ɹ�', sHint);
end;

procedure TfFormOrderAdditional.EditIDPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  inherited;
  nP.FParamA := cCmd_ViewData;
  CreateBaseFormItem(cFI_FormGetPOrderBase, FPopedom, @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  gOrderBaseData := PackerDecodeStr(nP.FParamB);
  LoadFormData(gOrderBaseData);
end;

initialization
  gControlManager.RegCtrl(TfFormOrderAdditional, TfFormOrderAdditional.FormID);
end.
