inherited fFrameFXZhiKa: TfFrameFXZhiKa
  Width = 1028
  Height = 493
  inherited ToolBar1: TToolBar
    Width = 1028
    inherited BtnAdd: TToolButton
      Caption = #21150#21345
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Caption = #20572#29992
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 1028
    Height = 288
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PopupMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1028
    Height = 138
    object EditCard: TcxButtonEdit [0]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object cxTextEdit1: TcxTextEdit [1]
      Left = 69
      Top = 93
      Hint = 'T.I_Card'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 232
      Top = 93
      Hint = 'T.I_ID'
      ParentFont = False
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 608
      Top = 93
      Hint = 'T.I_YuE'
      ParentFont = False
      TabOrder = 7
      Width = 100
    end
    object Edit1: TcxTextEdit [4]
      Left = 420
      Top = 93
      Hint = 'T.I_StockName'
      ParentFont = False
      TabOrder = 6
      Width = 125
    end
    object EditID: TcxButtonEdit [5]
      Left = 257
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditSaleMan: TcxButtonEdit [6]
      Left = 429
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditCustomer: TcxButtonEdit [7]
      Left = 613
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 3
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = 'IC'#21345#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #35746#21333#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #19994#21153#21592':'
          Control = EditSaleMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'IC'#21345#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #35746#21333#32534#21495':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = Edit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #21487#29992#20313#39069':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 1028
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1028
    inherited TitleBar: TcxLabel
      Caption = #20998#38144#35746#21333#26597#35810
      Style.IsFontAssigned = True
      Width = 1028
      AnchorX = 514
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 240
    object N3: TMenuItem
      Caption = '**'#39069#24230#31649#29702'**'
      Enabled = False
    end
    object N1: TMenuItem
      Caption = #36861#21152#38480#39069
      OnClick = N1Click
    end
    object N11: TMenuItem
      Caption = #38477#20302#38480#39069
      OnClick = N11Click
    end
    object N2: TMenuItem
      Caption = '**'#30913#21345#31649#29702'**'
      Enabled = False
    end
    object N4: TMenuItem
      Caption = #27880#38144#30913#21345
      OnClick = N4Click
    end
    object N6: TMenuItem
      Caption = #21150#29702#30913#21345
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #20572#29992#35746#21333
    end
    object N5: TMenuItem
      Caption = '**'#35746#21333#26597#35810'**'
      Enabled = False
    end
    object N8: TMenuItem
      Caption = #26080#25928#35746#21333
      OnClick = N8Click
    end
    object N9: TMenuItem
      Tag = 1
      Caption = #26377#25928#35746#21333
      OnClick = N8Click
    end
    object N10: TMenuItem
      Tag = 2
      Caption = #26597#35810#20840#37096
      OnClick = N8Click
    end
  end
end
