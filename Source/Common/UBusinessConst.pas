{*******************************************************************************
  作者: dmzn@163.com 2012-02-03
  描述: 业务常量定义

  备注:
  *.所有In/Out数据,最好带有TBWDataBase基数据,且位于第一个元素.
*******************************************************************************}
unit UBusinessConst;

interface

uses
  Classes, SysUtils, UBusinessPacker, ULibFun, USysDB;

const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*query field define*}
  cQF_Bill                    = $0001;

  {*business command*}
  cBC_GetSerialNO             = $0001;   //获取串行编号
  cBC_ServerNow               = $0002;   //服务器当前时间
  cBC_IsSystemExpired         = $0003;   //系统是否已过期
  cBC_GetCardUsed             = $0004;   //获取卡片类型
  cBC_UserLogin               = $0005;   //用户登录
  cBC_UserLogOut              = $0006;   //用户注销
  cBC_GetSerialNOByDate       = $0007;   //获取串行编号

  cBC_GetCustomerMoney        = $0010;   //获取客户可用金
  cBC_GetZhiKaMoney           = $0011;   //获取纸卡(订单)可用金
  cBC_CustomerHasMoney        = $0012;   //客户是否有余额
  cBC_AdjustCustomerMoney     = $0013;   //矫正客户余额
  cBC_GetTransportMoney       = $0014;   //获取运费可用金
  cBC_GetCompensateMoney      = $0019;   //获取客户可用金

  cBC_SaveTruckInfo           = $0015;   //保存车辆信息
  cBC_GetTruckPoundData       = $0016;   //获取车辆称重数据
  cBC_SaveTruckPoundData      = $0017;   //保存车辆称重数据
  cBC_GetFLMoney              = $0018;   //获取提货IC卡可用金

  cBC_SaveBills               = $0020;   //保存交货单列表
  cBC_DeleteBill              = $0021;   //删除交货单
  cBC_ModifyBillTruck         = $0022;   //修改车牌号
  cBC_SaleAdjust              = $0023;   //销售调拨
  cBC_SaveBillCard            = $0024;   //绑定交货单磁卡
  cBC_LogoffCard              = $0025;   //注销磁卡
  cBC_SaveZhiKa               = $0026;   //保存纸卡(订单)
  cBC_DeleteZhiKa             = $0027;   //删除纸卡(订单)
  cBC_SaveICCInfo             = $0028;   //保存IC卡信息
  cBC_DeleteICCInfo           = $0029;   //删除纸卡(订单)

  cBC_GetPostBills            = $0030;   //获取岗位交货单
  cBC_SavePostBills           = $0031;   //保存岗位交货单
  cBC_SaveFactZhiKa           = $0032;   //保存工厂订单
  cBC_SaveFLZhiKa             = $0033;   //保存纸卡(订单)
  cBC_DeleteFLZhiKa           = $0034;   //删除纸卡(订单)
  cBC_ModifyBillValue         = $0035;   //修改提货量
  cBC_ModifyBillLine          = $0036;   //同步提货单通道

  cBC_SaveOrder               = $0040;
  cBC_DeleteOrder             = $0041;
  cBC_SaveOrderCard           = $0042;
  cBC_LogOffOrderCard         = $0043;
  cBC_GetPostOrders           = $0044;   //获取岗位采购单
  cBC_SavePostOrders          = $0045;   //保存岗位采购单
  cBC_SaveOrderBase           = $0046;   //保存采购申请单
  cBC_DeleteOrderBase         = $0047;   //删除采购申请单
  cBC_GetGYOrderValue         = $0048;   //获取已收货量
  cBC_SaveOrderDtlAdd         = $0049;

  cBC_GetQueueList            = $0050;   //获取队列数据
  cBC_GetStockBatValue        = $0051;   //获取可用批次号
  cBC_SaveStockBatcode        = $0052;   //保存物料批次
  cBC_ChangeDispatchMode      = $0053;   //切换调度模式
  cBC_GetPoundCard            = $0054;   //获取磅站卡号
  cBC_GetQueueData            = $0055;   //获取队列数据
  cBC_PrintCode               = $0056;
  cBC_PrintFixCode            = $0057;   //喷码
  cBC_PrinterEnable           = $0058;   //喷码机启停
  cBC_GetStockBatcode         = $0059;   //获取可用批次号

  cBC_JSStart                 = $0060;
  cBC_JSStop                  = $0061;
  cBC_JSPause                 = $0062;
  cBC_JSGetStatus             = $0063;
  cBC_SaveCountData           = $0064;   //保存计数结果
  cBC_RemoteExecSQL           = $0065;

  cBC_IsTunnelOK              = $0075;
  cBC_TunnelOC                = $0076;

  cBC_SyncCustomer            = $0080;   //远程同步客户
  cBC_SyncSaleMan             = $0081;   //远程同步业务员
  cBC_SyncStockBill           = $0082;   //同步单据到远程
  cBC_CheckStockValid         = $0083;   //验证是否允许发货
  cBC_SyncStockOrder          = $0084;   //同步采购单据到远程
  cBC_SyncProvider            = $0085;   //远程同步供应商
  cBC_SyncMaterails           = $0086;   //远程同步原材料
  cBC_StatisticsTrucks        = $0087;   //将所有出厂车辆统计

  cBC_VerifyMYZhiKaMoney      = $0090;   //校验贸易公司客户可用金
  cBC_SaveMYBills             = $0091;   //保存贸易公司交易明细
  cBC_DeleteMYBill            = $0092;   //删除贸易公司交易明细

  cBC_SaveRefund              = $0111;   //保存退货
  cBC_DeleteRefund            = $0112;   //删除退货单
  cBC_SaveRefundCard          = $0113;   //退货磁卡
  cBC_ModifyRefundTruck       = $0114;   //修改退货车牌号
  cBC_GetTruckCGHZValue       = $0115;   //获取车辆最大荷载量

