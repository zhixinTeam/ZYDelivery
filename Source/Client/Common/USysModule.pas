{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

interface

{$I Link.Inc}
uses
  UClientWorker, UMITPacker, UMemDataPool,
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormClearData
  {$IFDEF SHXZY},
  UFormPassword, UFormBaseInfo, UFrameAuthorize, UFormAuthorize,
  UFrameCustomer, UFormCustomer, UFormGetCustom, UFrameCustAddr, UFormCusAddr,
  UFrameSalesMan, UFormSalesMan,
  UFrameShouJu, UFormShouJu, UFramePayment, UFormPayment, UFormCustomerCredit,
  UFrameCustomerCredit, UFrameCusAccount, UFrameCusInOutMoney, UFormMoneyAdjust,
  UFrameCompensateAccount, UFrameCompensateInOutMoney,
  UFormFLPayment, UFrameFLPayment, UFormFLZhiKa, UFrameFLZhiKa,
  UFrameTransContract, UFormTransContract, UFrameTransPayment,UFrameTransCredit,
  UFrameTransAccount, UFrameTransInOutMoney, UFrameTruckLogs, UFrameTruckJieSuan,
  UFrameQueryTransTotal,
  UFrameSaleContract, UFormSaleContract, UFormGetContract,
  UFormFXZhiKa, UFrameFXZhiKa, UFormGetFXZhiKa, UFormReadICCard,
  UFormGetFactZhiKa, UFormFactZhiKaBind,
  UFrameZhiKa, UFormZhiKa, UFormGetZhiKa, UFrameZhiKaDetail, UFormZhiKaFreeze,
  UFormZhiKaPrice, UFormZhiKaAdjust, UFormZhiKaFixMoney,
  UFrameZhiKaVerify, UFormZhiKaVerify, UFormBillAdditional,
  UFrameBill, UFormBill, UFrameBillCard, UFormGetBill,
  UFormGetTruck, UFrameTrucks, UFormTruck, UFrameTruckQuery,
  UFormCard, UFormTruckIn, UFormTruckOut, UFormLadingDai, UFormLadingSan,
  UFramePoundManual, UFramePoundAuto, UFramePMaterails, UFormPMaterails,
  UFramePProvider, UFormPProvider, UFramePoundQuery, UFrameQuerySaleDetail,
  UFrameQuerySealDetail,UFrameZTDispatch, UFrameQueryDiapatch,UFrameQueryBillTotal,
  UFramePurchaseOrder, UFormPurchaseOrder, UFormPurchasing, UFormOrderAdditional,
  UFrameQueryOrderDetail, UFrameOrderCard,  UFrameOrderDetail,
  UFormGetProvider, UFormGetMeterails, UFramePOrderBase, UFormPOrderBase,
  UFormGetPOrderBase, UFrameDeduct, UFormDeduct, UFrameQueryOrderTotal,
  UFormRefund, UFormRefundNew, UFrameRefund, UFrameQueryRefundDetail,
  UFrameQueryRefundTotal,

  UFormHYStock, UFormHYData, UFormHYRecord, UFormGetStockNo,
  UFrameHYStock, UFrameHYData, UFrameHYRecord
  {$ELSE},
  UFormTruckTrans,UFrameBatcodeQuery,UFormBatcodeEdit,UFrameBatcode,UFormBatcode,
  UFrameInvoiceWeek, UFormInvoiceWeek, UFormInvoiceGetWeek,
  UFrameInvoice, UFormInvoice, UFormInvoiceAdjust,UFrameInvoiceK, UFormInvoiceK,
  UFrameInvoiceDtl, UFrameInvoiceZZ, UFormInvoiceZZAll, UFormInvoiceZZCus,
  UFormRFIDCard
  {$ENDIF};

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  UMgrChannel, UChannelChooser, UDataModule, USysDB, USysMAC, SysUtils,
  USysLoger, USysConst, UMgrLEDDisp;

//Desc: 初始化系统对象
procedure InitSystemObject;
var nStr: string;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger

  if not Assigned(gMemDataManager) then
    gMemDataManager := TMemDataManager.Create;
  //xxxxx

  nStr := gPath + 'LEDDisp.xml';
  if FileExists(nStr) then
  begin
    gDisplayManager.TempDir := gPath + 'Temp\';
    gDisplayManager.LoadConfig(nStr);
    gDisplayManager.StartDisplay;
  end; //小屏显示

  gChannelManager := TChannelManager.Create;
  gChannelManager.ChannelMax := 20;
  gChannelChoolser := TChannelChoolser.Create('');
  gChannelChoolser.AutoUpdateLocal := False;
  //channel
end;

//Desc: 运行系统对象
procedure RunSystemObject;
var nStr: string;
begin
  with gSysParam do
  begin
    FLocalMAC   := MakeActionID_MAC;
    GetLocalIPConfig(FLocalName, FLocalIP);
  end;

  nStr := 'Select W_Factory,W_Serial From %s ' +
          'Where W_MAC=''%s'' And W_Valid=''%s''';
  nStr := Format(nStr, [sTable_WorkePC, gSysParam.FLocalMAC, sFlag_Yes]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gSysParam.FFactNum := Fields[0].AsString;
    gSysParam.FSerialID := Fields[1].AsString;
  end;

  //----------------------------------------------------------------------------
  with gSysParam do
  begin
    FPoundDaiZ := 0;
    FPoundDaiF := 0;
    FPoundSanF := 0;
    FDaiWCStop := False;
    FDaiPercent := False;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[1].AsString;
      if nStr = sFlag_PDaiWuChaZ then
        gSysParam.FPoundDaiZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiWuChaF then
        gSysParam.FPoundDaiF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiPercent then
        gSysParam.FDaiPercent := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PDaiWuChaStop then
        gSysParam.FDaiWCStop := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PSanWuChaF then
        gSysParam.FPoundSanF := Fields[0].AsFloat;

      if nStr = sFlag_PSanWuChaStop then
        gSysParam.FSanStop := Fields[0].AsString = sFlag_Yes;
      //xxxxx
      Next;
    end;

    with gSysParam do
    begin
      FPoundDaiZ_1 := FPoundDaiZ;
      FPoundDaiF_1 := FPoundDaiF;
      //backup wucha value
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_MITSrvURL]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      gChannelChoolser.AddChannelURL(Fields[0].AsString);
      Next;
    end;

    {$IFNDEF DEBUG}
    gChannelChoolser.StartRefresh;
    {$ENDIF}//update channel
  end;

  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_HardSrvURL]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gSysParam.FHardMonURL := Fields[0].AsString;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_Customer]);

  gSysParam.FCustomer := '';
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      if Fields[0].AsString = '' then Continue;
      gSysParam.FCustomer := gSysParam.FCustomer + Fields[0].AsString + ',';
    finally
      Next;
    end;  
  end;
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  gDisplayManager.Display('ShowBill', gDisplayManager.DefaultTxt);
  Sleep(5000);
  //xxxxx
  gDisplayManager.StopDisplay;
  FreeAndNil(gSysLoger);
end;

end.
