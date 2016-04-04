unit UYBLEDSDK;

interface

uses
  Windows, Classes, SysUtils;

const
  cDLL        = 'BX_IV.dll';

  cSend_FileRTF = 'LED.rtf';
  cSend_File    = 'LED.txt';

//==============================================================================
// 用户发送信息命令表
  SEND_CMD_PARAMETER = $A1FF; //加载屏参数。
  SEND_CMD_SCREENSCAN = $A1FE; //设置扫描方式。
  SEND_CMD_SENDALLPROGRAM = $A1F0; //发送所有节目信息。
  SEND_CMD_POWERON  = $A2FF; //强制开机
  SEND_CMD_POWEROFF = $A2FE; //强制关机
  SEND_CMD_TIMERPOWERONOFF = $A2FD; //定时开关机
  SEND_CMD_CANCEL_TIMERPOWERONOFF = $A2FC; //取消定时开关机
  SEND_CMD_RESIVETIME = $A2FB; //校正时间。
  SEND_CMD_ADJUSTLIGHT = $A2FA; //亮度调整。

//==============================================================================
//==============================================================================
// 控制器通讯模式
  SEND_MODE_COMM    = 0;
  SEND_MODE_NET     = 2;
  SEND_MODE_WIFI    = 4;
//==============================================================================
//==============================================================================
// 通讯错误返回代码值
  RETURN_ERROR_NOSUPPORT_USB = $F6; //不支持USB模式；
  RETURN_ERROR_NO_USB_DISK = $F5; //找不到usb设备路径；
  RETURN_ERROR_AERETYPE = $F7; //区域类型错误，在添加图文区域文件时区域类型出错返回此类型错误。
  RETURN_ERROR_RA_SCREENNO = $F8; //已经有该显示屏信息。如要重新设定请先DeleteScreen删除该显示屏再添加；
  RETURN_ERROR_NOFIND_AREAFILE = $F9; //没有找到有效的区域文件(图文区域)；
  RETURN_ERROR_NOFIND_AREA = $FA; //没有找到有效的显示区域；可以使用AddScreenProgramBmpTextArea添加区域信息。
  RETURN_ERROR_NOFIND_PROGRAM = $FB; //没有找到有效的显示屏节目；可以使用AddScreenProgram函数添加指定节目
  RETURN_ERROR_NOFIND_SCREENNO = $FC; //系统内没有查找到该显示屏；可以使用AddScreen函数添加显示屏
  RETURN_ERROR_NOW_SENDING = $FD; //系统内正在向该显示屏通讯，请稍后再通讯；
  RETURN_ERROR_OTHER = $FF; //其它错误；
  RETURN_NOERROR    = 0; //没有错误

//------------------------------------------------------------------------------

//==============================================================================
  Screen_Control    : array[0..61] of String =
    ('BX-5AT'
    , 'BX-5A0'
    , 'BX-5A1'
    , 'BX-5A1&WiFi'
    , 'BX-5A2'
    , 'BX-5A2&RF'
    , 'BX-5A2&WiFi'
    , 'BX-5A3'
    , 'BX-5A4'
    , 'BX-5A4&RF'
    , 'BX-5A4&WiFi'
    , 'BX-5M1'
    , 'BX-5M2'
    , 'BX-5M3'
    , 'BX-5M4'
    , 'BX-5UT'
    , 'BX-5U0'
    , 'BX-5U1'
    , 'BX-5U2'
    , 'BX-5U3'
    , 'BX-5U4'
    , 'BX-5E2'
    , 'BX-5E3'
    , 'BX-5E1'
    , 'BX-4T1'
    , 'BX-4T2'
    , 'BX-4T3'
    , 'BX-4A1'
    , 'BX-4A2'
    , 'BX-4A3'
    , 'BX-4AQ'
    , 'BX-4A'
    , 'BX-4UT'
    , 'BX-4U0'
    , 'BX-4U1'
    , 'BX-4U2'
    , 'BX-4U2X'
    , 'BX-4U3'
    , 'BX-4M0'
    , 'BX-4M1'
    , 'BX-4M'
    , 'BX-4MC'
    , 'BX-4C'
    , 'BX-4E1'
    , 'BX-4E'
    , 'BX-4EL'
    , 'BX-3T'
    , 'BX-3A1'
    , 'BX-3A2'
    , 'BX-3A'
    , 'BX-3M'
    , 'BX-5Q1'
    , 'BX-5Q2'
    , 'BX-5QS1'
    , 'BX-5QS2'
    , 'BX-5QS'
    , 'BX-5Q0+'
    , 'BX-5Q1+'
    , 'BX-5Q2+'
    , 'BX-5QS1+'
    , 'BX-5QS2+'
    , 'BX-5QS+');
//------------------------------------------------------------------------------
// 控制器类型列表序号
  CONTROLLER_BX_5AT_INDEX = 0;
  CONTROLLER_BX_5A0_INDEX = 1;
  CONTROLLER_BX_5A1_INDEX = 2;
  CONTROLLER_BX_5A1_WiFi_INDEX = 3;
  CONTROLLER_BX_5A2_INDEX = 4;
  CONTROLLER_BX_5A2_RF_INDEX = 5;
  CONTROLLER_BX_5A2_WiFi_INDEX = 6;
  CONTROLLER_BX_5A3_INDEX = 7;
  CONTROLLER_BX_5A4_INDEX = 8;
  CONTROLLER_BX_5A4_RF_INDEX = 9;
  CONTROLLER_BX_5A4_WiFi_INDEX = 10;
  CONTROLLER_BX_5M1_INDEX = 11;
  CONTROLLER_BX_5M2_INDEX = 12;
  CONTROLLER_BX_5M3_INDEX = 13;
  CONTROLLER_BX_5M4_INDEX = 14;
  CONTROLLER_BX_5UT_INDEX = 15;
  CONTROLLER_BX_5U0_INDEX = 16;
  CONTROLLER_BX_5U1_INDEX = 17;
  CONTROLLER_BX_5U2_INDEX = 18;
  CONTROLLER_BX_5U3_INDEX = 19;
  CONTROLLER_BX_5U4_INDEX = 20;
  CONTROLLER_BX_5E2_INDEX = 21;
  CONTROLLER_BX_5E3_INDEX = 22;
  CONTROLLER_BX_5E1_INDEX = 23;
  CONTROLLER_BX_4T1_INDEX = 24;
  CONTROLLER_BX_4T2_INDEX = 25;
  CONTROLLER_BX_4T3_INDEX = 26;
  CONTROLLER_BX_4A1_INDEX = 27;
  CONTROLLER_BX_4A2_INDEX = 28;
  CONTROLLER_BX_4A3_INDEX = 29;
  CONTROLLER_BX_4AQ_INDEX = 30;
  CONTROLLER_BX_4A_INDEX = 31;
  CONTROLLER_BX_4UT_INDEX = 32;
  CONTROLLER_BX_4U0_INDEX = 33;
  CONTROLLER_BX_4U1_INDEX = 34;
  CONTROLLER_BX_4U2_INDEX = 35;
  CONTROLLER_BX_4U2X_INDEX = 36;
  CONTROLLER_BX_4U3_INDEX = 37;
  CONTROLLER_BX_4M0_INDEX = 38;
  CONTROLLER_BX_4M1_INDEX = 39;
  CONTROLLER_BX_4M_INDEX = 40;
  CONTROLLER_BX_4MC_INDEX = 41;
  CONTROLLER_BX_4C_INDEX = 42;
  CONTROLLER_BX_4E1_INDEX = 43;
  CONTROLLER_BX_4E_INDEX = 44;
  CONTROLLER_BX_4EL_INDEX = 45;
  CONTROLLER_BX_3T_INDEX = 46;
  CONTROLLER_BX_3A1_INDEX = 47;
  CONTROLLER_BX_3A2_INDEX = 48;
  CONTROLLER_BX_3A_INDEX = 49;
  CONTROLLER_BX_3M_INDEX = 50;
  CONTROLLER_BX_5Q0P_INDEX = 56;
  CONTROLLER_BX_5Q1P_INDEX = 57;
  CONTROLLER_BX_5Q2P_INDEX = 58;
  CONTROLLER_BX_5QS1P_INDEX = 59;
  CONTROLLER_BX_5QS2P_INDEX = 60;
  CONTROLLER_BX_5QSP_INDEX = 61;

