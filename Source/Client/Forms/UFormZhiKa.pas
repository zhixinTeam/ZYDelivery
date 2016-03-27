{*******************************************************************************
  ����: dmzn@163.com 2010-3-8
  ����: ��������
*******************************************************************************}
unit UFormZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, Menus,
  cxDropDownEdit, cxCalendar, cxCheckBox, cxLabel, cxMaskEdit,
  cxButtonEdit, cxTextEdit, cxListView, dxLayoutControl, StdCtrls;

{$I Link.Inc}
type
  TStockItem = record
   FStock: string;
   FType: string;
   FName: string;
   FPrice: Double;
   FValue: Double;
   FSelected: Boolean;
  end;

  TZhiKaItem = record
    FContract: string;
    FIsXuNi: Boolean;
    FIsValid: Boolean;

    FSaleMan: string;
    FSaleName: string;
    FSalePY: string;
    FCustomer: string;
    FCusName: string;

    FCard  : string;
  end;

  TfFormZhiKa = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListDetail: TcxListView;
    dxLayout1Item3: TdxLayoutItem;
    EditStock: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditCID: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditPName: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditSMan: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditCustom: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item11: TdxLayoutItem;
    EditPayment: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Item16: TdxLayoutItem;
    cxLabel2: TcxLabel;
    EditName: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSManPropertiesEditValueChanged(Sender: TObject);
    procedure EditCIDExit(Sender: TObject);
    procedure ListDetailClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure EditCIDKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCustomKeyPress(Sender: TObject; var Key: Char);
    procedure EditPricePropertiesEditValueChanged(Sender: TObject);
    procedure ListDetailChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure EditCustomPropertiesChange(Sender: TObject);
  protected
    { Protected declarations }
    FRecordID: string;
    //��¼���
    FItemIndex: Integer;
    //��¼����
    FZhiKa: TZhiKaItem;
    FStockList: array of TStockItem;
    //������Ϣ
    FListA, FListB, FListC: TStrings;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //���෽��
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadStockList;
    procedure LoadStockListSummary;
    //ˮ���б�
    procedure LoadSaleContract(const nCID: string);
    //�����ͬ
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UAdjustForm, UFormCtrl, UFormBase, UFrameBase,
  USysGrid, USysDB, USysConst, USysBusiness, UDataModule, UBusinessPacker;

var
  gForm: TfFormZhiKa = nil;

