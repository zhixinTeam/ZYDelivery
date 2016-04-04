{*******************************************************************************
  作者: dmzn@163.com 2009-7-15
  描述: 销售回款
*******************************************************************************}
unit UFrameTransPayment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus;

type
  TfFrameTransPayment = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FTransPaymentType: String;
    FStart,FEnd: TDate;
    //时间区间
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
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UFormDateFilter,
  UFormInputbox, UDataModule, USysBusiness;

//------------------------------------------------------------------------------
class function TfFrameTransPayment.FrameID: integer;
begin
  Result := cFI_FrameTransPayment;
end;

procedure TfFrameTransPayment.OnCreateFrame;
begin
  inherited;
  FTransPaymentType := 'MAIN_C12';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTransPayment.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameTransPayment.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select iom.*,sm.S_Name From $IOM iom ' +
            ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ' +
            'Where 1=1 ';
            
  if nWhere = '' then
       Result := Result + 'And (M_Date>=''$Start'' And M_Date <''$End'')'
  else Result := Result + 'And (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$IOM', sTable_TransInOutMoney), 
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 回款
procedure TfFrameTransPayment.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FParamA := '';
  CreateBaseFormItem(cFI_FormPayment, FTransPaymentType, @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: 特定客户回款
procedure TfFrameTransPayment.cxView1DblClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nP.FParamA := SQLQuery.FieldByName('M_CusID').AsString;
  CreateBaseFormItem(cFI_FormPayment, FTransPaymentType, @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: 纸卡(订单)回款
procedure TfFrameTransPayment.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormPaymentZK, FTransPaymentType, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: 日期筛选
procedure TfFrameTransPayment.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameTransPayment.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;
    
    FWhere := '(M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%'')';
    FWhere := Format(FWhere, [EditID.Text, EditID.Text]);
    InitFormData(FWhere);
  end else
end;

procedure TfFrameTransPayment.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N1.Visible := BtnAdd.Enabled;
  N2.Visible := BtnAdd.Enabled;
end;

procedure TfFrameTransPayment.N1Click(Sender: TObject);
var nMemo, nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr  := Trim(SQLQuery.FieldByName('M_Memo').AsString);
    nMemo := nStr;
    if not ShowInputBox('请输入新的备注信息:', '修改', nMemo) then Exit;

    if (nMemo = '') or (nStr = nMemo) then Exit;
    //无效或一致

    nStr := 'Update %s Set M_Memo=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_TransInOutMoney, nMemo,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);
    ShowMsg('修改备注成功!', sHint);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameTransPayment.N2Click(Sender: TObject);
var nPayment, nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr  := Trim(SQLQuery.FieldByName('M_Payment').AsString);
    nPayment := nStr;
    if not ShowInputBox('请输入新的付款方式:', '修改', nPayment) then Exit;

    if (nPayment = '') or (nStr = nPayment) then Exit;
    //无效或一致

    nStr := 'Update %s Set M_Payment=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_TransInOutMoney, nPayment,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);
    ShowMsg('修改付款方式成功!', sHint);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameTransPayment.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := '是否删除回款记录 [ %s ] 该记录详细信息如下: ' + #13#10 +
            '客户编号: [ %s ] 客户名称: [ %s] ' + #13#10 +
            '回款金额: [ %.2f ] 元';
    nStr := Format(nStr, [SQLQuery.FieldByName('R_ID').AsString,
            SQLQuery.FieldByName('M_CusID').AsString,
            SQLQuery.FieldByName('M_CusName').AsString,
            SQLQuery.FieldByName('M_Money').AsFloat]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := SQLQuery.FieldByName('R_ID').AsString;
    if not DeleteCustomerPayment(nStr, True) then
    begin
      ShowMsg('删除记录失败', sHint);
      Exit;
    end;

    ShowMsg('删除回款记录成功!', sHint);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTransPayment, TfFrameTransPayment.FrameID);
end.
