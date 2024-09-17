CREATE TABLE enderecos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cep TEXT(9),
    logradouro TEXT(255),
    complemento TEXT(255),
    bairro TEXT(255),
    localidade TEXT(255),
    uf TEXT(2)
);
CREATE UNIQUE INDEX idx_cep_unique ON enderecos(cep);
