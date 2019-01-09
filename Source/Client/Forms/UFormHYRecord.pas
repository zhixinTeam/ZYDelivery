{*******************************************************************************
  ����: dmzn@163.com 2009-07-20
  ����: ����¼��
*******************************************************************************}
unit UFormHYRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, cxGraphics, StdCtrls, cxMaskEdit, cxDropDownEdit,
  cxMCListBox, cxMemo, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxControls, cxButtonEdit, cxCalendar, ExtCtrls, cxPC, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters;

type
  TfFormHYRecord = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    wPanel: TPanel;
    dxLayoutControl1Item4: TdxLayoutItem;
    Label17: TLabel;
    Label18: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Bevel2: TBevel;
    cxTextEdit29: TcxTextEdit;
    cxTextEdit30: TcxTextEdit;
    cxTextEdit31: TcxTextEdit;
    cxTextEdit32: TcxTextEdit;
    cxTextEdit33: TcxTextEdit;
    cxTextEdit34: TcxTextEdit;
    cxTextEdit35: TcxTextEdit;
    cxTextEdit36: TcxTextEdit;
    cxTextEdit37: TcxTextEdit;
    cxTextEdit38: TcxTextEdit;
    cxTextEdit39: TcxTextEdit;
    cxTextEdit40: TcxTextEdit;
    cxTextEdit41: TcxTextEdit;
    cxTextEdit42: TcxTextEdit;
    cxTextEdit43: TcxTextEdit;
    cxTextEdit47: TcxTextEdit;
    cxTextEdit48: TcxTextEdit;
    cxTextEdit49: TcxTextEdit;
    EditDate: TcxDateEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    Label19: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    cxTextEdit17: TcxTextEdit;
    cxTextEdit18: TcxTextEdit;
    cxTextEdit19: TcxTextEdit;
    cxTextEdit22: TcxTextEdit;
    cxTextEdit23: TcxTextEdit;
    cxTextEdit24: TcxTextEdit;
    cxTextEdit25: TcxTextEdit;
    cxTextEdit26: TcxTextEdit;
    cxTextEdit27: TcxTextEdit;
    cxTextEdit28: TcxTextEdit;
    Label43: TLabel;
    cxTextEdit57: TcxTextEdit;
    Label44: TLabel;
    cxTextEdit58: TcxTextEdit;
    EditPlan: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group4: TdxLayoutGroup;
    EditWarn: TcxTextEdit;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group7: TdxLayoutGroup;
    EditSent: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditWC: TcxTextEdit;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditExtID: TcxTextEdit;
    dxLayoutControl1Item9: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    Label1: TLabel;
    cxTextEdit2: TcxTextEdit;
    Label2: TLabel;
    Label3: TLabel;
    cxTextEdit3: TcxTextEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cxTextEdit4: TcxTextEdit;
    cxTextEdit5: TcxTextEdit;
    cxTextEdit6: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStockPropertiesEditValueChanged(Sender: TObject);
    procedure cxTextEdit17KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FListA: TStrings;
    FRecordID,FExtID: string;
    //��ͬ���
    FPrefixID,FExtPrefixID: string;
    //ǰ׺���
    FIDLength,FExtIDLength: integer;
    //ǰ׺����
    procedure InitFormData(const nID: string);
    //��������
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //���ݴ���
  public
    { Public declarations }
  end;

function ShowStockRecordAddForm: Boolean;
function ShowStockRecordEditForm(const nID: string): Boolean;
procedure ShowStockRecordViewForm(const nID: string);
procedure CloseStockRecordForm;
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysDB, USysConst, UDataReport;

var
  gForm: TfFormHYRecord = nil;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
//Desc: ���
function ShowStockRecordAddForm: Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := '';
    Caption := '�����¼ - ���';

    InitFormData('');
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: �޸�
function ShowStockRecordEditForm(const nID: string): Boolean;
begin
  with TfFormHYRecord.Create(Application) do
  begin
    FRecordID := nID;
    Caption := '�����¼ - �޸�';

    InitFormData(nID);
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: �鿴
procedure ShowStockRecordViewForm(const nID: string);
begin
  if not Assigned(gForm) then
  begin
    gForm := TfFormHYRecord.Create(Application);
    gForm.Caption := '�����¼ - �鿴';
    gForm.FormStyle := fsStayOnTop;
    gForm.BtnOK.Visible := False;
  end;

  with gForm  do
  begin
    FRecordID := nID;
    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure CloseStockRecordForm;
