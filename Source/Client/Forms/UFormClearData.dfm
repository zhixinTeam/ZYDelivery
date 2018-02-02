inherited fFormClearData: TfFormClearData
  Left = 542
  Top = 402
  Caption = #25968#25454#28165#29702
  ClientHeight = 403
  ClientWidth = 404
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 404
    Height = 403
    inherited BtnOK: TButton
      Left = 258
      Top = 370
      Caption = #28165#29702
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 328
      Top = 370
      TabOrder = 2
    end
    object MemoLog: TcxMemo [2]
      Left = 23
      Top = 36
      Align = alClient
      Lines.Strings = (
        #28857#20987'"'#28165#29702'"'#25353#38062'.')
      ParentFont = False
      Style.Edges = []
      TabOrder = 0
      Height = 89
      Width = 185
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMemo1'
          ShowCaption = False
          Control = MemoLog
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
