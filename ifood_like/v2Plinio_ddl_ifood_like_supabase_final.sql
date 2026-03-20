-- Script SQL DDL para o Sistema de Delivery de Comida (iFood-like)
-- Otimizado para PostgreSQL (Supabase)
-- Este script cria as tabelas, define chaves primárias (PK), chaves estrangeiras (FK),
-- restrições UNIQUE, CHECK e DEFAULT, aplicando a Terceira Forma Normal (3FN)
-- e o conceito de disjunção para os métodos de pagamento.

-- Habilita a extensão 'uuid-ossp' para gerar UUIDs aleatórios, comum no Supabase.
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- Geralmente já habilitado no Supabase

-- Tabela: Restaurante
-- Armazena informações sobre os restaurantes parceiros.
-- 3FN: Cada atributo depende da PK (id_restaurante) e não há dependências transitivas.
CREATE TABLE Restaurante (
    id_restaurante UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do restaurante (UUID gerado automaticamente)
    nome TEXT NOT NULL UNIQUE, -- UK: Nome do restaurante, deve ser único
    cnpj TEXT NOT NULL UNIQUE CHECK (LENGTH(cnpj) = 14), -- UK: CNPJ do restaurante, deve ser único e ter 14 dígitos
    endereco TEXT NOT NULL, -- Endereço completo do restaurante
    telefone TEXT NOT NULL,
    categoria TEXT NOT NULL, -- Tipo de culinária (ex: 'Pizzaria', 'Japonesa', 'Brasileira')
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Data de registro do restaurante
    status TEXT NOT NULL DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Em Manutenção')) -- Status operacional do restaurante
);

-- Tabela: Cliente
-- Armazena informações sobre os clientes do sistema.
-- 3FN: Cada atributo depende da PK (id_cliente) e não há dependências transitivas.
CREATE TABLE Cliente (
    id_cliente UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do cliente (UUID gerado automaticamente)
    nome_completo TEXT NOT NULL, -- Nome completo do cliente
    email TEXT NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'), -- UK: Email do cliente, deve ser único e ter formato válido
    telefone TEXT NOT NULL,
    endereco_principal TEXT NOT NULL, -- Endereço principal de entrega do cliente
    data_cadastro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP -- Data de registro do cliente
);

-- Tabela: Produto
-- Armazena informações sobre os produtos oferecidos pelos restaurantes.
-- 3FN: Cada atributo depende da PK (id_produto). id_restaurante é FK.
CREATE TABLE Produto (
    id_produto UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do produto
    nome_produto TEXT NOT NULL, -- Nome do produto
    descricao TEXT,
    preco NUMERIC(10, 2) NOT NULL CHECK (preco > 0), -- Preço do produto, deve ser positivo
    disponivel BOOLEAN DEFAULT TRUE, -- Indica se o produto está disponível para venda
    id_restaurante UUID NOT NULL, -- FK: Chave estrangeira para a tabela Restaurante
    CONSTRAINT fk_restaurante_produto FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante) ON DELETE CASCADE ON UPDATE CASCADE -- Se o restaurante for excluído, seus produtos também são. Se o ID do restaurante mudar, atualiza aqui.
);

-- Tabela: Pedido
-- Armazena informações sobre os pedidos realizados pelos clientes.
-- 3FN: Cada atributo depende da PK (id_pedido). id_cliente e id_restaurante são FKs.
CREATE TABLE Pedido (
    id_pedido UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do pedido
    data_hora_pedido TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Data e hora em que o pedido foi feito
    status TEXT NOT NULL DEFAULT 'Pendente' CHECK (status IN ('Pendente', 'Confirmado', 'Em Preparo', 'Em Entrega', 'Entregue', 'Cancelado')), -- Status atual do pedido
    valor_total NUMERIC(10, 2) NOT NULL CHECK (valor_total >= 0), -- Valor total do pedido (calculado pela aplicação)
    observacoes TEXT,
    id_cliente UUID NOT NULL, -- FK: Chave estrangeira para a tabela Cliente
    id_restaurante UUID NOT NULL, -- FK: Chave estrangeira para a tabela Restaurante
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE, -- Não permite excluir cliente com pedidos. Se o ID do cliente mudar, atualiza aqui.
    CONSTRAINT fk_restaurante_pedido FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante) ON DELETE RESTRICT ON UPDATE CASCADE -- Não permite excluir restaurante com pedidos. Se o ID do restaurante mudar, atualiza aqui.
);