begin
  FreeAndNil(gForm);
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  ResetHintAllForm(Self, 'E', sTable_StockRecord);
  //���ñ�����

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'SN');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);

    FExtID       := '';
    FExtPrefixID := nIni.ReadString(Name, 'ExtIDPrefix', 'EN');
    FExtIDLength := nIni.ReadInteger(Name, 'ExtIDLength', 8);
  finally
    nIni.Free;
  end;

  FListA := TStringList.Create;
end;

procedure TfFormHYRecord.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  FListA.Free;
  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormHYRecord.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormHYRecord.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end else

  if Key = VK_DOWN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end else

  if Key = VK_UP then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 1, 0);
  end;
end;

procedure TfFormHYRecord.cxTextEdit17KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormHYRecord.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditDate then nData := DateTime2Str(EditDate.Date);
end;

function TfFormHYRecord.SetData(Sender: TObject; const nData: string): Boolean;
begin
  if Sender = EditDate then
  begin
    EditDate.Date := Str2DateTime(nData);
    Result := True;
  end else Result := False;
end;

//Date: 2009-6-2
//Parm: ��¼���
//Desc: ����nID��Ӧ�̵���Ϣ������
procedure TfFormHYRecord.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Now;
  EditMan.Text := gSysParam.FUserID;
  
  if EditStock.Properties.Items.Count < 1 then
  begin
    nStr := 'Select P_ID,P_QLevel,P_Stock From %s';
    nStr := Format(nStr, [sTable_StockParam]);
    //����ǿ�ȵȼ�����

    with FDM.QueryTemp(nStr) do
    if RecordCount>0 then
    begin
      First;

      while not Eof do
      begin
        FListA.Values[Fields[0].AsString + '_Group'] := Fields[1].AsString;
        FListA.Values[Fields[0].AsString + '_Name'] := Fields[2].AsString;
        Next;
      end;
    end;
    //�����Ӧ��ϵ

    nStr := 'P_ID=' + nStr;
    FDM.FillStringsData(EditStock.Properties.Items, nStr, -1, '��');
    AdjustStringsItem(EditStock.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s sr ' +
            'inner join %s se on sr.R_ExtID=se.E_ID ' +
            'Where sr.R_ID=%s';
    nStr := Format(nStr, [sTable_StockRecord, sTable_StockRecordExt, nID]);
    LoadDataToForm(FDM.QuerySQL(nStr), Self, '', SetData);

    with FDM.SqlQuery do
    if RecordCount > 0 then
    begin
      FExtID := FieldByName('R_ExtID').ASString;

      EditPlan.Text := Format('%.2f', [FieldByName('E_Plan').AsFloat]);
      EditWarn.Text := Format('%.2f', [FieldByName('E_Warn').AsFloat]);
      EditWC.Text   := Format('%.2f', [FieldByName('E_WCValue').AsFloat]);
      EditSent.Text := Format('%.2f', [FieldByName('E_Sent').AsFloat]);
    end;
  end;
end;

//Desc: ��������
procedure TfFormHYRecord.EditStockPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  if FRecordID = '' then
  begin
    nStr := 'Select * From %s Where R_PID=''%s''';
    nStr := Format(nStr, [sTable_StockParamExt, GetCtrlData(EditStock)]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), wPanel);
  end;

  nStr := 'Select P_Stock From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_StockParam, GetCtrlData(EditStock)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       nStr := GetPinYinOfStr(Fields[0].AsString)
  else nStr := '';                                    

  if Pos('kzf', nStr) > 0 then //������
  begin
    Label24.Caption := '�ܶ�g/cm:';
    Label19.Caption := '�����ȱ�:';
    Label22.Caption := '�� ˮ ��:';
    //Label21.Caption := 'ʯ�����:';
    //Label34.Caption := '�� ĥ ��:';
    Label18.Caption := '7�����ָ��:';
    Label26.Caption := '28�����ָ��:';
  end else
  begin
    Label24.Caption := '�� �� þ:';
    Label19.Caption := '�� �� ��:';
    Label22.Caption := 'ϸ    ��:';
    //Label21.Caption := '��    ��:';
    //Label34.Caption := '�� �� ��:';
    Label18.Caption := '3�쿹��ǿ��:';
    Label26.Caption := '28�쿹��ǿ��:';
  end;
