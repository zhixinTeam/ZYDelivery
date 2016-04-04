unit UYBLEDSDK;

interface

uses
  Windows, Classes, SysUtils;

const
  cDLL        = 'BX_IV.dll';

  cSend_FileRTF = 'LED.rtf';
  cSend_File    = 'LED.txt';

//==============================================================================
// �û�������Ϣ�����
  SEND_CMD_PARAMETER = $A1FF; //������������
  SEND_CMD_SCREENSCAN = $A1FE; //����ɨ�跽ʽ��
  SEND_CMD_SENDALLPROGRAM = $A1F0; //�������н�Ŀ��Ϣ��
  SEND_CMD_POWERON  = $A2FF; //ǿ�ƿ���
  SEND_CMD_POWEROFF = $A2FE; //ǿ�ƹػ�
  SEND_CMD_TIMERPOWERONOFF = $A2FD; //��ʱ���ػ�
  SEND_CMD_CANCEL_TIMERPOWERONOFF = $A2FC; //ȡ����ʱ���ػ�
  SEND_CMD_RESIVETIME = $A2FB; //У��ʱ�䡣
  SEND_CMD_ADJUSTLIGHT = $A2FA; //���ȵ�����

//==============================================================================
//==============================================================================
// ������ͨѶģʽ
  SEND_MODE_COMM    = 0;
  SEND_MODE_NET     = 2;
  SEND_MODE_WIFI    = 4;
//==============================================================================
//==============================================================================
// ͨѶ���󷵻ش���ֵ
  RETURN_ERROR_NOSUPPORT_USB = $F6; //��֧��USBģʽ��
  RETURN_ERROR_NO_USB_DISK = $F5; //�Ҳ���usb�豸·����
  RETURN_ERROR_AERETYPE = $F7; //�������ʹ��������ͼ�������ļ�ʱ�������ͳ����ش����ʹ���
  RETURN_ERROR_RA_SCREENNO = $F8; //�Ѿ��и���ʾ����Ϣ����Ҫ�����趨����DeleteScreenɾ������ʾ������ӣ�
  RETURN_ERROR_NOFIND_AREAFILE = $F9; //û���ҵ���Ч�������ļ�(ͼ������)��
  RETURN_ERROR_NOFIND_AREA = $FA; //û���ҵ���Ч����ʾ���򣻿���ʹ��AddScreenProgramBmpTextArea���������Ϣ��
  RETURN_ERROR_NOFIND_PROGRAM = $FB; //û���ҵ���Ч����ʾ����Ŀ������ʹ��AddScreenProgram�������ָ����Ŀ
  RETURN_ERROR_NOFIND_SCREENNO = $FC; //ϵͳ��û�в��ҵ�����ʾ��������ʹ��AddScreen���������ʾ��
  RETURN_ERROR_NOW_SENDING = $FD; //ϵͳ�����������ʾ��ͨѶ�����Ժ���ͨѶ��
  RETURN_ERROR_OTHER = $FF; //��������
  RETURN_NOERROR    = 0; //û�д���

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
// �����������б����
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
// ����������
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
  //��ʼ���ͷ�

