{*******************************************************************************
  ����: dmzn@163.com 2018-01-30
  ����: У���ʽ�
*******************************************************************************}
unit UFormMoneyAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, cxLabel;

type
  TfFormMoneyAdjust = class(TfFormNormal)
    EditID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditBegin: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditIn: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditOut: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditFreeze: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    EditBC: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item13: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayout1Item14: TdxLayoutItem;
    cxLabel4: TcxLabel;
    dxLayout1Item15: TdxLayoutItem;
    cxLabel5: TcxLabel;
    dxLayout1Item17: TdxLayoutItem;
    cxLabel7: TcxLabel;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FRecordID: string;
    //��¼���
    FFormType: Integer;
    //ҵ������
    FMBegin,FMIn,FMOut,FMFreeze,FMBC: Double;
    //��ʼ���
    procedure InitFormData(const nRecord: string);
    //��ʼ��
    procedure AddMoneyChangeLog;
    //�����־
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormCtrl, USysDB, USysConst;

class function TfFormMoneyAdjust.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;
  
  with TfFormMoneyAdjust.Create(Application) do
  begin
    FRecordID := nP.FParamA;
    FFormType := nP.FParamB;

    case FFormType of
     cFI_FrameCusAccountQuery        : Caption := '�ͻ��ʽ�';
     cFI_FrameCompensateAccountQuery : Caption := '�����ʽ�';
     cFI_FrameTransAccountQuery      : Caption := '�˷�';
    end;

    BtnOK.Enabled := False;
    InitFormData(FRecordID);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormMoneyAdjust.FormID: integer;
begin
  Result := cFI_FormMoneyAdjust;
end;

procedure TfFormMoneyAdjust.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

end;

