inherited fFrameZhiKa: TfFrameZhiKa
  Width = 831
  Height = 436
  inherited ToolBar1: TToolBar
    Width = 831
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 831
    Height = 234
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 831
    Height = 135
    object EditID: TcxButtonEdit [0]
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
      Width = 105
    end
    object EditCID: TcxButtonEdit [1]
      Left = 237
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
      Width = 105
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 249
      Top = 93
      Hint = 'T.Z_CID'
      ParentFont = False
      TabOrder = 5
      Width = 105
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 417
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 6
      Width = 105
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 585
      Top = 93
      Hint = 'T.Z_Project'
      ParentFont = False
      TabOrder = 7
      Width = 185
    end
    object cxTextEdit5: TcxTextEdit [5]
      Left = 81
      Top = 93
      Hint = 'T.Z_ID'
      ParentFont = False
      TabOrder = 4
      Width = 105
    end
    object EditDate: TcxButtonEdit [6]
      Left = 573
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 185
    end
    object EditSale: TcxButtonEdit [7]
      Left = 405
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
      Width = 105
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = 'IC'#21345#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #19994' '#21153' '#21592':'
          Control = EditSale
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21512#21516#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #24037#31243#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 831
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 831
    inherited TitleBar: TcxLabel
      Caption = #35746#21333#35760#24405#26597#35810
      Style.IsFontAssigned = True
      Width = 831
      AnchorX = 416
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 264
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 264
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 292
    object N1: TMenuItem
      Caption = #25171#21360#35746#21333
      OnClick = N1Click
    end
    object N12: TMenuItem
      Caption = #21150#29702#30913#21345
      OnClick = N12Click
    end
    object N11: TMenuItem
      Caption = #27880#38144#30913#21345
      OnClick = N11Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #26597#35810#36873#39033
      object N5: TMenuItem
        Tag = 10
        Caption = #20923#32467#35746#21333
        OnClick = N4Click
      end
      object N9: TMenuItem
        Tag = 20
        Caption = #26080#25928#35746#21333
        OnClick = N4Click
      end
      object N4: TMenuItem
        Tag = 30
        Caption = #26597#35810#20840#37096
        OnClick = N4Click
      end
    end
    object N6: TMenuItem
      Caption = #20854#23427#25805#20316
      object N7: TMenuItem
        Tag = 10
        Caption = #20923#32467#35746#21333
        OnClick = N8Click
      end
      object N8: TMenuItem
        Tag = 20
        Caption = #35299#38500#20923#32467
        OnClick = N8Click
      end
      object N10: TMenuItem
        Caption = #38480#21046#25552#36135
        OnClick = N10Click
      end
    end
  end
end
