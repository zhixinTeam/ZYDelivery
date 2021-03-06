{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 系统业务处理
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, UBusinessPacker, UBusinessWorker,
  UBusinessConst, ULibFun, UAdjustForm, UFormCtrl, UDataModule, UDataReport,
  UFormBase, cxMCListBox, UMgrPoundTunnels, USysConst, HKVNetSDK, Forms,
  USysDB, USysLoger, ADODB, Grids, Clipbrd, ComObj, Dialogs, Messages;

type
  TLadingStockItem = record
    FID: string;         //编号
    FType: string;       //类型
    FName: string;       //名称
    FParam: string;      //扩展
  end;

  TDynamicStockItemArray = array of TLadingStockItem;
  //系统可用的品种列表

  PZTLineItem = ^TZTLineItem;
  TZTLineItem = record
    FID       : string;      //编号
    FName     : string;      //名称
    FStock    : string;      //品名
    FWeight   : Integer;     //袋重
    FValid    : Boolean;     //是否有效
    FPrinterOK: Boolean;     //喷码机
  end;

  PZTTruckItem = ^TZTTruckItem;
  TZTTruckItem = record
    FTruck    : string;      //车牌号
    FLine     : string;      //通道
    FBill     : string;      //提货单
    FValue    : Double;      //提货量
    FDai      : Integer;     //袋数
    FTotal    : Integer;     //总数
    FInFact   : Boolean;     //是否进厂
    FIsRun    : Boolean;     //是否运行    
  end;

  TZTLineItems = array of TZTLineItem;
  TZTTruckItems = array of TZTTruckItem;
  
//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//调整提示内容
function WorkPCHasPopedom: Boolean;
//验证主机是否已授权
function GetSysValidDate: Integer;
//获取系统有效期
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//获取串行编号
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
//可用品种列表
function GetCardUsed(const nCard: string): string;
//获取卡片类型

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//读取系统字典项
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取业务员列表
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取客户列表
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string; const nUseBackdb: Boolean=False): TDataSet;
//载入客户信息
function LoadContractInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//载入合同信息 

function IsZhiKaNeedVerify: Boolean;
//订单是否需要审核
function IsPrintZK: Boolean;
//是否打印订单
//function DeleteZhiKa(const nZID: string): Boolean;
//删除指定订单
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string; nZType: string='S'): TDataset;
function LoadCardInfo(const nCard: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//载入订单
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean;
 nZKType: string='S'): Double;
//订单可用金
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean = True;
 const nCredit: PDouble = nil): Double;
//客户可用金额
function GetTransportValidMoney(nCID: string; const nLimit: Boolean = True;
 const nCredit: PDouble = nil): Double;
//运费可用金额
function GetCustomerCompensateMoney(nCID: string): Double;
//返利金额

function SyncRemoteCustomer: Boolean;
//同步远程用户
function SyncRemoteSaleMan: Boolean;
//同步远程业务员
function SyncRemoteProviders: Boolean;
//同步远程用户
function SyncRemoteMeterails: Boolean;
//同步远程业务员
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
//存临时客户
function IsAutoPayCredit: Boolean;
//回款时冲信用
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean = True; const nTransAccount: Boolean=False): Boolean;
//保存回款记录
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime; const nTransCredit: Boolean=False;
 const nType: string= ''): Boolean;
//保存信用记录
function SaveCustomerFLPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nMemo: string; const nMoney: Double): Boolean;
function IsCustomerCreditValid(const nCusID: string): Boolean;
//客户信用是否有效
function DeleteCustomerPayment(const nRID: string;
  const nTransAccount: Boolean): Boolean;
//删除回款记录

function IsStockValid(const nStocks: string): Boolean;
//品种是否可以发货
function SaveZhiKa(const nZhiKaData: string): string;
//保存纸卡(订单)
function DeleteZhiKa(const nZhiKa: string): Boolean;
//删除纸卡(订单)
function SaveFLZhiKa(const nZhiKaData: string): string;
//保存纸卡(订单)
function DeleteFLZhiKa(const nZhiKa: string): Boolean;
//删除纸卡(订单)
function SaveICCardInfo(const nZID: string; const nZType: string='S';
  const nCardType: string='V'):Boolean;
function DeleteICCardInfo(const nCard: string; const nZID: string=''):Boolean;
function SaveBill(const nBillData: string): string;
//保存交货单
function DeleteBill(const nBill: string): Boolean;
//删除交货单
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
//更改提货车辆
function ChangeLadingValue(const nBill,nValue: string): Boolean;
//更改提货量
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
//交货单调拨
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//为交货单办理磁卡
function SaveBillCard(const nBill, nCard: string): Boolean;
//保存交货单磁卡
function LogoutBillCard(const nCard: string): Boolean;
//注销指定磁卡
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
//载入单据信息到列表
function ReadBillInfo(var nBillInfo: string):Boolean;
//读取提货单信息

function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
//获取指定车辆的已称皮重信息
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
//保存车辆过磅记录
function ReadPoundCard(const nTunnel: string): string;
//读取指定磅站读头上的卡号
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
//抓拍指定通道

function SaveOrderBase(const nOrderData: string): string;
//保存采购申请单
function DeleteOrderBase(const nOrder: string): Boolean;
//删除采购申请单
function SaveOrder(const nOrderData: string): string;
//保存采购单
function DeleteOrder(const nOrder: string): Boolean;
//删除采购单
function SaveOrderDtlAdd(const nOrderData: string; var nHint: string): string;
//function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
////更改提货车辆
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
//为采购单办理磁卡
function SaveOrderCard(const nOrder, nCard: string): Boolean;
//保存采购单磁卡
function LogoutOrderCard(const nCard: string): Boolean;
//注销指定磁卡
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
//修改车牌号

function SaveRefund(const nRefundData: string): string;
//保存退购单
function DeleteRefund(const nRefund: string): Boolean;
//删除退购单
function ChangeRefundTruckNo(const nRefund,nTruck: string): Boolean;
//更改退购车辆
function SetRefundCard(const nRefund,nTruck: string; nVerify: Boolean): Boolean;
//为退购单办理磁卡
function SaveRefundCard(const nRefund, nCard: string): Boolean;
//保存退购单磁卡

function GetPostItems(const nCard,nPost: string;
 var nItems: TLadingBillItems): Boolean;
//获取岗位订单信息
function SavePostItems(const nPost: string; const nItems: TLadingBillItems;
 const nTunnel: PPTTunnelItem=nil): Boolean;
//保存岗位订单信息

procedure LoadOrderBaseToMC(const nItem: TStrings; const nMC: TStrings;
 const nDelimiter: string);

function GetStockBatcode(const nStock: string;
 const nBrand: string=''; const nValue: Double=0; const nBatch: string=''): string;
//获取当前物料品种批次号

function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//读取车辆队列
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//启停喷码机
function ChangeDispatchMode(const nMode: Byte): Boolean;
//切换调度模式

function GetHYMaxValue: Double;
//获取化验单已开量
function GetHYValueByStockNo(const nNo: string): Double;
//获取nNo水泥编号的已开量

function GetICCardInfo(var nCardNO: string; const nPassword: string=''):Boolean;
//获取IC卡信息

function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
//保存用户补偿金

function SaveFactZhiKa(const nZhiKa: string; const nFactZhiKa: string): Boolean;
//绑定工厂订单编号

//------------------------------------------------------------------------------
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
//打印合同
procedure PrintTransContractReport(const nID: string; const nAsk: Boolean);
//打印运费协议
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
//打印订单
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
//打印收据
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
//打印提货单
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
//打印榜单
function PrintOrderReport(const nOrder: string; const nAsk: Boolean): Boolean;
//打印材料单据
function PrintRefundReport(nRefund: string; const nAsk: Boolean): Boolean;
//打印退购单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
//化验单,合格证
procedure PrintTruckLog(const nStart:TDate; nWhere: string='');
//打印车辆登记表
procedure PrintTruckJieSuan(nWhere: string='');
//打印司机运费结算单

//function PrintSealReport(nQuery: TADOQuery): Boolean;
function PrintSealReport(const nSeal: string; const FStart,
  FEnd: TDateTime): Boolean;

function SmallTOBig(small: real): string;
//金额转换大写
procedure SelectAllOfGrid(nStringGrid: TStringGrid);
function StringGridSelectText(nStringGrid: TStringGrid): string;
procedure StringGridPasteFromClipboard(nStringGrid: TStringGrid);
procedure StringGridCopyToClipboard(nStringGrid: TStringGrid);
procedure StringGridExportToExcel(nStringGrid: TStringGrid; nFile: string='123');
function StringGridPrintPreview(const nGrid: TStringGrid; const nTitle: string): Boolean;
function StringGridPrintData(const nGrid: TStringGrid; const nTitle: string): Boolean;
//StringGrid操作


