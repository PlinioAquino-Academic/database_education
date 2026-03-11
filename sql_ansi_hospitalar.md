```sql
-- Criação do Schema (opcional em alguns SGBDs ANSI, mas boa prática para organização)
CREATE SCHEMA hospital;

-- Tabela Paciente
CREATE TABLE hospital.Paciente (
    id_paciente INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_completo VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    endereco VARCHAR(500),
    telefone VARCHAR(20),
    data_cadastro DATE DEFAULT CURRENT_DATE NOT NULL
);

-- Tabela Medico
CREATE TABLE hospital.Medico (
    id_medico INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_completo VARCHAR(255) NOT NULL,
    crm VARCHAR(15) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    especialidade_principal VARCHAR(100) NOT NULL
);

-- Tabela Especialidade
CREATE TABLE hospital.Especialidade (
    id_especialidade INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_especialidade VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela Associativa Medico_Especialidade (para relacionamento N:M entre Medico e Especialidade)
CREATE TABLE hospital.Medico_Especialidade (
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    PRIMARY KEY (id_medico, id_especialidade),
    FOREIGN KEY (id_medico) REFERENCES hospital.Medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES hospital.Especialidade(id_especialidade)
);

-- Tabela Consulta
CREATE TABLE hospital.Consulta (
    id_consulta INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN (
        'Agendada',
        'Realizada',
        'Cancelada'
    )),
    diagnostico VARCHAR(1000),
    observacoes VARCHAR(1000),
    id_medico INT NOT NULL,
    id_paciente INT NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES hospital.Medico(id_medico),
    FOREIGN KEY (id_paciente) REFERENCES hospital.Paciente(id_paciente)
);

-- Tabela AlaHospitalar
CREATE TABLE hospital.AlaHospitalar (
    id_ala INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_ala VARCHAR(100) UNIQUE NOT NULL,
    capacidade_maxima INT NOT NULL CHECK (capacidade_maxima > 0)
);

-- Tabela Internacao
CREATE TABLE hospital.Internacao (
    id_internacao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_entrada DATE NOT NULL,
    data_saida DATE,
    motivo VARCHAR(500) NOT NULL,
    id_paciente INT NOT NULL,
    id_ala INT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.Paciente(id_paciente),
    FOREIGN KEY (id_ala) REFERENCES hospital.AlaHospitalar(id_ala),
    CHECK (data_saida IS NULL OR data_saida >= data_entrada)
);

-- Tabela Prontuario (relacionamento 1:1 com Paciente)
CREATE TABLE hospital.Prontuario (
    id_prontuario INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    id_paciente INT UNIQUE NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.Paciente(id_paciente)
);

-- Tabela RegistroProntuario (entidade fraca)
CREATE TABLE hospital.RegistroProntuario (
    id_registro INT NOT NULL,
    id_prontuario INT NOT NULL,
    data_registro DATE DEFAULT CURRENT_DATE NOT NULL,
    descricao VARCHAR(2000) NOT NULL,
    id_medico INT,
    PRIMARY KEY (id_registro, id_prontuario),
    FOREIGN KEY (id_prontuario) REFERENCES hospital.Prontuario(id_prontuario),
    FOREIGN KEY (id_medico) REFERENCES hospital.Medico(id_medico)
);

-- Tabela Medicamento
CREATE TABLE hospital.Medicamento (
    id_medicamento INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_comercial VARCHAR(255) UNIQUE NOT NULL,
    principio_ativo VARCHAR(255) NOT NULL,
    dosagem VARCHAR(100) NOT NULL,
    estoque_atual INT NOT NULL CHECK (estoque_atual >= 0)
);

-- Tabela Prescricao
CREATE TABLE hospital.Prescricao (
    id_prescricao INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    frequencia VARCHAR(255) NOT NULL,
    id_medicamento INT NOT NULL,
    id_consulta INT,
    id_internacao INT,
    FOREIGN KEY (id_medicamento) REFERENCES hospital.Medicamento(id_medicamento),
    FOREIGN KEY (id_consulta) REFERENCES hospital.Consulta(id_consulta),
    FOREIGN KEY (id_internacao) REFERENCES hospital.Internacao(id_internacao),
    CHECK (id_consulta IS NOT NULL OR id_internacao IS NOT NULL) -- Deve estar associada a uma consulta OU internação
);

-- Tabela PlanoSaude
CREATE TABLE hospital.PlanoSaude (
    id_plano INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nome_plano VARCHAR(255) UNIQUE NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL
);

-- Tabela Associativa Paciente_PlanoSaude (para relacionamento N:M entre Paciente e PlanoSaude)
CREATE TABLE hospital.Paciente_PlanoSaude (
    id_paciente INT NOT NULL,
    id_plano INT NOT NULL,
    PRIMARY KEY (id_paciente, id_plano),
    FOREIGN KEY (id_paciente) REFERENCES hospital.Paciente(id_paciente),
    FOREIGN KEY (id_plano) REFERENCES hospital.PlanoSaude(id_plano)
);
```
