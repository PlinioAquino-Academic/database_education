# Solução do Projeto de Banco de Dados Hospitalar

Esta solução apresenta um projeto de Banco de Dados, focado em um cenário de **Gestão Hospitalar**, com complexidade de relacionamentos e restrições. A solução inclui o Modelo Entidade-Relacionamento (MER), o Modelo Relacional (MR), scripts SQL para criação do banco de dados (padrões ANSI e Supabase/PostgreSQL) e exemplos de comandos de manipulação e seleção de dados.

---

## 1. Enunciado do Problema: Sistema de Gestão Hospitalar

Um hospital de médio porte deseja modernizar seu sistema de gestão, implementando um banco de dados robusto para gerenciar informações cruciais sobre pacientes, equipe médica, consultas, internações, prontuários eletrônicos, medicamentos e recursos hospitalares. O sistema deve ser capaz de:

*   **Gerenciar Pacientes:** Cada paciente possui um `ID` único, `nome completo`, `data de nascimento`, `CPF` (único), `endereço`, `telefone` e `plano de saúde`. É fundamental registrar a `data de cadastro` do paciente no sistema.

*   **Gerenciar Médicos:** Cada médico é identificado por um `ID` único, `nome completo`, `CRM` (único), `telefone` e `especialidade` (ex: Cardiologia, Pediatria, Cirurgia Geral). Um médico pode ter múltiplas especialidades, mas deve ter uma `especialidade principal`.

*   **Gerenciar Consultas:** As consultas são agendadas e possuem um `ID` único, `data` e `hora`. Cada consulta é realizada por **um único médico** e está associada a **um único paciente**. É necessário registrar o `status` da consulta (ex: Agendada, Realizada, Cancelada). Após a consulta, o médico deve registrar um `diagnóstico` e as `observações` pertinentes.

*   **Gerenciar Internações:** Uma internação possui um `ID` único, `data de entrada` e `data de saída` (pode ser nula se o paciente ainda estiver internado). Cada internação está associada a **um paciente** e a **uma ala hospitalar** específica. É necessário registrar o `motivo da internação`.

*   **Gerenciar Alas Hospitalares:** Cada ala possui um `ID` único, `nome da ala` (ex: UTI, Pediatria, Clínica Médica) e `capacidade máxima` de leitos.

*   **Gerenciar Prontuários Eletrônicos:** Cada paciente possui um `prontuário` eletrônico que registra seu histórico médico. Um prontuário é composto por `registros` (entidade fraca) que detalham eventos como `exames`, `prescrições de medicamentos`, `procedimentos` e `evoluções clínicas`. Cada registro de prontuário tem um `ID` único (dentro do prontuário), `data` e `descrição`. Um registro de prontuário pode estar associado a **um médico** que o realizou.

*   **Gerenciar Medicamentos:** Cada medicamento possui um `ID` único, `nome comercial`, `princípio ativo`, `dosagem` e `estoque atual`. Os medicamentos são `prescritos` pelos médicos aos pacientes durante as consultas ou internações. Uma prescrição deve registrar a `quantidade` e a `frequência` do medicamento.

*   **Relacionamentos Adicionais:**
    *   Um paciente pode ter **múltiplos planos de saúde** (relacionamento N:M com uma entidade `PlanoSaude`).
    *   Um médico pode ser responsável por **múltiplas internações** ao longo do tempo.

Chave Primária (PK): O "RG" único de cada registro que nunca pode ser nulo.
Restrição UNIQUE: Como garantir que outros dados (como CPF ou E-mail) não se repitam, mesmo não sendo a chave principal.
Chave Estrangeira (FK): O elo que conecta tabelas e garante a integridade referencial.
Chaves Compostas: Quando a combinação de dois ou mais campos forma uma identidade única.

---

## 2. Modelo Entidade-Relacionamento (MER)

O MER abaixo ilustra as entidades, seus atributos e os relacionamentos entre elas, com as respectivas cardinalidades.

![Diagrama MER Hospitalar](mer_hospitalar.png)

### Descrição das Entidades e Relacionamentos:

