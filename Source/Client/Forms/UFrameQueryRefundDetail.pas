{*******************************************************************************
  作者: fendou116688@163.com 2016-04-2
  描述: 退购明细
*******************************************************************************}
unit UFrameQueryRefundDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameRefundDetailQuery = class(TfFrameNormal)
    cxtxtdt1: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxtxtdt2: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    pmPMenu1: TPopupMenu;
    mniN1: TMenuItem;
    cxtxtdt3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxtxtdt4: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditBill: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditSaleMan: TcxButtonEdit;
    dxLayout1Item10: TdxLayoutItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件 
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;

class function TfFrameRefundDetailQuery.FrameID: integer;
begin
  Result := cFI_FrameRefundDetailQuery;
end;

procedure TfFrameRefundDetailQuery.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameRefundDetailQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameRefundDetailQuery.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select r.*,(F_Value*F_Price) as F_Money,s.* ' +
            'From $Refund r Left Join $SaleMan s on r.F_SaleID=s.S_ID ';

  if FJBWhere = '' then
  begin
    Result := Result + 'Where (F_OutFact>=''$ST'' and F_OutFact <''$End'')';

    if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  Result := MacroValue(Result, [MI('$Refund', sTable_Refund),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
            MI('$SaleMan', sTable_Salesman)]);
  //xxxxx
end;

//Desc: 过滤字段
function TfFrameRefundDetailQuery.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'F_Price;F_Money';
end;

//Desc: 日期筛选
procedure TfFrameRefundDetailQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameRefundDetailQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'F_LID like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditSaleMan then
  begin
    EditSaleMan.Text := Trim(EditSaleMan.Text);
    if EditSaleMan.Text = '' then Exit;

    FWhere := 'F_SaleMan like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSaleMan.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'F_CusPY like ''%%%s%%'' Or F_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'F_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end;

  if Sender = EditBill then
  begin
    EditBill.Text := Trim(EditBill.Text);
    if EditBill.Text = '' then Exit;

    FWhere := 'F_ID like ''%%%s%%''';
    FWhere := Format(FWhere, [EditBill.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 交接班查询
procedure TfFrameRefundDetailQuery.mniN1Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(F_OutFact>=''%s'' and F_OutFact <''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

procedure TfFrameRefundDetailQuery.N3Click(Sender: TObject);
begin
  inherited;
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    if Sender = N3 then   //过重时间
       FJBWhere := '(F_MDate>=''%s'' and F_MDate <''%s'')'
    else
    if Sender = N4 then   //开单时间
      FJBWhere := '(F_Date>=''%s'' and F_Date <''%s'')';

    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRefundDetailQuery, TfFrameRefundDetailQuery.FrameID);
end.
