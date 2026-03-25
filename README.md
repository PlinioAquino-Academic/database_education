# Projetos de Banco de Dados Relacionais

Bem-vindo(a) ao meu repositório de projetos de Banco de Dados! Aqui você encontrará uma coleção de exercícios práticos e soluções detalhadas para desafios de modelagem e implementação de bancos de dados relacionais. O objetivo é demonstrar a aplicação de conceitos fundamentais como Modelagem Entidade-Relacionamento (MER), Modelo Relacional (MR), Normalização (especialmente a 3ª Forma Normal - 3FN), integridade de dados (PK, UNIQUE, FK, CHECK, DEFAULT) e a utilização de disjunção (especialização/generalização).

Cada projeto inclui:
*   Um **enunciado** detalhado do problema.
*   O **Modelo Entidade-Relacionamento (MER)** e seu diagrama visual.
*   O **Modelo Relacional (MR)** correspondente.
*   **Scripts SQL DDL** (Data Definition Language) para criação das tabelas, com todas as restrições.
*   **Scripts SQL DML** (Data Manipulation Language) para popular o banco de dados com dados fictícios.
*   **Scripts SQL DQL** (Data Query Language) com consultas complexas para testar o modelo.

Os scripts DDL e DML são fornecidos tanto no **padrão ANSI SQL** quanto adaptados para **Supabase (PostgreSQL)**, destacando as diferenças e vantagens de cada abordagem.

## Vídeo de demonstração

