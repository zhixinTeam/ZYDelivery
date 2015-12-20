{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数

  cShouJuIDLength       = 7;                         //财务收据标识长度
  cItemIconIndex        = 11;                        //默认的提货单列表图标
const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志
  cFI_FrameAuthorize    = $0003;                     //系统授权

  cFI_FrameCustomer     = $0007;                     //客户管理
  cFI_FrameSalesMan     = $0008;                     //业务员
  cFI_FrameSaleContract = $0009;                     //销售合同
  cFI_FrameTransContract= $0019;                     //销售合同

  cFI_FrameZhiKa        = $0010;                     //办理纸卡(订单)
  cFI_FrameZhiKaVerify  = $0011;                     //纸卡(订单)审核
  cFI_FrameBill         = $0015;                     //开提货单
  cFI_FrameFXZhiKa      = $0016;                     //办提货卡
  cFI_FrameBillQuery    = $0017;                     //开单查询
  cFI_FrameMakeOCard    = $0018;                     //办理采购磁卡

  cFI_FrameMakeCard     = $0020;                     //办理磁卡
  cFI_FrameShouJu       = $0021;                     //收据查询
  cFI_FramePayment      = $0022;                     //销售回款
  cFI_FrameCusCredit    = $0023;                     //信用管理
  cFI_FrameTransPayment = $0024;                     //运费回款
  cFI_FrameTransCredit  = $0025;                     //信用管理

  cFI_FrameLadingDai    = $0030;                     //袋装提货
  cFI_FramePoundQuery   = $0031;                     //磅房查询
  cFI_FrameFangHuiQuery = $0032;                     //放灰查询
  cFI_FrameZhanTaiQuery = $0033;                     //栈台查询
  cFI_FrameZTDispatch   = $0034;                     //栈台调度
  cFI_FramePoundManual  = $0035;                     //手动称重
  cFI_FramePoundAuto    = $0036;                     //自动称重

  cFI_FrameCusAddr      = $0040;                     //送货地址管理
  cFI_FrameTransTruck   = $0044;                     //运输车辆管理

  cFI_FrameTruckQuery   = $0050;                     //车辆查询
  cFI_FrameCusAccountQuery = $0051;                  //客户账户
  cFI_FrameCusInOutMoney   = $0052;                  //出入金明细
  cFI_FrameSaleTotalQuery  = $0053;                  //累计发货
  cFI_FrameSaleDetailQuery = $0054;                  //发货明细
  cFI_FrameZhiKaDetail  = $0055;                     //纸卡明细
  cFI_FrameDispatchQuery = $0056;                    //调度查询
  cFI_FrameOrderDetailQuery = $0057;                 //采购明细
  cFI_FrameTransAccountQuery = $0058;                  //客户运费
  cFI_FrameTransInOutMoney   = $0059;                  //出入金明细

  cFI_FrameTrucks       = $0070;                     //车辆档案
  cFI_FrameTruckLogs    = $0071;                     //车辆档案
  cFI_FrameBatch        = $0076;                     //批次管理
  cFI_FrameBatchQuery   = $0077;                     //批次管理

  cFI_FrameStock        = $0081;                     //品种管理
  cFI_FrameStockRecord  = $0084;                     //检验记录
  cFI_FrameStockHuaYan  = $0082;                     //开化验单
  cFI_FrameStockHY_Each = $0083;                     //随车开单


  cFI_FrameProvider     = $0104;                     //供应
  cFI_FrameProvideLog   = $0105;                     //供应日志
  cFI_FrameMaterails    = $0106;                     //原材料
  cFI_FrameOrder        = $0107;                     //采购订单
  cFI_FrameOrderBase    = $0108;                     //采购申请单
  cFI_FrameOrderDetail  = $0109;                     //采购明细
  cFI_FrameDeduct       = $0110;                     //暗扣规则

  {*Form ID*}
  cFI_FormMemo          = $1000;                     //备注窗口
  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormAuthorize     = $1003;                     //安全验证
  cFI_FormIncInfo       = $1004;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码

  cFI_FormAreaInfo      = $1006;                     //区域信息 
  cFI_FormCustomer      = $1007;                     //客户资料
  cFI_FormSaleMan       = $1008;                     //业务员
  cFI_FormSaleContract  = $1009;                     //销售合同
  cFI_FormTransContract = $1019;                     //销售合同

  cFI_FormZhiKa         = $1010;                     //纸卡(订单)办理
  cFI_FormZhiKaVerify   = $1011;                     //纸卡(订单)审核
  cFI_FormZhiKaAdjust   = $1012;                     //纸卡(订单)调整
  cFI_FormZhiKaFixMoney = $1013;                     //限提金额
  cFI_FormZhiKaParam    = $1014;                     //纸卡(订单)参数
  cFI_FormBill          = $1015;                     //开提货单
  cFI_FormFXZhiKa       = $1016;                     //分销订单
  cFI_FormBillAdditional= $1017;                     //补提货单
  cFI_FormFactZhiKaBind = $1018;                     //绑定订单

  cFI_FormMakeCard      = $1020;                     //办理磁卡
  cFI_FormReadICCard    = $1023;                     //办理磁卡
  cFI_FormMakeRFIDCard  = $1021;                     //办理电子标签
  cFI_FormShouJu        = $1022;                     //开收据

  cFI_FormCusAddr       = $1040;                     //送货地址管理
  cFI_FormTransTruck    = $1044;                     //送货车辆管理

  cFI_FormGetTruck      = $1047;                     //选择车辆
  cFI_FormGetContract   = $1048;                     //选择合同
  cFI_FormGetCustom     = $1049;                     //选择客户
  cFI_FormGetStockNo    = $1050;                     //选择编号
  cFI_FormGetZhika      = $1046;                     //选择纸卡(订单)
  cFI_FormGetFXZhiKa    = $1045;                     //选择分销订单
  cFI_FormGetProvider   = $1041;                     //选择供应商
  cFI_FormGetMeterail   = $1042;                     //选择原材料
  cFI_FormGetBill       = $1043;                     //选择交货单
  cFI_FormGetFactZhika  = $1052;                     //选择工厂纸卡(订单)

  cFI_FormCusCredit     = $1064;                     //信用变动
  cFI_FormPayment       = $1066;                     //销售回款
  cFI_FormPaymentZK     = $1067;                     //纸卡(订单)回款
  cFI_FormFreezeZK      = $1068;                     //冻结纸卡(订单)
  cFI_FormAdjustPrice   = $1069;                     //纸卡(订单)调价

  cFI_FormTrucks        = $1070;                     //车辆档案
  cFI_FormTruckIn       = $1071;                     //车辆进厂
  cFI_FormTruckOut      = $1072;                     //车辆出厂
  cFI_FormLadDai        = $1073;                     //袋装提货
  cFI_FormLadSan        = $1074;                     //散装提货
  cFI_FormZTLine        = $1075;                     //装车线
  cFI_FormBatch         = $1076;                     //批次管理
  cFI_FormBatchEdit     = $1077;                     //批次管理

  cFI_FormStockParam    = $1081;                     //品种管理
  cFI_FormStockHuaYan   = $1082;                     //开化验单
  cFI_FormStockHY_Each  = $1083;                     //随车开单

  cFI_FormProvider      = $1104;                     //供应商
  cFI_FormMaterails     = $1106;                     //原材料
  cFI_FormOrder         = $1107;                     //采购订单
  cFI_FormOrderBase     = $1108;                     //采购订单
  cFI_FormPurchase      = $1155;                     //采购验收
  cFI_FormGetPOrderBase  = $1109;                     //采购订单
  cFI_FormDeduct        = $1110;                     //暗扣规则


  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FRecMenuMax : integer;                           //导航栏个数
    FIconFile   : string;                            //图标配置文件
    FUsesBackDB : Boolean;                           //使用备份库

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称
    FHardMonURL : string;                            //硬件守护

    FFactNum    : string;                            //工厂编号
    FSerialID   : string;                            //电脑编号
    FCustomer   : string;                            //关注客户编号
    FIsManual   : Boolean;                           //手动过磅
    FAutoPound  : Boolean;                           //自动称重

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //袋装正误差
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //袋装负误差
    FDaiPercent : Boolean;                           //按比例计算偏差
    FDaiWCStop  : Boolean;                           //不允许袋装偏差
    FPoundSanF  : Double;                            //散装负误差
    FSanStop    : Boolean;                           //不允许散装超发
    FPicBase    : Integer;                           //图片索引
    FPicPath    : string;                            //图片目录
    FVoiceUser  : Integer;                           //语音计数
    FProberUser : Integer;                           //检测器技术
  end;
  //系统参数

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引
  sCameraDir          = 'Camera\';                   //抓拍目录

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接
  sDBConfig_bk        = 'isbk';                      //备份库

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: 菜单模块映射表
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);

  AddMenuModuleItem('MAIN_B01', cFI_FormAreaInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameSaleContract);
  AddMenuModuleItem('MAIN_B05', cFI_FrameTransContract);
  AddMenuModuleItem('MAIN_B06', cFI_FrameTrucks);

  AddMenuModuleItem('MAIN_C01', cFI_FrameZhiKaVerify);
  AddMenuModuleItem('MAIN_C02', cFI_FramePayment);
  AddMenuModuleItem('MAIN_C03', cFI_FrameCusCredit);
  AddMenuModuleItem('MAIN_C04', cFI_FrameTransPayment);
  AddMenuModuleItem('MAIN_C05', cFI_FrameTransCredit);
  AddMenuModuleItem('MAIN_C07', cFI_FrameShouJu);
  AddMenuModuleItem('MAIN_C12', cFI_FormPayment, mtForm);
  AddMenuModuleItem('MAIN_C13', cFI_FormCusCredit, mtForm);
  AddMenuModuleItem('MAIN_C14', cFI_FormPayment, mtForm);
  AddMenuModuleItem('MAIN_C15', cFI_FormCusCredit, mtForm);

  AddMenuModuleItem('MAIN_D01', cFI_FormZhiKa, mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormBillAdditional, mtForm);
  AddMenuModuleItem('MAIN_D05', cFI_FrameZhiKa);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D09', cFI_FrameFXZhiKa);
  AddMenuModuleItem('MAIN_D08', cFI_FormFXZhiKa, mtForm);

  AddMenuModuleItem('MAIN_E01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_E02', cFI_FramePoundAuto);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZTDispatch);
  AddMenuModuleItem('MAIN_F05', cFI_FormPurchase, mtForm);

  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  //AddMenuModuleItem('MAIN_J02', cFI_FrameBatch);
  //AddMenuModuleItem('MAIN_J03', cFI_FrameBatchQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K04', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K03', cFI_FormStockHuaYan, mtForm);
  AddMenuModuleItem('MAIN_K05', cFI_FormStockHY_Each, mtForm);
  AddMenuModuleItem('MAIN_K06', cFI_FrameStockHY_Each);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_L02', cFI_FrameCusAccountQuery);
  AddMenuModuleItem('MAIN_L03', cFI_FrameCusInOutMoney);
  AddMenuModuleItem('MAIN_L05', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L08', cFI_FrameZhiKaDetail);
  AddMenuModuleItem('MAIN_L09', cFI_FrameOrderDetailQuery);
  AddMenuModuleItem('MAIN_L12', cFI_FrameTransAccountQuery);
  AddMenuModuleItem('MAIN_L13', cFI_FrameTransInOutMoney);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameMakeOCard); 
  AddMenuModuleItem('MAIN_M04', cFI_FrameOrder);
  AddMenuModuleItem('MAIN_M05', cFI_FrameDeduct);
  AddMenuModuleItem('MAIN_M08', cFI_FrameOrderDetail);
  AddMenuModuleItem('MAIN_M09', cFI_FrameOrderBase);

  AddMenuModuleItem('MAIN_N01', cFI_FormZhiKa, mtForm);
  AddMenuModuleItem('MAIN_N02', cFI_FormFactZhiKaBind, mtForm);
  AddMenuModuleItem('MAIN_N03', cFI_FrameZhiKa);
  AddMenuModuleItem('MAIN_N04', cFI_FrameFXZhiKa);

  AddMenuModuleItem('MAIN_Y01', cFI_FormTransContract, mtForm);  
  AddMenuModuleItem('MAIN_Y02', cFI_FrameTruckLogs);
  AddMenuModuleItem('MAIN_Y03', cFI_FrameCusAddr);
  AddMenuModuleItem('MAIN_Y04', cFI_FrameTransTruck);
end;

//Desc: 清理模块列表
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