*   **Paciente**: Entidade central que armazena dados demográficos e de contato dos pacientes.
*   **Medico**: Entidade para informações dos profissionais de saúde, incluindo especialidade principal.
*   **Especialidade**: Entidade para categorizar as áreas de atuação dos médicos.
*   **Medico_Especialidade**: Tabela associativa para o relacionamento N:M entre `Medico` e `Especialidade`.
*   **Consulta**: Registra os agendamentos e atendimentos, associando um paciente e um médico.
*   **AlaHospitalar**: Entidade para as diferentes seções do hospital com sua capacidade.
*   **Internacao**: Detalha as internações dos pacientes em alas específicas.
*   **Prontuario**: Entidade que representa o prontuário eletrônico de cada paciente (relacionamento 1:1 com `Paciente`).
*   **RegistroProntuario**: Entidade fraca que detalha os eventos dentro de um prontuário, como exames e evoluções, associada a um médico.
*   **Medicamento**: Informações sobre os fármacos disponíveis no hospital.
*   **Prescricao**: Registra a prescrição de medicamentos, podendo estar ligada a uma consulta ou internação.
*   **PlanoSaude**: Entidade para os convênios de saúde.
*   **Paciente_PlanoSaude**: Tabela associativa para o relacionamento N:M entre `Paciente` e `PlanoSaude`.

---

## 3. Modelo Relacional (MR)

O Modelo Relacional, derivado do MER, define a estrutura das tabelas, suas chaves primárias (PK), chaves estrangeiras (FK) e atributos.

*   **Paciente** (`id_paciente` PK, `nome_completo`, `data_nascimento`, `cpf` UNIQUE, `endereco`, `telefone`, `data_cadastro`)
*   **Medico** (`id_medico` PK, `nome_completo`, `crm` UNIQUE, `telefone`, `especialidade_principal`)
*   **Especialidade** (`id_especialidade` PK, `nome_especialidade` UNIQUE)
*   **Medico_Especialidade** (`id_medico` FK PK, `id_especialidade` FK PK)
*   **Consulta** (`id_consulta` PK, `data_hora`, `status`, `diagnostico`, `observacoes`, `id_medico` FK, `id_paciente` FK)
*   **AlaHospitalar** (`id_ala` PK, `nome_ala` UNIQUE, `capacidade_maxima`)
*   **Internacao** (`id_internacao` PK, `data_entrada`, `data_saida`, `motivo`, `id_paciente` FK, `id_ala` FK)
*   **Prontuario** (`id_prontuario` PK, `id_paciente` FK UNIQUE)
*   **RegistroProntuario** (`id_registro` PK, `id_prontuario` FK PK, `data_registro`, `descricao`, `id_medico` FK)
*   **Medicamento** (`id_medicamento` PK, `nome_comercial` UNIQUE, `principio_ativo`, `dosagem`, `estoque_atual`)
*   **Prescricao** (`id_prescricao` PK, `quantidade`, `frequencia`, `id_medicamento` FK, `id_consulta` FK, `id_internacao` FK)
*   **PlanoSaude** (`id_plano` PK, `nome_plano` UNIQUE, `cnpj` UNIQUE)
*   **Paciente_PlanoSaude** (`id_paciente` FK PK, `id_plano` FK PK)

---

## 4. Scripts SQL - Padrão ANSI

Os scripts a seguir estão em conformidade com o padrão ANSI SQL, garantindo compatibilidade com a maioria dos sistemas de gerenciamento de banco de dados relacionais.

### Criação das Tabelas (DDL)
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

---

## 5. Scripts SQL - Padrão Supabase (PostgreSQL)

O Supabase utiliza o PostgreSQL como seu banco de dados, que é altamente compatível com o padrão ANSI SQL. No entanto, o ecossistema Supabase incentiva e facilita o uso de algumas extensões e práticas recomendadas do PostgreSQL que não fazem parte do padrão ANSI estrito. As principais diferenças e adições são destacadas abaixo.

### Criação das Tabelas (DDL para Supabase/PostgreSQL)

As maiores mudanças incluem o uso do tipo `TEXT` para strings de comprimento variável, a adição de colunas de auditoria como `created_at`, e a utilização de `UUID` como chave primária, que é uma prática comum em aplicações web modernas para evitar a exposição de IDs sequenciais.

