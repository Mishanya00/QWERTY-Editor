object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 479
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object lblDefaultWidth: TLabel
    Left = 32
    Top = 24
    Width = 137
    Height = 28
    BiDiMode = bdRightToLeft
    Caption = #1064#1080#1088#1080#1085#1072' '#1073#1083#1086#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object lblDefaultHeight: TLabel
    Left = 32
    Top = 72
    Width = 124
    Height = 28
    BiDiMode = bdRightToLeft
    Caption = #1042#1099#1089#1086#1090#1072' '#1073#1083#1086#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object lblCanvasWidth: TLabel
    Left = 32
    Top = 120
    Width = 141
    Height = 28
    BiDiMode = bdRightToLeft
    Caption = #1064#1080#1088#1080#1085#1072' '#1093#1086#1083#1089#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object lblCanvasHeight: TLabel
    Left = 32
    Top = 165
    Width = 128
    Height = 28
    BiDiMode = bdRightToLeft
    Caption = #1042#1099#1089#1086#1090#1072' '#1093#1086#1083#1089#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object editBlockWidth: TEdit
    Left = 216
    Top = 24
    Width = 137
    Height = 28
    TabOrder = 0
    Text = 'editBlockWidth'
  end
  object editBlockHeight: TEdit
    Left = 216
    Top = 72
    Width = 137
    Height = 28
    TabOrder = 1
    Text = 'Edit1'
  end
  object editCanvasWidth: TEdit
    Left = 216
    Top = 120
    Width = 137
    Height = 28
    TabOrder = 2
    Text = 'Edit1'
  end
  object editCanvasHeight: TEdit
    Left = 216
    Top = 162
    Width = 137
    Height = 31
    TabOrder = 3
    Text = 'Edit1'
  end
  object btnAcceptSettings: TButton
    Left = 528
    Top = 408
    Width = 121
    Height = 47
    Caption = #1055#1088#1080#1085#1103#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Roboto'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnAcceptSettingsClick
  end
  object btnCancelSettings: TButton
    Left = 64
    Top = 408
    Width = 121
    Height = 47
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Roboto'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnCancelSettingsClick
  end
end
