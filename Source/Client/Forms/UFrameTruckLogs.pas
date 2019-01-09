{*******************************************************************************
  作者: fendou116688@163.com 2015/12/13
  描述: 车辆装载登记管理
*******************************************************************************}
unit UFrameTruckLogs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus, cxDropDownEdit,
  dxSkinscxPCPainter, dxLayoutcxEditAdapters;

type
  TfFrameTruckLogs = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ToolButton1: TToolButton;
    dxLayout1Item7: TdxLayoutItem;
    EditType: TcxComboBox;
    Editflag: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditflagPropertiesChange(Sender: TObject);
  private
    { Private declarations }
     FStart,FEnd: TDate;
    //时间区间
    FUseDate: Boolean;
    //使用区间
    FSql: string;
  protected
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, USysConst, USysDB, UDataModule, UFormBase,
  UFormDateFilter, UAdjustForm;

class function TfFrameTruckLogs.FrameID: integer;
begin
  Result := cFI_FrameTruckLogs;
end;

function TfFrameTruckLogs.InitFormDataSQL(const nWhere: string): string;
var nStr, nType, nFlag: string;
begin
  if Pos('S', GetCtrlData(EditType))>0 then
        nType := sFlag_Sale
  else
  if Pos('P', GetCtrlData(EditType))>0 then
        nType := sFlag_Provide
  else  nType :='';

  if Pos('Y', GetCtrlData(Editflag))>0 then
        nFlag := sFlag_CusZY
  else  nFlag := sFlag_CusZYF;

  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if nType = sFlag_Provide then
  begin
    Result := 'Select ROW_NUMBER() over (Order By tl.L_OutFact) As RowID, '+
              'tl.*,tc.* From $TLOG tl ' +
              'Left Join $TRUCK tc on tl.L_Truck= tc.T_Truck '+
              'left join P_OrderDtl od on od.D_ID=tl.L_BID ';

    if (nWhere = '') or FUseDate then
    begin
      Result := Result + 'Where (tl.L_OutFact>=''$ST'' and tl.L_OutFact <''$End'') And od.d_ProType=''$ZY''';
      nStr := ' And ';
    end else nStr := ' Where ';

  end
  else
  if nType = sFlag_Sale then
  begin
    Result := 'Select ROW_NUMBER() over (Order By tl.L_OutFact) As RowID, '+
              'tl.*,tc.* From $TLOG tl ' +
              'Left Join $TRUCK tc on tl.L_Truck= tc.T_Truck '+
              'left join S_Bill sb on L_ID=tl.L_BID ';

    if (nWhere = '') or FUseDate then
    begin
      Result := Result + 'Where (tl.L_OutFact>=''$ST'' and tl.L_OutFact <''$End'') And l_custype=''$ZY''';
      nStr := ' And ';
    end else nStr := ' Where ';

  end
  else
  begin
    Result := 'Select ROW_NUMBER() over (Order By tl.L_OutFact) As RowID, '+
              'tl.*,tc.* From $TLOG tl ' +
              'Left Join $TRUCK tc on tl.L_Truck= tc.T_Truck ';

    if (nWhere = '') or FUseDate then
    begin
      Result := Result + 'Where (tl.L_OutFact>=''$ST'' and tl.L_OutFact <''$End'')';
      nStr := ' And ';
    end else nStr := ' Where ';
  end;

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$TLOG', sTable_TruckLog),
            MI('$TRUCK', sTable_Truck),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
            MI('$ZY', nFlag)]);

  Result := Result + ' Order By RowID';
  FSql := Result;
end;

procedure TfFrameTruckLogs.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruckLogs.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 添加
procedure TfFrameTruckLogs.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormTrucks, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameTruckLogs.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    CreateBaseFormItem(cFI_FormTrucks, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: 删除
procedure TfFrameTruckLogs.BtnDelClick(Sender: TObject);
var nStr,nTruck,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStr   := Format('确定要删除车辆[ %s ]吗?', [nTruck]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);

    nEvent := '删除[ %s ]档案信息.';
    nEvent := Format(nEvent, [nTruck]);
    FDM.WriteSysLog(sFlag_CommonItem, nTruck, nEvent);

    InitFormData(FWhere);
  end;
end;

//Desc: 查询
procedure TfFrameTruckLogs.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('T_Truck Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameTruckLogs.ToolButton1Click(Sender: TObject);
var nWhere, nType, nFlag: string;
begin
  PrintTruckLog(FStart,FSql);
end;

procedure TfFrameTruckLogs.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

procedure TfFrameTruckLogs.EditflagPropertiesChange(Sender: TObject);
var nType, nFlag: string;
begin
  inherited;
  InitFormData(FWhere);
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckLogs, TfFrameTruckLogs.FrameID);
end.
