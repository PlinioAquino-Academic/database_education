# Diagrama ER de Sistema de Biblioteca: PK, UNIQUE e FK em Ação

Este diagrama Entidade-Relacionamento (ER) ilustra um sistema básico de biblioteca, destacando a aplicação prática de Chaves Primárias (PK), Chaves Estrangeiras (FK) e restrições UNIQUE.

![Diagrama ER Biblioteca](er_biblioteca.png)

## Explicação das Chaves no Diagrama:

### Chaves Primárias (PK - Primary Key):

As Chaves Primárias são os identificadores únicos e não nulos de cada registro em uma tabela. Elas garantem que cada linha seja única e acessível de forma eficiente.

*   **`id_livro` (Tabela Livro)**: Cada livro na biblioteca terá um `id_livro` exclusivo. É o identificador principal do livro.
*   **`id_autor` (Tabela Autor)**: Cada autor será identificado por um `id_autor` único.
*   **`id_usuario` (Tabela Usuario)**: Cada usuário da biblioteca terá um `id_usuario` exclusivo.
*   **`id_emprestimo` (Tabela Emprestimo)**: Cada empréstimo realizado terá um `id_emprestimo` único.
*   **`id_editora` (Tabela Editora)**: Cada editora será identificada por um `id_editora` único.
*   **`id_livro`, `id_autor` (Tabela Livro_Autor)**: Esta é uma **chave primária composta**. A combinação do `id_livro` e `id_autor` é única, pois um livro pode ter vários autores e um autor pode escrever vários livros. A combinação dos dois identifica a relação específica de autoria.

### Restrições UNIQUE:

As restrições UNIQUE garantem que todos os valores em uma coluna (ou grupo de colunas) sejam diferentes, mas, ao contrário da PK, permitem valores nulos (geralmente apenas um valor nulo, dependendo do SGBD). Elas são usadas para identificar atributos que devem ser únicos, mas não são o identificador principal da entidade.

*   **`isbn` (Tabela Livro)**: O ISBN (International Standard Book Number) é um código único para cada edição de um livro. Embora `id_livro` seja a PK, o `isbn` também deve ser único para evitar duplicidade de registros de livros.
*   **`cpf` (Tabela Usuario)**: O CPF é um documento de identificação único para cada pessoa. Embora `id_usuario` seja a PK, o `cpf` também deve ser único para garantir que não haja dois usuários com o mesmo CPF.
*   **`nome_editora` (Tabela Editora)**: O nome da editora deve ser único para evitar confusão entre diferentes editoras.

### Chaves Estrangeiras (FK - Foreign Key):

As Chaves Estrangeiras são colunas que estabelecem um vínculo entre duas tabelas, referenciando a Chave Primária (ou uma restrição UNIQUE) de outra tabela. Elas são essenciais para manter a integridade referencial e modelar os relacionamentos entre as entidades.

*   **`id_editora` (Tabela Livro)**: Esta FK referencia o `id_editora` da tabela `Editora`. Isso significa que cada livro deve ser publicado por uma editora que exista na tabela `Editora`.
*   **`id_livro` (Tabela Emprestimo)**: Esta FK referencia o `id_livro` da tabela `Livro`. Garante que apenas livros existentes possam ser emprestados.
*   **`id_usuario` (Tabela Emprestimo)**: Esta FK referencia o `id_usuario` da tabela `Usuario`. Garante que apenas usuários cadastrados possam realizar empréstimos.
*   **`id_livro` (Tabela Livro_Autor)**: Esta FK referencia o `id_livro` da tabela `Livro`.
*   **`id_autor` (Tabela Livro_Autor)**: Esta FK referencia o `id_autor` da tabela `Autor`.

Este diagrama demonstra como a combinação dessas chaves permite construir um modelo de dados robusto e consistente para um sistema de biblioteca, garantindo a integridade e a correta representação dos relacionamentos entre as informações.
