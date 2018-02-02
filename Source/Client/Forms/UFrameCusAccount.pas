{*******************************************************************************
  作者: dmzn@163.com 2009-09-04
  描述: 客户账户查询
*******************************************************************************}
unit UFrameCusAccount;

{$I Link.Inc}
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
  TfFrameCusAccount = class(TfFrameNormal)
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EditID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    procedure N3Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure PMenu1Popup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysConst, USysDB, UDataModule,
  USysBusiness, USysPopedom;

const
  gA_YuE = 'A_BeginBalance+A_InMoney+A_RefundMoney-A_OutMoney-A_FreezeMoney-A_CardUseMoney';
  gI_YuE = 'I_Money+I_RefundMoney-I_OutMoney-I_FreezeMoney-I_BackMoney';
  gYuE   = 'IsNull(I_YuE, 0) + A_YuE';

class function TfFrameCusAccount.FrameID: integer;
begin
  Result := cFI_FrameCusAccountQuery;
end;

function TfFrameCusAccount.InitFormDataSQL(const nWhere: string): string;
var nSQL, nWh: string;
begin
  nSQL := 'Select IsNull(I_YuE, 0) As I_YuE, $YU As YuE, '+
          'Abs($YU) As YingShow, 0 As YingFu, tt.*, ' +
          'cus.*,S_Name as C_SaleName ' +
          'From (' +
          'Select ($AY) As A_YuE, * From $CA ca ' +
          ' Left Join (Select Sum($IU) As I_YuE, I_Customer, I_Paytype ' +
          ' From $FX Group By I_Customer, I_Paytype ) fx ' +
          'on fx.I_Customer=ca.A_CID And fx.I_Paytype=ca.A_Type) As tt'+
          ' Left Join $Cus cus On cus.C_ID=tt.A_CID ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          ' Where $YU<0 $Where ' +
          'Union ' +
          'Select IsNull(I_YuE, 0) As I_YuE, $YU As YuE, '+
          '0 As YingShow, Abs($YU) As YingFu, tt.*, ' +
          'cus.*,S_Name as C_SaleName ' +
          'From (' +
          'Select ($AY) As A_YuE, * From $CA ca ' +
          ' Left Join (Select Sum($IU) As I_YuE, I_Customer, I_Paytype ' +
          ' From $FX Group By I_Customer, I_Paytype ) fx ' +
          'on fx.I_Customer=ca.A_CID And fx.I_Paytype=ca.A_Type) As tt'+
          ' Left Join $Cus cus On cus.C_ID=tt.A_CID ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          ' Where $YU>=0 $Where ';

  if nWhere = '' then
       nWh := ' And IsNull(C_XuNi, '''')<>''$Yes'''
  else nWh := ' And (' + nWhere + ')';

  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       nWh := nWh + ''
  else nWh := nWh + ' And C_Type=''$ZY''';

  Result := MacroValue(nSQL, [MI('$CA', sTable_CusAccDetail),
            MI('$FX', sTable_FXZhiKa), MI('$Cus', sTable_Customer),
            MI('$SM', sTable_Salesman), MI('$Where', nWh),
            MI('$YU', gYuE), MI('$AY', gA_YuE), MI('$IU', gI_YuE),
            MI('$Yes', sFlag_Yes), MI('$ZY', sFlag_CusZY)]);
  //xxxxx
end;

