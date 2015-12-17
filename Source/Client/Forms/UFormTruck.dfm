inherited fFormTruck: TfFormTruck
  Left = 573
  Top = 165
  ClientHeight = 457
  ClientWidth = 444
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 444
    Height = 457
    inherited BtnOK: TButton
      Left = 298
      Top = 424
      TabOrder = 20
    end
    inherited BtnExit: TButton
      Left = 368
      Top = 424
      TabOrder = 21
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 36
      Hint = 'T.T_Truck'
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 0
      Width = 116
    end
    object EditOwner: TcxTextEdit [3]
      Left = 81
      Top = 61
      Hint = 'T.T_Owner'
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 1
      Width = 125
    end
    object EditPhone: TcxTextEdit [4]
      Left = 271
      Top = 61
      Hint = 'T.T_Phone'
      ParentFont = False
      TabOrder = 7
      Width = 138
    end
    object CheckValid: TcxCheckBox [5]
      Left = 23
      Top = 339
      Caption = #36710#36742#20801#35768#24320#21333'.'
      ParentFont = False
      TabOrder = 15
      Transparent = True
      Width = 80
    end
    object CheckVerify: TcxCheckBox [6]
      Left = 23
      Top = 391
      Caption = #39564#35777#36710#36742#24050#21040#20572#36710#22330'.'
      ParentFont = False
      TabOrder = 18
      Transparent = True
      Width = 165
    end
    object CheckUserP: TcxCheckBox [7]
      Left = 23
      Top = 365
      Caption = #36710#36742#20351#29992#39044#32622#30382#37325'.'
      ParentFont = False
      TabOrder = 16
      Transparent = True
      Width = 165
    end
    object CheckVip: TcxCheckBox [8]
      Left = 193
      Top = 365
      Caption = 'VIP'#36710#36742
      ParentFont = False
      TabOrder = 17
      Transparent = True
      Width = 100
    end
    object CheckGPS: TcxCheckBox [9]
      Left = 193
      Top = 391
      Caption = #24050#23433#35013'GPS'
      ParentFont = False
      TabOrder = 19
      Transparent = True
      Width = 100
    end
    object EditHZValue: TcxTextEdit [10]
      Left = 81
      Top = 136
      Hint = 'T.T_HZValue'
      ParentFont = False
      TabOrder = 5
      Width = 94
    end
    object cxLabel1: TcxLabel [11]
      Left = 180
      Top = 136
      Caption = #21315#20811
      ParentFont = False
      Transparent = True
    end
    object EditNum: TcxTextEdit [12]
      Left = 271
      Top = 136
      Hint = 'T.T_Bearings'
      ParentFont = False
      TabOrder = 11
      Width = 121
    end
    object EditYSSerial: TcxTextEdit [13]
      Left = 81
      Top = 161
      Hint = 'T.T_YSSerial'
      ParentFont = False
      TabOrder = 12
      Width = 121
    end
    object EditZGSerial: TcxTextEdit [14]
      Left = 81
      Top = 186
      Hint = 'T.T_ZGSerial'
      ParentFont = False
      TabOrder = 13
      Width = 121
    end
    object EditMemo: TcxMemo [15]
      Left = 81
      Top = 211
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 14
      Height = 89
      Width = 304
    end
    object EditPValue: TcxTextEdit [16]
      Left = 81
      Top = 111
      Hint = 'T.T_PValue'
      ParentFont = False
      TabOrder = 3
      Width = 96
    end
    object EditCGValue: TcxTextEdit [17]
      Left = 271
      Top = 111
      Hint = 'T.T_CGHZValue'
      ParentFont = False
      TabOrder = 9
      Width = 121
    end
    object cxLabel2: TcxLabel [18]
      Left = 182
      Top = 111
      Caption = #21544
      ParentFont = False
      Transparent = True
    end
    object cxLabel3: TcxLabel [19]
      Left = 397
      Top = 111
      Caption = #21544
      ParentFont = False
      Transparent = True
    end
    object EditDrver: TcxTextEdit [20]
      Left = 81
      Top = 86
      Hint = 'T.T_Driver'
      TabOrder = 2
      Width = 121
    end
    object EditDrvPhone: TcxTextEdit [21]
      Left = 271
      Top = 86
      Hint = 'T.T_DrPhone'
      TabOrder = 8
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item9: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #36710#20027#22995#21517':'
              Control = EditOwner
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              Caption = #21496#26426#22995#21517':'
              Control = EditDrver
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group8: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              ShowBorder = False
              object dxLayout1Group9: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                LayoutDirection = ldHorizontal
                ShowBorder = False
                object dxLayout1Item19: TdxLayoutItem
                  Caption = #36710#36742#30382#37325':'
                  Control = EditPValue
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item21: TdxLayoutItem
                  Caption = 'cxLabel2'
                  ShowCaption = False
                  Control = cxLabel2
                  ControlOptions.ShowBorder = False
                end
              end
              object dxLayout1Group7: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                LayoutDirection = ldHorizontal
                ShowBorder = False
                object dxLayout1Item13: TdxLayoutItem
                  Caption = #26680#36733#37325#37327':'
                  Control = EditHZValue
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item14: TdxLayoutItem
                  Caption = 'cxLabel1'
                  ShowCaption = False
                  Control = cxLabel1
                  ControlOptions.ShowBorder = False
                end
              end
            end
          end
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #32852#31995#26041#24335':'
              Control = EditPhone
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              Caption = #21496#26426#30005#35805':'
              Control = EditDrvPhone
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group10: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item20: TdxLayoutItem
                Caption = #26368#22823#36733#37325':'
                Control = EditCGValue
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item22: TdxLayoutItem
                Caption = 'cxLabel3'
                ShowCaption = False
                Control = cxLabel3
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item15: TdxLayoutItem
              Caption = #36724#25215#25968#37327':'
              Control = EditNum
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item16: TdxLayoutItem
          Caption = #36816#36755#35777#21495':'
          Control = EditYSSerial
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item17: TdxLayoutItem
          Caption = #20174#19994#35777#21495':'
          Control = EditZGSerial
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item18: TdxLayoutItem
          Caption = #22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36710#36742#21442#25968
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckValid
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            ShowCaption = False
            Control = CheckUserP
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckVip
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = 'cxCheckBox2'
            ShowCaption = False
            Control = CheckVerify
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckGPS
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
