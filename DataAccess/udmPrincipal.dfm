object dtmPrincipal: TdtmPrincipal
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=D:\Projetos\softplan\mvp-viacep\db\mvpviacep')
    Left = 40
    Top = 16
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    VendorLib = 'D:\Projetos\softplan\mvp-viacep\db\win32\sqlite3.dll'
    Left = 288
    Top = 24
  end
  object qryEnderecos: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'SELECT id,'
      '             cep,'
      '             logradouro,'
      '             complemento,'
      '             bairro,'
      '             localidade,'
      '             uf'
      '  FROM enderecos')
    Left = 56
    Top = 192
  end
  object dspEnderecos: TDataSetProvider
    DataSet = qryEnderecos
    Left = 152
    Top = 192
  end
  object cdsEnderecos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspEnderecos'
    Left = 248
    Top = 192
    object cdsEnderecosid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object cdsEnderecoscep: TWideStringField
      FieldName = 'cep'
      Size = 9
    end
    object cdsEnderecoslogradouro: TWideStringField
      DisplayWidth = 50
      FieldName = 'logradouro'
      Size = 255
    end
    object cdsEnderecoscomplemento: TWideStringField
      DisplayWidth = 20
      FieldName = 'complemento'
      Size = 255
    end
    object cdsEnderecosbairro: TWideStringField
      DisplayWidth = 30
      FieldName = 'bairro'
      Size = 255
    end
    object cdsEnderecoslocalidade: TWideStringField
      DisplayWidth = 30
      FieldName = 'localidade'
      Size = 255
    end
    object cdsEnderecosuf: TWideStringField
      FieldName = 'uf'
      Size = 2
    end
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 144
    Top = 16
  end
  object qryExecute: TFDQuery
    Connection = FDConnection
    Left = 56
    Top = 128
  end
end
