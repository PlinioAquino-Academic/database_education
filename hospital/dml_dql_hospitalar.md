## 5. Exemplos de Comandos SQL (DML e DQL)

Para demonstrar a manipulação e consulta de dados no cenário hospitalar, serão apresentados exemplos de comandos `INSERT`, `UPDATE`, `DELETE` e `SELECT` complexos.

### 5.1. Comandos de Manipulação de Dados (DML)

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

### 5.2. Comandos de Seleção de Dados (DQL)

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
