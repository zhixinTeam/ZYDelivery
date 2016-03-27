inherited fFormCustomerCredit: TfFormCustomerCredit
  Left = 301
  Top = 288
  ClientHeight = 259
  ClientWidth = 427
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 427
    Height = 259
    inherited BtnOK: TButton
      Left = 281
      Top = 226
      Caption = #30830#23450
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 351
      Top = 226
      TabOrder = 10
    end
    object EditSaleMan: TcxComboBox [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditSaleManPropertiesChange
      TabOrder = 0
      Width = 301
    end
    object EditCus: TcxComboBox [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      TabOrder = 1
      OnKeyPress = EditCusKeyPress
      Width = 301
    end
    object EditCredit: TcxTextEdit [4]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.ReadOnly = False
      Properties.OnChange = EditCreditPropertiesChange
      TabOrder = 3
      Text = '0'
      Width = 142
    end
    object cxLabel1: TcxLabel [5]
      Left = 228
      Top = 111
      AutoSize = False
      Caption = #27880':'#37329#39069#20026#36127#34920#31034#20943#23567#39069#24230'.'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 204
      AnchorY = 121
    end
    object EditMemo: TcxMemo [6]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 8
      Height = 50
      Width = 301
    end
    object EditEnd: TcxDateEdit [7]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 142
    end
    object cxLabel2: TcxLabel [8]
      Left = 228
      Top = 136
      AutoSize = False
      Caption = #27880':'#20026#26368#21518#19968#27425#25480#20449#26102#26377#25928'.'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 52
      AnchorY = 146
    end
    object EditBig: TcxLabel [9]
      Left = 23
      Top = 161
      AutoSize = False
      Caption = #37329#39069#22823#20889':'
      ParentFont = False
      Transparent = True
      Height = 16
      Width = 378
    end
    object EditType: TcxComboBox [10]
      Left = 81
      Top = 86
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #19994#21153#20154#21592':'
          Control = EditSaleMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              Caption = #23458#25143#21015#34920':'
              Control = EditCus
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              Caption = #36134#25143#31867#22411':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group3: TdxLayoutGroup
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item5: TdxLayoutItem
                Caption = #20449#29992#37329#39069':'
                Control = EditCredit
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item6: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                ShowCaption = False
                Control = cxLabel1
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item8: TdxLayoutItem
                Caption = #26377#25928#26085#26399':'
                Control = EditEnd
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item9: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = 'cxLabel2'
                ShowCaption = False
                Control = cxLabel2
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item10: TdxLayoutItem
              Caption = 'cxLabel3'
              ShowCaption = False
              Control = EditBig
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaHorizontal]
              AlignVert = avClient
              Caption = #22791#27880#20449#24687':'
              Control = EditMemo
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end
