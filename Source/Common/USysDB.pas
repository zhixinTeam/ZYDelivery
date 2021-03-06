{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

  cPrecision            = 100;
  {-----------------------------------------------------------------------------
   描述: 计算精度
   *.重量为吨的计算中,小数值比较或者相减运算时会有误差,所以会先放大,去掉
     小数位后按照整数计算.放大倍数由精度值确定.
  -----------------------------------------------------------------------------}

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出   
  sPopedom_ViewPrice  = 'H';                         //查看单价
  sPopedom_ViewCusFZY = 'I';                         //查看资源类型
  sPopedom_ViewCusXN  = 'J';                         //查看虚拟订单

  {*数据库标识*}
  sFlag_DB_K3         = 'King_K3';                   //金蝶数据库
  sFlag_DB_NC         = 'YonYou_NC';                 //用友数据库
  sFlag_DB_Master     = 'Fact_Master';               //工厂主数据库
  sFlag_DB_DRX        = 'Drx_Master';                //德仁鑫数据库
  sFlag_DB_SHY        = 'Shy_Master';                //盛华运数据库

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Unknow        = 'U';                         //未知 
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_ManualNo      = '%';                         //手动指定(非系统自动)
  sFlag_NotMatter     = '@';                         //无关编号(任意编号都可)
  sFlag_ForceDone     = '#';                         //强制完成(未完成前不换)
  sFlag_FixedNo       = '$';                         //指定编号(使用相同编号)
  sFlag_Delimater     = '@';                         //分隔符

  sFlag_Provide       = 'P';                         //供应
  sFlag_Sale          = 'S';                         //销售
  sFlag_Returns       = 'R';                         //退货
  sFlag_Tranlation    = 'T';                         //运输
  sFlag_Other         = 'O';                         //其它
  sFlag_Refund        = 'F';                         //退货

  sFlag_CusZY         = 'Z';                         //资源类客户
  sFlag_CusZYF        = 'F';                         //非资源类客户

  sFlag_TiHuo         = 'T';                         //自提
  sFlag_SongH         = 'S';                         //送货
  sFlag_XieH          = 'X';                         //运卸

  sFlag_Dai           = 'D';                         //袋装水泥
  sFlag_San           = 'S';                         //散装水泥

  sFlag_BillNew       = 'N';                         //新单
  sFlag_BillEdit      = 'E';                         //修改
  sFlag_BillDel       = 'D';                         //删除
  sFlag_BillLading    = 'L';                         //提货中
  sFlag_BillPick      = 'P';                         //拣配
  sFlag_BillPost      = 'G';                         //过账
  sFlag_BillDone      = 'O';                         //完成

  sFlag_BillFL        = 'F';                         //返利订单
  sFlag_BillSZ        = 'S';                         //标准订单
  sFlag_BillFX        = 'V';                         //分销订单
  sFlag_BillMY        = 'M';                         //贸易订单

  sFlag_OrderNew       = 'N';                        //新单
  sFlag_OrderEdit      = 'E';                        //修改
  sFlag_OrderDel       = 'D';                        //删除
  sFlag_OrderPuring    = 'L';                        //送货中
  sFlag_OrderDone      = 'O';                        //完成
  sFlag_OrderAbort     = 'A';                        //废弃
  sFlag_OrderStop      = 'S';                        //终止

  sFlag_OrderCardL     = 'L';                        //临时
  sFlag_OrderCardG     = 'G';                        //固定
  sFlag_ICCardM        = 'M';                        //IC主卡
  sFlag_ICCardV        = 'V';                        //IC副卡

  sFlag_TypeShip      = 'S';                         //船运
  sFlag_TypeZT        = 'Z';                         //栈台
  sFlag_TypeVIP       = 'V';                         //VIP
  sFlag_TypeCommon    = 'C';                         //普通,订单类型

  sFlag_CardIdle      = 'I';                         //空闲卡
  sFlag_CardUsed      = 'U';                         //使用中
  sFlag_CardLoss      = 'L';                         //挂失卡
  sFlag_CardInvalid   = 'N';                         //注销卡

  sFlag_TruckNone     = 'N';                         //无状态车辆
  sFlag_TruckIn       = 'I';                         //进厂车辆
  sFlag_TruckOut      = 'O';                         //出厂车辆
  sFlag_TruckBFP      = 'P';                         //磅房皮重车辆
  sFlag_TruckBFM      = 'M';                         //磅房毛重车辆
  sFlag_TruckSH       = 'S';                         //送货车辆
  sFlag_TruckFH       = 'F';                         //放灰车辆
  sFlag_TruckZT       = 'Z';                         //栈台车辆
  sFlag_TruckXH       = 'X';                         //验收车辆

  sFlag_DeductFix     = 'F';                         //固定值扣减
  sFlag_DeductPer     = 'P';                         //百分比扣减

  sFlag_TJNone        = 'N';                         //未调价
  sFlag_TJing         = 'T';                         //调价中
  sFlag_TJOver        = 'O';                         //调价完成

  sFlag_BatchInUse    = 'Y';                         //批次号有效
  sFlag_BatchOutUse   = 'N';                         //批次号已封存
  sFlag_BatchDel      = 'D';                         //批次号已删除

  sFlag_PoundBZ       = 'B';                         //标准
  sFlag_PoundPZ       = 'Z';                         //皮重
  sFlag_PoundPD       = 'P';                         //配对
  sFlag_PoundCC       = 'C';                         //出厂(过磅模式)
  sFlag_PoundLS       = 'L';                         //临时
  
  sFlag_MoneyHuiKuan  = 'R';                         //回款入金
  sFlag_MoneyJiaCha   = 'C';                         //补缴价差
  sFlag_MoneyZhiKa    = 'Z';                         //纸卡(订单)回款
  sFlag_MoneyFanHuan  = 'H';                         //返还用户

  sFlag_InvNormal     = 'N';                         //正常发票
  sFlag_InvHasUsed    = 'U';                         //已用发票
  sFlag_InvInvalid    = 'V';                         //作废发票
  sFlag_InvRequst     = 'R';                         //申请开出
  sFlag_InvDaily      = 'D';                         //日常开出

  sFlag_SysParam      = 'SysParam';                  //系统参数
  sFlag_EnableBakdb   = 'Uses_BackDB';               //备用库
  sFlag_ValidDate     = 'SysValidDate';              //有效期
  sFlag_ZhiKaVerify   = 'ZhiKaVerify';               //纸卡(订单)审核
  sFlag_PrintZK       = 'PrintZK';                   //打印纸卡(订单)
  sFlag_PrintBill     = 'PrintStockBill';            //需打印订单
  sFlag_ViaBillCard   = 'ViaBillCard';               //直接制卡
  sFlag_PayCredit     = 'Pay_Credit';                //回款冲信用
  sFlag_HYValue       = 'HYMaxValue';                //化验批次量
  sFlag_SaleManDept   = 'SaleManDepartment';         //业务员部门编号
  sFlag_SystemCompanyID = 'SystemCompanyID';         //公司编码
  sFlag_MasterCompanyID = 'MasterCompanyID';         //主服务编码
  sFlag_HZStandard    = 'HZStandard';                //治超标准
  sFlag_NoPoundStock  = 'NoPoundStock';              //超载禁止过磅
  
  sFlag_PDaiWuChaZ    = 'PoundDaiWuChaZ';            //袋装正误差
  sFlag_PDaiWuChaF    = 'PoundDaiWuChaF';            //袋装负误差
  sFlag_PDaiPercent   = 'PoundDaiPercent';           //按比例计算误差
  sFlag_PDaiWuChaStop = 'PoundDaiWuChaStop';         //误差时停止业务
  sFlag_PSanWuChaF    = 'PoundSanWuChaF';            //散装负误差
  sFlag_PSanWuChaStop = 'PoundSanWuChaStop';         //误差时停止业务
  sFlag_PoundWuCha    = 'PoundWuCha';                //过磅误差分组
  sFlag_PoundIfDai    = 'PoundIFDai';                //袋装是否过磅
  sFlag_NFStock       = 'NoFaHuoStock';              //现场无需发货   
  sFlag_OutOfRefund   = 'OutOfRefund';               //退货时限

  sFlag_CommonItem    = 'CommonItem';                //公共信息
  sFlag_CardItem      = 'CardItem';                  //磁卡信息项
  sFlag_AreaItem      = 'AreaItem';                  //区域信息项
  sFlag_TruckItem     = 'TruckItem';                 //车辆信息项
  sFlag_CustomerItem  = 'CustomerItem';              //客户信息项
  sFlag_BankItem      = 'BankItem';                  //银行信息项
  sFlag_UserLogItem   = 'UserLogItem';               //用户登录项

  sFlag_StockItem     = 'StockItem';                 //水泥信息项
  sFlag_ContractItem  = 'ContractItem';              //合同信息项
  sFlag_SalesmanItem  = 'SalesmanItem';              //业务员信息项
  sFlag_ZhiKaItem     = 'ZhiKaItem';                 //纸卡(订单)信息项
  sFlag_BillItem      = 'BillItem';                  //提单信息项
  sFlag_ICCardItem    = 'ICCardItem';                //车辆队列
  sFlag_TruckQueue    = 'TruckQueue';                //车辆队列
                                                               
  sFlag_PaymentItem   = 'PaymentItem';               //付款方式信息项
  sFlag_PaymentItem2  = 'PaymentItem2';              //销售回款信息项
  sFlag_PaymentItem3  = 'PaymentItem3';              //运费付款信息项
  sFlag_LadingItem    = 'LadingItem';                //提货方式信息项
  sFlag_TruckType     = 'TruckType';                 //车辆类型

  sFlag_ProviderItem  = 'ProviderItem';              //供应商信息项
  sFlag_MaterailsItem = 'MaterailsItem';             //原材料信息项

  sFlag_HardSrvURL    = 'HardMonURL';
  sFlag_MITSrvURL     = 'MITServiceURL';             //服务地址
  sFlag_RmtMITSrvURL  = 'RmtMITSvrcURL';             //远程服务地址

  sFlag_AutoIn        = 'Truck_AutoIn';              //自动进厂
  sFlag_AutoOut       = 'Truck_AutoOut';             //自动出厂
  sFlag_InTimeout     = 'InFactTimeOut';             //进厂超时(队列)
  sFlag_SanMultiBill  = 'SanMultiBill';              //散装预开多单
  sFlag_NoDaiQueue    = 'NoDaiQueue';                //袋装禁用队列
  sFlag_NoSanQueue    = 'NoSanQueue';                //散装禁用队列
  sFlag_DelayQueue    = 'DelayQueue';                //延迟排队(厂内)
  sFlag_PoundQueue    = 'PoundQueue';                //延迟排队(厂内依据过皮时间)
  sFlag_NetPlayVoice  = 'NetPlayVoice';              //使用网络语音播发
  sFlag_BatchAuto     = 'Batch_Auto';                //自动生成批次号
  sFlag_BatchBrand    = 'Batch_Brand';               //批次区分品牌
  sFlag_BatchValid    = 'Batch_Valid';               //启用批次管理
  sFlag_DeleteHasOut  = 'DeleteHasOut';              //允许删除已出厂

  sFlag_BusGroup      = 'BusFunction';               //业务编码组
  sFlag_BillNo        = 'Bus_Bill';                  //交货单号
  sFlag_PoundID       = 'Bus_Pound';                 //称重记录
  sFlag_Customer      = 'Bus_Customer';              //客户编号
  sFlag_SaleMan       = 'Bus_SaleMan';               //业务员编号
  sFlag_ZhiKa         = 'Bus_ZhiKa';                 //纸卡(订单)编号
  sFlag_WeiXin        = 'Bus_WeiXin';                //微信映射编号
  sFlag_HYDan         = 'Bus_HYDan';                 //化验单号
  sFlag_ForceHint     = 'Bus_HintMsg';               //强制提示
  sFlag_Order         = 'Bus_Order';                 //采购单号
  sFlag_OrderDtl      = 'Bus_OrderDtl';              //采购单号
  sFlag_OrderBase     = 'Bus_OrderBase';             //采购申请单号
  sFlag_MYZhiKa       = 'Bus_MYZhiKa';               //贸易公司订单
  sFlag_FLZhiKa       = 'Bus_FLZhiKa';               //返利订单
  sFlag_RefundNo      = 'Bus_RefundNo';              //退货单号

  {*数据表*}
  sTable_Group        = 'Sys_Group';                 //用户组
  sTable_User         = 'Sys_User';                  //用户表
  sTable_Menu         = 'Sys_Menu';                  //菜单表
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项
  sTable_Entity       = 'Sys_Entity';                //字典实体
  sTable_DictItem     = 'Sys_DataDict';              //字典明细

  sTable_SysDict      = 'Sys_Dict';                  //系统字典
  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息

  sTable_SerialBase   = 'Sys_SerialBase';            //编码种子
  sTable_SerialStatus = 'Sys_SerialStatus';          //编号状态
  sTable_WorkePC      = 'Sys_WorkePC';               //验证授权

  sTable_CusAccount   = 'Sys_CustomerAccount';       //客户账户
  sTable_CusAccDetail = 'Sys_CustomerAccountDetail'; //客户账户分类明细
  sTable_InOutMoney   = 'Sys_CustomerInOutMoney';    //资金明细
  sTable_CusCredit    = 'Sys_CustomerCredit';        //客户信用
  sTable_SysShouJu    = 'Sys_ShouJu';                //收据记录
  sTable_TransCredit      = 'Sys_TransCredit';        //客户信用
  sTable_TransAccount     = 'Sys_TransAccount';       //运费账户
  sTable_TransInOutMoney  = 'Sys_TransInOutMoney';    //资金明细
  sTable_CompensateAccount= 'Sys_CompensateAccount';       //运费账户
  sTable_CompensateInOutMoney= 'Sys_CompensateInOutMoney';    //资金明细
  //客户账户信息

  sTable_PoundLog     = 'Sys_PoundLog';              //过磅数据
  sTable_PoundBak     = 'Sys_PoundBak';              //过磅作废
  sTable_Picture      = 'Sys_Picture';               //存放图片
  //过磅信息

  sTable_CusAddr      = 'S_CusAddr';                 //客户送货地址
  sTable_Customer     = 'S_Customer';                //客户信息
  sTable_Salesman     = 'S_Salesman';                //业务人员
  sTable_SaleContract = 'S_Contract';                //销售合同
  sTable_SContractExt = 'S_ContractExt';             //合同扩展
  sTable_TransContract= 'S_TransContract';           //运费合同
  //销售合同信息

  sTable_ZhiKa        = 'S_ZhiKa';                   //纸卡(订单)数据
  sTable_ZhiKaDtl     = 'S_ZhiKaDtl';                //纸卡(订单)明细
  //订单明细

  sTable_Card         = 'S_Card';                    //销售磁卡
  sTable_Bill         = 'S_Bill';                    //提货单
  sTable_BillBak      = 'S_BillBak';                 //已删交货单
  sTable_ICCardInfo   = 'S_ICCardInfo';              //提货卡
  sTable_FXZhiKa      = 'S_FXZhiKa';                 //分销订单
  sTable_FLZhiKa      = 'S_FLZhiKa';                 //返利订单
  sTable_MYZhiKa      = 'S_MYZhiKa';                 //贸易订单
  sTable_FLZhiKaDtl   = 'S_FLZhiKaDtl';                 //返利订单
  sTable_Refund       = 'S_Refund';                  //退货单
  sTable_RefundBak    = 'S_RefundBak';               //已删除退货单

  sTable_Truck        = 'S_Truck';                   //车辆表
  sTable_ZTLines      = 'S_ZTLines';                 //装车道
  sTable_ZTTrucks     = 'S_ZTTrucks';                //车辆队列
  sTable_TruckLog     = 'Sys_TruckLog';              //车辆出厂日志

  sTable_StockMatch   = 'S_StockMatch';              //品种映射
  sTable_StockParam   = 'S_StockParam';              //品种参数
  sTable_StockParamExt= 'S_StockParamExt';           //参数扩展
  sTable_StockRecord  = 'S_StockRecord';             //检验记录
  sTable_StockRecordExt= 'S_StockRecordExt';         //记录扩展
  sTable_StockHuaYan  = 'S_StockHuaYan';             //开化验单
  sTable_Batcode      = 'S_Batcode';                 //批次号
  sTable_BatcodeDoc   = 'S_BatcodeDoc';              //批次号

  sTable_Provider     = 'P_Provider';                //客户表
  sTable_Materails    = 'P_Materails';               //物料表
  sTable_Deduct       = 'P_PoundDeduct';             //过磅暗扣
  sTable_Order        = 'P_Order';                   //采购订单
  sTable_OrderBak     = 'P_OrderBak';                //已删除采购订单
  sTable_OrderBase    = 'P_OrderBase';               //采购申请订单
  sTable_OrderBaseBak = 'P_OrderBaseBak';            //已删除采购申请订单
  sTable_OrderDtl     = 'P_OrderDtl';                //采购订单明细
  sTable_OrderDtlBak  = 'P_OrderDtlBak';             //采购订单明细

  sTable_WeixinLog    = 'Sys_WeixinLog';             //微信日志
  sTable_WeixinMatch  = 'Sys_WeixinMatch';           //账号匹配
  sTable_WeixinTemp   = 'Sys_WeixinTemplate';        //信息模板

const   
  {*新建表*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: SysDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
   *.D_ParamA: 浮点参数
   *.D_ParamB: 字符参数
   *.D_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   基本信息表: BaseInfo
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Text: 内容
   *.B_Py: 拼音简写
   *.B_Memo: 备注信息
   *.B_PID: 上级节点
   *.B_Index: 创建顺序
  -----------------------------------------------------------------------------}

    sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   串行编号基数表: SerialBase
   *.R_ID: 编号
   *.B_Group: 分组
   *.B_Object: 对象
   *.B_Prefix: 前缀
   *.B_IDLen: 编号长
   *.B_Base: 基数
   *.B_Date: 参考日期
  -----------------------------------------------------------------------------}

  sSQL_NewSerialStatus = 'Create Table $Table(R_ID $Inc, S_Object varChar(32),' +
       'S_SerailID varChar(32), S_PairID varChar(32), S_Status Char(1),' +
       'S_Date DateTime)';
  {-----------------------------------------------------------------------------
   串行状态表: SerialStatus
   *.R_ID: 编号
   *.S_Object: 对象
   *.S_SerailID: 串行编号
   *.S_PairID: 配对编号
   *.S_Status: 状态(Y,N)
   *.S_Date: 创建时间
  -----------------------------------------------------------------------------}

  sSQL_NewWorkePC = 'Create Table $Table(R_ID $Inc, W_Name varChar(100),' +
       'W_MAC varChar(32), W_Factory varChar(32), W_Serial varChar(32),' +
       'W_Departmen varChar(32), W_ReqMan varChar(32), W_ReqTime DateTime,' +
       'W_RatifyMan varChar(32), W_RatifyTime DateTime, W_Valid Char(1))';
  {-----------------------------------------------------------------------------
   工作授权: WorkPC
   *.R_ID: 编号
   *.W_Name: 电脑名称
   *.W_MAC: MAC地址
   *.W_Factory: 工厂编号
   *.W_Departmen: 部门
   *.W_Serial: 编号
   *.W_ReqMan,W_ReqTime: 接入申请
   *.W_RatifyMan,W_RatifyTime: 批准
   *.W_Valid: 有效(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewStockMatch = 'Create Table $Table(R_ID $Inc, M_Group varChar(8),' +
       'M_ID varChar(20), M_Name varChar(80), M_Status Char(1))';
  {-----------------------------------------------------------------------------
   相似品种映射: StockMatch
   *.R_ID: 记录编号
   *.M_Group: 分组
   *.M_ID: 物料号
   *.M_Name: 物料名称
   *.M_Status: 状态
  -----------------------------------------------------------------------------}
  
  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20), S_Credit $Float,' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   业务员表: SalesMan
   *.R_ID: 记录号
   *.S_ID: 编号
   *.S_Name: 名称
   *.S_PY: 简拼
   *.S_Phone: 联系方式
   *.S_Credit: 所有该业务员能授信的最高额度
   *.S_Area:所在区域
   *.S_InValid: 已无效
   *.S_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Code varChar(15), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50), C_WeiXin varChar(15),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Param varChar(32), C_Memo varChar(50), C_Type Char(1),C_XuNi Char(1))';
  {-----------------------------------------------------------------------------
   客户信息表: Customer
   *.R_ID: 记录号
   *.C_ID: 编号
   *.C_Name: 名称
   *.C_PY: 拼音简写
   *.C_Code: 客户代码
   *.C_Addr: 地址
   *.C_FaRen: 法人
   *.C_LiXiRen: 联系人
   *.C_Phone: 电话
   *.C_WeiXin: 微信
   *.C_Fax: 传真
   *.C_Tax: 税号
   *.C_Bank: 开户行
   *.C_Account: 帐号
   *.C_SaleMan: 业务员
   *.C_Param: 备用参数
   *.C_Type:  客户类型,资源类客户，非资源类客户
   *.C_Memo: 备注信息
   *.C_XuNi: 虚拟(临时)客户
  -----------------------------------------------------------------------------}

  sSQL_NewCusAddr = 'Create Table $Table(R_ID $Inc, A_ID varChar(15), ' +
       'A_CID varChar(15), A_CusName varChar(80), ' +
       'A_Delivery varChar(50), A_DeliveryPY varChar(50), ' +
       'A_RecvMan varChar(30), A_RecvPhone varChar(15), A_Distance $Float,' +
       'A_CPrice $Float Default 0, A_DPrice $Float Default 0,' +
       'A_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   客户收货地址信息表: Customer
   *.R_ID: 记录号
   *.A_ID: 地址编号
   *.A_CID: 客户编号
   *.A_Delivery: 收货地址名称
   *.A_DeliveryPY: 收货地址拼音
   *.A_RecvMan: 收货人
   *.A_RecvPhone: 收货人电话
   *.A_Distance: 运距
   *.A_CPrice: 客户运费价格
   *.A_DPrice: 司机运费价格
   *.A_Memo
  -----------------------------------------------------------------------------}

  sSQL_NewCusAccount = 'Create Table $Table(R_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_CardUseMoney Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_BeginBalance Decimal(15,5) Default 0,' +
       'A_RefundMoney Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   客户账户:CustomerAccount
   *.R_ID:记录编号
   *.A_CID:客户号
   *.A_Used:用途(供应,销售,运输)
   *.A_InMoney:入金
   *.A_OutMoney:出金
   *.A_RefundMoney:销售退购
   *.A_DebtMoney:欠款
   *.A_Compensation:补偿金
   *.A_CardUseMoney:倒卖金额
   *.A_FreezeMoney:冻结资金
   *.A_CreditLimit:信用额度
   *.A_BeginBalance:期初，用于系统导入对账
   *.A_Date:创建日期

   *.水泥销售账中
     A_InMoney:客户存入账户的金额
     A_OutMoney:客户实际花费的金额
     A_RefundMoney:客户退货的金额
     A_DebtMoney:还未支付的金额
     A_Compensation:由于差价退还给客户的金额
     A_CardUseMoney:办理副卡倒卖金额
     A_BeginBalance:期初余额，
     A_FreezeMoney:已办纸卡(订单)但未进厂提货的金额
     A_CreditLimit:授信给用户的最高可欠款金额

     可用余额 = 入金 + 信用额 + 期初 + - 出金 - 补偿金 - 已冻结 - 倒卖金额
     消费总额 = 出金 + 欠款 + 已冻结 + 倒卖金额
  -----------------------------------------------------------------------------}

    sSQL_NewCusAccDetial = 'Create Table $Table(R_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_Type Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_CardUseMoney Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_BeginBalance Decimal(15,5) Default 0,' +
       'A_RefundMoney Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   客户账户:CustomerAccountDetail
   *.R_ID:记录编号
   *.A_CID:客户号
   *.A_Used:用途(供应,销售,运输)
   *.A_Type:账户类型(现金、卡片、承兑、预付款)
   *.A_InMoney:入金
   *.A_OutMoney:出金
   *.A_RefundMoney:销售退购
   *.A_DebtMoney:欠款
   *.A_Compensation:补偿金
   *.A_CardUseMoney:倒卖金额
   *.A_FreezeMoney:冻结资金
   *.A_CreditLimit:信用额度
   *.A_BeginBalance:期初，用于系统导入对账
   *.A_Date:创建日期

   *.水泥销售账中
     A_InMoney:客户存入账户的金额
     A_OutMoney:客户实际花费的金额
     A_RefundMoney:客户退货的金额
     A_DebtMoney:还未支付的金额
     A_Compensation:由于差价退还给客户的金额
     A_CardUseMoney:办理副卡倒卖金额
     A_BeginBalance:期初余额，
     A_FreezeMoney:已办纸卡(订单)但未进厂提货的金额
     A_CreditLimit:授信给用户的最高可欠款金额

     可用余额 = 入金 + 信用额 + 期初 + 退购 + - 出金 - 补偿金 - 已冻结 - 倒卖金额
     消费总额 = 出金 + 欠款 + 已冻结 + 倒卖金额 - 退购
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(R_ID $Inc, M_SaleMan varChar(15),' +
       'M_CusID varChar(15), M_CusName varChar(80), ' +
       'M_Type Char(1), M_Payment varChar(20),' +
       'M_Money Decimal(15,5), M_ZID varChar(15), M_Date DateTime,' +
       'M_Man varChar(32), M_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   出入金明细:CustomerInOutMoney
   *.M_ID:记录编号
   *.M_SaleMan:业务员
   *.M_CusID:客户号
   *.M_CusName:客户名
   *.M_Type:类型(补差,回款等)
   *.M_Payment:付款方式
   *.M_Money:缴纳金额
   *.M_ZID:纸卡(订单)号
   *.M_Date:操作日期
   *.M_Man:操作人
   *.M_Memo:描述

   *.水泥销售入金中
     金额 = 单价 x 数量 + 其它
  -----------------------------------------------------------------------------}

  sSQL_NewSysShouJu = 'Create Table $Table(R_ID $Inc ,S_Code varChar(15),' +
       'S_Sender varChar(100), S_Reason varChar(100), S_Money Decimal(15,5),' +
       'S_BigMoney varChar(50), S_Bank varChar(35), S_Man varChar(32),' +
       'S_Date DateTime, S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   收据明细:ShouJu
   *.R_ID:编号
   *.S_Code:记账凭单号码
   *.S_Sender:兹由(来源)
   *.S_Reason:交来(事务)
   *.S_Money:金额
   *.S_Bank:银行
   *.S_Man:出纳员
   *.S_Date:日期
   *.S_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewCusCredit = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_Man varChar(32), C_Type Char(1),' +
       'C_Date DateTime, C_End DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   信用明细:CustomerCredit
   *.R_ID:编号
   *.C_CusID:客户编号
   *.C_Money:授信额
   *.C_Man:操作人
   *.C_Date:日期
   *.C_End: 有效期
   *.C_Type: 账户类型
   *.C_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewSaleContract = 'Create Table $Table(R_ID $Inc, C_ID varChar(15),' +
       'C_Project varChar(100),C_SaleMan varChar(15), C_Customer varChar(15),' +
       'C_Date varChar(20), C_Area varChar(50), C_Addr varChar(50),' +
       'C_Delivery varChar(50), C_Paytype Char(1), C_Payment varChar(20), ' +
       'C_Approval varChar(30),' +
       'C_ZKDays Integer, C_XuNi Char(1), C_Freeze Char(1), C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   销售合同: SalesContract
   *.R_ID: 编号
   *.C_Project: 项目名称
   *.C_SaleMan: 销售人员
   *.C_Customer: 客户
   *.C_Date: 签订时间
   *.C_Area: 所属区域
   *.C_Addr: 签订地点
   *.C_Delivery: 交货地
   *.C_Paytype: 付款方式
   *.C_Payment: 付款方式
   *.C_Approval: 批准人
   *.C_ZKDays: 纸卡(订单)有效期
   *.C_XuNi: 虚拟合同
   *.C_Freeze: 是否冻结
   *.C_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewSContractExt = 'Create Table $Table(R_ID $Inc,' +
       'E_CID varChar(15), E_Type Char(1), ' +
       'E_StockNo varChar(20), E_StockName varChar(80),' +
       'E_Value Decimal(15,5), E_Price Decimal(15,5), E_Money Decimal(15,5))';
  {-----------------------------------------------------------------------------
   销售合同: SalesContract
   *.R_ID: 记录编号
   *.E_CID: 销售合同
   *.E_Type: 类型(袋,散)
   *.E_StockNo,E_StockName: 水泥类型
   *.E_Value: 数量
   *.E_Price: 单价
   *.E_Money: 金额
  -----------------------------------------------------------------------------}

  sSQL_NewTransContract = 'Create Table $Table(R_ID $Inc, T_ID varChar(15),' +
       'T_LID varChar(15), T_Project varChar(100),' +
       'T_SaleID varChar(15), T_SaleMan varChar(32), T_SalePY varChar(32),' +
       'T_CusID varChar(15), T_CusName varChar(128), T_CusPY varChar(128),' +
       'T_CusPhone varChar(15), T_Area varChar(50), ' +
       'T_Addr varChar(50),T_SrcAddr varChar(50), T_Delivery varChar(50), ' +
       'T_Payment varChar(20), T_RecvMan varChar(30), T_Approval varChar(30),' +
       'T_Driver varChar(32), T_Truck varChar(15), T_DrvPhone varChar(15),' +
       'T_WeiValue $Float, T_DisValue $Float, T_TrueValue $Float,' +
       'T_DrvMoney $Float, T_CusMoney $Float,T_StockName varChar(64),' +
       'T_CPrice $Float Default 0, T_DPrice $Float Default 0,'+
       'T_DisFlag Char(1), T_WeiFlag Char(1), T_Enabled Char(1) Default ''Y'','+
       'T_Man varChar(32), T_Date DateTime, ' +
       'T_VerifyMan varChar(32), T_VerifyDate DateTime,' +
       'T_Settle Char(1), T_SetMan varChar(32), T_SetDate DateTime,' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   运费合同: TransContract
   *.R_ID: 编号
   *.T_ID: 协议编号
   *.T_LID: 销售提货单编号
   *.T_Project: 项目名称
   *.T_SaleID, T_SaleMan, T_SalePY: 销售人员
   *.T_CusID, T_CusName, T_CusPY,T_CusPhone: 客户
   *.T_StockName: 水泥品种
   *.T_Date: 签订时间
   *.T_Area: 所属区域
   *.T_Addr: 签订地点
   *.T_SrcAddr: 装货地址：卓越水泥有限公司
   *.T_Delivery: 交货地
   *.T_RecvMan: 收货人
   *.T_Payment: 付款方式
   *.T_Approval: 批准人
   *.T_Driver: 司机
   *.T_Truck:  车牌
   *.T_DrvPhone: 司机电话
   *.T_WeiValue: 总重
   *.T_DisValue: 运距
   *.T_TrueValue: 确认总重
   *.T_DrvMoney: 司机运费
   *.T_CusMoney: 货款总值
   *.T_CPrice: 客户运费价格
   *.T_DPrice: 司机运费价格
   *.T_DisFlag: 按距离结算运费
   *.T_WeiFlag: 按送货量结算运费
   *.T_Enabled: 是否有效
   *.T_Man:
   *.T_Date:
   *.T_VerifyMan:
   *.T_VerifyDate:
   *.T_Settle: 是否已结算
   *.T_SetDate: 结算时间
   *.T_SetMan: 结算人
   *.T_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKa = 'Create Table $Table(R_ID $Inc,Z_ID varChar(15),' +
       'Z_Name varChar(100),Z_Card varChar(64),Z_CardNO varChar(64),' +
       'Z_CID varChar(15), Z_Project varChar(100), Z_Customer varChar(15),' +
       'Z_SaleMan varChar(15), Z_Paytype Char(1), Z_Payment varChar(20), ' +
       'Z_ValidDays DateTime, Z_Password varChar(16), Z_OnlyPwd Char(1),' +
       'Z_Verified Char(1), Z_InValid Char(1), Z_Freeze Char(1),' +
       'Z_YFMoney $Float,Z_FixedMoney $Float, Z_OnlyMoney Char(1),' +
       'Z_TJStatus Char(1), Z_Memo varChar(200), Z_Man varChar(32),' +
       'Z_Lading Char(1), Z_Date DateTime)';
  {-----------------------------------------------------------------------------
   纸卡(订单)办理: ZhiKa
   *.R_ID:记录编号
   *.Z_ID:纸卡(订单)号
   *.Z_Card:磁卡号
   *.Z_CardNO:磁卡序列号
   *.Z_Name:纸卡(订单)名称
   *.Z_CID:销售合同
   *.Z_Project:项目名称
   *.Z_Customer:客户编号
   *.Z_SaleMan:业务员
   *.Z_Paytype:付款方式
   *.Z_Payment:付款方式
   *.Z_Lading:提货方式(自提,送货)
   *.Z_ValidDays:有效期
   *.Z_Password: 密码
   *.Z_OnlyPwd: 统一密码
   *.Z_Verified:已审核
   *.Z_InValid:已无效
   *.Z_Freeze:已冻结
   *.Z_YFMoney:预付金额
   *.Z_FixedMoney:可用金
   *.Z_OnlyMoney:只使用可用金
   *.Z_TJStatus:调价状态
   *.Z_Man:操作人
   *.Z_Date:创建时间
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaDtl = 'Create Table $Table(R_ID $Inc, D_ZID varChar(15),' +
       'D_Type Char(1), D_StockNo varChar(20), D_StockName varChar(80),' +
       'D_Price $Float, D_Value $Float, D_PPrice $Float, ' +
       'D_TPrice Char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   纸卡(订单)明细:ZhiKaDtl
   *.R_ID:记录编号
   *.D_ZID:纸卡(订单)号
   *.D_Type:类型(袋,散)
   *.D_StockNo,D_StockName:水泥名称
   *.D_Price:单价
   *.D_Value:办理量
   *.D_PPrice:调价前单价
   *.D_TPrice:允许调价
  -----------------------------------------------------------------------------}

  sSQL_NewICCardInfo = 'Create Table $Table(R_ID $Inc, ' +
       'F_ZID varChar(15), F_ZType Char(1),'+
			 'F_Card varChar(64), F_Password varChar(64), F_CardType Char(1),' +
       'F_ParentCard varChar(64), F_CardNO varChar(64))';
  {-----------------------------------------------------------------------------
   IC卡信息:ICCardInfo
   *.R_ID:记录编号
   *.F_ZID: 订单号
   *.F_ZType: 订单类型
   *.F_Card: IC卡号
   *.F_CardNO: 卡序列号
   *.F_Password: 密码
   *.F_CardType: IC卡类型:M,主卡(Master Card)；V,副卡(Vice Card)
   *.F_ParentCard: 父卡号
  -----------------------------------------------------------------------------}

  sSQL_NewFXZhiKa = 'Create Table $Table(R_ID $Inc, I_ID varChar(15),' +
			 'I_ZID varChar(15), I_Password varChar(64), I_CardType Char(1),' +
       'I_Card varChar(64), I_ParentCard varChar(64), I_CardNO varChar(64),' +
       'I_StockType Char(1), I_StockNo varChar(20), I_StockName varChar(80),' +
       'I_Paytype Char(1), I_Payment varChar(20), ' +
       'I_Customer varChar(15),I_SaleMan varChar(15),' +
       'I_Price $Float, I_Value $Float, I_Money $Float,' +
       'I_OutMoney $Float Default 0, I_FreezeMoney $Float Default 0, ' +
       'I_BackMoney $Float Default 0, I_Enabled Char(1) Default ''Y'',' +
       'I_TJStatus Char(1),I_PPrice $Float, I_TPrice Char(1) Default ''Y'',' +
       'I_Man varChar(32), I_Date DateTime,' +
       'I_RefundMoney $Float Default 0,' +
       'I_VerifyMan varChar(32), I_VerifyDate DateTime,I_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   分销订单明细:FXZhiKa
   *.R_ID:记录编号
   *.I_ID: 分销订单编号
   *.I_ZID:纸卡(订单)号
   *.I_Password: 密码
   *.I_Card:IC卡号
   *.I_CardNO: 卡序列号
   *.I_ParentCard: 父卡号
   *.I_Paytype:付款方式
   *.I_Payment:付款方式 (延用主卡)
   *.I_StockType:类型(袋,散)
   *.I_StockNo,I_StockName:水泥名称
   *.I_Customer:客户编号
   *.I_SaleMan:业务员编号
   *.I_Price:单价
   *.I_Value:办理量
   *.I_Money:磁卡可用金额
   *.I_OutMoney:已发量金额
   *.I_FreezeMoney:冻结金额
   *.I_RefundMoney:销售退购
   *.I_BackMoney:冲红
   *.I_Enabled:订单状态
   *.I_TJStatus:调价状态
   *.I_PPrice:调价前单价
   *.I_TPrice:允许调价
   *.I_Man:办理人
   *.I_Date:办卡时间
   *.I_VerifyMan:修改ren
   *.I_VerifyDate:修改时间
  -----------------------------------------------------------------------------}

  sSQL_NewMYZhiKa = 'Create Table $Table(R_ID $Inc, M_ID varChar(15),' +
       'M_MID varChar(15), M_FID varChar(15), M_Fact varChar(64), ' +
        'M_Password varChar(64), M_CardType Char(1),' +
       'M_Card varChar(64), M_CardNO varChar(64),' +
       'M_Man varChar(32), M_Date DateTime,' +
       'M_VerifyMan varChar(32), M_VerifyDate DateTime)';
  {-----------------------------------------------------------------------------
   贸易订单明细:MYZhiKa
   *.R_ID:记录编号
   *.M_ID: 贸易订单编号
   *.M_MID:贸易公司订单号
   *.M_FID:工厂订单号
   *.M_Fact:贸易公司编号
   *.M_Password: 密码
   *.M_Card:IC卡号
   *.M_CardNO: 卡序列号
   *.M_Man:办理人
   *.M_Date:办卡时间
   *.M_VerifyMan:修改ren
   *.M_VerifyDate:修改时间
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc,L_ID varChar(20),' +
       'L_Card varChar(16),L_CDate DateTime,' +
       'L_ZhiKa varChar(15),L_Project varChar(100),' +
       'L_ICC varChar(64),L_ICCT Char(1),L_ZKType Char(1),' +
       'L_Area varChar(50),L_CusType Char(1),' +
       'L_CusID varChar(15),L_CusName varChar(80),L_CusPY varChar(80),' +
       'L_SaleID varChar(15),L_SaleMan varChar(32),' +
       'L_Type Char(1),L_StockNo varChar(20),L_StockName varChar(80),' +
       'L_Value $Float,L_Price $Float,L_PPrice $Float,L_ZKMoney Char(1),' +
       'L_Truck varChar(15),L_Status Char(1),L_NextStatus Char(1),' +
       'L_InTime DateTime,L_InMan varChar(32),' +
       'L_PValue $Float,L_PDate DateTime,L_PMan varChar(32),' +
       'L_MValue $Float,L_MDate DateTime,L_MMan varChar(32),' +
       'L_LadeTime DateTime,L_LadeMan varChar(32), ' +
       'L_LadeLine varChar(15),L_LineName varChar(32),' +
       'L_DaiTotal Integer,L_DaiNormal Integer,L_DaiBuCha Integer,' +
       'L_OutFact DateTime,L_OutMan varChar(32),' +
       'L_Lading Char(1),L_IsVIP varChar(1),L_Seal varChar(100),' +
       'L_HYDan varChar(15),L_Man varChar(32),L_Date DateTime, ' +
       'L_Paytype Char(1),L_Payment varChar(20),' +
       'L_SrcCompany varChar(32), L_SrcID varChar(20), ' +
       'L_DelMan varChar(32),L_DelDate DateTime)';
  {-----------------------------------------------------------------------------
   交货单表: Bill
   *.R_ID: 编号
   *.L_ID: 提单号
   *.L_Card: 磁卡号
   *.L_CDate: 办理磁卡时间
   *.L_ZhiKa: 订单编号
   *.L_ZKType: 订单类型
   *.L_Area: 区域
   *.L_CusID,L_CusName,L_CusPY:客户
   *.L_SaleID,L_SaleMan:业务员
   *.L_Type: 类型(袋,散)
   *.L_StockNo: 物料编号
   *.L_StockName: 物料描述 
   *.L_Value: 提货量
   *.L_Price: 提货单价
   *.L_ZKMoney: 占用纸卡(订单)限提(Y/N)
   *.L_Truck: 车船号
   *.L_Status,L_NextStatus:状态控制
   *.L_InTime,L_InMan: 进厂放行
   *.L_PValue,L_PDate,L_PMan: 称皮重
   *.L_MValue,L_MDate,L_MMan: 称毛重
   *.L_LadeTime,L_LadeMan: 发货时间,发货人
   *.L_LadeLine,L_LineName: 发货通道
   *.L_DaiTotal,L_DaiNormal,L_DaiBuCha:总装,正常,补差
   *.L_OutFact,L_OutMan: 出厂放行
   *.L_Lading: 提货方式(自提,送货)
   *.L_IsVIP:VIP单
   *.L_Seal:封签号
   *.L_HYDan:化验单
   *.L_Man:操作人
   *.L_Date:创建时间
   *.L_Paytype:付款方式
   *.L_Payment:付款方式 (延用主卡)
   *.L_SrcCompany: 公司代码
   *.L_DelMan: 交货单删除人员
   *.L_DelDate: 交货单删除时间
   *.L_Memo: 动作备注
  -----------------------------------------------------------------------------}

    sSQL_NewRefund = 'Create Table $Table(R_ID $Inc, F_ID varChar(20),' +
       'F_Card varChar(16),F_LID varChar(20),F_LOutFact DateTime,' +
       'F_CusID varChar(15),F_CusName varChar(80),F_CusPY varChar(80),' +
       'F_SaleID varChar(15),F_SaleMan varChar(32),' +
       'F_ZKType Char(1),F_ZhiKa varChar(15),F_CusType Char(1),' +
       'F_Type Char(1),F_StockNo varChar(20),F_StockName varChar(80),' +
       'F_LimValue $Float,F_Value $Float,F_Price $Float,' +
       'F_Truck varChar(15),F_Status Char(1),F_NextStatus Char(1),' +
       'F_InTime DateTime,F_InMan varChar(32),' +
       'F_PValue $Float,F_PDate DateTime,F_PMan varChar(32),' +
       'F_MValue $Float,F_MDate DateTime,F_MMan varChar(32),' +
       'F_LadeTime DateTime,F_LadeMan varChar(32), ' +
       'F_LadeLine varChar(15),F_LineName varChar(32),' +
       'F_OutFact DateTime,F_OutMan varChar(32),' +
       'F_Man varChar(32),F_Date DateTime,' +
       'F_Paytype Char(1),F_Payment varChar(20),' +
       'F_SrcCompany varChar(1), F_SrcID varChar(20), ' +
       'F_DelMan varChar(32),F_DelDate DateTime)';
  {-----------------------------------------------------------------------------
   退货单表: Refund
   *.R_ID: 编号
   *.F_ID: 退货单号
   *.F_Card: 磁卡号
   *.F_LID: 退货单对应提货单号
   *.F_LOutFact: 提货出厂时间
   *.F_CusID,F_CusName,F_CusPY,F_CusType:客户
   *.F_SaleID,F_SaleMan:业务员
   *.F_ZhiKa: 订单编号
   *.F_ZKType: 订单类型
   *.F_Type: 类型(袋,散)
   *.F_StockNo: 物料编号
   *.F_StockName: 物料描述
   *.F_LimValue: 提货单原始提货量
   *.F_Value: 退货量
   *.F_Price: 退货单价
   *.F_Truck: 车船号
   *.F_Status,F_NextStatus:状态控制
   *.F_InTime,F_InMan: 进厂放行
   *.F_PValue,F_PDate,F_PMan: 称皮重
   *.F_MValue,F_MDate,F_MMan: 称毛重
   *.F_LadeTime,F_LadeMan: 卸货时间,卸货人
   *.F_LadeLine,F_LineName: 卸货通道
   *.F_OutFact,F_OutMan: 出厂放行
   *.F_Man:操作人
   *.F_Date:创建时间
   *.F_Paytype:付款方式
   *.F_Payment:付款方式 (延用主卡)
   *.F_DelMan: 退货单删除人员
   *.F_DelDate: 退货单删除时间
  -----------------------------------------------------------------------------}

    sSQL_NewCard = 'Create Table $Table(R_ID $Inc, C_Card varChar(16),' +
       'C_Card2 varChar(32), C_Card3 varChar(32),' +
       'C_Owner varChar(15), C_TruckNo varChar(15), C_Status Char(1),' +
       'C_Freeze Char(1), C_Used Char(1), C_UseTime Integer Default 0,' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   磁卡表:Card
   *.R_ID:记录编号
   *.C_Card:主卡号
   *.C_Card2,C_Card3:副卡号
   *.C_Owner:持有人标识
   *.C_TruckNo:提货车牌
   *.C_Used:用途(供应,销售,临时)
   *.C_UseTime:使用次数
   *.C_Status:状态(空闲,使用,注销,挂失)
   *.C_Freeze:是否冻结
   *.C_Man:办理人
   *.C_Date:办理时间
   *.C_Memo:备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewTruck = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15), ' +
       'T_PY varChar(15), T_Owner varChar(32), T_Phone varChar(15), T_Used Char(1), ' +
       'T_PrePValue $Float, T_PrePMan varChar(32), T_PrePTime DateTime, ' +
       'T_PrePUse Char(1), T_MinPVal $Float, T_MaxPVal $Float, ' +
       'T_PValue $Float Default 0, T_PTime Integer Default 0,' +
       'T_PlateColor varChar(12),T_Type varChar(12), T_LastTime DateTime, ' +
       'T_Card varChar(32), T_CardUse Char(1), T_NoVerify Char(1),' +
       'T_Valid Char(1), T_VIPTruck Char(1), T_HasGPS Char(1),' +
       'T_Driver varChar(32), T_DrPhone varChar(15), ' +
       'T_Bearings $Float, T_YSSerial varChar(16), T_ZGSerial varChar(32),' +
       'T_HZValue $Float, T_CGHZValue $Float, T_Memo varChar(100),' +
       'T_TruckAddr varChar(128))';
  {-----------------------------------------------------------------------------
   车辆信息:Truck
   *.R_ID: 记录号
   *.T_Truck: 车牌号
   *.T_PY: 车牌拼音
   *.T_Owner: 车主
   *.T_Phone: 联系方式
   *.T_Used: 用途(供应,销售,其他)
   *.T_PrePValue: 预置皮重
   *.T_PrePMan: 预置司磅
   *.T_PrePTime: 预置时间
   *.T_PrePUse: 使用预置
   *.T_MinPVal: 历史最小皮重
   *.T_MaxPVal: 历史最大皮重
   *.T_PValue: 有效皮重
   *.T_PTime: 过皮次数
   *.T_PlateColor: 车牌颜色
   *.T_Type: 车型
   *.T_LastTime: 上次活动
   *.T_Card: 电子标签
   *.T_CardUse: 使用电子签(Y/N)
   *.T_NoVerify: 不校验时间
   *.T_Valid: 是否有效
   *.T_VIPTruck:是否VIP
   *.T_HasGPS:安装GPS(Y/N)
   *.T_Driver:驾驶员
   *.T_DrPhone:驾驶员联系方式
   *.T_HZValue:核定载重量
   *.T_CGHZValue:采购最大载重量
   *.T_Bearings:轴承数量
   *.T_YSSerial:道路运输证号
   *.T_ZGSerial:从业资格证号
   *.T_Memo:备注

   有效平均皮重算法:
   T_PValue = (T_PValue * T_PTime + 新皮重) / (T_PTime + 1)
  -----------------------------------------------------------------------------}

  sSQL_NewPoundLog = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Type varChar(1), P_Order varChar(20), P_Card varChar(16),' +
       'P_Bill varChar(20), P_Truck varChar(15), P_CusID varChar(32),' +
       'P_CusName varChar(80), P_MID varChar(32),P_MName varChar(80),' +
       'P_MType varChar(10), P_LimValue $Float,' +
       'P_PValue $Float, P_PDate DateTime, P_PMan varChar(32), ' +
       'P_MValue $Float, P_MDate DateTime, P_MMan varChar(32), ' +
       'P_FactID varChar(32), P_PStation varChar(10), P_MStation varChar(10),' +
       'P_Direction varChar(10), P_PModel varChar(10), P_Status Char(1),' +
       'P_Valid Char(1), P_PrintNum Integer Default 1,' +
       'P_DelMan varChar(32), P_DelDate DateTime, P_KZValue $Float Default 0)';
  {-----------------------------------------------------------------------------
   过磅记录: Materails
   *.P_ID: 编号
   *.P_Type: 类型(销售,供应,临时)
   *.P_Order: 订单号(供应)
   *.P_Bill: 交货单
   *.P_Truck: 车牌
   *.P_CusID: 客户号
   *.P_CusName: 物料名
   *.P_MID: 物料号
   *.P_MName: 物料名
   *.P_MType: 包,散等
   *.P_LimValue: 票重
   *.P_PValue,P_PDate,P_PMan: 皮重
   *.P_MValue,P_MDate,P_MMan: 毛重
   *.P_FactID: 工厂编号
   *.P_PStation,P_MStation: 称重磅站
   *.P_Direction: 物料流向(进,出)
   *.P_PModel: 过磅模式(标准,配对等)
   *.P_Status: 记录状态
   *.P_Valid: 是否有效
   *.P_PrintNum: 打印次数
   *.P_DelMan,P_DelDate: 删除记录
   *.P_KZValue: 供应扣杂
  -----------------------------------------------------------------------------}

  sSQL_NewTruckLog = 'Create Table $Table(R_ID $Inc, L_BID varChar(15),' +
       'L_Type varChar(1), L_PValue $Float, L_MValue $Float,' +
       'L_Value $Float, L_Truck varChar(32), L_OutFact DateTime, ' +
       'L_Memo varChar(32))';
  {-----------------------------------------------------------------------------
   车辆出厂记录: TruckLog
   *.L_BID: 编号(销售出厂编号,供应入厂编号)
   *.L_Type: 类型(销售,供应,临时)
   *.L_PValue: 皮重
   *.L_MValue: 毛重
   *.L_Truck : 车牌号
   *.L_Value:  净重=毛重-皮重
   *.L_OutFact: 出厂时间
   *.L_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewPicture = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(32), P_Mate varChar(80), P_Date DateTime, P_Picture Image)';
  {-----------------------------------------------------------------------------
   图片: Picture
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Mate: 物料
   *.P_Date: 时间
   *.P_Picture: 图片
  -----------------------------------------------------------------------------}

  sSQL_NewZTLines = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_Name varChar(32), Z_StockNo varChar(20), Z_Stock varChar(80),' +
       'Z_StockType Char(1), Z_PeerWeight Integer,' +
       'Z_QueueMax Integer, Z_VIPLine Char(1), Z_Valid Char(1), Z_Index Integer)';
  {-----------------------------------------------------------------------------
   装车线配置: ZTLines
   *.R_ID: 记录号
   *.Z_ID: 编号
   *.Z_Name: 名称
   *.Z_StockNo: 品种编号
   *.Z_Stock: 品名
   *.Z_StockType: 类型(袋,散)
   *.Z_PeerWeight: 袋重
   *.Z_QueueMax: 队列大小
   *.Z_VIPLine: VIP通道
   *.Z_Valid: 是否有效
   *.Z_Index: 顺序索引
  -----------------------------------------------------------------------------}

  sSQL_NewZTTrucks = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15),' +
       'T_StockNo varChar(20), T_Stock varChar(80), T_Type Char(1),' +
       'T_Line varChar(15), T_Index Integer, ' +
       'T_InTime DateTime, T_InFact DateTime, T_InQueue DateTime,' +
       'T_InLade DateTime, T_VIP Char(1), T_Valid Char(1), T_Bill varChar(15),' +
       'T_Value $Float, T_PeerWeight Integer, T_Total Integer Default 0,' +
       'T_Normal Integer Default 0, T_BuCha Integer Default 0,' +
       'T_PDate DateTime, T_IsPound Char(1),T_HKBills varChar(200))';
  {-----------------------------------------------------------------------------
   待装车队列: ZTTrucks
   *.R_ID: 记录号
   *.T_Truck: 车牌号
   *.T_StockNo: 品种编号
   *.T_Stock: 品种名称
   *.T_Type: 品种类型(D,S)
   *.T_Line: 所在道
   *.T_Index: 顺序索引
   *.T_InTime: 入队时间
   *.T_InFact: 进厂时间
   *.T_InQueue: 上屏时间
   *.T_InLade: 提货时间
   *.T_VIP: 特权
   *.T_Bill: 提单号
   *.T_Valid: 是否有效
   *.T_Value: 提货量
   *.T_PeerWeight: 袋重
   *.T_Total: 总装袋数
   *.T_Normal: 正常袋数
   *.T_BuCha: 补差袋数
   *.T_PDate: 过磅时间
   *.T_IsPound: 需过磅(Y/N)
   *.T_HKBills: 合卡交货单列表
  -----------------------------------------------------------------------------}

    sSQL_NewBatcode = 'Create Table $Table(R_ID $Inc, B_Stock varChar(32),' +
       'B_Name varChar(80), B_Prefix varChar(5), B_Base Integer,' +
       'B_Interval Integer, B_Incement Integer, B_Length Integer,' +
       'B_UseDate Char(1), B_LastDate DateTime)';
  {-----------------------------------------------------------------------------
   批次编码表: Batcode
   *.R_ID: 编号
   *.B_Stock: 物料号
   *.B_Name: 物料名
   *.B_Prefix: 前缀
   *.B_Base: 起始编码(基数)
   *.B_Interval: 有效时长(天)
   *.B_Incement: 编号增量
   *.B_Length: 编号长度
   *.B_UseDate: 使用日期编码
   *.B_LastDate: 上次基数更新时间
  -----------------------------------------------------------------------------}

  sSQL_NewBatcodeDoc = 'Create Table $Table(R_ID $Inc, D_ID varChar(32),' +
       'D_Stock varChar(32),D_Name varChar(80), D_Brand varChar(32), ' +
       'D_Plan $Float, D_Sent $Float, D_Rund $Float, D_Init $Float, D_Warn $Float, ' +
       'D_Man varChar(32), D_Date DateTime, D_DelMan varChar(32), D_DelDate DateTime, ' +
       'D_UseDate DateTime, D_LastDate DateTime, D_Valid char(1))';
  {-----------------------------------------------------------------------------
   批次编码表: Batcode
   *.R_ID: 编号
   *.D_ID: 批次号
   *.D_Stock: 物料号
   *.D_Name: 物料名
   *.D_Brand: 水泥品牌
   *.D_Plan: 计划总量
   *.D_Sent: 已发量
   *.D_Rund: 退货量
   *.D_Init: 初始量
   *.D_Warn: 预警量
   *.D_Man:  操作人
   *.D_Date: 生成时间
   *.D_DelMan: 删除人
   *.D_DelDate: 删除时间
   *.D_UseDate: 启用时间
   *.D_LastDate: 终止时间
   *.D_Valid: 是否启用(N、封存;Y、启用；D、删除)
  -----------------------------------------------------------------------------}

  sSQL_NewStockParam = 'Create Table $Table(P_ID varChar(15), P_Stock varChar(30),' +
       'P_Type Char(1), P_Name varChar(50), P_QLevel varChar(20), P_Memo varChar(50),' +
       'P_MgO varChar(20), P_SO3 varChar(20), P_ShaoShi varChar(20),' +
       'P_CL varChar(20), P_BiBiao varChar(20), P_ChuNing varChar(20),' +
       'P_ZhongNing varChar(20), P_AnDing varChar(20), P_XiDu varChar(20),' +
       'P_Jian varChar(20), P_ChouDu varChar(20), P_BuRong varChar(20),' +
       'P_YLiGai varChar(20), P_Water varChar(20), P_KuangWu varChar(20),' +
       'P_GaiGui varChar(20), P_3DZhe varChar(20), P_28Zhe varChar(20),' +
       'P_3DYa varChar(20), P_28Ya varChar(20), P_Methods varChar(64),' +
       'P_Criterion varChar(32), P_License varChar(64), P_VI varChar(20), ' +
       'P_SGType varChar(20), P_SGValue varChar(20),' +
       'P_C3A varChar(20), P_HHCValue varChar(20))';
  {-----------------------------------------------------------------------------
   品种参数:StockParam
   *.P_ID:记录编号
   *.P_Stock:品名
   *.P_Type:类型(袋,散)
   *.P_Name:等级名
   *.P_QLevel:强度等级
   *.P_Memo:备注
   *.P_MgO:氧化镁
   *.P_SO3:三氧化硫
   *.P_ShaoShi:烧失量
   *.P_CL:氯离子
   *.P_BiBiao:比表面积
   *.P_ChuNing:初凝时间
   *.P_ZhongNing:终凝时间
   *.P_AnDing:安定性
   *.P_XiDu:细度
   *.P_Jian:碱含量
   *.P_ChouDu:稠度
   *.P_BuRong:不溶物
   *.P_YLiGai:游离钙
   *.P_Water:保水率
   *.P_KuangWu:硅酸盐矿物
   *.P_GaiGui:钙硅比
   *.P_3DZhe:3天抗折强度
   *.P_28DZhe:28抗折强度
   *.P_3DYa:3天抗压强度
   *.P_28DYa:28抗压强度
   *.P_VI:水溶性铬
   *.P_SGType: 石膏种类
   *.P_SGValue: 石膏掺入量
   *.P_HHCValue: 混合材掺入量
   *.P_C3A: 熟料(C3A)
   *.P_Methods: 检验方法
   *.P_Criterion: 执行标准
   *.P_License:生产许可证编号
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord = 'Create Table $Table(R_ID $Inc, R_SerialNo varChar(15),' +
       'R_PID varChar(15), R_ExtID varChar(30), ' +
       'R_SGType varChar(20), R_SGValue varChar(20),' +
       'R_HHCType varChar(20), R_HHCValue varChar(20),' +
       'R_MgO varChar(20), R_SO3 varChar(20), R_ShaoShi varChar(20),' +
       'R_CL varChar(20), R_BiBiao varChar(20), R_ChuNing varChar(20),' +
       'R_ZhongNing varChar(20), R_AnDing varChar(20), R_XiDu varChar(20),' +
       'R_Jian varChar(20), R_ChouDu varChar(20), R_BuRong varChar(20),' +
       'R_YLiGai varChar(20), R_Water varChar(20), R_KuangWu varChar(20),' +
       'R_GaiGui varChar(20),' +
       'R_3DZhe1 varChar(20), R_3DZhe2 varChar(20), R_3DZhe3 varChar(20),' +
       'R_28Zhe1 varChar(20), R_28Zhe2 varChar(20), R_28Zhe3 varChar(20),' +
       'R_3DYa1 varChar(20), R_3DYa2 varChar(20), R_3DYa3 varChar(20),' +
       'R_3DYa4 varChar(20), R_3DYa5 varChar(20), R_3DYa6 varChar(20),' +
       'R_28Ya1 varChar(20), R_28Ya2 varChar(20), R_28Ya3 varChar(20),' +
       'R_28Ya4 varChar(20), R_28Ya5 varChar(20), R_28Ya6 varChar(20),' +
       'R_VI varChar(20), R_Date DateTime, R_Man varChar(32),' +
       'R_Cao varChar(20), R_ZhuMoJi varChar(20), R_ShiGao varChar(20))';
  {-----------------------------------------------------------------------------
   检验记录:StockRecord
   *.R_ID:记录编号
   *.R_SerialNo:水泥编号
   *.R_ExtID: 扩展参数ID
   *.R_PID:品种参数
   *.R_SGType: 石膏种类
   *.R_SGValue: 石膏掺入量
   *.R_HHCType: 混合材料类
   *.R_HHCValue: 混合材掺入量
   *.R_MgO:氧化镁
   *.R_SO3:三氧化硫
   *.R_ShaoShi:烧失量
   *.R_CL:氯离子
   *.R_BiBiao:比表面积
   *.R_ChuNing:初凝时间
   *.R_ZhongNing:终凝时间
   *.R_AnDing:安定性
   *.R_XiDu:细度
   *.R_Jian:碱含量
   *.R_ChouDu:稠度
   *.R_BuRong:不溶物
   *.R_YLiGai:游离钙
   *.R_Water:保水率
   *.R_KuangWu:硅酸盐矿物
   *.R_GaiGui:钙硅比
   *.R_3DZhe1:3天抗折强度1
   *.R_3DZhe2:3天抗折强度2
   *.R_3DZhe3:3天抗折强度3
   *.R_28Zhe1:28抗折强度1
   *.R_28Zhe2:28抗折强度2
   *.R_28Zhe3:28抗折强度3
   *.R_3DYa1:3天抗压强度1
   *.R_3DYa2:3天抗压强度2
   *.R_3DYa3:3天抗压强度3
   *.R_3DYa4:3天抗压强度4
   *.R_3DYa5:3天抗压强度5
   *.R_3DYa6:3天抗压强度6
   *.R_28Ya1:28抗压强度1
   *.R_28Ya2:28抗压强度2
   *.R_28Ya3:28抗压强度3
   *.R_28Ya4:28抗压强度4
   *.R_28Ya5:28抗压强度5
   *.R_28Ya6:28抗压强度6
   *.R_VI:水溶性铬
   *.R_Date:取样日期
   *.R_Man:录入人
   *.R_Cao :氧化钙
   *.R_ZhuMoJi : 助磨剂
   *.R_ShiGao  : 石膏
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecordExt = 'Create Table $Table(R_ID $Inc,E_ID VarChar(30),' +
       'E_Group varChar(32),' +
       'E_Stock varChar(32),E_Name varChar(80), E_Brand varChar(32), ' +
       'E_Plan $Float, E_Sent $Float, E_Rund $Float, ' +
       'E_Init $Float, E_Warn $Float, E_Freeze $Float, E_WCValue $Float,' +
       'E_Man varChar(32), E_Date DateTime, E_DelMan varChar(32), E_DelDate DateTime, ' +
       'E_UseDate DateTime, E_LastDate DateTime, E_Status char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   记录扩展: StockRecordExt
   *.R_ID: 编号
   *.E_ID: ID
   *.E_Group: 分组
   *.E_Stock: 物料号
   *.E_Name: 物料名
   *.E_Brand: 水泥品牌
   *.E_Plan: 计划总量
   *.E_Sent: 已发量
   *.E_Init: 初始量
   *.E_Rund: 退货量
   *.E_Warn: 预警量
   *.E_Freeze: 冻结量
   *.E_WCValue: 误差额度
   *.E_Man:  操作人
   *.E_Date: 生成时间
   *.E_DelMan: 删除人
   *.E_DelDate: 删除时间
   *.E_UseDate: 启用时间
   *.E_LastDate: 终止时间
   *.E_Status: 是否启用(N、封存;Y、启用；D、删除)
  -----------------------------------------------------------------------------}

  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_No varChar(15),' +
       'H_Custom varChar(15), H_CusName varChar(80), H_SerialNo varChar(15),' +
       'H_Truck varChar(15), H_Value $Float, ' +
       'H_BillNO DateTime, H_BillDate DateTime,' +
       'H_EachTruck Char(1), H_ReportDate DateTime, H_Reporter varChar(32),' +
       'H_ReportDate2 DateTime, H_Reporter2 varChar(32))';
  {-----------------------------------------------------------------------------
   开化验单:StockHuaYan
   *.H_ID:记录编号
   *.H_No:化验单号
   *.H_Custom:客户编号
   *.H_CusName:客户名称
   *.H_SerialNo:水泥编号
   *.H_Truck:提货车辆
   *.H_Value:提货量
   *.H_BillDate:提货日期
   *.H_EachTruck: 随车开单
   *.H_ReportDate:报告日期
   *.H_Reporter:报告人
   *.H_ReportDate2:补报日期
   *.H_Reporter2:补报人
  -----------------------------------------------------------------------------}

  sSQL_NewDataTemp = 'Create Table $Table(T_SysID varChar(15))';
  {-----------------------------------------------------------------------------
   临时数据表: DataTemp
   *.T_SysID: 系统编号
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(32),' +
       'P_Name varChar(80),P_PY varChar(80), P_Phone varChar(20),' +
       'P_Saler varChar(32),P_Type Char(1), P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   供应商: Provider
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_PY: 拼音简写
   *.P_Phone: 联系方式
   *.P_Saler: 业务员
   *.P_Type: 供应商类型,资源综合利用(或者非资源综合利用)
   *.P_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(R_ID $Inc, M_ID varChar(32),' +
       'M_Name varChar(80),M_PY varChar(80),M_Unit varChar(20),M_Price $Float,' +
       'M_PrePValue Char(1), M_PrePTime Integer, M_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   物料表: Materails
   *.M_ID: 编号
   *.M_Name: 名称
   *.M_PY: 拼音简写
   *.M_Unit: 单位
   *.M_PrePValue: 预置皮重
   *.M_PrePTime: 皮重时长(天)
   *.M_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewOrderBase = 'Create Table $Table(R_ID $Inc, B_ID varChar(20),' +
       'B_Value $Float, B_SentValue $Float,B_RestValue $Float,' +
       'B_LimValue $Float, B_WarnValue $Float,B_FreezeValue $Float,' +
       'B_BStatus Char(1),B_Area varChar(50), B_Project varChar(100),' +
       'B_ProType Char(1), B_ProID varChar(32), B_XuNi Char(1),' +
       'B_ProName varChar(80), B_ProPY varChar(80),' +
       'B_SaleID varChar(32), B_SaleMan varChar(80), B_SalePY varChar(80),' +
       'B_StockType Char(1), B_StockNo varChar(32), B_StockName varChar(80),' +
       'B_Man varChar(32), B_Date DateTime,' +
       'B_DelMan varChar(32), B_DelDate DateTime, B_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   采购申请单表: Order
   *.R_ID: 编号
   *.B_ID: 提单号
   *.B_XuNi: 虚拟(资源综合利用；非资源综合利用)
   *.B_Value,B_SentValue,B_RestValue:订单量，已发量，剩余量
   *.B_LimValue,B_WarnValue,B_FreezeValue:订单超发上限;订单预警量,订单冻结量
   *.B_BStatus: 订单状态
   *.B_Area,B_Project: 区域,项目
   *.B_ProID,B_ProName,B_ProPY, B_ProType:供应商
   *.B_SaleID,B_SaleMan,B_SalePY:业务员
   *.B_StockType: 类型(袋,散)
   *.B_StockNo: 原材料编号
   *.B_StockName: 原材料名称
   *.B_Man:操作人
   *.B_Date:创建时间
   *.B_DelMan: 采购申请单删除人员
   *.B_DelDate: 采购申请单删除时间
   *.B_Memo: 动作备注
  -----------------------------------------------------------------------------}

  sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(20),' +
       'O_BID varChar(20),O_Card varChar(16), O_CType varChar(1),' +
       'O_Value $Float,O_Area varChar(50), O_Project varChar(100),' +
       'O_ProType Char(1), O_ProID varChar(32), ' +
       'O_ProName varChar(80), O_ProPY varChar(80),' +
       'O_SaleID varChar(32), O_SaleMan varChar(80), O_SalePY varChar(80),' +
       'O_Type Char(1), O_StockNo varChar(32), O_StockName varChar(80),' +
       'O_Truck varChar(15), O_OStatus Char(1),' +
       'O_Man varChar(32), O_Date DateTime, O_XuNi Char(1),' +
       'O_SrcCompany varChar(32), O_SrcID varChar(20), ' +
       'O_DelMan varChar(32), O_DelDate DateTime, O_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   采购订单表: Order
   *.R_ID: 编号
   *.O_ID: 提单号
   *.O_BID: 采购申请单据号
   *.O_Card,O_CType: 磁卡号,磁卡类型(L、临时卡;G、固定卡)
   *.O_Value:订单量，
   *.O_OStatus: 订单状态
   *.O_Area,O_Project: 区域,项目
   *.O_ProType,O_ProID,O_ProName,O_ProPY:供应商
   *.O_SaleID,O_SaleMan:业务员
   *.O_Type: 类型(袋,散)
   *.O_StockNo: 原材料编号
   *.O_StockName: 原材料名称
   *.O_Truck: 车船号
   *.O_Man:操作人
   *.O_Date:创建时间
   *.O_XuNi:虚拟订单
   *.O_DelMan: 采购单删除人员
   *.O_DelDate: 采购单删除时间
   *.O_Memo: 动作备注
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_ID varChar(20),' +
       'D_OID varChar(20), D_PID varChar(20), D_Card varChar(16), ' +
       'D_Area varChar(50), D_Project varChar(100),D_Truck varChar(15), ' +
       'D_ProType Char(1), D_ProID varChar(32), D_XuNi Char(1),' +
       'D_ProName varChar(80), D_ProPY varChar(80),' +
       'D_SaleID varChar(32), D_SaleMan varChar(80), D_SalePY varChar(80),' +
       'D_Type Char(1), D_StockNo varChar(32), D_StockName varChar(80),' +
       'D_DStatus Char(1), D_Status Char(1), D_NextStatus Char(1),' +
       'D_InTime DateTime, D_InMan varChar(32),' +
       'D_PValue $Float, D_PDate DateTime, D_PMan varChar(32),' +
       'D_MValue $Float, D_MDate DateTime, D_MMan varChar(32),' +
       'D_YTime DateTime, D_YMan varChar(32), ' +
       'D_Value $Float,D_KZValue $Float, D_AKValue $Float,' +
       'D_YLine varChar(15), D_YLineName varChar(32), ' +
       'D_DelMan varChar(32), D_DelDate DateTime, D_YSResult Char(1), ' +
       'D_SrcCompany varChar(32), D_SrcID varChar(20), ' +
       'D_OutFact DateTime, D_OutMan varChar(32), D_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   采购订单明细表: OrderDetail
   *.R_ID: 编号
   *.D_ID: 采购明细号
   *.D_OID: 采购单号
   *.D_PID: 磅单号
   *.D_Card: 采购磁卡号
   *.D_DStatus: 订单状态
   *.D_Area,D_Project: 区域,项目
   *.D_ProType,D_ProID,D_ProName,D_ProPY:供应商
   *.D_XuNi: 虚拟明细
   *.D_SaleID,D_SaleMan:业务员
   *.D_Type: 类型(袋,散)
   *.D_StockNo: 原材料编号
   *.D_StockName: 原材料名称
   *.D_Truck: 车船号
   *.D_Status,D_NextStatus: 状态
   *.D_InTime,D_InMan: 进厂放行
   *.D_PValue,D_PDate,D_PMan: 称皮重
   *.D_MValue,D_MDate,D_MMan: 称毛重
   *.D_YTime,D_YMan: 收货时间,验收人,
   *.D_Value,D_KZValue,D_AKValue: 收货量,验收扣除(明扣),暗扣
   *.D_YLine,D_YLineName: 收货通道
   *.D_YSResult: 验收结果
   *.D_OutFact,D_OutMan: 出厂放行
  -----------------------------------------------------------------------------}

  sSQL_NewDeduct = 'Create Table $Table(R_ID $Inc, D_Stock varChar(32),' +
       'D_Name varChar(80), D_CusID varChar(32), D_CusName varChar(80),' +
       'D_Value $Float, D_Type Char(1), D_Valid Char(1))';
  {-----------------------------------------------------------------------------
   暗扣规则表: Batcode
   *.R_ID: 编号
   *.D_Stock: 物料号
   *.D_Name: 物料名
   *.D_CusID: 客户号
   *.D_CusName: 客户名
   *.D_Value: 取值
   *.D_Type: 类型(F,固定值;P,百分比)
   *.D_Valid: 是否有效(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewWXLog = 'Create Table $Table(R_ID $Inc, L_UserID varChar(50), ' +
       'L_Data varChar(2000), L_MsgID varChar(20), L_Result varChar(150),' +
       'L_Count Integer Default 0, L_Status Char(1), ' +
       'L_Comment varChar(100), L_Date DateTime)';
  {-----------------------------------------------------------------------------
   微信发送日志:WeixinLog
   *.R_ID:记录编号
   *.L_UserID: 接收者ID
   *.L_Data:微信数据
   *.L_Count:发送次数
   *.L_MsgID: 微信返回标识
   *.L_Result:发送返回信息
   *.L_Status:发送状态(N待发送,I发送中,Y已发送)
   *.L_Comment:备注
   *.L_Date: 发送时间
  -----------------------------------------------------------------------------}

  sSQL_NewWXMatch = 'Create Table $Table(R_ID $Inc, M_ID varChar(15), ' +
       'M_WXID varChar(50), M_WXName varChar(64), M_WXFactory varChar(15), ' +
       'M_IsValid Char(1), M_Comment varChar(100), ' +
       'M_AttentionID varChar(32), M_AttentionType Char(1))';
  {-----------------------------------------------------------------------------
   微信账户:WeixinMatch
   *.R_ID:记录编号
   *.M_ID: 微信编号
   *.M_WXID:开发ID
   *.M_WXName:微信名
   *.M_WXFactory:微信注册工厂编码
   *.M_IsValid: 是否有效
   *.M_Comment: 备注             
   *.M_AttentionID,M_AttentionType: 微信关注客户ID,类型(S、业务员;C、客户;G、管理员)
  -----------------------------------------------------------------------------}

  sSQL_NewWXTemplate = 'Create Table $Table(R_ID $Inc, W_Type varChar(15), ' +
       'W_TID varChar(50), W_TFields varChar(64), ' +
       'W_TComment Char(300), W_IsValid Char(1))';
  {-----------------------------------------------------------------------------
   微信账户:WeixinMatch
   *.R_ID:记录编号
   *.W_Type:类型
   *.W_TID:标识
   *.W_TFields:数据域段
   *.W_IsValid: 是否有效
   *.W_TComment: 备注
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo, D_ParamA, ' +
         'D_ParamB From $Table Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table:数据字典表
   *.$Name:字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
         'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table:扩展信息表
   *.$Group:分组名称
   *.$ID:信息标识
  -----------------------------------------------------------------------------}

  sQuery_ZhiKa = 'Select Z_ID,Z_Name,Z_Freeze,Z_Card, Z_CardNO, Z_Password,' +
         'Z_Customer,Z_InValid,' +
         'Z_TJStatus From $Table Where Z_ID=''$ZID'' Order By Z_ID ASC';
  {-----------------------------------------------------------------------------
   从纸卡表中读取数据信息
   *.$Table:订单表
   *.$ZID:订单编号
  -----------------------------------------------------------------------------}

  sQuery_ZhiKaDtl = 'Select D_ZID, D_Type, D_StockNo, D_StockName, D_Price,' +
         'D_Value From $Table Where D_ZID=''$DZID'' Order By D_StockNo ASC';
  {-----------------------------------------------------------------------------
   从纸卡表中读取数据信息
   *.$Table:订单明细表
   *.$DZID:订单编号
  -----------------------------------------------------------------------------}

function CardStatusToStr(const nStatus: string): string;
//磁卡状态
function TruckStatusToStr(const nStatus: string): string;
//车辆状态
function BillTypeToStr(const nType: string): string;
//订单类型
function PostTypeToStr(const nPost: string): string;
//岗位类型
function BusinessToStr(const nBus: string): string;
//交易类型
{$IFDEF SHXZY}
function SealToStr(const nSeal, nStockName: string): string;
//Desc: 将nSeal转为可读内容
{$ENDIF}

implementation

{$IFDEF SHXZY}
//Desc: 将nStatus转为可读内容
function SealToStr(const nSeal, nStockName: string): string;
var nStr: string;
    nPos: Integer;
begin
  nStr := nSeal;
  nPos := Pos('-', nSeal);
  if nPos > 0 then System.Delete(nStr, 1, nPos);

  if Pos('32.5', nStockName) > 0 then Result := 'S' + nStr else
  if Pos('42.5', nStockName) > 0 then Result := 'O' + nStr else
  if Pos('52.5', nStockName) > 0 then Result := 'P' + nStr else Result := nSeal;
end;
{$ENDIF}

//Desc: 将nStatus转为可读内容
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '空闲' else
  if nStatus = sFlag_CardUsed then Result := '正常' else
  if nStatus = sFlag_CardLoss then Result := '挂失' else
  if nStatus = sFlag_CardInvalid then Result := '注销' else Result := '未知';
end;

//Desc: 将nStatus转为可识别的内容
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '进厂' else
  if nStatus = sFlag_TruckOut then Result := '出厂' else
  if nStatus = sFlag_TruckBFP then Result := '称皮重' else
  if nStatus = sFlag_TruckBFM then Result := '称毛重' else
  if nStatus = sFlag_TruckSH then Result := '送货中' else
  if nStatus = sFlag_TruckXH then Result := '验收处' else
  if nStatus = sFlag_TruckFH then Result := '放灰处' else
  if nStatus = sFlag_TruckZT then Result := '栈台' else Result := '未进厂';
end;

//Desc: 交货单类型转为可识别内容
function BillTypeToStr(const nType: string): string;
begin
  if nType = sFlag_TypeShip then Result := '船运' else
  if nType = sFlag_TypeZT   then Result := '栈台' else
  if nType = sFlag_TypeVIP  then Result := 'VIP' else Result := '普通';
end;

//Desc: 将岗位转为可识别内容
function PostTypeToStr(const nPost: string): string;
begin
  if nPost = sFlag_TruckIn   then Result := '门卫进厂' else
  if nPost = sFlag_TruckOut  then Result := '门卫出厂' else
  if nPost = sFlag_TruckBFP  then Result := '磅房称皮' else
  if nPost = sFlag_TruckBFM  then Result := '磅房称重' else
  if nPost = sFlag_TruckFH   then Result := '散装放灰' else
  if nPost = sFlag_TruckZT   then Result := '袋装栈台' else Result := '厂外';
end;

//Desc: 业务类型转为可识别内容
function BusinessToStr(const nBus: string): string;
begin
  if nBus = sFlag_Sale       then Result := '销售' else
  if nBus = sFlag_Provide    then Result := '供应' else
  if nBus = sFlag_Returns    then Result := '退货' else
  if nBus = sFlag_Refund     then Result := '退购' else
  if nBus = sFlag_Other      then Result := '其它';
end;

//------------------------------------------------------------------------------
//Desc: 添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: 系统表
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);
  //系统基本

  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);
  AddSysTableItem(sTable_SerialStatus, sSQL_NewSerialStatus);
  AddSysTableItem(sTable_StockMatch, sSQL_NewStockMatch);
  AddSysTableItem(sTable_WorkePC, sSQL_NewWorkePC);
  //编号与验证

  AddSysTableItem(sTable_CusAddr, sSQL_NewCusAddr);
  AddSysTableItem(sTable_Customer, sSQL_NewCustomer);
  AddSysTableItem(sTable_Salesman, sSQL_NewSalesMan);
  AddSysTableItem(sTable_SaleContract, sSQL_NewSaleContract);
  AddSysTableItem(sTable_SContractExt, sSQL_NewSContractExt);
  AddSysTableItem(sTable_TransContract, sSQL_NewTransContract);

  AddSysTableItem(sTable_CusCredit, sSQL_NewCusCredit);
  AddSysTableItem(sTable_CusAccount, sSQL_NewCusAccount);
  AddSysTableItem(sTable_InOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_TransCredit, sSQL_NewCusCredit);
  AddSysTableItem(sTable_TransAccount, sSQL_NewCusAccount);
  AddSysTableItem(sTable_TransInOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_CompensateAccount, sSQL_NewCusAccount);
  AddSysTableItem(sTable_CompensateInOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_SysShouJu, sSQL_NewSysShouJu);
  AddSysTableItem(sTable_CusAccDetail, sSQL_NewCusAccDetial);
  //客户帐户信息与销售合同

  AddSysTableItem(sTable_Card, sSQL_NewCard);
  AddSysTableItem(sTable_Bill, sSQL_NewBill);
  AddSysTableItem(sTable_BillBak, sSQL_NewBill);
  AddSysTableItem(sTable_ZhiKa, sSQL_NewZhiKa);
  AddSysTableItem(sTable_FXZhiKa,sSQL_NewFXZhiKa);
  AddSysTableItem(sTable_MYZhiKa,sSQL_NewMYZhiKa);
  AddSysTableItem(sTable_ZhiKaDtl, sSQL_NewZhiKaDtl);
  AddSysTableItem(sTable_FLZhiKa, sSQL_NewZhiKa);
  AddSysTableItem(sTable_FLZhiKaDtl, sSQL_NewZhiKaDtl);
  AddSysTableItem(sTable_ICCardInfo,sSQL_NewICCardInfo);
  //提货单信息

  AddSysTableItem(sTable_Refund, sSQL_NewRefund);
  AddSysTableItem(sTable_RefundBak, sSQL_NewRefund);

  AddSysTableItem(sTable_Truck, sSQL_NewTruck);
  AddSysTableItem(sTable_TruckLog, sSQL_NewTruckLog);
  AddSysTableItem(sTable_ZTLines, sSQL_NewZTLines);
  AddSysTableItem(sTable_Batcode, sSQL_NewBatcode);
  AddSysTableItem(sTable_BatcodeDoc, sSQL_NewBatcodeDoc);
  AddSysTableItem(sTable_StockParam, sSQL_NewStockParam);
  AddSysTableItem(sTable_StockParamExt, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockRecord, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockRecordExt, sSQL_NewStockRecordExt);
  AddSysTableItem(sTable_StockHuaYan, sSQL_NewStockHuaYan);

  AddSysTableItem(sTable_ZTTrucks, sSQL_NewZTTrucks);
  AddSysTableItem(sTable_PoundLog, sSQL_NewPoundLog);
  AddSysTableItem(sTable_PoundBak, sSQL_NewPoundLog);
  AddSysTableItem(sTable_Picture, sSQL_NewPicture);

  AddSysTableItem(sTable_Deduct, sSQL_NewDeduct);
  AddSysTableItem(sTable_Provider, ssql_NewProvider);
  AddSysTableItem(sTable_Materails, sSQL_NewMaterails);  
  AddSysTableItem(sTable_Order, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderBak, sSQL_NewOrder);
  AddSysTableItem(sTable_OrderDtl, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderDtlBak, sSQL_NewOrderDtl);
  AddSysTableItem(sTable_OrderBase, sSQL_NewOrderBase);
  AddSysTableItem(sTable_OrderBaseBak, sSQL_NewOrderBase);

  AddSysTableItem(sTable_WeixinLog, sSQL_NewWXLog);
  AddSysTableItem(sTable_WeixinMatch, sSQL_NewWXMatch);
  AddSysTableItem(sTable_WeixinTemp, sSQL_NewWXTemplate);
end;

//Desc: 清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


