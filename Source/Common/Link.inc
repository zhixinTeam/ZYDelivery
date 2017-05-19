//----------------------------------- 通用 -------------------------------------
{.$DEFINE DEBUG}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境

{.$DEFINE EnableBackupDB}
//备用数据库支持
{.$DEFINE EnableDoubleDB}
//双数据库支持

//---------------------------------- 中间件 ------------------------------------
{.$DEFINE ClientMon}
//进程守护客户端

{.$DEFINE GenRODL}
//生成RODL资源

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {$DEFINE ChannelPool}
  //启用通道支持
  {$DEFINE Remote2MIT}
  //启用中间件互访
  {.$DEFINE AutoChannel}
  //启用通道平衡
  {.$DEFINE SAP}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//--------------------------------- 特定系统 -----------------------------------
{$DEFINE COMMON}
//通用版本

{$DEFINE SHXZY}
//特定系统

//山西卓越
{$IFDEF SHXZY}
  {$DEFINE HardMon}
  //编译硬件守护
  {$DEFINE MasterSys}
  //编译主服务系统
  {$DEFINE HYRFID201}
  //华益读头
  {$DEFINE AppAtTaskBar}
  //状态栏显示
{$ENDIF}

{$IFDEF MYGS}
  {$DEFINE SHXZY}
  //山西卓越
  {$DEFINE EnableBackupDB}
  //备用数据库支持
  {$DEFINE EnableDoubleDB}
  //双数据库支持
{$ENDIF}