```sql
-- Criação do Schema (se não existir)
CREATE SCHEMA IF NOT EXISTS hospital;

-- Tabela Paciente
CREATE TABLE hospital.Paciente (
    id_paciente UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome_completo TEXT NOT NULL,
    data_nascimento DATE NOT NULL,
    cpf TEXT UNIQUE NOT NULL,
    endereco TEXT,
    telefone TEXT,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela Medico
CREATE TABLE hospital.Medico (
    id_medico UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome_completo TEXT NOT NULL,
    crm TEXT UNIQUE NOT NULL,
    telefone TEXT,
    especialidade_principal TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela Especialidade
CREATE TABLE hospital.Especialidade (
    id_especialidade SERIAL PRIMARY KEY, -- SERIAL é um atalho comum no PostgreSQL
    nome_especialidade TEXT UNIQUE NOT NULL
);

-- Tabela Associativa Medico_Especialidade
CREATE TABLE hospital.Medico_Especialidade (
    id_medico UUID NOT NULL REFERENCES hospital.Medico(id_medico) ON DELETE CASCADE,
    id_especialidade INT NOT NULL REFERENCES hospital.Especialidade(id_especialidade) ON DELETE CASCADE,
    PRIMARY KEY (id_medico, id_especialidade)
);

-- Tabela Consulta
CREATE TABLE hospital.Consulta (
    id_consulta UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data_hora TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL CHECK (status IN (
        'Agendada',
        'Realizada',
        'Cancelada'
    )),
    diagnostico TEXT,
    observacoes TEXT,
    id_medico UUID NOT NULL REFERENCES hospital.Medico(id_medico),
    id_paciente UUID NOT NULL REFERENCES hospital.Paciente(id_paciente),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela AlaHospitalar
CREATE TABLE hospital.AlaHospitalar (
    id_ala SERIAL PRIMARY KEY,
    nome_ala TEXT UNIQUE NOT NULL,
    capacidade_maxima INT NOT NULL CHECK (capacidade_maxima > 0)
);

-- Tabela Internacao
CREATE TABLE hospital.Internacao (
    id_internacao UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data_entrada DATE NOT NULL,
    data_saida DATE,
    motivo TEXT NOT NULL,
    id_paciente UUID NOT NULL REFERENCES hospital.Paciente(id_paciente),
    id_ala INT NOT NULL REFERENCES hospital.AlaHospitalar(id_ala),
    created_at TIMESTAMPTZ DEFAULT now(),
    CHECK (data_saida IS NULL OR data_saida >= data_entrada)
);

-- Tabela Prontuario
CREATE TABLE hospital.Prontuario (
    id_prontuario UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_paciente UUID UNIQUE NOT NULL REFERENCES hospital.Paciente(id_paciente) ON DELETE CASCADE
);

-- Tabela RegistroProntuario
CREATE TABLE hospital.RegistroProntuario (
    id_registro BIGSERIAL PRIMARY KEY, -- Usando BIGSERIAL para a chave primária simples
    id_prontuario UUID NOT NULL REFERENCES hospital.Prontuario(id_prontuario) ON DELETE CASCADE,
    data_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    descricao TEXT NOT NULL,
    id_medico UUID REFERENCES hospital.Medico(id_medico),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tabela Medicamento
CREATE TABLE hospital.Medicamento (
    id_medicamento SERIAL PRIMARY KEY,
    nome_comercial TEXT UNIQUE NOT NULL,
    principio_ativo TEXT NOT NULL,
    dosagem TEXT NOT NULL,
    estoque_atual INT NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0)
);

-- Tabela Prescricao
CREATE TABLE hospital.Prescricao (
    id_prescricao UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    frequencia TEXT NOT NULL,
    id_medicamento INT NOT NULL REFERENCES hospital.Medicamento(id_medicamento),
    id_consulta UUID REFERENCES hospital.Consulta(id_consulta),
    id_internacao UUID REFERENCES hospital.Internacao(id_internacao),
    created_at TIMESTAMPTZ DEFAULT now(),
    CHECK (id_consulta IS NOT NULL OR id_internacao IS NOT NULL)
);

-- Tabela PlanoSaude
CREATE TABLE hospital.PlanoSaude (
    id_plano SERIAL PRIMARY KEY,
    nome_plano TEXT UNIQUE NOT NULL,
    cnpj TEXT UNIQUE NOT NULL
);

-- Tabela Associativa Paciente_PlanoSaude
CREATE TABLE hospital.Paciente_PlanoSaude (
    id_paciente UUID NOT NULL REFERENCES hospital.Paciente(id_paciente) ON DELETE CASCADE,
    id_plano INT NOT NULL REFERENCES hospital.PlanoSaude(id_plano) ON DELETE CASCADE,
    PRIMARY KEY (id_paciente, id_plano)
);

-- Exemplo de Habilitação de Row Level Security (RLS)
-- Esta é uma funcionalidade poderosa do Supabase/PostgreSQL para segurança de dados.

-- 1. Habilitar RLS na tabela de pacientes
ALTER TABLE hospital.Paciente ENABLE ROW LEVEL SECURITY;

-- 2. Criar uma política que permite aos usuários (médicos) verem apenas seus próprios pacientes
-- (Isso assume uma lógica de aplicação mais complexa, onde o `auth.uid()` corresponde a um ID de médico)
CREATE POLICY select_pacientes_para_medicos ON hospital.Paciente
FOR SELECT
USING (EXISTS (
    SELECT 1 FROM hospital.Consulta c
    WHERE c.id_paciente = Paciente.id_paciente
    AND c.id_medico = auth.uid() -- auth.uid() é uma função do Supabase que retorna o ID do usuário autenticado
));
```

