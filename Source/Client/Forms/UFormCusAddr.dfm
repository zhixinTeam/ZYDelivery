inherited fFormCusAddr: TfFormCusAddr
  Left = 684
  Top = 326
  ClientHeight = 326
  ClientWidth = 464
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 464
    Height = 326
    inherited BtnOK: TButton
      Left = 318
      Top = 293
      TabOrder = 13
    end
    inherited BtnExit: TButton
      Left = 388
      Top = 293
      TabOrder = 14
    end
    object cxLabel2: TcxLabel [2]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 461
      AnchorY = 126
    end
    object EditDelivery: TcxTextEdit [3]
      Left = 81
      Top = 156
      Hint = 'T.A_Delivery'
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 5
      Width = 152
    end
    object EditCusPrice: TcxTextEdit [4]
      Left = 81
      Top = 181
      Hint = 'T.A_CPrice'
      ParentFont = False
      TabOrder = 8
      Width = 120
    end
    object cxLabel1: TcxLabel [5]
      Left = 206
      Top = 181
      AutoSize = False
      Caption = #20803
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 25
      AnchorY = 191
    end
    object EditDrvPrice: TcxTextEdit [6]
      Left = 294
      Top = 181
      Hint = 'T.A_DPrice'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 10
      Width = 208
    end
    object EditMemo: TcxMemo [7]
      Left = 81
      Top = 206
      Hint = 'T.A_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 12
      Height = 46
      Width = 403
    end
    object EditCusName: TcxButtonEdit [8]
      Left = 81
      Top = 86
      Hint = 'T.A_CusName'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCusNamePropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object cxLabel3: TcxLabel [9]
      Left = 425
      Top = 181
      Caption = #20803
      ParentFont = False
      Transparent = True
    end
    object EditRecvMan: TcxTextEdit [10]
      Left = 81
      Top = 131
      Hint = 'T.A_RecvMan'
      ParentFont = False
      TabOrder = 4
      Width = 144
    end
    object EditPhone: TcxTextEdit [11]
      Left = 296
      Top = 131
      Hint = 'T.A_RecvPhone'
      ParentFont = False
      TabOrder = 6
      Width = 145
    end
    object EditID: TcxButtonEdit [12]
      Left = 81
      Top = 36
      Hint = 'T.A_ID'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 121
    end
    object EditCusID: TcxButtonEdit [13]
      Left = 81
      Top = 61
      Hint = 'T.A_CID'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCusNamePropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditDistance: TcxTextEdit [14]
      Left = 296
      Top = 156
      Hint = 'T.A_Distance'
      TabOrder = 7
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          Caption = #22320#22336#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = EditCusID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCusName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              Caption = #25910' '#36135' '#20154':'
              Control = EditRecvMan
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              Caption = #25910#36135#22320#22336':'
              Control = EditDelivery
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              Caption = #32852#31995#30005#35805':'
              Control = EditPhone
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item15: TdxLayoutItem
              Caption = #36816'    '#36317':'
              Control = EditDistance
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item9: TdxLayoutItem
              Caption = #23458#25143#21333#20215':'
              Control = EditCusPrice
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              ShowCaption = False
              Control = cxLabel1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21496#26426#21333#20215':'
              Control = EditDrvPrice
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              Caption = 'cxLabel3'
              ShowCaption = False
              Control = cxLabel3
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
