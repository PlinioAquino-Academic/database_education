# Projeto de Banco de Dados: Sistema de Delivery de Comida (iFood-like)

Bem-vindo(a) ao repositório do projeto de sistema de delivery de comida, inspirado em plataformas como o iFood! Este projeto é um estudo de caso avançado em modelagem e implementação de bancos de dados relacionais, com foco em conceitos cruciais como **Normalização (Terceira Forma Normal - 3FN)** e **Disjunção (Especialização/Generalização)** para métodos de pagamento.

## Objetivo do Projeto

O principal objetivo deste projeto é demonstrar a construção de um banco de dados robusto e escalável para um sistema de delivery, gerenciando entidades como Restaurantes, Clientes, Produtos, Pedidos e, de forma inovadora, os diferentes tipos de Pagamento. A solução foi projetada para ser compatível com **PostgreSQL** e otimizada para implantação em plataformas como o **Supabase**.

## Conceitos Técnicos Abordados

### 1. Modelagem Entidade-Relacionamento (MER) e Modelo Relacional (MR)

O projeto inicia com uma modelagem conceitual (MER) e lógica (MR) detalhada, que serve como base para a implementação do banco de dados. O diagrama ER visualiza as entidades e seus relacionamentos, enquanto o Modelo Relacional especifica as tabelas, atributos, chaves primárias (PK), chaves estrangeiras (FK) e restrições de integridade.

### 2. Terceira Forma Normal (3FN)

Todo o design do banco de dados adere rigorosamente à **Terceira Forma Normal (3FN)**. Isso garante que:
*   Não existam dependências parciais (2FN).
*   Não existam dependências transitivas, ou seja, atributos não-chave não dependem de outros atributos não-chave.

Essa normalização minimiza a redundância de dados, previne anomalias de inserção, atualização e exclusão, e promove a consistência e a integridade dos dados a longo prazo.

### 3. Disjunção (Especialização/Generalização) para Pagamentos

Um dos pontos altos deste projeto é a implementação da disjunção para os métodos de pagamento. A entidade `Pagamento` atua como um **supertipo** genérico, contendo informações comuns a todos os pagamentos (ID, valor, data, status, etc.). A partir dela, especializamos em **subtipos**:

*   `PagamentoCartao`
*   `PagamentoPix`
*   `PagamentoValeRefeicao`

Cada subtipo possui atributos específicos do seu método de pagamento. Essa abordagem permite:
*   **Extensibilidade**: Facilita a adição de novos métodos de pagamento no futuro sem alterar a estrutura das tabelas principais.
*   **Reuso**: Atributos comuns são centralizados na entidade `Pagamento`.
*   **Integridade**: Garante que cada pagamento seja de um tipo específico e que os dados sejam armazenados de forma consistente.

### 4. Restrições de Integridade

O script DDL (Data Definition Language) implementa diversas restrições para garantir a integridade e a validade dos dados:

*   **Chaves Primárias (PK)**: Identificadores únicos para cada registro, utilizando `UUID`s para escalabilidade e distribuição.
*   **Chaves Estrangeiras (FK)**: Estabelecem os relacionamentos entre as tabelas, garantindo a integridade referencial (`ON DELETE RESTRICT`, `ON UPDATE CASCADE`).
*   **Restrições UNIQUE**: Garantem a unicidade de atributos como `email` do cliente, `cnpj` do restaurante e `id_transacao_pix`.
*   **Restrições CHECK**: Validam o formato de dados (ex: `email` válido, `preco` positivo) e regras de negócio (ex: `data_devolucao >= data_emprestimo`).
*   **Valores DEFAULT**: Definem valores padrão para campos como `data_cadastro`.

## Estrutura do Repositório

*   `enunciado_ifood_like.md`: Descrição detalhada do problema e regras de negócio.
*   `mer_ifood_like_simplified_final.mmd`: Diagrama ER em formato Mermaid.
*   `mer_ifood_like_simplified_final.png`: Imagem do Diagrama ER.
*   `mr_ifood_like.md`: Modelo Relacional detalhado.
*   `ddl_ifood_like_supabase.sql`: Script SQL DDL para criação do banco de dados no Supabase (PostgreSQL).
*   `dml_ifood_like_supabase.sql`: Script SQL DML para popular o banco de dados com dados fictícios.
*   `consultas_ifood_like.sql`: Exemplos de consultas DQL complexas.
*   `explicacao_er_ifood_like.md`: Explicação detalhada do diagrama ER, disjunção e 3FN.