### Tabela Comparativa: ANSI SQL vs. Supabase (PostgreSQL)

| Característica | Padrão ANSI SQL | Supabase (PostgreSQL) |
| :--- | :--- | :--- |
| **Chaves Primárias** | `INTEGER` ou `BIGINT` com `GENERATED ALWAYS AS IDENTITY`. | Frequentemente se utiliza `UUID` com `gen_random_uuid()` para chaves primárias, evitando colisões em sistemas distribuídos e não expondo a contagem de registros. O tipo `SERIAL` também é uma alternativa popular e mais concisa. |
| **Tipos de Dados de Texto** | `VARCHAR(n)` com tamanho definido. | O tipo `TEXT` é geralmente preferido, pois não há diferença de desempenho em relação ao `VARCHAR` e oferece comprimento ilimitado, simplificando o desenvolvimento. |
| **Tipos de Dados de Data/Hora** | `TIMESTAMP` e `DATE`. | `TIMESTAMPTZ` (`TIMESTAMP WITH TIME ZONE`) é fortemente recomendado para armazenar data e hora com informação de fuso horário, crucial para aplicações globais. |
| **Segurança de Acesso** | Gerenciada principalmente por `GRANT` e `REVOKE` em nível de tabela/coluna para roles de banco de dados. | Oferece **Row-Level Security (RLS)**, que permite definir políticas de acesso por linha. Isso é integrado ao sistema de autenticação do Supabase (`auth`), permitindo, por exemplo, que um usuário veja apenas seus próprios dados. |
| **Esquemas** | O conceito de schema existe, mas seu uso e nomenclatura (`dbo`, `public`, etc.) variam entre os SGBDs. | O uso do schema `public` é o padrão, mas a criação de schemas customizados (`hospital` neste caso) é uma prática comum e bem suportada para organizar o banco de dados. |
| **Extensões e Funções** | O padrão não define um sistema de extensões. | O PostgreSQL possui um rico ecossistema de extensões. O Supabase já vem com várias habilitadas por padrão, como `uuid-ossp` (que provê `uuid_generate_v4()`) e `pgcrypto` (que provê `gen_random_uuid()`). |

---

## 6. Exemplos de Comandos SQL (DML e DQL)

Para demonstrar a manipulação e consulta de dados no cenário hospitalar, serão apresentados exemplos de comandos `INSERT`, `UPDATE`, `DELETE` e `SELECT` complexos.

### 6.1. Comandos de Manipulação de Dados (DML)

#### INSERT (Exemplo para cada tabela)

