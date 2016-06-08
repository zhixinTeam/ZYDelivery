{*******************************************************************************
����: fendou116688@163.com 2015/11/24
����: ����������ѯ
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
    N5: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  protected
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
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

//Desc: ���ݲ�ѯSQL
function TfFrameFXZhiKa.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select *, cast( I_YuE /I_Price as decimal(18, 2))  As I_Rest,' +
            ' sc.C_Name as Cus_Name,sm.S_Name as Sale_Name From(' +
            'Select zk.*, I_Money+I_RefundMoney-I_OutMoney-I_FreezeMoney-' +
            'I_BackMoney As I_YuE' +
            ' From $FXZhiKa zk) fxdtl' +
            ' Left join $SC sc on fxdtl.I_Customer=sc.C_ID ' +
            ' Left Join $SM sm on fxdtl.I_SaleMan=sm.S_ID ';
  //�������Ϣ

  if nWhere <> '' then
       Result := Result + ' Where ' + nWhere
  else Result := Result + ' Where I_Enabled=''$Yes''';

  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewCusFZY) then
       Result := Result + ''
  else Result := Result + ' And sc.C_Type=''$ZY''';


  Result := MacroValue(Result, [MI('$Yes', sFlag_Yes), MI('$ZY', sFlag_CusZY),
            MI('$FXZhiKa', sTable_FXZhiKa), MI('$SC', sTable_Customer),
            MI('$SM', sTable_Salesman)]);
end;

function TfFrameFXZhiKa.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'I_Price';
end;

