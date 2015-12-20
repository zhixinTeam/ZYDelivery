inherited fFormFactZhiKaBind: TfFormFactZhiKaBind
  Left = 633
  Top = 337
  Caption = #20851#32852#24037#21378#35746#21333
  ClientHeight = 178
  ClientWidth = 326
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 326
    Height = 178
    inherited BtnOK: TButton
      Left = 180
      Top = 145
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 250
      Top = 145
      TabOrder = 4
    end
    object cxLabel1: TcxLabel [2]
      Left = 23
      Top = 61
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 20
      Width = 287
    end
    object EditOwnZhiKa: TcxButtonEdit [3]
      Left = 105
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditOwnZhiKaPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditFactZhiKa: TcxButtonEdit [4]
      Left = 105
      Top = 86
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditOwnZhiKaPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20844#21496#35746#21333#32534#21495':'
          Control = EditOwnZhiKa
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #24037#21378#35746#21333#32534#21495':'
          Control = EditFactZhiKa
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
