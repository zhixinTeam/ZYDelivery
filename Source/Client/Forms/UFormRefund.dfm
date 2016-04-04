inherited fFormRefund: TfFormRefund
  Left = 253
  Top = 218
  ClientHeight = 327
  ClientWidth = 458
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 458
    Height = 327
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 312
      Top = 294
      Caption = #24320#21333
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 382
      Top = 294
      TabOrder = 9
    end
    object EditValue: TcxTextEdit [2]
      Left = 81
      Top = 258
      ParentFont = False
      TabOrder = 6
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditCusName: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditSaleMan: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditDate: TcxTextEdit [5]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditSName: TcxTextEdit [6]
      Left = 81
      Top = 161
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 152
    end
    object EditMax: TcxTextEdit [7]
      Left = 296
      Top = 186
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      OnKeyPress = EditLadingKeyPress
      Width = 121
    end
    object EditTruck: TcxButtonEdit [8]
      Left = 81
      Top = 186
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 5
      OnKeyPress = EditLadingKeyPress
      Width = 152
    end
    object EditMan: TcxTextEdit [9]
      Left = 81
      Top = 111
      ParentFont = False
      TabOrder = 12
      Width = 121
    end
    object EditBill: TcxTextEdit [10]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25552#36135#21333#21495':'
          Control = EditBill
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item4: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCusName
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item5: TdxLayoutItem
          Caption = #38144#21806#32463#29702':'
          Control = EditSaleMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #24320' '#21333' '#20154':'
          Control = EditMan
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item6: TdxLayoutItem
          Caption = #20986#21378#26102#38388':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #27700#27877#21517#31216':'
          Control = EditSName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxlytmLayout1Item12: TdxLayoutItem
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552' '#36135' '#37327':'
            Control = EditMax
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#21333#20449#24687
        object dxLayout1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21150#29702#21544#25968':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
