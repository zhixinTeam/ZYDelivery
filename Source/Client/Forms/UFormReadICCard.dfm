inherited fFormReadICCard: TfFormReadICCard
  Left = 436
  Top = 177
  Caption = #35835#21462'IC'#21345
  ClientHeight = 217
  ClientWidth = 434
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 434
    Height = 217
    inherited BtnOK: TButton
      Left = 288
      Top = 184
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 358
      Top = 184
      TabOrder = 7
    end
    object EditCard: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 0
      OnKeyPress = EditCardKeyPress
      Width = 204
    end
    object BtnRead: TButton [3]
      Left = 290
      Top = 36
      Width = 95
      Height = 21
      Caption = #35835#21462
      TabOrder = 1
      OnClick = BtnReadClick
    end
    object EditCardType: TcxComboBox [4]
      Left = 81
      Top = 107
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 2
      Width = 121
    end
    object EditCardNO: TcxTextEdit [5]
      Left = 265
      Top = 107
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditBillType: TcxComboBox [6]
      Left = 81
      Top = 132
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditBillNO: TcxComboBox [7]
      Left = 265
      Top = 132
      ParentFont = False
      Properties.OnChange = EditBillNOPropertiesChange
      TabOrder = 5
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35835#21462'IC'#21345
        LayoutDirection = ldHorizontal
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'IC'#21345#21495#65306
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnRead
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = 'IC'#21345#20449#24687
        LayoutDirection = ldHorizontal
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #21345#29255#31867#22411':'
            Control = EditCardType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            Caption = #35746#21333#31867#22411':'
            Control = EditBillType
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #21345#24207#21015#21495':'
            Control = EditCardNO
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = #35746#21333#32534#21495':'
            Control = EditBillNO
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
