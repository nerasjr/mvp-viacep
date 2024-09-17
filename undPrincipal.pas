unit undPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untViaCepInterface, Vcl.ExtCtrls,
  Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, udmPrincipal;

type
  TConsultaCEPService = class
  private
    FCEPClient: IViaCEPClient;
  public
    constructor Create(ACEPClient: IViaCEPClient);
    function ConsultarCEP(const ACEP: string; const AType, AProtocol: Integer): TViaCepResult;
    function ConsultarEndereco(const AUf, ACidade, AEndereco: string; const AType, AProtocol: Integer): TViaCepResult;
    function CepExists(const ACep: String; const AQuery: TFDQuery): Boolean;
  end;

type
  TfrmPrincipal = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlLeft: TPanel;
    edtCep: TEdit;
    lblCep: TLabel;
    lblEndereco: TLabel;
    edtCidade: TEdit;
    btnConsultaCep: TButton;
    btnBuscaEndereco: TButton;
    cmbUf: TComboBox;
    edtEndereco: TEdit;
    lblUf: TLabel;
    lblCidade: TLabel;
    rdgType: TRadioGroup;
    dtsEnderecos: TDataSource;
    rdgProtocol: TRadioGroup;
    dbgEnderecos: TDBGrid;
    procedure btnConsultaCepClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBuscaEnderecoClick(Sender: TObject);
    procedure ClearEdits;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FConsultaCEPService: TConsultaCEPService;
    FCepData: TViaCepResult;
    function ValidaCep(var ACep: String): Boolean;
    procedure doConsultaCep;
    procedure InsereOuAtualizaCep(const ACepData: TViaCepResult; const AQuery: TFDQuery; const ACepExiste: Boolean = False);
    procedure doConsultaEndereco;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses untUtils;

{ TConsultaCEPService }

function TConsultaCEPService.ConsultarEndereco(const AUf, ACidade, AEndereco: string; const AType, AProtocol: Integer): TViaCepResult;
begin
  FCEPClient.TypeJsonXml := TEnumJsonXml(AType);
  FCEPClient.Protocol := TEnumProtocol(AProtocol);
  Result := FCEPClient.ConsultarPorEndereco(AUf, ACidade, AEndereco);
end;

constructor TConsultaCEPService.Create(ACEPClient: IViaCEPClient);
begin
  FCEPClient := ACEPClient;
end;

function TConsultaCEPService.CepExists(const ACep: String; const AQuery: TFDQuery): Boolean;
begin
  AQuery.SQL.Text := 'SELECT 1 FROM enderecos WHERE cep = :pcep';
  AQuery.Params.ParamByName('pcep').AsString := ACep;
  AQuery.Open;
  Result := not AQuery.IsEmpty;
end;

function TConsultaCEPService.ConsultarCEP(const ACEP: string; const AType, AProtocol: Integer): TViaCepResult;
begin
  FCEPClient.TypeJsonXml := TEnumJsonXml(AType);
  FCEPClient.Protocol := TEnumProtocol(AProtocol);
  Result := FCEPClient.ConsultarPorCep(ACEP);
end;

{ TfrmPrincipal }

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  frmPrincipal := nil;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FConsultaCEPService := TConsultaCEPService.Create(TViaCEPClient.Create);
  ClearEdits;
end;

procedure TfrmPrincipal.InsereOuAtualizaCep(const ACepData: TViaCepResult;
  const AQuery: TFDQuery; const ACepExiste: Boolean);
var
  sQryCmd: String;