```sql
-- Inserir um Paciente
INSERT INTO hospital.Paciente (nome_completo, data_nascimento, cpf, endereco, telefone)
VALUES (
    'Maria Silva',
    '1980-05-20',
    '111.222.333-44',
    'Rua das Flores, 123, Centro, Cidade - UF',
    '(11) 98765-4321'
);

-- Inserir um Médico
INSERT INTO hospital.Medico (nome_completo, crm, telefone, especialidade_principal)
VALUES (
    'Dr. João Santos',
    'CRM/SP 123456',
    '(11) 91234-5678',
    'Cardiologia'
);

-- Inserir uma Especialidade
INSERT INTO hospital.Especialidade (nome_especialidade)
VALUES ('Cardiologia');

-- Associar Médico a Especialidade
INSERT INTO hospital.Medico_Especialidade (id_medico, id_especialidade)
VALUES (
    (SELECT id_medico FROM hospital.Medico WHERE crm = 'CRM/SP 123456'),
    (SELECT id_especialidade FROM hospital.Especialidade WHERE nome_especialidade = 'Cardiologia')
);

-- Inserir uma Consulta
INSERT INTO hospital.Consulta (data_hora, status, id_medico, id_paciente)
VALUES (
    '2024-03-15 10:00:00',
    'Agendada',
    (SELECT id_medico FROM hospital.Medico WHERE crm = 'CRM/SP 123456'),
    (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44')
);

-- Inserir uma Ala Hospitalar
INSERT INTO hospital.AlaHospitalar (nome_ala, capacidade_maxima)
VALUES ('UTI Adulto', 10);

-- Inserir uma Internação
INSERT INTO hospital.Internacao (data_entrada, motivo, id_paciente, id_ala)
VALUES (
    '2024-03-12',
    'Infarto Agudo do Miocárdio',
    (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44'),
    (SELECT id_ala FROM hospital.AlaHospitalar WHERE nome_ala = 'UTI Adulto')
);

-- Inserir um Prontuário (associado ao paciente)
INSERT INTO hospital.Prontuario (id_paciente)
VALUES (
    (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44')
);

-- Inserir um Registro de Prontuário
INSERT INTO hospital.RegistroProntuario (id_registro, id_prontuario, data_registro, descricao, id_medico)
VALUES (
    1, -- Primeiro registro para este prontuário
    (SELECT id_prontuario FROM hospital.Prontuario WHERE id_paciente = (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44')),
    '2024-03-12',
    'Paciente admitido com dor torácica intensa. Iniciado protocolo de IAM.',
    (SELECT id_medico FROM hospital.Medico WHERE crm = 'CRM/SP 123456')
);

-- Inserir um Medicamento
INSERT INTO hospital.Medicamento (nome_comercial, principio_ativo, dosagem, estoque_atual)
VALUES ('Aspirina', 'Ácido Acetilsalicílico', '100mg', 500);

-- Inserir uma Prescrição (associada a uma internação)
INSERT INTO hospital.Prescricao (quantidade, frequencia, id_medicamento, id_internacao)
VALUES (
    1,
    '1x ao dia',
    (SELECT id_medicamento FROM hospital.Medicamento WHERE nome_comercial = 'Aspirina'),
    (SELECT id_internacao FROM hospital.Internacao WHERE id_paciente = (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44') AND data_saida IS NULL)
);

-- Inserir um Plano de Saúde
INSERT INTO hospital.PlanoSaude (nome_plano, cnpj)
VALUES ('Saúde Mais', '00.111.222/0001-33');

-- Associar Paciente a Plano de Saúde
INSERT INTO hospital.Paciente_PlanoSaude (id_paciente, id_plano)
VALUES (
    (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44'),
    (SELECT id_plano FROM hospital.PlanoSaude WHERE nome_plano = 'Saúde Mais')
);
```

#### UPDATE

```sql
-- Atualizar o status de uma consulta para 'Realizada'
UPDATE hospital.Consulta
SET status = 'Realizada',
    diagnostico = 'Angina estável',
    observacoes = 'Recomendado acompanhamento ambulatorial e medicação contínua.'
WHERE id_consulta = (SELECT id_consulta FROM hospital.Consulta WHERE id_paciente = (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44') AND status = 'Agendada');

-- Atualizar o estoque de um medicamento após uma prescrição (exemplo)
UPDATE hospital.Medicamento
SET estoque_atual = estoque_atual - 1 -- Supondo que 1 unidade foi prescrita
WHERE nome_comercial = 'Aspirina';

-- Registrar a data de saída de uma internação
UPDATE hospital.Internacao
SET data_saida = '2024-03-18'
WHERE id_paciente = (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44') AND data_saida IS NULL;
```

