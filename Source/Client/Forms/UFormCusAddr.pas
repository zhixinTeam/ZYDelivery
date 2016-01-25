{*******************************************************************************
  作者: fendou116688@163.com 2015/12/12
  描述: 客户送货地址管理
*******************************************************************************}
unit UFormCusAddr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxDropDownEdit, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxMaskEdit, cxCalendar,
  dxLayoutControl, StdCtrls;

type
  TfFormCusAddr = class(TfFormNormal)
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item8: TdxLayoutItem;
    EditDelivery: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditCusPrice: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    EditDrvPrice: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditCusName: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    EditRecvMan: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditCusID: TcxButtonEdit;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditDistance: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditCusNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FRecordID: string;
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    procedure InitFormData(const nID: string);
    //载入数据
    procedure GetData(Sender: TObject; var nData: string);
    //获取数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
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
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, UFormBase, UMgrControl, USysGrid,
  USysDB, USysConst, USysBusiness, UDataModule;

var
  gForm: TfFormCusAddr = nil;
  //全局使用

class function TfFormCusAddr.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormCusAddr.Create(Application) do
    begin
      FRecordID := '';
      Caption := '送货地址 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormCusAddr.Create(Application) do
    begin
      Caption := '送货地址 - 修改';
      FRecordID := nP.FParamA;

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
        gForm := TfFormCusAddr.Create(Application);
      //xxxxx

      with gForm  do
      begin
        Caption := '送货地址 - 查看';
        FormStyle := fsStayOnTop;
        BtnOK.Visible := False;

        FRecordID := nP.FParamA;
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

class function TfFormCusAddr.FormID: integer;
begin
  Result := cFI_FormCusAddr;
end;

procedure TfFormCusAddr.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'SH');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  ResetHintAllForm(Self, 'T', sTable_CusAddr);
  //重置表名称
end;

procedure TfFormCusAddr.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
end;

//------------------------------------------------------------------------------
procedure TfFormCusAddr.GetData(Sender: TObject; var nData: string);
var nValue: Double;
begin
  if Sender = EditDrvPrice then
  begin
    nValue:= StrToFloatDef(EditDrvPrice.Text, 0);
    nData := FloatToStr(nValue);
  end else

  if Sender = EditCusPrice then
  begin
    nValue:= StrToFloatDef(EditCusPrice.Text, 0);
    nData := FloatToStr(nValue);
  end else

  if Sender = EditDistance then
  begin
    nValue:= StrToFloatDef(EditDistance.Text, 0);
    nData := FloatToStr(nValue);
  end;
end;

function TfFormCusAddr.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
end;

procedure TfFormCusAddr.InitFormData(const nID: string);
var nStr: string;
begin
  if nID = '' then
  begin
    EditIDPropertiesButtonClick(nil, 0);
  end else
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_CusAddr, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
  end;
end;


//Desc: 验证数据
function TfFormCusAddr.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = EditID then
  begin
    Result := Trim(EditID.Text) <> '';
    nHint := '请填写有效的地址编码';
    if not Result then Exit;

    nStr := 'Select Count(*) From %s Where A_ID=''%s''';
    nStr := Format(nStr, [sTable_CusAddr, EditID.Text]);

    if FRecordID <> '' then
      nStr := nStr + ' And R_ID<>' + FRecordID;
    //xxxxx

    Result := FDM.QueryTemp(nStr).Fields[0].AsInteger < 1;
    nHint := '该编号已经存在';
  end;
end;

//Desc: 保存
procedure TfFormCusAddr.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := MakeSQLByForm(Self, sTable_CusAddr, '', True, GetData);
  end else
  begin
    nStr := 'R_ID=' + FRecordID;
    nStr := MakeSQLByForm(Self, sTable_CusAddr, nStr, False, GetData);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    if FRecordID = '' then
         nStr := IntToStr(FDM.GetFieldMax(sTable_CusAddr, 'R_ID'))
    else nStr := FRecordID;

    FDM.ADOConn.CommitTrans;

    ModalResult := mrOK;
    ShowMsg('送货地址已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('送货地址保存失败', sError);
  end;
end;

procedure TfFormCusAddr.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nID: integer;
begin
  nID := FDM.GetFieldMax(sTable_CusAddr, 'R_ID') + 1;
  EditID.Text := FDM.GetSerialID2(FPrefixID, sTable_CusAddr, 'R_ID', 'A_ID', nID);
end;

procedure TfFormCusAddr.EditCusNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  inherited;

  nP.FParamA := Trim(TcxButtonEdit(Sender).Text);
  CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  EditCusID.Text   := nP.FParamB;
  EditCusName.Text := nP.FParamC; 
end;

initialization
  gControlManager.RegCtrl(TfFormCusAddr, TfFormCusAddr.FormID);
end.
