{*******************************************************************************
  ����: dmzn@163.com 2014-09-01
  ����: ѡ�񶩵�
*******************************************************************************}
unit UFormGetFactZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls;

type
  TfFormGetFactZhiKa = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item10: TdxLayoutItem;
    EditName: TcxComboBox;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListDetail: TcxListView;
    dxLayout1Item4: TdxLayoutItem;
    EditZK: TcxComboBox;
    EditID: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditZKPropertiesEditValueChanged(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDPropertiesEditValueChanged(Sender: TObject);
  protected
    { Private declarations }
    FShowPrice: Boolean;
    //��ʾ����
    procedure InitFormData(const nID: string);
    //��������
    procedure ClearCustomerInfo;
    procedure LoadCustomerID(const nCusIDS: string);
    function LoadCustomerInfo(const nID: string): Boolean;
    //����ͻ�
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule,
  USysPopedom, USysGrid, USysDB, USysConst, USysBusiness;

var
  gParam: PFormCommandParam = nil;
  //ȫ��ʹ��

class function TfFormGetFactZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  gParam := nParam;

  with TfFormGetFactZhiKa.Create(Application) do
  try
    Caption := 'ѡ�񹤳�����';
    InitFormData('');
    FShowPrice := True;
    
    gParam.FCommand := cCmd_ModalResult;
    gParam.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormGetFactZhiKa.FormID: integer;
begin
  Result := cFI_FormGetFactZhiKa;
end;

procedure TfFormGetFactZhiKa.FormCreate(Sender: TObject);
begin
  LoadMCListBoxConfig(Name, ListInfo);
  LoadcxListViewConfig(Name, ListDetail);
end;

procedure TfFormGetFactZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, ListInfo);
  SavecxListViewConfig(Name, ListDetail);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormGetFactZhiKa.InitFormData(const nID: string);
begin
  dxGroup1.AlignVert := avTop;
  ActiveControl := EditName;
  LoadCustomerID(gSysParam.FCustomer);
end;

//Desc: ����ͻ���Ϣ
procedure TfFormGetFactZhiKa.ClearCustomerInfo;
begin
  if not EditID.Focused then EditID.Clear;
  if not EditName.Focused then EditName.ItemIndex := -1;

  ListInfo.Clear;
  ActiveControl := EditName;
end;

procedure TfFormGetFactZhiKa.LoadCustomerID(const nCusIDS: string);
begin
  AdjustStringsItem(EditID.Properties.Items, True);
  SplitStr(nCusIDS, EditID.Properties.Items, 0, ',', False);
  AdjustStringsItem(EditID.Properties.Items, False);
end;  

//Desc: ����nID�ͻ�����Ϣ
function TfFormGetFactZhiKa.LoadCustomerInfo(const nID: string): Boolean;
var nDS: TDataSet;
    nStr,nCusName,nSaleMan: string;
begin
  //ClearCustomerInfo;
  nDS := USysBusiness.LoadCustomerInfo(nID, ListInfo, nStr, True);

  Result := Assigned(nDS);
  BtnOK.Enabled := Result;

  if not Result then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  with nDS do
  begin
    nCusName := FieldByName('C_Name').AsString;
    nSaleMan := FieldByName('C_SaleMan').AsString;
  end;

  if GetStringsItemIndex(EditName.Properties.Items, nID) < 0 then
  begin
    nStr := Format('%s=%s.%s', [nID, nID, nCusName]);
    InsertStringsItem(EditName.Properties.Items, nStr);
  end;

  SetCtrlData(EditName, nID);
  //customer info done

  //----------------------------------------------------------------------------
  nStr := 'Z_ID=Select Z_ID, Z_Name From %s ' +
          'Where Z_Customer=''%s'' And ' +
          'IsNull(Z_InValid, '''')<>''%s'' And ' +
          'IsNull(Z_Freeze, '''')<>''%s'' Order By Z_ID';
  nStr := Format(nStr, [sTable_ZhiKa, nID, sFlag_Yes, sFlag_Yes]);

  with EditZK.Properties do
  begin
    AdjustStringsItem(Items, True);
    FDM.FillStringsData(Items, nStr, 0, '.', nil, True);
    AdjustStringsItem(Items, False);

    if Items.Count > 0 then
      EditZK.ItemIndex := 0;
    //xxxxx

    ActiveControl := BtnOK;
    //׼������
  end;
end;

procedure TfFormGetFactZhiKa.EditNamePropertiesEditValueChanged(Sender: TObject);
begin
  if (EditName.ItemIndex > -1) and EditName.Focused then
    LoadCustomerInfo(GetCtrlData(EditName));
  //xxxxx
end;

procedure TfFormGetFactZhiKa.EditZKPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  ListDetail.Clear;
  if EditZK.ItemIndex < 0 then Exit;

  nStr := 'Select D_StockName,D_Price,D_Value From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, GetCtrlData(EditZK)]);

  with FDM.QueryTemp(nStr, True) do
  begin
    if RecordCount < 0 then Exit;
    //no data
    First;

    while not Eof do
    begin
      with ListDetail.Items.Add do
      begin
        Checked := True;
        Caption := Fields[0].AsString;

        if FShowPrice then
             nStr := Format('%.2f',[Fields[1].AsFloat])
        else nStr := '---';

        SubItems.Add(nStr);
        SubItems.Add(Format('%.2f',[Fields[2].AsFloat]));
      end;

      Next;
    end;
  end;
end;

procedure TfFormGetFactZhiKa.BtnOKClick(Sender: TObject);
begin
  if EditZK.ItemIndex < 0 then
  begin
    ShowMsg('��ѡ�񶩵�', sHint);
    Exit;
  end;

  gParam.FParamB := GetCtrlData(EditZK);
  ModalResult := mrOk;
end;

procedure TfFormGetFactZhiKa.EditIDPropertiesEditValueChanged(
  Sender: TObject);
begin
  inherited;
  if EditID.ItemIndex > -1 then
    LoadCustomerInfo(Trim(EditID.Text));
end;

initialization
  gControlManager.RegCtrl(TfFormGetFactZhiKa, TfFormGetFactZhiKa.FormID);
end.