#### DELETE

```sql
-- Excluir um registro de prontuário (exemplo: registro incorreto)
DELETE FROM hospital.RegistroProntuario
WHERE id_registro = 1 AND id_prontuario = (SELECT id_prontuario FROM hospital.Prontuario WHERE id_paciente = (SELECT id_paciente FROM hospital.Paciente WHERE cpf = '111.222.333-44'));
```

### 6.2. Comandos de Seleção de Dados (DQL)

#### Consultas Complexas

```sql
-- 1. Listar pacientes internados em uma ala específica (ex: 'UTI Adulto'), incluindo a data de entrada.
SELECT
    p.nome_completo AS Paciente,
    p.cpf AS CPF_Paciente,
    i.data_entrada AS Data_Entrada_Internacao,
    ah.nome_ala AS Ala_Internacao
FROM
    hospital.Paciente p
JOIN
    hospital.Internacao i ON p.id_paciente = i.id_paciente
JOIN
    hospital.AlaHospitalar ah ON i.id_ala = ah.id_ala
WHERE
    ah.nome_ala = 'UTI Adulto' AND i.data_saida IS NULL;

-- 2. Contar o número de consultas realizadas por cada médico em um período específico (ex: Março de 2024).
SELECT
    m.nome_completo AS Medico,
    m.especialidade_principal AS Especialidade,
    COUNT(c.id_consulta) AS Total_Consultas_Realizadas
FROM
    hospital.Medico m
LEFT JOIN
    hospital.Consulta c ON m.id_medico = c.id_medico
WHERE
    c.status = 'Realizada' AND c.data_hora BETWEEN '2024-03-01 00:00:00' AND '2024-03-31 23:59:59'
GROUP BY
    m.nome_completo, m.especialidade_principal
HAVING
    COUNT(c.id_consulta) > 0 -- Opcional: mostrar apenas médicos com consultas realizadas
ORDER BY
    Total_Consultas_Realizadas DESC;

-- 3. Encontrar os medicamentos com estoque abaixo de um limite (ex: 50 unidades).
SELECT
    med.nome_comercial AS Medicamento,
    med.principio_ativo AS Principio_Ativo,
    med.dosagem AS Dosagem,
    med.estoque_atual AS Estoque_Atual
FROM
    hospital.Medicamento med
WHERE
    med.estoque_atual < 50
ORDER BY
    med.estoque_atual ASC;

-- 4. Listar o histórico de prontuário de um paciente específico (ex: 'Maria Silva'), incluindo o médico responsável por cada registro.
SELECT
    p.nome_completo AS Paciente,
    rp.data_registro AS Data_Registro,
    rp.descricao AS Descricao_Registro,
    COALESCE(m.nome_completo, 'Não Informado') AS Medico_Responsavel
FROM
    hospital.Paciente p
JOIN
    hospital.Prontuario pr ON p.id_paciente = pr.id_paciente
JOIN
    hospital.RegistroProntuario rp ON pr.id_prontuario = rp.id_prontuario
LEFT JOIN
    hospital.Medico m ON rp.id_medico = m.id_medico
WHERE
    p.cpf = '111.222.333-44'
ORDER BY
    rp.data_registro ASC;

-- 5. Médicos que atenderam mais de 1 paciente em um mês específico (ex: Março de 2024).
SELECT
    m.nome_completo AS Medico,
    m.especialidade_principal AS Especialidade,
    COUNT(DISTINCT c.id_paciente) AS Pacientes_Atendidos
FROM
    hospital.Medico m
JOIN
    hospital.Consulta c ON m.id_medico = c.id_medico
WHERE
    c.data_hora BETWEEN '2024-03-01 00:00:00' AND '2024-03-31 23:59:59'
GROUP BY
    m.nome_completo, m.especialidade_principal
HAVING
    COUNT(DISTINCT c.id_paciente) > 1
ORDER BY
    Pacientes_Atendidos DESC;
```
