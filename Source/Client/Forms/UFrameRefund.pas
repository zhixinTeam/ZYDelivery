{*******************************************************************************
  作者: fendou116688@163.com 2016-03-29
  描述: 开退货单
*******************************************************************************}
unit UFrameRefund;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters,
  cxCheckBox;

type
  TfFrameRefund = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N6: TMenuItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N9: TMenuItem;
    dxLayout1Item10: TdxLayoutItem;
    CheckDelete: TcxCheckBox;
    EditTruck: TcxButtonEdit;
    dxLayout1Item11: TdxLayoutItem;
    N11: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure CheckDeleteClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //日期区间
    FTimeS,FTimeE: TDate;
    //时间段查询
    FUseDate: Boolean;
    //使用区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameRefund.FrameID: integer;
begin
  Result := cFI_FrameRefund;
end;

procedure TfFrameRefund.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameRefund.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameRefund.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Refund ';
  //销售退购单

  if (nWhere = '') or FUseDate then
  begin
    Result := Result + 'Where (F_Date>=''$ST'' and F_Date <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  if CheckDelete.Checked then
       Result := MacroValue(Result, [MI('$Refund', sTable_RefundBak)])
  else Result := MacroValue(Result, [MI('$Refund', sTable_Refund)]);
end;

procedure TfFrameRefund.AfterInitFormData;
begin
  FUseDate := True;
end;

function TfFrameRefund.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'F_Price';
end;

//Desc: 执行查询
procedure TfFrameRefund.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FUseDate := Length(EditLID.Text) <= 3;
    FWhere := 'F_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'F_CusPY like ''%%%s%%'' Or F_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('F_LID like ''%%%s%%''', [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('F_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 未开始销售退购的销售退购单
procedure TfFrameRefund.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('(F_Status=''%s'')', [sFlag_BillNew]);
   20: FWhere := 'F_OutFact Is Null'
   else Exit;
  end;

  FUseDate := False;
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameRefund.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 查询删除
procedure TfFrameRefund.CheckDeleteClick(Sender: TObject);
begin
  InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 开销售退购单
procedure TfFrameRefund.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormRefund, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameRefund.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := '确定要删除编号为[ %s ]的单据吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('F_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if DeleteBill(SQLQuery.FieldByName('F_ID').AsString) then
  begin
    InitFormData(FWhere);
    ShowMsg('销售退货单已删除', sHint);
  end;
end;

//Desc: 打印销售退购单
procedure TfFrameRefund.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('F_ID').AsString;
    PrintRefundReport(nStr, False);
  end;
end;

procedure TfFrameRefund.N11Click(Sender: TObject);
begin
  inherited;
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FUseDate := False;

    FWhere := '(F_Date>=''%s'' and F_Date <''%s'')';
    FWhere := Format(FWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    InitFormData(FWhere);
  finally
    FWhere := '';
  end;
end;

procedure TfFrameRefund.N3Click(Sender: TObject);
var nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('F_ID').AsString;
    if SetRefundCard(nStr, SQLQuery.FieldByName('F_Truck').AsString, False) then
    begin
      ShowMsg('办理磁卡成功', sHint);
      InitFormData(FWhere);
    end;  
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRefund, TfFrameRefund.FrameID);
end.
