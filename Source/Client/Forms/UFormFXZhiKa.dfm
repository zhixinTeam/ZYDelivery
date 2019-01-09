inherited fFormFXZhiKa: TfFormFXZhiKa
  Left = 573
  Top = 122
  ClientHeight = 499
  ClientWidth = 430
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 430
    Height = 499
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 284
      Top = 466
      Caption = #21150#21345
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 354
      Top = 466
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 373
      Height = 133
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 295
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object ListFXZhiKa: TcxListView [3]
      Left = 23
      Top = 334
      Width = 372
      Height = 113
      Columns = <
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditValue: TcxTextEdit [4]
      Left = 81
      Top = 236
      ParentFont = False
      TabOrder = 3
      OnKeyPress = EditLadingKeyPress
      Width = 120
    end
    object EditStock: TcxComboBox [5]
      Left = 81
      Top = 211
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 1
      OnKeyPress = EditLadingKeyPress
      Width = 115
    end
    object BtnAdd: TButton [6]
      Left = 368
      Top = 211
      Width = 39
      Height = 17
      Caption = #28155#21152
      TabOrder = 2
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [7]
      Left = 368
      Top = 236
      Width = 39
      Height = 18
      Caption = #21024#38500
      TabOrder = 4
      OnClick = BtnDelClick
    end
    object cxMemo1: TcxMemo [8]
      Left = 81
      Top = 261
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      Height = 68
      Width = 326
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #21345#29255#26126#32454
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #27700#27877#31867#22411':'
              Control = EditStock
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21150#29702#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #22791'    '#27880':'
          Control = cxMemo1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'New Item'
          ShowCaption = False
          Control = ListFXZhiKa
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