//------------------------------------------------------------------------------
class function TfFormZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nD: TFormCommandParam;
begin
  Result := nil;
  nD.FCommand := cCmd_AddData;

  if Assigned(nParam) then
       nP := nParam
  else nP := @nD;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormZhiKa.Create(Application) do
    begin
      FRecordID := '';
      Caption := '���� - ����';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormZhiKa.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '���� - �޸�';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormZhiKa.Create(Application);
        with gForm do
        begin
          FormStyle := fsStayOnTop; 
          BtnOK.Enabled := False;
        end;
      end;

      with gForm  do
      begin
        FRecordID := nP.FParamA;
        Caption := '���� - ' + FRecordID;
        
        InitFormData(FRecordID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormZhiKa.FormID: integer;
begin
  Result := cFI_FormZhiKa;
end;

procedure TfFormZhiKa.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  LoadcxListViewConfig(Name, ListDetail);

  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;

  FItemIndex := -1;
  AdjustCtrlData(Self);
end;

procedure TfFormZhiKa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SavecxListViewConfig(Name, ListDetail);

  FListA.Free;
  FListB.Free;
  FListC.Free;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: �������
procedure TfFormZhiKa.InitFormData(const nID: string);
var nStr: string;
    nZK: TZhiKaItem;                     
    i,nIdx: integer;
    nDStr: TDynamicStrArray;
    nItem: array of TStockItem;
begin
  EditName.Text := '��׼����';
  FZhiKa.FContract := '';
  FZhiKa.FIsValid := False;
  SetLength(FStockList, 0);
  {
  if EditPayment.Properties.Items.Count < 1 then
  begin
    EditPayment.Clear;
    EditPayment.Text := 'Ԥ����';
    LoadSysDictItem(sFlag_PaymentItem, EditPayment.Properties.Items);
  end; }

  if EditPayment.Properties.Items.Count < 1 then
  begin
    nStr := 'D_Memo=Select D_Memo,D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_PaymentItem]);

    FDM.FillStringsData(EditPayment.Properties.Items, nStr, 1, '.');
    AdjustCXComboBoxItem(EditPayment, False);
    if EditPayment.Properties.Items.Count>0 then EditPayment.ItemIndex := 0;
  end;

  if nID <> '' then
  begin
    nStr := 'Select zk.*,S_Name,S_PY,C_Name From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan' +
            ' Left Join $Cus cus On cus.c_ID=zk.Z_Customer ' +
            'Where Z_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
            MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman),
            MI('$ID', nID)]);
    //xxxxx

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      with nZK do
      begin
        FContract := FieldByName('Z_CID').AsString;
        FSaleMan := FieldByName('Z_SaleMan').AsString;
        FSaleName := FieldByName('S_Name').AsString;
        FSalePY := FieldByName('S_PY').AsString;
        FCustomer := FieldByName('Z_Customer').AsString;
        FCusName := FieldByName('C_Name').AsString;
        FCard    := FieldByName('Z_Card').AsString;
      end;

      EditName.Text := FieldByName('Z_Name').AsString;
      SetLength(nDStr, 3);
      
      nDStr[0] := FieldByName('Z_Project').AsString;
      nDStr[1] := FieldByName('Z_Lading').AsString;
      nDStr[2] := FieldByName('Z_PayType').AsString;

      EditMoney.Text := FieldByName('Z_YFMoney').AsString;
      //Ԥ����

      nStr := 'Select * From %s Where D_ZID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKaDtl, nID]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        SetLength(nItem, RecordCount);
        nIdx := 0;
        First;

        while not Eof do
        with nItem[nIdx] do
        begin
          FStock := FieldByName('D_StockNo').AsString;
          FType := FieldByName('D_Type').AsString;
          FName := FieldByName('D_StockName').AsString;
          FPrice := FieldByName('D_Price').AsFloat;
          FValue := FieldByName('D_Value').AsFloat;

          Inc(nIdx);
          Next;
        end;
      end;

      LoadSaleContract(nZK.FContract);
      //��ȡ��ͬ

      if FZhiKa.FIsValid then
      begin
        FZhiKa.FSaleMan := nZK.FSaleMan;
        FZhiKa.FSaleName := nZK.FSaleName;
        FZhiKa.FSalePY := nZK.FSalePY;
        FZhiKa.FCustomer := nZK.FCustomer;
        FZhiKa.FCusName := nZK.FCusName;
        FZhiKa.FCard    := nZK.FCard;
      end else Exit;

      EditCID.Text := FZhiKa.FContract;
      EditPName.Text := nDStr[0];

      if FZhiKa.FIsXuNi then
      begin
        SetCtrlData(EditSMan, FZhiKa.FSaleMan);
        if GetStringsItemIndex(EditCustom.Properties.Items, FZhiKa.FCustomer) < 0 then
        begin
          nStr := Format('%s=%s.%s', [FZhiKa.FCustomer, FZhiKa.FCustomer,
                                      FZhiKa.FCusName]);
          InsertStringsItem(EditCustom.Properties.Items, nStr);
        end;
        SetCtrlData(EditCustom, FZhiKa.FCustomer);
      end else
      begin
        EditSMan.Text := Format('%s.%s', [FZhiKa.FSalePY, FZhiKa.FSaleName]);
        EditCustom.Text := Format('%s.%s', [FZhiKa.FCustomer, FZhiKa.FCusName]);
      end;

      SetCtrlData(EditLading, nDStr[1]);
      //EditPayment.Text := nDStr[2];
      SetCtrlData(EditPayment, nDStr[2]);

      for nIdx:=Low(nItem) to High(nItem) do
      begin
        nStr := '';

        for i:=Low(FStockList) to High(FStockList) do
        if (FStockList[i].FType = nItem[nIdx].FType) and
           (FStockList[i].FName = nItem[nIdx].FName) then
        begin
          FStockList[i].FPrice := nItem[nIdx].FPrice;
          FStockList[i].FValue := nItem[nIdx].FValue;

          FStockList[i].FSelected := True;
          nStr := 'Y';
          Break;
        end;

        if nStr = '' then
        begin
          i := Length(FStockList);
          SetLength(FStockList, i + 1);

          FStockList[i].FStock := nItem[nIdx].FStock;
          FStockList[i].FType := nItem[nIdx].FType;
          FStockList[i].FName := nItem[nIdx].FName;
          FStockList[i].FPrice := nItem[nIdx].FPrice;
          FStockList[i].FValue := nItem[nIdx].FValue;
          FStockList[i].FSelected := True;
        end;
      end;
    end;

    LoadStockList;
    LoadStockListSummary;
  end;
