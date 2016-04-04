{*******************************************************************************
����: fendou116688@163.com 2015/11/26
����: ���������ͬ����
*******************************************************************************}
unit UFormTransContract;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxLayoutControl, cxLabel,
  cxCheckBox, cxTextEdit, cxDropDownEdit, cxMCListBox, cxMaskEdit,
  cxButtonEdit, StdCtrls, cxMemo;

type
  TCommonInfo = record
    FCusID: string;
    FCusPY: string;

    FSaleID: string;
    FSalePY: string;

    FCalcMoney: Boolean;
    FCusMoney: Double;
  end;

  TCusAddrInfo = record
    FCusID: string;
    FAddrID:string;

    FDelivery: string;
    FRecvMan:  string;
    FRecvPhone: string;
    FDistance: Double;

    FCusPrice: Double;
    FDrvPrice: Double;
  end;

  TfFormTransContract = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditCPrice: TcxTextEdit;
    dxLayoutControl1Item16: TdxLayoutItem;
    EditDPrice: TcxTextEdit;
    dxLayoutControl1Item17: TdxLayoutItem;
    dxLayoutControl1Group12: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    EditCusName: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    EditSaleMan: TcxTextEdit;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    dxLayoutControl1Group3: TdxLayoutGroup;
    EditProject: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditAddr: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditArea: TcxButtonEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditSrcAddr: TcxTextEdit;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditPayment: TcxComboBox;
    dxLayoutControl1Item9: TdxLayoutItem;
    EditAID: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    EditRecvMan: TcxTextEdit;
    dxLayoutControl1Item13: TdxLayoutItem;
    EditCusPhone: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayoutControl1Item15: TdxLayoutItem;
    dxLayoutControl1Group8: TdxLayoutGroup;
    EditStock: TcxTextEdit;
    dxLayoutControl1Item18: TdxLayoutItem;
    dxLayoutControl1Group9: TdxLayoutGroup;
    EditDriver: TcxTextEdit;
    dxLayoutControl1Item19: TdxLayoutItem;
    EditDPhone: TcxTextEdit;
    dxLayoutControl1Item20: TdxLayoutItem;
    EditLID: TcxButtonEdit;
    dxLayoutControl1Item21: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayoutControl1Item22: TdxLayoutItem;
    EditTValue: TcxTextEdit;
    dxLayoutControl1Item23: TdxLayoutItem;
    EditDistance: TcxTextEdit;
    dxLayoutControl1Item24: TdxLayoutItem;
    EditDestAddr: TcxTextEdit;
    dxLayoutControl1Item25: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditLIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditAreaPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditAIDPropertiesChange(Sender: TObject);
    procedure EditTruckPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FRID: string;
    FInfo: TCommonInfo;
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadCusAddrInfo(const nCusID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormCtrl, UAdjustForm, UMgrControl, UFormBaseInfo,
  USysBusiness, USysGrid, USysDB, USysConst;

var
  gAddrs: array of TCusAddrInfo;
  gForm: TfFormTransContract = nil;
  //ȫ��ʹ��

class function TfFormTransContract.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
    nP := nParam
  else
  begin
    New(nP);
    nP.FCommand := cCmd_AddData;
  end;  


  case nP.FCommand of
   cCmd_AddData:
    with TfFormTransContract.Create(Application) do
    begin
      FRID := '';
      Caption := '�˷�Э�� - ���';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;

      if not Assigned(nParam) then Dispose(nP);
      Free;
    end;
   cCmd_EditData:
    with TfFormTransContract.Create(Application) do
    begin
      FRID := nP.FParamA;
      Caption := '�˷�Э�� - �޸�';

      InitFormData(FRID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormTransContract.Create(Application);
        with gForm do
        begin
          Caption := '�˷�Э�� - �鿴';
          FormStyle := fsStayOnTop;
          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        FRID := nP.FParamA;
        InitFormData(FRID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormTransContract.FormID: integer;
begin
  Result := cFI_FormTransContract;
end;

//------------------------------------------------------------------------------
procedure TfFormTransContract.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'PC');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  FillChar(FInfo, SizeOf(TCommonInfo), #0);

  ResetHintAllForm(Self, 'T', sTable_TransContract);
end;

procedure TfFormTransContract.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  
  gForm := nil;  
  Action := caFree;
end;

procedure TfFormTransContract.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormTransContract.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//Date: 2009-6-2
//Parm: ��ͬ���
//Desc: ����nID��ͬ����Ϣ������
procedure TfFormTransContract.InitFormData(const nID: string);
var nStr: string;
    nDS : TDataSet;
begin
  if nID='' then Exit;
  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_TransContract, nID]);
  nDS  := FDM.QueryTemp(nStr);

  if nDS.RecordCount < 1 then Exit;
  LoadDataToCtrl(nDS, Self, '');

  with nDS, FInfo do
  begin
    FCusID := FieldByName('T_CusID').AsString;
    FCusPY := FieldByName('T_CusPY').AsString;
    FSaleID:= FieldByName('T_SaleID').AsString;
    FSalePY:= FieldByName('T_SalePY').AsString;

    FCusMoney := FieldByName('T_CusMoney').AsFloat;
    FCalcMoney:= Pos('��', FieldByName('T_PayMent').AsString) > 0;

    EditValue.Text := Format('%.2f', [FieldByName('T_WeiValue').AsFloat]);
    EditTValue.Text := Format('%.2f', [FieldByName('T_TrueValue').AsFloat]);
    EditDPrice.Text := Format('%.2f', [FieldByName('T_DPrice').AsFloat]);
    EditCPrice.Text := Format('%.2f', [FieldByName('T_CPrice').AsFloat]);
    EditDistance.Text:=Format('%.2f', [FieldByName('T_DisValue').AsFloat]);
  end;

  LoadCusAddrInfo(FInfo.FCusID);
end;

procedure TfFormTransContract.LoadCusAddrInfo(const nCusID: string);
var nIdx: Integer;
    nSQL: string;
begin
  if FInfo.FCusID = '' then Exit;

  if FInfo.FCusID <> '' then
  begin
    SetLength(gAddrs, 0);

    nSQL := 'Select * From %s Where A_CID=''%s''';
    nSQL := Format(nSQL, [sTable_CusAddr, FInfo.FCusID]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount>0 then
    begin
      SetLength(gAddrs, RecordCount);

      First;
      nIdx := 0;

      while not Eof do
      try
        with gAddrs[nIdx] do
        begin
          FCusID := FieldByName('A_CID').AsString;
          FAddrID:= FieldByName('A_ID').AsString;

          FRecvPhone:= FieldByName('A_RecvPhone').AsString;
          FDelivery := FieldByName('A_Delivery').AsString;
          FRecvMan  := FieldByName('A_RecvMan').AsString;

          FDistance := FieldByName('A_Distance').AsFloat;
          FCusPrice := FieldByName('A_CPrice').AsFloat;
          FDrvPrice := FieldByName('A_DPrice').AsFloat;

          EditAID.Properties.Items.AddObject(FAddrID + '.' + FDelivery,
            Pointer(nIdx));
        end;

        Inc(nIdx); 
      finally
        Next;
      end;
    end;  

    if EditPayment.Properties.Items.Count<1 then
    begin
      nSQL := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                         MI('$Name', sFlag_PaymentItem3)]);
      //xxxxx
      with FDM.QueryTemp(nSQL) do
      if RecordCount>0 then
      begin
        First;

        while not Eof do
        try
          EditPayment.Properties.Items.Add(FieldByName('D_Value').AsString);
        finally
          Next;
        end;
      end;
    end;

    if EditAID.Properties.Items.Count>0 then EditAID.ItemIndex := 0;
    if EditPayment.Properties.Items.Count>0 then EditPayment.ItemIndex := 0;
  end;

