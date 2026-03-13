--- Script SQL DDL para o Sistema iFood-like (Supabase/PostgreSQL) ---

-- Este script cria as tabelas para o sistema de delivery de comida, aplicando o conceito de disjunção
-- para pagamentos e garantindo a Terceira Forma Normal (3FN). Inclui Chaves Primárias (PKs) com UUIDs,
-- Restrições UNIQUE, Chaves Estrangeiras (FKs) com ações de deleção, e Restrições CHECK para validação de dados.

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
