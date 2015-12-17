inherited fFormTruckTrans: TfFormTruckTrans
  Left = 586
  Top = 241
  ClientHeight = 253
  ClientWidth = 413
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 413
    Height = 253
    inherited BtnOK: TButton
      Left = 267
      Top = 220
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 337
      Top = 220
      TabOrder = 6
    end
    object EditDriver: TcxTextEdit [2]
      Left = 81
      Top = 61
      Hint = 'T.T_Driver'
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object EditDrvPhone: TcxTextEdit [3]
      Left = 265
      Top = 61
      Hint = 'T.T_DrPhone'
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object EditZGSerial: TcxTextEdit [4]
      Left = 81
      Top = 86
      Hint = 'T.T_ZGSerial'
      ParentFont = False
      TabOrder = 3
      Width = 121
    end
    object EditMemo: TcxMemo [5]
      Left = 81
      Top = 111
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 4
      Height = 89
      Width = 304
    end
    object EditTruck: TcxButtonEdit [6]
      Left = 81
      Top = 36
      Hint = 'T.T_Truck'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item11: TdxLayoutItem
            Caption = #36816#36755#21496#26426':'
            Control = EditDriver
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #21496#26426#30005#35805':'
            Control = EditDrvPhone
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item17: TdxLayoutItem
          Caption = #20174#19994#35777#21495':'
          Control = EditZGSerial
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item18: TdxLayoutItem
          Caption = #22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
