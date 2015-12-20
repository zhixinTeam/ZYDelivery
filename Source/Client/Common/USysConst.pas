{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��

  cShouJuIDLength       = 7;                         //�����վݱ�ʶ����
  cItemIconIndex        = 11;                        //Ĭ�ϵ�������б�ͼ��
const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־
  cFI_FrameAuthorize    = $0003;                     //ϵͳ��Ȩ

  cFI_FrameCustomer     = $0007;                     //�ͻ�����
  cFI_FrameSalesMan     = $0008;                     //ҵ��Ա
  cFI_FrameSaleContract = $0009;                     //���ۺ�ͬ
  cFI_FrameTransContract= $0019;                     //���ۺ�ͬ

  cFI_FrameZhiKa        = $0010;                     //����ֽ��(����)
  cFI_FrameZhiKaVerify  = $0011;                     //ֽ��(����)���
  cFI_FrameBill         = $0015;                     //�������
  cFI_FrameFXZhiKa      = $0016;                     //�������
  cFI_FrameBillQuery    = $0017;                     //������ѯ
  cFI_FrameMakeOCard    = $0018;                     //����ɹ��ſ�

  cFI_FrameMakeCard     = $0020;                     //����ſ�
  cFI_FrameShouJu       = $0021;                     //�վݲ�ѯ
  cFI_FramePayment      = $0022;                     //���ۻؿ�
  cFI_FrameCusCredit    = $0023;                     //���ù���
  cFI_FrameTransPayment = $0024;                     //�˷ѻؿ�
  cFI_FrameTransCredit  = $0025;                     //���ù���

  cFI_FrameLadingDai    = $0030;                     //��װ���
  cFI_FramePoundQuery   = $0031;                     //������ѯ
  cFI_FrameFangHuiQuery = $0032;                     //�ŻҲ�ѯ
  cFI_FrameZhanTaiQuery = $0033;                     //ջ̨��ѯ
  cFI_FrameZTDispatch   = $0034;                     //ջ̨����
  cFI_FramePoundManual  = $0035;                     //�ֶ�����
  cFI_FramePoundAuto    = $0036;                     //�Զ�����

  cFI_FrameCusAddr      = $0040;                     //�ͻ���ַ����
  cFI_FrameTransTruck   = $0044;                     //���䳵������

  cFI_FrameTruckQuery   = $0050;                     //������ѯ
  cFI_FrameCusAccountQuery = $0051;                  //�ͻ��˻�
  cFI_FrameCusInOutMoney   = $0052;                  //�������ϸ
  cFI_FrameSaleTotalQuery  = $0053;                  //�ۼƷ���
  cFI_FrameSaleDetailQuery = $0054;                  //������ϸ
  cFI_FrameZhiKaDetail  = $0055;                     //ֽ����ϸ
  cFI_FrameDispatchQuery = $0056;                    //���Ȳ�ѯ
  cFI_FrameOrderDetailQuery = $0057;                 //�ɹ���ϸ
  cFI_FrameTransAccountQuery = $0058;                  //�ͻ��˷�
  cFI_FrameTransInOutMoney   = $0059;                  //�������ϸ

  cFI_FrameTrucks       = $0070;                     //��������
  cFI_FrameTruckLogs    = $0071;                     //��������
  cFI_FrameBatch        = $0076;                     //���ι���
  cFI_FrameBatchQuery   = $0077;                     //���ι���

  cFI_FrameStock        = $0081;                     //Ʒ�ֹ���
  cFI_FrameStockRecord  = $0084;                     //�����¼
  cFI_FrameStockHuaYan  = $0082;                     //�����鵥
  cFI_FrameStockHY_Each = $0083;                     //�泵����


  cFI_FrameProvider     = $0104;                     //��Ӧ
  cFI_FrameProvideLog   = $0105;                     //��Ӧ��־
  cFI_FrameMaterails    = $0106;                     //ԭ����
  cFI_FrameOrder        = $0107;                     //�ɹ�����
  cFI_FrameOrderBase    = $0108;                     //�ɹ����뵥
  cFI_FrameOrderDetail  = $0109;                     //�ɹ���ϸ
  cFI_FrameDeduct       = $0110;                     //���۹���

  {*Form ID*}
  cFI_FormMemo          = $1000;                     //��ע����
  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormAuthorize     = $1003;                     //��ȫ��֤
  cFI_FormIncInfo       = $1004;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����

  cFI_FormAreaInfo      = $1006;                     //������Ϣ 
  cFI_FormCustomer      = $1007;                     //�ͻ�����
  cFI_FormSaleMan       = $1008;                     //ҵ��Ա
  cFI_FormSaleContract  = $1009;                     //���ۺ�ͬ
  cFI_FormTransContract = $1019;                     //���ۺ�ͬ

  cFI_FormZhiKa         = $1010;                     //ֽ��(����)����
  cFI_FormZhiKaVerify   = $1011;                     //ֽ��(����)���
  cFI_FormZhiKaAdjust   = $1012;                     //ֽ��(����)����
  cFI_FormZhiKaFixMoney = $1013;                     //������
  cFI_FormZhiKaParam    = $1014;                     //ֽ��(����)����
  cFI_FormBill          = $1015;                     //�������
  cFI_FormFXZhiKa       = $1016;                     //��������
  cFI_FormBillAdditional= $1017;                     //�������
  cFI_FormFactZhiKaBind = $1018;                     //�󶨶���

  cFI_FormMakeCard      = $1020;                     //����ſ�
  cFI_FormReadICCard    = $1023;                     //����ſ�
  cFI_FormMakeRFIDCard  = $1021;                     //������ӱ�ǩ
  cFI_FormShouJu        = $1022;                     //���վ�

  cFI_FormCusAddr       = $1040;                     //�ͻ���ַ����
  cFI_FormTransTruck    = $1044;                     //�ͻ���������

  cFI_FormGetTruck      = $1047;                     //ѡ����
  cFI_FormGetContract   = $1048;                     //ѡ���ͬ
  cFI_FormGetCustom     = $1049;                     //ѡ��ͻ�
  cFI_FormGetStockNo    = $1050;                     //ѡ����
  cFI_FormGetZhika      = $1046;                     //ѡ��ֽ��(����)
  cFI_FormGetFXZhiKa    = $1045;                     //ѡ���������
  cFI_FormGetProvider   = $1041;                     //ѡ��Ӧ��
  cFI_FormGetMeterail   = $1042;                     //ѡ��ԭ����
  cFI_FormGetBill       = $1043;                     //ѡ�񽻻���
  cFI_FormGetFactZhika  = $1052;                     //ѡ�񹤳�ֽ��(����)

  cFI_FormCusCredit     = $1064;                     //���ñ䶯
  cFI_FormPayment       = $1066;                     //���ۻؿ�
  cFI_FormPaymentZK     = $1067;                     //ֽ��(����)�ؿ�
  cFI_FormFreezeZK      = $1068;                     //����ֽ��(����)
  cFI_FormAdjustPrice   = $1069;                     //ֽ��(����)����

  cFI_FormTrucks        = $1070;                     //��������
  cFI_FormTruckIn       = $1071;                     //��������
  cFI_FormTruckOut      = $1072;                     //��������
  cFI_FormLadDai        = $1073;                     //��װ���
  cFI_FormLadSan        = $1074;                     //ɢװ���
  cFI_FormZTLine        = $1075;                     //װ����
  cFI_FormBatch         = $1076;                     //���ι���
  cFI_FormBatchEdit     = $1077;                     //���ι���

  cFI_FormStockParam    = $1081;                     //Ʒ�ֹ���
  cFI_FormStockHuaYan   = $1082;                     //�����鵥
  cFI_FormStockHY_Each  = $1083;                     //�泵����

  cFI_FormProvider      = $1104;                     //��Ӧ��
  cFI_FormMaterails     = $1106;                     //ԭ����
  cFI_FormOrder         = $1107;                     //�ɹ�����
  cFI_FormOrderBase     = $1108;                     //�ɹ�����
  cFI_FormPurchase      = $1155;                     //�ɹ�����
  cFI_FormGetPOrderBase  = $1109;                     //�ɹ�����
  cFI_FormDeduct        = $1110;                     //���۹���


  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
    FUsesBackDB : Boolean;                           //ʹ�ñ��ݿ�

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������
    FHardMonURL : string;                            //Ӳ���ػ�

    FFactNum    : string;                            //�������
    FSerialID   : string;                            //���Ա��
    FCustomer   : string;                            //��ע�ͻ����
    FIsManual   : Boolean;                           //�ֶ�����
    FAutoPound  : Boolean;                           //�Զ�����

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //��װ�����
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //��װ�����
    FDaiPercent : Boolean;                           //����������ƫ��
    FDaiWCStop  : Boolean;                           //�������װƫ��
    FPoundSanF  : Double;                            //ɢװ�����
    FSanStop    : Boolean;                           //������ɢװ����
    FPicBase    : Integer;                           //ͼƬ����
    FPicPath    : string;                            //ͼƬĿ¼
    FVoiceUser  : Integer;                           //��������
    FProberUser : Integer;                           //���������
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������
  sCameraDir          = 'Camera\';                   //ץ��Ŀ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������
  sDBConfig_bk        = 'isbk';                      //���ݿ�

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
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

//Desc: �˵�ģ��ӳ���
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

//Desc: ����ģ���б�
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


