{*******************************************************************************
����: fendou116688@163.com 2015/11/26
����: �ͻ��������ϸ��ѯ
*******************************************************************************}
unit UFrameTransInOutMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameTransInOutMoney = class(TfFrameNormal)
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
  protected
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter;

class function TfFrameTransInOutMoney.FrameID: integer;
begin
  Result := cFI_FrameTransInOutMoney;
end;

procedure TfFrameTransInOutMoney.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTransInOutMoney.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameTransInOutMoney.BtnExitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

function TfFrameTransInOutMoney.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select iom.*,S_Name From $IOM iom ' +
            ' Left Join $SM sm On sm.S_ID=iom.M_SaleMan ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where (M_Date>=''$Start'' And M_Date<''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';
  
  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$IOM', sTable_TransInOutMoney),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ����ɸѡ
procedure TfFrameTransInOutMoney.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: ִ�в�ѯ
procedure TfFrameTransInOutMoney.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCustomer then
  begin
    FWhere := 'M_CusID like ''%%%s%%'' Or M_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTransInOutMoney, TfFrameTransInOutMoney.FrameID);
end.
