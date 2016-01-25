{*******************************************************************************
  ����: dmzn@163.com 2009-7-2
  ����: ԭ����
*******************************************************************************}
unit UFramePMaterails;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus;

type
  TfFrameMaterails = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N3Click(Sender: TObject);
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase, USysBusiness;

class function TfFrameMaterails.FrameID: integer;
begin
  Result := cFI_FrameMaterails;
end;

function TfFrameMaterails.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Materails;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By M_Name';
end;

//Desc: ���
procedure TfFrameMaterails.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormMaterails, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: �޸�
procedure TfFrameMaterails.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('M_ID').AsString;
    CreateBaseFormItem(cFI_FormMaterails, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: ɾ��
procedure TfFrameMaterails.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_Name').AsString;
    nStr := Format('ȷ��Ҫɾ��ԭ����[ %s ]��?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Materails, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: ��ѯ
procedure TfFrameMaterails.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('M_Name Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameMaterails.N1Click(Sender: TObject);
begin
  inherited;
  SyncRemoteMeterails;
  BtnRefresh.Click;
end;

procedure TfFrameMaterails.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  {$IFDEF SyncRemote}
  N1.Visible := True;
  {$ENDIF}
  N3.Visible := gSysParam.FIsAdmin;
  N4.Visible := gSysParam.FIsAdmin;
end;

procedure TfFrameMaterails.N3Click(Sender: TObject);
var nSQL, nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_Name').AsString;
    nStr := Format('ȷ��Ҫ��ԭ����[ %s ] %s ��?', [nStr, TMenuItem(Sender).Caption]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := SQLQuery.FieldByName('M_ID').AsString;
    if Sender = N3 then
    begin
      nSQL := 'Delete From %s Where D_Name=''%s'' And D_Value=''%s''';
      nSQL := Format(nSQL, [sTable_SysDict, sFlag_NFStock, nStr]);
    end else

    if Sender = N4 then
    begin
      nSQL := 'Insert Into %s (D_Name, D_Value, D_Desc, D_Memo) ' +
              'Values(%s, %s, %s, %s)';
      nSQL := Format(nSQL, [sTable_SysDict, sFlag_NFStock, nStr,
              '�ֳ�������', SQLQuery.FieldByName('M_Name').AsString]);

      nStr := Format('Select * From %s Where D_Name=''%s'' And D_Value=''%s''',
              [sTable_SysDict, sFlag_NFStock, nStr]);
      with FDM.QueryTemp(nStr) do
      if RecordCount>0 then
      begin
        nStr := 'ԭ���� [%s] �Ѿ�����Ϊ������';
        nStr := Format(nStr, [SQLQuery.FieldByName('M_Name').AsString]);
        Exit;
      end;
    end;

    FDM.ExecuteSQL(nSQL);
  end;

  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameMaterails, TfFrameMaterails.FrameID);
end.
