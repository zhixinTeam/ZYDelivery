unit UMgrURFR300_Head;

interface

Const
  UURFR300_DLLName = 'mwrf32.dll';

type
  RTempRecord=Record
  end;
  //==========================================================================================//
  {a example for your to try using .dll. add_s return i+1}
  Function add_s(i: smallint): smallint; stdcall;
  far;external UURFR300_DLLName name 'add_s';
  {comm Function.}
  Function rf_init(port: smallint;baud:longint): longint; stdcall;
  far;external UURFR300_DLLName name 'rf_init';
  Function rf_exit(icdev: longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_exit';
  Function rf_encrypt(key:pchar;ptrsource:pchar;msglen:smallint;ptrdest:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_encrypt';
  Function rf_decrypt(key:pchar;ptrsource:pchar;msglen:smallint;ptrdest:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_decrypt';
  //
  Function rf_card(icdev:longint;mode:smallint;snr:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_card';
  Function rf_load_key(icdev:longint;mode,secnr:smallint;nkey:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_load_key';
  Function rf_load_key_hex(icdev:longint;mode,secnr:smallint;nkey:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_load_key_hex';
  Function rf_authentication(icdev:longint;mode,secnr:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_authentication';
  //
  Function rf_read(icdev:longint;adr:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_read';
  Function rf_read_hex(icdev:longint;adr:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_read_hex';
  Function rf_write(icdev:longint;adr:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_write';
  Function rf_write_hex(icdev:longint;adr:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_write_hex';
  Function rf_halt(icdev:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_halt';
  Function rf_reset(icdev:longint;msec:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_reset';
  //M1 CARD
  Function rf_initval(icdev:longint;adr:smallint;value:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_initval';
  Function rf_readval(icdev:longint;adr:smallint;value:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_readval';
  Function rf_increment(icdev:longint;adr:smallint;value:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_increment';
  Function rf_decrement(icdev:longint;adr:smallint;value:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_decrement';
  Function rf_restore(icdev:longint;adr:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_restore';
  Function rf_transfer(icdev:longint;adr:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_transfer';
  Function rf_check_write(icdev,snr:longint;adr,authmode:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_check_write';
  Function rf_check_writehex(icdev,snr:longint;adr,authmode:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_check_writehex';

    //M1 CARD HIGH Function
  Function rf_HL_initval(icdev:longint;mode:smallint;secnr:smallint;value:longint;snr:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_HL_initval';
  Function rf_HL_increment(icdev:longint;mode:smallint;secnr:smallint;value,snr:longint;svalue,ssnr:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_HL_increment';
  Function rf_HL_decrement(icdev:longint;mode:smallint;secnr:smallint;value:longint;snr:longint;svalue,ssnr:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_HL_decrement';
  Function rf_HL_write(icdev:longint;mode,adr:smallint;ssnr,sdata:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_HL_write';
  Function rf_HL_read(icdev:longint;mode,adr:smallint;snr:longint;sdata,ssnr:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_HL_read';
  Function rf_changeb3(Adr:pchar;keyA:pchar;B0:pchar;B1:pchar;B2:pchar;B3:pchar;Bk:pchar;KeyB:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_changeb3';
  //DEVICE
  Function rf_get_status(icdev:longint;status:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_get_status';
  Function rf_beep(icdev:longint;time:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_beep';
  Function rf_ctl_mode(icdev:longint;ctlmode:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_ctl_mode';
  Function rf_disp_mode(icdev:longint;mode:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_disp_mode';
  Function rf_disp8(icdev:longint;len:longint;disp:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_disp8';
  Function rf_disp(icdev:longint;pt_mode:smallint;disp:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_disp';
  //
  Function rf_settimehex(icdev:longint;dis_time:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_settimehex';
  Function rf_gettimehex(icdev:longint;dis_time:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_gettimehex';
  Function rf_swr_eeprom(icdev:longint;offset,len:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_swr_eeprom';
  Function rf_srd_eeprom(icdev:longint;offset,len:smallint;data:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_srd_eeprom';
  //ML CARD
  Function rf_authentication_2(icdev:longint;mode,keyNum,secnr:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_authentication_2';
  Function rf_initval_ml(icdev:longint;value:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_initval_ml';
  Function rf_readval_ml(icdev:longint;rvalue:pchar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_readval_ml';
  Function rf_decrement_transfer(icdev:longint;adr:smallint;value:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_decrement_transfer';
  Function rf_sam_rst(icdev:longint;baud:smallint;samack:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_sam_rst';
  Function rf_sam_trn(icdev:longint;samblock,recv:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_sam_trn';
  Function rf_sam_off(icdev:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_sam_off';
  Function rf_cpu_rst(icdev:longint;baud:smallint;cpuack:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_cpu_rst';
  Function rf_cpu_trn(icdev:longint;cpublock,recv:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_cpu_trn';
  Function rf_pro_rst(icdev:longint;_Data:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_pro_rst';
  Function rf_pro_trn(icdev:longint;problock,recv:pChar):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_pro_trn';
  Function rf_pro_halt(icdev:longint):smallint;stdcall;
  far;external UURFR300_DLLName name 'rf_pro_halt';
  Function hex_a(hex,a:pChar;length:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'hex_a';
  Function a_hex(a,hex:pChar;length:smallint):smallint;stdcall;
  far;external UURFR300_DLLName name 'a_hex';

implementation

end.