//Desc: ִ�в�ѯ
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

    FWhere := 'I_Card Like ''%%%s%%'' or I_CardNO Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCard.Text, EditCard.Text]);
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
//Desc: �������
procedure TfFrameFXZhiKa.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormFXZhiKa, PopedomItem, @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: ɾ��
procedure TfFrameFXZhiKa.BtnDelClick(Sender: TObject);
var nStr,nCusID,nPayType: string;
    nInMoney,nOutMoney,nRefundMoney,nBackMoney: Double;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫͣ�õļ�¼', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_FreezeMoney').AsFloat>0 then
  begin
    ShowMsg('�ÿ���δ������������ֹͣ��', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Enabled').AsString = sFlag_No then
  begin
    ShowMsg('�ö�����ͣ��', sHint); Exit;
  end;

  nStr := 'ȷ��Ҫͣ�ñ��Ϊ[ %s ]�ķ���������?';
  nStr := Format(nStr, [SQLQuery.FieldByName('I_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;



  FDM.ADOConn.BeginTrans;
  try
    nCusID := SQLQuery.FieldByName('I_Customer').AsString;
    nInMoney   := SQLQuery.FieldByName('I_Money').AsFloat;
    nOutMoney  := SQLQuery.FieldByName('I_OutMoney').AsFloat;
    nPayType   := SQLQuery.FieldByName('I_Paytype').AsString;
    nRefundMoney  := SQLQuery.FieldByName('I_RefundMoney').AsFloat;
    nBackMoney := Float2Float(nInMoney + nRefundMoney -nOutMoney, cPrecision, False);

    nStr := 'Update %s Set I_Enabled=''%s'', I_BackMoney=%s ' +
            'Where I_ID=''%s''';
    nStr := Format(nStr, [sTable_FXZhiKa, sFlag_No, FloatToStr(nBackMoney),
            SQLQuery.FieldByName('I_ID').AsString]);
    //xxxxx
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+%s,' +
            'A_CardUseMoney=A_CardUseMoney-%s Where A_CID=''%s'' And A_Type=''%s''';
    nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nOutMoney),
            FloatToStr(nInMoney), nCusID, nPayType]);
    //xxxxx
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    ShowMsg('ͣ�ôſ��ɹ���', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('ͣ�ôſ�ʧ�ܣ�', sHint);
  end;

  nStr := SQLQuery.FieldByName('I_Card').AsString;
  if nStr <> '' then
    DeleteICCardInfo(nStr, SQLQuery.FieldByName('I_ID').AsString);

  InitFormData('');
end;

procedure TfFrameFXZhiKa.N6Click(Sender: TObject);
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  if not BtnEdit.Enabled then
  begin
    ShowMsg('��û�и�Ȩ��', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Card').AsString<>'' then
  begin
    ShowMsg('���Ѱ���IC��', sHint); Exit;
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
    ShowMsg('��û�и�Ȩ��', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Card').AsString='' then
  begin
    ShowMsg('��δ������', sHint); Exit;
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
    ShowMsg('��û�и�Ȩ��', sHint); Exit;
  end;

  nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
  CreateBaseFormItem(cFI_FormFXZhiKa, '', @nP);

  InitFormData('')
end;

procedure TfFrameFXZhiKa.N8Click(Sender: TObject);
begin
  inherited;
  case TMenuItem(Sender).Tag of
  0: FWhere := 'I_Enabled = ''$No''';
  1: FWhere := 'I_Enabled = ''$Yes''';
  2: FWhere := '1=1';
  end;

  FWhere := MacroValue(FWhere, [MI('$Yes', sFlag_Yes), MI('$No', sFlag_No)]);
  InitFormData(FWhere)
end;

procedure TfFrameFXZhiKa.N11Click(Sender: TObject);
var nStr, nStrVal, nRID, nCID, nPayType: string;
    nVal, nRest, nPrice, nMoney: Double;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ��Ҫ�����޶�Ŀ�Ƭ', sHint); Exit;
  end;

  if SQLQuery.FieldByName('I_Enabled').AsString = sFlag_No then
  begin
    ShowMsg('�ö�����ͣ��', sHint); Exit;
  end;

  nRest := SQLQuery.FieldByName('I_Rest').AsFloat;
  nStr := '�ͻ� [%s] �������ǰ�������Ϊ [%.2f] ��, �Ƿ񽵵��޶�?';
  nStr := Format(nStr, [SQLQuery.FieldByName('Cus_Name').AsString,
          nRest]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := 'ʣ���� [%.2f] ,�����뽵���޶���:';
  nStr := Format(nStr, [nRest]);
  if not ShowInputBox(nStr, sHint, nStrVal) then Exit;

  nVal := StrToFloatDef(nStrVal, 0);
  if FloatRelation(nVal, 0, rtLE) then
  begin
    ShowMsg('���������0����', sHint);
    Exit;
  end;

  if FloatRelation(nVal, nRest, rtGreater) then
  begin
    ShowMsg('���������ڿ�������������²���', sHint);
    Exit;
  end;
  //xxxxx

  nRID   := SQLQuery.FieldByName('R_ID').AsString;
  nCID   := SQLQuery.FieldByName('I_Customer').AsString;
  nPrice := SQLQuery.FieldByName('I_Price').AsFloat;
  nMoney := Float2Float(nVal * nPrice, cPrecision, True);
  nPayType := SQLQuery.FieldByName('I_Paytype').AsString;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set I_Money=I_Money+(-%s),I_Value=I_Value+(-%s),' +
            'I_VerifyMan=''%s'',I_VerifyDate=%s Where R_ID=%s';
    nStr := Format(nStr, [sTable_FXZhiKa, FloatToStr(nMoney),FloatToStr(nVal),
            gSysParam.FUserID, FDM.SQLServerNow, nRID]);
    FDM.ExecuteSQL(nStr);

    nStr := '����������� [%s], ���ö�ȼ�����[%s]';
    nStr := Format(nStr, [FloatToStr(nVal),FloatToStr(nMoney)]);
    FDM.WriteSysLog(sFlag_ZhiKaItem, nRID, nStr);

    nStr := 'Update %s Set A_CardUseMoney=A_CardUseMoney+(-%s) ' +
            'Where A_CID=''%s'' And A_Type=''%s''';
    nStr := Format(nStr, [sTable_CusAccDetail, FloatToStr(nMoney),
            nCID, nPayType]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    ShowMsg('�����޶�ɹ�', sHint);
  except
    ShowMsg('δ֪ԭ���½����޶�ʧ��', sHint);
    raise;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameFXZhiKa, TfFrameFXZhiKa.FrameID);
end.
