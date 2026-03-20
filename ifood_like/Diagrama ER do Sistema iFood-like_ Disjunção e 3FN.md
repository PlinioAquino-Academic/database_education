# Diagrama ER do Sistema iFood-like: Disjunção e 3FN

Este documento apresenta o Diagrama Entidade-Relacionamento (ER) para um sistema de delivery de comida, inspirado no iFood, com foco na ilustração da **disjunção (especialização/generalização)** para métodos de pagamento e na aplicação da **Terceira Forma Normal (3FN)**.

## Diagrama ER Simplificado

![Diagrama ER iFood-like Simplificado]

## Explicação dos Conceitos Chave

### 1. Disjunção (Especialização/Generalização) para Pagamentos

No diagrama, a disjunção é aplicada à entidade `Pagamento`. Isso significa que um pagamento pode ser de um tipo específico, mas não de vários ao mesmo tempo. A entidade `Pagamento` atua como uma **entidade genérica** (ou supertipo), contendo atributos comuns a todos os tipos de pagamento (como `id_pagamento`, `data_hora_pagamento`, `valor_pago`, `status_pagamento` e `id_pedido`).

As entidades `PagamentoCartao`, `PagamentoPix` e `PagamentoValeRefeicao` são as **entidades especializadas** (ou subtipos). Cada uma delas herda a chave primária (`id_pagamento`) da entidade `Pagamento` e adiciona atributos específicos a cada método:

*   **`PagamentoCartao`**: `numero_cartao_final`, `bandeira`, `tipo_cartao`.
*   **`PagamentoPix`**: `chave_pix_origem`, `id_transacao_pix`.
*   **`PagamentoValeRefeicao`**: `empresa_vale`, `numero_cartao_vale_final`.

O relacionamento entre `Pagamento` e suas especializações é de **um-para-um (1:1)**, onde cada registro em `Pagamento` corresponde a **exatamente um** registro em uma das tabelas especializadas. Isso é implementado no modelo relacional através de chaves estrangeiras que também são chaves primárias nas tabelas especializadas (`id_pagamento PK,FK`).

Essa abordagem permite:
*   **Flexibilidade**: Adicionar novos métodos de pagamento sem alterar a estrutura da tabela `Pagamento` principal.
*   **Reuso**: Atributos comuns são armazenados apenas uma vez.
*   **Integridade**: Garante que cada pagamento tenha apenas um tipo detalhado.

### 2. Terceira Forma Normal (3FN)

O diagrama e o modelo relacional foram projetados para atender à Terceira Forma Normal (3FN), que exige que:

1.  **Estar na 2FN**: Não há dependências parciais de atributos não-chave em relação à chave primária.
2.  **Não haver dependências transitivas**: Nenhum atributo não-chave depende de outro atributo não-chave.

Exemplos de como a 3FN é aplicada:

*   **Entidade `Restaurante`**: Contém apenas atributos que dependem diretamente de `id_restaurante` (nome, cnpj, endereço, etc.). Informações sobre produtos ou pedidos são armazenadas em suas respectivas entidades.
*   **Entidade `Produto`**: `nome_produto`, `descricao`, `preco`, `disponivel` dependem de `id_produto`. O `id_restaurante` é uma FK, mas não há atributos do restaurante repetidos aqui, evitando dependência transitiva.
*   **Entidade `Pedido`**: `data_hora_pedido`, `status`, `valor_total`, `observacoes` dependem de `id_pedido`. `id_cliente` e `id_restaurante` são FKs, e não há informações redundantes de cliente ou restaurante dentro de `Pedido`.
*   **Entidade `ItemPedido`**: `quantidade` e `preco_unitario` dependem da chave primária `id_item_pedido` (que por sua vez é identificada pela combinação de `id_pedido` e `id_produto`). Não há atributos de `Produto` ou `Pedido` que não sejam parte da chave ou dependam transitivamente de outro atributo não-chave.

Ao aderir à 3FN, o modelo minimiza a redundância de dados, evita anomalias de atualização, inserção e exclusão, e melhora a integridade e a consistência do banco de dados.
