# Integration Services, Analysis Services e Reporting Services - Do zero ao Datawarehouse com ETL e Cubos


## O que esse projeto contempla:
1. Estudo das Regras de Negócio e montagem de todo ambiente OLTP e OLAP.
2. Instalação do ambiente
3. Criação do Banco de Dados Relacional
4. Modelagem do Banco de Dados Relacional
5. Geração de Dados fictícios na base de dados relacionais, com técnicas de TSQL
6. Criação da área de stage
7. Carga de Dados do operacional para a área de stage, utilizando Integration Services
8. Criação do Datawarehouse
9. Modelagem do Datawarehouse
10. Carga de Dados INCREMENTAL de Dimensões da Stage para o Datawarehouse, utilizando Integration Services com técnicas de SCD.
11. Carga da Tabela Fato da Stage para o DW, utilizando programação TSQL com Integration Services e a técnica de Watermark
12. Montagem do Cubo no Analysis Services
13. Análises no Excel, com criação de Dashboards
14. Criação de Relatórios no ambiente OLTP e no ambiente OLAP

## Requisitos e Escopo do Projeto

O cliente do ramo varejista, necessita armazenar seus dados através de um sistema que será construído posteriormente à modelagem do banco de dados. A equipe de analistas iniciou o levantamento de requisitos conforme descrito nesse documento.

### Perguntas a serem respondidas pelo Datawarehouse

**Entrevista com o manager da empresa**

Hoje vendemos muito, temos lucro, mas não sei qual categoria, fornecedor ou produto me dá mais lucro. Não estou interessado em quantidade. Preciso de analises sumarizadas. Hoje não me interessa saber quantas vendas tem um vendedor e sim o total vendido, pois os mesmos podem recomendar produtos para os nossos clientes. Também gostaria de sabe meus custos por sazonalidade. Preciso saber em que época do ano gasto mais para controlar meus investimentos em estoque ou contratações. Saber qual cliente compra mais comigo em termos totais também seria uma boa ideia. Outra necessidade é um relatório com os dados dos meus clientes, pois a enviar mala direta vai ser uma prática da empresa. Não estou seguro se uma análise por categoria ou fornecedor seria útil. A sua equipe também pode disponibilizar o que achar relevante para o negócio.

- Quem são os melhores clientes?
- Quem são os melhores vendedores?
- Qual categoria rende mais?
- Qual a minha relação com os fornecedores?
- Qual meu pior e melhor produto?
- Em qual região eu vendo mais?

### Fases do Projeto
Em necessidades macro, o projeto foi dividido em 04 grandes fases:
- **Fase 01**: Construção do ambiente OLTP.
- **Fase 02**: Construção da área de Stage.
- **Fase 03**: Construção do Datawarehouse.
- **Fase 04**: Ferramentas de análise de dados.
- **Fase 05**: Catálogo, Automatização de ETL e Cubo e Monitoramento de Pacotes Automatizados

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/src/01%20-%20FASES.png)

### Fase 01: Construção do ambiente OLTP

A fase 01 compreende à modelagem relacional do negócio. O SGBD utilizado foi o SQL Server 2017, versão Enterprise.

**Requisitos**

A Empresa necessita armazenar os seus dados de vendas. O estoque não faz parte do escopo desse projeto, porém, utilizará dos produtos cadastrados nessa modelagem.

**Dos cadastros Gerais**

De forma geral, seguem os requisitos de cadastro abaixo.
1. Cadastro de Produtos
2. Cadastro de Fornecedores
3. Cadastro de Categorias
4. Cadastro de Notas Fiscais
5. Cadastro de Endereço de Clientes
6. Cadastro de Clientes
7. Cadastro de Formas de Pagamentos
8. Cadastro de vendedores (Os vendedores cuidam dos pedidos online, acompanhando os mesmos desde a origem até a entrega, otimizando e solucionando problemas.).

**Dos Campos**

*Todos os cadastros deverão ter números de identificação automáticos e aleatórios*, de forma a deixar a cargo do sistema o controle de identificação de transações.

**Dicionário de Dados**

|  Cadastro Produto |  |
| ------------ | ------------ |
| Produto  | Nome do Produto  |
|   Valor|  Valor de Venda do Produto |
| Custo Médio  | Custo de Compra do Produto  |


|  Cadastro Fornecedor |  |
| ------------ | ------------ |
| Nome  | Nome ou Razão Social do Fornecedor  |


|  Cadastro Categoria |  |
| ------------ | ------------ |
| Nome  | Nome da Categoria do Produto  |


