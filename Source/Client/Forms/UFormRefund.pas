{*******************************************************************************
  ����: fendou116688@163.com 2016-03-29
  ����: ���˻���
*******************************************************************************}
unit UFormRefund;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit;

type
  TfFormRefund = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditCusName: TcxTextEdit;
    dxlytmLayout1Item4: TdxLayoutItem;
    EditSaleMan: TcxTextEdit;
    dxlytmLayout1Item5: TdxLayoutItem;
    EditDate: TcxTextEdit;
    dxlytmLayout1Item6: TdxLayoutItem;
    EditSName: TcxTextEdit;
    dxlytmLayout1Item10: TdxLayoutItem;
    EditMax: TcxTextEdit;
    dxlytmLayout1Item11: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxlytmLayout1Item12: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditBill: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    { Protected declarations }
    FCardData: TStrings;
    //��Ƭ����
    FNewBillID: string;
    //���ᵥ�� 
    procedure InitFormData;
    //��ʼ������
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
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst;

class function TfFormRefund.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  try
    CreateBaseFormItem(cFI_FormRefundNew, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    nStr := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormRefund.Create(Application) do
  try
    Caption := '���˹���';
    ActiveControl := EditTruck;

    FCardData.Text := PackerDecodeStr(nStr);
    InitFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := FNewBillID
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormRefund.FormID: integer;
begin
  Result := cFI_FormRefund;
end;

procedure TfFormRefund.FormCreate(Sender: TObject);
begin
  FCardData := TStringList.Create;

  AdjustCtrlData(Self);
  LoadFormConfig(Self);
end;

procedure TfFormRefund.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FCardData.Free;
end;

//Desc: �س���
procedure TfFormRefund.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditValue then
         BtnOK.Click
    else Perform(WM_NEXTDLGCTL, 0, 0);
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

procedure TfFormRefund.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nChar: Char;
begin
  nChar := Char(VK_SPACE);
  EditLadingKeyPress(EditTruck, nChar);
end;

//------------------------------------------------------------------------------
procedure TfFormRefund.InitFormData;
begin
  with FCardData do
  begin
    EditBill.Text   := Values['BillNO'];
    EditCusName.Text:= Values['CusName'];
    EditSaleMan.Text:= Values['SaleMan'];
    EditMan.Text    := Values['Man'];
    EditDate.Text   := Values['OutFact'];
    EditSName.Text  := Values['StockName'];
    EditMax.Text    := Values['Value'];
    EditTruck.Text  := Values['Truck'];
  end;
end;

function TfFormRefund.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '���ƺų���Ӧ����2λ';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    nHint := '����д��Ч�İ�����';
  end;
end;

//Desc: ����
procedure TfFormRefund.BtnOKClick(Sender: TObject);
var nPrint: Boolean;
    nList,nStocks: TStrings;
begin
  if not IsDataValid then Exit;
  //check valid

  nStocks := TStringList.Create;
  nList := TStringList.Create;
  try
    nList.Clear;
    nPrint := False;
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    //���ӡƷ��

    with nList do
    begin
      Values['Truck'] := EditTruck.Text;
      Values['BillNO'] := EditBill.Text;
      Values['Value'] := EditValue.Text;
    end;

    FNewBillID := SaveRefund(PackerEncodeStr(nList.Text));
    //call mit bus
    if FNewBillID = '' then Exit;
  finally
    nList.Free;
  end;

  SetRefundCard(FNewBillID, EditTruck.Text, True);
  //����ſ�

  if nPrint then
    PrintRefundReport(FNewBillID, True);
  //print report

  ModalResult := mrOk;
  ShowMsg('�����˻�������ɹ�', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormRefund, TfFormRefund.FormID);
end.