end;  

//Desc: ��������
procedure TfFormTransContract.BtnOKClick(Sender: TObject);
var nStr, nSQL, nSQLTmp: string;
    nList: TStrings;
    nTVal, nFVal, nDPrice, nCPrice, nCusMoney, nDrvMoney, nMoney: Double;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('����д��Ч��Э����', sHint); Exit;
  end;

  if (not IsNumber(EditCPrice.Text, True))
    Or (StrToFloat(EditCPrice.Text) <= 0 ) then
  begin
    EditCPrice.SetFocus;
    ShowMsg('����д��Ч�Ŀͻ��˷Ѽ۸�', sHint); Exit;
  end;

  if (not IsNumber(EditDPrice.Text, True))
    Or (StrToFloat(EditDPrice.Text) <= 0 ) then
  begin
    EditDPrice.SetFocus;
    ShowMsg('����д��Ч��˾���˷Ѽ۸�', sHint); Exit;
  end;

  if (not IsNumber(EditValue.Text, True))
    Or (StrToFloat(EditValue.Text) <= 0 ) then
  begin
    EditValue.SetFocus;
    ShowMsg('����д��Ч�ķ�����', sHint); Exit;
  end;

  if not IsNumber(EditTValue.Text, True) then
  begin
    EditTValue.SetFocus;
    ShowMsg('����д��Ч���˻���', sHint); Exit;
  end;

  if FRID = '' then
  begin
    nSQL := 'Select count(*) From %s Where T_ID=''%s''';
    nSQL := Format(nSQL, [sTable_TransContract, EditID.Text]);
    with FDM.QuerySQL(nSQL) do
    if (RecordCount>0) and (Fields[0].AsInteger>0) then
    begin
      nStr := 'Э���� [ %s ] �Ѿ�����';
      nStr := Format(nStr, [EditID.Text]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nSQL := 'Select count(*) From %s Where T_LID=''%s'' ' +
            'And IsNull(T_Enabled, '''') <> ''%s''';
    nSQL := Format(nSQL, [sTable_TransContract, EditLID.Text, sFlag_No]);
    with FDM.QuerySQL(nSQL) do
    if (RecordCount>0) and (Fields[0].AsInteger>0) then
    begin
      nStr := '�������� [ %s ] �Ѿ������˷�Э��';
      nStr := Format(nStr, [EditLID.Text]);
      ShowMsg(nStr, sHint);
      Exit;
    end;
  end;

  nTVal := StrToFloatDef(EditTValue.Text, 0);
  nFVal := StrToFloatDef(EditValue.Text, 0);
  nDPrice := StrToFloatDef(EditDPrice.Text, 0);
  nCPrice := StrToFloatDef(EditCPrice.Text, 0);

  nCusMoney := Float2Float(nCPrice * (nFVal-nTVal), cPrecision, True);
  nDrvMoney := Float2Float(nDPrice * (nFVal-nTVal), cPrecision, True);

  nList := TStringList.Create;
  try
    nStr := SF('T_CusID', FInfo.FCusID);
    nList.Add(nStr);

    nStr := SF('T_CusPY', FInfo.FCusPY);
    nList.Add(nStr);

    nStr := SF('T_SaleID', FInfo.FSaleID);
    nList.Add(nStr);

    nStr := SF('T_SalePY', FInfo.FSalePY);
    nList.Add(nStr);

    nStr := SF('T_CPrice', FloatToStr(nCPrice), sfVal);
    nList.Add(nStr);

    nStr := SF('T_DPrice', FloatToStr(nDPrice), sfVal);
    nList.Add(nStr);

    nStr := SF('T_DisValue', EditDistance.Text, sfVal);
    nList.Add(nStr);

    nStr := SF('T_WeiValue', FloatToStr(nFVal), sfVal);
    nList.Add(nStr);

    nStr := SF('T_TrueValue', FloatToStr(nTVal), sfVal);
    nList.Add(nStr);

    nStr := SF('T_DrvMoney', FloatToStr(nDrvMoney), sfVal);
    nList.Add(nStr);

    nStr := SF('T_CusMoney', FloatToStr(nCusMoney), sfVal);
    nList.Add(nStr);

    if FRID = '' then
    begin
      nStr := SF('T_Date', FDM.SQLServerNow, sfVal);
      nList.Add(nStr);

      nStr := SF('T_Man', gSysParam.FUserID);
      nList.Add(nStr);

      nSQL := MakeSQLByForm(Self, sTable_TransContract, '', True, nil, nList);
    end else
    begin
      nStr := SF('T_VerifyDate', FDM.SQLServerNow, sfVal);
      nList.Add(nStr);

      nStr := SF('T_VerifyMan', gSysParam.FUserID);
      nList.Add(nStr);

      nStr := SF('R_ID', FRID, sfVal);
      nSQL := MakeSQLByForm(Self, sTable_TransContract, nStr, False, nil, nList);
    end;
  finally
    nList.Free;
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);
    //xxxxx

    if FInfo.FCalcMoney and (FInfo.FCusID <> '') then
    begin
      nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%s) Where A_CID=''%s''';
      nSQL := Format(nSQL, [sTable_TransAccount, FloatToStr(FInfo.FCusMoney),
              FInfo.FCusID]);
      FDM.ExecuteSQL(nSQL);
    end;
    //Edit���޸�ǰ����ͻ��˷�,���Ȼ�ԭ�˷�

    if Pos('��', EditPayment.Text)>0 then
    begin
      nSQLTmp := 'Select * From %s Where A_CID=''%s''';
      nSQLTmp := Format(nSQLTmp, [sTable_TransAccount, FInfo.FCusID]);

      with FDM.QuerySQL(nSQLTmp) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '���Ϊ[ %s ]�Ŀͻ��˻�������.';
          nStr := Format(nStr, [FInfo.FCusID]);
          raise Exception.Create(nStr);
        end;

        nMoney := FieldByName('A_BeginBalance').AsFloat +
                  FieldByName('A_InMoney').AsFloat +
                  FieldByName('A_RefundMoney').AsFloat +
                  FieldByName('A_CreditLimit').AsFloat-
                  FieldByName('A_OutMoney').AsFloat -
                  FieldByName('A_CardUseMoney').AsFloat -
                  FieldByName('A_Compensation').AsFloat - //������������������
                  FieldByName('A_FreezeMoney').AsFloat;
        //xxxxx

        nMoney := Float2Float(nMoney, cPrecision, False);

        if FloatRelation(nCusMoney, nMoney, rtGreater, cPrecision) then
        begin
          nStr := '�ͻ�[ %s ]��û���㹻���˷ѽ��,��������:' + #13#10#13#10 +
                 '���ý��: %.2f' + #13#10 +
                 '�����˷�: %.2f' + #13#10#13#10 +
                 '�������˷�.';
          nStr := Format(nStr, [EditCusName.Text, nMoney, nCusMoney]);
          raise Exception.Create(nStr);
        end;
      end;

      nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%s) Where A_CID=''%s''';
      nSQL := Format(nSQL, [sTable_TransAccount, FloatToStr(nCusMoney),
              FInfo.FCusID]);
      FDM.ExecuteSQL(nSQL);
      //�����˷�
    end;
    //�س����˷�У���˷�

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('װж����Э�鱣��ɹ�', sHint);
  except
    on E:Exception do
    begin
      FDM.ADOConn.RollbackTrans;
      
      nStr := 'װж����Э�鱣��ʧ��,' + E.Message;
      ShowDlg(nStr, sHint);
    end;
  end;

  if ModalResult = mrOk then PrintTransContractReport(EditID.Text, False);
end;

procedure TfFormTransContract.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  inherited;
  if FRID <> '' then Exit;
  //�鿴�����޸�
  
  EditID.Text := FDM.GetSerialID(FPrefixID, sTable_TransContract, 'T_ID');
end;

procedure TfFormTransContract.EditLIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nSQL, nStr, nID: string;
    nP: TFormCommandParam;
begin
  inherited;
  if FRID <> '' then Exit;
  //�鿴�����޸�
  nID := Trim(EditLID.Text);

  nP.FParamA := nID;
  CreateBaseFormItem(cFI_FormGetBill, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  nID := nP.FParamB;

  nSQL := 'Select * From %s Where L_ID = ''%s''';
  nSQL := Format(nSQL, [sTable_Bill, nID]);
  with FDM.QueryTemp(nSQL), FInfo do
  begin
    if RecordCount<1 then
    begin
      nStr := '�������� [%s] ����Ч!';
      nStr := Format(nStr, [nID]);
      ShowMsg(nStr, sHint); Exit;
    end;

    FCusID := FieldByName('L_CusID').AsString;
    FCusPY := FieldByName('L_CusPY').AsString;

    FSaleID := FieldByName('L_SaleID').AsString;
    FSalePY := GetPinYinOfStr(FieldByName('L_SaleMan').AsString);

    EditLID.Text     := FieldByName('L_ID').AsString;
    EditCusName.Text := FieldByName('L_CusName').AsString;
    EditSaleMan.Text := FieldByName('L_SaleMan').AsString;

    EditArea.Text    := FieldByName('L_Area').AsString;
    EditTruck.Text   := FieldByName('L_Truck').AsString;
    EditProject.Text := FieldByName('L_Project').AsString;

    EditStock.Text   := FieldByName('L_StockName').AsString;
    EditValue.Text   := FloatToStr(FieldByName('L_Value').AsFloat);
  end;

  LoadCusAddrInfo(FInfo.FCusID);
