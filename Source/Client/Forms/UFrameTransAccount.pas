{*******************************************************************************
作者: fendou116688@163.com 2015/11/26
描述: 客户运费账户信息查询
*******************************************************************************}
unit UFrameTransAccount;

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
  ComCtrls, ToolWin, cxDropDownEdit, cxCalendar;

type
  TfFrameTransAccount = class(TfFrameNormal)
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
    EditTime: TcxDateEdit;
    dxLayout1Item3: TdxLayoutItem;
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
    FDateTimeFilter :string;
  protected
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
  ULibFun, UMgrControl, UFormBase, USysConst, USysDB, UDataModule,
  USysBusiness;

class function TfFrameTransAccount.FrameID: integer;
begin
  Result := cFI_FrameTransAccountQuery;
end;

procedure TfFrameTransAccount.OnCreateFrame;
begin
  inherited;
  EditTime.Date := Date;
end;

procedure TfFrameTransAccount.OnDestroyFrame;
begin
  inherited;
end;

function TfFrameTransAccount.InitFormDataSQL(const nWhere: string): string;
begin
  FDateTimeFilter := DateTime2Str(EditTime.Date);

  Result := 'Select ca.*,cus.*,S_Name as C_SaleName, ' +
            'IsNull(T_OutMoney, 0) As T_OutMoney, IsNull(M_InMoney, 0) As M_InMoney, ' +
            '(A_BeginBalance+A_InMoney+A_RefundMoney-A_OutMoney-A_Compensation-' +
            'A_FreezeMoney) As A_YuE, ' +
            '(A_BeginBalance + IsNull(M_InMoney, 0)-IsNull(T_OutMoney, 0)) As T_YuE ' +
            'From $CA ca ' +
            ' Left Join $Cus cus On cus.C_ID=ca.A_CID ' +
            ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
            ' Left Join (Select Sum(T_CusMoney) As T_OutMoney, T_CusID ' +
            '  From $THT Where T_Enabled=''$Yes'' ' +
            '  And T_Payment Like ''回%%'' And T_Date<''$DATE'' ' +
            '  Group By T_CusID) ht on ht.T_CusID = ca.A_CID ' +
            ' Left Join (Select Sum(M_Money) As M_InMoney, M_CusID  ' +
            ' From $MDT Where M_Date<''$DATE'' ' +
            ' Group By M_CusID) mdt on mdt.M_CusID=ca.A_CID ';

  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where IsNull(C_XuNi, '''')<>''$Yes'''
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$CA', sTable_TransAccount),
            MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman),
            MI('$THT', sTable_TransContract),MI('$MDT', sTable_TransInOutMoney),
            MI('$DATE', FDateTimeFilter), MI('$Yes', sFlag_Yes)]);
  //xxxxx   
end;

//Desc: 执行查询  
procedure TfFrameTransAccount.EditIDPropertiesButtonClick(Sender: TObject;
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
procedure TfFrameTransAccount.PMenu1Popup(Sender: TObject);
begin
  {$IFDEF SyncRemote}
  N4.Visible := True;
  {$ELSE}
  N4.Visible := False;
  {$ENDIF}
  N7.Enabled := gSysParam.FIsAdmin;
end;

//Desc: 快捷菜单
procedure TfFrameTransAccount.N3Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('C_XuNi=''%s''', [sFlag_Yes]);
   20: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

procedure TfFrameTransAccount.N4Click(Sender: TObject);
var nStr: string;
    nVal,nCredit: Double;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('A_CID').AsString;
    nVal := GetTransportValidMoney(nStr, False, @nCredit);

    nStr := '客户当前可用金额如下:' + #13#10#13#10 +
            '*.客户名称: %s ' + #13#10 +
            '*.资金余额: %.2f 元' + #13#10 +
            '*.信用金额: %.2f 元' + #13#10;
    nStr := Format(nStr, [SQLQuery.FieldByName('C_Name').AsString, nVal, nCredit]);
    ShowDlg(nStr, sHint);
  end;
end;

//Desc: 校正客户资金
procedure TfFrameTransAccount.N6Click(Sender: TObject);
var nStr,nCID: string;
    nVal: Double;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;

  nCID := SQLQuery.FieldByName('A_CID').AsString;
  nStr := 'Select Sum(T_CusMoney) From %s Where T_CusID=''%s'' ' +
          'And (IsNull(T_Enabled, '''')<>''%s'') And T_PayMent Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_TransContract, nCID, sFlag_No, '回']);

  with FDM.QuerySQL(nStr) do
  begin
    nVal := Float2Float(Fields[0].AsFloat, cPrecision, True);
    nStr := 'Update %s Set A_FreezeMoney=%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_TransAccount, nVal, nCID]);
    FDM.ExecuteSQL(nStr);
  end;

  InitFormData(FWhere);
  ShowMsg('校正完毕', sHint);
end;

//Desc: 资金手动勘误
procedure TfFrameTransAccount.N7Click(Sender: TObject);
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
  gControlManager.RegCtrl(TfFrameTransAccount, TfFrameTransAccount.FrameID);
end.
