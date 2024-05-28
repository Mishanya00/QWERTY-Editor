object frmDelphiListing: TfrmDelphiListing
  Left = 0
  Top = 0
  Caption = 'QWEditor - Code Listing'
  ClientHeight = 569
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object memoListing: TMemo
    Left = 0
    Top = 0
    Width = 848
    Height = 569
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitWidth = 842
    ExplicitHeight = 560
  end
  object panelListingActions: TPanel
    Left = 848
    Top = 0
    Width = 105
    Height = 569
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 842
    ExplicitHeight = 560
    object btnGenerateFlowchart: TButton
      Left = 13
      Top = 250
      Width = 84
      Height = 47
      Cursor = crHandPoint
      Hint = #1057#1086#1079#1076#1072#1085#1080#1077' '#1073#1083#1086#1082#1089#1093#1077#1084#1099' '#1080#1079' '#1082#1086#1076#1072
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Caption = #1057#1086#1079#1076#1072#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      StyleName = 'Windows'
      OnClick = btnGenerateFlowchartClick
    end
  end
end
