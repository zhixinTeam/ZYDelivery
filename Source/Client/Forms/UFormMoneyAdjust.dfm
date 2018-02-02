inherited fFormMoneyAdjust: TfFormMoneyAdjust
  Left = 404
  Top = 403
  ClientHeight = 285
  ClientWidth = 479
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 479
    Height = 285
    inherited BtnOK: TButton
      Left = 333
      Top = 252
      TabOrder = 13
    end
    inherited BtnExit: TButton
      Left = 403
      Top = 252
      TabOrder = 14
    end
    object EditID: TcxTextEdit [2]
      Left = 81
      Top = 36
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object EditName: TcxTextEdit [3]
      Left = 81
      Top = 61
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object EditBegin: TcxTextEdit [4]
      Left = 81
      Top = 99
      TabOrder = 3
      Width = 121
    end
    object EditIn: TcxTextEdit [5]
      Left = 81
      Top = 124
      TabOrder = 5
      Width = 121
    end
    object EditOut: TcxTextEdit [6]
      Left = 81
      Top = 149
      TabOrder = 7
      Width = 121
    end
    object EditFreeze: TcxTextEdit [7]
      Left = 81
      Top = 174
      TabOrder = 9
      Width = 121
    end
    object cxLabel1: TcxLabel [8]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Transparent = True
      Height = 8
      Width = 358
    end
    object EditBC: TcxTextEdit [9]
      Left = 81
      Top = 199
      TabOrder = 11
      Width = 121
    end
    object cxLabel2: TcxLabel [10]
      Left = 207
      Top = 99
      Caption = #20803' '#27880':'#31995#32479#21021#22987#21270#26102#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel3: TcxLabel [11]
      Left = 207
      Top = 124
      Caption = #20803' '#27880':'#23458#25143#23384#20837#36134#25143#30340#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel4: TcxLabel [12]
      Left = 207
      Top = 149
      Caption = #20803' '#27880':'#23458#25143#20132#26131#25104#21151#30340#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel5: TcxLabel [13]
      Left = 207
      Top = 174
      Caption = #20803' '#27880':'#24050#24320#26410#25552#36135#30340#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel7: TcxLabel [14]
      Left = 207
      Top = 199
      Caption = #20803' '#27880':'#36820#36824#32473#23458#25143#30340#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #26399#21021#37329#39069':'
            Control = EditBegin
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = 'cxLabel2'
            ShowCaption = False
            Control = cxLabel2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #20837#37329#37329#39069':'
            Control = EditIn
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel3
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #20986#37329#37329#39069':'
            Control = EditOut
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel4
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #20923#32467#37329#39069':'
            Control = EditFreeze
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item15: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel5
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item11: TdxLayoutItem
            Caption = #34917#20607#37329#39069':'
            Control = EditBC
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel7
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
