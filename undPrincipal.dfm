object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = '`'
  ClientHeight = 660
  ClientWidth = 1062
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1062
    Height = 118
    Align = alTop
    TabOrder = 0
    object lblCep: TLabel
      Left = 16
      Top = 8
      Width = 76
      Height = 15
      Caption = 'Busca por CEP'
    end
    object lblEndereco: TLabel
      Left = 637
      Top = 8
      Width = 107
      Height = 15
      Caption = 'Busca por Endere'#231'o:'
    end
    object lblUf: TLabel
      Left = 272
      Top = 8
      Width = 38
      Height = 15
      Caption = 'Estado:'
    end
    object lblCidade: TLabel
      Left = 463
      Top = 8
      Width = 40
      Height = 15
      Caption = 'Cidade:'
    end
    object edtCep: TEdit
      Left = 16
      Top = 25
      Width = 89
      Height = 23
      TabOrder = 0
      Text = 'edtCep'
    end
    object edtCidade: TEdit
      Left = 463
      Top = 25
      Width = 170
      Height = 23
      TabOrder = 3
      Text = 'edtCidade'
    end
    object btnConsultaCep: TButton
      Left = 111
      Top = 24
      Width = 120
      Height = 25
      Caption = 'Consultar CEP'
      TabOrder = 1
      OnClick = btnConsultaCepClick
    end
    object btnBuscaEndereco: TButton
      Left = 928
      Top = 24
      Width = 120
      Height = 25
      Caption = 'Consultar Endere'#231'o'
      TabOrder = 5
      OnClick = btnBuscaEnderecoClick
    end
    object cmbUf: TComboBox
      Left = 272
      Top = 25
      Width = 185
      Height = 23
      TabOrder = 2
      Text = 'cmbUf'
      Items.Strings = (
        'AC - Acre'
        'AL - Alagoas'
        'AP - Amap'#225
        'AM - Amazonas'
        'BA - Bahia'
        'CE - Cear'#225
        'DF - Distrito Federal'
        'ES - Esp'#237'rito Santo'
        'GO - Goi'#225's'
        'MA - Maranh'#227'o'
        'MT - Mato Grosso'
        'MS - Mato Grosso do Sul'
        'MG - Minas Gerais'
        'PA - Par'#225
        'PB - Para'#237'ba'
        'PR - Paran'#225
        'PE - Pernambuco'
        'PI - Piau'#237
        'RJ - Rio de Janeiro'
        'RN - Rio Grande do Norte'
        'RS - Rio Grande do Sul'
        'RO - Rond'#244'nia'
        'RR - Roraima'
        'SC - Santa Catarina'
        'SP - S'#227'o Paulo'
        'SE - Sergipe'
        'TO - Tocantins')
    end
    object edtEndereco: TEdit
      Left = 637
      Top = 25
      Width = 285
      Height = 23
      TabOrder = 4
      Text = 'edtEndereco'
    end
    object rdgType: TRadioGroup
      Left = 16
      Top = 56
      Width = 185
      Height = 49
      Caption = ' Formato retorno: '
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Json'
        'Xml')
      TabOrder = 6
    end
    object rdgProtocol: TRadioGroup
      Left = 216
      Top = 56
      Width = 185
      Height = 49
      Caption = ' Protocolo:  '
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Https'
        'Http')
      TabOrder = 7
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 619
    Width = 1062
    Height = 41
    Align = alBottom
    TabOrder = 1
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 118
    Width = 137
    Height = 501
    Align = alLeft
    TabOrder = 2
  end
  object dbgEnderecos: TDBGrid
    Left = 137
    Top = 118
    Width = 925
    Height = 501
    Align = alClient
    DataSource = dtsEnderecos
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dtsEnderecos: TDataSource
    DataSet = dtmPrincipal.cdsEnderecos
    Left = 1016
    Top = 56
  end
end
