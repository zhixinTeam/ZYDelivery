{*******************************************************************************
  ����: fendou116688@163.com 2016/1/13
  ����: �ͻ�����
*******************************************************************************}
unit UFrameFLPayment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus;

type
  TfFrameFLPayment = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FPaymentType: String;
    FStart,FEnd: TDate;
    //ʱ������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UFormDateFilter,
  UDataModule, UFormInputbox;

//------------------------------------------------------------------------------
class function TfFrameFLPayment.FrameID: integer;
begin
  Result := cFI_FrameFLPayment;
end;

procedure TfFrameFLPayment.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameFLPayment.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFrameFLPayment.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select iom.*,sm.S_Name From $IOM iom ' +
            ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ' +
            'Where M_Type=''$HK'' ';
            
  if nWhere = '' then
       Result := Result + 'And (M_Date>=''$Start'' And M_Date <''$End'')'
  else Result := Result + 'And (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$IOM', sTable_CompensateInOutMoney), MI('$HK', sFlag_MoneyFanHuan),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: �ؿ�
procedure TfFrameFLPayment.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FParamA := '';
  CreateBaseFormItem(cFI_FormFLPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: �ض��ͻ��ؿ�
procedure TfFrameFLPayment.cxView1DblClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nP.FParamA := SQLQuery.FieldByName('M_CusID').AsString;
  CreateBaseFormItem(cFI_FormFLPayment, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: ֽ��(����)�ؿ�
procedure TfFrameFLPayment.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormPaymentZK, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData;
  end;
end;

//Desc: ����ɸѡ
procedure TfFrameFLPayment.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: ִ�в�ѯ
procedure TfFrameFLPayment.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;
    
    FWhere := '(M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%'')';
    FWhere := Format(FWhere, [EditID.Text, EditID.Text]);
    InitFormData(FWhere);
  end else
end;

procedure TfFrameFLPayment.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N1.Visible := BtnAdd.Enabled;
  N2.Visible := BtnAdd.Enabled;
end;

procedure TfFrameFLPayment.N1Click(Sender: TObject);
var nMemo, nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr  := Trim(SQLQuery.FieldByName('M_Memo').AsString);
    nMemo := nStr;
    if not ShowInputBox('�������µı�ע��Ϣ:', '�޸�', nMemo) then Exit;

    if (nMemo = '') or (nStr = nMemo) then Exit;
    //��Ч��һ��

    nStr := 'Update %s Set M_Memo=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_CompensateInOutMoney, nMemo,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);
    ShowMsg('�޸ı�ע�ɹ�!', sHint);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameFLPayment.N2Click(Sender: TObject);
var nPayment, nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr  := SQLQuery.FieldByName('M_Payment').AsString;
    nPayment := nStr;
    if not ShowInputBox('�������µĸ��ʽ:', '�޸�', nPayment) then Exit;

    if (nPayment = '') or (nStr = nPayment) then Exit;
    //��Ч��һ��

    nStr := 'Update %s Set M_Payment=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_CompensateInOutMoney, nPayment,
            SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);
    ShowMsg('�޸ĸ��ʽ�ɹ�!', sHint);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameFLPayment, TfFrameFLPayment.FrameID);
end.
