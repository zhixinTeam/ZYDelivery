unit UFrameQueryTransTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxListView, Grids, ExtCtrls,
  cxEdit, cxLabel, UBitmapPanel, cxSplitter, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ToolWin;

type
  TRecordInfo = record
    FStockName: string;
    FProName  : string;
    FFlagT    : string;
    FCount    : Integer;

    FKZValue  : Double;
    FValue    : Double;

    FPrice    : Double;
    FMoney    : Double;
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

  TfFrameQueryTransTotal = class(TBaseFrame)
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
    cxtxtdt1: TcxTextEdit;
    EditDate: TcxButtonEdit;
    EditCustomer: TcxButtonEdit;
    cxtxtdt4: TcxTextEdit;
    dxGroup1: TdxLayoutGroup;
    GroupSearch1: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    GroupDetail1: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
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
    procedure OnCtrlKeyPress(Sender: TObject; var Key: Char);
    procedure EditCustomerPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
  fFrameQueryTransTotal: TfFrameQueryTransTotal;

implementation

{$R *.dfm}

uses USysConst, ULibFun, UFormDateFilter, UMgrControl, USysDB,
     USysPopedom, UDataModule, USysBusiness;

class function TfFrameQueryTransTotal.FrameID: integer;
begin
  Result := cFI_FrameQueryTransTotal;
end;

procedure TfFrameQueryTransTotal.OnCreateFrame;
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

procedure TfFrameQueryTransTotal.OnDestroyFrame;
begin
  inherited;
end;

function TfFrameQueryTransTotal.FrameTitle: string;
begin
  Result := TitleBar.Caption;
end;   

procedure TfFrameQueryTransTotal.OnCtrlKeyPress(Sender: TObject; var Key: Char);
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

procedure TfFrameQueryTransTotal.LoadDataToReportGrid(nSQL: string);
var nRecord: TRecordInfo;
    nIdx, nJdx, nInt: Integer;
    nSumValue, nSumKValue, nSumMomey: Double;
begin
  ReportGrid.RowCount := 1;
  ReportGrid.ColCount := 8;   //总共8列
  with ReportGrid do
  begin
    ColWidths[0] := 80;
    ColWidths[1] := 120;
    Cells[0, RowCount-1] := '客户名称';
    Cells[1, RowCount-1] := '销售经理';
    Cells[2, RowCount-1] := '提货方式';
    Cells[3, RowCount-1] := '存货名称';
    Cells[4, RowCount-1] := '规格型号';
    Cells[5, RowCount-1] := '包装类型';
    Cells[6, RowCount-1] := '司机运价';
    Cells[7, RowCount-1] := '发货数量';
    Cells[8, RowCount-1] := '司机金额';
    Cells[9, RowCount-1] := '发货次数';

    Cells[10, RowCount-1] := '卸货地址';
    Cells[11, RowCount-1] := '客户运价';
    Cells[12, RowCount-1] := '客户金额';
    Cells[13, RowCount-1] := '节约运费';
    Cells[14, RowCount-1] := '车主';
    Cells[15, RowCount-1] := '车次';
    Cells[16, RowCount-1] := '送货方式';
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
        FStockName := FieldByName('O_StockName').AsString;
        FProName   := FieldByName('O_ProName').AsString;
        FFlagT     := '收货';

        FCount     := FieldByName('T_Count').AsInteger;

        FKZValue   := FieldByName('T_KZValue').AsFloat;
        FValue     := FieldByName('T_Value').AsFloat;

        FPrice     := 0;
        FMoney     := 0;
      end;

      nInt := -1;
      for nIdx := Low(FGroups) to High(FGroups) do
      if FGroups[nIdx].FGroupName = nRecord.FStockName then
      begin
        nInt := nIdx;
        Break;
      end;

      if nInt < 0 then
      begin
        nInt := Length(FGroups);
        SetLength(FGroups, nInt+1);
        SetLength(FGroups[nInt].FRecords, 0);
        FGroups[nInt].FGroupName := nRecord.FStockName;
      end;

      with FGroups[nInt] do
      begin
        nIdx := Length(FRecords);
        SetLength(FRecords, Length(FRecords)+1);
        FRecords[nIdx] := nRecord;

        FSumValue   := FSumValue + FRecords[nIdx].FValue;
        FSumKZValue := FSumKZValue + FRecords[nIdx].FKZValue;

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

      Cells[0, RowCount-1] := FStockName;
      Cells[1, RowCount-1] := FProName;
      Cells[2, RowCount-1] := Format('%.2f', [FValue]);
      Cells[3, RowCount-1] := IntToStr(FCount);
      Cells[4, RowCount-1] := FFlagT;
      Cells[5, RowCount-1] := Format('%.2f', [FKZValue]);
      Cells[6, RowCount-1] := Format('%.2f', [FPrice]);
      Cells[7, RowCount-1] := Format('%.2f', [FMoney]);
    end;

    {RowCount := RowCount + 1;
    Cells[0, RowCount-1] := '小计';
    Cells[1, RowCount-1] := '';
    Cells[2, RowCount-1] := Format('%.2f', [FSumValue]);
    Cells[3, RowCount-1] := IntToStr(FSumCount);
    Cells[4, RowCount-1] := '';
    Cells[5, RowCount-1] := Format('%.2f', [FSumKZValue]);
    Cells[6, RowCount-1] := Format('%.2f', [0.00]);
    Cells[7, RowCount-1] := Format('%.2f', [FSumMoney]);     }
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
    Cells[2, RowCount-1] := Format('%.2f', [nSumValue]);
    Cells[3, RowCount-1] := IntToStr(nInt);
    Cells[4, RowCount-1] := '';
    Cells[5, RowCount-1] := Format('%.2f', [nSumKValue]);
    Cells[6, RowCount-1] := Format('%.2f', [0.00]);
    Cells[7, RowCount-1] := Format('%.2f', [nSumMomey]);
  end;  
