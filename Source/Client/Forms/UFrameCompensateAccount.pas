{*******************************************************************************
  ����: fendou116688@163.com 2016/1/13
  ����: �ͻ�������ѯ
*******************************************************************************}
unit UFrameCompensateAccount;

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
  TfFrameCompensateAccount = class(TfFrameNormal)
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
    procedure N3Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure PMenu1Popup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, USysBusiness;

class function TfFrameCompensateAccount.FrameID: integer;
begin
  Result := cFI_FrameCompensateAccountQuery;
end;

function TfFrameCompensateAccount.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select ca.*,cus.*,S_Name as C_SaleName,' +
            '(A_BeginBalance+A_InMoney-A_OutMoney-' +
            ' A_Compensation-A_FreezeMoney-A_CardUseMoney)' +
            ' As A_YuE From $CA ca ' +
            ' Left Join $Cus cus On cus.C_ID=ca.A_CID ' +
            ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where IsNull(C_XuNi, '''')<>''$Yes'''
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$CA', sTable_CompensateAccount),
            MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman),
            MI('$Yes', sFlag_Yes)]);
  //xxxxx
end;

//Desc: ִ�в�ѯ  
procedure TfFrameCompensateAccount.EditIDPropertiesButtonClick(Sender: TObject;
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
procedure TfFrameCompensateAccount.PMenu1Popup(Sender: TObject);
begin
  {$IFDEF SyncRemote}
  N4.Visible := True;
  {$ELSE}
  N4.Visible := False;
  {$ENDIF}
  N6.Enabled := gSysParam.FIsAdmin;
end;

//Desc: ��ݲ˵�
procedure TfFrameCompensateAccount.N3Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('C_XuNi=''%s''', [sFlag_Yes]);
   20: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

procedure TfFrameCompensateAccount.N4Click(Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('A_CID').AsString;
    nVal := GetCustomerCompensateMoney(nStr);

    nStr := '�ͻ���ǰ���ý������:' + #13#10#13#10 +
            '*.�ͻ�����: %s ' + #13#10 +
            '*.�ʽ����: %.2f Ԫ' + #13#10;
    nStr := Format(nStr, [SQLQuery.FieldByName('C_Name').AsString, nVal]);
    ShowDlg(nStr, sHint);
  end;
end;

//Desc: У���ͻ��ʽ�
procedure TfFrameCompensateAccount.N6Click(Sender: TObject);
var nStr,nCID: string;
    nVal: Double;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nCID := SQLQuery.FieldByName('A_CID').AsString;

  nStr := 'Select Sum(L_Money) from (' +
          '  select L_Value * L_Price as L_Money from %s' +
          '  where L_OutFact Is not Null And L_CusID = ''%s'') t';
  nStr := Format(nStr, [sTable_Bill, nCID]);

  with FDM.QuerySQL(nStr) do
  begin
    nVal := Float2Float(Fields[0].AsFloat, cPrecision, True);
    nStr := 'Update %s Set A_OutMoney=%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nVal, nCID]);
    FDM.ExecuteSQL(nStr);
  end;

  nStr := 'Select Sum(L_Money) from (' +
          '  select L_Value * L_Price as L_Money from %s' +
          '  where L_OutFact Is Null And L_CusID = ''%s'') t';
  nStr := Format(nStr, [sTable_Bill, nCID]);

  with FDM.QuerySQL(nStr) do
  begin
    nVal := Float2Float(Fields[0].AsFloat, cPrecision, True);
    nStr := 'Update %s Set A_FreezeMoney=%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nVal, nCID]);
    FDM.ExecuteSQL(nStr);
  end;

  InitFormData(FWhere);
  ShowMsg('У�����', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameCompensateAccount, TfFrameCompensateAccount.FrameID);
end.