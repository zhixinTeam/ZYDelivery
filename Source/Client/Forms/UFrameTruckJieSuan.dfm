inherited fFrameTruckJieSuan: TfFrameTruckJieSuan
  Width = 1004
  Height = 446
  inherited ToolBar1: TToolBar
    Width = 1004
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 1004
    Height = 244
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PopupMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1004
    Height = 135
    object cxTextEdit2: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.T_CusName'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    object cxTextEdit4: TcxTextEdit [1]
      Left = 269
      Top = 93
      Hint = 'T.T_Delivery'
      ParentFont = False
      TabOrder = 4
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 433
      Top = 93
      Hint = 'T.T_DMoney'
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditDrver: TcxButtonEdit [3]
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
    object EditDate: TcxButtonEdit [4]
      Left = 453
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 2
      Width = 244
    end
    object EditTruck: TcxButtonEdit [5]
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
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #21496#26426#22995#21517':'
          Control = EditDrver
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #21333#20301#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #21368#36135#22320#28857':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #37329#39069':'
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
      Caption = #21496#26426#36816#36153#32467#31639#31649#29702
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
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 240
    object N1: TMenuItem
      Caption = #25171#21360#36816#36153#32467#31639#21333
      OnClick = N1Click
    end
  end
end