## Como Utilizar (Supabase/PostgreSQL)

1.  **Crie um Projeto Supabase**: Acesse [Supabase](https://supabase.com/) e crie um novo projeto. Ele provisionará uma instância PostgreSQL para você.
2.  **Acesse o SQL Editor**: No painel do Supabase, navegue até a seção "SQL Editor".
3.  **Execute o DDL**: Copie e cole o conteúdo de `ddl_ifood_like_supabase.sql` no editor e execute-o para criar as tabelas e restrições.
4.  **Popule o Banco de Dados**: Em seguida, copie e cole o conteúdo de `dml_ifood_like_supabase.sql` e execute-o para popular o banco com dados fictícios.
5.  **Teste as Consultas**: Utilize o `consultas_ifood_like.sql` para explorar os dados e testar os relacionamentos e a lógica de negócio.

## Guia de Estudos de Banco de Dados

Para quem deseja aprofundar seus conhecimentos em bancos de dados relacionais, aqui estão algumas dicas valiosas:

1.  **Fundamentos da Modelagem (MER)**: Comece entendendo entidades, atributos (simples, compostos, multivalorados), tipos de relacionamentos (1:1, 1:N, N:M) e cardinalidades. Ferramentas visuais como o Mermaid (utilizado neste projeto) são excelentes para praticar.

2.  **Normalização é Essencial**: Domine as Formas Normais (1FN, 2FN, 3FN e, se possível, BCNF). Entenda o conceito de dependências funcionais e como a normalização ajuda a eliminar redundâncias e anomalias. A 3FN é um padrão robusto para a maioria dos sistemas.

3.  **Prática Constante de SQL**: A teoria é importante, mas a prática é fundamental. Escreva muitos comandos DDL para criar e alterar tabelas, DML para manipular dados e, principalmente, DQL para consultar. Experimente `JOIN`s complexos, subconsultas, funções de agregação (`COUNT`, `SUM`, `AVG`), `GROUP BY`, `HAVING` e `WHERE` com operadores lógicos.

4.  **Integridade de Dados**: Compreenda a importância das restrições (PK, UNIQUE, FK, CHECK, NOT NULL) para garantir que os dados sejam consistentes e válidos. Elas são a primeira linha de defesa contra dados incorretos.

5.  **Conceitos Avançados**: Explore índices para otimização de performance, transações (propriedades ACID), visões, stored procedures, triggers e segurança (como Row Level Security no PostgreSQL/Supabase). Estes tópicos elevam a qualidade de suas soluções.

6.  **Ferramentas e Plataformas**: Utilize ambientes como o Supabase para praticar. Ele oferece um PostgreSQL completo com recursos adicionais que simulam um ambiente de produção.

7.  **Documentação e Comunidade**: Consulte a documentação oficial do seu SGBD (PostgreSQL, MySQL, SQL Server) e participe de comunidades online. A troca de conhecimento é valiosa.

## Por que Supabase (PostgreSQL)?

O Supabase é uma plataforma de código aberto que oferece um banco de dados PostgreSQL como seu core, juntamente com uma suíte de ferramentas de backend. É uma escolha poderosa para desenvolvimento moderno devido a:

*   **PostgreSQL**: Um dos SGBDs relacionais mais avançados, confiáveis e com maior conformidade com o padrão ANSI SQL.
*   **Backend-as-a-Service (BaaS)**: Simplifica o desenvolvimento ao fornecer autenticação, APIs instantâneas (REST e GraphQL), armazenamento de arquivos e funções de borda, tudo integrado ao seu banco de dados.
*   **Row Level Security (RLS)**: Permite definir políticas de segurança granulares diretamente no banco de dados, controlando o acesso a dados em nível de linha para diferentes usuários ou funções. Essencial para aplicações multiusuário.
*   **Escalabilidade**: Projetado para crescer com sua aplicação, desde protótipos até sistemas de grande escala.
*   **Desenvolvimento Acelerado**: Reduz o tempo de configuração e gerenciamento de infraestrutura, permitindo que você se concentre na lógica de negócio da sua aplicação.

Ao utilizar o Supabase, você não apenas aplica seus conhecimentos em SQL, mas também se familiariza com uma plataforma moderna que acelera o desenvolvimento de aplicações web e mobile.

## Resumo de Comandos SQL ANSI (Cheat Sheet para Estudos)

Esta seção oferece um resumo dos comandos SQL mais comuns, categorizados por sua função, seguindo o padrão ANSI SQL. É um guia rápido para consulta e estudo.

### 1. DDL (Data Definition Language) - Definição de Dados

Comandos para definir, modificar ou excluir a estrutura do banco de dados.

| Comando | Descrição | Exemplo |
| :------ | :-------- | :------ |
| `CREATE DATABASE` | Cria um novo banco de dados. | `CREATE DATABASE minha_empresa;` |
| `CREATE TABLE` | Cria uma nova tabela. | `CREATE TABLE Produtos (id INT PRIMARY KEY, nome VARCHAR(100) NOT NULL);` |
| `ALTER TABLE` | Modifica a estrutura de uma tabela existente. | `ALTER TABLE Produtos ADD COLUMN preco DECIMAL(10, 2);` <br> `ALTER TABLE Produtos DROP COLUMN preco;` <br> `ALTER TABLE Produtos ALTER COLUMN nome VARCHAR(200);` |
| `DROP TABLE` | Exclui uma tabela existente. | `DROP TABLE Produtos;` |
| `CREATE INDEX` | Cria um índice em uma tabela para otimizar consultas. | `CREATE INDEX idx_nome_produto ON Produtos (nome);` |
| `DROP INDEX` | Exclui um índice. | `DROP INDEX idx_nome_produto;` |
| `CREATE VIEW` | Cria uma visão (tabela virtual) baseada no resultado de uma consulta. | `CREATE VIEW ProdutosAtivos AS SELECT nome, preco FROM Produtos WHERE disponivel = TRUE;` |
| `DROP VIEW` | Exclui uma visão. | `DROP VIEW ProdutosAtivos;` |
| `CREATE SCHEMA` | Cria um novo esquema para organizar objetos do banco de dados. | `CREATE SCHEMA vendas;` |
| `DROP SCHEMA` | Exclui um esquema. | `DROP SCHEMA vendas;` |

### 2. DML (Data Manipulation Language) - Manipulação de Dados

Comandos para manipular os dados dentro das tabelas.

| Comando | Descrição | Exemplo |
| :------ | :-------- | :------ |
| `INSERT INTO` | Insere novos registros em uma tabela. | `INSERT INTO Produtos (id, nome, preco) VALUES (1, 'Teclado', 150.00);` |
| `UPDATE` | Modifica registros existentes em uma tabela. | `UPDATE Produtos SET preco = 160.00 WHERE id = 1;` |
| `DELETE FROM` | Exclui registros de uma tabela. | `DELETE FROM Produtos WHERE id = 1;` |

### 3. DQL (Data Query Language) - Consulta de Dados

Comandos para recuperar dados do banco de dados.

| Comando | Descrição | Exemplo |
| :------ | :-------- | :------ |
| `SELECT` | Recupera dados de uma ou mais tabelas. | `SELECT nome, preco FROM Produtos;` |
| `WHERE` | Filtra registros com base em uma condição. | `SELECT * FROM Produtos WHERE preco > 100;` |
| `ORDER BY` | Ordena o resultado da consulta. | `SELECT * FROM Produtos ORDER BY nome ASC;` |
| `GROUP BY` | Agrupa linhas que têm os mesmos valores em colunas especificadas. | `SELECT categoria, COUNT(*) FROM Produtos GROUP BY categoria;` |
| `HAVING` | Filtra grupos criados pelo `GROUP BY`. | `SELECT categoria, COUNT(*) FROM Produtos GROUP BY categoria HAVING COUNT(*) > 5;` |
| `JOIN` | Combina linhas de duas ou mais tabelas com base em uma coluna relacionada. | `SELECT p.nome, c.nome_cliente FROM Pedidos p JOIN Clientes c ON p.id_cliente = c.id_cliente;` |
| `INNER JOIN` | Retorna registros quando há correspondência em ambas as tabelas. | `SELECT * FROM TabelaA INNER JOIN TabelaB ON TabelaA.id = TabelaB.id;` |
| `LEFT JOIN` (ou `LEFT OUTER JOIN`) | Retorna todos os registros da tabela esquerda e os registros correspondentes da tabela direita. | `SELECT * FROM TabelaA LEFT JOIN TabelaB ON TabelaA.id = TabelaB.id;` |
| `RIGHT JOIN` (ou `RIGHT OUTER JOIN`) | Retorna todos os registros da tabela direita e os registros correspondentes da tabela esquerda. | `SELECT * FROM TabelaA RIGHT JOIN TabelaB ON TabelaA.id = TabelaB.id;` |
| `FULL JOIN` (ou `FULL OUTER JOIN`) | Retorna todos os registros quando há uma correspondência em uma das tabelas. | `SELECT * FROM TabelaA FULL JOIN TabelaB ON TabelaA.id = TabelaB.id;` |
| `UNION` | Combina o resultado de duas ou mais instruções `SELECT` (remove duplicatas). | `SELECT nome FROM Clientes UNION SELECT nome FROM Fornecedores;` |
| `UNION ALL` | Combina o resultado de duas ou mais instruções `SELECT` (inclui duplicatas). | `SELECT nome FROM Clientes UNION ALL SELECT nome FROM Fornecedores;` |
| `EXISTS` | Testa a existência de linhas em uma subconsulta. | `SELECT nome FROM Clientes WHERE EXISTS (SELECT 1 FROM Pedidos WHERE Pedidos.id_cliente = Clientes.id);` |
| `IN` | Verifica se um valor corresponde a qualquer valor em uma lista ou subconsulta. | `SELECT nome FROM Produtos WHERE categoria IN ('Eletrônicos', 'Informática');` |
| `LIKE` | Busca por um padrão em uma coluna. | `SELECT nome FROM Produtos WHERE nome LIKE 'P%';` |
| `BETWEEN` | Seleciona valores dentro de um determinado intervalo. | `SELECT * FROM Pedidos WHERE data BETWEEN '2024-01-01' AND '2024-01-31';` |
| `AS` | Renomeia uma coluna ou tabela. | `SELECT nome AS NomeProduto FROM Produtos;` |
| `COUNT()` | Retorna o número de linhas que correspondem a um critério especificado. | `SELECT COUNT(*) FROM Produtos;` |
| `SUM()` | Retorna a soma total de uma coluna numérica. | `SELECT SUM(preco) FROM Produtos;` |
| `AVG()` | Retorna o valor médio de uma coluna numérica. | `SELECT AVG(preco) FROM Produtos;` |
| `MIN()` | Retorna o menor valor de uma coluna. | `SELECT MIN(preco) FROM Produtos;` |
| `MAX()` | Retorna o maior valor de uma coluna. | `SELECT MAX(preco) FROM Produtos;` |

### 4. DCL (Data Control Language) - Controle de Dados

Comandos para gerenciar permissões e controle de acesso ao banco de dados.

| Comando | Descrição | Exemplo |
| :------ | :-------- | :------ |
| `GRANT` | Concede permissões a usuários ou funções. | `GRANT SELECT, INSERT ON Produtos TO usuario_vendas;` |
| `REVOKE` | Remove permissões de usuários ou funções. | `REVOKE INSERT ON Produtos FROM usuario_vendas;` |

### 5. DTL (Data Transaction Language) - Transação de Dados

Comandos para gerenciar transações no banco de dados.

| Comando | Descrição | Exemplo |
| :------ | :-------- | :------ |
| `BEGIN TRANSACTION` (ou `START TRANSACTION`) | Inicia uma transação. | `BEGIN TRANSACTION;` |
| `COMMIT` | Salva todas as alterações feitas na transação. | `COMMIT;` |
| `ROLLBACK` | Desfaz todas as alterações feitas na transação. | `ROLLBACK;` |