//Desc: 执行查询  
procedure TfFrameCusAccount.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := Format('C_ID like ''%%%s%%''', [EditID.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'C_PY like ''%%%s%%'' Or C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end
end;

//------------------------------------------------------------------------------
procedure TfFrameCusAccount.PMenu1Popup(Sender: TObject);
begin
  {$IFDEF SyncRemote}
  N4.Visible := True;
  {$ELSE}
  N4.Visible := False;
  {$ENDIF}
  N6.Enabled := gSysParam.FIsAdmin;
  N7.Enabled := gSysParam.FIsAdmin;
end;

//Desc: 快捷菜单
procedure TfFrameCusAccount.N3Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('C_XuNi=''%s''', [sFlag_Yes]);
   20: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

procedure TfFrameCusAccount.N4Click(Sender: TObject);
var nStr: string;
    nVal,nCredit: Double;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('A_CID').AsString + sFlag_Delimater +
            SQLQuery.FieldByName('A_Type').AsString;
    nVal := GetCustomerValidMoney(nStr, False, @nCredit);

    nStr := '客户当前可用金额如下:' + #13#10#13#10 +
            '*.客户名称: %s ' + #13#10 +
            '*.资金余额: %.2f 元' + #13#10 +
            '*.信用金额: %.2f 元' + #13#10;
    nStr := Format(nStr, [SQLQuery.FieldByName('C_Name').AsString, nVal, nCredit]);
    ShowDlg(nStr, sHint);
  end;
end;

//Desc: 校正客户资金
procedure TfFrameCusAccount.N6Click(Sender: TObject);
var nStr,nCID,nTmp: string;
    nList: TStrings;
    nVal: Double;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nCID := SQLQuery.FieldByName('A_CID').AsString;

  nStr := 'Select Sum(L_Money),L_Paytype from (' +
          '  select L_Value * L_Price as L_Money,L_PayType from %s' +
          '  where L_OutFact Is not Null And L_CusID = ''%s''' +
          '  and (L_ZKType=''%s'' or L_ZKType=''%s'')) t' +
          '  Group By L_PayType';
  nStr := Format(nStr, [sTable_Bill, nCID, sFlag_BillSZ, sFlag_BillMY]);

  with FDM.QuerySQL(nStr) do
  begin
    First;

    while not Eof do
    try
      nVal := Float2Float(Fields[0].AsFloat, cPrecision, True);
      nStr := 'Update %s Set A_OutMoney=%.2f Where A_CID=''%s'' And A_Type=''%s''';
      nStr := Format(nStr, [sTable_CusAccDetail, nVal, nCID, Fields[1].AsString]);
      FDM.ExecuteSQL(nStr);
    finally
      Next;
    end;
  end;

  nStr := 'Select Sum(L_Money),L_Paytype from (' +
          '  select L_Value * L_Price as L_Money,L_PayType from %s' +
          '  where L_OutFact Is Null And L_CusID = ''%s''' +
          '  and (L_ZKType=''%s'' or L_ZKType=''%s'')) t' +
          '  Group By L_PayType';
  nStr := Format(nStr, [sTable_Bill, nCID, sFlag_BillSZ, sFlag_BillMY]);

  nList := TStringList.Create;

  try
    with FDM.QuerySQL(nStr) do
    begin
      First;

      while not Eof do
      try
        nVal := Float2Float(Fields[0].AsFloat, cPrecision, True);
        nStr := 'Update %s Set A_FreezeMoney=%.2f Where A_CID=''%s'' ' +
                'And A_Type=''%s''';
        nStr := Format(nStr, [sTable_CusAccDetail, nVal, nCID,
                Fields[1].AsString]);
        //xxxxx

        nList.Add(Fields[1].AsString);
        FDM.ExecuteSQL(nStr);
      finally
        Next;
      end;
    end;

    if nList.Count > 0 then
    begin
      nTmp := AdjustListStrFormat2(nList, '''', True, ',', False);
      //支付类型列表

      nStr := 'Update %s Set A_FreezeMoney=0 Where A_CID=''%s'' ' +
              'And A_Type not In (%s)';
      nStr := Format(nStr, [sTable_CusAccDetail, nCID, nTmp]);
      FDM.ExecuteSQL(nStr);
    end else

    begin
      nStr := 'Update %s Set A_FreezeMoney=0 Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccDetail, nCID]);
      FDM.ExecuteSQL(nStr);
    end;
    //更新标准和贸易纸卡
  finally
    nList.Free;
  end;

  InitFormData(FWhere);
  ShowMsg('校正完毕', sHint);
end;

//Desc: 资金手动勘误
procedure TfFrameCusAccount.N7Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    nP.FParamB := FrameID;

    CreateBaseFormItem(cFI_FormMoneyAdjust, '', @nP);
    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
      ShowMsg('操作成功', sHint); 
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameCusAccount, TfFrameCusAccount.FrameID);
end.