end;

//Desc: ����ˮ���б�
procedure TfFormZhiKa.LoadStockList;
var nIdx,nItem: integer;
begin
  nItem := ListDetail.ItemIndex;
  ListDetail.Items.BeginUpdate;
  try
    ListDetail.Items.Clear;

    for nIdx:=Low(FStockList) to High(FStockList) do
     with ListDetail.Items.Add do
     begin
       Caption := FStockList[nIdx].FName;
       SubItems.Add(Format('%.2f', [FStockList[nIdx].FPrice]));
       SubItems.Add(Format('%.2f', [FStockList[nIdx].FValue]));
       Checked := FStockList[nIdx].FSelected;
     end;
  finally
    ListDetail.Items.EndUpdate;
    ListDetail.ItemIndex := nItem;
  end;
end;

//Desc: ����ժҪ
procedure TfFormZhiKa.LoadStockListSummary;
var nMoney: Double;
    nIdx,nNum: integer;
begin
  nNum := 0;
  nMoney := 0;
  dxGroup2.Caption := '������ϸ';

  for nIdx:=Low(FStockList) to High(FStockList) do
  if FStockList[nIdx].FSelected then
  begin
    Inc(nNum);
    nMoney := nMoney + FStockList[nIdx].FPrice * FStockList[nIdx].FValue;
  end;

  EditMoney.Text := Format('%.2f', [nMoney]);

  if nNum > 0 then
    dxGroup2.Caption := dxGroup2.Caption +
      Format(' ��ѡ:[ %d ]�� �ܶ�:[ %.2f ]Ԫ', [nNum, nMoney]);
  //xxxxx
end;

//Desc: ������ΪnCID�ĺ�ͬ������
procedure TfFormZhiKa.LoadSaleContract(const nCID: string);
var nStr: string;
    nIdx: integer;
