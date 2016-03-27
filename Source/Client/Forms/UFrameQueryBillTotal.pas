unit UFrameQueryBillTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxListView, Grids, ExtCtrls,
  cxEdit, cxLabel, UBitmapPanel, cxSplitter, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ToolWin;

type
  TRecordInfo = record
    FICCard   : string;     //IC卡编号
    FCName    : string;     //客户名称
    FSName    : string;     //销售经理

    FStockName: string;     //存货名称
    FSeal     : string;     //规格型号
    FType     : string;     //包装类型

    FLading   : string;     //提货方式
    FFlagT    : string;     //发退货标记
    FCount    : Integer;    //发货车数
    FValue    : Double;     //发货数量
    FPrice    : Double;     //发货价格
    FMoney    : Double;     //发货金额
  end;
  TRecords = array of TRecordInfo;

  TGroupInfo = record
    FGroupName: string;
    FSumValue : Double;
    FSumCount : Integer;
    FSumKZValue: Double;
    FSumMoney : Double;

    FRecords  : TRecords;
  end;
  TGroups = array of TGroupInfo;

  TfFrameQueryBillTotal = class(TBaseFrame)
    TitlePanel1: TZnBitmapPanel;
    TitleBar: TcxLabel;
    ToolBar1: TToolBar;
    S1: TToolButton;
    BtnRefresh: TToolButton;
    S2: TToolButton;
    BtnPrint: TToolButton;
    BtnPreview: TToolButton;
    BtnExport: TToolButton;
    S3: TToolButton;
    BtnExit: TToolButton;
    dxLayout1: TdxLayoutControl;
    EditDate: TcxButtonEdit;
    EditCustomer: TcxButtonEdit;
    dxGroup1: TdxLayoutGroup;
    GroupSearch1: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    cxSplitter1: TcxSplitter;
    ZnBitmapPanel1: TZnBitmapPanel;
    ReportGrid: TStringGrid;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure ReportGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ReportGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BtnExportClick(Sender: TObject);
    procedure EditCustomerPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure OnCtrlKeyPress(Sender: TObject; var Key: Char);
    {*按键处理*}
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FWhere,FJBWhere: string;
    //查询条件
    FGroups: TGroups;
    function FrameTitle: string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure QueryData(const nWhere: string);
    procedure LoadDataToReportGrid(nSQL: string);
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFrameQueryBillTotal: TfFrameQueryBillTotal;

implementation

{$R *.dfm}

uses USysConst, ULibFun, UFormDateFilter, UMgrControl, USysDB,
     USysPopedom, UDataModule, USysBusiness;

class function TfFrameQueryBillTotal.FrameID: integer;
begin
  Result := cFI_FrameQueryBillTotal;
end;

procedure TfFrameQueryBillTotal.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FStart := FTimeS;
  FEnd   := FTimeE;

  FWhere := '';
  FJBWhere := '';
  QueryData(FWhere);
end;

procedure TfFrameQueryBillTotal.OnDestroyFrame;
begin
  inherited;
end;

function TfFrameQueryBillTotal.FrameTitle: string;
begin
  Result := TitleBar.Caption;
end;

procedure TfFrameQueryBillTotal.OnCtrlKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if Sender is TcxButtonEdit then
    with TcxButtonEdit(Sender) do
    begin
      Properties.OnButtonClick(Sender, 0);
      SelectAll;
    end else SwitchFocusCtrl(Self, True);
  end;
end;

procedure TfFrameQueryBillTotal.LoadDataToReportGrid(nSQL: string);
var nStr: string;
    nRecord: TRecordInfo;
    nIdx, nJdx, nInt: Integer;
    nSumValue, nSumKValue, nSumMomey: Double;
