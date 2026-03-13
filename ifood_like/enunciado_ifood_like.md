# Projeto de Banco de Dados - Cenário iFood-like: Gestão de Pedidos e Pagamentos

## Enunciado do Problema: Sistema de Delivery de Comida

Um sistema de delivery de comida, similar ao iFood, precisa de um banco de dados robusto para gerenciar restaurantes, clientes, produtos, pedidos e, especialmente, os diversos métodos de pagamento. O sistema deve ser projetado na **Terceira Forma Normal (3FN)** e incorporar o conceito de **disjunção (especialização/generalização)** para os pagamentos. As regras de negócio são as seguintes:

1.  **Restaurantes:**
    *   Cada restaurante possui um `ID` único, `nome` (único), `cnpj` (único), `endereco`, `telefone` e `categoria` (ex: Pizzaria, Japonesa, Brasileira).
    *   Deve-se registrar a `data_cadastro` do restaurante no sistema.
    *   O `status` do restaurante (Ativo, Inativo, Em Manutenção) deve ser controlado.

2.  **Clientes:**
    *   Cada cliente possui um `ID` único, `nome_completo`, `email` (único), `telefone`, `endereco_principal` e `data_cadastro`.
    *   O `email` deve ser um formato válido.

3.  **Produtos:**
    *   Cada produto pertence a **um único restaurante** e possui um `ID` único, `nome_produto` (único por restaurante), `descricao`, `preco` (deve ser positivo) e `disponivel` (booleano).
    *   O `preco` deve ser maior que zero.

4.  **Pedidos:**
    *   Cada pedido possui um `ID` único, `data_hora_pedido`, `status` (ex: Pendente, Em Preparo, A Caminho, Entregue, Cancelado), `valor_total` (calculado), `observacoes`.
    *   Um pedido é feito por **um único cliente** e pertence a **um único restaurante**.
    *   A `data_hora_pedido` deve ser registrada automaticamente.

5.  **Itens do Pedido:**
    *   Cada pedido é composto por vários `itens`.
    *   Um item de pedido possui um `ID` único (dentro do pedido), `quantidade` (deve ser positiva) e `preco_unitario` (do produto no momento do pedido).
    *   Cada item de pedido está associado a **um produto** e a **um pedido**.

6.  **Pagamentos (Disjunção - Especialização/Generalização):**
    *   Um pedido pode ter **um único pagamento** associado.
    *   Existe uma entidade genérica `Pagamento` com atributos comuns: `ID` único, `data_hora_pagamento`, `valor_pago` (deve ser positivo e igual ao `valor_total` do pedido), `status_pagamento` (ex: Aprovado, Recusado, Pendente).
    *   A partir de `Pagamento`, existem especializações (disjunção total e exclusiva):
        *   **PagamentoCartao**: Atributos adicionais: `numero_cartao_final` (apenas os 4 últimos dígitos), `bandeira` (ex: Visa, Mastercard), `tipo_cartao` (Crédito, Débito).
        *   **PagamentoPix**: Atributos adicionais: `chave_pix_origem`, `id_transacao_pix` (único).
        *   **PagamentoValeRefeicao**: Atributos adicionais: `empresa_vale` (ex: Sodexo, Alelo), `numero_cartao_vale_final`.
    *   O `valor_pago` deve ser maior que zero.

## Questões da Prova:

1.  **(3 pontos) Construa um Modelo Entidade-Relacionamento (MER) completo para o problema apresentado, incluindo todas as entidades, atributos (com tipos e chaves), e relacionamentos (com cardinalidades e tipos), destacando a disjunção de pagamentos.**

2.  **(3 pontos) Construa o Modelo Relacional (MR) correspondente ao MER do exercício anterior, listando todas as tabelas, chaves primárias (PK), chaves estrangeiras (FK) e atributos, garantindo a 3ª Forma Normal.**

3.  **(3 pontos) Escreva os comandos SQL (para Supabase/PostgreSQL) para criar todas as tabelas do Modelo Relacional, incluindo:
    *   Definição de chaves primárias (UUIDs com `gen_random_uuid()`) e estrangeiras (`ON DELETE CASCADE` ou `SET NULL` quando apropriado).
    *   Restrições de `NOT NULL` para atributos obrigatórios.
    *   Restrições de `UNIQUE` para atributos que devem ser únicos (ex: nome do restaurante, CNPJ, email do cliente, ISBN do livro).
    *   Restrições de `CHECK` para garantir a validade de dados (ex: preço positivo, quantidade positiva, status válidos).
    *   Valores `DEFAULT` para campos como `data_cadastro`, `created_at` e `status`.
    *   Comentários explicativos para cada restrição e escolha de design.

4.  **(3 pontos) Escreva os comandos SQL (para Supabase/PostgreSQL) para popular o banco de dados com dados fictícios, garantindo no mínimo 5 tuplas por entidade e respeitando todas as restrições de integridade. Inclua exemplos para cada tipo de pagamento (Cartão, PIX, Vale-Refeição).**

5.  **(3 pontos) Forneça exemplos de comandos SQL para manipulação e seleção de dados:
    *   `INSERT`: Um exemplo para cada tabela.
    *   `UPDATE`: Atualizar o status de um pedido, o estoque de um produto.
    *   `DELETE`: Excluir um item de pedido.
    *   `SELECT` (DQL): Pelo menos 5 consultas complexas, utilizando `JOIN`s, `WHERE`, `GROUP BY`, `HAVING` e funções de agregação, para responder a perguntas como:
        *   Listar todos os pedidos de um cliente específico, incluindo os produtos e o método de pagamento.
        *   Calcular o valor total de vendas por restaurante em um período.
        *   Encontrar os produtos mais vendidos.
        *   Listar clientes que fizeram pedidos em mais de 3 restaurantes diferentes.
        *   Detalhar pagamentos feitos com cartão de crédito, mostrando o nome do cliente e do restaurante.
