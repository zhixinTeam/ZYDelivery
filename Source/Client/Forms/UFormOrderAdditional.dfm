inherited fFormOrderAdditional: TfFormOrderAdditional
  Left = 434
  Top = 131
  ClientHeight = 537
  ClientWidth = 413
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 413
    Height = 537
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 267
      Top = 504
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 337
      Top = 504
      TabOrder = 3
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 369
      Height = 189
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 291
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
    end
    object EditTruck: TcxTextEdit [3]
      Left = 81
      Top = 255
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 0
      OnKeyPress = EditIDKeyPress
      Width = 296
    end
    object EditPValue: TcxTextEdit [4]
      Left = 81
      Top = 422
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditPMan: TcxTextEdit [5]
      Left = 81
      Top = 447
      ParentFont = False
      TabOrder = 8
      Width = 121
    end
    object EditMValue: TcxTextEdit [6]
      Left = 265
      Top = 422
      ParentFont = False
      TabOrder = 9
      Width = 121
    end
    object EditMMan: TcxTextEdit [7]
      Left = 265
      Top = 447
      ParentFont = False
      TabOrder = 10
      Width = 121
    end
    object EditMemo: TcxMemo [8]
      Left = 265
      Top = 361
      ParentFont = False
      TabOrder = 11
      Height = 24
      Width = 121
    end
    object EditPDate: TcxDateEdit [9]
      Left = 81
      Top = 472
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 12
      Width = 121
    end
    object EditMDate: TcxDateEdit [10]
      Left = 265
      Top = 472
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 13
      Width = 121
    end
    object EditID: TcxButtonEdit [11]
      Left = 81
      Top = 230
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 14
      OnKeyPress = EditIDKeyPress
      Width = 121
    end
    object EditYSMan: TcxTextEdit [12]
      Left = 81
      Top = 336
      TabOrder = 15
      Width = 121
    end
    object EditKZValue: TcxTextEdit [13]
      Left = 265
      Top = 336
      TabOrder = 16
      Text = '0.00'
      Width = 121
    end
    object EditYSDate: TcxDateEdit [14]
      Left = 81
      Top = 361
      Properties.Kind = ckDateTime
      TabOrder = 17
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30003#35831#21333#21495':'
          Control = EditID
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
      object dxLayout1Group2: TdxLayoutGroup [1]
        Caption = #39564#25910#26126#32454
        LayoutDirection = ldHorizontal
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #39564' '#25910' '#20154':'
            Control = EditYSMan
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            Caption = #39564#25910#26102#38388':'
            Control = EditYSDate
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #25187#38500#26434#36136':'
            Control = EditKZValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayout1Group3: TdxLayoutGroup [2]
        Caption = #36807#30917#26126#32454
        LayoutDirection = ldHorizontal
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            Caption = #30382'    '#37325':'
            Control = EditPValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            Caption = #30382#21496#30917#21592':'
            Control = EditPMan
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item18: TdxLayoutItem
            Caption = #36807#30382#26102#38388':'
            Control = EditPDate
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group9: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item15: TdxLayoutItem
            Caption = #27611'    '#37325':'
            Control = EditMValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item16: TdxLayoutItem
            Caption = #27611#21496#30917#21592':'
            Control = EditMMan
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item19: TdxLayoutItem
            Caption = #36807#27611#26102#38388':'
            Control = EditMDate
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
