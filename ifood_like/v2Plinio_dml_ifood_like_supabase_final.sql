-- Script SQL DML para popular o banco de dados do Sistema de Delivery de Comida (iFood-like)
-- Otimizado para PostgreSQL (Supabase)
-- Este script insere dados fictícios em todas as tabelas, respeitando as chaves primárias (PK),
-- chaves estrangeiras (FK), restrições UNIQUE, CHECK e a disjunção de pagamentos.
-- Garante no mínimo 5 tuplas por entidade principal.

-- Inserção de dados na tabela Restaurante
-- Gerando UUIDs para os restaurantes e armazenando em CTEs para uso posterior.
WITH inserted_restaurantes AS (
    INSERT INTO Restaurante (nome, cnpj, endereco, telefone, categoria, status)
    VALUES
        (
            'Pizzaria do Zé',
            '00000000000001',
            'Rua das Pizzas, 123, Centro, CidadeX',
            '(11)98765-4321',
            'Pizzaria',
            'Ativo'
        ),
        (
            'Hamburgueria do João',
            '00000000000002',
            'Av. dos Lanches, 456, BairroY, CidadeX',
            '(11)91234-5678',
            'Hamburgueria',
            'Ativo'
        ),
        (
            'Restaurante Oriental',
            '00000000000003',
            'Rua da Ásia, 789, Oriental, CidadeX',
            '(11)99887-7665',
            'Japonesa',
            'Ativo'
        ),
        (
            'Cantina Italiana',
            '00000000000004',
            'Praça da Itália, 10, Europa, CidadeX',
            '(11)97766-5544',
            'Italiana',
            'Ativo'
        ),
        (
            'Padaria e Confeitaria Doce Sabor',
            '00000000000005',
            'Rua do Pão, 50, Centro, CidadeX',
            '(11)96655-4433',
            'Padaria',
            'Ativo'
        )
    RETURNING id_restaurante, nome
),

-- Inserção de dados na tabela Cliente
-- Gerando UUIDs para os clientes e armazenando em CTEs para uso posterior.
inserted_clientes AS (
    INSERT INTO Cliente (nome_completo, email, telefone, endereco_principal)
    VALUES
        (
            'Ana Silva',
            'ana.silva@email.com',
            '(11)91111-1111',
            'Rua A, 100, Bairro A, CidadeX'
        ),
        (
            'Bruno Costa',
            'bruno.costa@email.com',
            '(11)92222-2222',
            'Av. B, 200, Bairro B, CidadeX'
        ),
        (
            'Carla Dias',
            'carla.dias@email.com',
            '(11)93333-3333',
            'Rua C, 300, Bairro C, CidadeX'
        ),
        (
            'Daniel Rocha',
            'daniel.rocha@email.com',
            '(11)94444-4444',
            'Av. D, 400, Bairro D, CidadeX'
        ),
        (
            'Erica Santos',
            'erica.santos@email.com',
            '(11)95555-5555',
            'Rua E, 500, Bairro E, CidadeX'
        )
    RETURNING id_cliente, nome_completo
),

-- Inserção de dados na tabela Produto
-- Associando produtos aos restaurantes criados.
inserted_produtos AS (
    INSERT INTO Produto (nome_produto, descricao, preco, id_restaurante)
    VALUES
        -- Pizzaria do Zé
        (
            'Pizza Calabresa',
            'Pizza com molho de tomate, mussarela e calabresa',
            45.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')
        ),
        (
            'Pizza Margherita',
            'Pizza com molho de tomate, mussarela e manjericão',
            40.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')
        ),
        (
            'Refrigerante Lata',
            'Coca-Cola 350ml',
            7.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')
        ),
        -- Hamburgueria do João
        (
            'X-Bacon',
            'Hambúrguer, queijo, bacon, alface, tomate',
            30.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')
        ),
        (
            'Batata Frita Grande',
            'Porção grande de batata frita',
            15.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')
        ),
        (
            'Milkshake Chocolate',
            'Milkshake de chocolate 500ml',
            20.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')
        ),
        -- Restaurante Oriental
        (
            'Combinado Sushi (10 peças)',
            'Seleção de sushis e sashimis',
            60.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental')
        ),
        (
            'Temaki Salmão',
            'Cone de alga com arroz e salmão',
            25.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental')
        ),
        -- Cantina Italiana
        (
            'Lasanha à Bolonhesa',
            'Lasanha tradicional com molho bolonhesa',
            55.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana')
        ),
        (
            'Espaguete Carbonara',
            'Espaguete com molho carbonara',
            48.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana')
        ),
        -- Padaria e Confeitaria Doce Sabor
        (
            'Pão de Queijo (6 unidades)',
            'Porção de pães de queijo',
            12.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor')
        ),
        (
            'Bolo de Cenoura com Chocolate',
            'Fatia de bolo de cenoura com cobertura de chocolate',
            18.00,
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor')
        )
    RETURNING id_produto, nome_produto, preco, id_restaurante
),

