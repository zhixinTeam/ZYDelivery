{*******************************************************************************
  作者: fendou116688@163.com 2015/12/20
  描述: 关联工厂订单
*******************************************************************************}
unit UFormFactZhiKaBind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxMaskEdit, cxButtonEdit;

type
  TfFormFactZhiKaBind = class(TfFormNormal)
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditOwnZhiKa: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditFactZhiKa: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure EditOwnZhiKaPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    FParam: PFormCommandParam;
    procedure InitFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB;

class function TfFormFactZhiKaBind.FormID: integer;
begin
  Result := cFI_FormFactZhiKaBind;
end;

class function TfFormFactZhiKaBind.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  with TfFormFactZhiKaBind.Create(Application) do
  try
    FParam := nP;
    InitFormData;

    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA := ShowModal;
  finally
    if not Assigned(nParam) then Dispose(nP); 
    Free;
  end;
end;

procedure TfFormFactZhiKaBind.InitFormData;
begin
  ActiveControl := EditFactZhiKa;
end;


procedure TfFormFactZhiKaBind.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end else OnCtrlKeyPress(Sender, Key);
end;

//Desc: 保存磁卡
procedure TfFormFactZhiKaBind.BtnOKClick(Sender: TObject);
var nRet: Boolean;
begin
  EditFactZhiKa.Text := Trim(EditFactZhiKa.Text);
  if EditFactZhiKa.Text = '' then
  begin
    ActiveControl := EditFactZhiKa;
    EditFactZhiKa.SelectAll;

    ShowMsg('请输入有效工厂订单编号', sHint);
    Exit;
  end;

  nRet := SaveFactZhiKa(Trim(EditOwnZhiKa.Text), Trim(EditFactZhiKa.Text));
  if nRet then
    ModalResult := mrOk;
  //done
end;

procedure TfFormFactZhiKaBind.EditOwnZhiKaPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  inherited;

  if Sender = EditOwnZhiKa then
  begin
    CreateBaseFormItem(cFI_FormGetZhika, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    EditOwnZhiKa.Text := nP.FParamB;
  end else

  if Sender = EditFactZhiKa then
  begin
    CreateBaseFormItem(cFI_FormGetFactZhika, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    EditFactZhiKa.Text := nP.FParamB;
  end;    
end;

initialization
  gControlManager.RegCtrl(TfFormFactZhiKaBind, TfFormFactZhiKaBind.FormID);
end.
