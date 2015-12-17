inherited fFormTransContract: TfFormTransContract
  Left = 639
  Top = 139
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 487
  ClientWidth = 542
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 542
    Height = 487
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditMemo: TcxMemo
      Left = 81
      Top = 236
      Hint = 'T.T_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 13
      Height = 40
      Width = 304
    end
    object BtnOK: TButton
      Left = 387
      Top = 453
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 23
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 462
      Top = 453
      Width = 69
      Height = 23
      Caption = #21462#28040
      TabOrder = 24
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 81
      Top = 36
      Hint = 'T.T_ID'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 304
    end
    object EditCPrice: TcxTextEdit
      Left = 81
      Top = 313
      ParentFont = False
      TabOrder = 14
      Text = '0.00'
      Width = 176
    end
    object EditDPrice: TcxTextEdit
      Left = 320
      Top = 313
      ParentFont = False
      TabOrder = 19
      Text = '0.00'
      Width = 177
    end
    object EditCusName: TcxTextEdit
      Left = 81
      Top = 86
      Hint = 'T.T_CusName'
      ParentFont = False
      TabOrder = 2
      Width = 184
    end
    object EditSaleMan: TcxTextEdit
      Left = 328
      Top = 86
      Hint = 'T.T_SaleMan'
      ParentFont = False
      TabOrder = 8
      Width = 177
    end
    object EditProject: TcxTextEdit
      Left = 81
      Top = 111
      Hint = 'T.T_Project'
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditAddr: TcxTextEdit
      Left = 328
      Top = 136
      Hint = 'T.T_Addr'
      ParentFont = False
      TabOrder = 10
      Text = #28510#22478#24066#23433#25463#35013#21368#36816#26381#21153#26377#38480#20844#21496
      Width = 161
    end
    object EditArea: TcxButtonEdit
      Left = 81
      Top = 136
      Hint = 'T.T_Area'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditAreaPropertiesButtonClick
      TabOrder = 4
      Width = 176
    end
    object EditSrcAddr: TcxTextEdit
      Left = 328
      Top = 111
      Hint = 'T.T_SrcAddr'
      ParentFont = False
      TabOrder = 9
      Text = #21331#36234#27700#27877#20844#21496
      Width = 121
    end
    object EditPayment: TcxComboBox
      Left = 81
      Top = 211
      Hint = 'T.T_Payment'
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditAID: TcxComboBox
      Left = 81
      Top = 161
      ParentFont = False
      Properties.OnChange = EditAIDPropertiesChange
      TabOrder = 5
      Width = 121
    end
    object EditRecvMan: TcxTextEdit
      Left = 81
      Top = 186
      Hint = 'T.T_RecvMan'
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object EditCusPhone: TcxTextEdit
      Left = 328
      Top = 186
      Hint = 'T.T_CusPhone'
      ParentFont = False
      TabOrder = 12
      Width = 121
    end
    object EditTruck: TcxTextEdit
      Left = 81
      Top = 338
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 15
      Width = 121
    end
    object EditStock: TcxTextEdit
      Left = 320
      Top = 338
      Hint = 'T.T_StockName'
      ParentFont = False
      TabOrder = 20
      Width = 121
    end
    object EditDriver: TcxTextEdit
      Left = 81
      Top = 363
      Hint = 'T.T_Driver'
      ParentFont = False
      TabOrder = 16
      Width = 121
    end
    object EditDPhone: TcxTextEdit
      Left = 320
      Top = 363
      Hint = 'T.T_DrvPhone'
      ParentFont = False
      TabOrder = 21
      Width = 121
    end
    object EditLID: TcxButtonEdit
      Left = 81
      Top = 61
      Hint = 'T.T_LID'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditLIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditValue: TcxTextEdit
      Left = 81
      Top = 388
      ParentFont = False
      TabOrder = 17
      Text = '0.00'
      Width = 121
    end
    object EditTValue: TcxTextEdit
      Left = 320
      Top = 388
      ParentFont = False
      TabOrder = 22
      Text = '0.00'
      Width = 121
    end
    object EditDistance: TcxTextEdit
      Left = 81
      Top = 413
      ParentFont = False
      TabOrder = 18
      Text = '0.00'
      Width = 121
    end
    object EditDestAddr: TcxTextEdit
      Left = 328
      Top = 161
      Hint = 'T.T_Delivery'
      ParentFont = False
      TabOrder = 11
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #21327#35758#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item21: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditLID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Item5: TdxLayoutItem
              Caption = #23458#25143#21517#31216':'
              Control = EditCusName
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item2: TdxLayoutItem
              Caption = #39033#30446#21517#31216':'
              Control = EditProject
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item7: TdxLayoutItem
              Caption = #31614#35746#21306#22495':'
              Control = EditArea
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item12: TdxLayoutItem
              Caption = #22320#22336#32534#21495':'
              Control = EditAID
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item13: TdxLayoutItem
              Caption = #25910' '#36135' '#20154':'
              Control = EditRecvMan
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item9: TdxLayoutItem
              Caption = #20184#27454#26041#24335':'
              Control = EditPayment
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Item6: TdxLayoutItem
              Caption = #38144#21806#32463#29702':'
              Control = EditSaleMan
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item8: TdxLayoutItem
              Caption = #35013#36135#22320#22336':'
              Control = EditSrcAddr
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item3: TdxLayoutItem
              Caption = #31614#35746#22320#28857':'
              Control = EditAddr
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item25: TdxLayoutItem
              Caption = #20132#36135#22320#28857':'
              Control = EditDestAddr
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item14: TdxLayoutItem
              Caption = #32852#31995#26041#24335':'
              Control = EditCusPhone
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxLayoutControl1Group2: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #21327#35758#26126#32454
          LayoutDirection = ldHorizontal
          object dxLayoutControl1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Item16: TdxLayoutItem
              Caption = #23458#25143#21333#20215':'
              Control = EditCPrice
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item15: TdxLayoutItem
              Caption = #36710' '#29260' '#21495':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item19: TdxLayoutItem
              Caption = #36816#36755#21496#26426':'
              Control = EditDriver
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item22: TdxLayoutItem
              Caption = #21457' '#36135' '#37327':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item24: TdxLayoutItem
              Caption = #36816#36755#36317#31163':'
              Control = EditDistance
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group9: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Item17: TdxLayoutItem
              Caption = #21496#26426#21333#20215':'
              Control = EditDPrice
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item18: TdxLayoutItem
              Caption = #27700#27877#21697#31181':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item20: TdxLayoutItem
              Caption = #32852#31995#26041#24335':'
              Control = EditDPhone
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item23: TdxLayoutItem
              Caption = #30830#35748#25910#36135':'
              Control = EditTValue
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Group12: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avBottom
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button3'
            ShowCaption = False
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button4'
            ShowCaption = False
            Control = BtnExit
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
