unit untViaCepInterface;

interface

uses
  System.JSON, System.SysUtils, System.StrUtils, REST.Client, REST.Types,
  TypInfo, Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections;

type

  TEnumJsonXml = (json, xml);
  TEnumProtocol = (https, http);

  TViaCepResult = record
    CEP: string;
    Logradouro: string;
    Complemento: string;
    Bairro: string;
    Localidade: string;
    UF: string;
  end;

  IViaCEPClient = interface
    ['{A1B2C3D4-E5F6-4789-ABCD-123456789ABC}']
    function ConsultarPorCEP(const ACep: string): TViaCepResult;
    function ConsultarPorEndereco(const AEstado, ACidade, AEndereco: string): TViaCepResult;
    function GetProtocol(): TEnumProtocol;
    procedure SetProtocol(const AValue: TEnumProtocol);
    function GetEnumJsonXml(): TEnumJsonXml;
    procedure SetEnumJsonXml(const AValue: TEnumJsonXml);
    property Protocol: TEnumProtocol read GetProtocol write SetProtocol;
    property TypeJsonXml: TEnumJsonXml read GetEnumJsonXml write SetEnumJsonXml;
  end;

  TViaCEPClient = class(TInterfacedObject, IViaCEPClient)
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FProtocol: TEnumProtocol;
    FTypeJsonXml: TEnumJsonXml;
    function ParseResponse(const AResponse: string): TViaCepResult;
    function ParseMultipleResults(
      const AResponse: string): TArray<TViaCepResult>;
  public
    constructor Create;
    destructor Destroy; override;
    function ConsultarPorCEP(const ACep: string): TViaCepResult;
    function ConsultarPorEndereco(const AEstado, ACidade, AEndereco: string): TViaCepResult;
    function GetProtocol(): TEnumProtocol;
    procedure SetProtocol(const AValue: TEnumProtocol);
    function GetEnumJsonXml(): TEnumJsonXml;
    procedure SetEnumJsonXml(const AValue: TEnumJsonXml);
    property Protocol: TEnumProtocol read GetProtocol write SetProtocol;
    property TypeJsonXml: TEnumJsonXml read GetEnumJsonXml write SetEnumJsonXml;
  end;

implementation

uses undSelecionarCep;

constructor TViaCEPClient.Create;
begin
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Method := rmGET;
end;

destructor TViaCEPClient.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  inherited;
end;

function TViaCEPClient.GetEnumJsonXml: TEnumJsonXml;
begin
  Result := FTypeJsonXml;
end;

function TViaCEPClient.GetProtocol: TEnumProtocol;
begin
  Result := FProtocol;
end;

function TViaCEPClient.ConsultarPorCEP(const ACEP: String): TViaCepResult;
begin
  FRESTClient.BaseURL := Format('%s://viacep.com.br/ws/%s/%s/', [GetEnumName(TypeInfo(TEnumProtocol), integer(FProtocol)),
    ACep, GetEnumName(TypeInfo(TEnumJsonXml), integer(FTypeJsonXml))]);
  FRESTRequest.Execute;
  if FRESTResponse.StatusCode = 200 then
    Result := ParseResponse(FRESTResponse.Content)
  else
    raise Exception.Create('Erro: ' + FRESTResponse.StatusText);
end;

function TViaCEPClient.ConsultarPorEndereco(const AEstado, ACidade, AEndereco: string): TViaCepResult;
var
  Resultados: TArray<TViaCepResult>;
  SelectedResult: TViaCepResult;
begin
  FRESTClient.BaseURL := Format('%s://viacep.com.br/ws/%s/%s/%s/%s/', [GetEnumName(TypeInfo(TEnumProtocol), integer(FProtocol)),
    AEstado, ACidade, AEndereco, GetEnumName(TypeInfo(TEnumJsonXml), integer(FTypeJsonXml))]);
  FRESTRequest.Execute;
  if FRESTResponse.StatusCode = 200 then
  begin
    Resultados := ParseMultipleResults(FRESTResponse.Content);
    if Length(Resultados) > 1 then
    begin
      frmSelecionarCEP := TfrmSelecionarCEP.Create(nil);
      SelectedResult := frmSelecionarCEP.SelecionarCEP(Resultados);
      Result := SelectedResult;
    end
    else if Length(Resultados) = 1 then
      Result := Resultados[0]
    else
      raise Exception.Create('Endereço não existe!');

  end
  else
    raise Exception.Create('Erro ao consultar endereço: ' + FRESTResponse.StatusText);
end;

