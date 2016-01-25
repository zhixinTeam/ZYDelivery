{*******************************************************************************
  作者: fendou116688@163.com 2016/1/17
  描述: 水泥厂水泥发货回单
*******************************************************************************}
unit UFrameQuerySealDetail;

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
  TfFrameQuerySealDetail = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditSeal: TcxButtonEdit;
    dxLayout1Item11: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //日期区间
    FTimeS,FTimeE: TDate;
    //时间段查询
    FUseDate: Boolean;
    //使用区间
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
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameQuerySealDetail.FrameID: integer;
begin
  Result := cFI_FrameQuerySealDetail;
end;

procedure TfFrameQuerySealDetail.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameQuerySealDetail.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameQuerySealDetail.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill b ' +
            ' Left Join $Sk s on b.L_Seal=s.R_SerialNo ' +
            ' Left Join $Ext e on e.E_ID=s.R_ExtID ';
  //提货单

  if (nWhere = '') or FUseDate then
  begin
    Result := Result + 'Where (L_OutFact>=''$ST'' and L_OutFact <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  Result := Result + nStr + '(L_CusType=''$CZY'')';

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$CZY', sFlag_CusZY),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
            MI('$SK', sTable_StockRecord),MI('$Ext', sTable_StockRecordExt)]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameQuerySealDetail.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditSeal then
  begin
    EditSeal.Text := Trim(EditSeal.Text);
    if EditSeal.Text = '' then Exit;

    FUseDate := Length(EditSeal.Text) <= 3;
    FWhere := 'L_Seal like ''%' + EditSeal.Text + '%''';
    FWhere := FWhere + 'And Year(R_Date)>=Year(''$ST'') and Year(R_Date) <Year(''$End'')+1 ';

    InitFormData(FWhere);
  end;
end;


//Desc: 日期筛选
procedure TfFrameQuerySealDetail.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 查询删除
procedure TfFrameQuerySealDetail.BtnAddClick(Sender: TObject);
var nSeal: string;
begin
  inherited;
  nSeal := SQLQuery.FieldByName('L_Seal').AsString;
  if nSeal = '' then Exit;
  PrintSealReport(nSeal, FStart, FEnd);
end;

initialization
  gControlManager.RegCtrl(TfFrameQuerySealDetail, TfFrameQuerySealDetail.FrameID);
end.