[![Assista ao vídeo no YouTube](https://img.youtube.com/vi/SEU_VIDEO_ID/maxresdefault.jpg)](https://www.youtube.com/watch?v=SEU_VIDEO_ID)


## Projetos Desenvolvidos

### 1. Sistema de Streaming de Música

Este projeto aborda a modelagem de um sistema básico de streaming de música, gerenciando usuários, artistas, músicas, reproduções e avaliações. É um excelente ponto de partida para entender os conceitos básicos de modelagem relacional e integridade de dados.

**Conceitos Abordados:**
*   Entidades e atributos básicos.
*   Relacionamentos 1:N e N:M (resolvido com tabela associativa).
*   Chaves Primárias (PK) e Estrangeiras (FK).
*   Restrições `NOT NULL` e `UNIQUE`.

**Arquivos Relevantes:**
*   `Solucao_Final_Prova_BD.md`: Documento completo com MER, MR, DDL e DML (ANSI e Supabase).
*   `mer_streaming_musica.png`: Diagrama ER visual.

### 2. Sistema de Gestão Hospitalar

Um projeto mais complexo que simula um sistema de gestão para um hospital. Inclui a gestão de pacientes, médicos, consultas, internações, prontuários eletrônicos, medicamentos e alas hospitalares. Este cenário introduz uma complexidade maior nos relacionamentos e nas restrições de integridade.

**Conceitos Abordados:**
*   Relacionamentos 1:1, 1:N e N:M (com tabelas associativas).
*   Entidades Fracas (ex: `RegistroProntuario` dependente de `Prontuario`).
*   Restrições `CHECK` para validação de dados (ex: `capacidade_maxima > 0`, `data_saida >= data_entrada`).
*   Uso de `DEFAULT` para campos como `data_cadastro`.
*   Scripts DDL e DML detalhados para ANSI e Supabase.

**Arquivos Relevantes:**
*   `Solucao_Final_Prova_BD_Hospitalar.md`: Documento completo com enunciado, MER, MR, DDL e DML (ANSI e Supabase), e exemplos de DML/DQL.
*   `mer_hospitalar.png`: Diagrama ER visual.
*   `script_populacao_hospitalar.sql`: Script DML para popular o banco de dados hospitalar.
*   `consultas_complexas_hospitalar.sql`: Script DQL com consultas avançadas.

### 3. Sistema de Delivery de Comida (iFood-like)

Este é o projeto mais avançado, modelando um sistema de delivery de comida com foco na gestão de pedidos e, principalmente, na implementação de **disjunção (especialização/generalização)** para os métodos de pagamento (Cartão, PIX, Vale-Refeição). O design segue rigorosamente a **Terceira Forma Normal (3FN)** e é otimizado para **Supabase (PostgreSQL)**.

**Conceitos Abordados:**
*   **Disjunção (Especialização/Generalização)**: Modelagem de hierarquias de entidades (Pagamento genérico e suas especializações).
*   **Terceira Forma Normal (3FN)**: Garantia de que o modelo está bem normalizado, eliminando dependências transitivas.
*   **Restrições Avançadas**: `CHECK` para formato de email, `LENGTH` para dígitos finais de cartão, `ON DELETE CASCADE/RESTRICT` para FKs.
*   **UUIDs como PKs**: Utilização de `gen_random_uuid()` para identificadores únicos e distribuídos.
*   **Row Level Security (RLS)**: Exemplos de políticas de segurança no Supabase.

**Arquivos Relevantes:**
*   `Solucao_Final_iFood_Like.md`: Documento completo com enunciado, MER, MR, DDL e DML (Supabase), e exemplos de DML/DQL.
*   `mer_ifood_like.png`: Diagrama ER visual.
*   `ddl_ifood_like_supabase.sql`: Script DDL para criação do banco de dados no Supabase.
*   `dml_ifood_like_supabase.sql`: Script DML para popular o banco de dados no Supabase.

## Guia de Estudos de Banco de Dados

Estudar bancos de dados é fundamental para qualquer profissional de tecnologia. Aqui estão algumas dicas para aprofundar seus conhecimentos:

1.  **Entenda os Fundamentos da Modelagem**: Comece com o Modelo Entidade-Relacionamento (MER). Compreenda entidades, atributos, tipos de atributos (simples, composto, multivalorado, derivado) e, crucialmente, os tipos de relacionamentos (1:1, 1:N, N:M) e suas cardinalidades. Ferramentas como o Mermaid (utilizado neste repositório) são ótimas para visualizar seus diagramas.

2.  **Domine a Normalização**: A normalização é a chave para projetar bancos de dados eficientes e sem redundâncias. Comece pela 1FN, 2FN e 3FN. Entenda o que são dependências funcionais e como eliminá-las para evitar anomalias de inserção, atualização e exclusão. A 3FN é um bom objetivo para a maioria dos projetos.

3.  **Pratique SQL Constantemente**: A melhor forma de aprender SQL é praticando. Escreva comandos DDL para criar tabelas com todas as restrições (PK, UNIQUE, FK, CHECK, DEFAULT). Crie scripts DML para inserir, atualizar e deletar dados. E, principalmente, desenvolva consultas DQL complexas com `JOIN`s, `WHERE`, `GROUP BY`, `HAVING`, subconsultas e funções de agregação. Plataformas como o Supabase oferecem um ambiente PostgreSQL gratuito e fácil de usar para isso.

4.  **Compreenda a Integridade de Dados**: As restrições (PK, UNIQUE, FK, CHECK, NOT NULL) não são apenas sintaxe; elas são a base para garantir que seus dados sejam consistentes e válidos. Entenda o propósito de cada uma e como elas protegem seu banco de dados de informações incorretas.

5.  **Explore Conceitos Avançados**: Após os fundamentos, mergulhe em tópicos como índices (para performance), transações (ACID), visões, stored procedures, triggers e segurança (como Row Level Security no PostgreSQL/Supabase). Estes conceitos elevam a qualidade e a robustez de suas aplicações.

6.  **Utilize Ferramentas Visuais**: Ferramentas de modelagem (como o draw.io, Lucidchart ou mesmo o Mermaid no VS Code) ajudam a visualizar o MER e o MR, tornando o processo de design mais intuitivo.

7.  **Mantenha-se Atualizado**: O mundo dos bancos de dados está em constante evolução. Acompanhe as novidades de SGBDs que você utiliza e explore novas tecnologias (NoSQL, bancos de dados em nuvem, etc.).

## Por que Supabase (PostgreSQL)?

O Supabase é uma plataforma de código aberto que oferece um banco de dados PostgreSQL com funcionalidades de Backend-as-a-Service (BaaS). Ele é uma excelente escolha para projetos modernos por várias razões:

*   **PostgreSQL Robusto**: Um dos SGBDs relacionais mais avançados e confiáveis do mercado, com forte conformidade ANSI SQL.
*   **Facilidade de Uso**: Simplifica a configuração e o gerenciamento de bancos de dados.
*   **Recursos Integrados**: Oferece autenticação, APIs instantâneas (REST e GraphQL), armazenamento de arquivos e funções Edge, tudo integrado ao seu banco de dados.
*   **Row Level Security (RLS)**: Permite implementar políticas de segurança granulares diretamente no banco de dados, controlando o acesso a dados em nível de linha, o que é crucial para aplicações multiusuário.
*   **Escalabilidade**: Projetado para escalar com suas necessidades, desde pequenos projetos até aplicações de grande porte.
*   **Comunidade Ativa**: Beneficia-se de uma grande comunidade de desenvolvedores e vasta documentação.

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

---

Espero que este `README.md` seja um recurso valioso para você e para quem visitar seu repositório!