begin
  if CompareText(nCID, FZhiKa.FContract) = 0 then
  begin
    EditCID.Text := nCID; Exit;
  end else FZhiKa.FIsValid := False;
  
  nStr := 'Select sc.*,sm.S_Name,sm.S_PY,cus.C_Name as CusName,' +
          '$Now as S_Now From $SC sc' +
          ' Left Join $SM sm On sm.S_ID=sc.C_SaleMan' +
          ' Left Join $Cus cus On cus.C_ID=sc.C_Customer ' +
          'Where sc.C_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
          MI('$ID', nCID), MI('$Now', FDM.SQLServerNow)]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    with FZhiKa do
    begin
      FIsXuNi := FieldByName('C_XuNi').AsString = sFlag_Yes;
      FSaleMan := FieldByName('C_SaleMan').AsString;
      FSaleName := FieldByName('S_Name').AsString;
      FSalePY := FieldByName('S_PY').AsString;
      FCustomer := FieldByName('C_Customer').AsString;
      FCusName := FieldByName('CusName').AsString;
    end;

    EditPName.Text := FieldByName('C_Project').AsString;
    EditSMan.Properties.ReadOnly := not FZhiKa.FIsXuNi;
    EditCustom.Properties.ReadOnly := not FZhiKa.FIsXuNi;

    if FZhiKa.FIsXuNi then
    begin
      EditSMan.Properties.DropDownListStyle := lsEditFixedList;
      EditCustom.Properties.DropDownListStyle := lsEditList;

      if EditSMan.Properties.Items.Count < 1 then
        LoadSaleMan(EditSMan.Properties.Items);
      SetCtrlData(EditSMan, FZhiKa.FSaleMan);
      //����ҵ��Ա

      if EditCustom.Properties.Items.Count < 1 then
      begin
        nStr := Format('C_SaleMan=''%s''', [GetCtrlData(EditSMan)]);
        LoadCustomer(EditCustom.Properties.Items, nStr);
      end;
      SetCtrlData(EditCustom, FZhiKa.FCustomer);
      //���ÿͻ���
    end else
    begin
      EditSMan.Properties.DropDownListStyle := lsEditList;
      EditCustom.Properties.DropDownListStyle := lsEditList;

      EditSMan.Text := Format('%s.%s', [FZhiKa.FSalePY, FZhiKa.FSaleName]);
      EditCustom.Text := Format('%s.%s', [FZhiKa.FCustomer, FZhiKa.FCusName]);
    end;

    SetLength(FStockList, 0);
    nStr := 'Select * From %s Where E_CID=''%s''';
    nStr := Format(nStr, [sTable_SContractExt, nCID]);

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      SetLength(FStockList, RecordCount);
      nIdx := 0;
      First;

      while not Eof do
      with FStockList[nIdx] do
      begin
        FStock := FieldByName('E_StockNo').AsString;
        FType := FieldByName('E_Type').AsString;
        FName := FieldByName('E_StockName').AsString;
        FPrice := FieldByName('E_Price').AsFloat;
        FValue := 0;

        Next;
        Inc(nIdx);
      end;
    end;

    LoadStockList;
    EditCID.Text := nCID;
    
    FZhiKa.FIsValid := True;
    FZhiKa.FContract := nCID;
  end;
end;

//Desc: ҵ��Ա���,��ȡ��ؿͻ�
procedure TfFormZhiKa.EditSManPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  if FZhiKa.FIsXuNi and (EditSMan.ItemIndex > -1) then
  begin
    EditCustom.Text := '';
    nStr := Format('C_SaleMan=''%s''', [GetCtrlData(EditSMan)]);
    LoadCustomer(EditCustom.Properties.Items, nStr);
  end;
end;

//Desc: �����ͬ
procedure TfFormZhiKa.EditCIDExit(Sender: TObject);
begin
  EditCID.Text := Trim(EditCID.Text);
  if EditCID.Text <> '' then LoadSaleContract(EditCID.Text);
end;

//Desc: ͬ�����°�����ϸ
procedure TfFormZhiKa.ListDetailClick(Sender: TObject);
var nIdx: Integer;
    nChanged: Boolean;
begin
  nChanged := False;
  for nIdx:=Low(FStockList) to High(FStockList) do
  if FStockList[nIdx].FSelected <> ListDetail.Items[nIdx].Checked then
  begin
    nChanged := True;
    FStockList[nIdx].FSelected := ListDetail.Items[nIdx].Checked;
  end;

  if nChanged then LoadStockListSummary;
  //update summary

  if ListDetail.ItemIndex >= 0 then
  begin
    FItemIndex := -1;

    EditStock.Text := FStockList[ListDetail.ItemIndex].FName;
    EditPrice.Text := Format('%.2f', [FStockList[ListDetail.ItemIndex].FPrice]);
    
    EditValue.Text := Format('%.2f', [FStockList[ListDetail.ItemIndex].FValue]);
    //EditValue.SetFocus;
    FItemIndex := ListDetail.ItemIndex;
  end;
