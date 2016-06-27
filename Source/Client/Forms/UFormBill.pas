{*******************************************************************************
  ����: dmzn@163.com 2014-09-01
  ����: �������
*******************************************************************************}
unit UFormBill;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxMaskEdit,
  cxDropDownEdit, cxListView, cxTextEdit, cxMCListBox, dxLayoutControl,
  StdCtrls, cxButtonEdit;

type
  TfFormBill = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    ListBill: TcxListView;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item10: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item11: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    EditType: TcxComboBox;
    EditFQ: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    EditZC: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditStockPropertiesChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
    procedure EditFQPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    FBuDanFlag: string;
    //�������
    FShowTxt: string;
    procedure LoadFormData;
    procedure LoadStockList;
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
  UDataModule, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst, UMgrLEDDisp;

type
  TCommonInfo = record
    FCard : string;
    FCardType: string;

    FZhiKa: string;
    FZKType:string;

    FCusID: string;
    FMoney: Double;
    FOnlyMoney: Boolean;
    FIDList: string;
    FShowPrice: Boolean;
    FPriceChanged: Boolean;
  end;

  TStockItem = record
    FSeal: string;
    FType: string;
    FStockNO: string;
    FStockName: string;
    FPrice: Double;
    FValue: Double;
    FSelecte: Boolean;
  end;

var
  gInfo: TCommonInfo;
  gStockList: array of TStockItem;
  //ȫ��ʹ��

