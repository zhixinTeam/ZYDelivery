{*******************************************************************************
  作者: fendou116688@163.com 2016-03-29
  描述: 开单入口
*******************************************************************************}
unit UFormRefundNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxMemo, cxTextEdit,
  dxLayoutControl, StdCtrls;

type
  TfFormNewRefund = class(TfFormNormal)
    EditID: TcxTextEdit;
    dxlytmLayout1Item4: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxlytmLayout1Item5: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FCardData: string;
    //卡片信息
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormWait, UFormBase, USysBusiness, USysConst;

class function TfFormNewRefund.FormID: integer;
begin
  Result := cFI_FormRefundNew;
end;

class function TfFormNewRefund.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  with TfFormNewRefund.Create(Application) do
  try
    Caption := '创建销售退购单';
    ActiveControl := EditID;
    
    if Assigned(nP) then
    begin
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      nP.FParamB := FCardData;
    end else ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormNewRefund.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if Sender = EditID then
    begin
      BtnOKClick(nil);
    end;
  end;
end;

procedure TfFormNewRefund.BtnOKClick(Sender: TObject);
begin
  BtnOK.Enabled := False;
  try
    EditMemo.Clear;
    EditID.Text := Trim(EditID.Text);
    
    if EditID.Text = '' then
    begin
      ShowMsg('请输入单据号', sHint);
      Exit;
    end;

    ShowWaitForm(Self, '正在读取单据');
    FCardData := EditID.Text;

    if ReadBillInfo(FCardData) then
         ModalResult := mrOk
    else EditMemo.Text := FCardData;
  finally
    CloseWaitForm;
    //xxxxx

    if ModalResult <> mrOk then
    begin
      BtnOK.Enabled := True;
      EditID.SetFocus;
      EditID.SelectAll;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormNewRefund, TfFormNewRefund.FormID);
end.
