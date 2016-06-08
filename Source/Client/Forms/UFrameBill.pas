{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 开提货单
*******************************************************************************}
unit UFrameBill;

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
  TfFrameBill = class(TfFrameNormal)
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
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N8: TMenuItem;
    N9: TMenuItem;
    dxLayout1Item10: TdxLayoutItem;
    CheckDelete: TcxCheckBox;
    N10: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item11: TdxLayoutItem;
    N11: TMenuItem;
    N7: TMenuItem;
    N12: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure CheckDeleteClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
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
class function TfFrameBill.FrameID: integer;
begin
  Result := cFI_FrameBill;
end;

procedure TfFrameBill.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBill.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill ';
  //提货单

  if (nWhere = '') or FUseDate then
  begin
    Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       Result := Result + ''
  else Result := Result + nStr + ' L_CusType=''$ZY''';

  Result := MacroValue(Result, [MI('$ZY', sFlag_CusZY),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  if CheckDelete.Checked then
       Result := MacroValue(Result, [MI('$Bill', sTable_BillBak)])
  else Result := MacroValue(Result, [MI('$Bill', sTable_Bill)]);
end;

procedure TfFrameBill.AfterInitFormData;
begin
  FUseDate := True;
end;

function TfFrameBill.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price';
end;

//Desc: 执行查询
procedure TfFrameBill.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FUseDate := Length(EditLID.Text) <= 3;
    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('L_ICC like ''%%%s%%''', [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('L_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 未开始提货的提货单
procedure TfFrameBill.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('(L_Status=''%s'')', [sFlag_BillNew]);
   20: FWhere := 'L_OutFact Is Null'
   else Exit;
  end;

  FUseDate := False;
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 查询删除
procedure TfFrameBill.CheckDeleteClick(Sender: TObject);
begin
  InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 开提货单
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormBill, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := '确定要删除编号为[ %s ]的单据吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if DeleteBill(SQLQuery.FieldByName('L_ID').AsString) then
  begin
    InitFormData(FWhere);
    ShowMsg('提货单已删除', sHint);
  end;
end;

//Desc: 打印提货单
procedure TfFrameBill.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillReport(nStr, False);
  end;
end;

procedure TfFrameBill.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit);
  //销售调拨
end;

//Desc: 修改未进厂车牌号
procedure TfFrameBill.N5Click(Sender: TObject);
var nStr,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nStr := SQLQuery.FieldByName('L_ID').AsString;
    if ChangeLadingTruckNo(nStr, nTruck) then
    begin
      InitFormData(FWhere);
      ShowMsg('车牌号修改成功', sHint);
    end;
  end;
end;

//Desc: 调拨提货单
procedure TfFrameBill.N3Click(Sender: TObject);
var nStr,nTmp, nNewZK,nNewZKType: string;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FParamA := cCmd_ViewData;
    CreateBaseFormItem(cFI_FormReadICCard, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    nNewZK    := nP.FParamD;
    nNewZKType:= nP.FParamE;

    nStr := SQLQuery.FieldByName('L_ZhiKa').AsString;
    if nStr = nNewZK then
    begin
      ShowMsg('相同订单不能调拨', sHint);
      Exit;
    end;

    if nNewZKType = sFlag_BillSZ then
    begin
      nStr := 'Select C_ID,C_Name From %s,%s ' +
              'Where Z_ID=''%s'' And Z_Customer=C_ID';
      nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer, nNewZK]);
    end else

    if nNewZKType = sFlag_BillFX then
    begin
      nStr := 'Select C_ID,C_Name From %s,%s ' +
              'Where I_ID=''%s'' And I_Customer=C_ID';
      nStr := Format(nStr, [sTable_FXZhiKa, sTable_Customer, nNewZK]);
    end else

    if nNewZKType = sFlag_BillFL then
    begin
      nStr := 'Select C_ID,C_Name From %s,%s ' +
              'Where Z_ID=''%s'' And Z_Customer=C_ID';
      nStr := Format(nStr, [sTable_FLZhiKa, sTable_Customer, nNewZK]);
    end;

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('订单信息无效', sHint);
        Exit;
      end;

      nStr := '系统将执行提货调拨操作,明细如下: ' + #13#10#13#10 +
              '※.从客户: %s.%s' + #13#10 +
              '※.到客户: %s.%s' + #13#10 +
              '※.品  种: %s.%s' + #13#10 +
              '※.调拨量: %.2f吨' + #13#10#13#10 +
              '确定要执行请点击"是".';
      nStr := Format(nStr, [SQLQuery.FieldByName('L_CusID').AsString,
              SQLQuery.FieldByName('L_CusName').AsString,
              FieldByName('C_ID').AsString,
              FieldByName('C_Name').AsString,
              SQLQuery.FieldByName('L_StockNo').AsString,
              SQLQuery.FieldByName('L_StockName').AsString,
              SQLQuery.FieldByName('L_Value').AsFloat]);
      if not QueryDlg(nStr, sAsk) then Exit;
    end;

    nStr := SQLQuery.FieldByName('L_ID').AsString;
    if BillSaleAdjust(nStr, nNewZK) then
    begin
      nTmp := '销售调拨给订单[ %s ].';
      nTmp := Format(nTmp, [nP.FParamB]);

      FDM.WriteSysLog(sFlag_BillItem, nStr, nTmp, False);
      InitFormData(FWhere);
      ShowMsg('调拨成功', sHint);
    end;
  end;
end;
//自动生成化验单并打印化验单
procedure TfFrameBill.N10Click(Sender: TObject);
var nSQL, nID, nHuaYan: string;
    nP: TFormCommandParam;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nID     := SQLQuery.FieldByName('L_ID').AsString;
    nHuaYan := SQLQuery.FieldByName('L_HYDan').AsString;

    if nHuaYan <> '' then PrintHuaYanReport(nHuaYan, False)
    else
    begin
      nP.FParamA := nID;
      CreateBaseFormItem(cFI_FormStockHuaYan, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOk)  then Exit;

      nSQL := 'Update %s Set L_HYDan=''%s'' Where L_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Bill, nP.FParamB, nID]);
      FDM.ExecuteSQL(nSQL);
    end;
  end;

  InitFormData(FWhere);
end;

procedure TfFrameBill.N11Click(Sender: TObject);
begin
  inherited;
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FUseDate := False;

    FWhere := '(L_Date>=''%s'' and L_Date <''%s'')';
    FWhere := Format(FWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_BillPick, sFlag_BillPost]);
    InitFormData(FWhere);
  finally
    FWhere := '';
  end;
end;

procedure TfFrameBill.N7Click(Sender: TObject);
var nOld, nNew, nStr: string;
begin
  inherited;

  nOld := SQLQuery.FieldByName('L_Lading').AsString;

  if nOld = sFlag_TiHuo then
  begin
    nNew := sFlag_SongH;
    nStr := '提货方式从 [T、自提] 改为 [S、送货]';
  end else

  if nOld = sFlag_SongH then
  begin
    nNew := sFlag_TiHuo;
    nStr := '提货方式从 [S、送货] 改为 [T、自提]';
  end;

  if not QueryDlg(nStr, sHint) then Exit;

  nStr := 'Update %s Set L_Lading=''%s'' Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nNew,
          SQLQuery.FieldByName('L_ID').AsString]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ShowMsg('修改提货方式成功', sHint);
  InitFormData(FWhere);
end;

//Date: 2016/3/29
//Parm: 
//Desc: 修改提货量(已出厂或者已经二次过重的提货单禁止修改)
procedure TfFrameBill.N12Click(Sender: TObject);
var nStr, nValue: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_Value').AsString;
    nValue := nStr;
    if not ShowInputBox('请输入新的提货量:', '修改', nValue, 15) then Exit;

    if (nValue = '') or (nStr = nValue) then Exit;
    //无效或一致

    if (not IsNumber(nValue, True)) or (StrToFloat(nValue) <= 0) then
    begin
      nStr := '提货量必须大于0';
      ShowMsg(nStr, sHint);
      Exit;
    end;

    if ChangeLadingValue(SQLQuery.FieldByName('L_ID').AsString, nValue) then
     ShowMsg('修改提货量成功!', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBill, TfFrameBill.FrameID);
end.