implementation

//Desc: 记录日志
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//------------------------------------------------------------------------------
//Desc: 调整nHint为易读的格式
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '※.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
//金额转换为大写
function SmallTOBig(small: real): string;
var
  SmallMonth, BigMonth: string;
  wei1, qianwei1: string[2];
  qianwei, dianweizhi, qian: integer;
  fs_bj: boolean;
begin
  if small < 0 then
    fs_bj := True
  else
    fs_bj := False;
  small      := abs(small);
  {------- 修改参数令值更精确 -------}
  {小数点后的位置，需要的话也可以改动-2值}
  qianwei    := -2;
  {转换成货币形式，需要的话小数点后加多几个零}
  Smallmonth := formatfloat('0.00', small);
  {---------------------------------}
  dianweizhi := pos('.', Smallmonth);{小数点的位置}
  {循环小写货币的每一位，从小写的右边位置到左边}
  for qian := length(Smallmonth) downto 1 do
  begin
    {如果读到的不是小数点就继续}
    if qian <> dianweizhi then
    begin
      {位置上的数转换成大写}
      case StrToInt(Smallmonth[qian]) of
        1: wei1 := '壹';
        2: wei1 := '贰';
        3: wei1 := '叁';
        4: wei1 := '肆';
        5: wei1 := '伍';
        6: wei1 := '陆';
        7: wei1 := '柒';
        8: wei1 := '捌';
        9: wei1 := '玖';
        0: wei1 := '零';
      end;
      {判断大写位置，可以继续增大到real类型的最大值}
      case qianwei of
        -3: qianwei1 := '厘';
        -2: qianwei1 := '分';
        -1: qianwei1 := '角';
        0: qianwei1  := '元';
        1: qianwei1  := '拾';
        2: qianwei1  := '佰';
        3: qianwei1  := '仟';
        4: qianwei1  := '万';
        5: qianwei1  := '拾';
        6: qianwei1  := '佰';
        7: qianwei1  := '仟';
        8: qianwei1  := '亿';
        9: qianwei1  := '拾';
        10: qianwei1 := '佰';
        11: qianwei1 := '仟';
      end;
      inc(qianwei);
      BigMonth := wei1 + qianwei1 + BigMonth;{组合成大写金额}
    end;
  end;

  BigMonth := StringReplace(BigMonth, '零拾', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零佰', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零仟', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零角零分', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零角', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零分', '', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零零', '零', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零亿', '亿', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零万', '万', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '零元', '元', [rfReplaceAll]);
  BigMonth := StringReplace(BigMonth, '亿万', '亿', [rfReplaceAll]);
  BigMonth := BigMonth + '整';
  BigMonth := StringReplace(BigMonth, '分整', '分', [rfReplaceAll]);

  if BigMonth = '元整' then
    BigMonth := '零元整';
  if copy(BigMonth, 1, 2) = '元' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if copy(BigMonth, 1, 2) = '零' then
    BigMonth := copy(BigMonth, 3, length(BigMonth) - 2);
  if fs_bj = True then
    SmallTOBig := '- ' + BigMonth
  else
    SmallTOBig := BigMonth;
end;

//Desc: 验证主机是否已授权接入系统
function WorkPCHasPopedom: Boolean;
begin
  Result := gSysParam.FSerialID <> '';
  if not Result then
  begin
    ShowDlg('该功能需要更高权限,请向管理员申请.', sHint);
  end;
end;

//Date: 2014-09-05
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的业务命令对象
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessSaleBill);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessPurchaseOrder);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售退购单据对象
function CallBusinessRefund(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessRefund);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-10-01
//Parm: 命令;数据;参数;输出
//Desc: 调用中间件上的销售单据对象
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //自动称重时不提示
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-04
//Parm: 分组;对象;使用日期编码模式
//Desc: 依据nGroup.nObject生成串行编号
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    nList.Free;
  end;   
end;

//Desc: 获取系统有效期
function GetSysValidDate: Integer;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_IsSystemExpired, '', '', @nOut) then
       Result := StrToInt(nOut.FData)
  else Result := 0;
end;

function GetCardUsed(const nCard: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

//Desc: 获取当前系统可用的水泥品种列表
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_StockItem)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    SetLength(nItems, RecordCount);
    if RecordCount > 0 then
    begin
      nIdx := 0;
      First;

      while not Eof do
      begin
        nItems[nIdx].FType := FieldByName('D_Memo').AsString;
        nItems[nIdx].FName := FieldByName('D_Value').AsString;
        nItems[nIdx].FID := FieldByName('D_ParamB').AsString;

        Next;
        Inc(nIdx);
      end;
    end;
  end;

  Result := Length(nItems) > 0;
end;

//------------------------------------------------------------------------------
//Date: 2014-06-19
//Parm: 记录标识;车牌号;图片文件
//Desc: 将nFile存入数据库
procedure SavePicture(const nID, nTruck, nMate, nFile: string);
var nStr: string;
    nRID: Integer;
begin
  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([
            SF('P_ID', nID),
            SF('P_Name', nTruck),
            SF('P_Mate', nMate),
            SF('P_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Picture, '', True);
    //xxxxx

    if FDM.ExecuteSQL(nStr) < 1 then Exit;
    nRID := FDM.GetFieldMax(sTable_Picture, 'R_ID');

    nStr := 'Select P_Picture From %s Where R_ID=%d';
    nStr := Format(nStr, [sTable_Picture, nRID]);
    FDM.SaveDBImage(FDM.QueryTemp(nStr), 'P_Picture', nFile);

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 构建图片路径
function MakePicName: string;
begin
  while True do
  begin
    Result := gSysParam.FPicPath + IntToStr(gSysParam.FPicBase) + '.jpg';
    if not FileExists(Result) then
    begin
      Inc(gSysParam.FPicBase);
      Exit;
    end;

    DeleteFile(Result);
    if FileExists(Result) then Inc(gSysParam.FPicBase)
  end;
end;

//Date: 2014-06-19
//Parm: 通道;列表
//Desc: 抓拍nTunnel的图像
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
const
  cRetry = 2;
  //重试次数
var nStr: string;
    nIdx,nInt: Integer;
    nLogin,nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  nLogin := -1;
  NET_DVR_Init();
  try
    for nIdx:=1 to cRetry do
    begin
      nLogin := NET_DVR_Login(PChar(nTunnel.FCamera.FHost),
                   nTunnel.FCamera.FPort,
                   PChar(nTunnel.FCamera.FUser),
                   PChar(nTunnel.FCamera.FPwd), @nInfo);
      //to login

      nErr := NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '登录摄像机[ %s.%d ]失败,错误码: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        Exit;
      end;
    end;

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;
      //invalid

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        //file path

        NET_DVR_CaptureJPEGPicture(nLogin, nTunnel.FCameraTunnels[nIdx],
                                   @nPic, PChar(nStr));
        //capture pic

        nErr := NET_DVR_GetLastError;
        if nErr = 0 then
        begin
          nList.Add(nStr);
          Break;
        end;

        if nIdx = cRetry then
        begin
          nStr := '抓拍图像[ %s.%d ]失败,错误码: %d';
          nStr := Format(nStr, [nTunnel.FCamera.FHost,
                   nTunnel.FCameraTunnels[nIdx], nErr]);
          WriteLog(nStr);
        end;
      end;
    end;
  finally
    if nLogin > -1 then
      NET_DVR_Logout(nLogin);
    NET_DVR_Cleanup();
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-4-13
//Parm: 字典项;列表
//Desc: 从SysDict中读取nItem项的内容,存入nList中
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

//Desc: 读取业务员列表到nList中,包含附加数据
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
          'Where IsNull(S_InValid, '''')<>''%s'' %s Order By S_PY';
  nStr := Format(nStr, [sTable_Salesman, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.', DSA(['S_ID']));
  
  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: 读取客户列表到nList中,包含附加数据
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'C_ID=Select C_ID,C_Name From %s ' +
          'Where IsNull(C_XuNi, '''')<>''%s'' %s Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.');

  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: 载入nCID客户的信息到nList中,并返回数据集
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string; const nUseBackdb: Boolean): TDataSet;
var nStr: string;
begin
  nStr := 'Select cus.*,S_Name as C_SaleName From $Cus cus ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          'Where C_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$Cus', sTable_Customer), MI('$ID', nCID),
          MI('$SM', sTable_Salesman)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr, nUseBackdb);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('客户编号:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('企业法人:' + nList.Delimiter + FieldByName('C_FaRen').AsString + ' ');
    Add('联系方式:' + nList.Delimiter + FieldByName('C_Phone').AsString + ' ');
    Add('所属业务员:' + nList.Delimiter + FieldByName('C_SaleName').AsString);
  end else
  begin
    Result := nil;
    nHint := '客户信息已丢失';
  end;
end;

//Desc: 保存nSaleMan名下的nName为临时客户,返回客户号
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
var nID: Integer;
    nStr: string;
    nBool: Boolean;
begin
  nStr := 'Select C_ID From %s ' +
          'Where C_XuNi=''%s'' And C_SaleMan=''%s'' And C_Name=''%s''';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nSaleMan, nName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
    Exit;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into %s(C_Name,C_PY,C_SaleMan,C_XuNi) ' +
            'Values(''%s'',''%s'',''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Customer, nName, GetPinYinOfStr(nName),
            nSaleMan, sFlag_Yes]);
    FDM.ExecuteSQL(nStr);

    nID := FDM.GetFieldMax(sTable_Customer, 'R_ID');
    Result := FDM.GetSerialID2('KH', sTable_Customer, 'R_ID', 'C_ID', nID);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Customer, Result, nID]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := '';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 汇款时冲信用额度