end;

//Desc: ��������
procedure TfFormZhiKa.EditPricePropertiesEditValueChanged(Sender: TObject);
var nInt: Integer;
    nChanged: Boolean;
begin
  if (FItemIndex >= 0) and IsNumber(EditPrice.Text, True) and
     IsNumber(EditValue.Text, True) then
  begin
    nInt := Float2PInt(StrToFloat(EditPrice.Text), cPrecision);
    if nInt <> Float2PInt(FStockList[FItemIndex].FPrice, cPrecision) then
    begin
      nChanged := True;
      FStockList[FItemIndex].FPrice := nInt / cPrecision;
    end else nChanged := False;

    nInt := Float2PInt(StrToFloat(EditValue.Text), cPrecision);
    if nInt <> Float2PInt(FStockList[FItemIndex].FValue, cPrecision) then
    begin
      nChanged := True;
      FStockList[FItemIndex].FValue := nInt / cPrecision;
    end;

    if not (EditPrice.IsFocused or EditValue.IsFocused) then
      FItemIndex := -1;
    //xxxxx

    if nChanged then
    begin
      LoadStockList;
      LoadStockListSummary;
    end;
  end;
end;

//Desc: ��ݲ˵�
procedure TfFormZhiKa.N3Click(Sender: TObject);
var nIdx: integer;
    nBool: Boolean;
begin
  for nIdx:=Low(FStockList) to High(FStockList) do
  begin
    case TComponent(Sender).Tag of
     10: nBool := True;
     20: nBool := False;
     30: nBool := not FStockList[nIdx].FSelected else nBool := False;
    end;

    FStockList[nIdx].FSelected := nBool;
    ListDetail.Items[nIdx].Checked := nBool;
    LoadStockListSummary;
  end;
end;

//Desc: ����ѡ���ͬ
procedure TfFormZhiKa.EditCIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
  end;
end;

//Desc: ����ѡ��ͻ�
procedure TfFormZhiKa.EditCustomKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    nP.FParamA := GetCtrlData(EditCustom);
    
    if nP.FParamA = '' then
      nP.FParamA := EditCustom.Text;
    //xxxxx

    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    SetCtrlData(EditSMan, nP.FParamD);
    if EditSMan.ItemIndex < 0 then
    begin
      ShowMsg('��Ч��ҵ��Ա', sHint); Exit;
    end;

    SetCtrlData(EditCustom, nP.FParamB);
    if EditCustom.ItemIndex < 0 then
    begin
      nStr := Format('%s=%s.%s', [nP.FParamB, nP.FParamB, nP.FParamC]);
      InsertStringsItem(EditCustom.Properties.Items, nStr);
      SetCtrlData(EditCustom, nP.FParamB);
    end;
  end;
end;