-- Tabela: ItemPedido
-- Tabela associativa para representar os produtos dentro de um pedido (relacionamento N:M entre Pedido e Produto).
-- 3FN: PK composta (id_item_pedido). quantidade e preco_unitario dependem da PK composta.
CREATE TABLE ItemPedido (
    id_item_pedido UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do item do pedido
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade do produto no pedido
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario > 0), -- Preço do produto no momento do pedido (para histórico)
    id_pedido UUID NOT NULL, -- FK: Chave estrangeira para a tabela Pedido
    id_produto UUID NOT NULL, -- FK: Chave estrangeira para a tabela Produto
    CONSTRAINT fk_pedido_item FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE, -- Se o pedido for excluído, seus itens também são.
    CONSTRAINT fk_produto_item FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE RESTRICT ON UPDATE CASCADE, -- Não permite excluir produto que está em algum item de pedido.
    CONSTRAINT unique_item_pedido UNIQUE (id_pedido, id_produto) -- Garante que um produto só apareça uma vez por pedido
);

-- Tabela: Pagamento (Supertipo/Generalização)
-- Armazena informações comuns a todos os tipos de pagamento.
-- 3FN: Cada atributo depende da PK (id_pagamento). id_pedido é FK e UNIQUE (um pedido tem apenas um pagamento).
CREATE TABLE Pagamento (
    id_pagamento UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- PK: Identificador único do pagamento
    data_hora_pagamento TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Data e hora do pagamento
    valor_pago NUMERIC(10, 2) NOT NULL CHECK (valor_pago > 0), -- Valor efetivamente pago
    status_pagamento TEXT NOT NULL CHECK (status_pagamento IN ('Aprovado', 'Recusado', 'Pendente', 'Estornado')), -- Status do pagamento
    id_pedido UUID NOT NULL UNIQUE, -- FK e UK: Cada pedido tem um e apenas um pagamento associado
    CONSTRAINT fk_pedido_pagamento FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE -- Se o pedido for excluído, o pagamento associado também é.
);

-- Tabela: PagamentoCartao (Subtipo/Especialização)
-- Detalhes específicos para pagamentos via cartão de crédito/débito.
-- 3FN: id_pagamento é PK e FK, garantindo 1:1 com Pagamento. Atributos dependem da PK.
CREATE TABLE PagamentoCartao (
    id_pagamento UUID PRIMARY KEY, -- PK e FK: Referencia a tabela Pagamento
    numero_cartao_final TEXT NOT NULL CHECK (LENGTH(numero_cartao_final) = 4), -- Últimos 4 dígitos do cartão
    bandeira TEXT NOT NULL CHECK (bandeira IN ('Visa', 'Mastercard', 'Elo', 'Amex', 'Outra')), -- Bandeira do cartão
    tipo_cartao TEXT NOT NULL CHECK (tipo_cartao IN ('Credito', 'Debito')), -- Tipo de cartão
    CONSTRAINT fk_pagamento_cartao FOREIGN KEY (id_pagamento) REFERENCES Pagamento(id_pagamento) ON DELETE CASCADE ON UPDATE CASCADE -- Se o pagamento genérico for excluído, os detalhes do cartão também são.
);

-- Tabela: PagamentoPix (Subtipo/Especialização)
-- Detalhes específicos para pagamentos via PIX.
-- 3FN: id_pagamento é PK e FK, garantindo 1:1 com Pagamento. Atributos dependem da PK.
CREATE TABLE PagamentoPix (
    id_pagamento UUID PRIMARY KEY, -- PK e FK: Referencia a tabela Pagamento
    chave_pix_origem TEXT NOT NULL, -- Chave PIX utilizada pelo pagador
    id_transacao_pix TEXT NOT NULL UNIQUE, -- UK: ID único da transação PIX, fornecido pelo banco
    CONSTRAINT fk_pagamento_pix FOREIGN KEY (id_pagamento) REFERENCES Pagamento(id_pagamento) ON DELETE CASCADE ON UPDATE CASCADE -- Se o pagamento genérico for excluído, os detalhes do PIX também são.
);

-- Tabela: PagamentoValeRefeicao (Subtipo/Especialização)
-- Detalhes específicos para pagamentos via vale-refeição/alimentação.
-- 3FN: id_pagamento é PK e FK, garantindo 1:1 com Pagamento. Atributos dependem da PK.
CREATE TABLE PagamentoValeRefeicao (
    id_pagamento UUID PRIMARY KEY, -- PK e FK: Referencia a tabela Pagamento
    empresa_vale TEXT NOT NULL CHECK (empresa_vale IN ('Sodexo', 'Alelo', 'Ticket', 'VR Beneficios', 'Outra')), -- Empresa do vale
    numero_cartao_vale_final TEXT NOT NULL CHECK (LENGTH(numero_cartao_vale_final) = 4), -- Últimos 4 dígitos do cartão vale
    CONSTRAINT fk_pagamento_vale FOREIGN KEY (id_pagamento) REFERENCES Pagamento(id_pagamento) ON DELETE CASCADE ON UPDATE CASCADE -- Se o pagamento genérico for excluído, os detalhes do vale também são.
);
