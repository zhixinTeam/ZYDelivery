{*******************************************************************************
  作者: dmzn@163.com 2014-11-25
  描述: 车辆档案管理
*******************************************************************************}
unit UFormTruckTrans;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxGraphics, cxControls, cxLookAndFeels, DB,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxCheckBox, cxLabel, cxMemo,
  cxButtonEdit;

type
  TfFormTruckTrans = class(TfFormNormal)
    EditDriver: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditDrvPhone: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditZGSerial: TcxTextEdit;
    dxLayout1Item17: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item18: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    { Protected declarations }
    FTruckTransID: string;
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
  ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst;

class function TfFormTruckTrans.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormTruckTrans.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '运输车辆 - 添加';
      FTruckTransID := '';
    end;

    if nP.FCommand = cCmd_EditData then
    begin
      Caption := '运输车辆 - 修改';
      FTruckTransID := nP.FParamA;
    end;

    LoadFormData(FTruckTransID); 
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormTruckTrans.FormID: integer;
begin
  Result := cFI_FormTransTruck;
end;

procedure TfFormTruckTrans.LoadFormData(const nID: string);
var nStr: string;
    nDS : TDataSet;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, nID]);

    nDS  := FDM.QueryTemp(nStr);
    LoadDataToCtrl(nDS, Self, '');
  end;
end;

//Desc: 保存
procedure TfFormTruckTrans.BtnOKClick(Sender: TObject);
var nStr,nTruckTrans: string;
begin
  nTruckTrans := UpperCase(Trim(EditTruck.Text));
  if nTruckTrans = '' then
  begin
    ActiveControl := EditTruck;
    ShowMsg('请输入车牌号码', sHint);
    Exit;
  end;

  if FTruckTransID = '' then
  begin
    nStr := 'Select count(*) From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nTruckTrans]);
    with FDM.QuerySQL(nStr) do
    if (RecordCount<1) or (Fields[0].AsInteger<1) then
      nStr := MakeSQLByForm(Self, sTable_Truck, '', True, nil)
    else
    begin
      nStr := SF('T_Truck', nTruckTrans);
      nStr := MakeSQLByForm(Self, sTable_Truck, nStr, False, nil);
    end;
  end else
  begin
    nStr := SF('R_ID', FTruckTransID, sfVal);
    nStr := MakeSQLByForm(Self, sTable_Truck, nStr, False, nil);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set T_Used=''%s'' Where  T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, sFlag_Other, nTruckTrans]);
    FDM.ExecuteSQL(nStr);

		FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('车辆信息保存成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('车辆信息保存失败', sHint);
  end;
end;

procedure TfFormTruckTrans.FormCreate(Sender: TObject);
begin
  inherited;
  ResetHintAllForm(Self, 'T', sTable_Truck);
end;

procedure TfFormTruckTrans.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
    nStr: string;
begin
  inherited;

  nP.FParamA := Trim(EditTruck.Text);
  CreateBaseFormItem(cFI_FormGetTruck, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA<>mrOK) then Exit;

  nStr := 'Select * From %s Where T_Truck=%s';
  nStr := Format(nStr, [sTable_Truck, nP.FParamB]);

  LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');
end;

initialization
  gControlManager.RegCtrl(TfFormTruckTrans, TfFormTruckTrans.FormID);
end.
