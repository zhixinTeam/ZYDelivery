inherited fFormBill: TfFormBill
  Left = 630
  Top = 259
  ClientHeight = 452
  ClientWidth = 419
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 419
    Height = 452
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 273
      Top = 419
      Caption = #24320#21333
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 343
      Top = 419
      TabOrder = 9
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 351
      Height = 116
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 273
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 8
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 292
      Width = 372
      Height = 113
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end
        item
          Caption = #25552#36135#36710#36742
          Width = 70
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditValue: TcxTextEdit [4]
      Left = 81
      Top = 267
      ParentFont = False
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditTruck: TcxTextEdit [5]
      Left = 264
      Top = 182
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 116
    end
    object EditStock: TcxComboBox [6]
      Left = 81
      Top = 242
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 115
    end
    object BtnAdd: TButton [7]
      Left = 357
      Top = 242
      Width = 39
      Height = 17
      Caption = #28155#21152
      TabOrder = 4
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [8]
      Left = 357
      Top = 267
      Width = 39
      Height = 18
      Caption = #21024#38500
      TabOrder = 7
      OnClick = BtnDelClick
    end
    object EditLading: TcxComboBox [9]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'T=T'#12289#33258#25552
        'S=S'#12289#36865#36135)
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditType: TcxComboBox [10]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      TabOrder = 13
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditFQ: TcxButtonEdit [11]
      Left = 264
      Top = 157
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditFQPropertiesButtonClick
      TabOrder = 14
      Width = 129
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #25552#36135#36890#36947':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #23553#31614#32534#21495':'
            Control = EditFQ
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #25552#36135#26041#24335':'
            Control = EditLading
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#21333#26126#32454
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #27700#27877#31867#22411':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'New Item'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