function IsAutoPayCredit: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PayCredit)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: 保存nCusID的一次回款记录
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean; const nTransAccount: Boolean): Boolean;
var nStr, nInOutTable, nAccountTable: string;
    nVal,nLimit: Double;
    nBool: Boolean;
    nInt: Integer;
begin
  Result := False;
  nVal := Float2Float(nMoney, cPrecision, False);
  //adjust float value

  if nTransAccount then
  begin
    nInOutTable  := sTable_TransInOutMoney;
    nAccountTable:= sTable_TransAccount;
  end
  else
  begin
    nInOutTable  := sTable_InOutMoney;
    nAccountTable:= sTable_CusAccDetail;
  end;

  if nVal < 0 then
  begin
    if nTransAccount then
         nLimit := GetTransportValidMoney(nCusID, False)
    else nLimit := GetCustomerValidMoney(nCusID + sFlag_Delimater + nType, False);
    //get money value
    
    if (nLimit <= 0) or (nLimit < -nVal) then
    begin
      nStr := '客户: %s ' + #13#10#13#10 +
              '当前余额为[ %.2f ]元,无法支出[ %.2f ]元.';
      nStr := Format(nStr, [nCusName, nLimit, -nVal]);
      
      ShowDlg(nStr, sHint);
      Exit;
    end;
  end;

  nLimit := 0;
  //no limit

  if nCredit and (nVal > 0) and IsAutoPayCredit then
  begin
    nStr := 'Select A_CreditLimit From %s Where A_CID=''%s''';
    nStr := Format(nStr, [nAccountTable, nCusID]);

    if not nTransAccount then nStr := nStr + ' And A_Type=''' + nType + '''';

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsFloat > 0) then
    begin
      if FloatRelation(nVal, Fields[0].AsFloat, rtGreater) then
           nLimit := Float2Float(Fields[0].AsFloat, cPrecision, False)
      else nLimit := nVal;

      nStr := '客户[ %s ]当前信用额度为[ %.2f ]元,是否冲减?' +
              #32#32#13#10#13#10 + '点击"是"将降低[ %.2f ]元的额度.';
      nStr := Format(nStr, [nCusName, Fields[0].AsFloat, nLimit]);

      if not QueryDlg(nStr, sAsk) then
        nLimit := 0;
      //xxxxx
    end;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    if nTransAccount then
    begin
      nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''';
      nStr := Format(nStr, [nAccountTable, nVal, nCusID]);
      nInt := FDM.ExecuteSQL(nStr);
      if nInt < 1 then
      begin
        nStr := 'Insert Into %s(A_CID,A_InMoney,A_Date) ' +
                'Values(''%s'', %.2f, %s)';
        nStr := Format(nStr, [nAccountTable, nCusID, nVal, FDM.SQLServerNow]);
        FDM.ExecuteSQL(nStr);
      end;
    end else
    begin
      nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''' +
              ' And A_Type=''%s''';
      nStr := Format(nStr, [nAccountTable, nVal, nCusID, nType]);
      nInt := FDM.ExecuteSQL(nStr);
      if nInt < 1 then
      begin
        nStr := 'Insert Into %s(A_CID,A_Type,A_InMoney,A_Date) ' +
                'Values(''%s'', ''%s'', %.2f, %s)';
        nStr := Format(nStr, [nAccountTable, nCusID, nType,
                nVal, FDM.SQLServerNow]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'')';
    nStr := Format(nStr, [nInOutTable, nSaleMan, nCusID, nCusName, nType,
            nPayment, nVal, FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if (nLimit > 0) and (
       not SaveCustomerCredit(nCusID, '回款时冲减', -nLimit, Now,
       nTransAccount, nType)) then
    begin
      nStr := '发生未知错误,导致冲减客户[ %s ]信用操作失败.' + #13#10 +
              '请手动调整该客户信用额度.';
      nStr := Format(nStr, [nCusName]);
      ShowDlg(nStr, sHint);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;


//Desc: 删除回款RID记录
function DeleteCustomerPayment(const nRID: string;
    const nTransAccount: Boolean): Boolean;
var nStr, nCID, nCName, nInOutTable, nAccountTable, nType: string;
    nBool: Boolean;
    nVal: Double;
begin
  Result := False;

  if nTransAccount then
  begin
    nInOutTable  := sTable_TransInOutMoney;
    nAccountTable:= sTable_TransAccount;
  end
  else
  begin
    nInOutTable  := sTable_InOutMoney;
    nAccountTable:= sTable_CusAccDetail;
  end;

  nStr := 'Select M_CusID, M_Type, M_CusName, M_Money From %s Where R_ID=%s';
  nStr := Format(nStr, [nInOutTable, nRID]);
  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := '回款记录 [%s] 不存在.';
      nStr := Format(nStr, [nRID]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nCID := FieldByName('M_CusID').AsString;
    nVal := Float2Float(FieldByName('M_Money').AsFloat, cPrecision, True);
    nType:= FieldByName('M_Type').AsString;
    nCName := FieldByName('M_CusName').AsString;
  end;  

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    if nTransAccount then
    begin
      nStr := 'Update %s Set A_InMoney=A_InMoney-%.2f Where A_CID=''%s''';
      nStr := Format(nStr, [nAccountTable, nVal, nCID]);
      FDM.ExecuteSQL(nStr);
    end  else
    begin
      nStr := 'Update %s Set A_InMoney=A_InMoney-%.2f ' +
              'Where A_CID=''%s'' And A_Type=''%s''';
      nStr := Format(nStr, [nAccountTable, nVal, nCID, nType]);
      FDM.ExecuteSQL(nStr);
    end;     

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [nInOutTable, nRID]);
    FDM.ExecuteSQL(nStr);

    nStr := '删除客户 [%s] 的回款金额 [%.2f 元]';
    nStr := Format(nStr, [nCName, nVal]);
    FDM.WriteSysLog(sFlag_PaymentItem, sFlag_CustomerItem, nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 保存nCusID的一次授信记录
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime; const nTransCredit: Boolean; const nType: string): Boolean;
var nStr, nSaleMan, nCreditTable, nAccountTable: string;
    nVal, nSaleCredit, nUsedCredit: Double;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    if nTransCredit then
    begin
      nCreditTable := sTable_TransCredit;
      nAccountTable:= sTable_TransAccount;
    end
    else
    begin
      nCreditTable := sTable_CusCredit;
      nAccountTable:= sTable_CusAccDetail;
    end;

    nStr := 'Select S_ID, S_Credit From $SM sm, $CM cm ' +
            'Where sm.S_ID=cm.C_SaleMan And C_ID=''$CID''';
    nStr := MacroValue(nStr, [MI('$SM', sTable_Salesman),
            MI('$CM', sTable_Customer), MI('$CID', nCusID)]);
    with FDM.QuerySQL(nStr) do
    if RecordCount>0 then
    begin
      nSaleMan := FieldByName('S_ID').AsString;
      nSaleCredit := FieldByName('S_Credit').AsFloat;
    end else nSaleCredit := 0;

    if nSaleCredit>0 then
    begin
      nStr := 'Select Sum(A_CreditLimit) ' +
              'From $SA sa, $SC sc, $SM sm ' +
              'Where sa.A_CID=sc.C_ID And sc.C_SaleMan=sm.S_ID And S_ID=''$SID''';
      nStr := MacroValue(nStr, [MI('$SA', nAccountTable),
              MI('$SC', sTable_Customer), MI('$SM', sTable_Salesman),
              MI('$SID', nSaleMan)]);
      //xxxxx

      with FDM.QuerySQL(nStr) do
      if RecordCount>0 then
           nUsedCredit := Fields[0].AsFloat
      else nUsedCredit := 0;

      nVal := Float2Float(nUsedCredit + nCredit, cPrecision, True);
      if FloatRelation(nVal, nSaleCredit, rtGreater, cPrecision) then
      begin
        nStr := '当前业务员的可用信用额度不足，详情如下:' + #13#10 +
                '※总信用额度[%.2f]'  + #13#10 +
                '※已用信用额[%.2f]'  + #13#10 +
                '※新申请额度[%.2f]'  + #13#10 +
                '是否保存?';
        nStr := Format(nStr, [nSaleCredit,nUsedCredit, nCredit]);

        if not QueryDlg(nStr, sHint) then
        begin
          Result := False;
          if not nBool then FDM.ADOConn.RollbackTrans;
          Exit;
        end;  
      end;  
    end;

    nVal := Float2Float(nCredit, cPrecision, False);
    //adjust float value

    nStr := 'Insert Into %s(C_CusID,C_Money,C_Man,C_Date,C_End,C_Memo, C_Type) ' +
            'Values(''%s'', %.2f, ''%s'', %s, ''%s'', ''%s'', ''%s'')';
    nStr := Format(nStr, [nCreditTable, nCusID, nVal, gSysParam.FUserID,
            FDM.SQLServerNow, DateTime2Str(nEndTime), nMemo, nType]);
    FDM.ExecuteSQL(nStr); 
    
    if nTransCredit then
    begin
      nStr := 'Update %s Set A_CreditLimit=A_CreditLimit+%.2f ' +
              'Where A_CID=''%s''' ;
      nStr := Format(nStr, [nAccountTable, nVal, nCusID]);
      if FDM.ExecuteSQL(nStr) < 1 then
      begin
        nStr := 'Insert Into %s(A_CID,A_Date,A_CreditLimit) Values(''%s'', %s, %.2f)';
        nStr := Format(nStr, [nAccountTable, nCusID, FDM.SQLServerNow, nVal]);
        FDM.ExecuteSQL(nStr);
      end;
    end else
    begin
      nStr := 'Update %s Set A_CreditLimit=A_CreditLimit+%.2f ' +
              'Where A_CID=''%s'' And A_Type=''%s''' ;
      nStr := Format(nStr, [nAccountTable, nVal, nCusID, nType]);
      if FDM.ExecuteSQL(nStr) < 1 then
      begin
        nStr := 'Insert Into %s(A_CID,A_Date,A_CreditLimit,A_Type) ' +
                'Values(''%s'', %s, %.2f, ''%s'')';
        nStr := Format(nStr, [nAccountTable, nCusID, FDM.SQLServerNow, nVal,
                nType]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 保存nCusID的一次返利记录
function SaveCustomerFLPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nMemo: string; const nMoney: Double): Boolean;
var nStr: string;
    nBool: Boolean;
    nVal,nLimit: Double;
begin
  Result := False;
  nVal := Float2Float(nMoney, cPrecision, False);
  //adjust float value

  if nVal < 0 then
  begin
    nLimit := GetCustomerCompensateMoney(nCusID);
    //get money value

    if (nLimit <= 0) or (nLimit < -nVal) then
    begin
      nStr := '客户: %s ' + #13#10#13#10 +
              '当前余额为[ %.2f ]元,无法支出[ %.2f ]元.';
      nStr := Format(nStr, [nCusName, nLimit, -nVal]);
      
      ShowDlg(nStr, sHint);
      Exit;
    end;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Select A_CID From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nCusID]);
    if FDM.QuerySQL(nStr).RecordCount < 1 then
    begin
      nStr := 'Insert Into %s(A_CID,A_Date) Values(''%s'', %s)';
      nStr := Format(nStr, [sTable_CompensateAccount, nCusID, FDM.SQLServerNow]);
      FDM.ExecuteSQL(nStr);
    end;  

    nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CompensateAccount, nVal, nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Money,M_Date,M_Man,M_Memo) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'')';
    nStr := Format(nStr, [sTable_CompensateInOutMoney, nSaleMan, nCusID, nCusName, nType,
            nVal, FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2014-09-14
//Parm: 客户编号
//Desc: 验证nCusID是否有足够的钱,或信用没有过期
function IsCustomerCreditValid(const nCusID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_CustomerHasMoney, nCusID, '', @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

//Date: 2014-10-13
//Desc: 同步业务员到DL系统
function SyncRemoteSaleMan: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncSaleMan, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: 同步用户到DL系统
function SyncRemoteCustomer: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncCustomer, '', '', @nOut);
end;

//Desc: 同步供应商到DL系统
function SyncRemoteProviders: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncProvider, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: 同步原材料到DL系统
function SyncRemoteMeterails: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncMaterails, '', '', @nOut);
end;

//Date: 2014-09-25
//Parm: 车牌号
//Desc: 获取nTruck的称皮记录
function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetTruckPoundData, nTruck, '', @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nPoundData);
  //xxxxx