procedure TfFormZhiKa.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  nP.FParamA := Trim(EditCID.Text);
  CreateBaseFormItem(cFI_FormGetContract, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    LoadSaleContract(nP.FParamB);
  EditCID.SelectAll;
end;

//Desc: ��֤Sender�ؼ�
function TfFormZhiKa.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditCID then
  begin
    Result := FZhiKa.FIsValid;
    nHint := '����д��Ч�ĺ�ͬ���';
  end else

  if Sender = EditSMan then
  begin
    Result := (not FZhiKa.FIsXuNi) or (EditSMan.ItemIndex >= 0);
    nHint := '��ѡ����Ч��ҵ��Ա';
  end else

  if Sender = EditCustom then
  begin
    Result := (not FZhiKa.FIsXuNi) or (EditCustom.Text <> '');
    nHint := '��ѡ����Ч�Ŀͻ�';
  end else

  if Sender = EditPayment then
  begin
    Result := EditPayment.ItemIndex >= 0;
    nHint := '��ѡ����Ч�ĸ��ʽ';
  end;
end;

//Desc: ��������
procedure TfFormZhiKa.BtnOKClick(Sender: TObject);
var nIdx, nInt: integer;
    nStr,nZID,nCID,nSID,nPayment: string;
begin
  if not IsDataValid then Exit;

  nInt := 0;
  for nIdx:=Low(FStockList) to High(FStockList) do
  with FStockList[nIdx] do
  begin
    if not FSelected then Continue;

    Inc(nInt);
  end;

  if nInt<1 then
  begin
    ShowMsg('��ѡ����������', sHint);
    Exit;
  end;

  nPayment := EditPayment.Text;
  System.Delete(nPayment, 1, Length(GetCtrlData(EditPayment)) + 1);

  if FZhiKa.FIsXuNi then
  begin
    if EditCustom.ItemIndex > -1 then
         nCID := GetCtrlData(EditCustom)
    else nCID := SaveXuNiCustomer(EditCustom.Text, GetCtrlData(EditSMan));
  end else nCID := FZhiKa.FCustomer;

  if FZhiKa.FIsXuNi then
       nSID := GetCtrlData(EditSMan)
  else nSID := FZhiKa.FSaleMan;

  with FListA do
  begin
    Clear;

    Values['Z_Name']      := Trim(EditName.Text);
    Values['Z_CID']       := FZhiKa.FContract;

    Values['Z_Project']   := Trim(EditPName.Text);
    Values['Z_Customer']  := nCID;
    Values['Z_SaleMan']   := nSID;

    Values['Z_PayType']   := GetCtrlData(EditPayment);
    Values['Z_Payment']   := nPayment;
    Values['Z_Lading']    := GetCtrlData(EditLading);
    Values['Z_YFMoney']   := Trim(EditMoney.Text);

    if IsZhiKaNeedVerify then
         nStr := sFlag_No
    else nStr := sFlag_Yes;

    Values['Z_Verified']  := nStr;
    Values['Z_Man']       := gSysParam.FUserName;
    Values['Z_ID']        := FRecordID;

    FListC.Clear;
    for nIdx:=Low(FStockList) to High(FStockList) do
    begin
      with FStockList[nIdx],FListB do
      begin
        if not FSelected then Continue;
        //no selected

        Clear;
        Values['D_Type']    := FType;
        Values['D_StockNo'] := FStock;
        Values['D_StockName'] := FName;

        Values['D_Price']   := FloatToStr(FPrice);
        Values['D_Value']   := FloatToStr(FValue);

        FListC.Add(PackerEncodeStr(FListB.Text));
      end;
    end;

    Values['Z_Data'] := PackerEncodeStr(FListC.Text);
  end;

  nZID := SaveZhiKa(PackerEncodeStr(FListA.Text));

  if nZID='' then
  begin
    ShowMsg('��������ʧ��', sHint);
    Exit;
  end;
                       
  if IsPrintZK then
    PrintZhiKaReport(nZID, True);
  //print report

  if FZhiKa.FCard = '' then SaveICCardInfo(nZID, sFlag_BillSZ, sFlag_ICCardM);

  ModalResult := mrOK;
  ShowMsg('�����ѱ���', sHint);
end;

procedure TfFormZhiKa.ListDetailChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var nIdx: Integer;
begin
  inherited;
  if ctState=Change then
  try
    ListDetail.Items.BeginUpdate;

    if Item.Checked then
      for nIdx:=0 to ListDetail.Items.Count-1 do
      with ListDetail.Items[nIdx] do
        if index <> Item.Index then  Checked := False;
  finally
    ListDetail.Items.EndUpdate;
  end;  
end;

procedure TfFormZhiKa.EditCustomPropertiesChange(Sender: TObject);
var nCusID: string;
begin
  inherited;
  if FZhiKa.FIsXuNi then
  begin
    if EditCustom.ItemIndex > -1 then
         nCusID := GetCtrlData(EditCustom)
    else nCusID := SaveXuNiCustomer(EditCustom.Text, GetCtrlData(EditSMan));
  end else nCusID := FZhiKa.FCustomer;
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKa, TfFormZhiKa.FormID);
end.