//------------------------------------------------------------------------------
//Desc: ��ȡ����
procedure TfFormMoneyAdjust.InitFormData(const nRecord: string);
var nStr: string;
begin
  if FFormType = cFI_FrameCusAccountQuery then
  begin
    nStr := 'Select a.*,b.C_Name From %s a ' +
            ' Left Join %s b on b.C_ID=a.A_CID ' +
            'Where a.R_ID=%s';
    nStr := Format(nStr, [sTable_CusAccDetail, sTable_Customer, nRecord]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      BtnOK.Enabled := True;
      EditID.Text := FieldByName('A_CID').AsString;
      EditName.Text := FieldByName('C_Name').AsString;

      FMBegin := FieldByName('A_BeginBalance').AsFloat;
      FMIn := FieldByName('A_InMoney').AsFloat;
      FMOut := FieldByName('A_OutMoney').AsFloat;
      FMFreeze := FieldByName('A_FreezeMoney').AsFloat;
      FMBC := FieldByName('A_Compensation').AsFloat;
    end;
  end else

  if FFormType = cFI_FrameCompensateAccountQuery then
  begin
    nStr := 'Select a.*,b.C_Name From %s a ' +
            ' Left Join %s b on b.C_ID=a.A_CID ' +
            'Where a.R_ID=%s';
    nStr := Format(nStr, [sTable_CompensateAccount, sTable_Customer, nRecord]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      BtnOK.Enabled := True;
      EditID.Text := FieldByName('A_CID').AsString;
      EditName.Text := FieldByName('C_Name').AsString;

      FMBegin := FieldByName('A_BeginBalance').AsFloat;
      FMIn := FieldByName('A_InMoney').AsFloat;
      FMOut := FieldByName('A_OutMoney').AsFloat;
      FMFreeze := FieldByName('A_FreezeMoney').AsFloat;
      FMBC := FieldByName('A_Compensation').AsFloat;
    end;
  end else

  if FFormType = cFI_FrameTransAccountQuery then
  begin
    nStr := 'Select a.*,b.C_Name From %s a ' +
            ' Left Join %s b on b.C_ID=a.A_CID ' +
            'Where a.R_ID=%s';
    nStr := Format(nStr, [sTable_TransAccount, sTable_Customer, nRecord]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      BtnOK.Enabled := True;
      EditID.Text := FieldByName('A_CID').AsString;
      EditName.Text := FieldByName('C_Name').AsString;

      FMBegin := FieldByName('A_BeginBalance').AsFloat;
      FMIn := FieldByName('A_InMoney').AsFloat;
      FMOut := FieldByName('A_FreezeMoney').AsFloat;

      FMFreeze := 0;
      EditFreeze.Enabled := False;
      FMBC := 0;
      EditBC.Enabled := False;
    end;
  end;

  if BtnOK.Enabled then
  begin
    ActiveControl := EditBegin;
    EditBegin.Text := Format('%.2f', [FMBegin]);
    EditIn.Text    := Format('%.2f', [FMIn]);
    EditOut.Text   := Format('%.2f', [FMOut]);
    EditFreeze.Text := Format('%.2f', [FMFreeze]);
    EditBC.Text    := Format('%.2f', [FMBC]);
  end else
  begin
    ShowMsg('�ͻ���¼��Ч', sHint);
  end;
end;

procedure TfFormMoneyAdjust.AddMoneyChangeLog;
var nStr: string;
begin
  nStr := '';
  if not FloatRelation(StrToFloat(EditBegin.Text), FMBegin, rtEqual) then
    nStr := nStr + Format('�ڳ�:[%.2f -> %s] ', [FMBegin, EditBegin.Text]);
  //xxxxx

  if not FloatRelation(StrToFloat(EditIn.Text), FMIn, rtEqual) then
    nStr := nStr + Format('���:[%.2f -> %s] ', [FMIn, EditIn.Text]);
  //xxxxx

  if not FloatRelation(StrToFloat(EditOut.Text), FMOut, rtEqual) then
    nStr := nStr + Format('����:[%.2f -> %s] ', [FMOut, EditOut.Text]);
  //xxxxx

  if not FloatRelation(StrToFloat(EditFreeze.Text), FMFreeze, rtEqual) then
    nStr := nStr + Format('����:[%.2f -> %s] ', [FMFreeze, EditFreeze.Text]);
  //xxxxx

  if not FloatRelation(StrToFloat(EditBC.Text), FMBC, rtEqual) then
    nStr := nStr + Format('����:[%.2f -> %s] ', [FMBC, EditBC.Text]);
  //xxxxx

  if nStr <> '' then
  begin
    nStr := Format('�ͻ�:[ %s ] ', [EditName.Text]) + nStr;
    FDM.WriteSysLog(sFlag_Customer, EditID.Text, nStr);
  end;
end;

procedure TfFormMoneyAdjust.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  FDM.ADOConn.BeginTrans;
  try
    if FFormType = cFI_FrameCusAccountQuery then
    begin
      nStr := MakeSQLByStr([SF('A_BeginBalance', EditBegin.Text, sfVal),
        SF('A_InMoney', EditIn.Text, sfVal),
        SF('A_OutMoney', EditOut.Text, sfVal),
        SF('A_FreezeMoney', EditFreeze.Text, sfVal),
        SF('A_Compensation', EditBC.Text, sfVal)
        ], sTable_CusAccDetail, SF('R_ID', FRecordID, sfVal), False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      AddMoneyChangeLog;
    end else

    if FFormType = cFI_FrameCompensateAccountQuery then
    begin
      nStr := MakeSQLByStr([SF('A_BeginBalance', EditBegin.Text, sfVal),
        SF('A_InMoney', EditIn.Text, sfVal),
        SF('A_OutMoney', EditOut.Text, sfVal),
        SF('A_FreezeMoney', EditFreeze.Text, sfVal),
        SF('A_Compensation', EditBC.Text, sfVal)
        ], sTable_CompensateAccount, SF('R_ID', FRecordID, sfVal), False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      AddMoneyChangeLog;
    end else

    if FFormType = cFI_FrameTransAccountQuery then
    begin
      nStr := MakeSQLByStr([SF('A_BeginBalance', EditBegin.Text, sfVal),
        SF('A_InMoney', EditIn.Text, sfVal),
        SF('A_FreezeMoney', EditOut.Text, sfVal)
        ], sTable_TransAccount, SF('R_ID', FRecordID, sfVal), False);
      //xxxxx

      FDM.ExecuteSQL(nStr);
      AddMoneyChangeLog;
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
  except
    FDM.ADOConn.RollbackTrans;
  end;   
end;

initialization
  gControlManager.RegCtrl(TfFormMoneyAdjust, TfFormMoneyAdjust.FormID);
end.