type
  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //类型
    FData     : string;            //数据
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //命令
    FData     : string;            //数据
    FExtParam : string;            //参数
  end;

  TPoundStationData = record
    FStation  : string;            //磅站标识
    FValue    : Double;           //皮重
    FDate     : TDateTime;        //称重日期
    FOperator : string;           //操作员
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //交货单号
    FSeal       : string;
    FZhiKa      : string;          //纸卡(订单)编号
    FZKType     : string;          //订单类型
    FCusID      : string;          //客户编号
    FCusName    : string;          //客户名称
    FCusType    : string;          //客户类型
    FTruck      : string;          //车牌号码

    FType       : string;          //品种类型
    FStockNo    : string;          //品种编号
    FStockName  : string;          //品种名称
    FValue      : Double;          //提货量
    FPrice      : Double;          //提货单价

    FCard       : string;          //磁卡号
    FCardUse    : string;          //磁卡类型
    FIsVIP      : string;          //通道类型
    FStatus     : string;          //当前状态
    FNextStatus : string;          //下一状态

    FPData      : TPoundStationData; //称皮
    FMData      : TPoundStationData; //称毛
    FFactory    : string;          //工厂编号
    FPModel     : string;          //称重模式
    FPType      : string;          //业务类型
    FPoundID    : string;          //称重记录
    FSelected   : Boolean;         //选中状态

    FYSValid    : string;          //验收结果，Y验收成功；N拒收；
    FKZValue    : Double;          //供应扣除
    FPayType    : String;          //付款方式
    FMemo       : string;          //动作备注
  end;

  TLadingBillItems = array of TLadingBillItem;
  //交货单列表



procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
//解析由业务对象返回的交货单数据
function CombineBillItmes(const nItems: TLadingBillItems): string;
//合并交货单数据为业务对象能处理的字符串

resourcestring
  {*PBWDataBase.FParam*}
  sParam_NoHintOnError        = 'NHE';                  //不提示错误

  {*plug module id*}
  sPlug_ModuleBus             = '{DF261765-48DC-411D-B6F2-0B37B14E014E}';
                                                        //业务模块
  sPlug_ModuleHD              = '{B584DCD6-40E5-413C-B9F3-6DD75AEF1C62}';
                                                        //硬件守护
  sPlug_ModuleRemote          = '{B584DCD7-40E5-413C-B9F3-6DD75AEF1C63}';
                                                        //MIT互相访问
                                                                                                   
  {*common function*}  
  sSys_BasePacker             = 'Sys_BasePacker';       //基本封包器

  {*business mit function name*}
  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //服务状态
  sBus_GetQueryField          = 'Bus_GetQueryField';    //查询的字段

  sBus_BusinessSaleBill       = 'Bus_BusinessSaleBill'; //交货单相关
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //业务指令
  sBus_HardwareCommand        = 'Bus_HardwareCommand';  //硬件指令
  sBus_BusinessPurchaseOrder  = 'Bus_BusinessPurchaseOrder'; //采购单相关
  sBus_BusinessRefund         = 'Bus_BusinessRefund';   //退货业务相关

  {*client function name*}
  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //服务状态
  sCLI_GetQueryField          = 'CLI_GetQueryField';    //查询的字段

  sCLI_BusinessSaleBill       = 'CLI_BusinessSaleBill'; //交货单业务
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //业务指令
  sCLI_HardwareCommand        = 'CLI_HardwareCommand';  //硬件指令
  sCLI_BusinessPurchaseOrder  = 'CLI_BusinessPurchaseOrder'; //采购单相关
  sCLI_BusinessRefund         = 'CLI_BusinessRefund';   //退货业务相关

