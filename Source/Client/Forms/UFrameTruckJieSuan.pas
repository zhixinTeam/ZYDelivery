{*******************************************************************************
作者: fendou116688@163.com 2016/1/24
描述: 司机运费结算管理
*******************************************************************************}
unit UFrameTruckJieSuan;

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
  TfFrameTruckJieSuan = class(TfFrameNormal)
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDrver: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
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
  USysConst, USysDB, UFormDateFilter, UAdjustForm, UFormCtrl;

//------------------------------------------------------------------------------
class function TfFrameTruckJieSuan.FrameID: integer;
begin
  Result := cFI_FrameTruckJieSuan;
end;

procedure TfFrameTruckJieSuan.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruckJieSuan.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameTruckJieSuan.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select T_StockName, T_Truck, T_Driver, T_CusName, T_Delivery,' +
            'T_DPrice,Sum(T_WeiValue) As T_Value,Sum(T_DrvMoney) As T_DMoney,' +
            'Count(*) As T_Count, T_DisValue, T_SetDate From $Con ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (IsNull(T_Enabled, '''')<>''$NO'')'
  else Result := Result + ' Where (' + nWhere + ')';
  //Conditional

  Result := Result + ' And ' + '(IsNull(T_Settle, '''') = ''$Yes'')' +
            ' And T_PayMent Like ''%回厂%''';
  //Has Settled

  if FUseDate then
    Result := Result + ' And ' + '(T_SetDate>=''$ST'' and T_SetDate <''$End'')';
  //SetDate

  Result := Result + ' Group By T_Truck, T_Driver, T_CusName, T_Delivery, ' +
            'T_DPrice, T_DisValue, T_SetDate, T_StockName Order By T_SetDate ';
  //Group By

  Result := MacroValue(Result, [MI('$Con', sTable_TransContract),
            MI('$Yes', sFlag_Yes), MI('$NO', sFlag_NO),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameTruckJieSuan.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditDrver then
  begin
    EditDrver.Text := Trim(EditDrver.Text);
    if EditDrver.Text = '' then Exit;

    FWhere := 'T_Driver like ''%%%s%%''';
    FWhere := Format(FWhere, [EditDrver.Text, EditDrver.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'T_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text, EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameTruckJieSuan.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;


procedure TfFrameTruckJieSuan.N1Click(Sender: TObject);
var nWhere: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nWhere := 'T_SetDate = ''%s'' And T_Driver=''%s'' And ' +
              'T_StockName Like ''%%袋装%%''';
    nWhere := Format(nWhere, [SQLQuery.FieldByName('T_SetDate').AsString,
              SQLQuery.FieldByName('T_Driver').AsString,
              SQLQuery.FieldByName('T_StockName').AsString]);

    PrintTruckJieSuan(nWhere);
  end;

  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckJieSuan, TfFrameTruckJieSuan.FrameID);
end.
