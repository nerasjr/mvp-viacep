object frmSelecionarCep: TfrmSelecionarCep
  Left = 0
  Top = 0
  Caption = 'frmSelecionarCep'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 624
    Height = 400
    Align = alClient
    ColCount = 2
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 585
    ExplicitHeight = 321
    ColWidths = (
      64
      461)
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = 224
    ExplicitTop = 360
    ExplicitWidth = 185
    object btnConfirmar: TButton
      Left = 534
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Selecionar'
      TabOrder = 0
      OnClick = btnConfirmarClick
    end
  end
end