end;

//Desc: ����������
procedure TfFormHYRecord.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := FDM.GetSerialID(FPrefixID, sTable_StockRecord, 'R_SerialNo');
end;

//Desc: ��������
procedure TfFormHYRecord.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    nPlan, nWarn, nSent, nWCValue: Double;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('����д��Ч��ˮ����', sHint); Exit;
  end;

  if EditStock.ItemIndex < 0 then
  begin
    EditStock.SetFocus;
    ShowMsg('����д��Ч��Ʒ��', sHint); Exit;
  end;

  nPlan := Float2Float(StrToFloatDef(EditPlan.Text, 3000), cPrecision, False);
  nWarn := Float2Float(StrToFloatDef(EditWarn.Text, 0), cPrecision);
  nWCValue := Float2Float(StrToFloatDef(EditWC.Text, 0), cPrecision);
  nSent := Float2Float(StrToFloatDef(EditSent.Text, 0), cPrecision);

  FDM.ADOConn.BeginTrans;
  try
    if FExtID = '' then
    begin
      FExtID := FDM.GetSerialID(FExtPrefixID, sTable_StockRecordExt, 'E_ID');

      nSQL := MakeSQLByStr([SF('E_ID', FExtID),
              SF('E_Group', FListA.Values[GetCtrlData(EditStock) + '_Group']),
              SF('E_Name', FListA.Values[GetCtrlData(EditStock)+'_Name']),
              SF('E_Stock', GetCtrlData(EditStock)),
              SF('E_Plan', FloatToStr(nPlan), sfVal),
              SF('E_Warn', FloatToStr(nWarn), sfVal),
              SF('E_Freeze', '0', sfVal),
              SF('E_WCValue', FloatToStr(nWCValue), sfVal),
              SF('E_Sent', FloatToStr(nSent), sfVal)
              ], sTable_StockRecordExt, '', True);
    end else

    begin
      nStr := 'E_ID=''' + FExtID + '''';
      nSQL := MakeSQLByStr([
              SF('E_Group', FListA.Values[GetCtrlData(EditStock) + '_Group']),
              SF('E_Name', FListA.Values[GetCtrlData(EditStock)+'_Name']),
              SF('E_Stock', GetCtrlData(EditStock)),
              SF('E_Plan', FloatToStr(nPlan), sfVal),
              SF('E_Warn', FloatToStr(nWarn), sfVal),
              SF('E_WCValue', FloatToStr(nWCValue), sfVal),
              SF('E_Sent', FloatToStr(nSent), sfVal)
              ], sTable_StockRecordExt, nStr, False);
    end;
    FDM.ExecuteSQL(nSQL);
    //xxxxx

    EditExtID.Text := FExtID;
    if FRecordID = '' then
    begin
      nStr := 'Select Count(*) From %s Where R_SerialNo=''%s'' ' +
              'and Year(R_Date)>=Year(GetDate())';
      nStr := Format(nStr, [sTable_StockRecord, EditID.Text]);
      //��ѯ����Ƿ����

      with FDM.QueryTemp(nStr) do
      if Fields[0].AsInteger > 0 then
      begin
        EditID.SetFocus;
        ShowMsg('�ñ�ŵļ�¼�Ѿ�����', sHint); Exit;
      end;

      nSQL := MakeSQLByForm(Self, sTable_StockRecord, '', True, GetData);
    end else
    begin
      EditID.Text := FRecordID;
      nStr := 'R_ID=''' + FRecordID + '''';
      nSQL := MakeSQLByForm(Self, sTable_StockRecord, nStr, False, GetData);
    end;
    FDM.ExecuteSQL(nSQL);
    //xxxxx

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��,δ֪����', sHint);
  end;
end;

end.
