{*******************************************************************************
  ����: fendou116688@163.com 2015/11/19
  ����: �����������
*******************************************************************************}

unit UFormFXZhiKa;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UFormInputbox, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxMaskEdit,
  cxDropDownEdit, cxListView, cxTextEdit, cxMCListBox, dxLayoutControl,
  StdCtrls, cxButtonEdit, dxLayoutcxEditAdapters, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, cxMemo;

type
  TfFormFXZhiKa = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    ListFXZhiKa: TcxListView;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item10: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    cxMemo1: TcxMemo;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditStockPropertiesChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
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
  UDataModule, USysPopedom, USysBusiness, USysDB, USysGrid, USysConst, UFormCtrl;

type
  TCommonInfo = record
    FZhiKa: string;
    FCusID: string;
    FCard : string;
    FMoney: Double;
    FPayType: String;
    FPayMent: string;

    FSaleMan: string;
    FOnlyMoney: Boolean;
    FOldStockNO: string;

    FIDList: string;
    FShowPrice: Boolean;
    FPriceChanged: Boolean;
  end;

  TStockItem = record
    FType: string;
    FStockNO: string;
    FStockName: string;
    FPrice: Double;
    FValue: Double;
    FSelected: Boolean;
  end;

var
  gInfo: TCommonInfo;

  gRecordID: string='';
  gStockList: array of TStockItem;
  //ȫ��ʹ��

class function TfFormFXZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nStr: string;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;


  {
  try
    nP.FParamA := cCmd_ViewData;
    CreateBaseFormItem(cFI_FormReadFXZhiKa, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    gInfo.FZhiKa := nP.FParamD;
    gInfo.FCard  := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;}

  gRecordID := nP.FParamA;
  //׷�ӿ�����ʱʹ��
  if gRecordID <> '' then
  begin
    nStr := 'Select I_StockNo, I_ZID From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_FXZhiKa, gRecordID]);
    with FDM.QueryTemp(nStr) do
    if RecordCount<1 then Exit else
    begin
      gInfo.FZhiKa      := Fields[1].AsString;
      gInfo.FOldStockNO := Fields[0].AsString;
    end;   
  end else

  try
    CreateBaseFormItem(cFI_FormGetZhika, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    gInfo.FZhiKa := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormFXZhiKa.Create(Application) do
  try
    LoadFormData;
    //try load data

    if not BtnOK.Enabled then Exit;
    gInfo.FShowPrice := gPopedomManager.HasPopedom(nPopedom, sPopedom_ViewPrice);

    Caption := '�����������';
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

class function TfFormFXZhiKa.FormID: integer;
begin
  Result := cFI_FormFXZhiKa;
end;

procedure TfFormFXZhiKa.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListFXZhiKa, nIni);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'FX');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;    

  AdjustCtrlData(Self);
end;

procedure TfFormFXZhiKa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, ListInfo);
  SavecxListViewConfig(Name, ListFXZhiKa);
  ReleaseCtrlData(Self);
end;

//Desc: �س���
procedure TfFormFXZhiKa.EditLadingKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;

    if Sender = EditStock then ActiveControl := EditValue else
    if Sender = EditValue then ActiveControl := BtnAdd
    else Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����������
procedure TfFormFXZhiKa.LoadFormData;
var nStr,nTmp: string;
    nDB: TDataSet;
    nIdx: integer;