end;

procedure TfFormTransContract.EditAreaPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nBool,nSelected: Boolean;
begin
  nBool := True;
  nSelected := True;

  with ShowBaseInfoEditForm(nBool, nSelected, '����', '', sFlag_AreaItem) do
  begin
    if nSelected then TcxButtonEdit(Sender).Text := FText;
  end;
end;

procedure TfFormTransContract.EditAIDPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  if EditAID.ItemIndex < 0 then Exit;
  nIdx := Integer(EditAID.Properties.Items.Objects[EditAID.ItemIndex]);

  EditDestAddr.Text := gAddrs[nIdx].FDelivery;
  EditRecvMan.Text  := gAddrs[nIdx].FRecvMan;
  EditCusPhone.Text := gAddrs[nIdx].FRecvPhone;
  EditDPrice.Text := Format('%.2f', [gAddrs[nIdx].FDrvPrice]);
  EditCPrice.Text := Format('%.2f', [gAddrs[nIdx].FCusPrice]);
  EditDistance.Text:=Format('%.2f', [gAddrs[nIdx].FDistance]);
end;

procedure TfFormTransContract.EditTruckPropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  inherited;
  EditTruck.Text := Trim(EditTruck.Text);
  if Length(EditTruck.Text)<=3 then Exit;
  if FRID <> '' then Exit;

  nStr := 'Select T_Owner, T_Phone From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, EditTruck.Text]);
  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    EditDriver.Text := FieldByName('T_Owner').AsString;
    EditDPhone.Text := FieldByName('T_Phone').AsString;
  end;  
end;

initialization
  gControlManager.RegCtrl(TfFormTransContract, TfFormTransContract.FormID);
end.
