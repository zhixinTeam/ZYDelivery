{*******************************************************************************
  作者: dmzn@163.com 2009-6-15
  描述: 办理纸卡(订单)
*******************************************************************************}
unit UFrameFLZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameFLZhiKa = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditSale: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    {*时间区间*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    {*基类函数*}
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, USysConst, USysDB, USysBusiness,
  UFormDateFilter, USysPopedom;

//------------------------------------------------------------------------------
class function TfFrameFLZhiKa.FrameID: integer;
begin
  Result := cFI_FrameFLZhiKa;
end;

procedure TfFrameFLZhiKa.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameFLZhiKa.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameFLZhiKa.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select zk.*,sm.S_Name,sm.S_PY,cus.C_Name,cus.C_PY From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer';
  //订单

  if nWhere = '' then
       Result := Result + ' Where (zk.Z_Date>=''$ST'' and zk.Z_Date <''$End'')' +
                 ' and (Z_InValid Is Null or Z_InValid<>''$Yes'')'
  else Result := Result + ' Where (' + nWhere + ')';

  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       Result := Result + ''
  else Result := Result + ' And C_Type=''$ZY''';

  Result := MacroValue(Result, [MI('$ZK', sTable_FLZhiKa), 
             MI('$Con', sTable_SaleContract), MI('$SM', sTable_Salesman),
             MI('$Cus', sTable_Customer), MI('$Yes', sFlag_Yes),
             MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
             MI('$ZY', sFlag_CusZY)]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameFLZhiKa.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormFLZhiKa, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameFLZhiKa.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;        

  nParam.FParamA := SQLQuery.FieldByName('Z_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  CreateBaseFormItem(cFI_FormFLZhiKa, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFrameFLZhiKa.BtnDelClick(Sender: TObject);
var nStr,nID: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nID := SQLQuery.FieldByName('Z_ID').AsString;
  nStr := 'Select Count(*) From %s Where L_ZhiKa=''%s''';
  nStr := Format(nStr, [sTable_Bill, nID]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    ShowMsg('该订单不能删除', '已提货'); Exit;
  end;

  nStr := Format('确定要删除编号为[ %s ]的订单吗?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    DeleteFLZhiKa(nID);
    FDM.ADOConn.CommitTrans;

    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除记录失败', '未知错误');
  end;
end;

//Desc: 执行查询
procedure TfFrameFLZhiKa.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'Z_CardNO like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCID then
  begin
    EditCID.Text := Trim(EditCID.Text);
    if EditCID.Text = '' then Exit;

    FWhere := 'C_Name like ''%%%s%%'' Or C_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCID.Text, EditCID.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditSale then
  begin
    EditSale.Text := Trim(EditSale.Text);
    if EditSale.Text = '' then Exit;

    FWhere := 'S_Name like ''%%%s%%'' Or S_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSale.Text, EditSale.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 查看内容
procedure TfFrameFLZhiKa.cxView1DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := SQLQuery.FieldByName('Z_ID').AsString;
    CreateBaseFormItem(cFI_FormFLZhiKa, PopedomItem, @nParam);
  end;
end;

//Desc: 日期筛选
procedure TfFrameFLZhiKa.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 打印订单
procedure TfFrameFLZhiKa.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('Z_ID').AsString;
    PrintZhiKaReport(nStr, False);
  end;
end;

//Desc: 快捷查询
procedure TfFrameFLZhiKa.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: FWhere := Format('Z_Freeze=''%s''', [sFlag_Yes]);
    20: FWhere := Format('Z_InValid=''%s''', [sFlag_Yes]);
    30: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

//Desc: 冻结
procedure TfFrameFLZhiKa.N8Click(Sender: TObject);
var nStr,nFlag,nMsg: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    case TComponent(Sender).Tag of
     10:
       if SQLQuery.FieldByName('Z_Freeze').AsString <> sFlag_Yes then
       begin
         nFlag := sFlag_Yes; nMsg := '订单已成功冻结';
       end else Exit;
     20:
       if SQLQuery.FieldByName('Z_Freeze').AsString = sFlag_Yes then
       begin
         nFlag := sFlag_No; nMsg := '冻结已成功解除';
       end else Exit;
    end;

    nStr := 'Update %s Set Z_Freeze=''%s'' Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_FLZhiKa, nFlag, SQLQuery.FieldByName('Z_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg(nMsg, sHint);
  end;
end;

//Desc: 设置订单限提金额
procedure TfFrameFLZhiKa.N10Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  nP.FCommand := cCmd_EditData;
  nP.FParamA := SQLQuery.FieldByName('Z_ID').AsString;
  CreateBaseFormItem(cFI_FormZhiKaFixMoney, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameFLZhiKa.N12Click(Sender: TObject);
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  if SQLQuery.FieldByName('Z_Card').AsString<>'' then
  begin
    ShowMsg('您已办理主卡', sHint); Exit;
  end;

  SaveICCardInfo(SQLQuery.FieldByName('Z_ID').AsString,sFlag_BillFL,
    sFlag_ICCardM);
  InitFormData(FWhere);
end;

procedure TfFrameFLZhiKa.N11Click(Sender: TObject);
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  if SQLQuery.FieldByName('Z_Card').AsString='' then
  begin
    ShowMsg('您未办理主卡', sHint); Exit;
  end;

  DeleteICCardInfo(SQLQuery.FieldByName('Z_Card').AsString,
    SQLQuery.FieldByName('Z_ID').AsString);
  InitFormData(FWhere);  
end;

initialization
  gControlManager.RegCtrl(TfFrameFLZhiKa, TfFrameFLZhiKa.FrameID);
end.