begin
  BtnOK.Enabled := False;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr);

  if Assigned(nDB) then
  with gInfo do
  begin
    FCard  := nDB.FieldByName('Z_CardNO').AsString;
    FCusID := nDB.FieldByName('Z_Customer').AsString;
    FSaleMan := nDB.FieldByName('Z_SaleMan').AsString;
    FPayType := nDB.FieldByName('Z_PayType').AsString;
    FPayment := nDB.FieldByName('Z_Payment').AsString;
    FPriceChanged := nDB.FieldByName('Z_TJStatus').AsString = sFlag_TJOver;

    FMoney := GetZhikaValidMoney(gInfo.FZhiKa, gInfo.FOnlyMoney);
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  BtnOK.Enabled := IsCustomerCreditValid(gInfo.FCusID + sFlag_Delimater + gInfo.FPayType);
  if not BtnOK.Enabled then Exit;
  //to verify credit

  SetLength(gStockList, 0);
  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, gInfo.FZhiKa]);

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
      FValue := FieldByName('D_Value').AsFloat;
      //�������ɷ���

      FSelected := False;

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
    nStr := Format(nStr, [sTable_ZhiKa, gInfo.FZhiKa]);
    FDM.ExecuteSQL(nStr);
  end;

  LoadStockList;
  //load stock into window

  ActiveControl := EditValue;
end;

//Desc: ˢ��ˮ���б�����
procedure TfFormFXZhiKa.LoadStockList;
var nStr: string;
    i,nIdx: integer;
begin
  AdjustCXComboBoxItem(EditStock, True);
  nIdx := ListFXZhiKa.ItemIndex;

  ListFXZhiKa.Items.BeginUpdate;
  try
    ListFXZhiKa.Clear;
    for i:=Low(gStockList) to High(gStockList) do
    if gStockList[i].FSelected then
    begin
      with ListFXZhiKa.Items.Add do
      begin
        Caption := gStockList[i].FStockName;
        SubItems.Add(FloatToStr(gStockList[i].FValue));

        Data := Pointer(i);
        ImageIndex := cItemIconIndex;
      end;
    end else
    begin
      if (gInfo.FOldStockNO <> '') and
        (gInfo.FOldStockNO <> gStockList[i].FStockNO) then Continue;
      nStr := Format('%d=%s', [i, gStockList[i].FStockName]);
      EditStock.Properties.Items.Add(nStr);
    end;
  finally
    ListFXZhiKa.Items.EndUpdate;
    if ListFXZhiKa.Items.Count > nIdx then
      ListFXZhiKa.ItemIndex := nIdx;
    //xxxxx

    AdjustCXComboBoxItem(EditStock, False);
    EditStock.ItemIndex := 0;
  end;
end;

//Dessc: ѡ��Ʒ��
procedure TfFormFXZhiKa.EditStockPropertiesChange(Sender: TObject);
var nInt: Int64;
begin
  dxGroup2.Caption := '�ᵥ��ϸ';
  if EditStock.ItemIndex < 0 then Exit;

  with gStockList[StrToInt(GetCtrlData(EditStock))] do
  if FPrice > 0 then
  begin
    nInt := Float2PInt(gInfo.FMoney / FPrice, cPrecision, False);
    EditValue.Text := FloatToStr(nInt / cPrecision);

    if gInfo.FShowPrice then
      dxGroup2.Caption := Format('�ᵥ��ϸ ����:%.2fԪ/��', [FPrice]);
    //xxxxx
  end;
end;

function TfFormFXZhiKa.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditStock then
  begin
    Result := EditStock.ItemIndex > -1;
    nHint := '��ѡ��ˮ������';
  end else
  
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
procedure TfFormFXZhiKa.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  if IsDataValid then
  begin
    nIdx := StrToInt(GetCtrlData(EditStock));
    with gStockList[nIdx] do
    begin
      if ListFXZhiKa.Items.Count > 0 then
      begin
        ShowMsg('����ֻ�ܰ���һ��Ʒ��', sHint);
        ActiveControl := EditStock;
        Exit;
      end;

      FValue := StrToFloat(EditValue.Text);
      FValue := Float2Float(FValue, cPrecision, False);
      FSelected := True;

      gInfo.FMoney := gInfo.FMoney - FPrice * FValue;
    end;

    LoadStockList;
    ActiveControl := BtnOK;
  end;
end;

