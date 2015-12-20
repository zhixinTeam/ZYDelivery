{*******************************************************************************
  作者: dmzn@163.com 2009-7-22
  描述: 检验记录
*******************************************************************************}
unit UFrameHYRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UFrameNormal,
  Menus, UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameHYRecord = class(TfFrameNormal)
    EditStock: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1DblClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //初始化数据
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysFun, USysConst, USysGrid, USysDB, UMgrControl,
  UFormDateFilter, UFormHYRecord;

class function TfFrameHYRecord.FrameID: integer;
begin
  Result := cFI_FrameStockRecord;
end;

procedure TfFrameHYRecord.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameHYRecord.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameHYRecord.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select sr.*,se.*,P_Stock,P_Type,P_Name From $SR sr' +
            ' Left Join $SP sp On sp.P_ID=sr.R_PID ' +
            ' Left Join $SE se On sr.R_ExtID=se.E_ID ';

  if nWhere = '' then
       Result := Result + 'Where (R_Date>=''$Start'' and R_Date<''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SR', sTable_StockRecord),
            MI('$SP', sTable_StockParam), MI('$SE', sTable_StockRecordExt),
            MI('$Start', DateTime2Str(FStart)),MI('$End', DateTime2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameHYRecord.BtnAddClick(Sender: TObject);
begin
  if ShowStockRecordAddForm then InitFormData('');
end;

//Desc: 编辑
procedure TfFrameHYRecord.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('R_ID').AsString;
  if ShowStockRecordEditForm(nStr) then InitFormData(FWhere);
end;

//Desc: 删除
procedure TfFrameHYRecord.BtnDelClick(Sender: TObject);
var nStr,nSQL, nExtID, nRID: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  if (SQLQuery.FieldByName('E_Freeze').AsFloat>0) or
     (SQLQuery.FieldByName('E_Sent').AsFloat>0) then
  begin
    ShowMsg('禁止删除, 已发货', sWarn); Exit;
  end;     

  nStr := SQLQuery.FieldByName('R_ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]的检验记录吗', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nRID   := SQLQuery.FieldByName('R_ID').AsString;
    nExtID := SQLQuery.FieldByName('R_ExtID').AsString;

    nSQL := 'Delete From %s Where R_ID=%s';
    nSQL := Format(nSQL, [sTable_StockRecord, nRID]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where E_ID=''%s''';
    nSQL := Format(nSQL, [sTable_StockRecordExt, nExtID]);
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    ShowMsg('记录已成功删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败,未知错误', sHint);
  end;

  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameHYRecord.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 查询
procedure TfFrameHYRecord.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'R_SerialNo like ''%%' + EditID.Text + '%%''';
    InitFormData(FWhere);
  end else

  if Sender = EditStock then
  begin
    EditStock.Text := Trim(EditStock.Text);
    if EditStock.Text = '' then Exit;

    FWhere := 'P_Stock like ''%%' + EditStock.Text + '%%''';
    InitFormData(FWhere);
  end else
end;

//Desc: 查看
procedure TfFrameHYRecord.cxView1DblClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    ShowStockRecordViewForm(nStr);
  end;
end;

procedure TfFrameHYRecord.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N1.Visible := BtnAdd.Enabled;
end;

procedure TfFrameHYRecord.N1Click(Sender: TObject);
var nStr, nSeal: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nSeal := SQLQuery.FieldByName('R_SerialNo').AsString;

    nStr  := '要停用批次号[ %s ]么?';
    nStr  := Format(nStr, [nSeal]);
    if not QueryDlg(nStr, sAsk) then  Exit;

    nStr := 'Update %s Set E_Status=''%s'' Where E_ID=''%s''';
    nStr := Format(nStr, [sTable_StockRecordExt, sFlag_No,
            SQLQuery.FieldByName('R_ExtID').AsString]);
    FDM.ExecuteSQL(nStr);

    InitFormData('');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameHYRecord, TfFrameHYRecord.FrameID);
end.