//------------------------------------------------------------------------------
// 控制器类型
  CONTROLLER_BX_5AT = $0051;
  CONTROLLER_BX_5A0 = $0151;
  CONTROLLER_BX_5A1 = $0251;
  CONTROLLER_BX_5A1_WiFi = $0651;
  CONTROLLER_BX_5A2 = $0351;
  CONTROLLER_BX_5A2_RF = $1351;
  CONTROLLER_BX_5A2_WiFi = $0751;
  CONTROLLER_BX_5A3 = $0451;
  CONTROLLER_BX_5A4 = $0551;
  CONTROLLER_BX_5A4_RF = $1551;
  CONTROLLER_BX_5A4_WiFi = $0851;
  CONTROLLER_BX_5M1 = $0052;
  CONTROLLER_BX_5M2 = $0252;
  CONTROLLER_BX_5M3 = $0352;
  CONTROLLER_BX_5M4 = $0452;
  CONTROLLER_BX_5UT = $0055;
  CONTROLLER_BX_5U0 = $0155;
  CONTROLLER_BX_5U1 = $0255;
  CONTROLLER_BX_5U2 = $0355;
  CONTROLLER_BX_5U3 = $0455;
  CONTROLLER_BX_5U4 = $0555;
  CONTROLLER_BX_5E2 = $0254;
  CONTROLLER_BX_5E3 = $0354;
  CONTROLLER_BX_5E1 = $0154;
  CONTROLLER_BX_4T1 = $0140;
  CONTROLLER_BX_4T2 = $0240;
  CONTROLLER_BX_4T3 = $0340;
  CONTROLLER_BX_4A1 = $0141;
  CONTROLLER_BX_4A2 = $0241;
  CONTROLLER_BX_4A3 = $0341;
  CONTROLLER_BX_4AQ = $1041;
  CONTROLLER_BX_4A  = $0041;
  CONTROLLER_BX_4UT = $0445;
  CONTROLLER_BX_4U0 = $0045;
  CONTROLLER_BX_4U1 = $0145;
  CONTROLLER_BX_4U2 = $0245;
  CONTROLLER_BX_4U2X = $0545;
  CONTROLLER_BX_4U3 = $0345;
  CONTROLLER_BX_4M0 = $0242;
  CONTROLLER_BX_4M1 = $0142;
  CONTROLLER_BX_4M  = $0042;
  CONTROLLER_BX_4MC = $0C42;
  CONTROLLER_BX_4C  = $0043;
  CONTROLLER_BX_4E1 = $0144;
  CONTROLLER_BX_4E  = $0044;
  CONTROLLER_BX_4EL = $0844;
  CONTROLLER_BX_3T  = $0010;
  CONTROLLER_BX_3A1 = $0021;
  CONTROLLER_BX_3A2 = $0022;
  CONTROLLER_BX_3A  = $0020;
  CONTROLLER_BX_3M  = $0030;
  CONTROLLER_BX_5Q0P = 4182;
  CONTROLLER_BX_5Q1P = 4438;
  CONTROLLER_BX_5Q2P = 4694;
  CONTROLLER_BX_5QS1P = 4439;
  CONTROLLER_BX_5QS2P = 4695;
  CONTROLLER_BX_5QSP = 4951;
//------------------------------------------------------------------------------

//  function InitDLLResource(nHandle: Integer): integer; stdcall; external cDLL;
//  procedure FreeDLLResource; stdcall; external cDLL;
  //初始化释放

