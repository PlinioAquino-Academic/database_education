# Solução da Prova de Banco de Dados - Cenário iFood-like: Gestão de Pedidos e Pagamentos

Esta solução apresenta um projeto de banco de dados para um sistema de delivery de comida, inspirado no iFood, com foco na gestão de pedidos e pagamentos. O projeto foi desenvolvido seguindo a **Terceira Forma Normal (3FN)** e incorpora o conceito de **disjunção (especialização/generalização)** para os diferentes métodos de pagamento. Todos os scripts são otimizados para **Supabase (PostgreSQL)**, com comentários detalhados sobre as restrições e escolhas de design.

---

## 1. Enunciado do Problema: Sistema de Delivery de Comida

Um sistema de delivery de comida, similar ao iFood, precisa de um banco de dados robusto para gerenciar informações sobre restaurantes, clientes, produtos, pedidos e, especialmente, os diversos métodos de pagamento. O sistema deve ser projetado na **Terceira Forma Normal (3FN)** e incorporar o conceito de **disjunção (especialização/generalização)** para os pagamentos. As regras de negócio são as seguintes:

*   **Restaurantes:**
    *   Cada restaurante possui um `ID` único, `nome` (único), `cnpj` (único), `endereco`, `telefone` e `categoria` (ex: Pizzaria, Japonesa, Brasileira).
    *   Deve-se registrar a `data_cadastro` do restaurante no sistema.
    *   O `status` do restaurante (Ativo, Inativo, Em Manutenção) deve ser controlado.

*   **Clientes:**
    *   Cada cliente possui um `ID` único, `nome_completo`, `email` (único), `telefone`, `endereco_principal` e `data_cadastro`.
    *   O `email` deve ser um formato válido.

*   **Produtos:**
    *   Cada produto pertence a **um único restaurante** e possui um `ID` único, `nome_produto` (único por restaurante), `descricao`, `preco` (deve ser positivo) e `disponivel` (booleano).
    *   O `preco` deve ser maior que zero.

*   **Pedidos:**
    *   Cada pedido possui um `ID` único, `data_hora_pedido`, `status` (ex: Pendente, Em Preparo, A Caminho, Entregue, Cancelado), `valor_total` (calculado), `observacoes`.
    *   Um pedido é feito por **um único cliente** e pertence a **um único restaurante**.
    *   A `data_hora_pedido` deve ser registrada automaticamente.

*   **Itens do Pedido:**
    *   Cada pedido é composto por vários `itens`.
    *   Um item de pedido possui um `ID` único (dentro do pedido), `quantidade` (deve ser positiva) e `preco_unitario` (do produto no momento do pedido).
    *   Cada item de pedido está associado a **um produto** e a **um pedido**.

*   **Pagamentos (Disjunção - Especialização/Generalização):**
    *   Um pedido pode ter **um único pagamento** associado.
    *   Existe uma entidade genérica `Pagamento` com atributos comuns: `ID` único, `data_hora_pagamento`, `valor_pago` (deve ser positivo e igual ao `valor_total` do pedido), `status_pagamento` (ex: Aprovado, Recusado, Pendente).
    *   A partir de `Pagamento`, existem especializações (disjunção total e exclusiva):
        *   **PagamentoCartao**: Atributos adicionais: `numero_cartao_final` (apenas os 4 últimos dígitos), `bandeira` (ex: Visa, Mastercard), `tipo_cartao` (Crédito, Débito).
        *   **PagamentoPix**: Atributos adicionais: `chave_pix_origem`, `id_transacao_pix` (único).
        *   **PagamentoValeRefeicao**: Atributos adicionais: `empresa_vale` (ex: Sodexo, Alelo), `numero_cartao_vale_final`.
    *   O `valor_pago` deve ser maior que zero.

---

## 2. Modelo Entidade-Relacionamento (MER)

O diagrama ER abaixo representa as entidades, seus atributos e os relacionamentos para o sistema de delivery de comida, com destaque para a disjunção de pagamentos.

![Diagrama ER iFood-like](mer_ifood_like.png)

### Descrição das Entidades e Relacionamentos:

*   **Restaurante**: Entidade principal para os estabelecimentos que oferecem produtos.
*   **Cliente**: Entidade para os usuários que realizam pedidos.
*   **Produto**: Entidade para os itens vendidos pelos restaurantes.
*   **Pedido**: Entidade que registra as solicitações dos clientes a um restaurante.
*   **ItemPedido**: Entidade associativa que detalha quais produtos e em que quantidade fazem parte de um pedido.
*   **Pagamento**: Entidade genérica que representa a transação financeira de um pedido.
*   **PagamentoCartao**: Especialização de `Pagamento` para transações via cartão.
*   **PagamentoPix**: Especialização de `Pagamento` para transações via PIX.
*   **PagamentoValeRefeicao**: Especialização de `Pagamento` para transações via vale-refeição.

---

## 3. Modelo Relacional (MR) na 3ª Forma Normal (3FN)

O Modelo Relacional a seguir detalha a estrutura das tabelas, suas chaves primárias (PK), chaves estrangeiras (FK) e restrições UNIQUE, garantindo a conformidade com a Terceira Forma Normal (3FN). A 3FN assegura que todos os atributos não-chave dependem apenas da chave primária e não de outros atributos não-chave, eliminando dependências transitivas.

*   **Restaurante** (`id_restaurante` PK, `nome` UNIQUE, `cnpj` UNIQUE, `endereco`, `telefone`, `categoria`, `data_cadastro`, `status`)
    *   *Justificativa 3FN*: Todos os atributos descrevem diretamente o restaurante e dependem apenas de `id_restaurante`.

*   **Cliente** (`id_cliente` PK, `nome_completo`, `email` UNIQUE, `telefone`, `endereco_principal`, `data_cadastro`)
    *   *Justificativa 3FN*: Todos os atributos descrevem diretamente o cliente e dependem apenas de `id_cliente`.

*   **Produto** (`id_produto` PK, `nome_produto`, `descricao`, `preco`, `disponivel`, `id_restaurante` FK)
    *   *Justificativa 3FN*: `nome_produto` é único apenas dentro do contexto de um `id_restaurante`. `preco` e `disponivel` dependem diretamente do `id_produto`. `id_restaurante` é uma FK para a tabela `Restaurante`.