-- Inserção de dados na tabela Pedido
-- Associando pedidos a clientes e restaurantes.
inserted_pedidos AS (
    INSERT INTO Pedido (id_cliente, id_restaurante, data_hora_pedido, status, valor_total, observacoes)
    VALUES
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé'),
            CURRENT_TIMESTAMP - INTERVAL '2 hours',
            'Entregue',
            52.00,
            'Sem cebola'
        ),
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Bruno Costa'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João'),
            CURRENT_TIMESTAMP - INTERVAL '1 hour',
            'Em Entrega',
            45.00,
            'Maionese extra'
        ),
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Carla Dias'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental'),
            CURRENT_TIMESTAMP - INTERVAL '30 minutes',
            'Confirmado',
            85.00,
            'Hashi extra'
        ),
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana'),
            CURRENT_TIMESTAMP - INTERVAL '15 minutes',
            'Pendente',
            55.00,
            NULL
        ),
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Erica Santos'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor'),
            CURRENT_TIMESTAMP - INTERVAL '5 minutes',
            'Pendente',
            30.00,
            'Café forte'
        ),
        (
            (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva'),
            (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João'),
            CURRENT_TIMESTAMP - INTERVAL '4 hours',
            'Entregue',
            30.00,
            'Sem picles'
        )
    RETURNING id_pedido, id_cliente, id_restaurante, valor_total, data_hora_pedido
),

-- Inserção de dados na tabela ItemPedido
-- Associando produtos aos pedidos.
inserted_itens_pedido AS (
    INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES
        -- Pedido 1 (Ana Silva - Pizzaria do Zé)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé') AND valor_total = 52.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Pizza Calabresa' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')),
            1,
            45.00
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé') AND valor_total = 52.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Refrigerante Lata' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')),
            1,
            7.00
        ),
        -- Pedido 2 (Bruno Costa - Hamburgueria do João)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Bruno Costa') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 45.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'X-Bacon' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')),
            1,
            30.00
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Bruno Costa') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 45.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Batata Frita Grande' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')),
            1,
            15.00
        ),
        -- Pedido 3 (Carla Dias - Restaurante Oriental)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Carla Dias') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental') AND valor_total = 85.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Combinado Sushi (10 peças)' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental')),
            1,
            60.00
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Carla Dias') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental') AND valor_total = 85.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Temaki Salmão' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental')),
            1,
            25.00
        ),
        -- Pedido 4 (Daniel Rocha - Cantina Italiana)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana') AND valor_total = 55.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Lasanha à Bolonhesa' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana')),
            1,
            55.00
        ),
        -- Pedido 5 (Erica Santos - Padaria e Confeitaria Doce Sabor)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Erica Santos') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor') AND valor_total = 30.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Pão de Queijo (6 unidades)' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor')),
            1,
            12.00
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Erica Santos') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor') AND valor_total = 30.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'Bolo de Cenoura com Chocolate' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor')),
            1,
            18.00
        ),
        -- Pedido 6 (Ana Silva - Hamburgueria do João)
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 30.00),
            (SELECT id_produto FROM inserted_produtos WHERE nome_produto = 'X-Bacon' AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João')),
            1,
            30.00
        )
    RETURNING id_item_pedido
),

-- Inserção de dados na tabela Pagamento (Supertipo)
-- Gerando UUIDs para os pagamentos e associando aos pedidos.
inserted_pagamentos AS (
    INSERT INTO Pagamento (id_pedido, data_hora_pagamento, valor_pago, status_pagamento)
    VALUES
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé') AND valor_total = 52.00),
            CURRENT_TIMESTAMP - INTERVAL '1 hour 55 minutes',
            52.00,
            'Aprovado'
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Bruno Costa') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 45.00),
            CURRENT_TIMESTAMP - INTERVAL '55 minutes',
            45.00,
            'Aprovado'
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Carla Dias') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental') AND valor_total = 85.00),
            CURRENT_TIMESTAMP - INTERVAL '25 minutes',
            85.00,
            'Aprovado'
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana') AND valor_total = 55.00),
            CURRENT_TIMESTAMP - INTERVAL '10 minutes',
            55.00,
            'Pendente'
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Erica Santos') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor') AND valor_total = 30.00),
            CURRENT_TIMESTAMP - INTERVAL '3 minutes',
            30.00,
            'Aprovado'
        ),
        (
            (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 30.00),
            CURRENT_TIMESTAMP - INTERVAL '3 hours 50 minutes',
            30.00,
            'Aprovado'
        )
    RETURNING id_pagamento, id_pedido, valor_pago
)