begin
  ReportGrid.RowCount := 1;
  ReportGrid.ColCount := 12;   //总共8列
  with ReportGrid do
  begin
    DefaultColWidth := 60;

    ColWidths[0] := 80;
    ColWidths[1] := 220;
    ColWidths[3] := 220;
    Cells[0, RowCount-1] := 'IC卡编号';
    Cells[1, RowCount-1] := '客户名称';
    Cells[2, RowCount-1] := '销售经理';
    Cells[3, RowCount-1] := '存货名称';
    Cells[4, RowCount-1] := '规格型号';
    Cells[5, RowCount-1] := '包装类型';
    Cells[6, RowCount-1] := '提货方式';
    Cells[7, RowCount-1] := '单价';
    Cells[8, RowCount-1] := '发货数量';
    Cells[9, RowCount-1] := '金额';
    Cells[10, RowCount-1] := '发货车数';
    Cells[11, RowCount-1] := '发退货标记';
  end;

  SetLength(FGroups, 0);
  with FDM.QuerySQL(nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      with nRecord do
      begin
        FICCard    := FieldByName('L_ICC').AsString;
        FCName     := FieldByName('L_CusName').AsString;
        FSName     := FieldByName('L_SaleMan').AsString;
              
        FStockName := FieldByName('P_Name').AsString;
        FSeal      := FieldByName('P_Qlevel').AsString;
        FType      := FieldByName('L_Type').AsString;

        FLading    := FieldByName('L_PayMent').AsString;
        FFlagT     := '发货';
        FCount     := FieldByName('T_Count').AsInteger;
        FValue     := FieldByName('T_Value').AsFloat;
        FPrice     := FieldByName('L_Price').AsFloat;
        FMoney     := FieldByName('T_Money').AsFloat;
      end;

      nInt := -1;
      for nIdx := Low(FGroups) to High(FGroups) do
      if FGroups[nIdx].FGroupName = nRecord.FICCard then
      begin
        nInt := nIdx;
        Break;
      end;

      if nInt < 0 then
      begin
        nInt := Length(FGroups);
        SetLength(FGroups, nInt+1);
        SetLength(FGroups[nInt].FRecords, 0);
        FGroups[nInt].FGroupName := nRecord.FICCard;
      end;

      with FGroups[nInt] do
      begin
        nIdx := Length(FRecords);
        SetLength(FRecords, Length(FRecords)+1);
        FRecords[nIdx] := nRecord;
        //Move(nRecord, FRecords[nIdx], 1);

        FSumValue   := FSumValue + FRecords[nIdx].FValue;
        FSumCount   := FSumCount + FRecords[nIdx].FCount;
        FSumMoney   := FSumMoney + FRecords[nIdx].FMoney;
      end;  
    finally
      Next;
    end;
  end;

  for nIdx:=Low(FGroups) to High(FGroups) do
  with FGroups[nIdx], ReportGrid do
  begin
    for nJdx:=Low(FRecords) to High(FRecords) do
    with FRecords[nJdx] do
    begin
      RowCount := RowCount + 1;

      if FType = sFlag_San then
            nStr := '散装'
      else  nStr := '袋装';

      Cells[0, RowCount-1] := FICCard;
      Cells[1, RowCount-1] := FCName;
      Cells[2, RowCount-1] := FSName;
      Cells[3, RowCount-1] := FStockName + '(' + nStr + ')';
      Cells[4, RowCount-1] := FSeal;
      Cells[5, RowCount-1] := nStr;
      Cells[6, RowCount-1] := FLading;
      Cells[7, RowCount-1] := Format('%.2f', [FPrice]);
      Cells[8, RowCount-1] := Format('%.2f', [FValue]);
      Cells[9, RowCount-1] := Format('%.2f', [FMoney]);
      Cells[10, RowCount-1] := IntToStr(FCount);
      Cells[11, RowCount-1] := FFlagT;
    end;
    {
    RowCount := RowCount + 1;
    Cells[0, RowCount-1] := '小计';
    Cells[1, RowCount-1] := '';
    Cells[2, RowCount-1] := '';
    Cells[3, RowCount-1] := '';
    Cells[4, RowCount-1] := '';
    Cells[5, RowCount-1] := '';
    Cells[6, RowCount-1] := '';
    Cells[7, RowCount-1] := '';
    Cells[8, RowCount-1] := Format('%.2f', [FSumValue]);
    Cells[9, RowCount-1] := Format('%.2f', [FSumMoney]);
    Cells[10, RowCount-1] := IntToStr(FSumCount);
    Cells[11, RowCount-1] := ''; }
  end;

  nInt      := 0;
  nSumValue := 0;
  nSumKValue:= 0;
  nSumMomey := 0;

  for nIdx:=Low(FGroups) to High(FGroups) do
  with FGroups[nIdx] do
  begin
    nInt      := nInt + FSumCount;
    nSumMomey := nSumMomey + FSumMoney;
    nSumValue := nSumValue + FSumValue;
    nSumKValue:= nSumKValue + FSumKZValue;
  end;

  with ReportGrid do
  begin
    RowCount := RowCount + 1;

    Cells[0, RowCount-1] := '合计';
    Cells[1, RowCount-1] := '';
    Cells[2, RowCount-1] := '';
    Cells[3, RowCount-1] := '';
    Cells[4, RowCount-1] := '';
    Cells[5, RowCount-1] := '';
    Cells[6, RowCount-1] := '';
    Cells[7, RowCount-1] := '';
    Cells[8, RowCount-1] := Format('%.2f', [nSumValue]);
    Cells[9, RowCount-1] := Format('%.2f', [nSumMomey]);
    Cells[10, RowCount-1] := IntToStr(nInt);
    Cells[11, RowCount-1] := '';
  end;  
end;  

procedure TfFrameQueryBillTotal.QueryData(const nWhere: string);
var nSQL: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  nSQL := 'Select L_ICC, L_CusName, L_SaleMan, P_Qlevel, L_Price, L_Type,L_PayMent,' +
	        'P_Name, Sum(L_Money) As T_Money, Sum(L_Value) As T_Value, ' +
          'Count(L_ID) As T_Count ' +
          'From (' +
          'Select L_ICC,L_CusName,L_SaleMan,L_Value,L_Price,L_Type,L_CusPY, ' +
          'L_OutFact,L_CusType,L_PayMent,(L_Value*L_Price) as L_Money,P_Name,P_Qlevel, ' +
          'L_ID From $Bill b Left Join $TP sp on b.L_StockNo=sp.P_ID' +
          ') bb ';
  //xxxxxx

  if FJBWhere = '' then
  begin
    nSQL := nSQL + ' Where (L_OutFact>=''$S'' and L_OutFact <''$End'')';

    if nWhere <> '' then
      nSQL := nSQL + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    nSQL := nSQL + ' Where (' + FJBWhere + ')';
  end;

  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       nSQL := nSQL + ''
  else nSQL := nSQL + ' And L_CusType=''$ZY''';

  nSQL := nSQL + ' Group By L_ICC,L_CusName,L_SaleMan,P_Qlevel,' +
          'L_PayMent,P_Name,L_Type,L_Price ';

  nSQL := MacroValue(nSQL, [MI('$Bill', sTable_Bill),MI('$TP', sTable_StockParam),
            MI('$ZY', sFlag_CusZYF), MI('$S', Date2Str(FStart)),
            MI('$End', Date2Str(FEnd + 1))]);

  LoadDataToReportGrid(nSQL);
end;

procedure TfFrameQueryBillTotal.BtnExitClick(Sender: TObject);
begin
  inherited;
  if not FIsBusy then Close;
end;

procedure TfFrameQueryBillTotal.BtnRefreshClick(Sender: TObject);
begin
  inherited;
  QueryData('');
end;

procedure TfFrameQueryBillTotal.ReportGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if ssCtrl in Shift then
  case Key of
    Ord('A'): SelectAllOfGrid(TStringGrid(Sender));
    Ord('C'): StringGridCopyToClipboard(TStringGrid(Sender));
    //Ord('V'): StringGridPasteFromClipboard(TStringGrid(Sender));
  end;
end;

procedure TfFrameQueryBillTotal.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then QueryData(FWhere);
end;

procedure TfFrameQueryBillTotal.ReportGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
   HCell: Integer;
   HRow: Integer;
   SCell: string;
begin
   SCell:= ReportGrid.Cells[ACol, ARow];
   HRow := ReportGrid.RowHeights[ARow];
   ReportGrid.Canvas.FillRect(Rect);
   HCell := DrawText(ReportGrid.Canvas.Handle, PChar(SCell), Length(SCell), Rect, DT_Center or DT_VCenter or DT_WORDBREAK );
   if HCell > HRow then
     ReportGrid.RowHeights[ARow] := HCell;
end;

procedure TfFrameQueryBillTotal.BtnExportClick(Sender: TObject);
begin
  inherited;
  StringGridExportToExcel(ReportGrid, TitleBar.Caption);
end;

procedure TfFrameQueryBillTotal.EditCustomerPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    QueryData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryBillTotal, TfFrameQueryBillTotal.FrameID);
end.