//Desc: ɾ��
procedure TfFormFXZhiKa.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListFXZhiKa.ItemIndex > -1 then
  begin
    nIdx := Integer(ListFXZhiKa.Items[ListFXZhiKa.ItemIndex].Data);
    with gStockList[nIdx] do
    begin
      FSelected := False;
      gInfo.FMoney := gInfo.FMoney + FPrice * FValue;
    end;

    LoadStockList;
  end;
end;

//Desc: ����
procedure TfFormFXZhiKa.BtnOKClick(Sender: TObject);
var nStr, nID, nEvent: string;
    nIdx: Integer;
    nMoney: Double;
begin
  if ListFXZhiKa.Items.Count < 1 then
  begin
    ShowMsg('���Ȱ������������', sHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    for nIdx:=Low(gStockList) to High(gStockList) do
    with gStockList[nIdx] do
    begin
      if not FSelected then Continue;

      nID    := FDM.GetSerialID(FPrefixID, sTable_FXZhiKa, 'I_ID');
      nMoney := Float2Float(FPrice * FValue, cPrecision, False);

      if gRecordID = '' then
      begin
        nStr := MakeSQLByStr([SF('I_ID', nID),
                SF('I_ZID', gInfo.FZhiKa),
                SF('I_StockType', FType),
                SF('I_StockNo', FStockNO),
                SF('I_StockName', FStockName),

                SF('I_Customer', gInfo.FCusID),
                SF('I_SaleMan', gInfo.FSaleMan),

                SF('I_Paytype', gInfo.FPayType),
                SF('I_Payment', gInfo.FPayMent),

                SF('I_Price', FloatToStr(FPrice), sfVal),
                SF('I_Value', FloatToStr(FValue), sfVal),
                SF('I_Money', FloatToStr(nMoney), sfVal),
                SF('I_Date', FDM.SQLServerNow, sfVal),

                SF('I_ParentCard', gInfo.FCard),
                SF('I_Memo', cxMemo1.Text)
                ], sTable_FXZhiKa, '', True);
        //xxxxx
        FDM.ExecuteSQL(nStr);

      end else

      begin

        nStr := 'Select I_Enabled From %s Where R_ID=%s';
        nStr := Format(nStr, [sTable_FXZhiKa, gRecordID]);
        with FDM.QueryTemp(nStr) do
        if (RecordCount<1) or (Fields[0].AsString = sFlag_No) then
        begin
          nStr := '��¼��Ϊ [ %s ] ������������Ч������׷�Ӷ��!';
          nStr := Format(nStr, [gRecordID]);
          ShowMsg(nStr, sHint);

          if FDM.ADOConn.InTransaction then
            FDM.ADOConn.RollbackTrans;
          Exit;
        end;

        nStr := 'Update %s Set I_Money=I_Money+(%s),I_Value=I_Value+(%s),' +
                'I_VerifyMan=''%s'',I_VerifyDate=%s Where R_ID=%s';
        nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nMoney),FloatToStr(FValue),
                gSysParam.FUserID, FDM.SQLServerNow, gRecordID]);
        FDM.ExecuteSQL(nStr);

        nEvent := '����������� [%s], ���ö��������[%s]';
        nEvent := Format(nEvent, [FloatToStr(FValue),FloatToStr(nMoney)]);
        FDM.WriteSysLog(sFlag_ZhiKaItem, gRecordID, nEvent);
      end;

      nStr := 'Update %s Set A_CardUseMoney=A_CardUseMoney+%s ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nMoney),
              gInfo.FCusID, gInfo.FPayType]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('������������ɹ�', sHint);
    
    if (gRecordID = '') then SaveICCardInfo(nID, sFlag_BillFX, sFlag_ICCardV);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    ShowMsg('������������ʧ��', sError); Exit;
  end; 
end;

initialization
  gControlManager.RegCtrl(TfFormFXZhiKa, TfFormFXZhiKa.FormID);
end.
