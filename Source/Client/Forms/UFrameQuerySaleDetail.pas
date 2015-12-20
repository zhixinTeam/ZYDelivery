{*******************************************************************************
  作者: dmzn@163.com 2012-03-26
  描述: 发货明细
*******************************************************************************}
unit UFrameQuerySaleDetail;

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
  TfFrameSaleDetailQuery = class(TfFrameNormal)
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
    N1: TMenuItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditSaleMan: TcxButtonEdit;
    dxLayout1Item10: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
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
    function GetVal(const nRow: Integer; const nField: string): string;
    //获取指定字段
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UFormInputbox;

class function TfFrameSaleDetailQuery.FrameID: integer;
begin
  Result := cFI_FrameSaleDetailQuery;
end;

procedure TfFrameSaleDetailQuery.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameSaleDetailQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameSaleDetailQuery.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := 'Select *,(L_Value*L_Price) as L_Money From $Bill b ';

  if FJBWhere = '' then
  begin
    Result := Result + 'Where (L_OutFact>=''$S'' and L_OutFact <''$End'')';

    if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       Result := Result + ''
  else Result := Result + ' And L_CusType=''$ZY''';

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill), MI('$ZY', sFlag_CusZY),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 过滤字段
function TfFrameSaleDetailQuery.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price;L_Money';
end;

//Desc: 日期筛选
procedure TfFrameSaleDetailQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameSaleDetailQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'L_ICC like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditSaleMan then
  begin
    EditSaleMan.Text := Trim(EditSaleMan.Text);
    if EditSaleMan.Text = '' then Exit;

    FWhere := 'L_SaleMan like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSaleMan.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'b.L_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end;

  if Sender = EditBill then
  begin
    EditBill.Text := Trim(EditBill.Text);
    if EditBill.Text = '' then Exit;

    FWhere := 'b.L_ID like ''%%%s%%''';
    FWhere := Format(FWhere, [EditBill.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 交接班查询
procedure TfFrameSaleDetailQuery.mniN1Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(L_OutFact>=''%s'' and L_OutFact <''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_BillPick, sFlag_BillPost]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//Desc: 获取nRow行nField字段的内容
function TfFrameSaleDetailQuery.GetVal(const nRow: Integer;
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

procedure TfFrameSaleDetailQuery.N1Click(Sender: TObject);
var nStr,nLID,nType, nStock, nZKType,nNewPrice, nCID: string;
    nPPrice, nNPrice, nValue, nPMon, nNMon: Double;
    nList, nListSQL, nListEvent: TStrings;
    nIdx, nLen: Integer;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;

  nNewPrice := SQLQuery.FieldByName('L_Price').AsString;
  if not ShowInputBox('新价格', '提货单价格调整', nNewPrice) then Exit;

  if (nNewPrice='') or (nNewPrice=SQLQuery.FieldByName('L_Price').AsString) then
    Exit;
  //无新价格

  nNPrice := StrToFloat(nNewPrice);

  nList := TStringList.Create;
  nListSQL := TStringList.Create;
  nListEvent := TStringList.Create;
  try
    nType := GetVal(0, 'L_Type');
    nStock := GetVal(0, 'L_StockNO');
    nLen := cxView1.DataController.GetSelectedCount - 1;

    nListSQL.Clear;
    nListEvent.Clear;
    for nIdx:=0 to nLen do
    begin
      nLID := GetVal(nIdx, 'L_ID');
      if nLID = '' then Continue;

      nStr := GetVal(nIdx, 'L_OutFact');
      if nStr = '' then
      begin
        nStr := '调价需要已出厂提货单,提单编号[ %s ]不符合要求.';
        nStr := Format(nStr, [nLID]);
        ShowDlg(nStr, sHint, Handle); Exit;
      end;

      if (GetVal(nIdx, 'L_Type') <> nType) or
         (GetVal(nIdx, 'L_StockNO') <> nStock) then
      begin
        nStr := '只有同品种的水泥才能统一调价,提单编号[ %s ]不符合要求.';
        nStr := Format(nStr, [nLID]);
        ShowDlg(nStr, sHint, Handle); Exit;
      end;

      nPPrice := StrToFloat(GetVal(nIdx, 'L_Price'));
      nValue  := StrToFloat(GetVal(nIdx, 'L_Value'));

      nPMon   := nPPrice * nValue;
      nPMon   := Float2Float(nPMon, cPrecision, False);

      nNMon   := nNPrice * nValue;
      nNMon   := Float2Float(nNMon, cPrecision, True);

      nZKType := GetVal(nIdx, 'L_ZKType');
      if nZKType = sFlag_BillSZ then
      begin
        nCID := GetVal(nIdx, 'L_CusID');
        nStr := 'Update %s Set A_OutMoney=A_OutMoney-%s Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nPMon), nCID]);
        nListSQL.Add(nStr);

        nStr := 'Update %s Set L_Price=%s, L_PPrice=%s Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FloatToStr(nNPrice),
                FloatToStr(nPPrice), nLID]);
        nListSQL.Add(nStr);

        nStr := 'Update %s Set A_OutMoney=A_OutMoney+%s Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nNMon), nCID]);
        nListSQL.Add(nStr);
      end else

      if nZKType = sFlag_BillFX then
      begin
        nCID := GetVal(nIdx, 'L_ZhiKa');
        nStr := 'Update %s Set I_OutMoney=I_OutMoney-%s Where I_ZID=''%s''';
        nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nPMon), nCID]);
        nListSQL.Add(nStr);

        nStr := 'Update %s Set L_Price=%s, L_PPrice=%s Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FloatToStr(nNPrice),
                FloatToStr(nPPrice), nLID]);
        nListSQL.Add(nStr);

        nStr := 'Update %s Set I_OutMoney=I_OutMoney+%s Where I_ZID=''%s''';
        nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nNMon), nCID]);
        nListSQL.Add(nStr);
      end else

      if nZKType = sFlag_BillFL then
      begin

      end;

      nStr := '提货单[ %s ]单价调整[ %.2f -> %.2f ]';
      nStr := Format(nStr, [nLID, nPPrice, nNPrice]);
      nListEvent.Add(nStr);
    end;

    if nListSQL.Count < 1 then
    begin
      ShowMsg('选中记录无效', sHint); Exit;
    end;

    FDM.ADOConn.BeginTrans;
    try
      for nIdx:=0 to nListSQL.Count-1 do
        FDM.ExecuteSQL(nListSQL[nIdx]);

      for nIdx:=0 to nListEvent.Count-1 do
        FDM.WriteSysLog(sFlag_ZhiKaItem, '已发货单调价', nListEvent[nIdx], False);

      FDM.ADOConn.CommitTrans;
      ShowMsg('调整价格成功!', sHint);
    except
      FDM.ADOConn.RollbackTrans;
      ShowMsg('调整价格无效!', sHint);
    end;
  finally
    nList.Free;
    nListSQL.Free;
    nListEvent.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSaleDetailQuery, TfFrameSaleDetailQuery.FrameID);
end.
