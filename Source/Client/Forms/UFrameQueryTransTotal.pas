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
    FCusName  : string;
    FSaleMan  : string;
    FPayMent  : string;

    FDelivery : string;
    FStockName: string;
    FStockType: string;
    FQevel    : string;

    FDriver   : string;
    FSendType : string;

    FCount    : Integer;
    FValue    : Double;
    FJYMoney  : Double;

    FDrvPrice : Double;
    FDrvMoney : Double;

    FCusPrice : Double;
    FCusMoney : Double;
  end;
  TRecords = array of TRecordInfo;

  TGroupInfo = record
    FGroupName: string;
    FSumValue : Double;
    FSumCount : Integer;

    FSumCusMoney: Double;
    FSumDrvMoney: Double;
    FSumJYMoney : Double;
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
    cxSplitter1: TcxSplitter;
    ZnBitmapPanel1: TZnBitmapPanel;
    ReportGrid: TStringGrid;
    dxLayout1: TdxLayoutControl;
    EditDate: TcxButtonEdit;
    EditCustomer: TcxButtonEdit;
    dxGroup1: TdxLayoutGroup;
    GroupSearch1: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    EditSales: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
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
  FStart := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FEnd   := Str2DateTime(Date2Str(Now) + ' 00:00:00');

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
    nSumValue, nSumDrvMoney, nSumCusMoney, nSumJYMoney: Double;
begin
  ReportGrid.RowCount := 1;
  ReportGrid.ColCount := 14;   //总共16列
  with ReportGrid do
  begin
    ColWidths[0] := 180;
    ColWidths[1] := 80;
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
    //Cells[14, RowCount-1] := '车主';
    //Cells[15, RowCount-1] := '送货方式';
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
        FCusName  := FieldByName('T_CusName').AsString;
        FSaleMan  := FieldByName('T_SaleMan').AsString;
        FPayMent  := FieldByName('T_PayMent').AsString;
           
        FDelivery := FieldByName('T_Delivery').AsString;
        FStockName:= FieldByName('T_StockName').AsString;

        if FieldByName('L_Type').AsString=sFlag_Dai then
             FStockType:= '袋装'
        else FStockType:= '散装';
        FQevel    := FieldByName('P_Qlevel').AsString;
           
        FDriver   := '';//FieldByName('T_Driver').AsString;
        FSendType := '';
           
        FCount    := FieldByName('T_Count').AsInteger;
        FValue    := FieldByName('T_Value').AsFloat;
        FJYMoney  := FieldByName('JieSheng').AsFloat;

        FDrvPrice := FieldByName('T_DPrice').AsFloat;
        FDrvMoney := FieldByName('T_DrvMoneyT').AsFloat;
           
        FCusPrice := FieldByName('T_CPrice').AsFloat;
        FCusMoney := FieldByName('T_CusMoneyT').AsFloat;
      end;

      nInt := -1;
      for nIdx := Low(FGroups) to High(FGroups) do
      if FGroups[nIdx].FGroupName = nRecord.FSaleMan then
      begin
        nInt := nIdx;
        Break;
      end;

      if nInt < 0 then
      begin
        nInt := Length(FGroups);
        SetLength(FGroups, nInt+1);
        SetLength(FGroups[nInt].FRecords, 0);
        FGroups[nInt].FGroupName := nRecord.FSaleMan;
      end;

      with FGroups[nInt] do
      begin
        nIdx := Length(FRecords);
        SetLength(FRecords, Length(FRecords)+1);
        FRecords[nIdx] := nRecord;

        FSumValue   := FSumValue + FRecords[nIdx].FValue;
        FSumCount   := FSumCount + FRecords[nIdx].FCount;

        FSumCusMoney   := FSumCusMoney + FRecords[nIdx].FCusMoney;
        FSumDrvMoney   := FSumDrvMoney + FRecords[nIdx].FDrvMoney;
        FSumJYMoney    := FSumJYMoney + FRecords[nIdx].FJYMoney;
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

      Cells[0, RowCount-1] := FCusName;
      Cells[1, RowCount-1] := FSaleMan;
      Cells[2, RowCount-1] := FPayMent;
      Cells[3, RowCount-1] := FStockName;
      Cells[4, RowCount-1] := FQevel;
      Cells[5, RowCount-1] := FStockType;
      Cells[6, RowCount-1] := Format('%.2f', [FDrvPrice]);
      Cells[7, RowCount-1] := Format('%.2f', [FValue]);
      Cells[8, RowCount-1] := Format('%.2f', [FDrvMoney]);
      Cells[9, RowCount-1] := Format('%d',   [FCount]);

      Cells[10, RowCount-1] := FDelivery;
      Cells[11, RowCount-1] := Format('%.2f', [FCusPrice]);
      Cells[12, RowCount-1] := Format('%.2f', [FCusMoney]);
      Cells[13, RowCount-1] := Format('%.2f', [FJYMoney]);
      //Cells[14, RowCount-1] := FDriver;
      //Cells[15, RowCount-1] := FSendType;
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
  nSumDrvMoney := 0;
  nSumCusMoney := 0;
  nSumJYMoney  := 0;

  for nIdx:=Low(FGroups) to High(FGroups) do
  with FGroups[nIdx] do
  begin
    nInt      := nInt + FSumCount;
    nSumValue := nSumValue + FSumValue;

    nSumDrvMoney := nSumDrvMoney + FSumDrvMoney;
    nSumCusMoney := nSumCusMoney + FSumCusMoney;
    nSumJYMoney  := nSumJYMoney  + FSumJYMoney;
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
    Cells[7, RowCount-1] := Format('%.2f', [nSumValue]);
    Cells[8, RowCount-1] := Format('%.2f', [nSumDrvMoney]);
    Cells[9, RowCount-1] := Format('%d',   [nInt]);

    Cells[10, RowCount-1] := '';
    Cells[11, RowCount-1] := '';
    Cells[12, RowCount-1] := Format('%.2f', [nSumCusMoney]);
    Cells[13, RowCount-1] := Format('%.2f', [nSumJYMoney]);
    Cells[14, RowCount-1] := '';
    Cells[15, RowCount-1] := '';
  end;  