end;

//Date: 2014-09-25
//Parm: 称重数据
//Desc: 保存nData称重数据
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessCommand(cBC_SaveTruckPoundData, nStr, '', @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  nList := TStringList.Create;
  try
    CapturePicture(nTunnel, nList);
    //capture file

    for nIdx:=0 to nList.Count - 1 do
      SavePicture(nOut.FData, nData[0].FTruck,
                              nData[0].FStockName, nList[nIdx]);
    //save file
  finally
    nList.Free;
  end;
end;

//Date: 2014-10-02
//Parm: 通道号
//Desc: 读取nTunnel读头上的卡号
function ReadPoundCard(const nTunnel: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//Date: 2014-10-01
//Parm: 通道;车辆
//Desc: 读取车辆队列数据
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean): Boolean;
var nIdx: Integer;
    nSLine,nSTruck: string;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    if nRefreshLine then
         nSLine := sFlag_Yes
    else nSLine := sFlag_No;

    Result := CallBusinessHardware(cBC_GetQueueData, nSLine, '', @nOut);
    if not Result then Exit;

    nListA.Text := PackerDecodeStr(nOut.FData);
    nSLine := nListA.Values['Lines'];
    nSTruck := nListA.Values['Trucks'];

    nListA.Text := PackerDecodeStr(nSLine);
    SetLength(nLines, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nLines[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FID       := Values['ID'];
      FName     := Values['Name'];
      FStock    := Values['Stock'];
      FValid    := Values['Valid'] <> sFlag_No;
      FPrinterOK:= Values['Printer'] <> sFlag_No;

      if IsNumber(Values['Weight'], False) then
           FWeight := StrToInt(Values['Weight'])
      else FWeight := 1;
    end;

    nListA.Text := PackerDecodeStr(nSTruck);
    SetLength(nTrucks, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nTrucks[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FTruck    := Values['Truck'];
      FLine     := Values['Line'];
      FBill     := Values['Bill'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;

      FInFact   := Values['InFact'] = sFlag_Yes;
      FIsRun    := Values['IsRun'] = sFlag_Yes;
           
      if IsNumber(Values['Dai'], False) then
           FDai := StrToInt(Values['Dai'])
      else FDai := 0;

      if IsNumber(Values['Total'], False) then
           FTotal := StrToInt(Values['Total'])
      else FTotal := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2014-10-01
//Parm: 通道号;启停标识
//Desc: 启停nTunnel通道的喷码机
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nEnable then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_PrinterEnable, nTunnel, nStr, @nOut);
end;

//Date: 2014-10-07
//Parm: 调度模式
//Desc: 切换系统调度模式为nMode
function ChangeDispatchMode(const nMode: Byte): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ChangeDispatchMode, IntToStr(nMode), '',
            @nOut);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 订单是否需要审核
function IsZhiKaNeedVerify: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_ZhiKaVerify)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: 是否打印订单
function IsPrintZK: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PrintZK)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

function LoadContractInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select con.*,sm.S_Name,cus.C_Name From $Con con ' +
          ' Left Join $SM sm On sm.S_ID=con.C_SaleMan ' +
          ' Left Join $Cus cus On cus.C_ID=con.C_Customer ' +
          'Where con.C_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$Con', sTable_SaleContract),
             MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
             MI('$ID', nCID)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount = 1 then
  with nList.Items,Result do
  begin
    Add('合同编号:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('项目名称:' + nList.Delimiter + FieldByName('C_Project').AsString + ' ');

    nStr := FieldByName('C_Date').AsString;
    Add('签订时间:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := '合同已无效';
  end;
end;

//Desc: 载入nZID的信息到nList中,并返回查询数据集
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string; nZType: string): TDataset;
var nStr: string;
begin
  if nZType = sFlag_BillSZ then
  begin
    nStr := 'Select zk.*,sm.S_ID,sm.S_Name,cus.C_ID,cus.C_Name From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            'Where Z_ID=''$ID''';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
               MI('$Con', sTable_SaleContract), MI('$SM', sTable_Salesman),
               MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
    //xxxxx

    nList.Clear;
    Result := FDM.QueryTemp(nStr);

    if Result.RecordCount = 1 then
    with nList.Items,Result do
    begin
      Add('订单编号:' + nList.Delimiter + FieldByName('Z_ID').AsString);
      Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
      Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
      Add('项目名称:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
      nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
      Add('订单时间:' + nList.Delimiter + nStr);
    end else
    begin
      Result := nil;
      nHint := '订单已无效';
    end;
  end else

  if nZType = sFlag_BillFX then
  begin
    nStr := 'Select zk.*,sm.S_ID,sm.S_Name,cus.C_ID,cus.C_Name From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.I_SaleMan ' +
            ' Left Join $Cus cus On cus.C_ID=zk.I_Customer ' +
            'Where I_ID=''$ID''';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$ZK', sTable_FXZhiKa),
               MI('$SM', sTable_Salesman),MI('$Cus', sTable_Customer),
                MI('$ID', nZID)]);
    //xxxxx

    nList.Clear;
    Result := FDM.QueryTemp(nStr);

    if Result.RecordCount = 1 then
    with nList.Items,Result do
    begin
      Add('订单编号:' + nList.Delimiter + FieldByName('I_ID').AsString);
      Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
      Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
      Add('项目名称:' + nList.Delimiter + ' ');
    
      nStr := DateTime2Str(FieldByName('I_Date').AsDateTime);
      Add('订单时间:' + nList.Delimiter + nStr);
    end else
    begin
      Result := nil;
      nHint := '订单已无效';
    end;

  end else

  if nZType = sFlag_BillFL then
  begin
    nStr := 'Select zk.*,sm.S_ID,sm.S_Name,cus.C_ID,cus.C_Name From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            'Where Z_ID=''$ID''';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$ZK', sTable_FLZhiKa),
               MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
               MI('$ID', nZID)]);
    //xxxxx

    nList.Clear;
    Result := FDM.QueryTemp(nStr);

    if Result.RecordCount = 1 then
    with nList.Items,Result do
    begin
      Add('订单编号:' + nList.Delimiter + FieldByName('Z_ID').AsString);
      Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
      Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
      Add('项目名称:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
      nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
      Add('订单时间:' + nList.Delimiter + nStr);
    end else
    begin
      Result := nil;
      nHint := '订单已无效';
    end;
  end else

  if nZType = sFlag_BillMY then
  begin
    nStr := 'Select zk.*,sm.S_ID,sm.S_Name,cus.C_ID,cus.C_Name From $ZK zk ' +
            ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
            ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
            ' Left Join $MYZ my On my.M_FID=zk.Z_ID ' +
            'Where M_ID=''$ID''';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$MYZ', sTable_MYZhiKa),
               MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
               MI('$ID', nZID)]);
    //xxxxx

    nList.Clear;
    Result := FDM.QueryTemp(nStr);

    if Result.RecordCount = 1 then
    with nList.Items,Result do
    begin
      Add('订单编号:' + nList.Delimiter + FieldByName('Z_ID').AsString);
      Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
      Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
      Add('项目名称:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
      nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
      Add('订单时间:' + nList.Delimiter + nStr);
    end else
    begin
      Result := nil;
      nHint := '订单已无效';
    end;

  end else
  begin
    Result := nil;
    nHint := '订单已无效';
  end;
end;

function LoadCardInfo(const nCard: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select ic.*,zk.*,sm.S_Name,cus.C_Name From  $IC ic' +
          ' Left Join $ZK zk On ic.I_ZID=zk.Z_ID ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where I_Card=''$ID'' And I_Enabled=''$Y''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$IC', sTable_FXZhiKa),
             MI('$Con', sTable_SaleContract), MI('$SM', sTable_Salesman),
             MI('$Cus', sTable_Customer), MI('$ID', nCard), MI('$Y', sFlag_Yes)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount = 1 then
  with nList.Items,Result do
  begin
    Add('订单编号:' + nList.Delimiter + FieldByName('Z_ID').AsString);
    Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString+ ' ');
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('项目名称:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
    nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    Add('创建时间:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := '订单已无效';
  end;
end;

procedure LoadOrderBaseToMC(const nItem: TStrings; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  if (not Assigned(nItem)) or (not Assigned(nMC)) then Exit;
  with nMC do
  begin
    Clear;
    Add(Format('申请单号:%s %s', [nDelimiter, nItem.Values['SQ_ID']]));
    Add(Format('区    域:%s %s', [nDelimiter, nItem.Values['SQ_Area']]));
    Add(Format('业 务 员:%s %s', [nDelimiter, nItem.Values['SQ_SaleName']]));
    Add(Format('项目名称:%s %s', [nDelimiter, nItem.Values['SQ_Project']]));

    if nItem.Values['SQ_ProType'] = sFlag_CusZY then
         nStr := '资源类'
    else nStr := '非资源类';
    Add(Format('供 应 商:%s %s', [nDelimiter, nItem.Values['SQ_ProName']]));

    Add(Format('品种编号:%s %s', [nDelimiter, nItem.Values['SQ_StockNO']]));
    Add(Format('品种名称:%s %s', [nDelimiter, nItem.Values['SQ_StockName']]));
  end;
end;

//Date: 2014-09-14
//Parm: 订单号;是否限提
//Desc: 获取nZhiKa的可用金哦
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean;
  nZKType: string): Double;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetZhiKaMoney, nZhiKa, nZKType, @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    nFixMoney := nOut.FExtParam = sFlag_Yes;
  end else Result := 0;
end;

//Desc: 获取nCID用户的可用金额,包含信用额或净额
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean;
 const nCredit: PDouble): Double;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nLimit then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  if CallBusinessCommand(cBC_GetCustomerMoney, nCID, nStr, @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    if Assigned(nCredit) then
      nCredit^ := StrToFloat(nOut.FExtParam);
    //xxxxx
  end else
  begin
    Result := 0;
    if Assigned(nCredit) then
      nCredit^ := 0;
    //xxxxx
  end;
end;

//Desc: 获取nCID用户的可用金额,包含信用额或净额
function GetTransportValidMoney(nCID: string; const nLimit: Boolean;
 const nCredit: PDouble): Double;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nLimit then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  if CallBusinessCommand(cBC_GetTransportMoney, nCID, nStr, @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    if Assigned(nCredit) then
      nCredit^ := StrToFloat(nOut.FExtParam);
    //xxxxx
  end else
  begin
    Result := 0;
    if Assigned(nCredit) then
      nCredit^ := 0;
    //xxxxx
  end;
end;

function GetCustomerCompensateMoney(nCID: string): Double;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetCompensateMoney, nCID, '', @nOut) then
       Result := StrToFloat(nOut.FData)
  else Result := 0;
end;

//Date: 2014-10-16
//Parm: 品种列表(s1,s2..)
//Desc: 验证nStocks是否可以发货
function IsStockValid(const nStocks: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_CheckStockValid, nStocks, '', @nOut);
end;

//Date: 2015/11/20
//Parm: 纸卡(订单)数据
//Desc: 保存纸卡(订单),返回纸卡单号
function SaveZhiKa(const nZhiKaData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveZhiKa, nZhiKaData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2015/11/20
//Parm: 纸卡(订单)编号
//Desc: 删除纸卡(订单)
function DeleteZhiKa(const nZhiKa: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteZhiKa, nZhiKa, '', @nOut);
end;

//Date: 2015/11/20
//Parm: 纸卡(订单)数据
//Desc: 保存纸卡(订单),返回纸卡单号
function SaveFLZhiKa(const nZhiKaData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveFLZhiKa, nZhiKaData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2015/11/20
//Parm: 纸卡(订单)编号
//Desc: 删除纸卡(订单)
function DeleteFLZhiKa(const nZhiKa: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteFLZhiKa, nZhiKa, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 开单数据
//Desc: 保存交货单,返回交货单号列表
function SaveBill(const nBillData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveBills, nBillData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: 交货单号
//Desc: 删除nBillID单据
function DeleteBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteBill, nBill, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新车牌
//Desc: 修改nBill的车牌为nTruck.
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillTruck, nBill, nTruck, @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新提货量
//Desc: 修改nBill的提货量为nTruck.
function ChangeLadingValue(const nBill,nValue: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillValue, nBill, nValue, @nOut);
end;

//Date: 2014-09-30
//Parm: 交货单;订单
//Desc: 将nBill调拨给nNewZK的客户
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaleAdjust, nBill, nNewZK, @nOut);
end;

//Date: 2014-09-17
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;

  nStr := 'Select O_Card From %s Where O_Truck=''%s''';
  nStr := Format(nStr, [sTable_Order, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      if Length(Fields[0].AsString) < 1 then Continue;

      nStr := '此车有原材料固定ID卡,确认是否继续?';
      if not QueryDlg(nStr, sAsk) then Exit;

      Break;
    finally
      Next;
    end;
  end;
  //查询是否有供应卡

  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Sale;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

function SaveICCardInfo(const nZID: string; const nZType: string;
  const nCardType: string):Boolean;
var nOut: TWorkerBusinessCommand;
    nP: TFormCommandParam;
    nList: TStrings;
begin
  Result := False;

  nP.FParamA := cCmd_AddData;
  nP.FParamB := nCardType;
  nP.FParamC := nZID;
  nP.FParamD := nZType;
  CreateBaseFormItem(cFI_FormReadICCard, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  nList := TStringList.Create;
  try
    with nList do
    begin
      Values['F_ZID']      := nZID;
      Values['F_ZType']    := nZType;

      Values['F_CardType'] := nCardType;
      Values['F_CardNO']   := nP.FParamC;
      Values['F_Card']     := nP.FParamB;
    end;

    Result := CallBusinessSaleBill(cBC_SaveICCInfo, PackerEncodeStr(nList.Text),
              '', @nOut);
    //xxxxx          
  finally
    nList.Free;
  end;
end;

function DeleteICCardInfo(const nCard: string; const nZID: string=''):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteICCInfo, nCard, nZID, @nOut);
end;

//Date: 2014-09-17
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveBillCard(const nBill, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillCard, nBill, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutBillCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_LogoffCard, nCard, '', @nOut);
end;

//Date: 2016/3/29
//Parm: 
//Desc: 读取交货单信息
function ReadBillInfo(var nBillInfo: string):Boolean;
var nSQL: string;
    nList: TStrings;
begin
  Result := False;
  if Length(nBillInfo) < 1 then Exit;

  nSQL := 'Select * From %s Where L_ID=''%s''';
  nSQL := Format(nSQL, [sTable_Bill, nBillInfo]);

  with FDM.QueryTemp(nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nBillInfo := Format('提货单[ %s ]信息已丢失.', [nBillInfo]);
      Exit;
    end;

    nList := TStringList.Create;

    try
      with nList do
      begin
        Clear;

        Values['BillNO']    := FieldByName('L_ID').AsString;
        Values['CusName']   := FieldByName('L_CusName').AsString;
        Values['SaleMan']   := FieldByName('L_SaleMan').AsString;
        Values['StockName'] := FieldByName('L_StockName').AsString;

        Values['OutFact'] := FieldByName('L_OutFact').AsString;
        Values['Truck']   := FieldByName('L_Truck').AsString;
        Values['Value']   := FieldByName('L_Value').AsString;
        Values['Man']     := FieldByName('L_Man').AsString;
      end;

      if Length(nList.Values['OutFact']) < 1 then
      begin
        nBillInfo := Format('提货单[ %s ]提货未完成,禁止退货.', [nBillInfo]);
        Exit;
      end;  

      nBillInfo := PackerEncodeStr(nList.Text);
      Result := True;
    finally
      FreeAndNil(nList);
    end;
  end;  
end;  


//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm:
//Desc: 保存采购申请单
function SaveOrderBase(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrderBase, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

function DeleteOrderBase(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrderBase, nOrder, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 开单数据
//Desc: 保存采购单,返回采购单号列表
function SaveOrder(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrder, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: 交货单号
//Desc: 删除nBillID单据
function DeleteOrder(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrder, nOrder, '', @nOut);
end;

function SaveOrderDtlAdd(const nOrderData: string; var nHint: string): String;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrderDtlAdd, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';

  nHint := nOut.FData;
end;

//Date: 2014-09-17
//Parm: 交货单;车牌号;校验制卡开关
//Desc: 为nBill交货单制卡
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nOrder;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Provide;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: 交货单号;磁卡
//Desc: 绑定nBill.nCard
function SaveOrderCard(const nOrder, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_SaveOrderCard, nOrder, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: 磁卡号
//Desc: 注销nCard
function LogoutOrderCard(const nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_LogOffOrderCard, nCard, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 交货单;新车牌
//Desc: 修改nOrder的车牌为nTruck.
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_ModifyBillTruck, nOrder, nTruck, @nOut);
end;

//Date: 2014-09-15
//Parm: 开单数据
//Desc: 保存退购单,返回退购单号列表
function SaveRefund(const nRefundData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessRefund(cBC_SaveRefund, nRefundData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: 退购单号
//Desc: 删除nRefund单据
function DeleteRefund(const nRefund: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessRefund(cBC_DeleteRefund, nRefund, '', @nOut);
end;

//Date: 2014-09-15
//Parm: 退购单;新车牌
//Desc: 修改nBill的车牌为nTruck.
function ChangeRefundTruckNo(const nRefund,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessRefund(cBC_ModifyRefundTruck, nRefund, nTruck, @nOut);
end;

//Date: 2014-09-17
//Parm: 退购单号;磁卡
//Desc: 绑定nBill.nCard
function SaveRefundCard(const nRefund, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessRefund(cBC_SaveRefundCard, nRefund, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: 退购单;车牌号;校验制卡开关
//Desc: 为Refund退购单制卡
function SetRefundCard(const nRefund,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nRefund;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Refund;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: 磁卡号;岗位;交货单列表
//Desc: 获取nPost岗位上磁卡为nCard的交货单列表
function GetPostItems(const nCard,nPost: string;
 var nItems: TLadingBillItems): Boolean;
var nStr: string;
    nIdx: Integer;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  SetLength(nItems, 0);
  nStr := GetCardUsed(nCard);

  if nStr = sFlag_Sale then //销售
  begin
    Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  end else

  if nStr = sFlag_Provide then
  begin
    Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  end else

  if nStr = sFlag_Refund then
  begin
    Result := CallBusinessRefund(cBC_GetPostBills, nCard, nPost, @nOut);
  end;

  if Result then
    AnalyseBillItems(nOut.FData, nItems);
    //xxxxx

  for nIdx:=Low(nItems) to High(nItems) do
    nItems[nIdx].FCardUse := nStr;
  //xxxxx
end;

//Date: 2014-09-18
//Parm: 岗位;交货单列表;磅站通道
//Desc: 保存nPost岗位上的交货单数据
function SavePostItems(const nPost: string; const nItems: TLadingBillItems;
 const nTunnel: PPTTunnelItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  if Length(nItems) < 1 then Exit;
  nStr := nItems[0].FCardUse;

  if nStr = sFlag_Sale then //销售
  begin
    nStr := CombineBillItmes(nItems);
    Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);
    if (not Result) or (nOut.FData = '') then Exit;
  end else

  if nStr = sFlag_Provide then
  begin
    nStr := CombineBillItmes(nItems);
    Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut); 
    if (not Result) or (nOut.FData = '') then Exit;
  end else

  if nStr = sFlag_Refund then
  begin
    nStr := CombineBillItmes(nItems);
    Result := CallBusinessRefund(cBC_SavePostBills, nStr, nPost, @nOut);
	  if (not Result) or (nOut.FData = '') then Exit;
  end;

  for nIdx:=Low(nItems) to High(nItems) do
  with nItems[nIdx] do
  if nPost = sFlag_TruckBFM then
  begin
    if FCardUse = sFlag_Sale then //销售
      PrintBillReport(FID, False)
    else if FCardUse = sFlag_Refund then //销售 退购
      PrintRefundReport(FID, False)
    else if FCardUse = sFlag_Provide then //销售
      PrintOrderReport(FID, False);

    Sleep(100);
  end;
  
  if Assigned(nTunnel) then //过磅称重
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nList);
      //capture file

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nItems[0].FTruck,
                                nItems[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2014-09-17
//Parm: 交货单项; MCListBox;分隔符
//Desc: 将nItem载入nMC
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('车牌号码:%s %s', [nDelimiter, FTruck]));
    Add(Format('当前状态:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    if FCardUse = sFlag_Provide then
         Add(Format('订单编号:%s %s', [nDelimiter, FZhiKa]))
    else Add(Format('订单编号:%s %s', [nDelimiter, FId]));

    Add(Format('办理数量:%s %.3f 吨', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '袋装' else nStr := '散装';

    Add(Format('品种类型:%s %s', [nDelimiter, nStr]));
    Add(Format('品种名称:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('磁卡编号:%s %s', [nDelimiter, FCard]));
    Add(Format('单据类型:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('客户名称:%s %s', [nDelimiter, FCusName]));
  end;
end;

function GetICCardInfo(var nCardNO: string; const nPassword: string=''):Boolean;
var nSQL, nStr: string;
begin
  Result := False;
  if nCardNO='' then
  begin
    nCardNO := '卡号不能为空';
    Exit;
  end;

  nSQL := 'Select I_ZID,I_Password From %s Where I_Card=''%s'' ' +
          'and I_Enabled<>''%s''';
  nSQL := Format(nSQL, [sTable_FXZhiKa, nCardNO, sFlag_Yes]);
  with FDM.QuerySQL(nSQL) do
  begin
    if RecordCount<1 then
    begin
      nStr    := 'IC卡[%s]无效，请重新刷卡';
      nCardNO := Format(nStr, [nCardNO]);
      Exit;
    end;

    if nPassword <> FieldByName('I_Password').AsString then
    begin
      nStr    := 'IC卡[%s]密码错误，请重新输入密码！';
      nCardNO := Format(nStr, [nCardNO]);
      Exit;
    end;

    nCardNO   := FieldByName('I_ZID').AsString;
  end;

  nSQL := 'Select Z_ID,Z_Freeze,Z_InValid From %s Where Z_ID=''%s'' And ' +
          'IsNull(Z_InValid, '''')<>''%s'' And ' +
          'IsNull(Z_Freeze, '''')<>''%s'' Order By Z_ID';
  nSQL := Format(nSQL, [sTable_ZhiKa, nCardNO, sField_SQLServer_Now, sFlag_Yes, sFlag_Yes]);

  with FDM.QuerySQL(nSQL) do
  begin
    if RecordCount<1 then
    begin
      nStr    := '订单[%s]无效，请重新刷卡';
      nCardNO := Format(nStr, [nCardNO]);
      Exit;
    end;

    if sFlag_Yes = FieldByName('Z_Freeze').AsString then
    begin
      nStr    := '订单[%s]已冻结！';
      nCardNO := Format(nStr, [nCardNO]);
      Exit;
    end;

    if sFlag_Yes = FieldByName('Z_InValid').AsString then
    begin
      nStr    := '订单[%s]已无效！';
      nCardNO := Format(nStr, [nCardNO]);
      Exit;
    end;
  end;

  Result    := True;
end;

//------------------------------------------------------------------------------
//Desc: 每批次最大量
function GetHYMaxValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_HYValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Desc: 获取nNo水泥编号的已开量
function GetHYValueByStockNo(const nNo: string): Double;
var nStr: string;
begin
  nStr := 'Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          'Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[1].AsFloat
  else Result := -1;
end;

//Desc: 保存用户补偿金
function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_Compensation=A_Compensation+%s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nMoney), nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,M_Type,M_Payment,' +
            'M_Money,M_Date,M_Man,M_Memo) Values(''%s'',''%s'',''%s'',' +
            '''%s'',''%s'',%s,%s,''%s'',''%s'')';
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName,
            sFlag_MoneyFanHuan, nPayment, FloatToStr(nMoney),
            FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

function SaveFactZhiKa(const nZhiKa: string; const nFactZhiKa: string): Boolean;
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  Result := False;
  if (Trim(nFactZhiKa)='') or (Trim(nZhiKa)='') then Exit;

  nList := TStringList.Create;

  try
    nList.Clear;
    nList.Values['OwnZhiKa']  := nZhiKa;
    nList.Values['FactZhika'] := nFactZhiKa;
    nList.Values['OwnFactID'] := gSysParam.FFactNum;

    Result := CallBusinessCommand(cBC_SaveFactZhiKa,
      PackerEncodeStr(nList.Text), '', @nOut);
  finally
    nList.Free;
  end;
end;

//Date: 2015-01-16
//Parm: 物料号;品牌名;开单量;原始批次
//Desc: 生产nStock的批次号
function GetStockBatcode(const nStock: string;
 const nBrand: string; const nValue: Double; const nBatch: string): string;
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  nList := TStringList.Create;

  try
    nList.Clear;
    nList.Values['Batch'] := nBatch;
    nList.Values['Brand'] := nBrand;
    nList.Values['Value'] := FloatToStr(nValue);

    if CallBusinessCommand(cBC_GetStockBatcode, nStock,
       PackerEncodeStr(nList.Text), @nOut, False) then
         Result := nOut.FData
    else Result := '';
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 打印标识为nID的销售合同
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    nStr := '是否要打印销售合同?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select sc.*,S_Name,C_Name From $SC sc ' +
          '  Left Join $SM sm On sm.S_ID=sc.C_SaleMan ' +
          '  Left Join $Cus cus On cus.C_ID=sc.C_Customer ' +
          'Where sc.C_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
          MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s] 的销售合同已无效!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where E_CID=''%s''';
  nStr := Format(nStr, [sTable_SContractExt, nID]);
  FDM.QuerySQL(nStr);

  nStr := gPath + sReportDir + 'SaleContract.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

//------------------------------------------------------------------------------
//Desc: 打印标识为nID的运费协议
procedure PrintTransContractReport(const nID: string; const nAsk: Boolean);
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    nStr := '是否要打印货运协议?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From $TC Where T_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$TC', sTable_TransContract),
          MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s] 的运费协议已无效!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'TransContract.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
end;

//Desc: 打印收据
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印收据?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_SysShouJu, nSID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '凭单号为[ %s ] 的收据已无效!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印订单
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印订单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select zk.*,C_Name,S_Name From %s zk ' +
          ' Left Join %s cus on cus.C_ID=zk.Z_Customer' +
          ' Left Join %s sm on sm.S_ID=zk.Z_SaleMan ' +
          'Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer, sTable_Salesman, nZID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '订单号为[ %s ] 的记录已无效';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的订单无明细';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ZhiKa.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印退购单
function PrintRefundReport(nRefund: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nRefund := AdjustListStrFormat(nRefund, '''', True, ',', False);
  //添加引号
  
  nStr := 'Select * From %s r Left join %s c on r.F_StockNo=c.P_ID ' +
          'Where F_ID In(%s)';
  nStr := Format(nStr, [sTable_Refund, sTable_StockParam, nRefund]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nRefund]);
    ShowMsg(nStr, sHint); Exit;
  end;

  if FDM.SqlTemp.FieldByName('F_Type').AsString = sFlag_San then
       nStr := gPath + sReportDir + 'SRefund.fr3'
  else nStr := gPath + sReportDir + 'DRefund.fr3';

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  //FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印提货单
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //添加引号
  
  nStr := 'Select a.*,b.*,c.*,d.T_delivery From %s b Left join %s c on b.L_StockNo=c.P_ID ' +
          ' left join s_truck a on b.l_truck=a.t_truck '+
          ' left join S_TransContract d on l_id=T_LID '+
          ' Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, sTable_StockParam, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  if FDM.SqlTemp.FieldByName('L_Type').AsString = sFlag_San then
       nStr := gPath + sReportDir + 'SLadingBill.fr3'
  else nStr := gPath + sReportDir + 'DLadingBill.fr3';

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  //FDR.ShowReport;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;


//Date: 2012-4-1
//Parm: 采购单号;提示;数据对象;打印机
//Desc: 打印nOrder采购单号
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印采购单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID ' +
          'left join s_truck a on od.D_truck=a.t_truck '+
          'Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sTable_OrderDtl, nOrder]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount < 1 then
  begin
    nStr := '采购单[ %s ] 已无效!!';
    nStr := Format(nStr, [nOrder]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + 'Report\PurchaseOrder.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  //FDR.ShowReport;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
//Parm: 过磅单号;是否询问
//Desc: 打印nPound过磅记录
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印过磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '称重记录[ %s ] 已无效!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  //FDR.ShowReport;
  FDR.PrintReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Date: 2012-4-15
//Parm: nSeal;是否询问
//Desc: 打印批次号的发货回单
function PrintSealReport(const nSeal: string; const FStart,
  FEnd: TDateTime): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;
  if nSeal = '' then Exit;

  nStr := 'Select * From $Bill b ' +
            ' Left Join $Sk s on b.L_Seal=s.R_SerialNo ' +
            ' Left Join $Ext e on e.E_ID=s.R_ExtID ' +
            'Where L_Seal like ''%' + nSeal + '%''' +
            ' And (L_CusType=''$CZY'') ' +
            ' And Year(L_OutFact)>=Year(''$ST'') and Year(L_OutFact) <Year(''$End'')+1 ' +
            ' And Year(R_Date)>=Year(''$ST'') and Year(R_Date) <Year(''$End'')+1 ';
  //提货单

  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill),MI('$CZY', sFlag_CusZY),
          MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1)),
          MI('$SK', sTable_StockRecord),MI('$Ext', sTable_StockRecordExt)]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '满足条件的水泥编号 [ %s ] 已无效!!';
    nStr := Format(nStr, [nSeal]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'SealReport.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select 1 ';
  FDM.QueryTemp(nStr);

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;

  FDR.ShowReport;
  //FDR.PrintReport;
  Result := FDR.PrintSuccess;
end;


//Desc: 获取nStock品种的报表文件
function GetReportFileByStock(const nStock: string): string;
var nDefFile: string;
begin
  Result := GetPinYinOfStr(nStock);

  nDefFile := gPath + sReportDir + Result + '.fr3';
  if FileExists(nDefFile) then
  begin
    Result := nDefFile;
    Exit;
  end;

  if Pos('dj', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42_DJ.fr3'
  else if Pos('gsysl', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_gsl.fr3'
  else if Pos('kzf', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_kzf.fr3'
  else if Pos('qz', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan_qz.fr3'
  else if Pos('32', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan32.fr3'
  else if Pos('42', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else if Pos('52', Result) > 0 then
    Result := gPath + sReportDir + 'HuaYan42.fr3'
  else Result := '';
end;

//Desc: 打印标识为nHID的化验单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印化验单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select * From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID) And ' +
          'Year(R_Date)>=Year(H_ReportDate) and Year(R_Date) <Year(H_ReportDate)+1' ;
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  nStr := GetReportFileByStock(nStr);

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印标识为nID的合格证
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印合格证?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select R_SerialNo,P_Stock,P_Name,P_QLevel From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

procedure PrintTruckLog(const nStart:TDate; nWhere: string='');
var nStr: string;
    nParam: TReportParamItem;
begin
  nStr := 'Select 1 ';
  FDM.QueryTemp(nStr);

  if FDM.QuerySQL(nWhere).RecordCount < 1 then
  begin
    nStr := '无满足条件的信息!!';
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'TruckLogs.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'PrintDate';
  nParam.FValue := Date2Str(nStart);
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

procedure PrintTruckJieSuan(nWhere: string='');
var nStr: string;
    nParam: TReportParamItem;
begin
  nStr := 'Select T_Truck, T_Driver, T_CusName, T_Delivery, T_DPrice, ' +
          'Sum(T_WeiValue) As T_Value, Sum(T_DrvMoney) As T_DMoney, ' +
          'Count(*) As T_Count, T_DisValue, T_SetDate, T_StockName From $Con ' +
          ' Where (IsNull(T_Enabled, '''')<>''$NO'') ' +
          ' And (IsNull(T_Settle, '''') = ''$Yes'') ' +
          ' And T_PayMent Like ''%回厂%''';
  //xxxxx

  if nWhere <> '' then
    nStr := nStr + ' And (' + nWhere + ')';
  //Conditional

  nStr := nStr + ' Group By T_Truck, T_Driver, T_CusName, T_Delivery, ' +
          'T_DPrice, T_DisValue, T_SetDate, T_StockName ';
  //Group By

  nStr := MacroValue(nStr, [MI('$Con', sTable_TransContract),
          MI('$Yes', sFlag_Yes), MI('$NO', sFlag_NO)]);

  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '无满足条件的信息!!';
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select Sum(T_Value) As T_TotalValue, Sum(T_DMoney) As T_TotalMoney,'+
          'Sum(T_Count) As T_TotalCount From ( ' + nStr + ') kk';
  FDM.QueryTemp(nStr);
  //xxxxx

  nStr := gPath + sReportDir + 'TruckJieSuan.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'DaXie';
  nParam.FValue := SmallTOBig(FDM.SqlTemp.FieldByName('T_TotalMoney').AsFloat);
  FDR.AddParamItem(nParam);

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

//Date: 2015/1/18
//Parm: 车牌号；电子标签；是否启用；旧电子标签
//Desc: 读标签是否成功；新的电子标签
function SetTruckRFIDCard(nTruck: string; var nRFIDCard: string;
  var nIsUse: string; nOldCard: string=''): Boolean;
var nP: TFormCommandParam;
begin
  nP.FParamA := nTruck;
  nP.FParamB := nOldCard;
  nP.FParamC := nIsUse;
  CreateBaseFormItem(cFI_FormMakeRFIDCard, '', @nP);

  nRFIDCard := nP.FParamB;
  nIsUse    := nP.FParamC;
  Result    := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;


//Date: 2016/1/22
//Parm: 
//Desc: 格式化内容
function StringGridSelectText(nStringGrid: TStringGrid): string;
var
  nIdx, nJdx: Integer;
  nStr: string;
begin
  Result := '';
  if not Assigned(nStringGrid) then Exit;

  for nJdx := nStringGrid.Selection.Top to nStringGrid.Selection.Bottom do
  begin
    nStr := '';
    for nIdx := nStringGrid.Selection.Left to nStringGrid.Selection.Right do
      nStr := nStr + #9 + nStringGrid.Cells[nIdx, nJdx];

    Delete(nStr, 1, 1);
    Result := Result + nStr + #13#10;
  end;
end;

//Date: 2016/1/22
//Parm: 
//Desc: 从剪切板中粘贴内容到表格
procedure StringGridPasteFromClipboard(nStringGrid: TStringGrid);
var
  nTextList: TStringList;
  nLineList: TStringList;
  nIdx, nJdx: Integer;
begin
  nTextList := TStringList.Create;
  nLineList := TStringList.Create;

  try
    nLineList.Delimiter := #9;
    nTextList.Text := Clipboard.AsText;

    for nJdx := 0 to nTextList.Count - 1 do
    begin
      if nJdx + nStringGrid.Row >= nStringGrid.RowCount then Break;

      nLineList.DelimitedText := nTextList[nJdx];
      for nIdx := 0 to nLineList.Count - 1 do
      begin
        if nIdx + nStringGrid.Col >= nStringGrid.ColCount then Break;

        nStringGrid.Cells[nIdx+nStringGrid.Col,
          nJdx+nStringGrid.Row] := nLineList[nIdx];
      end;
    end;
  finally
    nTextList.Free;
    nLineList.Free;
  end;
end;

//Date: 2016/1/22
//Parm: 
//Desc: StringGrid复制到剪切板(Clipboard)
procedure StringGridCopyToClipboard(nStringGrid: TStringGrid);
begin
  Clipboard.AsText := StringGridSelectText(nStringGrid);
end;

//Date: 2016/1/23
//Parm: 
//Desc: 全选内容
procedure SelectAllOfGrid(nStringGrid: TStringGrid);
//var nIdx, nJdx: Integer;
begin
  if not Assigned(nStringGrid) then Exit;

  {for nIdx:= 0 to nStringGrid.RowCount-1 do
  begin
    //第一列没有数据，不用
    for nJdx:=0 to nStringGrid.ColCount-1 do
    begin
      SendMessage(nStringGrid.Handle, WM_LBUTTONDOWN, 0, MAKELONG(nIdx, nJdx));
      SendMessage(nStringGrid.Handle, WM_LBUTTONUP, 0, MAKELONG(nIdx, nJdx));
    end;  
  end; }

  {with nStringGrid do
  begin
    Selection.Top    := 0;
    Selection.Bottom := RowCount - 1;

    Selection.Left   := 0;
    Selection.Right  := ColCount - 1;
  end; }
end;

procedure StringGridExportToExcel(nStringGrid: TStringGrid; nFile: string='123');
var nSaveDialog:TSaveDialog;
    nExcel, nPage:Variant;
    nIdx, nJdx:Integer;
    nFileName:string;
begin
  try
    if Trim(nFile) = '' then nFile := '1';
    nSaveDialog := TSaveDialog.Create(nil);
    try
      nSaveDialog.FileName := nFile;
      nSaveDialog.Filter   := '*.xls';
      if nSaveDialog.Execute then
      begin
        nFileName := nSaveDialog.FileName;
        //Screen.Cursor:=crhourglass; //屏幕指针形状

        try
          nExcel := CreateOleObject('Excel.Application');  //Office
        except
          nExcel := CreateOleObject('ET.Application');     //WPS
        end;

        nExcel.WorkBooks.Add;
        nExcel.Workbooks[1].WorkSheets[1].Name := nFile;
        nPage := nExcel.Workbooks[1].Worksheets[nFile];

        for nIdx:= 0 to nStringGrid.RowCount-1 do
        begin
          //第一列没有数据，不用
          for nJdx:=0 to nStringGrid.ColCount-1 do
            nPage.Cells[nIdx+1, nJdx+1]:= nStringGrid.Cells[nJdx, nIdx];
        end;

        nExcel.ActiveWorkbook.SaveAs(nFileName);
        Application.ProcessMessages;
        nExcel.Application.Quit;
      end;
    finally
      nSaveDialog.Free;
      //Screen.Cursor:=crDefault;
    end;
  except
    raise
  end;
end;

//Desc: 打印预览nGrid表格
function StringGridPrintPreview(const nGrid: TStringGrid; const nTitle: string): Boolean;
begin
  with FDM.dxGridLink1 do
  begin
    ReportDocument.Creator := gSysParam.FUserName;
    //ReportDocument.Caption := gSysParam
    Component := nGrid;
    ReportTitle.Text := nTitle;
    Preview;
    Result := True;
  end;
end;

//Desc: 打印nGrid表格
function StringGridPrintData(const nGrid: TStringGrid; const nTitle: string): Boolean;
begin
  with FDM.dxGridLink1 do
  begin
    Component := nGrid;
    ReportTitle.Text := nTitle;
    Print(True, nil);
    Result := True;
  end;
end;


end.