|  Cadastro Nota Fiscal |  |
| ------------ | ------------ |
| Data  | Data da Venda do(s) Produto(s)  |
| Quantidade  | Quantidade de Itens  |
| Total Item  | Valor Total dos Itens  |
| Total  | Valor Total da Nota Fiscal  |


|  Cadastro Endereço |  |
| ------------ | ------------ |
| Rua  | Nome da Rua  |
| Cidade  | Nome da Cidade  |
| Estado  | Nome do Estado  |
| Região  | Região (Norte, Sul, Sudeste, etc)  |


|  Cadastro Cliente |  |
| ------------ | ------------ |
| Nome  | Nome do Cliente  |
| Sobrenome  | Sobrenome do Cliente  |
| Email  | Endereço de Email do Cliente  |
| Sexo  | Sexo do Cliente  |
| Nascimento  | Data de Nascimento do Cliente  |


|  Cadastro Forma de Pagamento |  |
| ------------ | ------------ |
| Forma  | Nome da Forma de Pagamento  |


|  Cadastro Vendedor |  |
| ------------ | ------------ |
| Nome  | Nome do Vendedor  |
| Sexo  | Sexo do Vendedor  |
| Email  | Endereço de Email do Vendedor  |

**Particularidades**

Requisitos levantados pela equipe quanto a detalhes do modelo de negócio. As particularidades são requisitos e são obrigatórios.

1. Nas vendas, uma nota fiscal pode conter um ou mais produtos, diferentes ou do mesmo tipo, contendo um subtotal de produtos do mesmo tipo e um total, com a soma de todos os produtos.
2. Os funcionários possuem gerentes, que deverão ser armazenados no banco de dados.

**Regras de Negócio Essenciais**

Aqui foram analisadas as regras de negócio junto aos usuários da empresa. Os analistas listaram as principais, e caso surjam duvidas ou outras regras, estas deverão ser informadas para a equipe de analistas para que sejam implementadas no banco de dados.

- Um fornecedor pode fornece vários produtos.
- Um cliente pode comprar várias vezes
- Uma nota fiscal só pode ter uma forma de pagamento
- Um vendedor pode emitir várias notas fiscais, mas uma nota só pode ser emitida por um vendedor.
- Um cliente só pode ter um endereço
- Um produto só pode pertencer a uma categoria.
- Uma nota fiscal pode ter vários itens de nota.

**Artefatos - Entregas**

**Modelagem Lógica**

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/Modelagem/Modelagem%20L%C3%B3gica%20DW.jpg)

**Modelagem Física**

> [Scripts SQL](https://github.com/omatheussantos/datawarehouse-sql-server/tree/main/Scripts)

**Constraints**

Abaixo segue o dicionário de constraints criadas no banco COMERCIO_OLTP

*Tabela de Constraints*

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/src/Constraints.png)

*Constraints Aplicadas*

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/src/Constraints%20Aplicadas.png)


### Fase 02: Construção da área de Stage

Na fase 02 começamos a utilizar o Visual Studio, iniciamos o processo de ETL e fizemos a carga de dados na Staging Area.

> [Pacotes ETL](https://github.com/omatheussantos/datawarehouse-sql-server/tree/main/Pacotes/PROJ_ETL)

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/VISUAL%20STUDIO.png)

**Modelagem da Staging Area**

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/Modelagem/Modelagem%20L%C3%B3gica%20STAGE.jpeg)


### Fase 03: Construção do Datawarehouse

Na fase 03 fizemos a construção do Datawarehouse e carga dos dados.

> [Pacotes DW](https://github.com/omatheussantos/datawarehouse-sql-server/tree/main/Pacotes/PROJ_OLAP)

**Modelagem do Datawarehouse**

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/Modelagem/Modelagem%20L%C3%B3gica%20DW.jpg)


### Fase 04: Ferramentas de análise de dados

Na fase 04 criamos o Cubo OLAP no Analysis Services, criamos o servidor e relatórios utulizando Reporting Services.

> [Pacotes Relatórios](https://github.com/omatheussantos/datawarehouse-sql-server/tree/main/Pacotes/PROJ_REPORTS/Report%20Project1)


### Fase 05: Catálogo, Automatização de ETL e Cubo e Monitoramento de Pacotes Automatizados

Na quinta e última fase do projeto criamos o catálogo SQL Server Integration Services (SSIS), automatizamos a rotina de ETL e Processamento do Cubo, além de fazer o monitoramento de Pacotes Automatizados.

![](https://github.com/omatheussantos/datawarehouse-sql-server/blob/main/SQL%20SERVER.png)

------------
Feito por Matheus Santos | Visite meu [Linkedin](https://www.linkedin.com/in/omatheussantos/)
