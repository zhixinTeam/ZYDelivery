{*******************************************************************************
  ����: dmzn@163.com 2018-01-30
  ����: ����ϵͳ����
*******************************************************************************}
unit UFormClearData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxMemo;

type
  TfFormClearData = class(TfFormNormal)
    MemoLog: TcxMemo;
    dxLayout1Item3: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDBName: string;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormCtrl, UFormConn,
  USysDB, USysConst;

class function TfFormClearData.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormClearData.Create(Application) do
  begin
    ShowModal;
    Free;
  end;
end;

class function TfFormClearData.FormID: integer;
begin
  Result := cFI_FormDataClear;
end;

procedure TfFormClearData.FormCreate(Sender: TObject);
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);
    FDBName := Trim(nList.Values[sConn_Key_DBCatalog]);
    if FDBName = '' then FDBName := 'ZYDelivery';
  finally
    nList.Free;
  end;   
end;

procedure TfFormClearData.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  nStr := '�ò�������ʼ��ȫ������,���Ҳ��ɳ���.' + #13#10 +
          'ȷ��Ҫ������?';
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    BtnOK.Enabled := False;
    MemoLog.Text := '1�������ʽ�ʣ����,��ʣ����ӵ��ڳ������.';
    Application.ProcessMessages;

    nStr := 'Update %s Set A_BeginBalance=A_InMoney+A_RefundMoney-A_OutMoney-' +
      'A_FreezeMoney-A_CardUseMoney,A_InMoney=0, A_RefundMoney=0, A_OutMoney=0,' +
      'A_FreezeMoney=0, A_CardUseMoney=0';
    nStr := Format(nStr, [sTable_CusAccDetail]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_InOutMoney;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('2����������ֽ��ʣ����,��ʣ����ӵ��ڳ������.');
    Application.ProcessMessages;

    nStr := 'Update %s Set I_Money=I_Money+I_RefundMoney-I_OutMoney-' +
      'I_FreezeMoney-I_BackMoney,I_RefundMoney=0, I_OutMoney=0, ' +
      'I_FreezeMoney=0, I_BackMoney=0';
    nStr := Format(nStr, [sTable_FXZhiKa]);
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('3���˷����.');
    Application.ProcessMessages;

    nStr := 'Update %s Set A_BeginBalance=A_BeginBalance+A_InMoney+' +
      'A_RefundMoney-A_OutMoney-A_Compensation-A_FreezeMoney,A_InMoney=0,' +
      'A_RefundMoney=0, A_OutMoney=0, A_FreezeMoney=0, A_CardUseMoney=0';
    nStr := Format(nStr, [sTable_TransAccount]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_TransInOutMoney;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('4���������.');
    Application.ProcessMessages;

    nStr := 'Update %s Set A_BeginBalance=A_BeginBalance+A_InMoney+' +
      'A_RefundMoney-A_OutMoney- A_Compensation-A_FreezeMoney-A_CardUseMoney,' +
	    'A_InMoney=0, A_RefundMoney=0, A_OutMoney=0, A_Compensation=0,' +
      'A_FreezeMoney=0, A_CardUseMoney=0';
    nStr := Format(nStr, [sTable_CompensateAccount]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_CompensateInOutMoney;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('5����շ�����ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_Bill;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_BillBak;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('6�����ԭ���Ͻ�����ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_OrderDtl;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_OrderDtlBak;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('7����չ�����ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_PoundLog;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_PoundBak;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('8�����ó��ֽ����ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_MYZhiKa;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('9������˻���ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_Refund;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_RefundBak;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('10-11����ջ��鵥��ϸ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_StockHuaYan;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_StockRecord;
    FDM.ExecuteSQL(nStr);

    nStr := 'Drop Table ' + sTable_StockRecordExt;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('12������˷�Э��.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_TransContract;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('13�����ץ��ͼƬ.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_Picture;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('14��ɾ���γ��ǼǱ�.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_TruckLog;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('15��ɾ��ϵͳ�¼���־.');
    Application.ProcessMessages;

    nStr := 'Drop Table ' + sTable_SysLog;
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    MemoLog.Lines.Add('16���ָ�ʣ�ั�����.');
    Application.ProcessMessages;

    nStr := 'Update %s Set A_CardUseMoney=CardMoney, A_BeginBalance=' +
      'A_BeginBalance+CardMoney From (Select Sum(I_Money) As CardMoney,' +
      'I_Customer,I_Paytype From S_FXZhiKa Group By I_Customer, I_PayType) b ' +
      'Where A_Type=b.I_Paytype And A_CID=b.I_Customer';
    nStr := Format(nStr, [sTable_CusAccDetail]);
    FDM.ExecuteSQL(nStr);

    //--------------------------------------------------------------------------
    FDM.ADOConn.CommitTrans;
    MemoLog.Lines.Add('17����ʼ����Ӳ�̿ռ�.');
    Application.ProcessMessages;

    nStr := 'DBCC SHRINKDATABASE(''%s'', 10)';
    nStr := Format(nStr, [FDBName]);
    FDM.ExecuteSQL(nStr);

    MemoLog.Lines.Add('18�������µ�¼�ͻ���.');
    ShowMsg('�������', sHint);
    ShowDlg('�뾡���¼�ͻ��������ϵͳ��ʼ��.', sHint, Handle);
  except
    on nErr: Exception do
    begin
      BtnOK.Enabled := True;
      FDM.ADOConn.RollbackTrans;
      ShowDlg(nErr.Message, sHint);
    end;
  end;   
end;

initialization
  gControlManager.RegCtrl(TfFormClearData, TfFormClearData.FormID);
end.
