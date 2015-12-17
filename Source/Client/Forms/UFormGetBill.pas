{*******************************************************************************
  作者: fendou116688@163.com 2015/12/9
  描述: 选择交货单号
*******************************************************************************}
unit UFormGetBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxCheckBox, Menus,
  cxLabel, cxListView, cxTextEdit, cxMaskEdit, cxButtonEdit,
  dxLayoutControl, StdCtrls;

type
  TfFormGetBill = class(TfFormNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListBill: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListBillKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListBillDblClick(Sender: TObject);
  private
    { Private declarations }
    function QueryBill(const nBill: string): Boolean;
    //查询交货单
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormBase, USysGrid, USysDB, USysConst,
  USysBusiness, UDataModule, UFormInputbox;

class function TfFormGetBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetBill.Create(Application) do
  begin
    Caption := '选择交货单';

    EditID.Text := nP.FParamA;
    QueryBill(EditID.Text);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
      nP.FParamB := ListBill.Items[ListBill.ItemIndex].Caption;
    Free;
  end;
end;

class function TfFormGetBill.FormID: integer;
begin
  Result := cFI_FormGetBill;
end;

procedure TfFormGetBill.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetBill.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 查询车牌号
function TfFormGetBill.QueryBill(const nBill: string): Boolean;
var nStr: string;
begin
  Result := False;
  if Trim(nBill) = '' then Exit;
  ListBill.Items.Clear;

  nStr := 'Select * From %s Where L_ID Like ''%%%s%%'' Order By L_ID Desc';
  nStr := Format(nStr, [sTable_Bill, Trim(nBill), Trim(nBill)]);

  nStr := nStr + ' ';

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      with ListBill.Items.Add do
      begin
        Caption := FieldByName('L_ID').AsString;
        SubItems.Add(FieldByName('L_Truck').AsString);
        SubItems.Add(FieldByName('L_CusName').AsString);
        SubItems.Add(FieldByName('L_StockName').AsString);
        SubItems.Add(FieldByName('L_OutFact').AsString);

        ImageIndex := 11;
        StateIndex := ImageIndex;
      end;

      Next;
    end;
  end;

  Result := ListBill.Items.Count > 0;
  if Result then
  begin
    ActiveControl := ListBill;
    ListBill.ItemIndex := 0;
    ListBill.ItemFocused := ListBill.TopItem;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormGetBill.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  QueryBill(EditID.Text);
end;

procedure TfFormGetBill.ListBillKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if ListBill.ItemIndex > -1 then
      ModalResult := mrOk;
    //xxxxx
  end;
end;

procedure TfFormGetBill.ListBillDblClick(Sender: TObject);
begin
  if ListBill.ItemIndex > -1 then
    ModalResult := mrOk;
  //xxxxx
end;

procedure TfFormGetBill.BtnOKClick(Sender: TObject);
begin
  if ListBill.ItemIndex > -1 then
       ModalResult := mrOk
  else ShowMsg('请在查询结果中选择', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormGetBill, TfFormGetBill.FormID);
end.
