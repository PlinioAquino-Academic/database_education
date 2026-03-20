--- Script SQL para População do Banco de Dados da Biblioteca com Dados Fictícios ---

-- Certifique-se de que o schema 'biblioteca' e as tabelas já foram criados.
-- Este script assume que as tabelas estão vazias ou que os IDs auto-gerados começarão a partir de 1.

-- Inserção de dados nas tabelas independentes primeiro

-- 1. Editora
INSERT INTO biblioteca.Editora (nome_editora, pais_origem) VALUES
(
    'Editora Alfa',
    'Brasil'
),
(
    'Publisher Beta',
    'EUA'
),
(
    'Editions Gamma',
    'França'
);

-- 2. Autor
INSERT INTO biblioteca.Autor (nome_autor, data_nascimento) VALUES
(
    'Machado de Assis',
    '1839-06-21'
),
(
    'Jane Austen',
    '1775-12-16'
),
(
    'George Orwell',
    '1903-06-25'
),
(
    'Clarice Lispector',
    '1920-12-10'
);

-- 3. Usuario
INSERT INTO biblioteca.Usuario (nome_completo, cpf, endereco, telefone, data_cadastro) VALUES
(
    'Carlos Eduardo',
    '111.111.111-11',
    'Rua A, 100, Bairro Central, Cidade - SP',
    '(11) 98765-1234',
    '2023-01-10'
),
(
    'Fernanda Lima',
    '222.222.222-22',
    'Av. B, 200, Bairro Novo, Cidade - RJ',
    '(21) 99887-4321',
    '2023-02-15'
),
(
    'Roberto Souza',
    '333.333.333-33',
    'Travessa C, 300, Vila Antiga, Cidade - MG',
    '(31) 97654-9876',
    '2023-03-20'
);

-- Inserção de dados nas tabelas principais que dependem das anteriores

-- 4. Livro
INSERT INTO biblioteca.Livro (titulo, isbn, ano_publicacao, id_editora) VALUES
(
    'Dom Casmurro',
    '978-85-0801484-0',
    1899,
    (SELECT id_editora FROM biblioteca.Editora WHERE nome_editora = 'Editora Alfa')
),
(
    'Orgulho e Preconceito',
    '978-85-3590000-0',
    1813,
    (SELECT id_editora FROM biblioteca.Editora WHERE nome_editora = 'Publisher Beta')
),
(
    '1984',
    '978-85-3590001-7',
    1949,
    (SELECT id_editora FROM biblioteca.Editora WHERE nome_editora = 'Publisher Beta')
),
(
    'A Hora da Estrela',
    '978-85-3250700-0',
    1977,
    (SELECT id_editora FROM biblioteca.Editora WHERE nome_editora = 'Editora Alfa')
),
(
    'Memórias Póstumas de Brás Cubas',
    '978-85-0801485-7',
    1881,
    (SELECT id_editora FROM biblioteca.Editora WHERE nome_editora = 'Editora Alfa')
);

-- 5. Livro_Autor (tabela associativa)
INSERT INTO biblioteca.Livro_Autor (id_livro, id_autor) VALUES
(
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-0801484-0'), -- Dom Casmurro
    (SELECT id_autor FROM biblioteca.Autor WHERE nome_autor = 'Machado de Assis')
),
(
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3590000-0'), -- Orgulho e Preconceito
    (SELECT id_autor FROM biblioteca.Autor WHERE nome_autor = 'Jane Austen')
),
(
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3590001-7'), -- 1984
    (SELECT id_autor FROM biblioteca.Autor WHERE nome_autor = 'George Orwell')
),
(
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3250700-0'), -- A Hora da Estrela
    (SELECT id_autor FROM biblioteca.Autor WHERE nome_autor = 'Clarice Lispector')
),
(
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-0801485-7'), -- Memórias Póstumas
    (SELECT id_autor FROM biblioteca.Autor WHERE nome_autor = 'Machado de Assis')
);

-- 6. Emprestimo
INSERT INTO biblioteca.Emprestimo (data_emprestimo, data_devolucao_prevista, data_devolucao_real, id_livro, id_usuario) VALUES
(
    '2024-03-01 10:00:00',
    '2024-03-15',
    '2024-03-14',
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-0801484-0'), -- Dom Casmurro
    (SELECT id_usuario FROM biblioteca.Usuario WHERE cpf = '111.111.111-11')
),
(
    '2024-03-05 14:30:00',
    '2024-03-19',
    NULL, -- Empréstimo ativo
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3590001-7'), -- 1984
    (SELECT id_usuario FROM biblioteca.Usuario WHERE cpf = '222.222.222-22')
),
(
    '2024-03-10 09:15:00',
    '2024-03-24',
    '2024-03-24',
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3590000-0'), -- Orgulho e Preconceito
    (SELECT id_usuario FROM biblioteca.Usuario WHERE cpf = '111.111.111-11')
),
(
    '2024-03-12 11:00:00',
    '2024-03-26',
    NULL, -- Empréstimo ativo
    (SELECT id_livro FROM biblioteca.Livro WHERE isbn = '978-85-3250700-0'), -- A Hora da Estrela
    (SELECT id_usuario FROM biblioteca.Usuario WHERE cpf = '333.333.333-33')
);