end;  

procedure TfFrameQueryTransTotal.QueryData(const nWhere: string);
var nSQL: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nSQL := 'Select T_CusName,T_SaleMan,T_PayMent,T_StockName,' +
          'P_Qlevel,L_Type,T_DPrice,T_CPrice, T_Delivery, ' +
          'Sum(T_CusMoney-T_DrvMoney) As JieSheng, ' +
          'Sum(T_DrvMoney) As T_DrvMoneyT, ' +
          'Sum(T_CusMoney) As T_CusMoneyT, ' +
          'Sum(T_WeiValue-T_TrueValue) As T_Value, Count(T_Truck) As T_Count ' +
          ' From $Con con Left Join $Bill b on b.L_ID=con.T_LID ' +
          ' Left Join $Stock s on b.L_StockNo=s.P_ID ' +
          ' Where (IsNull(T_Enabled, '''')<>''$NO'') ' +
          ' And T_PayMent Like ''%%回厂%%''';
  //xxxxx

  if FJBWhere = '' then
  begin
    nSQL := nSQL + ' And (T_Date>=''$ST'' and T_Date <''$End'')';

    if nWhere <> '' then
      nSQL := nSQL + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    nSQL := nSQL + ' And (' + FJBWhere + ')';
  end;

  nSQL := nSQL + ' Group By T_SaleMan,T_CusName,T_PayMent,T_StockName,' +
          'P_Qlevel,L_Type,T_DPrice,T_CPrice, T_Delivery ';
  nSQL := nSQL + ' Order By T_SaleMan,T_CusName ';

  nSQL := MacroValue(nSQL, [MI('$Con', sTable_TransContract),
            MI('$Bill', sTable_Bill),
            MI('$Stock', sTable_StockParam),
            MI('$Yes', sFlag_Yes), MI('$NO', sFlag_NO),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxxx

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

    FWhere := 'T_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text]);
    QueryData(FWhere);
  end else

  if Sender = EditSales then
  begin
    EditSales.Text := Trim(EditSales.Text);
    if EditSales.Text = '' then Exit;

    FWhere := 'T_SaleMan like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSales.Text]);
    QueryData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryTransTotal, TfFrameQueryTransTotal.FrameID);
end.