{-------------------------------------------------------------------------------
  过程名:    AddScreen
  向动态库中添加显示屏信息；该函数不与显示屏通讯，只用于动态库中的指定显示屏参数信息配置。
  参数:
    nControlType    :显示屏的控制器型号；详见宏定义“控制器型号定义”
      CONTROLLER_BX-5AT=81
      CONTROLLER_BX-5A0=337;
      CONTROLLER_BX-5A1=593;
      CONTROLLER_BX-5A1_WiFi=1617;
      CONTROLLER_BX-5A=2385;
      CONTROLLER_BX-5A2=849;
      CONTROLLER_BX-5A2_RF=4945;
      CONTROLLER_BX-5A2_WiFi=1873;
      CONTROLLER_BX-5A3=1105;
      CONTROLLER_BX-5A4=1361;
      CONTROLLER_BX-5A4_RF=5457;
      CONTROLLER_BX-5A4_WiFi=2129;
      CONTROLLER_BX-5M1=82;
      CONTROLLER_BX-5M2=594;
      CONTROLLER_BX-5M3=850;
      CONTROLLER_BX-5M4=1106;
      CONTROLLER_BX-5UT=85;
      CONTROLLER_BX-5U0=341;
      CONTROLLER_BX-5U1=597;
      CONTROLLER_BX-5U2=853;
      CONTROLLER_BX-5U3=1109;
      CONTROLLER_BX-5U4=1365;
      CONTROLLER_BX-5E1=340;
      CONTROLLER_BX-5E2=596;
      CONTROLLER_BX-5E3=852;
      CONTROLLER_BX-5Q1=342;
      CONTROLLER_BX-5Q2=598;
      CONTROLLER_BX-5QS1=343;
      CONTROLLER_BX-5QS2=599;
      CONTROLLER_BX-5QS=855;
      CONTROLLER_BX-4T1=320;
      CONTROLLER_BX-4T2=576;
      CONTROLLER_BX-4T3=832;
      CONTROLLER_BX-4A1=321;
      CONTROLLER_BX-4A2=577;
      CONTROLLER_BX-4A3=833;
      CONTROLLER_BX-4AQ=4161;
      CONTROLLER_BX-4A=65;
      CONTROLLER_BX-4UT=1093;
      CONTROLLER_BX-4U0=69;
      CONTROLLER_BX-4U1=325;
      CONTROLLER_BX-4U2=581;
      CONTROLLER_BX-4U2X=1349;
      CONTROLLER_BX-4U3=837;
      CONTROLLER_BX-4M0=578;
      CONTROLLER_BX-4M1=322;
      CONTROLLER_BX-4M=66;
      CONTROLLER_BX-4MC=3138;
      CONTROLLER_BX-4C=67;
      CONTROLLER_BX-4E1=324;
      CONTROLLER_BX-4E=68;
      CONTROLLER_BX-4EL=2116;
      CONTROLLER_BX-3T=16;
      CONTROLLER_BX-3A1=33;
      CONTROLLER_BX-3A2=34;
      CONTROLLER_BX-3A=32;
      CONTROLLER_BX-3M=48;
      CONTROLLER_BX_5Q0+ = 4182;
      CONTROLLER_BX_5Q1+ = 4438;
      CONTROLLER_BX_5Q2+ = 4694;
      CONTROLLER_BX_5QS1+ = 4439;
      CONTROLLER_BX_5QS2+ = 4695;
      CONTROLLER_BX_5QS+ = 4951;

    nScreenNo       :显示屏屏号；该参数与LedshowTW 2013软件中"设置屏参"模块的"屏号"参数一致。
    nWidth          :显示屏宽度 16的整数倍；最小64；BX-5E系列最小为80
    nHeight         :显示屏高度 16的整数倍；最小16；
    nScreenType     :显示屏类型；1：单基色；2：双基色；
      3：双基色；注意：该显示屏类型只有BX-4MC支持；同时该型号控制器不支持其它显示屏类型。
      4：全彩色；注意：该显示屏类型只有BX-5Q系列支持；同时该型号控制器不支持其它显示屏类型。
      5：双基色灰度；注意：该显示屏类型只有BX-5QS支持；同时该型号控制器不支持其它显示屏类型。
    nPixelMode      :点阵类型；1：R+G；2：G+R；该参数只对双基色屏有效 ；默认为2；
    nDataDA         :数据极性；，0x00：数据低有效，0x01：数据高有效；默认为0；
    nDataOE         :OE极性；  0x00：OE 低有效；0x01：OE 高有效；默认为0；
    nRowOrder       :行序模式；0：正常；1：加1行；2：减1行；默认为0；
    nFreqPar        :扫描点频；0~6；默认为0；
    pCom            :串口名称；串口通讯模式时有效；例:COM1
    nBaud           :串口波特率：目前支持9600、57600；默认为57600；
    pSocketIP       :控制卡IP地址，网络通讯模式时有效；例:192.168.0.199；
      本动态库网络通讯模式时只支持固定IP模式，单机直连和网络服务器模式不支持。
    nSocketPort     :控制卡网络端口；网络通讯模式时有效；例：5005
    pWiFiIP         :控制器WiFi模式的IP地址信息；WiFi通讯模式时有效；例:192.168.100.1
    nWiFiPort       :控制卡WiFi端口；WiFi通讯模式时有效；例：5005
    pScreenStatusFile:用于保存查询到的显示屏状态参数保存的INI文件名；
      只有执行查询显示屏状态GetScreenStatus时，该参数才有效
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreen(nControlType, nScreenNo, nWidth, nHeight, nScreenType, nPixelMode: Integer;
    nDataDA, nDataOE: Integer; nRowOrder, nFreqPar: Integer; pCom: PChar; nBaud: Integer;
    pSocketIP: PChar; nSocketPort: Integer; pWiFiIP: PChar; nWiFiPort: Integer; pFileName: PChar): integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgram
  向动态库中指定显示屏添加节目；该函数不与显示屏通讯，只用于动态库中的指定显示屏节目信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramType    :节目类型；0正常节目。
    nPlayLength     :0:表示自动顺序播放；否则表示节目播放的长度；范围1~65535；单位秒
    nStartYear      :节目的生命周期；开始播放时间年份。如果为无限制播放的话该参数值为65535；如2010
    nStartMonth     :节目的生命周期；开始播放时间月份。如11
    nStartDay       :节目的生命周期；开始播放时间日期。如26
    nEndYear        :节目的生命周期；结束播放时间年份。如2011
    nEndMonth       :节目的生命周期；结束播放时间月份。如11
    nEndDay         :节目的生命周期；结束播放时间日期。如26
    nMonPlay        :节目在生命周期内星期一是否播放;0：不播放;1：播放.
    nTuesPlay       :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    nWedPlay        :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    nThursPlay      :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    bFriPlay        :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    nSatPlay        :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    nSunPlay        :节目在生命周期内星期二是否播放;0：不播放;1：播放.
    nStartHour      :节目在当天开始播放时间小时。如8
    nStartMinute    :节目在当天开始播放时间分钟。如0
    nEndHour        :节目在当天结束播放时间小时。如18
    nEndMinute      :节目在当天结束播放时间分钟。如0
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
    function AddScreenProgram(nScreenNo, nProgramType: Integer; nPlayLength: Integer;
    nStartYear, nStartMonth, nStartDay, nEndYear, nEndMonth, nEndDay: Integer;
    nMonPlay, nTuesPlay, nWedPlay, nThursPlay, bFriPlay, nSatPlay, nSunPlay: integer;
    nStartHour, nStartMinute, nEndHour, nEndMinute: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramBmpTextArea:
  向动态库中指定显示屏的指定节目添加图文区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目中的图文区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramBmpTextArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramAreaBmpTextFile
  向动态库中指定显示屏的指定节目的指定图文区域添加文件；
      该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目中指定图文区域的文件信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd        :区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
    pFileName       :文件名称  支持.bmp,jpg,jpeg,rtf,txt等文件类型。
    nShowSingle     :单、多行显示；1：单行显示；0：多行显示；该参数只有在pFileName为txt类型文件时该参数才有效。
    pFontName       :字体名称；支持当前操作系统已经安装的矢量字库；该参数只有pFileName为txt类型文件时该参数才有效。
    nFontSize       :字体字号；支持当前操作系统的字号；该参数只有pFileName为txt类型文件时该参数才有效。
    nBold           :字体粗体；支持1：粗体；0：正常；该参数只有pFileName为txt类型文件时该参数才有效。
    nFontColor      :字体颜色；该参数只有pFileName为txt类型文件时该参数才有效。
    nStunt          :显示特技。
      0x00:随机显示
      0x01:静态
      0x02:快速打出
      0x03:向左移动
      0x04:向左连移
      0x05:向上移动            3T类型控制卡无此特技
      0x06:向上连移            3T类型控制卡无此特技
      0x07:闪烁                3T类型控制卡无此特技
      0x08:飘雪
      0x09:冒泡
      0x0A:中间移出
      0x0B:左右移入
      0x0C:左右交叉移入
      0x0D:上下交叉移入
      0x0E:画卷闭合
      0x0F:画卷打开
      0x10:向左拉伸
      0x11:向右拉伸
      0x12:向上拉伸
      0x13:向下拉伸            3T类型控制卡无此特技
      0x14:向左镭射
      0x15:向右镭射
      0x16:向上镭射
      0x17:向下镭射
      0x18:左右交叉拉幕
      0x19:上下交叉拉幕
      0x1A:分散左拉
      0x1B:水平百页            3T、3A、4A、3A1、3A2、4A1、4A2、4A3、4AQ类型控制卡无此特技
      0x1C:垂直百页            3T、3A、4A、3A1、3A2、4A1、4A2、4A3、4AQ、3M、4M、4M1、4MC类型控制卡无此特技
      0x1D:向左拉幕            3T、3A、4A类型控制卡无此特技
      0x1E:向右拉幕            3T、3A、4A类型控制卡无此特技
      0x1F:向上拉幕            3T、3A、4A类型控制卡无此特技
      0x20:向下拉幕            3T、3A、4A类型控制卡无此特技
      0x21:左右闭合            3T类型控制卡无此特技
      0x22:左右对开            3T类型控制卡无此特技
      0x23:上下闭合            3T类型控制卡无此特技
      0x24:上下对开            3T类型控制卡无此特技
      0x25:向右连移
      0x26:向右连移
      0x27:向下移动            3T类型控制卡无此特技
      0x28:向下连移            3T类型控制卡无此特技
    nRunSpeed       :运行速度；0~63；值越大运行速度越慢。
    nShowTime       :停留时间；0~65525；单位0.5秒

  返回值:           :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pFileName: PChar; nShowSingle: Integer; pFontName: PChar; nFontSize, nBold, nFontColor: Integer;
    nStunt, nRunSpeed, nShowTime: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramTimeArea
  向动态库中指定显示屏的指定节目添加时间区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目中的时间区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramTimeArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramTimeAreaFile
  向动态库中指定显示屏的指定节目的指定时间区域属性；该函数不与显示屏通讯，
  只用于动态库中的指定显示屏指定节目中指定时间区域属性信息配置。
  参数:
    nScreenNo   :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd    :区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
    pInputtxt   :固定文字
    pFontName   :文字的字体
    nSingal     :单行多行，0为单行 1为多行，单行模式下nAlign不起作用
    nAlign      :文字对齐模式，对多行有效，0为左1为中2为右
    nFontSize   :文字的大小
    nBold       :是否加粗，0为不1为是
    nItalic     :是否斜体，0为不1为是
    nUnderline  :是否下滑线，0为不1为是
    nUsetxt     :是否使用固定文字，0为不1为是
    nTxtcolor   :固定文字颜色，传递颜色的10进制 红255 绿65280 黄65535
    nUseymd     :是否使用年月日，0为不1为是
    nYmdstyle   :年月日格式，详见使用说明文档的附件1
    nYmdcolor   :年月日颜色，传递颜色的10进制
    nUseweek    :是否使用星期，0为不1为是
    nWeekstyle  :星期格式，详见使用说明文档的附件1
    nWeekcolor  :星期颜色，传递颜色的10进制
    nUsehns     :是否使用时分秒，0为不1是
    nHnsstyle   :时分秒格式，详见使用说明文档的附件1
    nHnscolor   :时分秒颜色，传递颜色的10进制
    nAutoset    :是否自动设置大小对应宽度，0为不1为是（默认不使用）
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramTimeAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pInputtxt, pFontName: PChar;
    nSingal, nAlign, nFontSize, nBold, nItalic, nUnderline: Integer;
    nUsetxt, nTxtcolor,
    nUseymd, nYmdstyle, nYmdcolor,
    nUseweek, nWeekstyle, nWeekcolor,
    nUsehns, nHnsstyle, nHnscolor, nAutoset: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramLunarArea
  向动态库中指定显示屏的指定节目添加农历区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目中的农历区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramLunarArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramLunarAreaFile
  向动态库中指定显示屏的指定节目的指定农历区域属性；该函数不与显示屏通讯，
  只用于动态库中的指定显示屏指定节目中指定农历区域属性信息配置。
  参数:
    nScreenNo		:显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd	:节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd		:区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
    pInputtxt		:固定文字
    pFontName		:文字的字体
    nSingal			:单行多行，0为单行 1为多行，单行模式下nAlign不起作用
    nAlign			:文字对齐模式，对多行有效，0为左1为中2为右
    nFontSize		:文字的大小
    nBold				:是否加粗，0为不1为是
    nItalic			:是否斜体，0为不1为是
    nUnderline	:是否下滑线，0为不1为是
    nUsetxt			:是否使用固定文字，0为不1为是
    nTxtcolor		:固定文字颜色，传递颜色的10进制
    nUseyear		:是否使用天干，0为不1为是  （辛卯兔年）
    nYearcolor	:天干颜色，传递颜色的10进制
    nUsemonth		:是否使用农历，0为不1为是  （九月三十）
    nMonthcolor	:农历颜色，传递颜色的10进制
    nUsesolar		:是否使用节气，0为不1是
    nSolarcolor	:节气颜色，传递颜色的10进制
    nAutoset		:是否自动设置大小对应宽度，0为不1为是（默认不使用）
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramLunarAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pInputtxt, pFontName: PChar;
    nSingal, nAlign, nFontSize, nBold, nItalic, nUnderline: Integer;
    nUsetxt, nTxtcolor, nUseyear, nYearcolor, nUsemonth, nMonthcolor,
    nUsesolar, nSolarcolor, nAutoset: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramClockArea
  向动态库中指定显示屏的指定节目添加表盘区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目中的表盘区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramClockArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramClockAreaFile
  向动态库中指定显示屏的指定节目的指定表盘区域属性；该函数不与显示屏通讯，
  只用于动态库中的指定显示屏指定节目中指定表盘区域属性信息配置。
  参数:
    nScreenNo			:显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd 	:节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd			:区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
    nusetxt				:是否使用固定文字 0为不1为是
    nusetime			:是否使用年月日时间 0为不1为是
    nuseweek			:是否使用星期 0为不1为是
    ntimeStyle		:年月日时间格式，参考时间区的表格说明
    nWeekStyle		:星期时间格式，参考时间区的表格说明
    ntxtfontsize	:固定文字的字大小
    ntxtfontcolor	:固定文字的颜色；传递颜色的10进制;红255绿65280黄65535
    ntxtbold			:固定文字是否加粗 0为不1为是
    ntxtitalic		:固定文字是否斜体 0为不1为是
    ntxtunderline	:固定文字是否下划线 0为不1为是
    txtleft				:固定文字在表盘区域中的X坐标
    txttop				:固定文字在表盘区域中的Y坐标
    ntimefontsize	:年月日文字的字大小
    ntimefontcolor:年月日文字的颜色； 传递颜色的10进制
    ntimebold			:年月日文字是否加粗 0为不1为是
    ntimeitalic		:年月日文字是否斜体 0为不1为是
    ntimeunderline:年月日文字是否下划线 0为不1为是
    timeleft			:年月日文字在表盘区域中的X坐标
    timetop				:年月日文字在表盘区域中的X坐标
    nweekfontsize	:星期文字的字大小
    nweekfontcolor:星期文字的颜色；传递颜色的10进制
    nweekbold			:星期文字是否加粗 0为不1为是
    nweekitalic		:星期文字是否斜体 0为不1为是
    nweekunderline:星期文字是否下划线 0为不1为是
    weekleft			:星期文字在表盘区域中的X坐标
    weektop				:星期文字在表盘区域中的X坐标
    nclockfontsize:表盘文字的字大小
    nclockfontcolor:表盘文字的颜色；传递颜色的10进制
    nclockbold		:表盘文字是否加粗 0为不1为是
    nclockitalic	:表盘文字是否斜体 0为不1为是
    nclockunderline:表盘文字是否下划线 0为不1为是
    clockcentercolor:表盘中心颜色；传递颜色的10进制
    mhrdotstyle		:3/6/9时点类型 0线形1圆形2方形3数字4罗马
    mhrdotsize		:3/6/9时点尺寸 0-8
    mhrdotcolor		:3/6/9时点颜色；传递颜色的10进制
    hrdotstyle		:3/6/9外的时点类型  0线形1圆形2方形3数字4罗马
    hrdotsize			:3/6/9外的时点尺寸 0-8
    hrdotcolor		:3/6/9外的时点颜色；传递颜色的10进制
    mindotstyle		:分钟点类型  0线形1圆形2方形
    mindotsize		:分钟点尺寸 0-1
    mindotcolor		:分钟点颜色；传递颜色的10进制
    hrhandsize		:时针尺寸 0-8
    hrhandcolor		:时针颜色；传递颜色的10进制
    minhandsize		:分针尺寸 0-8
    minhandcolor	:分针颜色；传递颜色的10进制
    sechandsize		:秒针尺寸 0-8
    sechandcolor	:秒针颜色；传递颜色的10进制
    nAutoset			:自适应位置设置，0为不1为是 如果为1，那txtleft/txttop/ weekleft/weektop/timeleft/timetop需要自己设坐标值
    btxtcontent		:固定文字信息
    btxtfontname	:固定文字字体
    btimefontname	:时间文字字体
    bweekfontname	:星期文字字体
    bclockfontname:表盘文字字体
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramClockAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    nusetxt, nusetime, nuseweek, ntimeStyle, nWeekStyle,
    ntxtfontsize, ntxtfontcolor, ntxtbold, ntxtitalic, ntxtunderline,
    txtleft, txttop, ntimefontsize, ntimefontcolor, ntimebold,
    ntimeitalic, ntimeunderline, timeleft, timetop, nweekfontsize,
    nweekfontcolor, nweekbold, nweekitalic, nweekunderline, weekleft,
    weektop, nclockfontsize, nclockfontcolor, nclockbold, nclockitalic,
    nclockunderline, clockcentersize, clockcentercolor, mhrdotstyle, mhrdotsize,
    mhrdotcolor, hrdotstyle, hrdotsize, hrdotcolor, mindotstyle,
    mindotsize, mindotcolor, hrhandsize, hrhandcolor, minhandsize,
    minhandcolor, sechandsize, sechandcolor, nAutoset: integer; btxtcontent,
    btxtfontname, btimefontname, bweekfontname, bclockfontname: pchar): Integer; stdcall; external cDLL;

  function AddScreenProgramChroArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;

 {-------------------------------------------------------------------------------
  过程名:    AddScreenProgramChroAreaFile
  向动态库中指定显示屏的指定节目的指定计时区域属性；该函数不与显示屏通讯，
  只用于动态库中的指定显示屏指定节目中指定计时区域属性信息配置。
  参数:
    nScreenNo   :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd    :区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。

    pInputtxt   :固定文字
    pDaystr    :天单位
    pHourstr   :小时单位
    pMinstr    :分钟单位
    pSecstr    :秒单位
    pFontName   :文字的字体
    nSingal     :单行多行，0为单行 1为多行，单行模式下nAlign不起作用
    nAlign      :文字对齐模式，对多行有效，0为左1为中2为右
    nFontSize   :文字的大小
    nBold       :是否加粗，0为不1为是
    nItalic     :是否斜体，0为不1为是
    nUnderline  :是否下滑线，0为不1为是
    nTxtcolor   :固定文字颜色，传递颜色的10进制 红255 绿65280 黄65535
    nFontcolor  :计时显示颜色，传递颜色的10进制 红255 绿65280 黄65535

    nShowstr     :是否显示单位，对应于所有的天，时，分，秒单位
    nShowAdd     :是否计时累加显示 默认是累加的
    nUsetxt     :是否使用固定文字，0为不1为是
    nUseDay     :是否使用天，0为不1为是
    nUseHour    :是否使用小时，0为不1为是
    nUseMin     :是否使用分钟，0为不1为是
    nUseSec     :是否使用秒，0为不1为是

    nDayLength     :天显示位数    默认为0 自动
    nHourLength    :小时显示位数  默认为0 自动
    nMinLength     :分显示位数    默认为0 自动
    nSecLength     :秒显示位数    默认为0 自动

    EndYear     :目标年值
    EndMonth   :目标月值
    EndDay     :目标日值
    EndHour    :目标时值
    EndMin     :目标分值
    EndSec     :目标秒值

    nAutoset    :是否自动设置大小对应宽度，0为不1为是（默认不使用）
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}

  function AddScreenProgramChroAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pInputtxt, pDaystr, pHourstr, pMinstr, pSecstr, pFontName: PChar;
    nSingal, nAlign, nFontSize, nBold, nItalic, nUnderline,
    nTxtcolor, nFontcolor,
    nShowstr, nShowAdd, nUseTxt, nUseDay, nUseHour, nUseMin, nUseSec,
    nDayLength, nHourLength, nMinLength, nSecLength,
    EndYear, EndMonth, EndDay, EndHour, EndMin, EndSec,
    nAutoset: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramTemperatureArea
  向动态库中指定显示屏的指定节目添加温度区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏节目中的温度区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
    nSensorType     :温度传感器类型；
      0:"Temp sensor S-T1";
      1:"Temp and hum sensor S-RHT 1";
      2:"Temp and hum sensor S-RHT 2"
    nTemperatureUnit:温度显示单位；0:摄氏度(℃);1:华氏度(℉);2:摄氏度(无)
    nTemperatureMode:温度显示模式；0:整数型；1:小数型。
    nTemperatureUnitScale:温度单位显示比例；50~100;默认为100.
    nTemperatureValueWidth:温度数值字符显示宽度；
    nTemperatureCorrectionPol:温度值误差修正值极性；0；正；1：负
    nTemperatureCondition:温度值误差修正值；
    nTemperatureThreshPol:温度阈值条件；0:表示小于此值触发事情;1:表示大于此值触发条件
    nTemperatureThresh:温度阈值
    nTemperatureColor:正常温度颜色
    nTemperatureErrColor:温度超过阈值时显示的颜色
    pStaticText     :温度区域前缀固定文本;该参数可为空
    pStaticFont     :字体名称；支持当前操作系统已经安装的矢量字库；
    nStaticSize     :字体字号；支持当前操作系统的字号；
    nStaticColor    :字体颜色；
    nStaticBold     :字体粗体；支持1：粗体；0：正常；
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramTemperatureArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer;
    nSensorType,
    nTemperatureUnit,
    nTemperatureMode,
    nTemperatureUnitScale,
    nTemperatureValueWidth,
    nTemperatureCorrectionPol,
    nTemperatureCondition,
    nTemperatureThreshPol,
    nTemperatureThresh,
    nTemperatureColor,
    nTemperatureErrColor: Integer;
    pStaticText,
    pStaticFont: pChar;
    nStaticSize,
    nStaticColor,
    nStaticBold: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramHumidityArea
  向动态库中指定显示屏的指定节目添加湿度区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏节目中的湿度区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
    nSensorType     :湿度传感器类型；
      0:"Temp and hum sensor S-RHT 1";
      1:"Temp and hum sensor S-RHT 2"
    nHumidityUnit   :湿度显示单位；0:相对湿度(%RH);1:相对湿度(无)
    nHumidityMode   :湿度显示模式；0:整数型；1:小数型。
    nHumidityUnitScale:湿度单位显示比例；50~100;默认为100.
    nHumidityValueWidth:湿度数值字符显示宽度；
    nHumidityConditionPol:湿度值误差修正值极性；0；正；1：负
    nHumidityCondition:湿度值误差修正值；
    nHumidityThreshPol:湿度阈值条件；0:表示小于此值触发事情;1:表示大于此值触发条件
    nHumidityThresh :湿度阈值
    nHumidityColor  :正常湿度颜色
    nHumidityErrColor:湿度超过阈值时显示的颜色
    pStaticText     :湿度区域前缀固定文本;该参数可为空
    pStaticFont     :字体名称；支持当前操作系统已经安装的矢量字库；
    nStaticSize     :字体字号；支持当前操作系统的字号；
    nStaticColor    :字体颜色；
    nStaticBold     :字体粗体；支持1：粗体；0：正常；
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramHumidityArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer;
    nSensorType,
    nHumidityUnit,
    nHumidityMode,
    nHumidityUnitScale,
    nHumidityValueWidth,
    nHumidityConditionPol,
    nHumidityCondition,
    nHumidityThreshPol,
    nHumidityThresh,
    nHumidityColor,
    nHumidityErrColor: Integer;
    pStaticText,
    pStaticFont: pChar;
    nStaticSize,
    nStaticColor,
    nStaticBold: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    AddScreenProgramNoiseArea
  向动态库中指定显示屏的指定节目添加噪声区域；该函数不与显示屏通讯，只用于动态库中的指定显示屏节目中的噪声区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nX              :区域的横坐标；显示屏的左上角的横坐标为0；最小值为0
    nY              :区域的纵坐标；显示屏的左上角的纵坐标为0；最小值为0
    nWidth          :区域的宽度；最大值不大于显示屏宽度-nX
    nHeight         :区域的高度；最大值不大于显示屏高度-nY
    nSensorType     :噪声传感器类型；
      0:"I-声级仪";
      1:"II-声级仪"
    nNoiseUnit      :噪声显示单位；0:相对湿度(%RH);1:相对湿度(无)
    nNoiseMode      :噪声显示模式；0:整数型；1:小数型。
    nNoiseUnitScale :噪声单位显示比例；50~100;默认为100.
    nNoiseValueWidth:噪声数值字符显示宽度；
    nNoiseConditionPol:噪声值误差修正值极性；0；正；1：负
    nNoiseCondition :噪声值误差修正值；
    nNoiseThreshPol :噪声阈值条件；0:表示小于此值触发事情;1:表示大于此值触发条件
    nNoiseThresh    :噪声阈值
    nNoiseColor     :正常噪声颜色
    nNoiseErrColor  :噪声超过阈值时显示的颜色
    pStaticText     :噪声区域前缀固定文本;该参数可为空
    pStaticFont     :字体名称；支持当前操作系统已经安装的矢量字库；
    nStaticSize     :字体字号；支持当前操作系统的字号；
    nStaticColor    :字体颜色；
    nStaticBold     :字体粗体；支持1：粗体；0：正常；
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function AddScreenProgramNoiseArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer;
    nSensorType,
    nNoiseUnit,
    nNoiseMode,
    nNoiseUnitScale,
    nNoiseValueWidth,
    nNoiseConditionPol,
    nNoiseCondition,
    nNoiseThreshPol,
    nNoiseThresh,
    nNoiseColor,
    nNoiseErrColor: Integer;
    pStaticText,
    pStaticFont: pChar;
    nStaticSize,
    nStaticColor,
    nStaticBold: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    DeleteScreen
  删除指定显示屏信息，删除显示屏成功后会将该显示屏下所有节目信息从动态库中删除。
  该函数不与显示屏通讯，只用于动态库中的指定显示屏参数信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function DeleteScreen      (nScreenNo: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    DeleteScreenProgram
  删除指定显示屏指定节目，删除节目成功后会将该节目下所有区域信息删除。
  该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function DeleteScreenProgram(nScreenNo, nProgramOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    DeleteScreenProgramArea
  删除指定显示屏指定节目的指定区域，删除区域成功后会将该区域下所有信息删除。
  该函数不与显示屏通讯，只用于动态库中指定显示屏指定节目中指定的区域信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd        :区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function DeleteScreenProgramArea(nScreenNo, nProgramOrd, nAreaOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    DeleteScreenProgramAreaBmpTextFile
  删除指定显示屏指定节目指定图文区域的指定文件，删除文件成功后会将该文件信息删除。
  该函数不与显示屏通讯，只用于动态库中的指定显示屏指定节目指定区域中的指定文件信息配置。
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nProgramOrd     :节目序号；该序号按照节目添加顺序，从0顺序递增，如删除中间的节目，后面的节目序号自动填充。
    nAreaOrd        :区域序号；该序号按照区域添加顺序，从0顺序递增，如删除中间的区域，后面的区域序号自动填充。
    nFileOrd        :文件序号；该序号按照文件添加顺序，从0顺序递增，如删除中间的文件，后面的文件序号自动填充。
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function DeleteScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd, nAreaOrd, nFileOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    SendScreenInfo
  通过指定的通讯模式，发送相应信息、命令到显示屏。该函数与显示屏进行通讯
  参数:
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nSendMode       :与显示屏的通讯模式；
      0:串口模式、BX-5A2&RF、BX-5A4&RF等控制器为RF串口无线模式;
      2:网络模式;
      4:WiFi模式
    nSendCmd        :通讯命令值
      SEND_CMD_PARAMETER =41471;  加载屏参数。
      SEND_CMD_SENDALLPROGRAM = 41456;  发送所有节目信息。
      SEND_CMD_POWERON =41727; 强制开机
      SEND_CMD_POWEROFF = 41726; 强制关机
      SEND_CMD_TIMERPOWERONOFF = 41725; 定时开关机
      SEND_CMD_CANCEL_TIMERPOWERONOFF = 41724; 取消定时开关机
      SEND_CMD_RESIVETIME = 41723; 校正时间。
      SEND_CMD_ADJUSTLIGHT = 41722; 亮度调整。
    nOtherParam1    :保留参数；0
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function SendScreenInfo    (nScreenNo, nSendMode, nSendCmd, nOtherParam1: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    SetScreenTimerPowerONOFF
  设定显示屏的定时开关机参数，可以设置3组开关机时间。该函数不与显示屏通讯，
  只用于动态库中对指定显示屏的定时开关机信息配置。如需将设定的定时开关值发送到显示屏上，
  只需使用SendScreenInfo函数发送定时开关命令即可。
  参数:
    nScreenNo		:显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nOnHour1		:第一组定时开关的开机时间的小时
    nOnMinute1	:第一组定时开关的开机时间的分钟
    nOffHour1		:第一组定时开关的关机时间的小时
    nOffMinute1	:第一组定时开关的关机时间的分钟
    nOnHour2		:第二组定时开关的开机时间的小时
    nOnMinute2	:第二组定时开关的开机时间的分钟
    nOffHour2		:第二组定时开关的关机时间的小时
    nOffMinute2	:第二组定时开关的关机时间的分钟
    nOnHour3		:第三组定时开关的开机时间的小时
    nOnMinute3	:第三组定时开关的开机时间的分钟
    nOffHour3		:第三组定时开关的关机时间的小时
    nOffMinute3	:第三组定时开关的关机时间的分钟
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function SetScreenTimerPowerONOFF(nScreenNo: Integer;
    nOnHour1, nOnMinute1, nOffHour1, nOffMinute1,
    nOnHour2, nOnMinute2, nOffHour2, nOffMinute2,
    nOnHour3, nOnMinute3, nOffHour3, nOffMinute3: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  过程名:    SetScreenAdjustLight
  设定显示屏的亮度调整参数，该函数可设置手工调亮和定时调亮两种模式。该函数不与显示屏通讯，
  只用于动态库中对指定显示屏的亮度调整信息配置。如需将设定的亮度调整值发送到显示屏上，
  只需使用SendScreenInfo函数发送亮度调整命令即可。
  参数:
    nScreenNo		:显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nAdjustType	:亮度调整类型；0：手工调亮；1：定时调亮
    nHandleLight:手工调亮的亮度值，只有nAdjustType=0时该参数有效。
    nHour1			:第一组定时调亮时间的小时
    nMinute1		:第一组定时调亮时间的分钟
    nLight1			:第一组定时调亮的亮度值
    nHour2			:第二组定时调亮时间的小时
    nMinute2		:第二组定时调亮时间的分钟
    nLight2			:第二组定时调亮的亮度值
    nHour3			:第三组定时调亮时间的小时
    nMinute3		:第三组定时调亮时间的分钟
    nLight3			:第三组定时调亮的亮度值
    nHour4			:第四组定时调亮时间的小时
    nMinute4		:第四组定时调亮时间的分钟
    nLight4			:第四组定时调亮的亮度值
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function SetScreenAdjustLight(nScreenNo: Integer; nAdjustType, nHandleLight: Integer;
    nHour1, nMinute1, nLight1,
    nHour2, nMinute2, nLight2,
    nHour3, nMinute3, nLight3,
    nHour4, nMinute4, nLight4: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    SaveUSBScreenInfo
  保存显示屏数据信息到USB设备。方便用户用USB方式更新显示屏信息。该函数与LedshowTW软件配套的USB下载功能一致。
  使用该功能时，注意当前控制器是否支持USB下载功能。
  参数
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    bCorrectTime    :是否校正时间
      0：不校正时间；
      1：校正时间；
    nAdvanceHour    :校正时间比当前计算机时间提前的小时值。范围0~23；只有当bCorrectTime=1时有效。
    nAdvanceMinute  :校正时间比当前计算机时间提前的分钟值。范围0~59；只有当bCorrectTime=1时有效。
    pUSBDisk        :USB设备的路径名称；格式为"盘符:\"的格式；例如："F:\"
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function SaveUSBScreenInfo (nScreenNo: Integer;
    bCorrectTime, nAdvanceHour, nAdvanceMinute: Integer; pUSBDisk: PChar): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  过程名:    GetScreenStatus
  查询当前显示屏状态，将查询状态参数保存到AddScreen函数中的pScreenStatusFile的INI类型文件中。
  该函数与显示屏进行通讯
  参数:      nScreenNo, nSendMode: Integer
    nScreenNo       :显示屏屏号；该参数与AddScreen函数中的nScreenNo参数对应。
    nSendMode       :与显示屏的通讯模式；
      0:串口模式、BX-5A2&RF、BX-5A4&RF等控制器为RF串口无线模式;
      2:网络模式;
      4:WiFi模式
  返回值            :详见返回状态代码定义。
-------------------------------------------------------------------------------}
  function GetScreenStatus(nScreenNo, nSendMode: Integer): Integer; stdcall; external cDLL;

function GetScreenControlTypeValue(nControlTypeIndex: Cardinal): Cardinal;
//获取控制器类型
function GetScreenControlIndex(const nLEDType: String): Cardinal;
//获取索引
function GetErrorDesc(const nErr: Integer): string;
//获取错误描述

type
  TCardCode = record
    FCode: Word;
    FDesc: string;
  end;

const
  cCardEffects: array[0..39] of TCardCode = (
             (FCode: $00; FDesc:'随机显示'),
             (FCode: $01; FDesc:'静态'),
             (FCode: $02; FDesc:'快速打出'),
             (FCode: $03; FDesc:'向左移动'),
             (FCode: $04; FDesc:'向左连移'),
             (FCode: $05; FDesc:'向上移动'),
             (FCode: $06; FDesc:'向上连移'),
             (FCode: $07; FDesc:'闪烁'),
             (FCode: $08; FDesc:'飘雪'),
             (FCode: $09; FDesc:'冒泡'),
             (FCode: $0A; FDesc:'中间移出'),
             (FCode: $0B; FDesc:'左右移入'),
             (FCode: $0C; FDesc:'左右交叉移入'),
             (FCode: $0D; FDesc:'上下交叉移入'),
             (FCode: $0E; FDesc:'画卷闭合'),
             (FCode: $0F; FDesc:'画卷打开'),
             (FCode: $10; FDesc:'向左拉伸'),
             (FCode: $11; FDesc:'向右拉伸'),
             (FCode: $12; FDesc:'向上拉伸'),
             (FCode: $13; FDesc:'向下拉伸'),
             (FCode: $14; FDesc:'向左镭射'),
             (FCode: $15; FDesc:'向右镭射'),
             (FCode: $16; FDesc:'向上镭射'),
             (FCode: $17; FDesc:'向下镭射'),
             (FCode: $18; FDesc:'左右交叉拉幕'),
             (FCode: $19; FDesc:'上下交叉拉幕'),
             (FCode: $1A; FDesc:'分散左拉'),
             (FCode: $1B; FDesc:'水平百页'),
             (FCode: $1D; FDesc:'向左拉幕'),
             (FCode: $1E; FDesc:'向右拉幕'),
             (FCode: $1F; FDesc:'向上拉幕'),
             (FCode: $20; FDesc:'向下拉幕'),
             (FCode: $21; FDesc:'左右闭合'),
             (FCode: $22; FDesc:'左右对开'),
             (FCode: $23; FDesc:'上下闭合'),
             (FCode: $24; FDesc:'上下对开'),
             (FCode: $25; FDesc:'向右连移'),
             (FCode: $26; FDesc:'向右连移'),
             (FCode: $27; FDesc:'向下移动'),
             (FCode: $28; FDesc:'向下连移'));
  //系统支持的特效
implementation

function GetScreenControlTypeValue(nControlTypeIndex: Cardinal): Cardinal;
begin
  case nControlTypeIndex of
    CONTROLLER_BX_5AT_INDEX:
      Result := CONTROLLER_BX_5AT;
    CONTROLLER_BX_5A0_INDEX:
      Result := CONTROLLER_BX_5A0;
    CONTROLLER_BX_5A1_INDEX:
      Result := CONTROLLER_BX_5A1;
    CONTROLLER_BX_5A1_WiFi_INDEX:
      Result := CONTROLLER_BX_5A1_WiFi;
    CONTROLLER_BX_5A2_INDEX:
      Result := CONTROLLER_BX_5A2;
    CONTROLLER_BX_5A2_RF_INDEX:
      Result := CONTROLLER_BX_5A2_RF;
    CONTROLLER_BX_5A2_WiFi_INDEX:
      Result := CONTROLLER_BX_5A2_WiFi;
    CONTROLLER_BX_5A3_INDEX:
      Result := CONTROLLER_BX_5A3;
    CONTROLLER_BX_5A4_INDEX:
      Result := CONTROLLER_BX_5A4;
    CONTROLLER_BX_5A4_RF_INDEX:
      Result := CONTROLLER_BX_5A4_RF;
    CONTROLLER_BX_5A4_WiFi_INDEX:
      Result := CONTROLLER_BX_5A4_WiFi;
    CONTROLLER_BX_5M1_INDEX:
      Result := CONTROLLER_BX_5M1;
    CONTROLLER_BX_5M2_INDEX:
      Result := CONTROLLER_BX_5M2;
    CONTROLLER_BX_5M3_INDEX:
      Result := CONTROLLER_BX_5M3;
    CONTROLLER_BX_5M4_INDEX:
      Result := CONTROLLER_BX_5M4;
    CONTROLLER_BX_5UT_INDEX:
      Result := CONTROLLER_BX_5UT;
    CONTROLLER_BX_5U0_INDEX:
      Result := CONTROLLER_BX_5U0;
    CONTROLLER_BX_5U1_INDEX:
      Result := CONTROLLER_BX_5U1;
    CONTROLLER_BX_5U2_INDEX:
      Result := CONTROLLER_BX_5U2;
    CONTROLLER_BX_5U3_INDEX:
      Result := CONTROLLER_BX_5U3;
    CONTROLLER_BX_5U4_INDEX:
      Result := CONTROLLER_BX_5U4;
    CONTROLLER_BX_5E2_INDEX:
      Result := CONTROLLER_BX_5E2;
    CONTROLLER_BX_5E3_INDEX:
      Result := CONTROLLER_BX_5E3;
    CONTROLLER_BX_5E1_INDEX:
      Result := CONTROLLER_BX_5E1;
    CONTROLLER_BX_4T1_INDEX:
      Result := CONTROLLER_BX_4T1;
    CONTROLLER_BX_4T2_INDEX:
      Result := CONTROLLER_BX_4T2;
    CONTROLLER_BX_4T3_INDEX:
      Result := CONTROLLER_BX_4T3;
    CONTROLLER_BX_4A1_INDEX:
      Result := CONTROLLER_BX_4A1;
    CONTROLLER_BX_4A2_INDEX:
      Result := CONTROLLER_BX_4A2;
    CONTROLLER_BX_4A3_INDEX:
      Result := CONTROLLER_BX_4A3;
    CONTROLLER_BX_4AQ_INDEX:
      Result := CONTROLLER_BX_4AQ;
    CONTROLLER_BX_4A_INDEX:
      Result := CONTROLLER_BX_4A;
    CONTROLLER_BX_4UT_INDEX:
      Result := CONTROLLER_BX_4UT;
    CONTROLLER_BX_4U0_INDEX:
      Result := CONTROLLER_BX_4U0;
    CONTROLLER_BX_4U1_INDEX:
      Result := CONTROLLER_BX_4U1;
    CONTROLLER_BX_4U2_INDEX:
      Result := CONTROLLER_BX_4U2;
    CONTROLLER_BX_4U2X_INDEX:
      Result := CONTROLLER_BX_4U2X;
    CONTROLLER_BX_4U3_INDEX:
      Result := CONTROLLER_BX_4U3;
    CONTROLLER_BX_4M0_INDEX:
      Result := CONTROLLER_BX_4M0;
    CONTROLLER_BX_4M1_INDEX:
      Result := CONTROLLER_BX_4M1;
    CONTROLLER_BX_4M_INDEX:
      Result := CONTROLLER_BX_4M;
    CONTROLLER_BX_4MC_INDEX:
      Result := CONTROLLER_BX_4MC;
    CONTROLLER_BX_4C_INDEX:
      Result := CONTROLLER_BX_4C;
    CONTROLLER_BX_4E1_INDEX:
      Result := CONTROLLER_BX_4E1;
    CONTROLLER_BX_4E_INDEX:
      Result := CONTROLLER_BX_4E;
    CONTROLLER_BX_4EL_INDEX:
      Result := CONTROLLER_BX_4EL;
    CONTROLLER_BX_3T_INDEX:
      Result := CONTROLLER_BX_3T;
    CONTROLLER_BX_3A1_INDEX:
      Result := CONTROLLER_BX_3A1;
    CONTROLLER_BX_3A2_INDEX:
      Result := CONTROLLER_BX_3A2;
    CONTROLLER_BX_3A_INDEX:
      Result := CONTROLLER_BX_3A;
    CONTROLLER_BX_3M_INDEX:
      Result := CONTROLLER_BX_3M;
    CONTROLLER_BX_5Q0P_INDEX:
      Result := CONTROLLER_BX_5Q0P;
    CONTROLLER_BX_5Q1P_INDEX:
      Result := CONTROLLER_BX_5Q1P;
    CONTROLLER_BX_5Q2P_INDEX:
      Result := CONTROLLER_BX_5Q2P;
    CONTROLLER_BX_5QS1P_INDEX:
      Result := CONTROLLER_BX_5QS1P;
    CONTROLLER_BX_5QS2P_INDEX:
      Result := CONTROLLER_BX_5QS2P;
    CONTROLLER_BX_5QSP_INDEX:
      Result := CONTROLLER_BX_5QSP;
  else
    Result := $FE; //广播模式，不指定设备类型，任何设备都应对其进行处理
  end;
end;

function GetScreenControlIndex(const nLEDType: String): Cardinal;
var nIdx: Integer;
begin
  Result := $FFFF;
  for nIdx := Low(Screen_Control) to High(Screen_Control) do
  if CompareText(Screen_Control[nIdx], nLEDType) = 0 then
  begin
     Result := nIdx;
     Exit;
  end;  
end;

function GetErrorDesc(const nErr: Integer): string;
begin
  Result := '未定义的错误.';

  case nErr of
   RETURN_ERROR_NO_USB_DISK:
    Result := '找不到usb设备路径';
   RETURN_ERROR_NOSUPPORT_USB:
    Result := '不支持USB模式';
   RETURN_ERROR_AERETYPE:
    Result := '区域类型错误,在添加、删除图文区域文件时区域类型出错返回此类型错误.';
   RETURN_ERROR_RA_SCREENNO:
    Result := '已经有该显示屏信息,如要重新设定请先DeleteScreen删除该显示屏再添加.';
   RETURN_ERROR_NOFIND_AREAFILE:
    Result := '没有找到有效的区域文件';
   RETURN_ERROR_NOFIND_AREA:
    Result := '没有找到有效的显示区域,可以使用AddScreenProgram添加区域信息.';
   RETURN_ERROR_NOFIND_PROGRAM:
    Result := '没有找到有效的显示屏节目.可以使用AddScreenProgram函数添加指定节目.';
   RETURN_ERROR_NOFIND_SCREENNO:
    Result := '系统内没有查找到该显示屏,可以使用AddScreen函数添加显示屏.';
   RETURN_ERROR_NOW_SENDING:
    Result := '系统内正在向该显示屏通讯,请稍后再通讯.';
   RETURN_ERROR_OTHER:
    Result := '其它错误.';
   RETURN_NOERROR:
    Result := '操作成功';
  end;
end;

end.
 