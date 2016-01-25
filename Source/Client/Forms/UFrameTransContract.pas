{*******************************************************************************
作者: fendou116688@163.com 2015/11/26
描述: 销售运输合同管理
*******************************************************************************}
unit UFrameTransContract;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxDropDownEdit, cxCheckComboBox;

type
  TfFrameTransContract = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDrver: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N3: TMenuItem;
    EditSellte: TcxCheckComboBox;
    dxLayout1Item9: TdxLayoutItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditSettlePropertiesEditValueChanged(Sender: TObject);
    procedure EditSelltePropertiesClickCheck(Sender: TObject;
      ItemIndex: Integer; var AllowToggle: Boolean);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
    FStart,FEnd: TDate;
    //时间区间
    FUseDate: Boolean;
    //使用区间
    function SelectSettleFlag: string;
    function GetVal(const nRow: Integer; const nField: string): string;
    //获取指定字段
  protected
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl,UDataModule, UFrameBase, UFormBase, USysBusiness,
  USysConst, USysDB, UFormDateFilter, UAdjustForm, UFormCtrl;

//------------------------------------------------------------------------------
class function TfFrameTransContract.FrameID: integer;
begin
  Result := cFI_FrameTransContract;
end;

procedure TfFrameTransContract.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTransContract.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameTransContract.InitFormDataSQL(const nWhere: string): string;
var nSettle: String;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select *,T_CusMoney-T_DrvMoney As JieSheng From $Con ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (IsNull(T_Enabled, '''')<>''$NO'')'
  else Result := Result + ' Where (' + nWhere + ')';

  nSettle := SelectSettleFlag;
  Result := Result + ' And ' + '(IsNull(T_Settle, ''$No'') = ''$Sel'')';

  if FUseDate then
    Result := Result + ' And ' + '(T_Date>=''$ST'' and T_Date <''$End'')';

  Result := MacroValue(Result, [MI('$Con', sTable_TransContract),
            MI('$Yes', sFlag_Yes), MI('$NO', sFlag_NO), MI('$Sel', nSettle),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 关闭
procedure TfFrameTransContract.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormTransContract, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameTransContract.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormTransContract, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameTransContract.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  if SQLQuery.FieldByName('T_Enabled').AsString = sFlag_No then
  begin
    ShowMsg('协议已无效，无法修改', sHint); Exit;
  end;

  if SQLQuery.FieldByName('T_Settle').AsString = sFlag_No then
  begin
    ShowMsg('协议已运费已结算，无法修改', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('R_ID').AsString;
  CreateBaseFormItem(cFI_FormTransContract, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFrameTransContract.BtnDelClick(Sender: TObject);
var nStr, nCID: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的协议记录', sHint); Exit;
  end;

  if SQLQuery.FieldByName('T_Enabled').AsString = sFlag_No then
  begin
    ShowMsg('协议已无效，无法删除', sHint); Exit;
  end;

  if SQLQuery.FieldByName('T_Settle').AsString = sFlag_No then
  begin
    ShowMsg('协议已运费已结算，无法删除', sHint); Exit;
  end;

  nStr := '确定要删除编号为[ %s ]的单据吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('T_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('T_Payment').AsString;

    if Pos('回', nStr)>0 then
    begin
      nCID := SQLQuery.FieldByName('T_CusID').AsString;
      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-%s Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_TransAccount,
              SQLQuery.FieldByName('T_CusMoney').AsString,nCID]);
      FDM.ExecuteSQL(nStr);
    end;

    nStr := 'Update %s Set T_Enabled=''%s'' Where R_ID=%s';
    nStr := Format(nStr,[sTable_TransContract, sFlag_No,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);
    
    FDM.ADOConn.CommitTrans;        
    ShowMsg('已成功删除协议记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除协议记录失败', sHint);
  end;

  InitFormData(FWhere);
end;

//Desc: 查看内容
procedure TfFrameTransContract.cxView1DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    CreateBaseFormItem(cFI_FormTransContract, PopedomItem, @nParam);
  end;
end;

//Desc: 执行查询
procedure TfFrameTransContract.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'T_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditDrver then
  begin
    EditDrver.Text := Trim(EditDrver.Text);
    if EditDrver.Text = '' then Exit;

    FWhere := 'T_Driver like ''%%%s%%''';
    FWhere := Format(FWhere, [EditDrver.Text, EditDrver.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'T_CusPY like ''%%%s%%'' Or T_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 打印合同
procedure TfFrameTransContract.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('T_ID').AsString;
    PrintTransContractReport(nStr, False);
  end;
end;

//Desc: 冻结,解冻合同
procedure TfFrameTransContract.N5Click(Sender: TObject);
var nStr: string;
begin
  if Sender = N7 then
  begin
    InitFormData('1=1');
    Exit;
  end; //query all

  if Sender = N3 then
  begin
    nStr := Format('T_Enabled=''%s''', [sFlag_No]);
  end;

  if Sender = N5 then
  begin
    nStr := Format('T_Enabled=''%s''', [sFlag_Yes]);
  end;

  InitFormData(nStr);
end;

procedure TfFrameTransContract.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFrameTransContract.EditSettlePropertiesEditValueChanged(
  Sender: TObject);
begin
  inherited;
  InitFormData(FWhere);
end;

procedure TfFrameTransContract.EditSelltePropertiesClickCheck(
  Sender: TObject; ItemIndex: Integer; var AllowToggle: Boolean);
var nIdx: Integer;
    nOStatus: TcxCheckBoxState;
begin
  inherited;
  nOStatus := EditSellte.States[ItemIndex];

  for nIdx := 0 to EditSellte.Properties.Items.Count - 1 do
  if nIdx <> ItemIndex then EditSellte.States[nIdx] := nOStatus;

  InitFormData(FWhere);
end;

function TfFrameTransContract.SelectSettleFlag: string;
begin
  if EditSellte.ItemIndex = 0 then
       Result := sFlag_Yes
  else Result := sFlag_No;
end;

function TfFrameTransContract.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

procedure TfFrameTransContract.N6Click(Sender: TObject);
var nList: TStrings;
    nIdx,nLen: Integer;
    nSetDate: TDateTime;
    nSQL, nPID, nSettle: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
    Exit;
  //xxxxx

  nSetDate := FDM.ServerNow;
  nList := TStringList.Create;
  try
    nLen := cxView1.DataController.GetSelectedCount - 1;

    for nIdx:=0 to nLen do
    begin
      nPID := GetVal(nIdx, 'T_ID');
      nSettle := GetVal(nIdx, 'T_Settle');
      if (nPID = '') or (nSettle = sFlag_Yes) then Continue;

      nSQL := MakeSQLByStr([SF('T_Settle', sFlag_Yes),
              SF('T_SetDate', DateTime2Str(nSetDate)),
              SF('T_SetMan', gSysParam.FUserID)
              ], sTable_TransContract, SF('T_ID', nPID), False);
      nList.Add(nSQL);
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('选中记录无效', sHint); Exit;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx := 0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);

      FDM.ADOConn.CommitTrans;
      ShowMsg('结算成功', sHint);
      InitFormData(FWhere);
    except
      ShowMsg('未知错误导致结算失败', sHint);
      FDM.ADOConn.RollbackTrans;
      Exit;
    end;
  finally
    nList.Free;
  end;
end;

procedure TfFrameTransContract.N8Click(Sender: TObject);
var nList: TStrings;
    nIdx,nLen: Integer;
    nSQL, nPID, nSettle: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
    Exit;
  //xxxxx

  nList := TStringList.Create;
  try
    nLen := cxView1.DataController.GetSelectedCount - 1;

    for nIdx:=0 to nLen do
    begin
      nPID := GetVal(nIdx, 'T_ID');
      nSettle := GetVal(nIdx, 'T_Settle');
      if (nPID = '') or (nSettle <> sFlag_Yes) then Continue;

      nSQL := 'Update %s Set T_Settle=Null, T_SetMan=Null, T_SetDate=Null ' +
              'Where T_ID=''%s''';
      nSQL := Format(nSQL, [sTable_TransContract, nPID]);
      nList.Add(nSQL);
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('选中记录无效', sHint); Exit;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx := 0 to nList.Count - 1 do
        FDM.ExecuteSQL(nList[nIdx]);

      FDM.ADOConn.CommitTrans;
      ShowMsg('反结算成功', sHint);
      InitFormData(FWhere);
    except
      ShowMsg('未知错误导致反结算失败', sHint);
      FDM.ADOConn.RollbackTrans;
      Exit;
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTransContract, TfFrameTransContract.FrameID);
end.