*   **Pedido** (`id_pedido` PK, `data_hora_pedido`, `status`, `valor_total`, `observacoes`, `id_cliente` FK, `id_restaurante` FK)
    *   *Justificativa 3FN*: `valor_total` é calculado e `status` descreve o pedido. `id_cliente` e `id_restaurante` são FKs para as respectivas tabelas.

*   **ItemPedido** (`id_item_pedido` PK, `quantidade`, `preco_unitario`, `id_pedido` FK, `id_produto` FK)
    *   *Justificativa 3FN*: `quantidade` e `preco_unitario` (do produto no momento do pedido) dependem diretamente do `id_item_pedido`. `id_pedido` e `id_produto` são FKs.

*   **Pagamento** (`id_pagamento` PK, `data_hora_pagamento`, `valor_pago`, `status_pagamento`, `id_pedido` FK UNIQUE)
    *   *Justificativa 3FN*: `id_pedido` é UNIQUE porque um pedido tem apenas um pagamento. `valor_pago`, `data_hora_pagamento` e `status_pagamento` dependem diretamente de `id_pagamento`.

*   **PagamentoCartao** (`id_pagamento` PK FK, `numero_cartao_final`, `bandeira`, `tipo_cartao`)
    *   *Justificativa 3FN*: `id_pagamento` é PK e FK, e os atributos adicionais descrevem o pagamento por cartão.

*   **PagamentoPix** (`id_pagamento` PK FK, `chave_pix_origem`, `id_transacao_pix` UNIQUE)
    *   *Justificativa 3FN*: `id_pagamento` é PK e FK, e os atributos adicionais descrevem o pagamento por PIX. `id_transacao_pix` é UNIQUE.

*   **PagamentoValeRefeicao** (`id_pagamento` PK FK, `empresa_vale`, `numero_cartao_vale_final`)
    *   *Justificativa 3FN*: `id_pagamento` é PK e FK, e os atributos adicionais descrevem o pagamento por vale-refeição.

---

## 4. Scripts SQL DDL (Criação) para Supabase (PostgreSQL)

Este script cria as tabelas para o sistema de delivery de comida, aplicando o conceito de disjunção para pagamentos e garantindo a Terceira Forma Normal (3FN). Inclui Chaves Primárias (PKs) com UUIDs, Restrições UNIQUE, Chaves Estrangeiras (FKs) com ações de deleção, e Restrições CHECK para validação de dados.

