inherited fFormGetFactZhiKa: TfFormGetFactZhiKa
  Left = 351
  Top = 280
  ClientHeight = 440
  ClientWidth = 423
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 423
    Height = 440
    inherited BtnOK: TButton
      Left = 277
      Top = 407
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 347
      Top = 407
      TabOrder = 6
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 338
      Height = 116
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 249
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditName: TcxComboBox [3]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditNamePropertiesEditValueChanged
      TabOrder = 2
      Width = 185
    end
    object ListDetail: TcxListView [4]
      Left = 23
      Top = 264
      Width = 355
      Height = 154
      Checkboxes = True
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 120
        end
        item
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 100
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
    end
    object EditZK: TcxComboBox [5]
      Left = 81
      Top = 239
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 20
      Properties.OnEditValueChanged = EditZKPropertiesEditValueChanged
      TabOrder = 3
      Width = 368
    end
    object EditID: TcxComboBox [6]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.OnEditValueChanged = EditIDPropertiesEditValueChanged
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = '1.'#36873#25321#23458#25143
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avBottom
          Caption = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = '2.'#36873#25321#32440#21345
        object dxLayout1Item4: TdxLayoutItem
          Caption = #32440#21345#21015#34920':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
