inherited fFrameTruckLogs: TfFrameTruckLogs
  Width = 897
  inherited ToolBar1: TToolBar
    Width = 897
    ButtonWidth = 91
    inherited BtnAdd: TToolButton
      Visible = False
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Left = 91
      Visible = False
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Left = 182
      Visible = False
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Left = 273
    end
    inherited BtnRefresh: TToolButton
      Left = 281
    end
    inherited S2: TToolButton
      Left = 372
    end
    inherited BtnPrint: TToolButton
      Left = 380
    end
    inherited BtnPreview: TToolButton
      Left = 471
    end
    inherited BtnExport: TToolButton
      Left = 562
    end
    inherited S3: TToolButton
      Left = 653
    end
    inherited BtnExit: TToolButton
      Left = 661
    end
    object ToolButton1: TToolButton
      Left = 752
      Top = 0
      Caption = #25171#21360#35013#36733#30331#35760#34920
      ImageIndex = 8
      OnClick = ToolButton1Click
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 897
    Height = 165
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 897
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.T_Truck'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 4
      Width = 125
    end
    object EditName: TcxButtonEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 281
      Top = 93
      Hint = 'T.T_Owner'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 445
      Top = 93
      Hint = 'T.T_PValue'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      TabOrder = 6
      Width = 125
    end
    object EditDate: TcxButtonEdit [4]
      Left = 269
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 172
    end
    object EditType: TcxComboBox [5]
      Left = 504
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'S=S'#12289#38144#21806
        'P=P'#12289#20379#24212)
      Properties.OnChange = EditflagPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 2
      Width = 120
    end
    object Editflag: TcxComboBox [6]
      Left = 687
      Top = 36
      ParentFont = False
      Properties.Items.Strings = (
        'Y=Y'#12289#24050#21457#36135
        'N=N'#12289#26410#21457#36135)
      Properties.OnChange = EditflagPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          CaptionOptions.Text = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          CaptionOptions.Text = #19994#21153#31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          CaptionOptions.Text = #21457#36135#26631#24535':'
          Control = Editflag
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          CaptionOptions.Text = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          CaptionOptions.Text = #39550#39542#21592#22995#21517':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          CaptionOptions.Text = #20928#37325':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 897
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 897
    inherited TitleBar: TcxLabel
      Caption = #36710#36742#35013#36733#30331#35760#31649#29702
      Style.IsFontAssigned = True
      Width = 897
      AnchorX = 449
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 234
  end
  inherited DataSource1: TDataSource
    Top = 234
  end
end