class function TfFormBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool: Boolean;
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
    nP.FParamA := cCmd_ViewData;
    CreateBaseFormItem(cFI_FormReadICCard, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    gInfo.FCard     := nP.FParamC;
    gInfo.FCardType := nP.FParamF;
    
    gInfo.FZhiKa    := nP.FParamD;
    gInfo.FZKType   := nP.FParamE;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormBill.Create(Application) do
  try
    LoadFormData;
    //try load data

    if not BtnOK.Enabled then Exit;
    gInfo.FShowPrice := gPopedomManager.HasPopedom(nPopedom, sPopedom_ViewPrice);

    Caption := '�������';
    nBool := not gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    EditLading.Properties.ReadOnly := nBool;

    if nPopedom = 'MAIN_D04' then //����
         FBuDanFlag := sFlag_Yes
    else FBuDanFlag := sFlag_No;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := gInfo.FIDList
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBill.FormID: integer;
begin
  Result := cFI_FormBill;
end;

procedure TfFormBill.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(Name, 'FQLabel', '');
    if nStr <> '' then
      dxLayout1Item5.Caption := nStr;
    //xxxxx

    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    FShowTxt := nIni.ReadString(gSysParam.FProgID, 'ShowTxt',
                '�𾴵Ŀͻ���$Customer,�������Ʒ�֣�$Stock, ' +
                'ʣ����: $MoneyԪ,ʣ��������: $Value��');
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
end;

procedure TfFormBill.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;

  ReleaseCtrlData(Self);
end;

//Desc: �س���
procedure TfFormBill.EditLadingKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditStock then ActiveControl := EditValue else
    if Sender = EditValue then ActiveControl := BtnAdd else
    if Sender = EditTruck then ActiveControl := EditStock else

    if Sender = EditLading then
         ActiveControl := EditTruck
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

//------------------------------------------------------------------------------
//Desc: �����������
procedure TfFormBill.LoadFormData;
var nStr,nTmp: string;
    nDB: TDataSet;
    nIdx: integer;
begin
  BtnOK.Enabled := False;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr, gInfo.FZKType);

  if Assigned(nDB) then
  with gInfo do
  begin
    FCusID := nDB.FieldByName('C_ID').AsString;
    FShowTxt := MacroValue(FShowTxt, [
                MI('$Customer', nDB.FieldByName('C_Name').AsString)]);

    if FZKType = sFlag_BillSZ then
    begin
      FPriceChanged := nDB.FieldByName('Z_TJStatus').AsString = sFlag_TJOver;
    end else

    if FZKType = sFlag_BillFX then
    begin
      FPriceChanged := nDB.FieldByName('I_TJStatus').AsString = sFlag_TJOver;
    end else

    if FZKType = sFlag_BillFL then
    begin
      FPriceChanged := nDB.FieldByName('Z_TJStatus').AsString = sFlag_TJOver;
    end;

    FMoney := GetZhikaValidMoney(FZhiKa, FOnlyMoney, FZKType);
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  {$IFDEF SHXZY}
  BtnOK.Enabled := gInfo.FMoney>0;
  {$ELSE}
  BtnOK.Enabled := IsCustomerCreditValid(gInfo.FCusID);
  {$ENDIF}
  if not BtnOK.Enabled then
  begin
    nStr := '��������ʽ���';
    ShowMsg(nStr, sHint);
    Exit;
  end;
  //to verify credit

  SetLength(gStockList, 0);
  if (gInfo.FZKType = sFlag_BillSZ) or
     (gInfo.FZKType = sFlag_BillMY) or
     (gInfo.FZKType = sFlag_BillFL) then
  begin
    if gInfo.FZKType = sFlag_BillMY then
         nStr := 'Select * From $ZD zd ' +
                 'Left Join $MYZ my On my.M_FID=D_ZID ' +
                 'Where my.M_ID=''$ID'''
    else

    if gInfo.FZKType = sFlag_BillFL then
         nStr := 'Select * From $FLZ Where D_ZID=''$ID'''

    else nStr := 'Select * From $ZD Where D_ZID=''$ID''';

    nStr := MacroValue(nStr, [MI('$ZD', sTable_ZhiKaDtl),
            MI('$FLZ', sTable_FLZhiKaDtl),
            MI('$ID', gInfo.FZhiKa), MI('$MYZ', sTable_MYZhiKa)]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '';
      nIdx := 0;
      SetLength(gStockList, RecordCount);

      First;  
      while not Eof do
      with gStockList[nIdx] do
      begin
        FType := FieldByName('D_Type').AsString;
        FStockNO := FieldByName('D_StockNo').AsString;
        FStockName := FieldByName('D_StockName').AsString;
        FPrice := FieldByName('D_Price').AsFloat;

        FValue := 0;
        FSeal  := '';
        FSelecte := False;

        if gInfo.FPriceChanged then
        begin
          nTmp := 'Ʒ��:[ %-8s ] ԭ��:[ %.2f ] �ּ�:[ %.2f ]' + #32#32;
          nTmp := Format(nTmp, [FStockName, FieldByName('D_PPrice').AsFloat, FPrice]);
          nStr := nStr + nTmp + #13#10;
        end;

        Inc(nIdx);
        Next;
      end;
    end else
    begin
      nStr := Format('����[ %s ]û�п����ˮ��Ʒ��,����ֹ.', [gInfo.FZhiKa]);
      ShowDlg(nStr, sHint);
      BtnOK.Enabled := False; Exit;
    end;

    if gInfo.FPriceChanged then
    begin
      nStr := '����Ա�ѵ�������[ %s ]�ļ۸�,��ϸ����: ' + #13#10#13#10 +
              AdjustHintToRead(nStr) + #13#10 +
              '��ѯ�ʿͻ��Ƿ�����µ���,���ܵ�"��"��ť.' ;
      nStr := Format(nStr, [gInfo.FZhiKa]);
    
      BtnOK.Enabled := QueryDlg(nStr, sHint);
      if not BtnOK.Enabled then Exit;

      nStr := 'Update %s Set Z_TJStatus=Null Where Z_ID=''%s''';

      if gInfo.FZKType = sFlag_BillFL then
           nStr := Format(nStr, [sTable_FLZhiKa, gInfo.FZhiKa])
      else nStr := Format(nStr, [sTable_ZhiKa, gInfo.FZhiKa]);
      FDM.ExecuteSQL(nStr);
    end;
  end else

  if gInfo.FZKType = sFlag_BillFX then
  begin
    nStr := 'Select * From %s Where I_ID=''%s'' And I_Enabled=''%s''';
    nStr := Format(nStr, [sTable_FXZhiKa, gInfo.FZhiKa, sFlag_Yes]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '';
      nIdx := 0;
      SetLength(gStockList, RecordCount);

      First;  
      while not Eof do
      with gStockList[nIdx] do
      begin
        FType := FieldByName('I_StockType').AsString;
        FStockNO := FieldByName('I_StockNo').AsString;
        FStockName := FieldByName('I_StockName').AsString;
        FPrice := FieldByName('I_Price').AsFloat;

        FValue := 0;
        FSeal  := '';
        FSelecte := False;

        if gInfo.FPriceChanged then
        begin
          nTmp := 'Ʒ��:[ %-8s ] ԭ��:[ %.2f ] �ּ�:[ %.2f ]' + #32#32;
          nTmp := Format(nTmp, [FStockName, FieldByName('I_PPrice').AsFloat, FPrice]);
          nStr := nStr + nTmp + #13#10;
        end;

        Inc(nIdx);
        Next;
      end;
    end else
    begin
      nStr := Format('����[ %s ]û�п����ˮ��Ʒ��,����ֹ.', [gInfo.FZhiKa]);
      ShowDlg(nStr, sHint);
      BtnOK.Enabled := False; Exit;
    end;

    if gInfo.FPriceChanged then
    begin
      nStr := '����Ա�ѵ�����������[ %s ]�ļ۸�,��ϸ����: ' + #13#10#13#10 +
              AdjustHintToRead(nStr) + #13#10 +
              '��ѯ�ʿͻ��Ƿ�����µ���,���ܵ�"��"��ť.' ;
      nStr := Format(nStr, [gInfo.FZhiKa]);
    
      BtnOK.Enabled := QueryDlg(nStr, sHint);
      if not BtnOK.Enabled then Exit;

      nStr := 'Update %s Set I_TJStatus=Null Where I_ID=''%s''';
      nStr := Format(nStr, [sTable_FXZhiKa, gInfo.FZhiKa]);
      FDM.ExecuteSQL(nStr);
    end;
  end;

  LoadStockList;
  //load stock into window

  EditType.ItemIndex := 0;
  ActiveControl := EditTruck;
end;

//Desc: ˢ��ˮ���б�����
procedure TfFormBill.LoadStockList;
var nStr: string;
    i,nIdx: integer;
begin
  AdjustCXComboBoxItem(EditStock, True);
  nIdx := ListBill.ItemIndex;

  ListBill.Items.BeginUpdate;
  try
    ListBill.Clear;
    for i:=Low(gStockList) to High(gStockList) do
    if gStockList[i].FSelecte then
    begin
      with ListBill.Items.Add do
      begin
        Caption := gStockList[i].FStockName;
        SubItems.Add(EditTruck.Text);
        SubItems.Add(FloatToStr(gStockList[i].FValue));

        Data := Pointer(i);
        ImageIndex := cItemIconIndex;
      end;
    end else
    begin
      nStr := Format('%d=%s', [i, gStockList[i].FStockName]); 
      EditStock.Properties.Items.Add(nStr);
    end;
  finally
    ListBill.Items.EndUpdate;
    if ListBill.Items.Count > nIdx then
      ListBill.ItemIndex := nIdx;
    //xxxxx

    AdjustCXComboBoxItem(EditStock, False);
    EditStock.ItemIndex := 0;
  end;
end;

//Dessc: ѡ��Ʒ��
procedure TfFormBill.EditStockPropertiesChange(Sender: TObject);
var nInt: Int64;
begin
  dxGroup2.Caption := '�ᵥ��ϸ';
  if EditStock.ItemIndex < 0 then Exit;

  with gStockList[StrToInt(GetCtrlData(EditStock))] do
  if FPrice > 0 then
  begin
    nInt := Float2PInt(gInfo.FMoney / FPrice, cPrecision, False);
    EditValue.Text := FloatToStr(nInt / cPrecision);

    FSeal := GetStockBatcode(FStockNO, '', nInt/cPrecision);
    EditFQ.Text := FSeal;

    if gInfo.FShowPrice then
      dxGroup2.Caption := Format('�ᵥ��ϸ ����:%.2fԪ/��', [FPrice]);
    //xxxxx
  end;
end;

function TfFormBill.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditStock then
  begin
    Result := EditStock.ItemIndex > -1;
    nHint := '��ѡ��ˮ������';
  end else

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '���ƺų���Ӧ����2λ';
  end else

  if Sender = EditLading then
  begin
    Result := EditLading.ItemIndex > -1;
    nHint := '��ѡ����Ч�������ʽ';
  end;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    nHint := '����д��Ч�İ�����';

    if not Result then Exit;
    if not OnVerifyCtrl(EditStock, nHint) then Exit;

    with gStockList[StrToInt(GetCtrlData(EditStock))] do
    if FPrice > 0 then
    begin
      nVal := StrToFloat(EditValue.Text);
      nVal := Float2Float(nVal, cPrecision, False);
      Result := FloatRelation(gInfo.FMoney / FPrice, nVal, rtGE, cPrecision);

      nHint := '�ѳ����ɰ�����';
      if not Result then Exit;

      if FloatRelation(gInfo.FMoney / FPrice, nVal, rtEqual, cPrecision) then
      begin
        nHint := '';
        Result := QueryDlg('ȷ��Ҫ�����������ȫ��������?', sAsk);
        if not Result then ActiveControl := EditValue;
      end;
    end else
    begin
      Result := False;
      nHint := '����[ 0 ]��Ч';
    end;
  end;
end;

//Desc: ���
procedure TfFormBill.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  if IsDataValid then
  begin
    nIdx := StrToInt(GetCtrlData(EditStock));
    with gStockList[nIdx] do
    begin
      if (FType = sFlag_San) and (ListBill.Items.Count > 0) then
      begin
        ShowMsg('ɢװˮ�಻�ܻ�װ', sHint);
        ActiveControl := EditStock;
        Exit;
      end;

      FValue := StrToFloat(EditValue.Text);
      FValue := Float2Float(FValue, cPrecision, False);
      FSelecte := True;

      EditTruck.Properties.ReadOnly := True;
      gInfo.FMoney := gInfo.FMoney - FPrice * FValue;
    end;

    LoadStockList;
    ActiveControl := BtnOK;
  end;
end;

//Desc: ɾ��
procedure TfFormBill.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListBill.ItemIndex > -1 then
  begin
    nIdx := Integer(ListBill.Items[ListBill.ItemIndex].Data);
    with gStockList[nIdx] do
    begin
      FSelecte := False;
      gInfo.FMoney := gInfo.FMoney + FPrice * FValue;
    end;

    LoadStockList;
    EditTruck.Properties.ReadOnly := ListBill.Items.Count > 0;
  end;
end;

//Desc: ����
procedure TfFormBill.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nPrint, nFix: Boolean;
    nMoney, nPrice: Double;
    nList,nTmp,nStocks: TStrings;
begin
  if ListBill.Items.Count < 1 then
  begin
    ShowMsg('���Ȱ��������', sHint); Exit;
  end;

  nStocks := TStringList.Create;
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    {$IFDEF XAZL} //�°�����: ��֤Ʒ���ܷ񷢻�
    nList.Clear;
    for nIdx:=Low(gStockList) to High(gStockList) do
     with gStockList[nIdx],nTmp do
      if FSelecte then nList.Add(FStockNO);
    //xxxxx

    if not IsStockValid(CombinStr(nList, ',')) then Exit;
    {$ENDIF}

    nList.Clear;
    nPrice := -1;
    nPrint := False;
    LoadSysDictItem(sFlag_PrintBill, nStocks);
    //���ӡƷ��

    for nIdx:=Low(gStockList) to High(gStockList) do
    with gStockList[nIdx],nTmp do
    begin
      if not FSelecte then Continue;
      //xxxxx

      Values['Seal'] := FSeal;
      Values['Type'] := FType;
      Values['StockNO'] := FStockNO;
      Values['StockName'] := FStockName;
      Values['Price'] := FloatToStr(FPrice);
      Values['Value'] := FloatToStr(FValue);

      nList.Add(PackerEncodeStr(nTmp.Text));
      //new bill

      if (not nPrint) and (FBuDanFlag <> sFlag_Yes) then
        nPrint := nStocks.IndexOf(FStockNO) >= 0;
      //xxxxx

      nPrice   := FPrice;
      FShowTxt := MacroValue(FShowTxt, [
                  MI('$Stock', Values['StockName'])]);
    end;

    with nList do
    begin
      Values['Bills'] := PackerEncodeStr(nList.Text);
      Values['ZhiKa'] := gInfo.FZhiKa;
      Values['ZKType']:= gInfo.FZKType;
      Values['Truck'] := EditTruck.Text;
      Values['Lading'] := GetCtrlData(EditLading);
      Values['IsVIP'] := GetCtrlData(EditType);
      Values['BuDan'] := FBuDanFlag;

      Values['ICCard']  := gInfo.FCard;
      Values['ICCardType'] := gInfo.FCardType;
    end;

    gInfo.FIDList := SaveBill(PackerEncodeStr(nList.Text));
    //call mit bus
    if gInfo.FIDList = '' then Exit;

    if nPrice<=0 then nPrice := 65535;

    nMoney := GetZhikaValidMoney(gInfo.FZhiKa, nFix, gInfo.FZKType);
    nPrice := nMoney / nPrice;
    nPrice := Float2Float(nPrice, cPrecision, False);

    FShowTxt := MacroValue(FShowTxt, [
                MI('$Money', FloatToStr(nMoney)),
                MI('$Value', FloatToStr(nPrice))]);
  finally
    nTmp.Free;
    nList.Free;
    nStocks.Free;
  end;

  if FBuDanFlag <> sFlag_Yes then
    SetBillCard(gInfo.FIDList, EditTruck.Text, True);
  //����ſ�

  if nPrint then
    PrintBillReport(gInfo.FIDList, True);
  //print report
  
  ModalResult := mrOk;
  ShowMsg('���������ɹ�', sHint);
  gDisplayManager.Display('ShowBill', FShowTxt);
end;

procedure TfFormBill.EditFQPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  inherited;
  nP.FParamA := gStockList[StrToInt(GetCtrlData(EditStock))].FStockNO;
  CreateBaseFormItem(cFI_FormGetStockNo, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  EditFQ.Text := nP.FParamB;
  gStockList[StrToInt(GetCtrlData(EditStock))].FSeal := EditFQ.Text;
end;

procedure TfFormBill.EditTruckPropertiesEditValueChanged(Sender: TObject);
var nSQL: string;
begin
  inherited;
  //
  nSQL := 'Select T_Bearings From %s Where T_Truck=''%s''';
  nSQL := Format(nSQL, [sTable_Truck, Trim(EditTruck.Text)]);
  with FDM.QuerySQL(nSQL) do
  if RecordCount > 0 then EditZC.Text := Fields[0].AsString; 
end;

initialization
  gControlManager.RegCtrl(TfFormBill, TfFormBill.FormID);
end.