```sql
-- Habilita a extensão pgcrypto para a função gen_random_uuid() se ainda não estiver habilitada.
-- No Supabase, esta extensão geralmente já está disponível.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Criação do Schema para organizar as tabelas do sistema iFood-like.
-- É uma boa prática para evitar conflitos de nomes e organizar o banco de dados.
CREATE SCHEMA IF NOT EXISTS ifood_like;

------------------------------------------------------------------------
-- Tabelas Principais
------------------------------------------------------------------------

-- Tabela Restaurante
-- Armazena informações sobre os restaurantes parceiros.
CREATE TABLE ifood_like.Restaurante (
    id_restaurante UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do restaurante, gerado automaticamente como UUID.
    nome TEXT UNIQUE NOT NULL,                                  -- UNIQUE: Nome do restaurante deve ser único. NOT NULL: Campo obrigatório.
    cnpj TEXT UNIQUE NOT NULL,                                  -- UNIQUE: CNPJ do restaurante deve ser único. NOT NULL: Campo obrigatório.
    endereco TEXT NOT NULL,                                     -- NOT NULL: Endereço é obrigatório.
    telefone TEXT,                                              -- Telefone é opcional.
    categoria TEXT NOT NULL,                                    -- NOT NULL: Categoria (ex: Pizzaria, Japonesa) é obrigatória.
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,           -- DEFAULT: Data de cadastro preenchida automaticamente com a data atual.
    status TEXT NOT NULL CHECK (status IN (
        'Ativo',
        'Inativo',
        'Em Manutenção'
    )),                                                         -- CHECK: Garante que o status seja um dos valores permitidos.
    created_at TIMESTAMPTZ DEFAULT now()                        -- Auditoria: Data e hora de criação do registro, com fuso horário.
);

-- Tabela Cliente
-- Armazena informações sobre os usuários do aplicativo.
CREATE TABLE ifood_like.Cliente (
    id_cliente UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do cliente, gerado automaticamente como UUID.
    nome_completo TEXT NOT NULL,                            -- NOT NULL: Nome completo é obrigatório.
    email TEXT UNIQUE NOT NULL CHECK (email ~* '^.+@.+\..+$'), -- UNIQUE: Email deve ser único. NOT NULL: Obrigatório. CHECK: Valida formato básico de email.
    telefone TEXT,                                          -- Telefone é opcional.
    endereco_principal TEXT NOT NULL,                       -- NOT NULL: Endereço principal é obrigatório.
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,       -- DEFAULT: Data de cadastro preenchida automaticamente.
    created_at TIMESTAMPTZ DEFAULT now()                    -- Auditoria: Data e hora de criação do registro.
);

-- Tabela Produto
-- Armazena os itens do cardápio oferecidos pelos restaurantes.
CREATE TABLE ifood_like.Produto (
    id_produto UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do produto, gerado automaticamente como UUID.
    nome_produto TEXT NOT NULL,                             -- NOT NULL: Nome do produto é obrigatório.
    descricao TEXT,                                         -- Descrição é opcional.
    preco NUMERIC(10, 2) NOT NULL CHECK (preco > 0),        -- NOT NULL: Preço é obrigatório. CHECK: Preço deve ser positivo.
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,               -- DEFAULT: Produto disponível por padrão. NOT NULL: Obrigatório.
    id_restaurante UUID NOT NULL,                           -- FK: Chave estrangeira para a tabela Restaurante.
    created_at TIMESTAMPTZ DEFAULT now(),                   -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_restaurante
        FOREIGN KEY (id_restaurante)
        REFERENCES ifood_like.Restaurante(id_restaurante) ON DELETE CASCADE, -- ON DELETE CASCADE: Se o restaurante for excluído, seus produtos também serão.
    CONSTRAINT uq_produto_restaurante UNIQUE (id_restaurante, nome_produto) -- UNIQUE: Nome do produto deve ser único APENAS dentro do mesmo restaurante.
);

-- Tabela Pedido
-- Registra os pedidos feitos pelos clientes.
CREATE TABLE ifood_like.Pedido (
    id_pedido UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do pedido, gerado automaticamente como UUID.
    data_hora_pedido TIMESTAMPTZ NOT NULL DEFAULT now(),  -- DEFAULT: Data e hora do pedido preenchida automaticamente.
    status TEXT NOT NULL CHECK (status IN (
        'Pendente',
        'Em Preparo',
        'A Caminho',
        'Entregue',
        'Cancelado'
    )),                                                    -- CHECK: Garante que o status seja um dos valores permitidos.
    valor_total NUMERIC(10, 2) NOT NULL CHECK (valor_total >= 0), -- NOT NULL: Valor total é obrigatório. CHECK: Valor não pode ser negativo.
    observacoes TEXT,                                       -- Observações do cliente são opcionais.
    id_cliente UUID NOT NULL,                               -- FK: Chave estrangeira para a tabela Cliente.
    id_restaurante UUID NOT NULL,                           -- FK: Chave estrangeira para a tabela Restaurante.
    created_at TIMESTAMPTZ DEFAULT now(),                   -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES ifood_like.Cliente(id_cliente) ON DELETE RESTRICT, -- ON DELETE RESTRICT: Não permite excluir cliente se houver pedidos associados.
    CONSTRAINT fk_restaurante_pedido
        FOREIGN KEY (id_restaurante)
        REFERENCES ifood_like.Restaurante(id_restaurante) ON DELETE RESTRICT -- ON DELETE RESTRICT: Não permite excluir restaurante se houver pedidos associados.
);

-- Tabela ItemPedido
-- Detalha os produtos incluídos em cada pedido.
CREATE TABLE ifood_like.ItemPedido (
    id_item_pedido UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do item do pedido, gerado automaticamente como UUID.
    quantidade INT NOT NULL CHECK (quantidade > 0),             -- NOT NULL: Quantidade é obrigatória. CHECK: Quantidade deve ser positiva.
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario >= 0), -- NOT NULL: Preço unitário é obrigatório. CHECK: Preço não pode ser negativo.
    id_pedido UUID NOT NULL,                                    -- FK: Chave estrangeira para a tabela Pedido.
    id_produto UUID NOT NULL,                                   -- FK: Chave estrangeira para a tabela Produto.
    created_at TIMESTAMPTZ DEFAULT now(),                       -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_pedido_item
        FOREIGN KEY (id_pedido)
        REFERENCES ifood_like.Pedido(id_pedido) ON DELETE CASCADE, -- ON DELETE CASCADE: Se o pedido for excluído, seus itens também serão.
    CONSTRAINT fk_produto_item
        FOREIGN KEY (id_produto)
        REFERENCES ifood_like.Produto(id_produto) ON DELETE RESTRICT -- ON DELETE RESTRICT: Não permite excluir produto se houver itens de pedido associados.
);

------------------------------------------------------------------------
-- Tabelas de Pagamento (Generalização/Especialização - Disjunção)
------------------------------------------------------------------------

-- Tabela Pagamento (Generalização)
-- Entidade base para todos os tipos de pagamento. Um pedido tem um único pagamento.
CREATE TABLE ifood_like.Pagamento (
    id_pagamento UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do pagamento, gerado automaticamente como UUID.
    data_hora_pagamento TIMESTAMPTZ NOT NULL DEFAULT now(), -- DEFAULT: Data e hora do pagamento preenchida automaticamente.
    valor_pago NUMERIC(10, 2) NOT NULL CHECK (valor_pago > 0), -- NOT NULL: Valor pago é obrigatório. CHECK: Valor deve ser positivo.
    status_pagamento TEXT NOT NULL CHECK (status_pagamento IN (
        'Aprovado',
        'Recusado',
        'Pendente',
        'Estornado'
    )),                                                      -- CHECK: Garante que o status seja um dos valores permitidos.
    id_pedido UUID UNIQUE NOT NULL,                          -- UNIQUE: Um pedido tem apenas um pagamento. NOT NULL: Obrigatório.
    created_at TIMESTAMPTZ DEFAULT now(),                    -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_pedido_pagamento
        FOREIGN KEY (id_pedido)
        REFERENCES ifood_like.Pedido(id_pedido) ON DELETE CASCADE -- ON DELETE CASCADE: Se o pedido for excluído, seu pagamento também será.
);

-- Tabela PagamentoCartao (Especialização)
-- Detalhes para pagamentos realizados com cartão de crédito/débito.
CREATE TABLE ifood_like.PagamentoCartao (
    id_pagamento UUID PRIMARY KEY,                                  -- PK/FK: Chave primária e estrangeira para a tabela Pagamento.
    numero_cartao_final TEXT NOT NULL CHECK (LENGTH(numero_cartao_final) = 4), -- NOT NULL: Obrigatório. CHECK: Apenas os 4 últimos dígitos.
    bandeira TEXT NOT NULL,                                         -- NOT NULL: Bandeira do cartão (Visa, Master, etc.) é obrigatória.
    tipo_cartao TEXT NOT NULL CHECK (tipo_cartao IN ('Credito', 'Debito')), -- CHECK: Tipo de cartão deve ser 'Credito' ou 'Debito'.
    created_at TIMESTAMPTZ DEFAULT now(),                           -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_pagamento_cartao
        FOREIGN KEY (id_pagamento)
        REFERENCES ifood_like.Pagamento(id_pagamento) ON DELETE CASCADE -- ON DELETE CASCADE: Se o pagamento base for excluído, o detalhe do cartão também será.
);

-- Tabela PagamentoPix (Especialização)
-- Detalhes para pagamentos realizados via PIX.
CREATE TABLE ifood_like.PagamentoPix (
    id_pagamento UUID PRIMARY KEY,                                  -- PK/FK: Chave primária e estrangeira para a tabela Pagamento.
    chave_pix_origem TEXT,                                          -- Chave PIX do pagador (opcional).
    id_transacao_pix TEXT UNIQUE NOT NULL,                          -- UNIQUE: ID da transação PIX deve ser único. NOT NULL: Obrigatório.
    created_at TIMESTAMPTZ DEFAULT now(),                           -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_pagamento_pix
        FOREIGN KEY (id_pagamento)
        REFERENCES ifood_like.Pagamento(id_pagamento) ON DELETE CASCADE -- ON DELETE CASCADE: Se o pagamento base for excluído, o detalhe do PIX também será.
);

-- Tabela PagamentoValeRefeicao (Especialização)
-- Detalhes para pagamentos realizados com vale-refeição.
CREATE TABLE ifood_like.PagamentoValeRefeicao (
    id_pagamento UUID PRIMARY KEY,                                  -- PK/FK: Chave primária e estrangeira para a tabela Pagamento.
    empresa_vale TEXT NOT NULL,                                     -- NOT NULL: Empresa do vale (Sodexo, Alelo, etc.) é obrigatória.
    numero_cartao_vale_final TEXT NOT NULL CHECK (LENGTH(numero_cartao_vale_final) = 4), -- NOT NULL: Obrigatório. CHECK: Apenas os 4 últimos dígitos.
    created_at TIMESTAMPTZ DEFAULT now(),                           -- Auditoria: Data e hora de criação do registro.
    CONSTRAINT fk_pagamento_vale
        FOREIGN KEY (id_pagamento)
        REFERENCES ifood_like.Pagamento(id_pagamento) ON DELETE CASCADE -- ON DELETE CASCADE: Se o pagamento base for excluído, o detalhe do vale também será.
);

------------------------------------------------------------------------
-- Configurações de Row Level Security (RLS) para Supabase (Exemplos)
------------------------------------------------------------------------

-- RLS é uma funcionalidade poderosa do PostgreSQL/Supabase para controle de acesso a nível de linha.
-- Abaixo, exemplos de como habilitar RLS e criar políticas básicas.

-- Habilitar RLS na tabela Cliente
ALTER TABLE ifood_like.Cliente ENABLE ROW LEVEL SECURITY;

-- Política para permitir que clientes vejam apenas seus próprios dados.
-- auth.uid() é uma função do Supabase que retorna o ID do usuário autenticado.
CREATE POLICY "Clientes podem ver seus próprios dados" ON ifood_like.Cliente
FOR SELECT
USING (id_cliente = auth.uid());

-- Habilitar RLS na tabela Pedido
ALTER TABLE ifood_like.Pedido ENABLE ROW LEVEL SECURITY;

-- Política para permitir que clientes vejam apenas seus próprios pedidos.
CREATE POLICY "Clientes podem ver seus próprios pedidos" ON ifood_like.Pedido
FOR SELECT
USING (id_cliente = auth.uid());

-- Política para permitir que restaurantes vejam apenas os pedidos feitos para eles.
-- (Assumindo que o auth.uid() do restaurante é o id_restaurante)
CREATE POLICY "Restaurantes podem ver seus próprios pedidos" ON ifood_like.Pedido
FOR SELECT
USING (id_restaurante = auth.uid());

-- Observação: A implementação completa de RLS requer um planejamento cuidadoso
-- e a definição de políticas para todas as operações (INSERT, UPDATE, DELETE) e tabelas relevantes.
-- Os exemplos acima são simplificados para demonstração.
```

