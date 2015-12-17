{*******************************************************************************
作者: fendou116688@163.com 2015/11/24
描述: 分销订单查询
*******************************************************************************}
unit UFrameFXZhiKa;

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
  TfFrameFXZhiKa = class(TfFrameNormal)
    EditCard: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditSaleMan: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  protected
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
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
class function TfFrameFXZhiKa.FrameID: integer;
begin
  Result := cFI_FrameFXZhiKa;
end;

procedure TfFrameFXZhiKa.OnCreateFrame;
begin
  inherited;
end;

procedure TfFrameFXZhiKa.OnDestroyFrame;
begin
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameFXZhiKa.InitFormDataSQL(const nWhere: string): string;
begin
  FEnableBackDB := True;

  Result := 'Select zk.*, I_Money-I_OutMoney-I_FreezeMoney-I_BackMoney As I_YuE,' +
            'sc.C_Name as Cus_Name,sm.S_Name as Sale_Name From $FXZhiKa zk ' +
            ' Left join $SC sc on zk.I_Customer=sc.C_ID ' +
            ' Left Join $SM sm on zk.I_SaleMan=sm.S_ID ';
  //提货卡信息

  if nWhere <> '' then
    Result := Result + ' Where ' + nWhere;

  Result := MacroValue(Result, [MI('$FXZhiKa', sTable_FXZhiKa),
            MI('$SC', sTable_Customer), MI('$SM', sTable_Salesman)]);
end;

function TfFrameFXZhiKa.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'I_Price';
end;

//Desc: 执行查询
procedure TfFrameFXZhiKa.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'I_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('I_Card Like ''%%%s%%''', [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditSaleMan then
  begin
    EditSaleMan.Text := Trim(EditSaleMan.Text);
    if EditSaleMan.Text = '' then Exit;

    FWhere := 'sm.S_PY like ''%%%s%%'' Or sm.S_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSaleMan.Text, EditSaleMan.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'sc.C_PY like ''%%%s%%'' Or sc.C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 开提货卡
procedure TfFrameFXZhiKa.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormFXZhiKa, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameFXZhiKa.BtnDelClick(Sender: TObject);
var nStr,nCusID: string;
    nInMoney,nOutMoney,nBackMoney: Double;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要停用的记录', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_FreezeMoney').AsFloat>0 then
  begin
    ShowMsg('该卡有未出厂车辆，禁止停用', sHint); Exit;
  end;

  nStr := '确定要停用编号为[ %s ]的分销订单吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('I_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nCusID := SQLQuery.FieldByName('I_Customer').AsString;
    nInMoney   := SQLQuery.FieldByName('I_Money').AsFloat;
    nOutMoney  := SQLQuery.FieldByName('I_OutMoney').AsFloat;
    nBackMoney := Float2Float(nInMoney-nOutMoney, cPrecision, False);

    nStr := 'Update %s Set I_Enabled=''%s'', I_BackMoney=%s ' +
            'Where I_ID=''%s''';
    nStr := Format(nStr, [sTable_FXZhiKa, sFlag_No, FloatToStr(nBackMoney),
            SQLQuery.FieldByName('I_ID').AsString]);
    //xxxxx
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+%s,' +
            'A_CardUseMoney=A_CardUseMoney-%s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nOutMoney),
            FloatToStr(nInMoney), nCusID]);
    //xxxxx
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    ShowMsg('停用磁卡成功！', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('停用磁卡失败！', sHint);
  end;

  DeleteICCardInfo(SQLQuery.FieldByName('I_Card').AsString,
    SQLQuery.FieldByName('I_ID').AsString);

  InitFormData('');
end;

procedure TfFrameFXZhiKa.N6Click(Sender: TObject);
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Card').AsString<>'' then
  begin
    ShowMsg('您已办理IC卡', sHint); Exit;
  end;  

  SaveICCardInfo(SQLQuery.FieldByName('I_ID').AsString,sFlag_BillFX,
    sFlag_ICCardV);
  InitFormData('');
end;

procedure TfFrameFXZhiKa.N4Click(Sender: TObject);
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Card').AsString='' then
  begin
    ShowMsg('您未办理副卡', sHint); Exit;
  end;

  DeleteICCardInfo(SQLQuery.FieldByName('I_Card').AsString,
    SQLQuery.FieldByName('I_ID').AsString);
  InitFormData('');
end;

procedure TfFrameFXZhiKa.N1Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('您没有该权限', sHint); Exit;
  end;

  nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
  CreateBaseFormItem(cFI_FormFXZhiKa, '', @nP);

  InitFormData('')
end;

initialization
  gControlManager.RegCtrl(TfFrameFXZhiKa, TfFrameFXZhiKa.FrameID);
end.
