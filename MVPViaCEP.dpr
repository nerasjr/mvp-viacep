program MVPViaCEP;

uses
  Vcl.Forms,
  undPrincipal in 'undPrincipal.pas' {frmPrincipal},
  udmPrincipal in 'DataAccess\udmPrincipal.pas' {dtmPrincipal: TDataModule},
  untViaCepInterface in 'Interfaces\untViaCepInterface.pas',
  undSelecionarCep in 'undSelecionarCep.pas' {frmSelecionarCep},
  untUtils in 'untUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdtmPrincipal, dtmPrincipal);
  Application.Run;
end.
