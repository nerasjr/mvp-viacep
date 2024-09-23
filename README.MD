MVP ViaCEP
Este projeto é uma aplicação para consulta de CEP utilizando o serviço público do ViaCEP. Ele foi desenvolvido em Delphi 12, seguindo princípios de Clean Code, SOLID e POO.

Índice
Arquitetura
Padrões de Projeto
Pré-requisitos
Como Executar
Estrutura do Projeto
Licença
Arquitetura
A aplicação segue uma arquitetura baseada em MVP (Model-View-Presenter), que separa a lógica de negócios da interface do usuário. Isso facilita a manutenção, testes e a escalabilidade do projeto.

Model: Responsável por representar e manipular os dados.
View: Responsável pela interface gráfica e interação com o usuário.
Presenter: Controla a lógica entre a View e o Model, fazendo a comunicação entre eles.
Além disso, o projeto utiliza o princípio de injeção de dependência para garantir a inversão de controle e melhorar a flexibilidade dos componentes.

Padrões de Projeto
O projeto aplica diversos padrões de design, incluindo:

Singleton: Utilizado para garantir que algumas classes sejam instanciadas uma única vez durante o ciclo de vida da aplicação.
Factory Method: Usado para criar instâncias de serviços e garantir a coesão do código.
Repository: Para encapsular o acesso aos dados e abstrair a fonte de dados, permitindo uma implementação mais desacoplada.
DTO (Data Transfer Object): Para transferência de dados entre camadas de maneira eficiente.
Pré-requisitos
Delphi 12 ou superior
FireDAC para conexão com o banco de dados
Bibliotecas OpenSSL (se necessário para conexões HTTPS)
Acesso à internet para consultar o ViaCEP
Como Executar
Clone o repositório:

bash
Copiar código
git clone https://github.com/nerasjr/mvp-viacep.git
Abra o projeto no Delphi 12.

Instale as dependências necessárias:
libeay32.dll e ssleay32.dll da pasta libssl

Execute a aplicação clicando no botão "Run" ou pressionando F9.

Utilize a interface gráfica para inserir um CEP e receber os dados da consulta.

Licença
Este projeto está licenciado sob a MIT License.
