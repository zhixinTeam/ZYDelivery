inherited fFrameQuerySealDetail: TfFrameQuerySealDetail
  Width = 1178
  Height = 493
  inherited ToolBar1: TToolBar
    Width = 1178
    inherited BtnAdd: TToolButton
      Caption = #25171#21360#22238#21333
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 205
    Width = 1178
    Height = 288
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1178
    Height = 138
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.L_ID'
      ParentFont = False
      TabOrder = 2
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 244
      Top = 93
      Hint = 'T.L_CusName'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 456
      Top = 93
      Hint = 'T.L_Value'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object EditDate: TcxButtonEdit [3]
      Left = 265
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 1
      Width = 176
    end
    object EditSeal: TcxButtonEdit [4]
      Left = 81
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
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item11: TdxLayoutItem
          Caption = #27700#27877#25209#27425':'
          Control = EditSeal
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25552#36135#21333#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #25910#36135#21333#20301':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #21457#36135#20928#37325'('#21544'):'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 1178
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1178
    inherited TitleBar: TcxLabel
      Caption = #27700#27877#21378#27700#27877#21457#36135#22238#21333#26597#35810
      Style.IsFontAssigned = True
      Width = 1178
      AnchorX = 589
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
end
