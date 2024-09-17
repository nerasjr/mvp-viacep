unit undSelecionarCEP;

interface

uses
  Vcl.Forms, Vcl.Grids, Vcl.Controls, Vcl.StdCtrls, System.Classes, untViaCepInterface,
  Vcl.ExtCtrls;

type
  TfrmSelecionarCEP = class(TForm)
    StringGrid1: TStringGrid;
    pnlBottom: TPanel;
    btnConfirmar: TButton;
    procedure BtnConfirmarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FResultados: TArray<TViaCepResult>;
    FSelectedResult: TViaCepResult;
  public
    function SelecionarCEP(const Resultados: TArray<TViaCepResult>): TViaCepResult;
  end;

var
  frmSelecionarCEP: TfrmSelecionarCEP;

implementation

{$R *.dfm}

procedure TfrmSelecionarCEP.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  frmSelecionarCEP := nil;
end;

function TfrmSelecionarCEP.SelecionarCEP(const Resultados: TArray<TViaCepResult>): TViaCepResult;
var
  I: Integer;
begin
  FResultados := Resultados;
  StringGrid1.RowCount := Length(Resultados) + 1;
  StringGrid1.Cells[0, 0] := 'CEP';
  StringGrid1.Cells[1, 0] := 'Logradouro';
  for I := 0 to Length(Resultados) - 1 do
  begin
    StringGrid1.Cells[0, I + 1] := Resultados[I].CEP;
    StringGrid1.Cells[1, I + 1] := Resultados[I].Logradouro;
  end;
  ShowModal;
  Result := FSelectedResult;
end;

procedure TfrmSelecionarCEP.BtnConfirmarClick(Sender: TObject);
var
  SelectedRow: Integer;
begin
  SelectedRow := StringGrid1.Row - 1;
  if (SelectedRow >= 0) and (SelectedRow < Length(FResultados)) then
  begin
    FSelectedResult := FResultados[SelectedRow];
    Close;
  end;
end;

end.