---

## 5. Scripts SQL DML (População) para Supabase (PostgreSQL)

Este script insere dados fictícios em todas as tabelas do sistema iFood-like, respeitando as restrições de integridade e chaves estrangeiras. Ele inclui exemplos para os diferentes tipos de pagamento (Cartão, PIX, Vale-Refeição).

```sql
-- Certifique-se de que o schema 'ifood_like' e todas as tabelas já foram criados
-- usando o script DDL fornecido anteriormente.

------------------------------------------------------------------------
-- Inserção de Dados nas Tabelas Principais
------------------------------------------------------------------------

-- 1. Restaurante (5 tuplas)
INSERT INTO ifood_like.Restaurante (nome, cnpj, endereco, telefone, categoria, data_cadastro, status)
VALUES
    (
        'Pizzaria Sabor Divino',
        '00.000.000/0001-01',
        'Rua das Pizzas, 123, Centro, Cidade - SP',
        '(11) 1111-1111',
        'Pizzaria',
        '2023-01-01',
        'Ativo'
    ),
    (
        'Sushi Express',
        '00.000.000/0001-02',
        'Av. Japão, 456, Liberdade, Cidade - SP',
        '(11) 2222-2222',
        'Japonesa',
        '2023-01-05',
        'Ativo'
    ),
    (
        'Churrascaria Gaúcha',
        '00.000.000/0001-03',
        'Rodovia do Churrasco, 789, Zona Rural, Cidade - SP',
        '(11) 3333-3333',
        'Churrascaria',
        '2023-01-10',
        'Ativo'
    ),
    (
        'Hamburgueria Artesanal',
        '00.000.000/0001-04',
        'Rua dos Lanches, 101, Vila Nova, Cidade - SP',
        '(11) 4444-4444',
        'Lanches',
        '2023-01-15',
        'Ativo'
    ),
    (
        'Restaurante Vegano Verde',
        '00.000.000/0001-05',
        'Praça da Natureza, 202, Bairro Verde, Cidade - SP',
        '(11) 5555-5555',
        'Vegana',
        '2023-01-20',
        'Em Manutenção'
    );

-- 2. Cliente (5 tuplas)
INSERT INTO ifood_like.Cliente (nome_completo, email, telefone, endereco_principal, data_cadastro)
VALUES
    (
        'Ana Paula Silva',
        'ana.silva@email.com',
        '(11) 99999-8888',
        'Rua A, 10, Apto 101, Centro, Cidade - SP',
        '2023-02-01'
    ),
    (
        'Bruno Costa',
        'bruno.costa@email.com',
        '(11) 98888-7777',
        'Av. B, 20, Casa, Bairro Jardim, Cidade - SP',
        '2023-02-05'
    ),
    (
        'Carla Dias',
        'carla.dias@email.com',
        '(11) 97777-6666',
        'Rua C, 30, Bloco 3, Apto 303, Vila Nova, Cidade - SP',
        '2023-02-10'
    ),
    (
        'Daniel Rocha',
        'daniel.rocha@email.com',
        '(11) 96666-5555',
        'Travessa D, 40, Centro, Cidade - SP',
        '2023-02-15'
    ),
    (
        'Elisa Santos',
        'elisa.santos@email.com',
        '(11) 95555-4444',
        'Rua E, 50, Casa, Bairro Antigo, Cidade - SP',
        '2023-02-20'
    );

-- 3. Produto (5+ tuplas por restaurante, totalizando 25+)
-- Produtos para Pizzaria Sabor Divino
INSERT INTO ifood_like.Produto (nome_produto, descricao, preco, disponivel, id_restaurante)
VALUES
    (
        'Pizza Calabresa',
        'Molho de tomate, mussarela, calabresa e cebola.',
        45.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
    ),
    (
        'Pizza Margherita',
        'Molho de tomate, mussarela, manjericão e tomate.',
        40.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
    ),
    (
        'Pizza Frango com Catupiry',
        'Molho de tomate, mussarela, frango desfiado e catupiry.',
        50.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
    ),
    (
        'Refrigerante Lata',
        'Coca-Cola 350ml.',
        7.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
    ),
    (
        'Água Mineral',
        'Água sem gás 500ml.',
        5.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
    );

-- Produtos para Sushi Express
INSERT INTO ifood_like.Produto (nome_produto, descricao, preco, disponivel, id_restaurante)
VALUES
    (
        'Combinado Sushi 20 peças',
        'Seleção de sushis e sashimis variados.',
        80.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
    ),
    (
        'Temaki Salmão',
        'Cone de alga com arroz, salmão e cream cheese.',
        30.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
    ),
    (
        'Hot Roll',
        'Sushi empanado e frito.',
        25.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
    ),
    (
        'Guioza',
        'Pastel japonês de carne suína.',
        20.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
    ),
    (
        'Cerveja Japonesa',
        'Cerveja Asahi 330ml.',
        15.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
    );

-- Produtos para Churrascaria Gaúcha
INSERT INTO ifood_like.Produto (nome_produto, descricao, preco, disponivel, id_restaurante)
VALUES
    (
        'Picanha na Chapa',
        'Picanha fatiada, acompanha arroz, farofa e vinagrete.',
        90.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
    ),
    (
        'Costela no Bafo',
        'Costela bovina assada lentamente, acompanha mandioca frita.',
        75.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
    ),
    (
        'Salada Completa',
        'Mix de folhas, tomate, pepino, palmito e molho especial.',
        30.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
    ),
    (
        'Cerveja Long Neck',
        'Heineken 330ml.',
        12.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
    ),
    (
        'Pudim de Leite',
        'Sobremesa clássica.',
        18.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
    );

-- Produtos para Hamburgueria Artesanal
INSERT INTO ifood_like.Produto (nome_produto, descricao, preco, disponivel, id_restaurante)
VALUES
    (
        'Classic Burger',
        'Pão brioche, hambúrguer 180g, queijo cheddar, alface, tomate, cebola roxa, molho especial.',
        35.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
    ),
    (
        'Smash Burger',
        'Pão de forma, 2x hambúrguer smash 90g, queijo prato, picles, maionese da casa.',
        30.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
    ),
    (
        'Batata Frita',
        'Porção de batata frita com alecrim.',
        15.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
    ),
    (
        'Milkshake Chocolate',
        'Milkshake cremoso de chocolate.',
        20.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
    ),
    (
        'Onion Rings',
        'Porção de anéis de cebola empanados.',
        18.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
    );

-- Produtos para Restaurante Vegano Verde
INSERT INTO ifood_like.Produto (nome_produto, descricao, preco, disponivel, id_restaurante)
VALUES
    (
        'Salada de Grãos',
        'Mix de grãos, vegetais frescos e molho de mostarda e mel vegano.',
        38.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Restaurante Vegano Verde')
    ),
    (
        'Hamburguer de Grão de Bico',
        'Pão integral, hambúrguer de grão de bico, queijo vegano, alface, tomate.',
        42.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Restaurante Vegano Verde')
    ),
    (
        'Suco Verde',
        'Couve, maçã, gengibre e limão.',
        15.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Restaurante Vegano Verde')
    ),
    (
        'Torta de Limão Vegana',
        'Torta de limão com base de castanhas.',
        25.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Restaurante Vegano Verde')
    ),
    (
        'Wrap de Legumes',
        'Tortilla integral com recheio de legumes grelhados e homus.',
        30.00,
        TRUE,
        (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Restaurante Vegano Verde')
    );

------------------------------------------------------------------------
-- Inserção de Dados nas Tabelas de Pedidos e Pagamentos
------------------------------------------------------------------------

-- 4. Pedido (5 tuplas)
-- Pedido 1: Ana Paula Silva na Pizzaria Sabor Divino
WITH cliente_ana AS (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'ana.silva@email.com'),
     restaurante_pizza AS (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
INSERT INTO ifood_like.Pedido (data_hora_pedido, status, valor_total, observacoes, id_cliente, id_restaurante)
VALUES (
    '2024-03-10 19:00:00',
    'Entregue',
    52.00,
    'Sem cebola na pizza',
    (SELECT id_cliente FROM cliente_ana),
    (SELECT id_restaurante FROM restaurante_pizza)
) RETURNING id_pedido AS pedido_ana_pizza;

-- Pedido 2: Bruno Costa no Sushi Express
WITH cliente_bruno AS (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'bruno.costa@email.com'),
     restaurante_sushi AS (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')
INSERT INTO ifood_like.Pedido (data_hora_pedido, status, valor_total, observacoes, id_cliente, id_restaurante)
VALUES (
    '2024-03-11 20:30:00',
    'Em Preparo',
    110.00,
    'Mais wasabi, por favor',
    (SELECT id_cliente FROM cliente_bruno),
    (SELECT id_restaurante FROM restaurante_sushi)
) RETURNING id_pedido AS pedido_bruno_sushi;

-- Pedido 3: Carla Dias na Churrascaria Gaúcha
WITH cliente_carla AS (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'carla.dias@email.com'),
     restaurante_churrasco AS (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')
INSERT INTO ifood_like.Pedido (data_hora_pedido, status, valor_total, observacoes, id_cliente, id_restaurante)
VALUES (
    '2024-03-12 13:00:00',
    'Entregue',
    105.00,
    NULL,
    (SELECT id_cliente FROM cliente_carla),
    (SELECT id_restaurante FROM restaurante_churrasco)
) RETURNING id_pedido AS pedido_carla_churrasco;

-- Pedido 4: Daniel Rocha na Hamburgueria Artesanal
WITH cliente_daniel AS (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'daniel.rocha@email.com'),
     restaurante_burger AS (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')
INSERT INTO ifood_like.Pedido (data_hora_pedido, status, valor_total, observacoes, id_cliente, id_restaurante)
VALUES (
    '2024-03-13 21:00:00',
    'A Caminho',
    50.00,
    'Sem picles',
    (SELECT id_cliente FROM cliente_daniel),
    (SELECT id_restaurante FROM restaurante_burger)
) RETURNING id_pedido AS pedido_daniel_burger;

-- Pedido 5: Elisa Santos na Pizzaria Sabor Divino (repetindo restaurante para testar)
WITH cliente_elisa AS (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com'),
     restaurante_pizza AS (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')
INSERT INTO ifood_like.Pedido (data_hora_pedido, status, valor_total, observacoes, id_cliente, id_restaurante)
VALUES (
    '2024-03-14 19:30:00',
    'Pendente',
    45.00,
    NULL,
    (SELECT id_cliente FROM cliente_elisa),
    (SELECT id_restaurante FROM restaurante_pizza)
) RETURNING id_pedido AS pedido_elisa_pizza;

-- 5. ItemPedido (múltiplos por pedido)
-- Itens para Pedido 1 (Ana Paula Silva - Pizzaria Sabor Divino)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem cebola na pizza' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'ana.silva@email.com')),
     pizza_calabresa AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Pizza Calabresa' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')),
     refrigerante AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Refrigerante Lata' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino'))
INSERT INTO ifood_like.ItemPedido (quantidade, preco_unitario, id_pedido, id_produto)
VALUES
    (1, (SELECT preco FROM pizza_calabresa), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM pizza_calabresa)),
    (1, (SELECT preco FROM refrigerante), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM refrigerante));

-- Itens para Pedido 2 (Bruno Costa - Sushi Express)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Mais wasabi, por favor' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'bruno.costa@email.com')),
     combinado AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Combinado Sushi 20 peças' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express')),
     temaki AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Temaki Salmão' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Sushi Express'))
INSERT INTO ifood_like.ItemPedido (quantidade, preco_unitario, id_pedido, id_produto)
VALUES
    (1, (SELECT preco FROM combinado), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM combinado)),
    (1, (SELECT preco FROM temaki), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM temaki));

-- Itens para Pedido 3 (Carla Dias - Churrascaria Gaúcha)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'carla.dias@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')),
     picanha AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Picanha na Chapa' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')),
     salada AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Salada Completa' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha'))
INSERT INTO ifood_like.ItemPedido (quantidade, preco_unitario, id_pedido, id_produto)
VALUES
    (1, (SELECT preco FROM picanha), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM picanha)),
    (1, (SELECT preco FROM salada), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM salada));

-- Itens para Pedido 4 (Daniel Rocha - Hamburgueria Artesanal)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem picles' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'daniel.rocha@email.com')),
     classic_burger AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Classic Burger' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal')),
     batata_frita AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Batata Frita' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Hamburgueria Artesanal'))
INSERT INTO ifood_like.ItemPedido (quantidade, preco_unitario, id_pedido, id_produto)
VALUES
    (1, (SELECT preco FROM classic_burger), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM classic_burger)),
    (1, (SELECT preco FROM batata_frita), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM batata_frita));

-- Itens para Pedido 5 (Elisa Santos - Pizzaria Sabor Divino)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')),
     pizza_margherita AS (SELECT id_produto, preco FROM ifood_like.Produto WHERE nome_produto = 'Pizza Margherita' AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino'))
INSERT INTO ifood_like.ItemPedido (quantidade, preco_unitario, id_pedido, id_produto)
VALUES
    (1, (SELECT preco FROM pizza_margherita), (SELECT id_pedido FROM pedido_id), (SELECT id_produto FROM pizza_margherita));

------------------------------------------------------------------------
-- Inserção de Dados nas Tabelas de Pagamento (com disjunção)
------------------------------------------------------------------------

-- 6. Pagamento (5 tuplas, uma para cada pedido)
-- Pagamento 1 (Pedido 1 - Cartão)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem cebola na pizza' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'ana.silva@email.com'))
INSERT INTO ifood_like.Pagamento (data_hora_pagamento, valor_pago, status_pagamento, id_pedido)
VALUES (
    '2024-03-10 19:05:00',
    52.00,
    'Aprovado',
    (SELECT id_pedido FROM pedido_id)
) RETURNING id_pagamento AS pag_ana_pizza;

-- Pagamento 2 (Pedido 2 - PIX)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Mais wasabi, por favor' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'bruno.costa@email.com'))
INSERT INTO ifood_like.Pagamento (data_hora_pagamento, valor_pago, status_pagamento, id_pedido)
VALUES (
    '2024-03-11 20:35:00',
    110.00,
    'Aprovado',
    (SELECT id_pedido FROM pedido_id)
) RETURNING id_pagamento AS pag_bruno_sushi;

-- Pagamento 3 (Pedido 3 - Vale Refeição)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'carla.dias@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha'))
INSERT INTO ifood_like.Pagamento (data_hora_pagamento, valor_pago, status_pagamento, id_pedido)
VALUES (
    '2024-03-12 13:05:00',
    105.00,
    'Aprovado',
    (SELECT id_pedido FROM pedido_id)
) RETURNING id_pagamento AS pag_carla_churrasco;

-- Pagamento 4 (Pedido 4 - Cartão)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem picles' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'daniel.rocha@email.com'))
INSERT INTO ifood_like.Pagamento (data_hora_pagamento, valor_pago, status_pagamento, id_pedido)
VALUES (
    '2024-03-13 21:05:00',
    50.00,
    'Aprovado',
    (SELECT id_pedido FROM pedido_id)
) RETURNING id_pagamento AS pag_daniel_burger;

-- Pagamento 5 (Pedido 5 - PIX)
WITH pedido_id AS (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino'))
INSERT INTO ifood_like.Pagamento (data_hora_pagamento, valor_pago, status_pagamento, id_pedido)
VALUES (
    '2024-03-14 19:35:00',
    45.00,
    'Pendente',
    (SELECT id_pedido FROM pedido_id)
) RETURNING id_pagamento AS pag_elisa_pizza;

-- 7. PagamentoCartao (2 tuplas)
WITH pag_id AS (SELECT id_pagamento FROM ifood_like.Pagamento WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem cebola na pizza' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'ana.silva@email.com')))
INSERT INTO ifood_like.PagamentoCartao (id_pagamento, numero_cartao_final, bandeira, tipo_cartao)
VALUES (
    (SELECT id_pagamento FROM pag_id),
    '1234',
    'Visa',
    'Credito'
);

WITH pag_id AS (SELECT id_pagamento FROM ifood_like.Pagamento WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Sem picles' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'daniel.rocha@email.com')))
INSERT INTO ifood_like.PagamentoCartao (id_pagamento, numero_cartao_final, bandeira, tipo_cartao)
VALUES (
    (SELECT id_pagamento FROM pag_id),
    '5678',
    'Mastercard',
    'Debito'
);

-- 8. PagamentoPix (2 tuplas)
WITH pag_id AS (SELECT id_pagamento FROM ifood_like.Pagamento WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE observacoes = 'Mais wasabi, por favor' AND id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'bruno.costa@email.com')))
INSERT INTO ifood_like.PagamentoPix (id_pagamento, chave_pix_origem, id_transacao_pix)
VALUES (
    (SELECT id_pagamento FROM pag_id),
    'bruno.costa@email.com',
    'TRANS_PIX_BRUNO_12345'
);

WITH pag_id AS (SELECT id_pagamento FROM ifood_like.Pagamento WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Pizzaria Sabor Divino')))
INSERT INTO ifood_like.PagamentoPix (id_pagamento, chave_pix_origem, id_transacao_pix)
VALUES (
    (SELECT id_pagamento FROM pag_id),
    'elisa.santos@email.com',
    'TRANS_PIX_ELISA_67890'
);

-- 9. PagamentoValeRefeicao (1 tupla)
WITH pag_id AS (SELECT id_pagamento FROM ifood_like.Pagamento WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'carla.dias@email.com') AND id_restaurante = (SELECT id_restaurante FROM ifood_like.Restaurante WHERE nome = 'Churrascaria Gaúcha')))
INSERT INTO ifood_like.PagamentoValeRefeicao (id_pagamento, empresa_vale, numero_cartao_vale_final)
VALUES (
    (SELECT id_pagamento FROM pag_id),
    'Sodexo',
    '9012'
);
```