end;  

procedure TfFrameQueryTransTotal.QueryData(const nWhere: string);
var nSQL: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  nSQL := 'Select Sum(D_Value) As T_Value, Sum(D_KZValue) As T_KZValue, ' +
          'Count(O_Truck) As T_Count, O_ProName, O_StockName ' +
          'From $OD od Inner Join $OO oo on od.D_OID=oo.O_ID ';
  //xxxxxx
  {
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

  if FJBWhere = '' then
  begin
    nSQL := nSQL + 'Where (T_Date>=''$S'' and T_Date <''$End'')';

    if nWhere <> '' then
      nSQL := nSQL + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    nSQL := nSQL + ' Where (' + FJBWhere + ')';
  end;

  nSQL := nSQL + 'Group By T_CusName,T_SaleMan, Order By O_StockName ';

  nSQL := MacroValue(nSQL, [MI('$OD', sTable_OrderDtl),MI('$OO', sTable_Order),
            MI('$ZY', sFlag_CusZYF), MI('$S', Date2Str(FStart)),
            MI('$End', Date2Str(FEnd + 1))]);
  }
  LoadDataToReportGrid(nSQL);
end;

procedure TfFrameQueryTransTotal.BtnExitClick(Sender: TObject);
begin
  inherited;
  if not FIsBusy then Close;
end;

procedure TfFrameQueryTransTotal.BtnRefreshClick(Sender: TObject);
begin
  inherited;
  QueryData('');
end;

procedure TfFrameQueryTransTotal.ReportGridKeyDown(Sender: TObject;
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

procedure TfFrameQueryTransTotal.EditDatePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then QueryData(FWhere);
end;

procedure TfFrameQueryTransTotal.ReportGridDrawCell(Sender: TObject; ACol,
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

procedure TfFrameQueryTransTotal.BtnExportClick(Sender: TObject);
begin
  inherited;
  StringGridExportToExcel(ReportGrid, TitleBar.Caption);
end;

procedure TfFrameQueryTransTotal.EditCustomerPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'D_ProPY like ''%%%s%%'' Or D_ProName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    QueryData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryTransTotal, TfFrameQueryTransTotal.FrameID);
end.
