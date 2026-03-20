--- Script SQL para Criação do Banco de Dados da Biblioteca ---

-- Este script cria as tabelas para o sistema de biblioteca, definindo Chaves Primárias (PKs),
-- Restrições UNIQUE e Chaves Estrangeiras (FKs) conforme o Modelo Entidade-Relacionamento.

-- Criação do Schema (opcional, mas boa prática para organização)
CREATE SCHEMA biblioteca;

-- Tabela Editora
CREATE TABLE biblioteca.Editora (
    id_editora INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_editora VARCHAR(255) UNIQUE NOT NULL,
    pais_origem VARCHAR(100)
);

-- Tabela Autor
CREATE TABLE biblioteca.Autor (
    id_autor INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_autor VARCHAR(255) NOT NULL,
    data_nascimento DATE
);

-- Tabela Usuario
CREATE TABLE biblioteca.Usuario (
    id_usuario INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_completo VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    endereco VARCHAR(500),
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE NOT NULL
);

-- Tabela Livro
CREATE TABLE biblioteca.Livro (
    id_livro INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    titulo VARCHAR(500) NOT NULL,
    isbn VARCHAR(17) UNIQUE NOT NULL,
    ano_publicacao INT,
    id_editora INT NOT NULL,
    FOREIGN KEY (id_editora) REFERENCES biblioteca.Editora(id_editora)
);

-- Tabela Associativa Livro_Autor (para relacionamento N:M entre Livro e Autor)
CREATE TABLE biblioteca.Livro_Autor (
    id_livro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_livro, id_autor),
    FOREIGN KEY (id_livro) REFERENCES biblioteca.Livro(id_livro),
    FOREIGN KEY (id_autor) REFERENCES biblioteca.Autor(id_autor)
);

-- Tabela Emprestimo
CREATE TABLE biblioteca.Emprestimo (
    id_emprestimo INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_emprestimo TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_real DATE,
    id_livro INT NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_livro) REFERENCES biblioteca.Livro(id_livro),
    FOREIGN KEY (id_usuario) REFERENCES biblioteca.Usuario(id_usuario),
    CHECK (data_devolucao_real IS NULL OR data_devolucao_real >= data_emprestimo)
);