implementation

//Date: 2014-09-17
//Parm: 交货单数据;解析结果
//Desc: 解析nData为结构化列表数据
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
var nStr: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FID         := Values['ID'];
        FZhiKa      := Values['ZhiKa'];
        FZKType     := Values['ZKType'];
        FCusID      := Values['CusID'];
        FCusName    := Values['CusName'];
        FCusType    := Values['CusType'];
        FTruck      := Values['Truck'];

        FType       := Values['Type'];
        FStockNo    := Values['StockNo'];
        FStockName  := Values['StockName'];

        FCard       := Values['Card'];
        FIsVIP      := Values['IsVIP'];
        FStatus     := Values['Status'];
        FCardUse    := Values['CardUse'];
        FNextStatus := Values['NextStatus'];

        FFactory    := Values['Factory'];
        FPModel     := Values['PModel'];
        FPType      := Values['PType'];
        FPoundID    := Values['PoundID'];
        FSelected   := Values['Selected'] = sFlag_Yes;

        with FPData do
        begin
          FStation  := Values['PStation'];
          FDate     := Str2DateTime(Values['PDate']);
          FOperator := Values['PMan'];

          nStr := Trim(Values['PValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FPData.FValue := StrToFloat(nStr)
          else FPData.FValue := 0;
        end;

        with FMData do
        begin
          FStation  := Values['MStation'];
          FDate     := Str2DateTime(Values['MDate']);
          FOperator := Values['MMan'];

          nStr := Trim(Values['MValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FMData.FValue := StrToFloat(nStr)
          else FMData.FValue := 0;
        end;

        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;

        FSeal   := Values['Seal'];

        nStr := Trim(Values['KZValue']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FKZValue := StrToFloat(nStr)
        else FKZValue := 0;

        FYSValid:= Values['YSValid'];
        FPayType:= Values['PayType'];
        FMemo := Values['Memo'];
      end;

      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;   
end;

//Date: 2014-09-18
//Parm: 交货单列表
//Desc: 将nItems合并为业务对象能处理的
function CombineBillItmes(const nItems: TLadingBillItems): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if not FSelected then Continue;
      //ignored

      with nListB do
      begin
        Values['ID']         := FID;
        Values['ZhiKa']      := FZhiKa;
        Values['ZKType']     := FZKType;
        Values['CusID']      := FCusID;
        Values['CusName']    := FCusName;
        Values['CusType']    := FCusType;
        Values['Truck']      := FTruck;

        Values['Seal']       := FSeal;

        Values['Type']       := FType;
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);

        Values['Card']       := FCard;
        Values['IsVIP']      := FIsVIP;
        Values['Status']     := FStatus;
        Values['NextStatus'] := FNextStatus;
        Values['CardUse']    := FCardUse;

        Values['Factory']    := FFactory;
        Values['PModel']     := FPModel;
        Values['PType']      := FPType;
        Values['PoundID']    := FPoundID;

        with FPData do
        begin
          Values['PStation'] := FStation;
          Values['PValue']   := FloatToStr(FPData.FValue);
          Values['PDate']    := DateTime2Str(FDate);
          Values['PMan']     := FOperator;
        end;

        with FMData do
        begin
          Values['MStation'] := FStation;
          Values['MValue']   := FloatToStr(FMData.FValue);
          Values['MDate']    := DateTime2Str(FDate);
          Values['MMan']     := FOperator;
        end;

        if FSelected then
             Values['Selected'] := sFlag_Yes
        else Values['Selected'] := sFlag_No;

        Values['KZValue']    := FloatToStr(FKZValue);
        Values['YSValid']    := FYSValid;
        Values['Paytype']    := FPayType;
        Values['Memo']       := FMemo;
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

end.