function TViaCEPClient.ParseMultipleResults(const AResponse: string): TArray<TViaCepResult>;
var
  JSONArray: TJSONArray;
  JSONObj: TJSONObject;
  XMLDocument: IXMLDocument;
  RootNode, Node: IXMLNode;
  ResultList: TArray<TViaCepResult>;
  ResultData: TViaCepResult;
  I: Integer;
begin
  if FTypeJsonXml = json then
  begin
    JSONArray := TJSONObject.ParseJSONValue(AResponse) as TJSONArray;
    try
      SetLength(ResultList, JSONArray.Count);

      for I := 0 to JSONArray.Count - 1 do
      begin
        JSONObj := JSONArray.Items[I] as TJSONObject;
        ResultData.CEP := JSONObj.GetValue<string>('cep', '');
        ResultData.Logradouro := JSONObj.GetValue<string>('logradouro', '');
        ResultData.Complemento := JSONObj.GetValue<string>('complemento', '');
        ResultData.Bairro := JSONObj.GetValue<string>('bairro', '');
        ResultData.Localidade := JSONObj.GetValue<string>('localidade', '');
        ResultData.UF := JSONObj.GetValue<string>('uf', '');
        ResultList[I] := ResultData;
      end;
    finally
      JSONArray.Free;
    end;
    Result := ResultList;
  end
  else if FTypeJsonXml = xml then
  begin
    XMLDocument := TXMLDocument.Create(nil);
    try
      XMLDocument.LoadFromXML(AResponse);
      XMLDocument.Active := True;
      RootNode := XMLDocument.DocumentElement;
      SetLength(ResultList, RootNode.ChildNodes.Count);
      for I := 0 to RootNode.ChildNodes.Count - 1 do
      begin
        Node := RootNode.ChildNodes[I];
        ResultData.CEP := Node.ChildNodes['cep'].Text;
        ResultData.Logradouro := Node.ChildNodes['logradouro'].Text;
        ResultData.Complemento := Node.ChildNodes['complemento'].Text;
        ResultData.Bairro := Node.ChildNodes['bairro'].Text;
        ResultData.Localidade := Node.ChildNodes['localidade'].Text;
        ResultData.UF := Node.ChildNodes['uf'].Text;
        ResultList[I] := ResultData;
      end;
    finally
      XMLDocument := nil;
    end;
    Result := ResultList;
  end;
end;

function TViaCEPClient.ParseResponse(const AResponse: string): TViaCepResult;
var
  JSONObj: TJSONObject;
  XMLDocument: IXMLDocument;
  ResultData: TViaCepResult;
begin
  ResultData := Default(TViaCepResult);
  if FTypeJsonXml = json then
  begin
    JSONObj := TJSONObject.ParseJSONValue(AResponse) as TJSONObject;
    try
      if JSONObj.GetValue<string>('erro', 'false') = 'true' then
      begin

        raise Exception.Create('CEP não encontrado.');
      end
      else
      begin
        ResultData.CEP := JSONObj.GetValue<string>('cep', '');
        ResultData.Logradouro := JSONObj.GetValue<string>('logradouro', '');
        ResultData.Complemento := JSONObj.GetValue<string>('complemento', '');
        ResultData.Bairro := JSONObj.GetValue<string>('bairro', '');
        ResultData.Localidade := JSONObj.GetValue<string>('localidade', '');
        ResultData.UF := JSONObj.GetValue<string>('uf', '');
      end;
    finally
      JSONObj.Free;
    end;
  end
  else if FTypeJsonXml = xml then
  begin
    XMLDocument := TXMLDocument.Create(nil);
    try
      XMLDocument.LoadFromXML(AResponse);
      XMLDocument.Active := True;
      if XMLDocument.DocumentElement.ChildNodes.FindNode('erro') <> nil then
      begin
        raise Exception.Create('CEP não encontrado.');
      end
      else
      begin
        ResultData.CEP := XMLDocument.DocumentElement.ChildNodes['cep'].Text;
        ResultData.Logradouro := XMLDocument.DocumentElement.ChildNodes['logradouro'].Text;
        ResultData.Complemento := XMLDocument.DocumentElement.ChildNodes['complemento'].Text;
        ResultData.Bairro := XMLDocument.DocumentElement.ChildNodes['bairro'].Text;
        ResultData.Localidade := XMLDocument.DocumentElement.ChildNodes['localidade'].Text;
        ResultData.UF := XMLDocument.DocumentElement.ChildNodes['uf'].Text;
      end;
    finally
      XMLDocument := nil;
    end;
  end;

  Result := ResultData;
end;

procedure TViaCEPClient.SetEnumJsonXml(const AValue: TEnumJsonXml);
begin
  FTypeJsonXml := AValue;
end;

procedure TViaCEPClient.SetProtocol(const AValue: TEnumProtocol);
begin
  FProtocol := AValue;
end;

end.

