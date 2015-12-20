{*******************************************************************************
  作者: dmzn@163.com 2010-3-9
  描述: 选择水泥编号
*******************************************************************************}
unit UFormGetStockNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormStockNo = class(TfFormNormal)
    EditNo: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListStock: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListStockKeyPress(Sender: TObject; var Key: Char);
    procedure ListStockDblClick(Sender: TObject);
    procedure EditNoPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FStockNo: string;
    //水泥编号
    procedure GetResult;
    function QueryStockNo(const nNo: string): Boolean;
    //查询编号
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormBase, USysGrid, UDataModule,
  USysDB, USysConst, USysBusiness;

class function TfFormStockNo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormStockNo.Create(Application) do
  begin
    Caption := '水泥编号';
    QueryStockNo(nP.FParamA);
    nP.FCommand := cCmd_ModalResult;
    
    nP.FParamA := ShowModal;
    nP.FParamB := FStockNo;
    Free;
  end;
end;

class function TfFormStockNo.FormID: integer;
begin
  Result := cFI_FormGetStockNo;
end;

procedure TfFormStockNo.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListStock, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormStockNo.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListStock, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 查询编号为nNo的
function TfFormStockNo.QueryStockNo(const nNo: string): Boolean;
var nStr, nGroup, nWhere: string;
    nRest, nSent: Double;
begin
  Result := False;
  EditNo.Text := nNo;
  ListStock.Items.Clear;

  nStr := 'Select P_QLevel From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_StockParam, nNo]);
  with FDM.QueryTemp(nStr) do
  if RecordCount>0 then
       nGroup := Fields[0].AsString
  else Exit;

  if nGroup='' then
       nWhere := 'E_Stock=''$NO'''
  else nWhere := '(E_Stock=''$NO'') or (E_Group=''$GP'')';
  nWhere := MacroValue(nWhere, [MI('$NO', nNo), MI('$GP', nGroup)]);

  nStr := 'Select re.*,R_SerialNo,R_Date From $RE re,$SR sr ' +
          'Where ($WHERE) And re.E_ID=sr.R_ExtID ' +
          'And E_Status=''$Y'' And Year(sr.R_Date)>=Year(GetDate()) ' +
          'Order By sr.R_Date';
  nStr := MacroValue(nStr, [MI('$RE', sTable_StockRecordExt),
          MI('$SR', sTable_StockRecord),
          MI('$WHERE', nWhere), MI('$Y', sFlag_Yes)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListStock.Items.Add do
    begin
      nSent := FieldByName('E_Sent').AsFloat + FieldByName('E_Freeze').AsFloat -
               FieldByName('E_Rund').AsFloat;
      nSent := Float2Float(nSent, cPrecision, True);

      nRest := FieldByName('E_Plan').AsFloat + FieldByName('E_Rund').AsFloat -
               FieldByName('E_Sent').AsFloat - FieldByName('E_Freeze').AsFloat;
      nRest := Float2Float(nRest, cPrecision, False);

      Caption := FieldByName('R_SerialNo').AsString;
      SubItems.Add(FieldByName('E_Name').AsString);

      nStr := Format('%.2f', [nSent]);
      SubItems.Add(nStr);

      nStr := Format('%.2f', [nRest]);
      SubItems.Add(nStr);
      SubItems.Add(DateTime2Str(FieldByName('R_Date').AsDateTime));

      ImageIndex := cItemIconIndex;
      Next;
    end;

    ListStock.ItemIndex := 0;
    Result := True;
  end;
end;

procedure TfFormStockNo.EditNoPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if QueryStockNo(EditNo.Text) then ListStock.SetFocus;
end;

procedure TfFormStockNo.GetResult;
begin
  if Assigned(ListStock.Selected) then
       FStockNo := ListStock.Selected.Caption
  else FStockNo := '';
end;

procedure TfFormStockNo.ListStockKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListStock.ItemIndex > -1 then
    begin
      GetResult; ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormStockNo.ListStockDblClick(Sender: TObject);
begin
  if ListStock.ItemIndex > -1 then
  begin
    GetResult; ModalResult := mrOk;
  end;
end;

procedure TfFormStockNo.BtnOKClick(Sender: TObject);
begin
  if ListStock.ItemIndex > -1 then
  begin
    GetResult; ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormStockNo, TfFormStockNo.FormID);
end.