-- Inserção de dados nas tabelas de especialização de Pagamento
-- Garantindo que cada pagamento genérico tenha apenas um tipo especializado.
INSERT INTO PagamentoCartao (id_pagamento, numero_cartao_final, bandeira, tipo_cartao)
SELECT id_pagamento, '1234', 'Visa', 'Credito'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé') AND valor_total = 52.00);

INSERT INTO PagamentoPix (id_pagamento, chave_pix_origem, id_transacao_pix)
SELECT id_pagamento, 'ana.silva@email.com', 'pix_trans_abc123'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Bruno Costa') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 45.00);

INSERT INTO PagamentoValeRefeicao (id_pagamento, empresa_vale, numero_cartao_vale_final)
SELECT id_pagamento, 'Sodexo', '5678'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Carla Dias') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Restaurante Oriental') AND valor_total = 85.00);

INSERT INTO PagamentoCartao (id_pagamento, numero_cartao_final, bandeira, tipo_cartao)
SELECT id_pagamento, '9012', 'Mastercard', 'Debito'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Erica Santos') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Padaria e Confeitaria Doce Sabor') AND valor_total = 30.00);

INSERT INTO PagamentoPix (id_pagamento, chave_pix_origem, id_transacao_pix)
SELECT id_pagamento, 'ana.silva.pix@email.com', 'pix_trans_def456'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Hamburgueria do João') AND valor_total = 30.00);

-- O pagamento do Daniel Rocha (Cantina Italiana) está pendente, então não há especialização ainda.

-- Exemplo de UPDATE (após a inserção)
-- Atualiza o status de um pedido e seu pagamento associado.
UPDATE Pedido
SET status = 'Entregue'
WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha')
  AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana')
  AND status = 'Pendente';

UPDATE Pagamento
SET status_pagamento = 'Aprovado',
    data_hora_pagamento = CURRENT_TIMESTAMP - INTERVAL '5 minutes'
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana') AND valor_total = 55.00);

-- Inserção do detalhe do pagamento para o pedido do Daniel Rocha após a atualização
INSERT INTO PagamentoValeRefeicao (id_pagamento, empresa_vale, numero_cartao_vale_final)
SELECT id_pagamento, 'Alelo', '3456'
FROM inserted_pagamentos
WHERE id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Daniel Rocha') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Cantina Italiana') AND valor_total = 55.00);