---

## 6. Exemplos de Comandos SQL (DML e DQL)

Para demonstrar a manipulação e consulta de dados no cenário iFood-like, serão apresentados exemplos de comandos `INSERT`, `UPDATE`, `DELETE` e `SELECT` complexos.

### 6.1. Comandos de Manipulação de Dados (DML)

#### INSERT (Exemplo para cada tabela - já inclusos no script de população)

Os exemplos de `INSERT` para cada tabela estão detalhados no script de população (`dml_ifood_like_supabase.sql`) acima, garantindo a inserção de dados fictícios e a integridade referencial.

#### UPDATE

```sql
-- Atualizar o status de um pedido para 'Entregue'
UPDATE ifood_like.Pedido
SET status = 'Entregue',
    data_hora_pedido = now() -- Atualiza a data/hora para o momento da entrega
WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'daniel.rocha@email.com') AND status = 'A Caminho');

-- Atualizar o status de um restaurante para 'Ativo'
UPDATE ifood_like.Restaurante
SET status = 'Ativo'
WHERE nome = 'Restaurante Vegano Verde';

-- Atualizar o valor pago de um pagamento pendente (ex: após confirmação)
UPDATE ifood_like.Pagamento
SET status_pagamento = 'Aprovado',
    data_hora_pagamento = now()
WHERE id_pedido = (SELECT id_pedido FROM ifood_like.Pedido WHERE id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com') AND status = 'Pendente');
```

