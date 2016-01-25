inherited fFrameTransContract: TfFrameTransContract
  Width = 1004
  Height = 446
  inherited ToolBar1: TToolBar
    Width = 1004
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
    Width = 1004
    Height = 244
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1004
    Height = 135
    object EditID: TcxButtonEdit [0]
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
      Width = 125
    end
    object EditCustomer: TcxButtonEdit [1]
      Left = 269
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
      Width = 125
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 81
      Top = 93
      Hint = 'T.T_ID'
      ParentFont = False
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 269
      Top = 93
      Hint = 'T.T_CusName'
      ParentFont = False
      TabOrder = 6
      Width = 125
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 445
      Top = 93
      Hint = 'T.T_SaleMan'
      ParentFont = False
      TabOrder = 7
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 633
      Top = 93
      Hint = 'T.T_ProjectT_Delivery'
      ParentFont = False
      TabOrder = 8
      Width = 121
    end
    object EditDrver: TcxButtonEdit [6]
      Left = 457
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
      Width = 125
    end
    object EditDate: TcxButtonEdit [7]
      Left = 645
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 132
    end
    object EditSellte: TcxCheckComboBox [8]
      Left = 840
      Top = 36
      ParentFont = False
      Properties.EmptySelectionText = #26410#32467#31639
      Properties.Items = <
        item
          Description = #24050#32467#31639
        end
        item
          Description = #26410#32467#31639
        end>
      Properties.OnClickCheck = EditSelltePropertiesClickCheck
      TabOrder = 4
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #21327#35758#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #21496#26426#22995#21517':'
          Control = EditDrver
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #32467#31639#26631#35760':'
          Control = EditSellte
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21327#35758#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #19994#21153#21592':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #24037#31243#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 1004
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1004
    inherited TitleBar: TcxLabel
      Caption = #38144#21806#36816#36153#31649#29702
      Style.IsFontAssigned = True
      Width = 1004
      AnchorX = 502
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
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 264
    object N1: TMenuItem
      Caption = #25171#21360#21327#35758
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #26080#25928#21327#35758
      OnClick = N5Click
    end
    object N5: TMenuItem
      Tag = 20
      Caption = #26377#25928#21327#35758
      OnClick = N5Click
    end
    object N7: TMenuItem
      Tag = 30
      Caption = #26597#35810#20840#37096
      OnClick = N5Click
    end
    object N4: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object N6: TMenuItem
      Caption = #32467#31639#36816#36153
      OnClick = N6Click
    end
    object N8: TMenuItem
      Caption = #21453#32467#31639
      OnClick = N8Click
    end
  end
end
