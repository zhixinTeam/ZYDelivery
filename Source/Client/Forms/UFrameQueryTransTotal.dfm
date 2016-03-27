inherited fFrameQueryTransTotal: TfFrameQueryTransTotal
  Width = 854
  Height = 317
  object TitlePanel1: TZnBitmapPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 22
    Align = alTop
    object TitleBar: TcxLabel
      Left = 0
      Top = 0
      Align = alClient
      AutoSize = False
      Caption = #36816#36153#27719#24635#25253#34920#26597#35810
      ParentFont = False
      Style.BorderStyle = ebsNone
      Style.Edges = [bBottom]
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.TextColor = clGray
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Properties.LabelEffect = cxleExtrude
      Properties.LabelStyle = cxlsLowered
      Properties.ShadowedColor = clBlack
      Transparent = True
      Height = 22
      Width = 854
      AnchorX = 427
      AnchorY = 11
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 22
    Width = 854
    Height = 37
    ButtonHeight = 35
    ButtonWidth = 79
    EdgeBorders = []
    Flat = True
    Images = FDM.ImageBar
    ShowCaptions = True
    TabOrder = 1
    object S1: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'S1'
      ImageIndex = 2
      Style = tbsSeparator
      Visible = False
    end
    object BtnRefresh: TToolButton
      Left = 8
      Top = 0
      Caption = '    '#26597#35810'    '
      ImageIndex = 14
      OnClick = BtnRefreshClick
    end
    object S2: TToolButton
      Left = 87
      Top = 0
      Width = 8
      Caption = 'S2'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object BtnPrint: TToolButton
      Left = 95
      Top = 0
      Caption = #25171#21360
      ImageIndex = 3
      Visible = False
    end
    object BtnPreview: TToolButton
      Left = 174
      Top = 0
      Caption = #25171#21360#39044#35272
      ImageIndex = 4
      Visible = False
    end
    object BtnExport: TToolButton
      Left = 253
      Top = 0
      Caption = #23548#20986
      ImageIndex = 5
      OnClick = BtnExportClick
    end
    object S3: TToolButton
      Left = 332
      Top = 0
      Width = 8
      Caption = 'S3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object BtnExit: TToolButton
      Left = 340
      Top = 0
      Caption = '   '#20851#38381'   '
      ImageIndex = 7
      OnClick = BtnExitClick
    end
  end
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 59
    Width = 854
    Height = 138
    Align = alTop
    BevelEdges = [beLeft, beRight, beBottom]
    TabOrder = 2
    TabStop = False
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    LookAndFeel = FDM.dxLayoutWeb1
    object cxtxtdt1: TcxTextEdit
      Left = 259
      Top = 93
      Hint = 'T.O_ProName'
      ParentFont = False
      TabOrder = 3
      Width = 105
    end
    object EditDate: TcxButtonEdit
      Left = 259
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 1
      Width = 206
    end
    object EditCustomer: TcxButtonEdit
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCustomerPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object cxtxtdt4: TcxTextEdit
      Left = 81
      Top = 93
      Hint = 'T.O_StockName'
      ParentFont = False
      TabOrder = 2
      Width = 115
    end
    object dxGroup1: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object GroupSearch1: TdxLayoutGroup
        Caption = #24555#36895#26597#35810
        LayoutDirection = ldHorizontal
        object dxLayout1Item8: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      object GroupDetail1: TdxLayoutGroup
        Caption = #31616#26126#20449#24687
        LayoutDirection = ldHorizontal
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21697#31181#21517#31216':'
          Control = cxtxtdt4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #20379' '#24212' '#21830':'
          Control = cxtxtdt1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 197
    Width = 854
    Height = 8
    HotZoneClassName = 'TcxXPTaskBarStyle'
    AlignSplitter = salTop
    Control = dxLayout1
  end
  object ZnBitmapPanel1: TZnBitmapPanel
    Left = 0
    Top = 205
    Width = 854
    Height = 112
    Align = alClient
    object ReportGrid: TStringGrid
      Left = 0
      Top = 0
      Width = 854
      Height = 112
      Align = alClient
      ColCount = 8
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnDrawCell = ReportGridDrawCell
      OnKeyDown = ReportGridKeyDown
    end
  end
end
