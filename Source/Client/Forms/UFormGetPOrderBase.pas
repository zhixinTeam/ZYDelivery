{*******************************************************************************
  作者: fendou116688@163.com 2015/9/19
  描述: 选择采购申请单
*******************************************************************************}
unit UFormGetPOrderBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TOrderBaseParam = record
    FID :string;
    FXuNi: string;

    FProvID: string;
    FProvName: string;
    FProvType: string;

    FSaleID: string;
    FSaleName: string;

    FArea: string;
    FProject: string;

    FStockNO: string;
    FStockName: string;

    FRestValue: string;
  end;
  TOrderBaseParams = array of TOrderBaseParam;

  TfFormGetPOrderBase = class(TfFormNormal)
    EditProvider: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditMate: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListQueryKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListQueryDblClick(Sender: TObject);
  private
    { Private declarations }
    FResults: TStrings;
    //查询类型
    FOrderData,FPopedom: string;
    //申请单信息,权限项
    FOrderItems: TOrderBaseParams;
    function QueryData(const nQueryType: string=''): Boolean;
    //查询数据
    procedure GetResult;
    //获取结果
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UFormBase, USysGrid, USysDB, 
  USysConst, UDataModule, UBusinessPacker, USysPopedom;

class function TfFormGetPOrderBase.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetPOrderBase.Create(Application) do
  begin
    FResults.Clear;
    FPopedom:=nPopedom;
    Caption := '选择申请单';

    SetLength(FOrderItems, 0);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := PackerEncodeStr(FOrderData);
    end;
    Free;
  end;
end;

class function TfFormGetPOrderBase.FormID: integer;
begin
  Result := cFI_FormGetPOrderBase;
end;

procedure TfFormGetPOrderBase.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;

  FResults := TStringList.Create;
end;

procedure TfFormGetPOrderBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;

  FResults.Free;
end;

//------------------------------------------------------------------------------
//Date: 2015-01-22
//Desc: 按指定类型查询
function TfFormGetPOrderBase.QueryData(const nQueryType: string=''): Boolean;
var nStr, nQuery: string;
    nIdx: Integer;
begin
  Result := False;
  ListQuery.Items.Clear;

  nStr := 'Select *,(B_Value-B_SentValue-B_FreezeValue) As B_MaxValue From $TB ' +
          'Where ((B_Value-B_SentValue>0) or (B_Value=0)) ' +
          'And B_BStatus=''Y'' ';
  if nQueryType = '1' then //供应商
  begin
    nQuery := Trim(EditProvider.Text);
    nStr := nStr + 'And ((B_ProID like ''%%$QUERY%%'') ' +
            'or (B_ProName  like ''%%$QUERY%%'') ' +
            'or (B_ProPY  like ''%%$QUERY%%'')) ';
  end
  else if nQueryType = '2' then //原材料
  begin
    nQuery := Trim(EditMate.Text);
    nStr := nStr + 'And ((B_StockName like ''%%$QUERY%%'') ' +
            'or (B_StockNo  like ''%%$QUERY%%'')) ';
  end else Exit;

  if gPopedomManager.HasPopedom(FPopedom, sPopedom_ViewCusFZY) then
       nStr := nStr + ''
  else nStr := nStr + ' And B_ProType=''$ZY''';

  nStr := MacroValue(nStr , [MI('$TB', sTable_OrderBase),
          MI('$ZY', sFlag_CusZY), MI('$QUERY', nQuery)]);  

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    SetLength(FOrderItems, RecordCount);
    nIdx := Low(FOrderItems);

    while not Eof do
    with FOrderItems[nIdx] do
    begin
      FID       := FieldByName('B_ID').AsString;
      FProvID   := FieldByName('B_ProID').AsString;
      FProvName := FieldByName('B_ProName').AsString;
      FProvType := FieldByName('B_ProType').AsString;
      FSaleID   := FieldByName('B_SaleID').AsString;
      FSaleName := FieldByName('B_SaleMan').AsString;
      FStockNO  := FieldByName('B_StockNO').AsString;
      FStockName:= FieldByName('B_StockName').AsString;
      FArea     := FieldByName('B_Area').AsString;
      FXuNi     := FieldByName('B_XuNi').AsString;
      FProject  := FieldByName('B_Project').AsString;
      if FieldByName('B_Value').AsFloat>0 then
           FRestValue:= Format('%.2f', [FieldByName('B_MaxValue').AsFloat])
      else FRestValue := '0.00';

      if (FieldByName('B_MaxValue').AsFloat>0)
        or (FieldByName('B_Value').AsFloat<=0) then
      with ListQuery.Items.Add do
      begin
        Caption := FID;
        SubItems.Add(FStockName);
        SubItems.Add(FProvName);
        SubItems.Add(FRestValue);
        SubItems.Add(FProvType);
        SubItems.Add(FStockNO);
        ImageIndex := cItemIconIndex;
      end;

      Inc(nIdx);
      Next;
    end;

    ListQuery.ItemIndex := 0;
    Result := True;
  end;
end;

procedure TfFormGetPOrderBase.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nQueryType: string;
begin
  if Sender = EditProvider then
       nQueryType := '1'
  else nQueryType := '2';

  if QueryData(nQueryType) then ListQuery.SetFocus;
end;

//Desc: 获取结果
procedure TfFormGetPOrderBase.GetResult;
var nIdx: Integer;
begin
  with ListQuery.Selected do
  begin
    for nIdx:=Low(FOrderItems) to High(FOrderItems) do
    with FOrderItems[nIdx], FResults do
    begin
      if CompareText(FID, Caption)=0 then
      begin
        Values['SQ_ID']       := FID;
        Values['SQ_ProID']    := FProvID;
        Values['SQ_ProName']  := FProvName;
        Values['SQ_ProType']  := FProvType;
        Values['SQ_SaleID']   := FSaleID;
        Values['SQ_SaleName'] := FSaleName;
        Values['SQ_StockNO']  := FStockNO;
        Values['SQ_StockName']:= FStockName;
        Values['SQ_Area']     := FArea;
        Values['SQ_XuNi']     := FXuNi;
        Values['SQ_Project']  := FProject;
        Values['SQ_RestValue']:= FRestValue;
        Break;
      end;  
    end;  
  end;

  FOrderData := FResults.Text;
end;

procedure TfFormGetPOrderBase.ListQueryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListQuery.ItemIndex > -1 then
    begin
      GetResult;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetPOrderBase.ListQueryDblClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end;
end;

procedure TfFormGetPOrderBase.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormGetPOrderBase, TfFormGetPOrderBase.FormID);
end.