#### DELETE

```sql
-- Excluir um item de pedido (ex: cliente removeu do carrinho antes de finalizar)
-- Nota: A exclusão de um item de pedido pode exigir a atualização do valor_total do pedido.
DELETE FROM ifood_like.ItemPedido
WHERE id_item_pedido = (SELECT ip.id_item_pedido FROM ifood_like.ItemPedido ip
                        JOIN ifood_like.Pedido p ON ip.id_pedido = p.id_pedido
                        JOIN ifood_like.Produto pr ON ip.id_produto = pr.id_produto
                        WHERE p.id_cliente = (SELECT id_cliente FROM ifood_like.Cliente WHERE email = 'elisa.santos@email.com')
                        AND pr.nome_produto = 'Pizza Margherita' LIMIT 1);

-- Excluir um cliente (se não houver pedidos associados devido à restrição ON DELETE RESTRICT)
-- DELETE FROM ifood_like.Cliente WHERE email = 'cliente_a_excluir@email.com';
```

### 6.2. Comandos de Seleção de Dados (DQL)

#### Consultas Complexas

```sql
-- 1. Listar todos os pedidos de um cliente específico ('Ana Paula Silva'), incluindo os produtos e o método de pagamento.
SELECT
    p.data_hora_pedido AS Data_Pedido,
    p.status AS Status_Pedido,
    r.nome AS Restaurante,
    pr.nome_produto AS Produto,
    ip.quantidade AS Quantidade,
    ip.preco_unitario AS Preco_Unitario,
    pag.valor_pago AS Valor_Pago,
    pag.status_pagamento AS Status_Pagamento,
    CASE
        WHEN pc.id_pagamento IS NOT NULL THEN 'Cartão (' || pc.bandeira || ' - ' || pc.tipo_cartao || ')'
        WHEN pp.id_pagamento IS NOT NULL THEN 'PIX'
        WHEN pv.id_pagamento IS NOT NULL THEN 'Vale Refeição (' || pv.empresa_vale || ')'
        ELSE 'Método Desconhecido'
    END AS Metodo_Pagamento
FROM
    ifood_like.Pedido p
JOIN
    ifood_like.Cliente c ON p.id_cliente = c.id_cliente
JOIN
    ifood_like.Restaurante r ON p.id_restaurante = r.id_restaurante
JOIN
    ifood_like.ItemPedido ip ON p.id_pedido = ip.id_pedido
JOIN
    ifood_like.Produto pr ON ip.id_produto = pr.id_produto
LEFT JOIN
    ifood_like.Pagamento pag ON p.id_pedido = pag.id_pedido
LEFT JOIN
    ifood_like.PagamentoCartao pc ON pag.id_pagamento = pc.id_pagamento
LEFT JOIN
    ifood_like.PagamentoPix pp ON pag.id_pagamento = pp.id_pagamento
LEFT JOIN
    ifood_like.PagamentoValeRefeicao pv ON pag.id_pagamento = pv.id_pagamento
WHERE
    c.email = 'ana.silva@email.com'
ORDER BY
    p.data_hora_pedido DESC;

-- 2. Calcular o valor total de vendas por restaurante em um período (ex: Março de 2024).
SELECT
    r.nome AS Restaurante,
    r.categoria AS Categoria,
    SUM(p.valor_total) AS Total_Vendas
FROM
    ifood_like.Restaurante r
JOIN
    ifood_like.Pedido p ON r.id_restaurante = p.id_restaurante
WHERE
    p.data_hora_pedido BETWEEN '2024-03-01 00:00:00' AND '2024-03-31 23:59:59'
    AND p.status = 'Entregue'
GROUP BY
    r.nome, r.categoria
ORDER BY
    Total_Vendas DESC;

-- 3. Encontrar os 3 produtos mais vendidos (em quantidade de itens) em todos os pedidos entregues.
SELECT
    pr.nome_produto AS Produto,
    r.nome AS Restaurante,
    SUM(ip.quantidade) AS Quantidade_Vendida
FROM
    ifood_like.ItemPedido ip
JOIN
    ifood_like.Produto pr ON ip.id_produto = pr.id_produto
JOIN
    ifood_like.Pedido p ON ip.id_pedido = p.id_pedido
JOIN
    ifood_like.Restaurante r ON p.id_restaurante = r.id_restaurante
WHERE
    p.status = 'Entregue'
GROUP BY
    pr.nome_produto, r.nome
ORDER BY
    Quantidade_Vendida DESC
LIMIT 3;

-- 4. Listar clientes que fizeram pedidos em mais de 1 restaurante diferente.
SELECT
    c.nome_completo AS Cliente,
    c.email AS Email_Cliente,
    COUNT(DISTINCT p.id_restaurante) AS Restaurantes_Diferentes
FROM
    ifood_like.Cliente c
JOIN
    ifood_like.Pedido p ON c.id_cliente = p.id_cliente
GROUP BY
    c.nome_completo, c.email
HAVING
    COUNT(DISTINCT p.id_restaurante) > 1
ORDER BY
    Restaurantes_Diferentes DESC;

-- 5. Detalhar pagamentos feitos com cartão de crédito, mostrando o nome do cliente e do restaurante.
SELECT
    c.nome_completo AS Cliente,
    r.nome AS Restaurante,
    pag.valor_pago AS Valor_Pago,
    pc.bandeira AS Bandeira_Cartao,
    pc.numero_cartao_final AS Final_Cartao,
    pag.data_hora_pagamento AS Data_Pagamento
FROM
    ifood_like.Pagamento pag
JOIN
    ifood_like.PagamentoCartao pc ON pag.id_pagamento = pc.id_pagamento
JOIN
    ifood_like.Pedido ped ON pag.id_pedido = ped.id_pedido
JOIN
    ifood_like.Cliente c ON ped.id_cliente = c.id_cliente
JOIN
    ifood_like.Restaurante r ON ped.id_restaurante = r.id_restaurante
WHERE
    pc.tipo_cartao = 'Credito'
ORDER BY
    pag.data_hora_pagamento DESC;

-- 6. Encontrar restaurantes que não tiveram nenhum pedido entregue no último mês.
SELECT
    r.nome AS Restaurante,
    r.categoria AS Categoria
FROM
    ifood_like.Restaurante r
WHERE
    r.status = 'Ativo' AND NOT EXISTS (
        SELECT 1
        FROM ifood_like.Pedido p
        WHERE p.id_restaurante = r.id_restaurante
          AND p.status = 'Entregue'
          AND p.data_hora_pedido >= (now() - INTERVAL '1 month')
    )
ORDER BY
    r.nome;

-- 7. Listar todos os produtos de um restaurante específico ('Pizzaria Sabor Divino') que estão disponíveis.
SELECT
    pr.nome_produto AS Produto,
    pr.descricao AS Descricao,
    pr.preco AS Preco
FROM
    ifood_like.Produto pr
JOIN
    ifood_like.Restaurante r ON pr.id_restaurante = r.id_restaurante
WHERE
    r.nome = 'Pizzaria Sabor Divino' AND pr.disponivel = TRUE
ORDER BY
    pr.nome_produto;

-- 8. Calcular a média de valor dos pedidos por cliente.
SELECT
    c.nome_completo AS Cliente,
    c.email AS Email_Cliente,
    AVG(p.valor_total) AS Media_Valor_Pedido
FROM
    ifood_like.Cliente c
JOIN
    ifood_like.Pedido p ON c.id_cliente = p.id_cliente
GROUP BY
    c.nome_completo, c.email
ORDER BY
    Media_Valor_Pedido DESC;

-- 9. Detalhar todos os pagamentos PIX, incluindo a chave de origem e o ID da transação.
SELECT
    c.nome_completo AS Cliente,
    r.nome AS Restaurante,
    pag.valor_pago AS Valor_Pago,
    pp.chave_pix_origem AS Chave_PIX_Origem,
    pp.id_transacao_pix AS ID_Transacao_PIX,
    pag.data_hora_pagamento AS Data_Pagamento
FROM
    ifood_like.Pagamento pag
JOIN
    ifood_like.PagamentoPix pp ON pag.id_pagamento = pp.id_pagamento
JOIN
    ifood_like.Pedido ped ON pag.id_pedido = ped.id_pedido
JOIN
    ifood_like.Cliente c ON ped.id_cliente = c.id_cliente
JOIN
    ifood_like.Restaurante r ON ped.id_restaurante = r.id_restaurante
ORDER BY
    pag.data_hora_pagamento DESC;

-- 10. Listar pedidos que estão 'Em Preparo' e o nome do restaurante.
SELECT
    p.id_pedido AS ID_Pedido,
    r.nome AS Restaurante,
    p.data_hora_pedido AS Data_Hora_Pedido,
    c.nome_completo AS Cliente
FROM
    ifood_like.Pedido p
JOIN
    ifood_like.Restaurante r ON p.id_restaurante = r.id_restaurante
JOIN
    ifood_like.Cliente c ON p.id_cliente = c.id_cliente
WHERE
    p.status = 'Em Preparo'
ORDER BY
    p.data_hora_pedido;
```