begin
  if ACepExiste then
  begin
    sQryCmd := 'UPDATE enderecos SET ' +
               '  logradouro = :plogradouro ' +
               ', complemento = :pcomplemento ' +
               ', bairro = :pbairro ' +
               ', localidade = :plocalidade ' +
               ', uf = :puf ' +
               'WHERE cep = :pcep';
  end
  else
    sQryCmd := 'INSERT INTO enderecos (cep, logradouro, complemento, bairro, localidade, uf) ' +
               ' values (:pcep, :plogradouro, :pcomplemento, :pbairro, :plocalidade, :puf)';
  AQuery.SQL.Text := sQryCmd;
  AQuery.Params.ParamByName('pcep').AsString := ACepData.CEP;
  AQuery.Params.ParamByName('plogradouro').AsString := ACepData.Logradouro;
  AQuery.Params.ParamByName('pcomplemento').AsString := ACepData.Complemento;
  AQuery.Params.ParamByName('pbairro').AsString := ACepData.Bairro;
  AQuery.Params.ParamByName('plocalidade').AsString := ACepData.Localidade;
  AQuery.Params.ParamByName('puf').AsString := ACepData.UF;
  dtmPrincipal.FDTransaction.StartTransaction;
  dtmPrincipal.cdsEnderecos.DisableControls;
  try
    AQuery.ExecSQL;
    dtmPrincipal.FDTransaction.Commit;
    dtmPrincipal.cdsEnderecos.Refresh;
  except
    dtmPrincipal.FDTransaction.Rollback;
  end;
  dtmPrincipal.cdsEnderecos.EnableControls;
end;

function TfrmPrincipal.ValidaCep(var ACep: String): Boolean;
const
  INVALID_CHARACTER = -1;
begin
  Result := True;
  ACep := ExtractNumbers(ACep);
  if ACep.Trim.Length <> 8 then
    Exit(False);
  if StrToIntDef(ACep, INVALID_CHARACTER) = INVALID_CHARACTER then
    Exit(False);
  ACep := Copy(ACep, 1, 5) + '-' + Copy(ACep, 6, 3);
end;

procedure TfrmPrincipal.btnBuscaEnderecoClick(Sender: TObject);
begin
  doConsultaEndereco;
end;

procedure TfrmPrincipal.btnConsultaCepClick(Sender: TObject);
begin
  doConsultaCep;
end;

procedure TfrmPrincipal.ClearEdits;
var
  i: Integer;
begin
  for i := 0 to Pred(frmPrincipal.ComponentCount) do
  begin
    if (frmPrincipal.Components[i] is TEdit) then
      TEdit(frmPrincipal.Components[i]).Clear;
  end;
  cmbuf.Text := EmptyStr;
end;

procedure TfrmPrincipal.doConsultaCep;
var
  sCep: String;
  bCepExiste,
  bConsultaCep: Boolean;
begin
  sCep := edtCep.Text;
  bCepExiste := False;
  bConsultaCep := True;
  FCepData := Default(TViaCepResult);
  if ValidaCep(sCep) then
  begin
    if (FConsultaCEPService.CepExists(sCep, dtmPrincipal.qryExecute) and (Confirma('Cep já existe, deseja atualizar?'))) then
    begin
      bCepExiste := True;
      bConsultaCep := False;
    end;
    if bConsultaCep then
    begin
      try
        FCepData := FConsultaCEPService.ConsultarCEP(sCep, rdgType.ItemIndex, rdgProtocol.ItemIndex);
      except
        on E: Exception do
          ShowMessage('Erro: ' + E.Message);
      end;
      if FCepData.CEP <> EmptyStr then
        InsereOuAtualizaCep(FCepData, dtmPrincipal.qryExecute, bCepExiste);
    end;
  end
  else
  begin
    edtCep.SetFocus;
    ShowMessage('CEP Inválido!');
  end;
end;

procedure TfrmPrincipal.doConsultaEndereco;
var
  bCepExiste,
  bInserirCep: Boolean;
  Uf: String;
begin
  Uf := cmbUf.Text;
  Uf := Uf.Substring(0, 2);
  bCepExiste := False;
  bInserirCep := True;
  FCepData := Default(TViaCepResult);

  FCepData := FConsultaCEPService.ConsultarEndereco(Uf, edtCidade.Text,
                edtEndereco.Text, rdgType.ItemIndex, rdgProtocol.ItemIndex);
  if (FCepData.CEP <> EmptyStr) then
  begin
    if FConsultaCEPService.CepExists(FCepData.CEP, dtmPrincipal.qryExecute) then
    begin
      bInserirCep := False;
      bCepExiste := Confirma('Cep já existe, deseja atualizar?');
    end;
    if (bInserirCep or bCepExiste) then
      InsereOuAtualizaCep(FCepData, dtmPrincipal.qryExecute, bCepExiste);
  end;
end;
end.

