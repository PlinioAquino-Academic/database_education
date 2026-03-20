# Projetos de Banco de Dados Relacionais

Bem-vindo(a) ao meu repositório de projetos de Banco de Dados! Aqui você encontrará uma coleção de exercícios práticos e soluções detalhadas para desafios de modelagem e implementação de bancos de dados relacionais. O objetivo é demonstrar a aplicação de conceitos fundamentais como Modelagem Entidade-Relacionamento (MER), Modelo Relacional (MR), Normalização (da 1ª à 5ª Forma Normal, incluindo 3FN e BCNF), integridade de dados (PK, UNIQUE, FK, CHECK, DEFAULT) e a utilização de disjunção (especialização/generalização).

Cada projeto inclui:
*   Um **enunciado** detalhado do problema.
*   O **Modelo Entidade-Relacionamento (MER)** e seu diagrama visual.
*   O **Modelo Relacional (MR)** correspondente.
*   **Scripts SQL DDL** (Data Definition Language) para criação das tabelas, com todas as restrições.
*   **Scripts SQL DML** (Data Manipulation Language) para popular o banco de dados com dados fictícios.
*   **Scripts SQL DQL** (Data Query Language) com consultas complexas para testar o modelo.

Os scripts DDL e DML são fornecidos tanto no **padrão ANSI SQL** quanto adaptados para **Supabase (PostgreSQL)**, destacando as diferenças e vantagens de cada abordagem.


## Vídeo de demonstração - Projeto de Banco de Dados - Conceitos inicias e básicos

