unit udmPrincipal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient, Datasnap.Provider;

type
  TdtmPrincipal = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    qryEnderecos: TFDQuery;
    dspEnderecos: TDataSetProvider;
    cdsEnderecos: TClientDataSet;
    FDTransaction: TFDTransaction;
    qryExecute: TFDQuery;
    cdsEnderecosid: TAutoIncField;
    cdsEnderecoscep: TWideStringField;
    cdsEnderecoslogradouro: TWideStringField;
    cdsEnderecoscomplemento: TWideStringField;
    cdsEnderecosbairro: TWideStringField;
    cdsEnderecoslocalidade: TWideStringField;
    cdsEnderecosuf: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmPrincipal.DataModuleCreate(Sender: TObject);
begin
  FDTransaction.Connection := FDConnection;
  FDConnection.Connected := True;
  cdsEnderecos.Open;
end;

end.
