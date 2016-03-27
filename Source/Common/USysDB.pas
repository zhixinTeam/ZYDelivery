{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
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
   ����: ���㾫��
   *.����Ϊ�ֵļ�����,С��ֵ�Ƚϻ����������ʱ�������,���Ի��ȷŴ�,ȥ��
     С��λ������������.�Ŵ����ɾ���ֵȷ��.
  -----------------------------------------------------------------------------}

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����   
  sPopedom_ViewPrice  = 'H';                         //�鿴����
  sPopedom_ViewCusFZY = 'I';                         //�鿴��Դ����

  {*���ݿ��ʶ*}
  sFlag_DB_K3         = 'King_K3';                   //������ݿ�
  sFlag_DB_NC         = 'YonYou_NC';                 //�������ݿ�
  sFlag_DB_Master     = 'Fact_Master';               //���������ݿ�
  sFlag_DB_DRX        = 'Drx_Master';                //���������ݿ�
  sFlag_DB_SHY        = 'Shy_Master';                //ʢ�������ݿ�

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Unknow        = 'U';                         //δ֪ 
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_ManualNo      = '%';                         //�ֶ�ָ��(��ϵͳ�Զ�)
  sFlag_NotMatter     = '@';                         //�޹ر��(�����Ŷ���)
  sFlag_ForceDone     = '#';                         //ǿ�����(δ���ǰ����)
  sFlag_FixedNo       = '$';                         //ָ�����(ʹ����ͬ���)
  sFlag_Delimater     = '@';                         //�ָ���

  sFlag_Provide       = 'P';                         //��Ӧ
  sFlag_Sale          = 'S';                         //����
  sFlag_Returns       = 'R';                         //�˻�
  sFlag_Tranlation    = 'T';                         //����
  sFlag_Other         = 'O';                         //����

  sFlag_CusZY         = 'Z';                         //��Դ��ͻ�
  sFlag_CusZYF        = 'F';                         //����Դ��ͻ�

  sFlag_TiHuo         = 'T';                         //����
  sFlag_SongH         = 'S';                         //�ͻ�
  sFlag_XieH          = 'X';                         //��ж

  sFlag_Dai           = 'D';                         //��װˮ��
  sFlag_San           = 'S';                         //ɢװˮ��

  sFlag_BillNew       = 'N';                         //�µ�
  sFlag_BillEdit      = 'E';                         //�޸�
  sFlag_BillDel       = 'D';                         //ɾ��
  sFlag_BillLading    = 'L';                         //�����
  sFlag_BillPick      = 'P';                         //����
  sFlag_BillPost      = 'G';                         //����
  sFlag_BillDone      = 'O';                         //���

  sFlag_BillFL        = 'F';                         //��������
  sFlag_BillSZ        = 'S';                         //��׼����
  sFlag_BillFX        = 'V';                         //��������
  sFlag_BillMY        = 'M';                         //ó�׶���

  sFlag_OrderNew       = 'N';                        //�µ�
  sFlag_OrderEdit      = 'E';                        //�޸�
  sFlag_OrderDel       = 'D';                        //ɾ��
  sFlag_OrderPuring    = 'L';                        //�ͻ���
  sFlag_OrderDone      = 'O';                        //���
  sFlag_OrderAbort     = 'A';                        //����
  sFlag_OrderStop      = 'S';                        //��ֹ

  sFlag_OrderCardL     = 'L';                        //��ʱ
  sFlag_OrderCardG     = 'G';                        //�̶�
  sFlag_ICCardM        = 'M';                        //IC����
  sFlag_ICCardV        = 'V';                        //IC����

  sFlag_TypeShip      = 'S';                         //����
  sFlag_TypeZT        = 'Z';                         //ջ̨
  sFlag_TypeVIP       = 'V';                         //VIP
  sFlag_TypeCommon    = 'C';                         //��ͨ,��������

  sFlag_CardIdle      = 'I';                         //���п�
  sFlag_CardUsed      = 'U';                         //ʹ����
  sFlag_CardLoss      = 'L';                         //��ʧ��
  sFlag_CardInvalid   = 'N';                         //ע����

  sFlag_TruckNone     = 'N';                         //��״̬����
  sFlag_TruckIn       = 'I';                         //��������
  sFlag_TruckOut      = 'O';                         //��������
  sFlag_TruckBFP      = 'P';                         //����Ƥ�س���
  sFlag_TruckBFM      = 'M';                         //����ë�س���
  sFlag_TruckSH       = 'S';                         //�ͻ�����
  sFlag_TruckFH       = 'F';                         //�Żҳ���
  sFlag_TruckZT       = 'Z';                         //ջ̨����
  sFlag_TruckXH       = 'X';                         //���ճ���

  sFlag_DeductFix     = 'F';                         //�̶�ֵ�ۼ�
  sFlag_DeductPer     = 'P';                         //�ٷֱȿۼ�

  sFlag_TJNone        = 'N';                         //δ����
  sFlag_TJing         = 'T';                         //������
  sFlag_TJOver        = 'O';                         //�������

  sFlag_BatchInUse    = 'Y';                         //���κ���Ч
  sFlag_BatchOutUse   = 'N';                         //���κ��ѷ��
  sFlag_BatchDel      = 'D';                         //���κ���ɾ��

  sFlag_PoundBZ       = 'B';                         //��׼
  sFlag_PoundPZ       = 'Z';                         //Ƥ��
  sFlag_PoundPD       = 'P';                         //���
  sFlag_PoundCC       = 'C';                         //����(����ģʽ)
  sFlag_PoundLS       = 'L';                         //��ʱ
  
  sFlag_MoneyHuiKuan  = 'R';                         //�ؿ����
  sFlag_MoneyJiaCha   = 'C';                         //���ɼ۲�
  sFlag_MoneyZhiKa    = 'Z';                         //ֽ��(����)�ؿ�
  sFlag_MoneyFanHuan  = 'H';                         //�����û�

  sFlag_InvNormal     = 'N';                         //������Ʊ
  sFlag_InvHasUsed    = 'U';                         //���÷�Ʊ
  sFlag_InvInvalid    = 'V';                         //���Ϸ�Ʊ
  sFlag_InvRequst     = 'R';                         //���뿪��
  sFlag_InvDaily      = 'D';                         //�ճ�����

  sFlag_SysParam      = 'SysParam';                  //ϵͳ����
  sFlag_EnableBakdb   = 'Uses_BackDB';               //���ÿ�
  sFlag_ValidDate     = 'SysValidDate';              //��Ч��
  sFlag_ZhiKaVerify   = 'ZhiKaVerify';               //ֽ��(����)���
  sFlag_PrintZK       = 'PrintZK';                   //��ӡֽ��(����)
  sFlag_PrintBill     = 'PrintStockBill';            //���ӡ����
  sFlag_ViaBillCard   = 'ViaBillCard';               //ֱ���ƿ�
  sFlag_PayCredit     = 'Pay_Credit';                //�ؿ������
  sFlag_HYValue       = 'HYMaxValue';                //����������
  sFlag_SaleManDept   = 'SaleManDepartment';         //ҵ��Ա���ű��
  
  sFlag_PDaiWuChaZ    = 'PoundDaiWuChaZ';            //��װ�����
  sFlag_PDaiWuChaF    = 'PoundDaiWuChaF';            //��װ�����
  sFlag_PDaiPercent   = 'PoundDaiPercent';           //�������������
  sFlag_PDaiWuChaStop = 'PoundDaiWuChaStop';         //���ʱֹͣҵ��
  sFlag_PSanWuChaF    = 'PoundSanWuChaF';            //ɢװ�����
  sFlag_PSanWuChaStop = 'PoundSanWuChaStop';         //���ʱֹͣҵ��
  sFlag_PoundWuCha    = 'PoundWuCha';                //����������
  sFlag_PoundIfDai    = 'PoundIFDai';                //��װ�Ƿ����
  sFlag_NFStock       = 'NoFaHuoStock';              //�ֳ����跢��

  sFlag_CommonItem    = 'CommonItem';                //������Ϣ
  sFlag_CardItem      = 'CardItem';                  //�ſ���Ϣ��
  sFlag_AreaItem      = 'AreaItem';                  //������Ϣ��
  sFlag_TruckItem     = 'TruckItem';                 //������Ϣ��
  sFlag_CustomerItem  = 'CustomerItem';              //�ͻ���Ϣ��
  sFlag_BankItem      = 'BankItem';                  //������Ϣ��
  sFlag_UserLogItem   = 'UserLogItem';               //�û���¼��

  sFlag_StockItem     = 'StockItem';                 //ˮ����Ϣ��
  sFlag_ContractItem  = 'ContractItem';              //��ͬ��Ϣ��
  sFlag_SalesmanItem  = 'SalesmanItem';              //ҵ��Ա��Ϣ��
  sFlag_ZhiKaItem     = 'ZhiKaItem';                 //ֽ��(����)��Ϣ��
  sFlag_BillItem      = 'BillItem';                  //�ᵥ��Ϣ��
  sFlag_ICCardItem    = 'ICCardItem';                //��������
  sFlag_TruckQueue    = 'TruckQueue';                //��������
                                                               
  sFlag_PaymentItem   = 'PaymentItem';               //���ʽ��Ϣ��
  sFlag_PaymentItem2  = 'PaymentItem2';              //���ۻؿ���Ϣ��
  sFlag_PaymentItem3  = 'PaymentItem3';              //�˷Ѹ�����Ϣ��
  sFlag_LadingItem    = 'LadingItem';                //�����ʽ��Ϣ��

  sFlag_ProviderItem  = 'ProviderItem';              //��Ӧ����Ϣ��
  sFlag_MaterailsItem = 'MaterailsItem';             //ԭ������Ϣ��

  sFlag_HardSrvURL    = 'HardMonURL';
  sFlag_MITSrvURL     = 'MITServiceURL';             //�����ַ

  sFlag_AutoIn        = 'Truck_AutoIn';              //�Զ�����
  sFlag_AutoOut       = 'Truck_AutoOut';             //�Զ�����
  sFlag_InTimeout     = 'InFactTimeOut';             //������ʱ(����)
  sFlag_SanMultiBill  = 'SanMultiBill';              //ɢװԤ���൥
  sFlag_NoDaiQueue    = 'NoDaiQueue';                //��װ���ö���
  sFlag_NoSanQueue    = 'NoSanQueue';                //ɢװ���ö���
  sFlag_DelayQueue    = 'DelayQueue';                //�ӳ��Ŷ�(����)
  sFlag_PoundQueue    = 'PoundQueue';                //�ӳ��Ŷ�(�������ݹ�Ƥʱ��)
  sFlag_NetPlayVoice  = 'NetPlayVoice';              //ʹ��������������
  sFlag_BatchAuto     = 'Batch_Auto';                //�Զ��������κ�
  sFlag_BatchBrand    = 'Batch_Brand';               //��������Ʒ��
  sFlag_BatchValid    = 'Batch_Valid';               //�������ι���
  sFlag_DeleteHasOut  = 'DeleteHasOut';              //����ɾ���ѳ���

  sFlag_BusGroup      = 'BusFunction';               //ҵ�������
  sFlag_BillNo        = 'Bus_Bill';                  //��������
  sFlag_PoundID       = 'Bus_Pound';                 //���ؼ�¼
  sFlag_Customer      = 'Bus_Customer';              //�ͻ����
  sFlag_SaleMan       = 'Bus_SaleMan';               //ҵ��Ա���
  sFlag_ZhiKa         = 'Bus_ZhiKa';                 //ֽ��(����)���
  sFlag_WeiXin        = 'Bus_WeiXin';                //΢��ӳ����
  sFlag_HYDan         = 'Bus_HYDan';                 //���鵥��
  sFlag_ForceHint     = 'Bus_HintMsg';               //ǿ����ʾ
  sFlag_Order         = 'Bus_Order';                 //�ɹ�����
  sFlag_OrderDtl      = 'Bus_OrderDtl';              //�ɹ�����
  sFlag_OrderBase     = 'Bus_OrderBase';             //�ɹ����뵥��
  sFlag_MYZhiKa       = 'Bus_MYZhiKa';               //ó�׹�˾����
  sFlag_FLZhiKa       = 'Bus_FLZhiKa';               //��������

  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ

  sTable_SerialBase   = 'Sys_SerialBase';            //��������
  sTable_SerialStatus = 'Sys_SerialStatus';          //���״̬
  sTable_WorkePC      = 'Sys_WorkePC';               //��֤��Ȩ

  sTable_CusAccount   = 'Sys_CustomerAccount';       //�ͻ��˻�
  sTable_CusAccDetail = 'Sys_CustomerAccountDetail'; //�ͻ��˻�������ϸ
  sTable_InOutMoney   = 'Sys_CustomerInOutMoney';    //�ʽ���ϸ
  sTable_CusCredit    = 'Sys_CustomerCredit';        //�ͻ�����
  sTable_SysShouJu    = 'Sys_ShouJu';                //�վݼ�¼
  sTable_TransCredit      = 'Sys_TransCredit';        //�ͻ�����
  sTable_TransAccount     = 'Sys_TransAccount';       //�˷��˻�
  sTable_TransInOutMoney  = 'Sys_TransInOutMoney';    //�ʽ���ϸ
  sTable_CompensateAccount= 'Sys_CompensateAccount';       //�˷��˻�
  sTable_CompensateInOutMoney= 'Sys_CompensateInOutMoney';    //�ʽ���ϸ
  //�ͻ��˻���Ϣ

  sTable_PoundLog     = 'Sys_PoundLog';              //��������
  sTable_PoundBak     = 'Sys_PoundBak';              //��������
  sTable_Picture      = 'Sys_Picture';               //���ͼƬ
  //������Ϣ

  sTable_CusAddr      = 'S_CusAddr';                 //�ͻ��ͻ���ַ
  sTable_Customer     = 'S_Customer';                //�ͻ���Ϣ
  sTable_Salesman     = 'S_Salesman';                //ҵ����Ա
  sTable_SaleContract = 'S_Contract';                //���ۺ�ͬ
  sTable_SContractExt = 'S_ContractExt';             //��ͬ��չ
  sTable_TransContract= 'S_TransContract';           //�˷Ѻ�ͬ
  //���ۺ�ͬ��Ϣ

  sTable_ZhiKa        = 'S_ZhiKa';                   //ֽ��(����)����
  sTable_ZhiKaDtl     = 'S_ZhiKaDtl';                //ֽ��(����)��ϸ
  //������ϸ

  sTable_Card         = 'S_Card';                    //���۴ſ�
  sTable_Bill         = 'S_Bill';                    //�����
  sTable_BillBak      = 'S_BillBak';                 //��ɾ������
  sTable_ICCardInfo   = 'S_ICCardInfo';              //�����
  sTable_FXZhiKa      = 'S_FXZhiKa';                 //��������
  sTable_FLZhiKa      = 'S_FLZhiKa';                 //��������
  sTable_MYZhiKa      = 'S_MYZhiKa';                 //ó�׶���
  sTable_FLZhiKaDtl   = 'S_FLZhiKaDtl';                 //��������

  sTable_Truck        = 'S_Truck';                   //������
  sTable_ZTLines      = 'S_ZTLines';                 //װ����
  sTable_ZTTrucks     = 'S_ZTTrucks';                //��������
  sTable_TruckLog     = 'Sys_TruckLog';              //����������־

  sTable_StockMatch   = 'S_StockMatch';              //Ʒ��ӳ��
  sTable_StockParam   = 'S_StockParam';              //Ʒ�ֲ���
  sTable_StockParamExt= 'S_StockParamExt';           //������չ
  sTable_StockRecord  = 'S_StockRecord';             //�����¼
  sTable_StockRecordExt= 'S_StockRecordExt';         //��¼��չ
  sTable_StockHuaYan  = 'S_StockHuaYan';             //�����鵥
  sTable_Batcode      = 'S_Batcode';                 //���κ�
  sTable_BatcodeDoc   = 'S_BatcodeDoc';              //���κ�

  sTable_Provider     = 'P_Provider';                //�ͻ���
  sTable_Materails    = 'P_Materails';               //���ϱ�
  sTable_Deduct       = 'P_PoundDeduct';             //��������
  sTable_Order        = 'P_Order';                   //�ɹ�����
  sTable_OrderBak     = 'P_OrderBak';                //��ɾ���ɹ�����
  sTable_OrderBase    = 'P_OrderBase';               //�ɹ����붩��
  sTable_OrderBaseBak = 'P_OrderBaseBak';            //��ɾ���ɹ����붩��
  sTable_OrderDtl     = 'P_OrderDtl';                //�ɹ�������ϸ
  sTable_OrderDtlBak  = 'P_OrderDtlBak';             //�ɹ�������ϸ


  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

    sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���б�Ż�����: SerialBase
   *.R_ID: ���
   *.B_Group: ����
   *.B_Object: ����
   *.B_Prefix: ǰ׺
   *.B_IDLen: ��ų�
   *.B_Base: ����
   *.B_Date: �ο�����
  -----------------------------------------------------------------------------}

  sSQL_NewSerialStatus = 'Create Table $Table(R_ID $Inc, S_Object varChar(32),' +
       'S_SerailID varChar(32), S_PairID varChar(32), S_Status Char(1),' +
       'S_Date DateTime)';
  {-----------------------------------------------------------------------------
   ����״̬��: SerialStatus
   *.R_ID: ���
   *.S_Object: ����
   *.S_SerailID: ���б��
   *.S_PairID: ��Ա��
   *.S_Status: ״̬(Y,N)
   *.S_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewWorkePC = 'Create Table $Table(R_ID $Inc, W_Name varChar(100),' +
       'W_MAC varChar(32), W_Factory varChar(32), W_Serial varChar(32),' +
       'W_Departmen varChar(32), W_ReqMan varChar(32), W_ReqTime DateTime,' +
       'W_RatifyMan varChar(32), W_RatifyTime DateTime, W_Valid Char(1))';
  {-----------------------------------------------------------------------------
   ������Ȩ: WorkPC
   *.R_ID: ���
   *.W_Name: ��������
   *.W_MAC: MAC��ַ
   *.W_Factory: �������
   *.W_Departmen: ����
   *.W_Serial: ���
   *.W_ReqMan,W_ReqTime: ��������
   *.W_RatifyMan,W_RatifyTime: ��׼
   *.W_Valid: ��Ч(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewStockMatch = 'Create Table $Table(R_ID $Inc, M_Group varChar(8),' +
       'M_ID varChar(20), M_Name varChar(80), M_Status Char(1))';
  {-----------------------------------------------------------------------------
   ����Ʒ��ӳ��: StockMatch
   *.R_ID: ��¼���
   *.M_Group: ����
   *.M_ID: ���Ϻ�
   *.M_Name: ��������
   *.M_Status: ״̬
  -----------------------------------------------------------------------------}
  
  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20), S_Credit $Float,' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ҵ��Ա��: SalesMan
   *.R_ID: ��¼��
   *.S_ID: ���
   *.S_Name: ����
   *.S_PY: ��ƴ
   *.S_Phone: ��ϵ��ʽ
   *.S_Credit: ���и�ҵ��Ա�����ŵ���߶��
   *.S_Area:��������
   *.S_InValid: ����Ч
   *.S_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Code varChar(15), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50), C_WeiXin varChar(15),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Param varChar(32), C_Memo varChar(50), C_Type Char(1),C_XuNi Char(1))';
  {-----------------------------------------------------------------------------
   �ͻ���Ϣ��: Customer
   *.R_ID: ��¼��
   *.C_ID: ���
   *.C_Name: ����
   *.C_PY: ƴ����д
   *.C_Code: �ͻ�����
   *.C_Addr: ��ַ
   *.C_FaRen: ����
   *.C_LiXiRen: ��ϵ��
   *.C_Phone: �绰
   *.C_WeiXin: ΢��
   *.C_Fax: ����
   *.C_Tax: ˰��
   *.C_Bank: ������
   *.C_Account: �ʺ�
   *.C_SaleMan: ҵ��Ա
   *.C_Param: ���ò���
   *.C_Type:  �ͻ�����,��Դ��ͻ�������Դ��ͻ�
   *.C_Memo: ��ע��Ϣ
   *.C_XuNi: ����(��ʱ)�ͻ�
  -----------------------------------------------------------------------------}

  sSQL_NewCusAddr = 'Create Table $Table(R_ID $Inc, A_ID varChar(15), ' +
       'A_CID varChar(15), A_CusName varChar(80), ' +
       'A_Delivery varChar(50), A_DeliveryPY varChar(50), ' +
       'A_RecvMan varChar(30), A_RecvPhone varChar(15), A_Distance $Float,' +
       'A_CPrice $Float Default 0, A_DPrice $Float Default 0,' +
       'A_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �ͻ��ջ���ַ��Ϣ��: Customer
   *.R_ID: ��¼��
   *.A_ID: ��ַ���
   *.A_CID: �ͻ����
   *.A_Delivery: �ջ���ַ����
   *.A_DeliveryPY: �ջ���ַƴ��
   *.A_RecvMan: �ջ���
   *.A_RecvPhone: �ջ��˵绰
   *.A_Distance: �˾�
   *.A_CPrice: �ͻ��˷Ѽ۸�
   *.A_DPrice: ˾���˷Ѽ۸�
   *.A_Memo
  -----------------------------------------------------------------------------}

  sSQL_NewCusAccount = 'Create Table $Table(R_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_CardUseMoney Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_BeginBalance Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   �ͻ��˻�:CustomerAccount
   *.R_ID:��¼���
   *.A_CID:�ͻ���
   *.A_Used:��;(��Ӧ,����,����)
   *.A_InMoney:���
   *.A_OutMoney:����
   *.A_DebtMoney:Ƿ��
   *.A_Compensation:������
   *.A_CardUseMoney:�������
   *.A_FreezeMoney:�����ʽ�
   *.A_CreditLimit:���ö��
   *.A_BeginBalance:�ڳ�������ϵͳ�������
   *.A_Date:��������

   *.ˮ����������
     A_InMoney:�ͻ������˻��Ľ��
     A_OutMoney:�ͻ�ʵ�ʻ��ѵĽ��
     A_DebtMoney:��δ֧���Ľ��
     A_Compensation:���ڲ���˻����ͻ��Ľ��
     A_CardUseMoney:�������������
     A_BeginBalance:�ڳ���
     A_FreezeMoney:�Ѱ�ֽ��(����)��δ��������Ľ��
     A_CreditLimit:���Ÿ��û�����߿�Ƿ����

     ������� = ��� + ���ö� + �ڳ� + - ���� - ������ - �Ѷ��� - �������
     �����ܶ� = ���� + Ƿ�� + �Ѷ��� + �������
  -----------------------------------------------------------------------------}

    sSQL_NewCusAccDetial = 'Create Table $Table(R_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_Type Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_CardUseMoney Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_BeginBalance Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   �ͻ��˻�:CustomerAccountDetail
   *.R_ID:��¼���
   *.A_CID:�ͻ���
   *.A_Used:��;(��Ӧ,����,����)
   *.A_Type:�˻�����(�ֽ𡢿�Ƭ���жҡ�Ԥ����)
   *.A_InMoney:���
   *.A_OutMoney:����
   *.A_DebtMoney:Ƿ��
   *.A_Compensation:������
   *.A_CardUseMoney:�������
   *.A_FreezeMoney:�����ʽ�
   *.A_CreditLimit:���ö��
   *.A_BeginBalance:�ڳ�������ϵͳ�������
   *.A_Date:��������

   *.ˮ����������
     A_InMoney:�ͻ������˻��Ľ��
     A_OutMoney:�ͻ�ʵ�ʻ��ѵĽ��
     A_DebtMoney:��δ֧���Ľ��
     A_Compensation:���ڲ���˻����ͻ��Ľ��
     A_CardUseMoney:�������������
     A_BeginBalance:�ڳ���
     A_FreezeMoney:�Ѱ�ֽ��(����)��δ��������Ľ��
     A_CreditLimit:���Ÿ��û�����߿�Ƿ����

     ������� = ��� + ���ö� + �ڳ� + - ���� - ������ - �Ѷ��� - �������
     �����ܶ� = ���� + Ƿ�� + �Ѷ��� + �������
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(R_ID $Inc, M_SaleMan varChar(15),' +
       'M_CusID varChar(15), M_CusName varChar(80), ' +
       'M_Type Char(1), M_Payment varChar(20),' +
       'M_Money Decimal(15,5), M_ZID varChar(15), M_Date DateTime,' +
       'M_Man varChar(32), M_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   �������ϸ:CustomerInOutMoney
   *.M_ID:��¼���
   *.M_SaleMan:ҵ��Ա
   *.M_CusID:�ͻ���
   *.M_CusName:�ͻ���
   *.M_Type:����(����,�ؿ��)
   *.M_Payment:���ʽ
   *.M_Money:���ɽ��
   *.M_ZID:ֽ��(����)��
   *.M_Date:��������
   *.M_Man:������
   *.M_Memo:����

   *.ˮ�����������
     ��� = ���� x ���� + ����
  -----------------------------------------------------------------------------}

  sSQL_NewSysShouJu = 'Create Table $Table(R_ID $Inc ,S_Code varChar(15),' +
       'S_Sender varChar(100), S_Reason varChar(100), S_Money Decimal(15,5),' +
       'S_BigMoney varChar(50), S_Bank varChar(35), S_Man varChar(32),' +
       'S_Date DateTime, S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �վ���ϸ:ShouJu
   *.R_ID:���
   *.S_Code:����ƾ������
   *.S_Sender:����(��Դ)
   *.S_Reason:����(����)
   *.S_Money:���
   *.S_Bank:����
   *.S_Man:����Ա
   *.S_Date:����
   *.S_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCusCredit = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_Man varChar(32), C_Type Char(1),' +
       'C_Date DateTime, C_End DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ������ϸ:CustomerCredit
   *.R_ID:���
   *.C_CusID:�ͻ����
   *.C_Money:���Ŷ�
   *.C_Man:������
   *.C_Date:����
   *.C_End: ��Ч��
   *.C_Type: �˻�����
   *.C_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewSaleContract = 'Create Table $Table(R_ID $Inc, C_ID varChar(15),' +
       'C_Project varChar(100),C_SaleMan varChar(15), C_Customer varChar(15),' +
       'C_Date varChar(20), C_Area varChar(50), C_Addr varChar(50),' +
       'C_Delivery varChar(50), C_Paytype Char(1), C_Payment varChar(20), ' +
       'C_Approval varChar(30),' +
       'C_ZKDays Integer, C_XuNi Char(1), C_Freeze Char(1), C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ: SalesContract
   *.R_ID: ���
   *.C_Project: ��Ŀ����
   *.C_SaleMan: ������Ա
   *.C_Customer: �ͻ�
   *.C_Date: ǩ��ʱ��
   *.C_Area: ��������
   *.C_Addr: ǩ���ص�
   *.C_Delivery: ������
   *.C_Paytype: ���ʽ
   *.C_Payment: ���ʽ
   *.C_Approval: ��׼��
   *.C_ZKDays: ֽ��(����)��Ч��
   *.C_XuNi: �����ͬ
   *.C_Freeze: �Ƿ񶳽�
   *.C_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewSContractExt = 'Create Table $Table(R_ID $Inc,' +
       'E_CID varChar(15), E_Type Char(1), ' +
       'E_StockNo varChar(20), E_StockName varChar(80),' +
       'E_Value Decimal(15,5), E_Price Decimal(15,5), E_Money Decimal(15,5))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ: SalesContract
   *.R_ID: ��¼���
   *.E_CID: ���ۺ�ͬ
   *.E_Type: ����(��,ɢ)
   *.E_StockNo,E_StockName: ˮ������
   *.E_Value: ����
   *.E_Price: ����
   *.E_Money: ���
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
   �˷Ѻ�ͬ: TransContract
   *.R_ID: ���
   *.T_ID: Э����
   *.T_LID: ������������
   *.T_Project: ��Ŀ����
   *.T_SaleID, T_SaleMan, T_SalePY: ������Ա
   *.T_CusID, T_CusName, T_CusPY,T_CusPhone: �ͻ�
   *.T_StockName: ˮ��Ʒ��
   *.T_Date: ǩ��ʱ��
   *.T_Area: ��������
   *.T_Addr: ǩ���ص�
   *.T_SrcAddr: װ����ַ��׿Խˮ�����޹�˾
   *.T_Delivery: ������
   *.T_RecvMan: �ջ���
   *.T_Payment: ���ʽ
   *.T_Approval: ��׼��
   *.T_Driver: ˾��
   *.T_Truck:  ����
   *.T_DrvPhone: ˾���绰
   *.T_WeiValue: ����
   *.T_DisValue: �˾�
   *.T_TrueValue: ȷ������
   *.T_DrvMoney: ˾���˷�
   *.T_CusMoney: ������ֵ
   *.T_CPrice: �ͻ��˷Ѽ۸�
   *.T_DPrice: ˾���˷Ѽ۸�
   *.T_DisFlag: ����������˷�
   *.T_WeiFlag: ���ͻ��������˷�
   *.T_Enabled: �Ƿ���Ч
   *.T_Man:
   *.T_Date:
   *.T_VerifyMan:
   *.T_VerifyDate:
   *.T_Settle: �Ƿ��ѽ���
   *.T_SetDate: ����ʱ��
   *.T_SetMan: ������
   *.T_Memo: ��ע��Ϣ
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
   ֽ��(����)����: ZhiKa
   *.R_ID:��¼���
   *.Z_ID:ֽ��(����)��
   *.Z_Card:�ſ���
   *.Z_CardNO:�ſ����к�
   *.Z_Name:ֽ��(����)����
   *.Z_CID:���ۺ�ͬ
   *.Z_Project:��Ŀ����
   *.Z_Customer:�ͻ����
   *.Z_SaleMan:ҵ��Ա
   *.Z_Paytype:���ʽ
   *.Z_Payment:���ʽ
   *.Z_Lading:�����ʽ(����,�ͻ�)
   *.Z_ValidDays:��Ч��
   *.Z_Password: ����
   *.Z_OnlyPwd: ͳһ����
   *.Z_Verified:�����
   *.Z_InValid:����Ч
   *.Z_Freeze:�Ѷ���
   *.Z_YFMoney:Ԥ�����
   *.Z_FixedMoney:���ý�
   *.Z_OnlyMoney:ֻʹ�ÿ��ý�
   *.Z_TJStatus:����״̬
   *.Z_Man:������
   *.Z_Date:����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaDtl = 'Create Table $Table(R_ID $Inc, D_ZID varChar(15),' +
       'D_Type Char(1), D_StockNo varChar(20), D_StockName varChar(80),' +
       'D_Price $Float, D_Value $Float, D_PPrice $Float, ' +
       'D_TPrice Char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   ֽ��(����)��ϸ:ZhiKaDtl
   *.R_ID:��¼���
   *.D_ZID:ֽ��(����)��
   *.D_Type:����(��,ɢ)
   *.D_StockNo,D_StockName:ˮ������
   *.D_Price:����
   *.D_Value:������
   *.D_PPrice:����ǰ����
   *.D_TPrice:�������
  -----------------------------------------------------------------------------}

  sSQL_NewICCardInfo = 'Create Table $Table(R_ID $Inc, ' +
       'F_ZID varChar(15), F_ZType Char(1),'+
			 'F_Card varChar(64), F_Password varChar(64), F_CardType Char(1),' +
       'F_ParentCard varChar(64), F_CardNO varChar(64))';
  {-----------------------------------------------------------------------------
   IC����Ϣ:ICCardInfo
   *.R_ID:��¼���
   *.F_ZID: ������
   *.F_ZType: ��������
   *.F_Card: IC����
   *.F_CardNO: �����к�
   *.F_Password: ����
   *.F_CardType: IC������:M,����(Master Card)��V,����(Vice Card)
   *.F_ParentCard: ������
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
       'I_VerifyMan varChar(32), I_VerifyDate DateTime)';
  {-----------------------------------------------------------------------------
   ����������ϸ:FXZhiKa
   *.R_ID:��¼���
   *.I_ID: �����������
   *.I_ZID:ֽ��(����)��
   *.I_Password: ����
   *.I_Card:IC����
   *.I_CardNO: �����к�
   *.I_ParentCard: ������
   *.I_Paytype:���ʽ
   *.I_Payment:���ʽ (��������)
   *.I_StockType:����(��,ɢ)
   *.I_StockNo,I_StockName:ˮ������
   *.I_Customer:�ͻ����
   *.I_SaleMan:ҵ��Ա���
   *.I_Price:����
   *.I_Value:������
   *.I_Money:�ſ����ý��
   *.I_OutMoney:�ѷ������
   *.I_FreezeMoney:������
   *.I_BackMoney:���
   *.I_Enabled:����״̬
   *.I_TJStatus:����״̬
   *.I_PPrice:����ǰ����
   *.I_TPrice:�������
   *.I_Man:������
   *.I_Date:�쿨ʱ��
   *.I_VerifyMan:�޸�ren
   *.I_VerifyDate:�޸�ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewMYZhiKa = 'Create Table $Table(R_ID $Inc, M_ID varChar(15),' +
       'M_MID varChar(15), M_FID varChar(15), M_Fact varChar(64), ' +
        'M_Password varChar(64), M_CardType Char(1),' +
       'M_Card varChar(64), M_CardNO varChar(64),' +
       'M_Man varChar(32), M_Date DateTime,' +
       'M_VerifyMan varChar(32), M_VerifyDate DateTime)';
  {-----------------------------------------------------------------------------
   ó�׶�����ϸ:MYZhiKa
   *.R_ID:��¼���
   *.M_ID: ó�׶������
   *.M_MID:ó�׹�˾������
   *.M_FID:����������
   *.M_Fact:ó�׹�˾���
   *.M_Password: ����
   *.M_Card:IC����
   *.M_CardNO: �����к�
   *.M_Man:������
   *.M_Date:�쿨ʱ��
   *.M_VerifyMan:�޸�ren
   *.M_VerifyDate:�޸�ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc,L_ID varChar(20),' +
       'L_Card varChar(16),L_ZhiKa varChar(15),L_Project varChar(100),' +
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
       'L_LadeLine varChar(15),L_LineName varChar(32), ' +
       'L_DaiTotal Integer,L_DaiNormal Integer,L_DaiBuCha Integer,' +
       'L_OutFact DateTime,L_OutMan varChar(32),' +
       'L_Lading Char(1),L_IsVIP varChar(1),L_Seal varChar(100),' +
       'L_HYDan varChar(15),L_Man varChar(32),L_Date DateTime, ' +
       'L_Paytype Char(1),L_Payment varChar(20),' +
       'L_DelMan varChar(32),L_DelDate DateTime)';
  {-----------------------------------------------------------------------------
   ��������: Bill
   *.R_ID: ���
   *.L_ID: �ᵥ��
   *.L_Card: �ſ���
   *.L_ZhiKa: �������
   *.L_ZKType: ��������
   *.L_Area: ����
   *.L_CusID,L_CusName,L_CusPY:�ͻ�
   *.L_SaleID,L_SaleMan:ҵ��Ա
   *.L_Type: ����(��,ɢ)
   *.L_StockNo: ���ϱ��
   *.L_StockName: �������� 
   *.L_Value: �����
   *.L_Price: �������
   *.L_ZKMoney: ռ��ֽ��(����)����(Y/N)
   *.L_Truck: ������
   *.L_Status,L_NextStatus:״̬����
   *.L_InTime,L_InMan: ��������
   *.L_PValue,L_PDate,L_PMan: ��Ƥ��
   *.L_MValue,L_MDate,L_MMan: ��ë��
   *.L_LadeTime,L_LadeMan: ����ʱ��,������
   *.L_LadeLine,L_LineName: ����ͨ��
   *.L_DaiTotal,L_DaiNormal,L_DaiBuCha:��װ,����,����
   *.L_OutFact,L_OutMan: ��������
   *.L_Lading: �����ʽ(����,�ͻ�)
   *.L_IsVIP:VIP��
   *.L_Seal:��ǩ��
   *.L_HYDan:���鵥
   *.L_Man:������
   *.L_Date:����ʱ��
   *.L_Paytype:���ʽ
   *.L_Payment:���ʽ (��������)
   *.L_DelMan: ������ɾ����Ա
   *.L_DelDate: ������ɾ��ʱ��
   *.L_Memo: ������ע
  -----------------------------------------------------------------------------}

    sSQL_NewCard = 'Create Table $Table(R_ID $Inc, C_Card varChar(16),' +
       'C_Card2 varChar(32), C_Card3 varChar(32),' +
       'C_Owner varChar(15), C_TruckNo varChar(15), C_Status Char(1),' +
       'C_Freeze Char(1), C_Used Char(1), C_UseTime Integer Default 0,' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ſ���:Card
   *.R_ID:��¼���
   *.C_Card:������
   *.C_Card2,C_Card3:������
   *.C_Owner:�����˱�ʶ
   *.C_TruckNo:�������
   *.C_Used:��;(��Ӧ,����,��ʱ)
   *.C_UseTime:ʹ�ô���
   *.C_Status:״̬(����,ʹ��,ע��,��ʧ)
   *.C_Freeze:�Ƿ񶳽�
   *.C_Man:������
   *.C_Date:����ʱ��
   *.C_Memo:��ע��Ϣ
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
       'T_HZValue $Float, T_CGHZValue $Float, T_Memo varChar(100))';
  {-----------------------------------------------------------------------------
   ������Ϣ:Truck
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_PY: ����ƴ��
   *.T_Owner: ����
   *.T_Phone: ��ϵ��ʽ
   *.T_Used: ��;(��Ӧ,����,����)
   *.T_PrePValue: Ԥ��Ƥ��
   *.T_PrePMan: Ԥ��˾��
   *.T_PrePTime: Ԥ��ʱ��
   *.T_PrePUse: ʹ��Ԥ��
   *.T_MinPVal: ��ʷ��СƤ��
   *.T_MaxPVal: ��ʷ���Ƥ��
   *.T_PValue: ��ЧƤ��
   *.T_PTime: ��Ƥ����
   *.T_PlateColor: ������ɫ
   *.T_Type: ����
   *.T_LastTime: �ϴλ
   *.T_Card: ���ӱ�ǩ
   *.T_CardUse: ʹ�õ���ǩ(Y/N)
   *.T_NoVerify: ��У��ʱ��
   *.T_Valid: �Ƿ���Ч
   *.T_VIPTruck:�Ƿ�VIP
   *.T_HasGPS:��װGPS(Y/N)
   *.T_Driver:��ʻԱ
   *.T_DrPhone:��ʻԱ��ϵ��ʽ
   *.T_HZValue:�˶�������
   *.T_CGHZValue:�ɹ����������
   *.T_Bearings:�������
   *.T_YSSerial:��·����֤��
   *.T_ZGSerial:��ҵ�ʸ�֤��
   *.T_Memo:��ע

   ��Чƽ��Ƥ���㷨:
   T_PValue = (T_PValue * T_PTime + ��Ƥ��) / (T_PTime + 1)
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
   ������¼: Materails
   *.P_ID: ���
   *.P_Type: ����(����,��Ӧ,��ʱ)
   *.P_Order: ������(��Ӧ)
   *.P_Bill: ������
   *.P_Truck: ����
   *.P_CusID: �ͻ���
   *.P_CusName: ������
   *.P_MID: ���Ϻ�
   *.P_MName: ������
   *.P_MType: ��,ɢ��
   *.P_LimValue: Ʊ��
   *.P_PValue,P_PDate,P_PMan: Ƥ��
   *.P_MValue,P_MDate,P_MMan: ë��
   *.P_FactID: �������
   *.P_PStation,P_MStation: ���ذ�վ
   *.P_Direction: ��������(��,��)
   *.P_PModel: ����ģʽ(��׼,��Ե�)
   *.P_Status: ��¼״̬
   *.P_Valid: �Ƿ���Ч
   *.P_PrintNum: ��ӡ����
   *.P_DelMan,P_DelDate: ɾ����¼
   *.P_KZValue: ��Ӧ����
  -----------------------------------------------------------------------------}

  sSQL_NewTruckLog = 'Create Table $Table(R_ID $Inc, L_BID varChar(15),' +
       'L_Type varChar(1), L_PValue $Float, L_MValue $Float,' +
       'L_Value $Float, L_Truck varChar(32), L_OutFact DateTime, ' +
       'L_Memo varChar(32))';
  {-----------------------------------------------------------------------------
   ����������¼: TruckLog
   *.L_BID: ���(���۳������,��Ӧ�볧���)
   *.L_Type: ����(����,��Ӧ,��ʱ)
   *.L_PValue: Ƥ��
   *.L_MValue: ë��
   *.L_Truck : ���ƺ�
   *.L_Value:  ����=ë��-Ƥ��
   *.L_OutFact: ����ʱ��
   *.L_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewPicture = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(32), P_Mate varChar(80), P_Date DateTime, P_Picture Image)';
  {-----------------------------------------------------------------------------
   ͼƬ: Picture
   *.P_ID: ���
   *.P_Name: ����
   *.P_Mate: ����
   *.P_Date: ʱ��
   *.P_Picture: ͼƬ
  -----------------------------------------------------------------------------}

  sSQL_NewZTLines = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_Name varChar(32), Z_StockNo varChar(20), Z_Stock varChar(80),' +
       'Z_StockType Char(1), Z_PeerWeight Integer,' +
       'Z_QueueMax Integer, Z_VIPLine Char(1), Z_Valid Char(1), Z_Index Integer)';
  {-----------------------------------------------------------------------------
   װ��������: ZTLines
   *.R_ID: ��¼��
   *.Z_ID: ���
   *.Z_Name: ����
   *.Z_StockNo: Ʒ�ֱ��
   *.Z_Stock: Ʒ��
   *.Z_StockType: ����(��,ɢ)
   *.Z_PeerWeight: ����
   *.Z_QueueMax: ���д�С
   *.Z_VIPLine: VIPͨ��
   *.Z_Valid: �Ƿ���Ч
   *.Z_Index: ˳������
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
   ��װ������: ZTTrucks
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_StockNo: Ʒ�ֱ��
   *.T_Stock: Ʒ������
   *.T_Type: Ʒ������(D,S)
   *.T_Line: ���ڵ�
   *.T_Index: ˳������
   *.T_InTime: ���ʱ��
   *.T_InFact: ����ʱ��
   *.T_InQueue: ����ʱ��
   *.T_InLade: ���ʱ��
   *.T_VIP: ��Ȩ
   *.T_Bill: �ᵥ��
   *.T_Valid: �Ƿ���Ч
   *.T_Value: �����
   *.T_PeerWeight: ����
   *.T_Total: ��װ����
   *.T_Normal: ��������
   *.T_BuCha: �������
   *.T_PDate: ����ʱ��
   *.T_IsPound: �����(Y/N)
   *.T_HKBills: �Ͽ��������б�
  -----------------------------------------------------------------------------}

    sSQL_NewBatcode = 'Create Table $Table(R_ID $Inc, B_Stock varChar(32),' +
       'B_Name varChar(80), B_Prefix varChar(5), B_Base Integer,' +
       'B_Interval Integer, B_Incement Integer, B_Length Integer,' +
       'B_UseDate Char(1), B_LastDate DateTime)';
  {-----------------------------------------------------------------------------
   ���α����: Batcode
   *.R_ID: ���
   *.B_Stock: ���Ϻ�
   *.B_Name: ������
   *.B_Prefix: ǰ׺
   *.B_Base: ��ʼ����(����)
   *.B_Interval: ��Чʱ��(��)
   *.B_Incement: �������
   *.B_Length: ��ų���
   *.B_UseDate: ʹ�����ڱ���
   *.B_LastDate: �ϴλ�������ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewBatcodeDoc = 'Create Table $Table(R_ID $Inc, D_ID varChar(32),' +
       'D_Stock varChar(32),D_Name varChar(80), D_Brand varChar(32), ' +
       'D_Plan $Float, D_Sent $Float, D_Rund $Float, D_Init $Float, D_Warn $Float, ' +
       'D_Man varChar(32), D_Date DateTime, D_DelMan varChar(32), D_DelDate DateTime, ' +
       'D_UseDate DateTime, D_LastDate DateTime, D_Valid char(1))';
  {-----------------------------------------------------------------------------
   ���α����: Batcode
   *.R_ID: ���
   *.D_ID: ���κ�
   *.D_Stock: ���Ϻ�
   *.D_Name: ������
   *.D_Brand: ˮ��Ʒ��
   *.D_Plan: �ƻ�����
   *.D_Sent: �ѷ���
   *.D_Rund: �˻���
   *.D_Init: ��ʼ��
   *.D_Warn: Ԥ����
   *.D_Man:  ������
   *.D_Date: ����ʱ��
   *.D_DelMan: ɾ����
   *.D_DelDate: ɾ��ʱ��
   *.D_UseDate: ����ʱ��
   *.D_LastDate: ��ֹʱ��
   *.D_Valid: �Ƿ�����(N�����;Y�����ã�D��ɾ��)
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
       'P_Criterion varChar(32), P_License varChar(64))';
  {-----------------------------------------------------------------------------
   Ʒ�ֲ���:StockParam
   *.P_ID:��¼���
   *.P_Stock:Ʒ��
   *.P_Type:����(��,ɢ)
   *.P_Name:�ȼ���
   *.P_QLevel:ǿ�ȵȼ�
   *.P_Memo:��ע
   *.P_MgO:����þ
   *.P_SO3:��������
   *.P_ShaoShi:��ʧ��
   *.P_CL:������
   *.P_BiBiao:�ȱ����
   *.P_ChuNing:����ʱ��
   *.P_ZhongNing:����ʱ��
   *.P_AnDing:������
   *.P_XiDu:ϸ��
   *.P_Jian:���
   *.P_ChouDu:���
   *.P_BuRong:������
   *.P_YLiGai:�����
   *.P_Water:��ˮ��
   *.P_KuangWu:�����ο���
   *.P_GaiGui:�ƹ��
   *.P_3DZhe:3�쿹��ǿ��
   *.P_28DZhe:28����ǿ��
   *.P_3DYa:3�쿹ѹǿ��
   *.P_28DYa:28��ѹǿ��
   *.P_Methods: ���鷽��
   *.P_Criterion: ִ�б�׼
   *.P_License:�������֤���
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
       'R_Date DateTime, R_Man varChar(32))';
  {-----------------------------------------------------------------------------
   �����¼:StockRecord
   *.R_ID:��¼���
   *.R_SerialNo:ˮ����
   *.R_ExtID: ��չ����ID
   *.R_PID:Ʒ�ֲ���
   *.R_SGType: ʯ������
   *.R_SGValue: ʯ�������
   *.R_HHCType: ��ϲ�����
   *.R_HHCValue: ��ϲĲ�����
   *.R_MgO:����þ
   *.R_SO3:��������
   *.R_ShaoShi:��ʧ��
   *.R_CL:������
   *.R_BiBiao:�ȱ����
   *.R_ChuNing:����ʱ��
   *.R_ZhongNing:����ʱ��
   *.R_AnDing:������
   *.R_XiDu:ϸ��
   *.R_Jian:���
   *.R_ChouDu:���
   *.R_BuRong:������
   *.R_YLiGai:�����
   *.R_Water:��ˮ��
   *.R_KuangWu:�����ο���
   *.R_GaiGui:�ƹ��
   *.R_3DZhe1:3�쿹��ǿ��1
   *.R_3DZhe2:3�쿹��ǿ��2
   *.R_3DZhe3:3�쿹��ǿ��3
   *.R_28Zhe1:28����ǿ��1
   *.R_28Zhe2:28����ǿ��2
   *.R_28Zhe3:28����ǿ��3
   *.R_3DYa1:3�쿹ѹǿ��1
   *.R_3DYa2:3�쿹ѹǿ��2
   *.R_3DYa3:3�쿹ѹǿ��3
   *.R_3DYa4:3�쿹ѹǿ��4
   *.R_3DYa5:3�쿹ѹǿ��5
   *.R_3DYa6:3�쿹ѹǿ��6
   *.R_28Ya1:28��ѹǿ��1
   *.R_28Ya2:28��ѹǿ��2
   *.R_28Ya3:28��ѹǿ��3
   *.R_28Ya4:28��ѹǿ��4
   *.R_28Ya5:28��ѹǿ��5
   *.R_28Ya6:28��ѹǿ��6
   *.R_Date:ȡ������
   *.R_Man:¼����
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecordExt = 'Create Table $Table(R_ID $Inc,E_ID VarChar(30),' +
       'E_Group varChar(32),' +
       'E_Stock varChar(32),E_Name varChar(80), E_Brand varChar(32), ' +
       'E_Plan $Float, E_Sent $Float, E_Rund $Float, ' +
       'E_Init $Float, E_Warn $Float, E_Freeze $Float, E_WCValue $Float,' +
       'E_Man varChar(32), E_Date DateTime, E_DelMan varChar(32), E_DelDate DateTime, ' +
       'E_UseDate DateTime, E_LastDate DateTime, E_Status char(1) Default ''Y'')';
  {-----------------------------------------------------------------------------
   ��¼��չ: StockRecordExt
   *.R_ID: ���
   *.E_ID: ID
   *.E_Group: ����
   *.E_Stock: ���Ϻ�
   *.E_Name: ������
   *.E_Brand: ˮ��Ʒ��
   *.E_Plan: �ƻ�����
   *.E_Sent: �ѷ���
   *.E_Init: ��ʼ��
   *.E_Rund: �˻���
   *.E_Warn: Ԥ����
   *.E_Freeze: ������
   *.E_WCValue: �����
   *.E_Man:  ������
   *.E_Date: ����ʱ��
   *.E_DelMan: ɾ����
   *.E_DelDate: ɾ��ʱ��
   *.E_UseDate: ����ʱ��
   *.E_LastDate: ��ֹʱ��
   *.E_Status: �Ƿ�����(N�����;Y�����ã�D��ɾ��)
  -----------------------------------------------------------------------------}

  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_No varChar(15),' +
       'H_Custom varChar(15), H_CusName varChar(80), H_SerialNo varChar(15),' +
       'H_Truck varChar(15), H_Value $Float, ' +
       'H_BillNO DateTime, H_BillDate DateTime,' +
       'H_EachTruck Char(1), H_ReportDate DateTime, H_Reporter varChar(32),' +
       'H_ReportDate2 DateTime, H_Reporter2 varChar(32))';
  {-----------------------------------------------------------------------------
   �����鵥:StockHuaYan
   *.H_ID:��¼���
   *.H_No:���鵥��
   *.H_Custom:�ͻ����
   *.H_CusName:�ͻ�����
   *.H_SerialNo:ˮ����
   *.H_Truck:�������
   *.H_Value:�����
   *.H_BillDate:�������
   *.H_EachTruck: �泵����
   *.H_ReportDate:��������
   *.H_Reporter:������
   *.H_ReportDate2:��������
   *.H_Reporter2:������
  -----------------------------------------------------------------------------}

  sSQL_NewDataTemp = 'Create Table $Table(T_SysID varChar(15))';
  {-----------------------------------------------------------------------------
   ��ʱ���ݱ�: DataTemp
   *.T_SysID: ϵͳ���
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(32),' +
       'P_Name varChar(80),P_PY varChar(80), P_Phone varChar(20),' +
       'P_Saler varChar(32),P_Type Char(1), P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ӧ��: Provider
   *.P_ID: ���
   *.P_Name: ����
   *.P_PY: ƴ����д
   *.P_Phone: ��ϵ��ʽ
   *.P_Saler: ҵ��Ա
   *.P_Type: ��Ӧ������,��Դ�ۺ�����(���߷���Դ�ۺ�����)
   *.P_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(R_ID $Inc, M_ID varChar(32),' +
       'M_Name varChar(80),M_PY varChar(80),M_Unit varChar(20),M_Price $Float,' +
       'M_PrePValue Char(1), M_PrePTime Integer, M_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ���ϱ�: Materails
   *.M_ID: ���
   *.M_Name: ����
   *.M_PY: ƴ����д
   *.M_Unit: ��λ
   *.M_PrePValue: Ԥ��Ƥ��
   *.M_PrePTime: Ƥ��ʱ��(��)
   *.M_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewOrderBase = 'Create Table $Table(R_ID $Inc, B_ID varChar(20),' +
       'B_Value $Float, B_SentValue $Float,B_RestValue $Float,' +
       'B_LimValue $Float, B_WarnValue $Float,B_FreezeValue $Float,' +
       'B_BStatus Char(1),B_Area varChar(50), B_Project varChar(100),' +
       'B_ProType Char(1), B_ProID varChar(32), ' +
       'B_ProName varChar(80), B_ProPY varChar(80),' +
       'B_SaleID varChar(32), B_SaleMan varChar(80), B_SalePY varChar(80),' +
       'B_StockType Char(1), B_StockNo varChar(32), B_StockName varChar(80),' +
       'B_Man varChar(32), B_Date DateTime,' +
       'B_DelMan varChar(32), B_DelDate DateTime, B_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ɹ����뵥��: Order
   *.R_ID: ���
   *.B_ID: �ᵥ��
   *.B_Value,B_SentValue,B_RestValue:���������ѷ�����ʣ����
   *.B_LimValue,B_WarnValue,B_FreezeValue:������������;����Ԥ����,����������
   *.B_BStatus: ����״̬
   *.B_Area,B_Project: ����,��Ŀ
   *.B_ProID,B_ProName,B_ProPY, B_ProType:��Ӧ��
   *.B_SaleID,B_SaleMan,B_SalePY:ҵ��Ա
   *.B_StockType: ����(��,ɢ)
   *.B_StockNo: ԭ���ϱ��
   *.B_StockName: ԭ��������
   *.B_Man:������
   *.B_Date:����ʱ��
   *.B_DelMan: �ɹ����뵥ɾ����Ա
   *.B_DelDate: �ɹ����뵥ɾ��ʱ��
   *.B_Memo: ������ע
  -----------------------------------------------------------------------------}

  sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(20),' +
       'O_BID varChar(20),O_Card varChar(16), O_CType varChar(1),' +
       'O_Value $Float,O_Area varChar(50), O_Project varChar(100),' +
       'O_ProType Char(1), O_ProID varChar(32), ' +
       'O_ProName varChar(80), O_ProPY varChar(80),' +
       'O_SaleID varChar(32), O_SaleMan varChar(80), O_SalePY varChar(80),' +
       'O_Type Char(1), O_StockNo varChar(32), O_StockName varChar(80),' +
       'O_Truck varChar(15), O_OStatus Char(1),' +
       'O_Man varChar(32), O_Date DateTime,' +
       'O_DelMan varChar(32), O_DelDate DateTime, O_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ɹ�������: Order
   *.R_ID: ���
   *.O_ID: �ᵥ��
   *.O_BID: �ɹ����뵥�ݺ�
   *.O_Card,O_CType: �ſ���,�ſ�����(L����ʱ��;G���̶���)
   *.O_Value:��������
   *.O_OStatus: ����״̬
   *.O_Area,O_Project: ����,��Ŀ
   *.O_ProType,O_ProID,O_ProName,O_ProPY:��Ӧ��
   *.O_SaleID,O_SaleMan:ҵ��Ա
   *.O_Type: ����(��,ɢ)
   *.O_StockNo: ԭ���ϱ��
   *.O_StockName: ԭ��������
   *.O_Truck: ������
   *.O_Man:������
   *.O_Date:����ʱ��
   *.O_DelMan: �ɹ���ɾ����Ա
   *.O_DelDate: �ɹ���ɾ��ʱ��
   *.O_Memo: ������ע
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_ID varChar(20),' +
       'D_OID varChar(20), D_PID varChar(20), D_Card varChar(16), ' +
       'D_Area varChar(50), D_Project varChar(100),D_Truck varChar(15), ' +
       'D_ProType Char(1), D_ProID varChar(32), ' +
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
       'D_OutFact DateTime, D_OutMan varChar(32), D_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ɹ�������ϸ��: OrderDetail
   *.R_ID: ���
   *.D_ID: �ɹ���ϸ��
   *.D_OID: �ɹ�����
   *.D_PID: ������
   *.D_Card: �ɹ��ſ���
   *.D_DStatus: ����״̬
   *.D_Area,D_Project: ����,��Ŀ
   *.D_ProType,D_ProID,D_ProName,D_ProPY:��Ӧ��
   *.D_SaleID,D_SaleMan:ҵ��Ա
   *.D_Type: ����(��,ɢ)
   *.D_StockNo: ԭ���ϱ��
   *.D_StockName: ԭ��������
   *.D_Truck: ������
   *.D_Status,D_NextStatus: ״̬
   *.D_InTime,D_InMan: ��������
   *.D_PValue,D_PDate,D_PMan: ��Ƥ��
   *.D_MValue,D_MDate,D_MMan: ��ë��
   *.D_YTime,D_YMan: �ջ�ʱ��,������,
   *.D_Value,D_KZValue,D_AKValue: �ջ���,���տ۳�(����),����
   *.D_YLine,D_YLineName: �ջ�ͨ��
   *.D_YSResult: ���ս��
   *.D_OutFact,D_OutMan: ��������
  -----------------------------------------------------------------------------}

  sSQL_NewDeduct = 'Create Table $Table(R_ID $Inc, D_Stock varChar(32),' +
       'D_Name varChar(80), D_CusID varChar(32), D_CusName varChar(80),' +
       'D_Value $Float, D_Type Char(1), D_Valid Char(1))';
  {-----------------------------------------------------------------------------
   ���۹����: Batcode
   *.R_ID: ���
   *.D_Stock: ���Ϻ�
   *.D_Name: ������
   *.D_CusID: �ͻ���
   *.D_CusName: �ͻ���
   *.D_Value: ȡֵ
   *.D_Type: ����(F,�̶�ֵ;P,�ٷֱ�)
   *.D_Valid: �Ƿ���Ч(Y/N)
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// ���ݲ�ѯ
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo, D_ParamA, ' +
         'D_ParamB From $Table Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   �������ֵ��ȡ����
   *.$Table:�����ֵ��
   *.$Name:�ֵ�������
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
         'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   ����չ��Ϣ���ȡ����
   *.$Table:��չ��Ϣ��
   *.$Group:��������
   *.$ID:��Ϣ��ʶ
  -----------------------------------------------------------------------------}

  sQuery_ZhiKa = 'Select Z_ID,Z_Name,Z_Freeze,Z_Card, Z_CardNO, Z_Password,' +
         'Z_Customer,Z_InValid,' +
         'Z_TJStatus From $Table Where Z_ID=''$ZID'' Order By Z_ID ASC';
  {-----------------------------------------------------------------------------
   ��ֽ�����ж�ȡ������Ϣ
   *.$Table:������
   *.$ZID:�������
  -----------------------------------------------------------------------------}

  sQuery_ZhiKaDtl = 'Select D_ZID, D_Type, D_StockNo, D_StockName, D_Price,' +
         'D_Value From $Table Where D_ZID=''$DZID'' Order By D_StockNo ASC';
  {-----------------------------------------------------------------------------
   ��ֽ�����ж�ȡ������Ϣ
   *.$Table:������ϸ��
   *.$DZID:�������
  -----------------------------------------------------------------------------}

function CardStatusToStr(const nStatus: string): string;
//�ſ�״̬
function TruckStatusToStr(const nStatus: string): string;
//����״̬
function BillTypeToStr(const nType: string): string;
//��������
function PostTypeToStr(const nPost: string): string;
//��λ����

implementation


//Desc: ��nStatusתΪ�ɶ�����
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '����' else
  if nStatus = sFlag_CardUsed then Result := '����' else
  if nStatus = sFlag_CardLoss then Result := '��ʧ' else
  if nStatus = sFlag_CardInvalid then Result := 'ע��' else Result := 'δ֪';
end;

//Desc: ��nStatusתΪ��ʶ�������
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '����' else
  if nStatus = sFlag_TruckOut then Result := '����' else
  if nStatus = sFlag_TruckBFP then Result := '��Ƥ��' else
  if nStatus = sFlag_TruckBFM then Result := '��ë��' else
  if nStatus = sFlag_TruckSH then Result := '�ͻ���' else
  if nStatus = sFlag_TruckXH then Result := '���մ�' else
  if nStatus = sFlag_TruckFH then Result := '�ŻҴ�' else
  if nStatus = sFlag_TruckZT then Result := 'ջ̨' else Result := 'δ����';
end;

//Desc: ����������תΪ��ʶ������
function BillTypeToStr(const nType: string): string;
begin
  if nType = sFlag_TypeShip then Result := '����' else
  if nType = sFlag_TypeZT   then Result := 'ջ̨' else
  if nType = sFlag_TypeVIP  then Result := 'VIP' else Result := '��ͨ';
end;

//Desc: ����λתΪ��ʶ������
function PostTypeToStr(const nPost: string): string;
begin
  if nPost = sFlag_TruckIn   then Result := '��������' else
  if nPost = sFlag_TruckOut  then Result := '��������' else
  if nPost = sFlag_TruckBFP  then Result := '������Ƥ' else
  if nPost = sFlag_TruckBFM  then Result := '��������' else
  if nPost = sFlag_TruckFH   then Result := 'ɢװ�Ż�' else
  if nPost = sFlag_TruckZT   then Result := '��װջ̨' else Result := '����';
end;

//------------------------------------------------------------------------------
//Desc: ���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: ϵͳ��
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);
  //ϵͳ����

  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase);
  AddSysTableItem(sTable_SerialStatus, sSQL_NewSerialStatus);
  AddSysTableItem(sTable_StockMatch, sSQL_NewStockMatch);
  AddSysTableItem(sTable_WorkePC, sSQL_NewWorkePC);
  //�������֤

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
  //�ͻ��ʻ���Ϣ�����ۺ�ͬ

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
  //�������Ϣ

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
end;

//Desc: ����ϵͳ��
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


