{*******************************************************************************
  ����: fendou116688@163.com 2015/8/8
  ����: �ɹ����뵥����
*******************************************************************************}
unit UFramePOrderBase;

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
  TfFramePOrderBase = class(TfFrameNormal)
    EditCustomer: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    EditID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Item10: TdxLayoutItem;
    CheckDelete: TcxCheckBox;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure CheckDeleteClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //��������
    FTimeS,FTimeE: TDate;
    //ʱ��β�ѯ
    FUseDate: Boolean;
    //ʹ������
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
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFramePOrderBase.FrameID: integer;
begin
  Result := cFI_FrameOrderBase;
end;

procedure TfFramePOrderBase.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePOrderBase.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: ���ݲ�ѯSQL
function TfFramePOrderBase.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $OrderBase ';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (B_Date >=''$ST'' and B_Date<''$End'') '
  else Result := Result + ' Where (' + nWhere + ')';

  if CheckDelete.Checked then
       Result := MacroValue(Result, [MI('$OrderBase', sTable_OrderBaseBak)])
  else Result := MacroValue(Result, [MI('$OrderBase', sTable_OrderBase)]);

  Result := MacroValue(Result, [MI('$ST', Date2Str(FStart)),
            MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ִ�в�ѯ
procedure TfFramePOrderBase.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'B_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'B_SaleMan like ''%%%s%%'' Or B_SaleMan like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);  
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'B_ProPY like ''%%%s%%'' Or B_ProName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end
end;

//Desc: ����ɸѡ
procedure TfFramePOrderBase.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: ��ѯɾ��
procedure TfFramePOrderBase.CheckDeleteClick(Sender: TObject);
begin
  InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: �����뵥
procedure TfFramePOrderBase.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormOrderBase, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: �޸����뵥
procedure TfFramePOrderBase.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�༭�ļ�¼', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('B_ID').AsString;
  CreateBaseFormItem(cFI_FormOrderBase, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: ɾ��
procedure TfFramePOrderBase.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('B_ID').AsString;
  if not QueryDlg('ȷ��Ҫɾ�����Ϊ[ ' + nStr + ' ]�����뵥��?', sAsk) then Exit;

  if DeleteOrderBase(nStr) then ShowMsg('�ѳɹ�ɾ����¼', sHint);

  InitFormData('');
end;

//Desc: �޸Ķ�������
procedure TfFramePOrderBase.N1Click(Sender: TObject);
var nXuNi, nStr, nBID: String;
begin
  inherited;

  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nBID := SQLQuery.FieldByName('B_ID').AsString;
    if not QueryDlg('ȷ��Ҫ�޸ı��Ϊ[ ' + nBID + ' ]�����뵥��?', sAsk) then Exit;

    Case TMenuItem(Sender).Tag of
    0:  nXuNi := sFlag_Yes;
    1:  nXuNi := sFlag_No;
    end;

    FDM.ADOConn.BeginTrans;
    try
      nStr := 'Update %s Set B_XuNi=''%s'' Where B_ID=''%s''';
      nStr := Format(nStr, [sTable_OrderBase, nXuNi, nBID]);
      FDM.ExecuteSQL(nStr);

      nStr := 'Update %s Set O_XuNi=''%s'' Where O_BID=''%s''';
      nStr := Format(nStr, [sTable_Order, nXuNi, nBID]);
      FDM.ExecuteSQL(nStr);

      FDM.ADOConn.CommitTrans;
    except
      FDM.ADOConn.RollbackTrans;
      raise;
    end;
  end;
end;

procedure TfFramePOrderBase.cxView1DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := SQLQuery.FieldByName('B_ID').AsString;
    CreateBaseFormItem(cFI_FormOrderBase, PopedomItem, @nParam);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePOrderBase, TfFramePOrderBase.FrameID);
end.