[![Assista ao vídeo no YouTube](https://img.youtube.com/vi/8Z44fiQOOnE/maxresdefault.jpg)](https://www.youtube.com/watch?v=8Z44fiQOOnE)


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

2.  **Domine a Normalização**: A normalização é a chave para projetar bancos de dados eficientes e sem redundâncias. Comece pela 1FN, 2FN e 3FN, depois aprofunde em BCNF, 4FN e 5FN para compreender casos mais sofisticados de dependências funcionais, multivaloradas e de junção. Entenda o que são dependências funcionais e como eliminá-las para evitar anomalias de inserção, atualização e exclusão. A 3FN é um bom objetivo para a maioria dos projetos, enquanto BCNF, 4FN e 5FN ajudam a refinar cenários mais complexos.

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


## Guia Complementar de Normalização: da 1FN à 5FN

Esta seção complementa o repositório com uma visão mais profunda das formas normais clássicas, incluindo a **Forma Normal de Boyce-Codd (BCNF)**, a **Quarta Forma Normal (4FN)** e a **Quinta Forma Normal (5FN)**. A ideia central da normalização é reduzir redundâncias, evitar anomalias de inserção, atualização e exclusão, e produzir um modelo relacional mais consistente, estável e fácil de manter.

## Vídeo de demonstração - Normalização em Banco de Dados

[![Assista ao vídeo no YouTube](https://img.youtube.com/vi/O5VsMpvySnU/maxresdefault.jpg)](https://www.youtube.com/watch?v=O5VsMpvySnU)

### Visão Geral

| Forma Normal | Objetivo principal | Problema que combate |
| :-- | :-- | :-- |
| **1FN** | Garantir atomicidade dos atributos | Campos multivalorados, listas e grupos repetitivos |
| **2FN** | Eliminar dependências parciais da chave | Redundância em tabelas com chave composta |
| **3FN** | Eliminar dependências transitivas | Atributos não-chave dependentes de outros não-chave |
| **BCNF** | Reforçar a 3FN exigindo determinantes mais fortes | Dependências funcionais onde o determinante não é superchave |
| **4FN** | Eliminar dependências multivaloradas independentes | Combinações artificiais entre conjuntos independentes |
| **5FN** | Eliminar dependências de junção complexas | Relações que só ficam corretas quando decompostas em mais de duas projeções |

### 1. Primeira Forma Normal (1FN)

A **Primeira Forma Normal (1FN)** exige que cada atributo da tabela contenha **valores atômicos**, ou seja, um único valor por célula, sem listas, grupos repetitivos ou colunas que armazenem múltiplos itens em um mesmo campo.

#### Quando uma tabela viola a 1FN?
- quando um atributo guarda vários telefones em uma única coluna;
- quando um campo armazena uma lista de produtos, e-mails ou códigos separados por vírgula;
- quando existem colunas repetidas do tipo `telefone1`, `telefone2`, `telefone3`.

#### Exemplo 1 — Telefones de aluno

**Tabela não normalizada**
```text
ALUNO(id_aluno, nome, telefones)
(1, 'Ana', '1199999-1111, 1198888-2222')
```

Problema: a coluna `telefones` armazena múltiplos valores em uma única célula.

**Solução em 1FN**
```text
ALUNO(id_aluno, nome)
(1, 'Ana')

ALUNO_TELEFONE(id_aluno, telefone)
(1, '1199999-1111')
(1, '1198888-2222')
```

#### Exemplo 2 — Itens de pedido em lista

**Tabela não normalizada**
```text
PEDIDO(id_pedido, cliente, itens)
(10, 'Carlos', 'Arroz; Feijão; Macarrão')
```

Problema: a coluna `itens` mistura vários produtos em um único campo.

**Solução em 1FN**
```text
PEDIDO(id_pedido, cliente)
(10, 'Carlos')

ITEM_PEDIDO(id_pedido, item)
(10, 'Arroz')
(10, 'Feijão')
(10, 'Macarrão')
```

**Resumo da 1FN:** todo atributo deve representar um único fato indivisível dentro do contexto da aplicação.

### 2. Segunda Forma Normal (2FN)

A **Segunda Forma Normal (2FN)** exige que a relação já esteja em 1FN e que **todo atributo não-chave dependa da chave primária inteira**, e não apenas de parte dela. Esse problema aparece principalmente em tabelas com **chave composta**.

#### Quando uma tabela viola a 2FN?
- quando a chave primária possui mais de um atributo;
- quando algum atributo não-chave depende apenas de um pedaço da chave composta;
- quando há repetição desnecessária de dados descritivos.

#### Exemplo 1 — Matrícula em disciplina

Considere a relação:
```text
MATRICULA(id_aluno, id_disciplina, nome_aluno, nome_disciplina, nota)
PK = (id_aluno, id_disciplina)
```

Dependências:
- `id_aluno -> nome_aluno`
- `id_disciplina -> nome_disciplina`
- `(id_aluno, id_disciplina) -> nota`

Problema: `nome_aluno` depende só de `id_aluno`, e `nome_disciplina` depende só de `id_disciplina`.

**Decomposição para 2FN**
```text
ALUNO(id_aluno, nome_aluno)
DISCIPLINA(id_disciplina, nome_disciplina)
MATRICULA(id_aluno, id_disciplina, nota)
```

#### Exemplo 2 — Itens de pedido com chave composta

Considere:
```text
ITEM_PEDIDO(id_pedido, id_produto, data_pedido, nome_produto, quantidade)
PK = (id_pedido, id_produto)
```

Dependências:
- `id_pedido -> data_pedido`
- `id_produto -> nome_produto`
- `(id_pedido, id_produto) -> quantidade`

Problema: `data_pedido` depende só de `id_pedido`, e `nome_produto` depende só de `id_produto`.

**Decomposição para 2FN**
```text
PEDIDO(id_pedido, data_pedido)
PRODUTO(id_produto, nome_produto)
ITEM_PEDIDO(id_pedido, id_produto, quantidade)
```

**Resumo da 2FN:** atributos descritivos devem ser colocados nas entidades às quais realmente pertencem.

### 3. Terceira Forma Normal (3FN)

A **Terceira Forma Normal (3FN)** exige que a relação já esteja em 2FN e que **não existam dependências transitivas** entre atributos não-chave. Em outras palavras, um atributo não-chave não deve depender de outro atributo não-chave.

#### Quando uma tabela viola a 3FN?
- quando um atributo não-chave determina outro atributo não-chave;
- quando informações de uma entidade secundária são repetidas em outra tabela;
- quando alterações em um único fato exigem atualização de várias linhas.

#### Exemplo 1 — Funcionário e departamento

Considere:
```text
FUNCIONARIO(id_funcionario, nome_funcionario, id_departamento, nome_departamento)
PK = id_funcionario
```

Dependências:
- `id_funcionario -> nome_funcionario, id_departamento`
- `id_departamento -> nome_departamento`

Problema: `nome_departamento` depende transitivamente de `id_funcionario` por meio de `id_departamento`.

**Decomposição para 3FN**
```text
DEPARTAMENTO(id_departamento, nome_departamento)
FUNCIONARIO(id_funcionario, nome_funcionario, id_departamento)
```

#### Exemplo 2 — Livro e editora

Considere:
```text
LIVRO(id_livro, titulo, id_editora, nome_editora)
PK = id_livro
```

Dependências:
- `id_livro -> titulo, id_editora`
- `id_editora -> nome_editora`

Problema: `nome_editora` não depende diretamente da chave da tabela `LIVRO`, mas de `id_editora`.

**Decomposição para 3FN**
```text
EDITORA(id_editora, nome_editora)
LIVRO(id_livro, titulo, id_editora)
```

**Resumo da 3FN:** cada fato deve ser armazenado uma única vez, na tabela cuja chave o determina diretamente.

### 4. Forma Normal de Boyce-Codd (BCNF)

A **BCNF (Boyce-Codd Normal Form)** é uma versão mais forte da 3FN. Ela exige que, para toda dependência funcional não trivial `X -> Y`, o determinante `X` seja uma **superchave**.

Em termos práticos: a BCNF resolve alguns casos em que a tabela está em 3FN, mas ainda mantém redundâncias porque existe um determinante que não é superchave.

#### Quando uma tabela pode estar em 3FN e ainda violar BCNF?
- quando um atributo primo aparece do lado direito de uma dependência funcional;
- quando a 3FN aceita a relação, mas ainda existem redundâncias estruturais;
- quando diferentes chaves candidatas compartilham atributos e surgem determinantes não plenos.

#### Exemplo 1 — Projeto, consultor e função

Considere:
```text
ALOCACAO(projeto, consultor, funcao)
```

Premissas:
- cada `consultor` exerce uma única `funcao`;
- um projeto pode ter vários consultores;
- uma função pode aparecer em vários projetos.

Dependências:
- `(projeto, consultor) -> funcao`
- `consultor -> funcao`

Supondo que `(projeto, consultor)` seja chave candidata, a dependência `consultor -> funcao` viola a BCNF porque `consultor` não é superchave.

**Decomposição para BCNF**
```text
CONSULTOR(consultor, funcao)
ALOCACAO_PROJETO(projeto, consultor)
```

#### Exemplo 2 — Turma, professor e disciplina

Considere:
```text
OFERTA(turma, professor, disciplina)
```

Premissas:
- cada `professor` ministra uma única `disciplina` naquela base;
- uma `turma` pode ter aulas com diferentes professores;
- a combinação `(turma, professor)` identifica a disciplina ofertada.

Dependências:
- `(turma, professor) -> disciplina`
- `professor -> disciplina`

Problema: `professor` determina `disciplina`, mas `professor` não é superchave na relação.

**Decomposição para BCNF**
```text
PROFESSOR(professor, disciplina)
TURMA_PROFESSOR(turma, professor)
```

**Resumo da BCNF:** toda fonte de determinação funcional relevante deve ser uma superchave.

### 5. Quarta Forma Normal (4FN)

A **Quarta Forma Normal (4FN)** exige que a relação esteja em BCNF e que **não existam dependências multivaloradas não triviais**. Isso acontece quando uma entidade possui dois ou mais conjuntos de valores independentes entre si, mas todos foram colocados na mesma tabela.

#### Sinal típico de violação da 4FN
- um aluno possui vários hobbies e vários idiomas, mas hobby e idioma são independentes;
- um produto possui vários fornecedores e várias cores, mas fornecedor e cor não dependem um do outro;
- a tabela gera combinações artificiais que não representam fatos reais.

#### Exemplo 1 — Aluno, hobby e idioma

Considere:
```text
ALUNO_INTERESSE(id_aluno, hobby, idioma)
```

Suponha que:
- um aluno tenha vários hobbies;
- um aluno tenha vários idiomas;
- hobbies e idiomas são independentes.

Se Ana gosta de `Xadrez` e `Pintura`, e fala `Português` e `Inglês`, a tabela gera:

```text
(1, 'Xadrez', 'Português')
(1, 'Xadrez', 'Inglês')
(1, 'Pintura', 'Português')
(1, 'Pintura', 'Inglês')
```

Problema: a relação mistura dois conjuntos independentes, criando um produto cartesiano.

**Decomposição para 4FN**
```text
ALUNO_HOBBY(id_aluno, hobby)
ALUNO_IDIOMA(id_aluno, idioma)
```

#### Exemplo 2 — Produto, fornecedor e cor

Considere:
```text
PRODUTO_FORNECEDOR_COR(id_produto, fornecedor, cor)
```

Suponha que:
- um produto tenha vários fornecedores homologados;
- um produto exista em várias cores;
- fornecedores e cores são independentes.

Problema: cada fornecedor será combinado com cada cor, mesmo sem existir um fato específico ligando ambos.

**Decomposição para 4FN**
```text
PRODUTO_FORNECEDOR(id_produto, fornecedor)
PRODUTO_COR(id_produto, cor)
```

**Resumo da 4FN:** fatos multivalorados independentes devem ser modelados em relações separadas.

### 6. Quinta Forma Normal (5FN)

A **Quinta Forma Normal (5FN)**, também chamada de **Forma Normal de Projeção-Junção (PJ/NF)**, trata casos em que uma relação só pode ser corretamente reconstruída a partir da decomposição em **três ou mais relações**, sem perda de informação e sem gerar tuplas espúrias.

A 5FN é menos comum em projetos introdutórios, mas é importante em cenários com regras de negócio muito refinadas, especialmente em contratos, logística, manufatura e autorizações complexas.

#### Quando pensar em 5FN?
- quando a relação representa uma associação ternária ou n-ária complexa;
- quando decompor em apenas duas tabelas não é suficiente;
- quando a combinação correta depende de múltiplas projeções simultâneas.

#### Exemplo 1 — Fornecedor, peça e projeto

Considere a relação:
```text
FORNECIMENTO(fornecedor, peca, projeto)
```

Suponha que uma linha só deva existir quando:
- o fornecedor está habilitado para fornecer a peça;
- o fornecedor está autorizado a atuar no projeto;
- a peça é utilizada no projeto.

Nessa situação, a relação pode ser decomposta em:
```text
FORNECEDOR_PECA(fornecedor, peca)
FORNECEDOR_PROJETO(fornecedor, projeto)
PECA_PROJETO(peca, projeto)
```

Se a regra de negócio garantir que a junção dessas três projeções reconstrói exatamente `FORNECIMENTO`, então a decomposição está em 5FN.

#### Exemplo 2 — Médico, procedimento e hospital

Considere:
```text
ATENDIMENTO(medico, procedimento, hospital)
```

Suponha que um atendimento seja válido apenas quando:
- o médico está credenciado no hospital;
- o médico está habilitado para o procedimento;
- o hospital realiza aquele procedimento.

Podemos decompor em:
```text
MEDICO_HOSPITAL(medico, hospital)
MEDICO_PROCEDIMENTO(medico, procedimento)
HOSPITAL_PROCEDIMENTO(hospital, procedimento)
```

Se toda tupla válida em `ATENDIMENTO` puder ser obtida exatamente pela junção dessas três relações, sem gerar combinações indevidas, então temos um caso típico de 5FN.

**Resumo da 5FN:** a decomposição deve preservar a semântica completa de relações complexas de muitos para muitos para muitos, evitando tuplas espúrias após junções.

### Comparação rápida entre 3FN, BCNF, 4FN e 5FN

| Forma | Foco principal | Exemplo típico de problema |
| :-- | :-- | :-- |
| **3FN** | Dependência transitiva | `id_departamento -> nome_departamento` dentro de `FUNCIONARIO` |
| **BCNF** | Determinante que não é superchave | `professor -> disciplina` dentro de `OFERTA` |
| **4FN** | Dependência multivalorada | hobbies e idiomas independentes na mesma tabela |
| **5FN** | Dependência de junção | relação ternária que precisa de três projeções para ficar correta |

### Dicas práticas para estudo e projeto

1. **Sempre comece pelo entendimento do domínio.** A normalização não é uma receita mecânica; ela depende da semântica dos dados e das regras de negócio.
2. **Liste as dependências funcionais.** Muitas falhas de modelagem surgem porque a equipe cria tabelas antes de entender quem determina quem.
3. **Use 3FN como meta base.** Em grande parte dos sistemas transacionais, chegar com qualidade à 3FN já resolve a maior parte dos problemas.
4. **Aplique BCNF, 4FN e 5FN quando o domínio justificar.** Esses níveis são especialmente úteis em modelos acadêmicos, ambientes complexos e cenários com muitas combinações.
5. **Avalie performance separadamente.** Em alguns casos reais, pode existir desnormalização controlada por razões de desempenho, mas isso deve ser consciente e documentado.

### Conclusão

Dominar da **1FN à 5FN** significa compreender diferentes tipos de redundância e saber tratá-los de forma estruturada. Em disciplinas de Banco de Dados Relacional, isso ajuda não apenas a resolver exercícios, mas também a justificar decisões de projeto, elaborar modelos mais elegantes e escrever SQL com maior coerência conceitual.


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
