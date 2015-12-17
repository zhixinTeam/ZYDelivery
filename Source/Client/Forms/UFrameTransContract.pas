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
  ComCtrls, ToolWin;

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
    EditSale: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N3: TMenuItem;
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
  private
    { Private declarations }
    FStart,FEnd: TDate;
    //时间区间
    FUseDate: Boolean;
    //使用区间
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
  USysConst, USysDB, UFormDateFilter;

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
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select *,T_CusMoney-T_DrvMoney As JieSheng From $Con ';
  //xxxxx
  
  if nWhere = '' then
       Result := Result + ' Where (IsNull(T_Enabled, '''')<>''$NO'')'
  else Result := Result + ' Where (' + nWhere + ')';

  if FUseDate then
    Result := Result + ' And ' + '(T_Date>=''$ST'' and T_Date <''$End'')';

  Result := MacroValue(Result, [MI('$Con', sTable_TransContract),
            MI('$NO', sFlag_NO),
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

  FDM.ADOConn.BeginTrans;
  try
    nCID := SQLQuery.FieldByName('T_CusID').AsString;
    nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-%s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_TransAccount,
            SQLQuery.FieldByName('CusMoney').AsString,nCID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set T_Enabled=''%s'' Where R_ID=%s';
    nStr := Format(nStr,[sTable_TransContract, sFlag_No,
            SQLQuery.FieldByName('R_ID').AsString]);
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

  if Sender = EditSale then
  begin
    EditSale.Text := Trim(EditSale.Text);
    if EditSale.Text = '' then Exit;

    FWhere := 'T_SalePY like ''%%%s%%'' Or T_SaleMan like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSale.Text, EditSale.Text]);
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

initialization
  gControlManager.RegCtrl(TfFrameTransContract, TfFrameTransContract.FrameID);
end.