-- Exemplo de DELETE (após a inserção)
-- Deleta um produto (se não estiver em nenhum pedido, devido ao ON DELETE RESTRICT)
-- Para demonstrar, vamos deletar um produto que não foi usado em nenhum pedido fictício.
-- Primeiro, insere um produto extra que não será usado.
WITH extra_produto AS (
    INSERT INTO Produto (nome_produto, descricao, preco, id_restaurante)
    VALUES (
        'Suco de Laranja Natural',
        'Suco de laranja fresco 300ml',
        10.00,
        (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé')
    )
    RETURNING id_produto
)
DELETE FROM Produto
WHERE id_produto = (SELECT id_produto FROM extra_produto);

-- Exemplo de SELECTs para verificar os dados (DQL)
-- 1. Listar todos os restaurantes e seus status
SELECT id_restaurante, nome, status FROM Restaurante;

-- 2. Listar clientes e seus emails
SELECT id_cliente, nome_completo, email FROM Cliente;

-- 3. Produtos da Pizzaria do Zé
SELECT p.nome_produto, p.preco
FROM Produto p
JOIN Restaurante r ON p.id_restaurante = r.id_restaurante
WHERE r.nome = 'Pizzaria do Zé';

-- 4. Pedidos feitos pela Ana Silva
SELECT pe.data_hora_pedido, pe.valor_total, pe.status, r.nome AS restaurante
FROM Pedido pe
JOIN Cliente c ON pe.id_cliente = c.id_cliente
JOIN Restaurante r ON pe.id_restaurante = r.id_restaurante
WHERE c.nome_completo = 'Ana Silva';

-- 5. Detalhes de um pedido específico (itens e produtos)
SELECT
    pe.id_pedido,
    p.nome_produto,
    ip.quantidade,
    ip.preco_unitario
FROM Pedido pe
JOIN ItemPedido ip ON pe.id_pedido = ip.id_pedido
JOIN Produto p ON ip.id_produto = p.id_produto
WHERE pe.id_pedido = (SELECT id_pedido FROM inserted_pedidos WHERE id_cliente = (SELECT id_cliente FROM inserted_clientes WHERE nome_completo = 'Ana Silva') AND id_restaurante = (SELECT id_restaurante FROM inserted_restaurantes WHERE nome = 'Pizzaria do Zé') AND valor_total = 52.00);

-- 6. Pagamentos aprovados e seus tipos (usando LEFT JOIN para disjunção)
SELECT
    pa.id_pagamento,
    pa.valor_pago,
    pa.status_pagamento,
    pc.bandeira AS cartao_bandeira,
    pp.chave_pix_origem AS pix_origem,
    pv.empresa_vale AS vale_empresa
FROM Pagamento pa
LEFT JOIN PagamentoCartao pc ON pa.id_pagamento = pc.id_pagamento
LEFT JOIN PagamentoPix pp ON pa.id_pagamento = pp.id_pagamento
LEFT JOIN PagamentoValeRefeicao pv ON pa.id_pagamento = pv.id_pagamento
WHERE pa.status_pagamento = 'Aprovado';

-- 7. Total de vendas por restaurante
SELECT
    r.nome AS restaurante,
    SUM(pe.valor_total) AS total_vendas
FROM Restaurante r
JOIN Pedido pe ON r.id_restaurante = pe.id_restaurante
WHERE pe.status = 'Entregue'
GROUP BY r.nome
ORDER BY total_vendas DESC;

-- 8. Clientes que fizeram mais de um pedido
SELECT
    c.nome_completo,
    COUNT(pe.id_pedido) AS total_pedidos
FROM Cliente c
JOIN Pedido pe ON c.id_cliente = pe.id_cliente
GROUP BY c.nome_completo
HAVING COUNT(pe.id_pedido) > 1
ORDER BY total_pedidos DESC;

-- 9. Produtos mais vendidos (considerando quantidade)
SELECT
    p.nome_produto,
    SUM(ip.quantidade) AS quantidade_total_vendida
FROM Produto p
JOIN ItemPedido ip ON p.id_produto = ip.id_produto
GROUP BY p.nome_produto
ORDER BY quantidade_total_vendida DESC
LIMIT 5;

-- 10. Pedidos com pagamento pendente e o cliente que o fez
SELECT
    pe.id_pedido,
    c.nome_completo AS cliente,
    pe.valor_total,
    pa.status_pagamento
FROM Pedido pe
JOIN Cliente c ON pe.id_cliente = c.id_cliente
JOIN Pagamento pa ON pe.id_pedido = pa.id_pedido
WHERE pa.status_pagamento = 'Pendente';

-- 11. Restaurantes que oferecem 'Refrigerante Lata'
SELECT DISTINCT r.nome
FROM Restaurante r
JOIN Produto p ON r.id_restaurante = p.id_restaurante
WHERE p.nome_produto = 'Refrigerante Lata';

-- 12. Valor médio dos pedidos por cliente
SELECT
    c.nome_completo,
    AVG(pe.valor_total) AS valor_medio_pedido
FROM Cliente c
JOIN Pedido pe ON c.id_cliente = pe.id_cliente
GROUP BY c.nome_completo
ORDER BY valor_medio_pedido DESC;

-- 13. Pedidos que contêm um produto de um restaurante específico
SELECT
    pe.id_pedido,
    c.nome_completo AS cliente,
    r.nome AS restaurante,
    p.nome_produto
FROM Pedido pe
JOIN Cliente c ON pe.id_cliente = c.id_cliente
JOIN Restaurante r ON pe.id_restaurante = r.id_restaurante
JOIN ItemPedido ip ON pe.id_pedido = ip.id_pedido
JOIN Produto p ON ip.id_produto = p.id_produto
WHERE r.nome = 'Pizzaria do Zé' AND p.nome_produto = 'Pizza Calabresa';

-- 14. Clientes que usaram PIX como forma de pagamento
SELECT DISTINCT c.nome_completo, c.email
FROM Cliente c
JOIN Pedido pe ON c.id_cliente = pe.id_cliente
JOIN Pagamento pa ON pe.id_pedido = pa.id_pedido
JOIN PagamentoPix pp ON pa.id_pagamento = pp.id_pagamento;

-- 15. Restaurantes com produtos acima de um determinado preço
SELECT DISTINCT r.nome AS restaurante_caro
FROM Restaurante r
JOIN Produto p ON r.id_restaurante = p.id_restaurante
WHERE p.preco > 50.00;
