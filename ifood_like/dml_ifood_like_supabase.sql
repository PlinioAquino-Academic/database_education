--- Script SQL DML para População do Banco de Dados iFood-like (Supabase/PostgreSQL) ---

-- Este script insere dados fictícios em todas as tabelas do sistema iFood-like,
-- respeitando as restrições de integridade e chaves estrangeiras. Ele inclui
-- exemplos para os diferentes tipos de pagamento (Cartão, PIX, Vale-Refeição).

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
