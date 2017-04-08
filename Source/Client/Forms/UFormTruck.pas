{*******************************************************************************
  ����: dmzn@163.com 2014-11-25
  ����: ������������
*******************************************************************************}
unit UFormTruck;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, DB,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox, cxLabel, cxMemo;

type
  TfFormTruck = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditOwner: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    CheckValid: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    CheckVerify: TcxCheckBox;
    dxLayout1Item7: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item6: TdxLayoutItem;
    CheckUserP: TcxCheckBox;
    CheckVip: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    CheckGPS: TcxCheckBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    EditHZValue: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    EditNum: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditYSSerial: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    EditZGSerial: TcxTextEdit;
    dxLayout1Item17: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item18: TdxLayoutItem;
    EditPValue: TcxTextEdit;
    dxLayout1Item19: TdxLayoutItem;
    EditCGValue: TcxTextEdit;
    dxLayout1Item20: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item21: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group9: TdxLayoutGroup;
    cxLabel3: TcxLabel;
    dxLayout1Item22: TdxLayoutItem;
    dxLayout1Group10: TdxLayoutGroup;
    EditDrver: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditDrvPhone: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item23: TdxLayoutItem;
    EditAddr: TcxTextEdit;
    dxLayout1Item24: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    { Protected declarations }
    FTruckID: string;
    procedure LoadFormData(const nID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst, UAdjustForm;

class function TfFormTruck.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormTruck.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '���� - ���';
      FTruckID := '';
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '���� - �޸�';
      FTruckID := nP.FParamA;
    end;

    LoadFormData(FTruckID); 
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally   
    AdjustStringsItem(EditType.Properties.Items, True);
    Free;
  end;
end;

class function TfFormTruck.FormID: integer;
begin
  Result := cFI_FormTrucks;
end;

procedure TfFormTruck.LoadFormData(const nID: string);
var nStr: string;
    nDS : TDataSet;
    nEx: TDynamicStrArray;
begin
  SetLength(nEx, 1);
  nStr := 'D_Value=Select D_Value, D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckType]);

  nEx[0] := 'D_Value';
  FDM.FillStringsData(EditType.Properties.Items, nStr, 0, '', nEx);
  AdjustCXComboBoxItem(EditType, False);

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, nID]);

    nDS  := FDM.QueryTemp(nStr);
    LoadDataToCtrl(nDS, Self, ''); 

    CheckVerify.Checked := nDS.FieldByName('T_NoVerify').AsString = sFlag_No;
    CheckValid.Checked := nDS.FieldByName('T_Valid').AsString = sFlag_Yes;
    CheckUserP.Checked := nDS.FieldByName('T_PrePUse').AsString = sFlag_Yes;

    CheckVip.Checked   := nDS.FieldByName('T_VIPTruck').AsString = sFlag_TypeVIP;
    CheckGPS.Checked   := nDS.FieldByName('T_HasGPS').AsString = sFlag_Yes;
  end else

  begin
    CheckVerify.Checked := True;
    CheckValid.Checked := True;
  end;
end;

//Desc: ����
procedure TfFormTruck.BtnOKClick(Sender: TObject);
var nStr,nTruck,nEvent: string;
    nList: TStrings;
begin
  nTruck := UpperCase(Trim(EditTruck.Text));
  if nTruck = '' then
  begin
    ActiveControl := EditTruck;
    ShowMsg('�����복�ƺ���', sHint);
    Exit;
  end;

  if FTruckID = '' then
  begin
    nStr := 'Select count(*) From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nTruck]);
    with FDM.QuerySQL(nStr) do
    if (RecordCount>0) and (Fields[0].AsInteger>0) then
    begin
      nStr := '���ƺ� [ %s ] �����Ѿ�����';
      nStr := Format(nStr, [nTruck]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nStr := 'Select T_Truck From %s Where T_ZGSerial=''%s'' And T_Truck <> ''%s''';
    nStr := Format(nStr, [sTable_Truck, Trim(EditZGSerial.Text), nTruck]);
    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '���ƺ� [ %s ] ����ʹ�ô�ҵ�ʸ�֤���[ %s ]';
      nStr := Format(nStr, [Fields[0].AsString, Trim(EditZGSerial.Text)]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nStr := 'Select T_Truck From %s Where T_YSSerial=''%s'' And T_Truck <> ''%s''';
    nStr := Format(nStr, [sTable_Truck, Trim(EditYSSerial.Text), nTruck]);
    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      nStr := '���ƺ� [ %s ] ����ʹ�������ʸ�֤���[ %s ]';
      nStr := Format(nStr, [Fields[0].AsString, Trim(EditYSSerial.Text)]);
      ShowMsg(nStr, sHint);
      Exit;
    end;
  end;

  nList := TStringList.Create;
  try
    if CheckValid.Checked then
         nStr := SF('T_Valid', sFlag_Yes)
    else nStr := SF('T_Valid', sFlag_No);
    nList.Add(nStr);

    if CheckVerify.Checked then
         nStr := SF('T_NoVerify', sFlag_No)
    else nStr := SF('T_NoVerify', sFlag_Yes);
    nList.Add(nStr);

    if CheckUserP.Checked then
         nStr := SF('T_PrePUse', sFlag_Yes)
    else nStr := SF('T_PrePUse', sFlag_No);
    nList.Add(nStr);

    if CheckVip.Checked then
         nStr := SF('T_VIPTruck', sFlag_TypeVIP)
    else nStr := SF('T_VIPTruck', sFlag_TypeCommon);
    nList.Add(nStr);

    if CheckGPS.Checked then
         nStr := SF('T_HasGPS', sFlag_Yes)
    else nStr := SF('T_HasGPS', sFlag_No);
    nList.Add(nStr);

    if FTruckID = '' then
    begin
      nStr := MakeSQLByForm(Self, sTable_Truck, '', True, nil, nList);
    end else
    begin
      nStr := SF('R_ID', FTruckID, sfVal);
      nStr := MakeSQLByForm(Self, sTable_Truck, nStr, False, nil, nList);
    end;
  finally
    nList.Free;
  end;

  FDM.ExecuteSQL(nStr); 
  if FTruckID='' then
        nEvent := '���[ %s ]������Ϣ.'
  else  nEvent := '�޸�[ %s ]������Ϣ.';
  nEvent := Format(nEvent, [nTruck]);
  FDM.WriteSysLog(sFlag_CommonItem, nTruck, nEvent);

  ModalResult := mrOk;
  ShowMsg('������Ϣ����ɹ�', sHint);
end;

procedure TfFormTruck.FormCreate(Sender: TObject);
begin
  inherited;
  ResetHintAllForm(Self, 'T', sTable_Truck);
end;

initialization
  gControlManager.RegCtrl(TfFormTruck, TfFormTruck.FormID);
end.