{-------------------------------------------------------------------------------
  ������:    AddScreen
  ��̬���������ʾ����Ϣ���ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��������Ϣ���á�
  ����:
    nControlType    :��ʾ���Ŀ������ͺţ�����궨�塰�������ͺŶ��塱
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

    nScreenNo       :��ʾ�����ţ��ò�����LedshowTW 2013�����"��������"ģ���"����"����һ�¡�
    nWidth          :��ʾ����� 16������������С64��BX-5Eϵ����СΪ80
    nHeight         :��ʾ���߶� 16������������С16��
    nScreenType     :��ʾ�����ͣ�1������ɫ��2��˫��ɫ��
      3��˫��ɫ��ע�⣺����ʾ������ֻ��BX-4MC֧�֣�ͬʱ���ͺſ�������֧��������ʾ�����͡�
      4��ȫ��ɫ��ע�⣺����ʾ������ֻ��BX-5Qϵ��֧�֣�ͬʱ���ͺſ�������֧��������ʾ�����͡�
      5��˫��ɫ�Ҷȣ�ע�⣺����ʾ������ֻ��BX-5QS֧�֣�ͬʱ���ͺſ�������֧��������ʾ�����͡�
    nPixelMode      :�������ͣ�1��R+G��2��G+R���ò���ֻ��˫��ɫ����Ч ��Ĭ��Ϊ2��
    nDataDA         :���ݼ��ԣ���0x00�����ݵ���Ч��0x01�����ݸ���Ч��Ĭ��Ϊ0��
    nDataOE         :OE���ԣ�  0x00��OE ����Ч��0x01��OE ����Ч��Ĭ��Ϊ0��
    nRowOrder       :����ģʽ��0��������1����1�У�2����1�У�Ĭ��Ϊ0��
    nFreqPar        :ɨ���Ƶ��0~6��Ĭ��Ϊ0��
    pCom            :�������ƣ�����ͨѶģʽʱ��Ч����:COM1
    nBaud           :���ڲ����ʣ�Ŀǰ֧��9600��57600��Ĭ��Ϊ57600��
    pSocketIP       :���ƿ�IP��ַ������ͨѶģʽʱ��Ч����:192.168.0.199��
      ����̬������ͨѶģʽʱֻ֧�̶ֹ�IPģʽ������ֱ�������������ģʽ��֧�֡�
    nSocketPort     :���ƿ�����˿ڣ�����ͨѶģʽʱ��Ч������5005
    pWiFiIP         :������WiFiģʽ��IP��ַ��Ϣ��WiFiͨѶģʽʱ��Ч����:192.168.100.1
    nWiFiPort       :���ƿ�WiFi�˿ڣ�WiFiͨѶģʽʱ��Ч������5005
    pScreenStatusFile:���ڱ����ѯ������ʾ��״̬���������INI�ļ�����
      ֻ��ִ�в�ѯ��ʾ��״̬GetScreenStatusʱ���ò�������Ч
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreen(nControlType, nScreenNo, nWidth, nHeight, nScreenType, nPixelMode: Integer;
    nDataDA, nDataOE: Integer; nRowOrder, nFreqPar: Integer; pCom: PChar; nBaud: Integer;
    pSocketIP: PChar; nSocketPort: Integer; pWiFiIP: PChar; nWiFiPort: Integer; pFileName: PChar): integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    AddScreenProgram
  ��̬����ָ����ʾ����ӽ�Ŀ���ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ����Ŀ��Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramType    :��Ŀ���ͣ�0������Ŀ��
    nPlayLength     :0:��ʾ�Զ�˳�򲥷ţ������ʾ��Ŀ���ŵĳ��ȣ���Χ1~65535����λ��
    nStartYear      :��Ŀ���������ڣ���ʼ����ʱ����ݡ����Ϊ�����Ʋ��ŵĻ��ò���ֵΪ65535����2010
    nStartMonth     :��Ŀ���������ڣ���ʼ����ʱ���·ݡ���11
    nStartDay       :��Ŀ���������ڣ���ʼ����ʱ�����ڡ���26
    nEndYear        :��Ŀ���������ڣ���������ʱ����ݡ���2011
    nEndMonth       :��Ŀ���������ڣ���������ʱ���·ݡ���11
    nEndDay         :��Ŀ���������ڣ���������ʱ�����ڡ���26
    nMonPlay        :��Ŀ����������������һ�Ƿ񲥷�;0��������;1������.
    nTuesPlay       :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    nWedPlay        :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    nThursPlay      :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    bFriPlay        :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    nSatPlay        :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    nSunPlay        :��Ŀ���������������ڶ��Ƿ񲥷�;0��������;1������.
    nStartHour      :��Ŀ�ڵ��쿪ʼ����ʱ��Сʱ����8
    nStartMinute    :��Ŀ�ڵ��쿪ʼ����ʱ����ӡ���0
    nEndHour        :��Ŀ�ڵ����������ʱ��Сʱ����18
    nEndMinute      :��Ŀ�ڵ����������ʱ����ӡ���0
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
    function AddScreenProgram(nScreenNo, nProgramType: Integer; nPlayLength: Integer;
    nStartYear, nStartMonth, nStartDay, nEndYear, nEndMonth, nEndDay: Integer;
    nMonPlay, nTuesPlay, nWedPlay, nThursPlay, bFriPlay, nSatPlay, nSunPlay: integer;
    nStartHour, nStartMinute, nEndHour, nEndMinute: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    AddScreenProgramBmpTextArea:
  ��̬����ָ����ʾ����ָ����Ŀ���ͼ�����򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ�е�ͼ��������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramBmpTextArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    AddScreenProgramAreaBmpTextFile
  ��̬����ָ����ʾ����ָ����Ŀ��ָ��ͼ����������ļ���
      �ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��ָ��ͼ��������ļ���Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd        :������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
    pFileName       :�ļ�����  ֧��.bmp,jpg,jpeg,rtf,txt���ļ����͡�
    nShowSingle     :����������ʾ��1��������ʾ��0��������ʾ���ò���ֻ����pFileNameΪtxt�����ļ�ʱ�ò�������Ч��
    pFontName       :�������ƣ�֧�ֵ�ǰ����ϵͳ�Ѿ���װ��ʸ���ֿ⣻�ò���ֻ��pFileNameΪtxt�����ļ�ʱ�ò�������Ч��
    nFontSize       :�����ֺţ�֧�ֵ�ǰ����ϵͳ���ֺţ��ò���ֻ��pFileNameΪtxt�����ļ�ʱ�ò�������Ч��
    nBold           :������壻֧��1�����壻0���������ò���ֻ��pFileNameΪtxt�����ļ�ʱ�ò�������Ч��
    nFontColor      :������ɫ���ò���ֻ��pFileNameΪtxt�����ļ�ʱ�ò�������Ч��
    nStunt          :��ʾ�ؼ���
      0x00:�����ʾ
      0x01:��̬
      0x02:���ٴ��
      0x03:�����ƶ�
      0x04:��������
      0x05:�����ƶ�            3T���Ϳ��ƿ��޴��ؼ�
      0x06:��������            3T���Ϳ��ƿ��޴��ؼ�
      0x07:��˸                3T���Ϳ��ƿ��޴��ؼ�
      0x08:Ʈѩ
      0x09:ð��
      0x0A:�м��Ƴ�
      0x0B:��������
      0x0C:���ҽ�������
      0x0D:���½�������
      0x0E:����պ�
      0x0F:�����
      0x10:��������
      0x11:��������
      0x12:��������
      0x13:��������            3T���Ϳ��ƿ��޴��ؼ�
      0x14:��������
      0x15:��������
      0x16:��������
      0x17:��������
      0x18:���ҽ�����Ļ
      0x19:���½�����Ļ
      0x1A:��ɢ����
      0x1B:ˮƽ��ҳ            3T��3A��4A��3A1��3A2��4A1��4A2��4A3��4AQ���Ϳ��ƿ��޴��ؼ�
      0x1C:��ֱ��ҳ            3T��3A��4A��3A1��3A2��4A1��4A2��4A3��4AQ��3M��4M��4M1��4MC���Ϳ��ƿ��޴��ؼ�
      0x1D:������Ļ            3T��3A��4A���Ϳ��ƿ��޴��ؼ�
      0x1E:������Ļ            3T��3A��4A���Ϳ��ƿ��޴��ؼ�
      0x1F:������Ļ            3T��3A��4A���Ϳ��ƿ��޴��ؼ�
      0x20:������Ļ            3T��3A��4A���Ϳ��ƿ��޴��ؼ�
      0x21:���ұպ�            3T���Ϳ��ƿ��޴��ؼ�
      0x22:���ҶԿ�            3T���Ϳ��ƿ��޴��ؼ�
      0x23:���±պ�            3T���Ϳ��ƿ��޴��ؼ�
      0x24:���¶Կ�            3T���Ϳ��ƿ��޴��ؼ�
      0x25:��������
      0x26:��������
      0x27:�����ƶ�            3T���Ϳ��ƿ��޴��ؼ�
      0x28:��������            3T���Ϳ��ƿ��޴��ؼ�
    nRunSpeed       :�����ٶȣ�0~63��ֵԽ�������ٶ�Խ����
    nShowTime       :ͣ��ʱ�䣻0~65525����λ0.5��

  ����ֵ:           :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pFileName: PChar; nShowSingle: Integer; pFontName: PChar; nFontSize, nBold, nFontColor: Integer;
    nStunt, nRunSpeed, nShowTime: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    AddScreenProgramTimeArea
  ��̬����ָ����ʾ����ָ����Ŀ���ʱ�����򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ�е�ʱ��������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramTimeArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    AddScreenProgramTimeAreaFile
  ��̬����ָ����ʾ����ָ����Ŀ��ָ��ʱ���������ԣ��ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��ָ��ʱ������������Ϣ���á�
  ����:
    nScreenNo   :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd    :������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
    pInputtxt   :�̶�����
    pFontName   :���ֵ�����
    nSingal     :���ж��У�0Ϊ���� 1Ϊ���У�����ģʽ��nAlign��������
    nAlign      :���ֶ���ģʽ���Զ�����Ч��0Ϊ��1Ϊ��2Ϊ��
    nFontSize   :���ֵĴ�С
    nBold       :�Ƿ�Ӵ֣�0Ϊ��1Ϊ��
    nItalic     :�Ƿ�б�壬0Ϊ��1Ϊ��
    nUnderline  :�Ƿ��»��ߣ�0Ϊ��1Ϊ��
    nUsetxt     :�Ƿ�ʹ�ù̶����֣�0Ϊ��1Ϊ��
    nTxtcolor   :�̶�������ɫ��������ɫ��10���� ��255 ��65280 ��65535
    nUseymd     :�Ƿ�ʹ�������գ�0Ϊ��1Ϊ��
    nYmdstyle   :�����ո�ʽ�����ʹ��˵���ĵ��ĸ���1
    nYmdcolor   :��������ɫ��������ɫ��10����
    nUseweek    :�Ƿ�ʹ�����ڣ�0Ϊ��1Ϊ��
    nWeekstyle  :���ڸ�ʽ�����ʹ��˵���ĵ��ĸ���1
    nWeekcolor  :������ɫ��������ɫ��10����
    nUsehns     :�Ƿ�ʹ��ʱ���룬0Ϊ��1��
    nHnsstyle   :ʱ�����ʽ�����ʹ��˵���ĵ��ĸ���1
    nHnscolor   :ʱ������ɫ��������ɫ��10����
    nAutoset    :�Ƿ��Զ����ô�С��Ӧ��ȣ�0Ϊ��1Ϊ�ǣ�Ĭ�ϲ�ʹ�ã�
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramTimeAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pInputtxt, pFontName: PChar;
    nSingal, nAlign, nFontSize, nBold, nItalic, nUnderline: Integer;
    nUsetxt, nTxtcolor,
    nUseymd, nYmdstyle, nYmdcolor,
    nUseweek, nWeekstyle, nWeekcolor,
    nUsehns, nHnsstyle, nHnscolor, nAutoset: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    AddScreenProgramLunarArea
  ��̬����ָ����ʾ����ָ����Ŀ���ũ�����򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ�е�ũ��������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramLunarArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    AddScreenProgramLunarAreaFile
  ��̬����ָ����ʾ����ָ����Ŀ��ָ��ũ���������ԣ��ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��ָ��ũ������������Ϣ���á�
  ����:
    nScreenNo		:��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd	:��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd		:������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
    pInputtxt		:�̶�����
    pFontName		:���ֵ�����
    nSingal			:���ж��У�0Ϊ���� 1Ϊ���У�����ģʽ��nAlign��������
    nAlign			:���ֶ���ģʽ���Զ�����Ч��0Ϊ��1Ϊ��2Ϊ��
    nFontSize		:���ֵĴ�С
    nBold				:�Ƿ�Ӵ֣�0Ϊ��1Ϊ��
    nItalic			:�Ƿ�б�壬0Ϊ��1Ϊ��
    nUnderline	:�Ƿ��»��ߣ�0Ϊ��1Ϊ��
    nUsetxt			:�Ƿ�ʹ�ù̶����֣�0Ϊ��1Ϊ��
    nTxtcolor		:�̶�������ɫ��������ɫ��10����
    nUseyear		:�Ƿ�ʹ����ɣ�0Ϊ��1Ϊ��  ����î���꣩
    nYearcolor	:�����ɫ��������ɫ��10����
    nUsemonth		:�Ƿ�ʹ��ũ����0Ϊ��1Ϊ��  ��������ʮ��
    nMonthcolor	:ũ����ɫ��������ɫ��10����
    nUsesolar		:�Ƿ�ʹ�ý�����0Ϊ��1��
    nSolarcolor	:������ɫ��������ɫ��10����
    nAutoset		:�Ƿ��Զ����ô�С��Ӧ��ȣ�0Ϊ��1Ϊ�ǣ�Ĭ�ϲ�ʹ�ã�
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramLunarAreaFile(nScreenNo, nProgramOrd, nAreaOrd: Integer;
    pInputtxt, pFontName: PChar;
    nSingal, nAlign, nFontSize, nBold, nItalic, nUnderline: Integer;
    nUsetxt, nTxtcolor, nUseyear, nYearcolor, nUsemonth, nMonthcolor,
    nUsesolar, nSolarcolor, nAutoset: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    AddScreenProgramClockArea
  ��̬����ָ����ʾ����ָ����Ŀ��ӱ������򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ�еı���������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function AddScreenProgramClockArea(nScreenNo, nProgramOrd: Integer;
    nX, nY, nWidth, nHeight: integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    AddScreenProgramClockAreaFile
  ��̬����ָ����ʾ����ָ����Ŀ��ָ�������������ԣ��ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��ָ����������������Ϣ���á�
  ����:
    nScreenNo			:��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd 	:��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd			:������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
    nusetxt				:�Ƿ�ʹ�ù̶����� 0Ϊ��1Ϊ��
    nusetime			:�Ƿ�ʹ��������ʱ�� 0Ϊ��1Ϊ��
    nuseweek			:�Ƿ�ʹ������ 0Ϊ��1Ϊ��
    ntimeStyle		:������ʱ���ʽ���ο�ʱ�����ı��˵��
    nWeekStyle		:����ʱ���ʽ���ο�ʱ�����ı��˵��
    ntxtfontsize	:�̶����ֵ��ִ�С
    ntxtfontcolor	:�̶����ֵ���ɫ��������ɫ��10����;��255��65280��65535
    ntxtbold			:�̶������Ƿ�Ӵ� 0Ϊ��1Ϊ��
    ntxtitalic		:�̶������Ƿ�б�� 0Ϊ��1Ϊ��
    ntxtunderline	:�̶������Ƿ��»��� 0Ϊ��1Ϊ��
    txtleft				:�̶������ڱ��������е�X����
    txttop				:�̶������ڱ��������е�Y����
    ntimefontsize	:���������ֵ��ִ�С
    ntimefontcolor:���������ֵ���ɫ�� ������ɫ��10����
    ntimebold			:�����������Ƿ�Ӵ� 0Ϊ��1Ϊ��
    ntimeitalic		:�����������Ƿ�б�� 0Ϊ��1Ϊ��
    ntimeunderline:�����������Ƿ��»��� 0Ϊ��1Ϊ��
    timeleft			:�����������ڱ��������е�X����
    timetop				:�����������ڱ��������е�X����
    nweekfontsize	:�������ֵ��ִ�С
    nweekfontcolor:�������ֵ���ɫ��������ɫ��10����
    nweekbold			:���������Ƿ�Ӵ� 0Ϊ��1Ϊ��
    nweekitalic		:���������Ƿ�б�� 0Ϊ��1Ϊ��
    nweekunderline:���������Ƿ��»��� 0Ϊ��1Ϊ��
    weekleft			:���������ڱ��������е�X����
    weektop				:���������ڱ��������е�X����
    nclockfontsize:�������ֵ��ִ�С
    nclockfontcolor:�������ֵ���ɫ��������ɫ��10����
    nclockbold		:���������Ƿ�Ӵ� 0Ϊ��1Ϊ��
    nclockitalic	:���������Ƿ�б�� 0Ϊ��1Ϊ��
    nclockunderline:���������Ƿ��»��� 0Ϊ��1Ϊ��
    clockcentercolor:����������ɫ��������ɫ��10����
    mhrdotstyle		:3/6/9ʱ������ 0����1Բ��2����3����4����
    mhrdotsize		:3/6/9ʱ��ߴ� 0-8
    mhrdotcolor		:3/6/9ʱ����ɫ��������ɫ��10����
    hrdotstyle		:3/6/9���ʱ������  0����1Բ��2����3����4����
    hrdotsize			:3/6/9���ʱ��ߴ� 0-8
    hrdotcolor		:3/6/9���ʱ����ɫ��������ɫ��10����
    mindotstyle		:���ӵ�����  0����1Բ��2����
    mindotsize		:���ӵ�ߴ� 0-1
    mindotcolor		:���ӵ���ɫ��������ɫ��10����
    hrhandsize		:ʱ��ߴ� 0-8
    hrhandcolor		:ʱ����ɫ��������ɫ��10����
    minhandsize		:����ߴ� 0-8
    minhandcolor	:������ɫ��������ɫ��10����
    sechandsize		:����ߴ� 0-8
    sechandcolor	:������ɫ��������ɫ��10����
    nAutoset			:����Ӧλ�����ã�0Ϊ��1Ϊ�� ���Ϊ1����txtleft/txttop/ weekleft/weektop/timeleft/timetop��Ҫ�Լ�������ֵ
    btxtcontent		:�̶�������Ϣ
    btxtfontname	:�̶���������
    btimefontname	:ʱ����������
    bweekfontname	:������������
    bclockfontname:������������
  ����ֵ            :�������״̬���붨�塣
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
  ������:    AddScreenProgramChroAreaFile
  ��̬����ָ����ʾ����ָ����Ŀ��ָ����ʱ�������ԣ��ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��ָ����ʱ����������Ϣ���á�
  ����:
    nScreenNo   :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd    :������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣

    pInputtxt   :�̶�����
    pDaystr    :�쵥λ
    pHourstr   :Сʱ��λ
    pMinstr    :���ӵ�λ
    pSecstr    :�뵥λ
    pFontName   :���ֵ�����
    nSingal     :���ж��У�0Ϊ���� 1Ϊ���У�����ģʽ��nAlign��������
    nAlign      :���ֶ���ģʽ���Զ�����Ч��0Ϊ��1Ϊ��2Ϊ��
    nFontSize   :���ֵĴ�С
    nBold       :�Ƿ�Ӵ֣�0Ϊ��1Ϊ��
    nItalic     :�Ƿ�б�壬0Ϊ��1Ϊ��
    nUnderline  :�Ƿ��»��ߣ�0Ϊ��1Ϊ��
    nTxtcolor   :�̶�������ɫ��������ɫ��10���� ��255 ��65280 ��65535
    nFontcolor  :��ʱ��ʾ��ɫ��������ɫ��10���� ��255 ��65280 ��65535

    nShowstr     :�Ƿ���ʾ��λ����Ӧ�����е��죬ʱ���֣��뵥λ
    nShowAdd     :�Ƿ��ʱ�ۼ���ʾ Ĭ�����ۼӵ�
    nUsetxt     :�Ƿ�ʹ�ù̶����֣�0Ϊ��1Ϊ��
    nUseDay     :�Ƿ�ʹ���죬0Ϊ��1Ϊ��
    nUseHour    :�Ƿ�ʹ��Сʱ��0Ϊ��1Ϊ��
    nUseMin     :�Ƿ�ʹ�÷��ӣ�0Ϊ��1Ϊ��
    nUseSec     :�Ƿ�ʹ���룬0Ϊ��1Ϊ��

    nDayLength     :����ʾλ��    Ĭ��Ϊ0 �Զ�
    nHourLength    :Сʱ��ʾλ��  Ĭ��Ϊ0 �Զ�
    nMinLength     :����ʾλ��    Ĭ��Ϊ0 �Զ�
    nSecLength     :����ʾλ��    Ĭ��Ϊ0 �Զ�

    EndYear     :Ŀ����ֵ
    EndMonth   :Ŀ����ֵ
    EndDay     :Ŀ����ֵ
    EndHour    :Ŀ��ʱֵ
    EndMin     :Ŀ���ֵ
    EndSec     :Ŀ����ֵ

    nAutoset    :�Ƿ��Զ����ô�С��Ӧ��ȣ�0Ϊ��1Ϊ�ǣ�Ĭ�ϲ�ʹ�ã�
  ����ֵ            :�������״̬���붨�塣
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
  ������:    AddScreenProgramTemperatureArea
  ��̬����ָ����ʾ����ָ����Ŀ����¶����򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ����Ŀ�е��¶�������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
    nSensorType     :�¶ȴ��������ͣ�
      0:"Temp sensor S-T1";
      1:"Temp and hum sensor S-RHT 1";
      2:"Temp and hum sensor S-RHT 2"
    nTemperatureUnit:�¶���ʾ��λ��0:���϶�(��);1:���϶�(�H);2:���϶�(��)
    nTemperatureMode:�¶���ʾģʽ��0:�����ͣ�1:С���͡�
    nTemperatureUnitScale:�¶ȵ�λ��ʾ������50~100;Ĭ��Ϊ100.
    nTemperatureValueWidth:�¶���ֵ�ַ���ʾ��ȣ�
    nTemperatureCorrectionPol:�¶�ֵ�������ֵ���ԣ�0������1����
    nTemperatureCondition:�¶�ֵ�������ֵ��
    nTemperatureThreshPol:�¶���ֵ������0:��ʾС�ڴ�ֵ��������;1:��ʾ���ڴ�ֵ��������
    nTemperatureThresh:�¶���ֵ
    nTemperatureColor:�����¶���ɫ
    nTemperatureErrColor:�¶ȳ�����ֵʱ��ʾ����ɫ
    pStaticText     :�¶�����ǰ׺�̶��ı�;�ò�����Ϊ��
    pStaticFont     :�������ƣ�֧�ֵ�ǰ����ϵͳ�Ѿ���װ��ʸ���ֿ⣻
    nStaticSize     :�����ֺţ�֧�ֵ�ǰ����ϵͳ���ֺţ�
    nStaticColor    :������ɫ��
    nStaticBold     :������壻֧��1�����壻0��������
  ����ֵ            :�������״̬���붨�塣
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
  ������:    AddScreenProgramHumidityArea
  ��̬����ָ����ʾ����ָ����Ŀ���ʪ�����򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ����Ŀ�е�ʪ��������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
    nSensorType     :ʪ�ȴ��������ͣ�
      0:"Temp and hum sensor S-RHT 1";
      1:"Temp and hum sensor S-RHT 2"
    nHumidityUnit   :ʪ����ʾ��λ��0:���ʪ��(%RH);1:���ʪ��(��)
    nHumidityMode   :ʪ����ʾģʽ��0:�����ͣ�1:С���͡�
    nHumidityUnitScale:ʪ�ȵ�λ��ʾ������50~100;Ĭ��Ϊ100.
    nHumidityValueWidth:ʪ����ֵ�ַ���ʾ��ȣ�
    nHumidityConditionPol:ʪ��ֵ�������ֵ���ԣ�0������1����
    nHumidityCondition:ʪ��ֵ�������ֵ��
    nHumidityThreshPol:ʪ����ֵ������0:��ʾС�ڴ�ֵ��������;1:��ʾ���ڴ�ֵ��������
    nHumidityThresh :ʪ����ֵ
    nHumidityColor  :����ʪ����ɫ
    nHumidityErrColor:ʪ�ȳ�����ֵʱ��ʾ����ɫ
    pStaticText     :ʪ������ǰ׺�̶��ı�;�ò�����Ϊ��
    pStaticFont     :�������ƣ�֧�ֵ�ǰ����ϵͳ�Ѿ���װ��ʸ���ֿ⣻
    nStaticSize     :�����ֺţ�֧�ֵ�ǰ����ϵͳ���ֺţ�
    nStaticColor    :������ɫ��
    nStaticBold     :������壻֧��1�����壻0��������
  ����ֵ            :�������״̬���붨�塣
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
  ������:    AddScreenProgramNoiseArea
  ��̬����ָ����ʾ����ָ����Ŀ����������򣻸ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ����Ŀ�е�����������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nX              :����ĺ����ꣻ��ʾ�������Ͻǵĺ�����Ϊ0����СֵΪ0
    nY              :����������ꣻ��ʾ�������Ͻǵ�������Ϊ0����СֵΪ0
    nWidth          :����Ŀ�ȣ����ֵ��������ʾ�����-nX
    nHeight         :����ĸ߶ȣ����ֵ��������ʾ���߶�-nY
    nSensorType     :�������������ͣ�
      0:"I-������";
      1:"II-������"
    nNoiseUnit      :������ʾ��λ��0:���ʪ��(%RH);1:���ʪ��(��)
    nNoiseMode      :������ʾģʽ��0:�����ͣ�1:С���͡�
    nNoiseUnitScale :������λ��ʾ������50~100;Ĭ��Ϊ100.
    nNoiseValueWidth:������ֵ�ַ���ʾ��ȣ�
    nNoiseConditionPol:����ֵ�������ֵ���ԣ�0������1����
    nNoiseCondition :����ֵ�������ֵ��
    nNoiseThreshPol :������ֵ������0:��ʾС�ڴ�ֵ��������;1:��ʾ���ڴ�ֵ��������
    nNoiseThresh    :������ֵ
    nNoiseColor     :����������ɫ
    nNoiseErrColor  :����������ֵʱ��ʾ����ɫ
    pStaticText     :��������ǰ׺�̶��ı�;�ò�����Ϊ��
    pStaticFont     :�������ƣ�֧�ֵ�ǰ����ϵͳ�Ѿ���װ��ʸ���ֿ⣻
    nStaticSize     :�����ֺţ�֧�ֵ�ǰ����ϵͳ���ֺţ�
    nStaticColor    :������ɫ��
    nStaticBold     :������壻֧��1�����壻0��������
  ����ֵ            :�������״̬���붨�塣
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
  ������:    DeleteScreen
  ɾ��ָ����ʾ����Ϣ��ɾ����ʾ���ɹ���Ὣ����ʾ�������н�Ŀ��Ϣ�Ӷ�̬����ɾ����
  �ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function DeleteScreen      (nScreenNo: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    DeleteScreenProgram
  ɾ��ָ����ʾ��ָ����Ŀ��ɾ����Ŀ�ɹ���Ὣ�ý�Ŀ������������Ϣɾ����
  �ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀ��Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function DeleteScreenProgram(nScreenNo, nProgramOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    DeleteScreenProgramArea
  ɾ��ָ����ʾ��ָ����Ŀ��ָ������ɾ������ɹ���Ὣ��������������Ϣɾ����
  �ú���������ʾ��ͨѶ��ֻ���ڶ�̬����ָ����ʾ��ָ����Ŀ��ָ����������Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd        :������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function DeleteScreenProgramArea(nScreenNo, nProgramOrd, nAreaOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    DeleteScreenProgramAreaBmpTextFile
  ɾ��ָ����ʾ��ָ����Ŀָ��ͼ�������ָ���ļ���ɾ���ļ��ɹ���Ὣ���ļ���Ϣɾ����
  �ú���������ʾ��ͨѶ��ֻ���ڶ�̬���е�ָ����ʾ��ָ����Ŀָ�������е�ָ���ļ���Ϣ���á�
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nProgramOrd     :��Ŀ��ţ�����Ű��ս�Ŀ���˳�򣬴�0˳���������ɾ���м�Ľ�Ŀ������Ľ�Ŀ����Զ���䡣
    nAreaOrd        :������ţ�����Ű����������˳�򣬴�0˳���������ɾ���м�����򣬺������������Զ���䡣
    nFileOrd        :�ļ���ţ�����Ű����ļ����˳�򣬴�0˳���������ɾ���м���ļ���������ļ�����Զ���䡣
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function DeleteScreenProgramAreaBmpTextFile(nScreenNo, nProgramOrd, nAreaOrd, nFileOrd: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    SendScreenInfo
  ͨ��ָ����ͨѶģʽ��������Ӧ��Ϣ�������ʾ�����ú�������ʾ������ͨѶ
  ����:
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nSendMode       :����ʾ����ͨѶģʽ��
      0:����ģʽ��BX-5A2&RF��BX-5A4&RF�ȿ�����ΪRF��������ģʽ;
      2:����ģʽ;
      4:WiFiģʽ
    nSendCmd        :ͨѶ����ֵ
      SEND_CMD_PARAMETER =41471;  ������������
      SEND_CMD_SENDALLPROGRAM = 41456;  �������н�Ŀ��Ϣ��
      SEND_CMD_POWERON =41727; ǿ�ƿ���
      SEND_CMD_POWEROFF = 41726; ǿ�ƹػ�
      SEND_CMD_TIMERPOWERONOFF = 41725; ��ʱ���ػ�
      SEND_CMD_CANCEL_TIMERPOWERONOFF = 41724; ȡ����ʱ���ػ�
      SEND_CMD_RESIVETIME = 41723; У��ʱ�䡣
      SEND_CMD_ADJUSTLIGHT = 41722; ���ȵ�����
    nOtherParam1    :����������0
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function SendScreenInfo    (nScreenNo, nSendMode, nSendCmd, nOtherParam1: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    SetScreenTimerPowerONOFF
  �趨��ʾ���Ķ�ʱ���ػ���������������3�鿪�ػ�ʱ�䡣�ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���ж�ָ����ʾ���Ķ�ʱ���ػ���Ϣ���á����轫�趨�Ķ�ʱ����ֵ���͵���ʾ���ϣ�
  ֻ��ʹ��SendScreenInfo�������Ͷ�ʱ��������ɡ�
  ����:
    nScreenNo		:��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nOnHour1		:��һ�鶨ʱ���صĿ���ʱ���Сʱ
    nOnMinute1	:��һ�鶨ʱ���صĿ���ʱ��ķ���
    nOffHour1		:��һ�鶨ʱ���صĹػ�ʱ���Сʱ
    nOffMinute1	:��һ�鶨ʱ���صĹػ�ʱ��ķ���
    nOnHour2		:�ڶ��鶨ʱ���صĿ���ʱ���Сʱ
    nOnMinute2	:�ڶ��鶨ʱ���صĿ���ʱ��ķ���
    nOffHour2		:�ڶ��鶨ʱ���صĹػ�ʱ���Сʱ
    nOffMinute2	:�ڶ��鶨ʱ���صĹػ�ʱ��ķ���
    nOnHour3		:�����鶨ʱ���صĿ���ʱ���Сʱ
    nOnMinute3	:�����鶨ʱ���صĿ���ʱ��ķ���
    nOffHour3		:�����鶨ʱ���صĹػ�ʱ���Сʱ
    nOffMinute3	:�����鶨ʱ���صĹػ�ʱ��ķ���
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function SetScreenTimerPowerONOFF(nScreenNo: Integer;
    nOnHour1, nOnMinute1, nOffHour1, nOffMinute1,
    nOnHour2, nOnMinute2, nOffHour2, nOffMinute2,
    nOnHour3, nOnMinute3, nOffHour3, nOffMinute3: Integer): Integer; stdcall; external cDLL;

{-------------------------------------------------------------------------------
  ������:    SetScreenAdjustLight
  �趨��ʾ�������ȵ����������ú����������ֹ������Ͷ�ʱ��������ģʽ���ú���������ʾ��ͨѶ��
  ֻ���ڶ�̬���ж�ָ����ʾ�������ȵ�����Ϣ���á����轫�趨�����ȵ���ֵ���͵���ʾ���ϣ�
  ֻ��ʹ��SendScreenInfo�����������ȵ�������ɡ�
  ����:
    nScreenNo		:��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nAdjustType	:���ȵ������ͣ�0���ֹ�������1����ʱ����
    nHandleLight:�ֹ�����������ֵ��ֻ��nAdjustType=0ʱ�ò�����Ч��
    nHour1			:��һ�鶨ʱ����ʱ���Сʱ
    nMinute1		:��һ�鶨ʱ����ʱ��ķ���
    nLight1			:��һ�鶨ʱ����������ֵ
    nHour2			:�ڶ��鶨ʱ����ʱ���Сʱ
    nMinute2		:�ڶ��鶨ʱ����ʱ��ķ���
    nLight2			:�ڶ��鶨ʱ����������ֵ
    nHour3			:�����鶨ʱ����ʱ���Сʱ
    nMinute3		:�����鶨ʱ����ʱ��ķ���
    nLight3			:�����鶨ʱ����������ֵ
    nHour4			:�����鶨ʱ����ʱ���Сʱ
    nMinute4		:�����鶨ʱ����ʱ��ķ���
    nLight4			:�����鶨ʱ����������ֵ
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function SetScreenAdjustLight(nScreenNo: Integer; nAdjustType, nHandleLight: Integer;
    nHour1, nMinute1, nLight1,
    nHour2, nMinute2, nLight2,
    nHour3, nMinute3, nLight3,
    nHour4, nMinute4, nLight4: Integer): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    SaveUSBScreenInfo
  ������ʾ��������Ϣ��USB�豸�������û���USB��ʽ������ʾ����Ϣ���ú�����LedshowTW������׵�USB���ع���һ�¡�
  ʹ�øù���ʱ��ע�⵱ǰ�������Ƿ�֧��USB���ع��ܡ�
  ����
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    bCorrectTime    :�Ƿ�У��ʱ��
      0����У��ʱ�䣻
      1��У��ʱ�䣻
    nAdvanceHour    :У��ʱ��ȵ�ǰ�����ʱ����ǰ��Сʱֵ����Χ0~23��ֻ�е�bCorrectTime=1ʱ��Ч��
    nAdvanceMinute  :У��ʱ��ȵ�ǰ�����ʱ����ǰ�ķ���ֵ����Χ0~59��ֻ�е�bCorrectTime=1ʱ��Ч��
    pUSBDisk        :USB�豸��·�����ƣ���ʽΪ"�̷�:\"�ĸ�ʽ�����磺"F:\"
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function SaveUSBScreenInfo (nScreenNo: Integer;
    bCorrectTime, nAdvanceHour, nAdvanceMinute: Integer; pUSBDisk: PChar): Integer; stdcall; external cDLL;
{-------------------------------------------------------------------------------
  ������:    GetScreenStatus
  ��ѯ��ǰ��ʾ��״̬������ѯ״̬�������浽AddScreen�����е�pScreenStatusFile��INI�����ļ��С�
  �ú�������ʾ������ͨѶ
  ����:      nScreenNo, nSendMode: Integer
    nScreenNo       :��ʾ�����ţ��ò�����AddScreen�����е�nScreenNo������Ӧ��
    nSendMode       :����ʾ����ͨѶģʽ��
      0:����ģʽ��BX-5A2&RF��BX-5A4&RF�ȿ�����ΪRF��������ģʽ;
      2:����ģʽ;
      4:WiFiģʽ
  ����ֵ            :�������״̬���붨�塣
-------------------------------------------------------------------------------}
  function GetScreenStatus(nScreenNo, nSendMode: Integer): Integer; stdcall; external cDLL;

function GetScreenControlTypeValue(nControlTypeIndex: Cardinal): Cardinal;
//��ȡ����������
function GetScreenControlIndex(const nLEDType: String): Cardinal;
//��ȡ����
function GetErrorDesc(const nErr: Integer): string;
//��ȡ��������

type
  TCardCode = record
    FCode: Word;
    FDesc: string;
  end;

const
  cCardEffects: array[0..39] of TCardCode = (
             (FCode: $00; FDesc:'�����ʾ'),
             (FCode: $01; FDesc:'��̬'),
             (FCode: $02; FDesc:'���ٴ��'),
             (FCode: $03; FDesc:'�����ƶ�'),
             (FCode: $04; FDesc:'��������'),
             (FCode: $05; FDesc:'�����ƶ�'),
             (FCode: $06; FDesc:'��������'),
             (FCode: $07; FDesc:'��˸'),
             (FCode: $08; FDesc:'Ʈѩ'),
             (FCode: $09; FDesc:'ð��'),
             (FCode: $0A; FDesc:'�м��Ƴ�'),
             (FCode: $0B; FDesc:'��������'),
             (FCode: $0C; FDesc:'���ҽ�������'),
             (FCode: $0D; FDesc:'���½�������'),
             (FCode: $0E; FDesc:'����պ�'),
             (FCode: $0F; FDesc:'�����'),
             (FCode: $10; FDesc:'��������'),
             (FCode: $11; FDesc:'��������'),
             (FCode: $12; FDesc:'��������'),
             (FCode: $13; FDesc:'��������'),
             (FCode: $14; FDesc:'��������'),
             (FCode: $15; FDesc:'��������'),
             (FCode: $16; FDesc:'��������'),
             (FCode: $17; FDesc:'��������'),
             (FCode: $18; FDesc:'���ҽ�����Ļ'),
             (FCode: $19; FDesc:'���½�����Ļ'),
             (FCode: $1A; FDesc:'��ɢ����'),
             (FCode: $1B; FDesc:'ˮƽ��ҳ'),
             (FCode: $1D; FDesc:'������Ļ'),
             (FCode: $1E; FDesc:'������Ļ'),
             (FCode: $1F; FDesc:'������Ļ'),
             (FCode: $20; FDesc:'������Ļ'),
             (FCode: $21; FDesc:'���ұպ�'),
             (FCode: $22; FDesc:'���ҶԿ�'),
             (FCode: $23; FDesc:'���±պ�'),
             (FCode: $24; FDesc:'���¶Կ�'),
             (FCode: $25; FDesc:'��������'),
             (FCode: $26; FDesc:'��������'),
             (FCode: $27; FDesc:'�����ƶ�'),
             (FCode: $28; FDesc:'��������'));
  //ϵͳ֧�ֵ���Ч
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
    Result := $FE; //�㲥ģʽ����ָ���豸���ͣ��κ��豸��Ӧ������д���
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
  Result := 'δ����Ĵ���.';

  case nErr of
   RETURN_ERROR_NO_USB_DISK:
    Result := '�Ҳ���usb�豸·��';
   RETURN_ERROR_NOSUPPORT_USB:
    Result := '��֧��USBģʽ';
   RETURN_ERROR_AERETYPE:
    Result := '�������ʹ���,����ӡ�ɾ��ͼ�������ļ�ʱ�������ͳ����ش����ʹ���.';
   RETURN_ERROR_RA_SCREENNO:
    Result := '�Ѿ��и���ʾ����Ϣ,��Ҫ�����趨����DeleteScreenɾ������ʾ�������.';
   RETURN_ERROR_NOFIND_AREAFILE:
    Result := 'û���ҵ���Ч�������ļ�';
   RETURN_ERROR_NOFIND_AREA:
    Result := 'û���ҵ���Ч����ʾ����,����ʹ��AddScreenProgram���������Ϣ.';
   RETURN_ERROR_NOFIND_PROGRAM:
    Result := 'û���ҵ���Ч����ʾ����Ŀ.����ʹ��AddScreenProgram�������ָ����Ŀ.';
   RETURN_ERROR_NOFIND_SCREENNO:
    Result := 'ϵͳ��û�в��ҵ�����ʾ��,����ʹ��AddScreen���������ʾ��.';
   RETURN_ERROR_NOW_SENDING:
    Result := 'ϵͳ�����������ʾ��ͨѶ,���Ժ���ͨѶ.';
   RETURN_ERROR_OTHER:
    Result := '��������.';
   RETURN_NOERROR:
    Result := '�����ɹ�';
  end;
end;

end.
 