-- Tabela de Endereços
CREATE TABLE Enderecos (
    id_endereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(200) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Pacientes
CREATE TABLE Pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    rg VARCHAR(20),
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    telefone VARCHAR(15),
    celular VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    id_endereco INT,
    tipo_sanguineo VARCHAR(3) CHECK (tipo_sanguineo IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    alergias TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_endereco) REFERENCES Enderecos(id_endereco)
);

-- Tabela de Especialidades Médicas
CREATE TABLE Especialidades (
    id_especialidade SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Médicos
CREATE TABLE Medicos (
    id_medico SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    crm VARCHAR(20) UNIQUE NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    telefone VARCHAR(15),
    celular VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    id_especialidade INT NOT NULL,
    id_endereco INT,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_especialidade) REFERENCES Especialidades(id_especialidade),
    FOREIGN KEY (id_endereco) REFERENCES Enderecos(id_endereco)
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    rg VARCHAR(20),
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    telefone VARCHAR(15),
    celular VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2),
    data_admissao DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    id_endereco INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_endereco) REFERENCES Enderecos(id_endereco)
);

-- Tabela de Consultórios
CREATE TABLE Consultorios (
    id_consultorio SERIAL PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    andar VARCHAR(10),
    descricao TEXT,
    equipamentos TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Agendamentos
CREATE TABLE Agendamentos (
    id_agendamento SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_consultorio INT NOT NULL,
    data_agendamento TIMESTAMP NOT NULL,
    duracao_estimada INT DEFAULT 30,
    tipo_consulta VARCHAR(20) CHECK (tipo_consulta IN ('Consulta', 'Retorno', 'Exame', 'Cirurgia')) DEFAULT 'Consulta',
    status VARCHAR(20) CHECK (status IN ('Agendado', 'Confirmado', 'Em Andamento', 'Concluído', 'Cancelado', 'Falta')) DEFAULT 'Agendado',
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico),
    FOREIGN KEY (id_consultorio) REFERENCES Consultorios(id_consultorio)
);

-- Tabela de Prontuários
CREATE TABLE Prontuarios (
    id_prontuario SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_consulta TIMESTAMP NOT NULL,
    anamnese TEXT,
    diagnostico TEXT,
    prescricao_medicamentos TEXT,
    exames_solicitados TEXT,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico)
);

-- Tabela de Exames
CREATE TABLE Exames (
    id_exame SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    preparo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Solicitações de Exame
CREATE TABLE SolicitacoesExame (
    id_solicitacao SERIAL PRIMARY KEY,
    id_prontuario INT NOT NULL,
    id_exame INT NOT NULL,
    data_solicitacao TIMESTAMP NOT NULL,
    data_realizacao TIMESTAMP,
    laboratorio VARCHAR(200),
    resultado TEXT,
    status VARCHAR(20) CHECK (status IN ('Solicitado', 'Agendado', 'Realizado', 'Cancelado')) DEFAULT 'Solicitado',
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_prontuario) REFERENCES Prontuarios(id_prontuario),
    FOREIGN KEY (id_exame) REFERENCES Exames(id_exame)
);

-- Tabela de Pagamentos
CREATE TABLE Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_agendamento INT NOT NULL,
    valor_consulta DECIMAL(10,2) NOT NULL,
    valor_desconto DECIMAL(10,2) DEFAULT 0,
    valor_total DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(20) CHECK (forma_pagamento IN ('Dinheiro', 'Cartão Débito', 'Cartão Crédito', 'PIX', 'Convênio')) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pendente', 'Pago', 'Cancelado')) DEFAULT 'Pendente',
    data_pagamento TIMESTAMP,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_agendamento) REFERENCES Agendamentos(id_agendamento)
);

-- Tabela de Convênios
CREATE TABLE Convenios (
    id_convenio SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL UNIQUE,
    cnpj VARCHAR(14) UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Relacionamento Paciente-Convênio
CREATE TABLE PacienteConvenio (
    id_paciente INT,
    id_convenio INT,
    numero_carteira VARCHAR(50),
    validade DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_paciente, id_convenio),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id_convenio)
);

-- Inserir dados de exemplo
INSERT INTO Especialidades (nome, descricao) VALUES
('Cardiologia', 'Especialidade médica que trata do coração e do sistema cardiovascular'),
('Dermatologia', 'Especialidade médica que trata da pele, cabelos e unhas'),
('Pediatria', 'Especialidade médica dedicada à saúde infantil'),
('Ortopedia', 'Especialidade médica que trata do sistema musculoesquelético'),
('Ginecologia', 'Especialidade médica que trata da saúde da mulher');

INSERT INTO Consultorios (numero, andar, descricao) VALUES
('101', '1º', 'Consultório geral'),
('102', '1º', 'Consultório para exames'),
('201', '2º', 'Consultório de pediatria'),
('202', '2º', 'Consultório de ginecologia'),
('301', '3º', 'Consultório de ortopedia');

-- Criar índices para melhor performance
CREATE INDEX idx_pacientes_cpf ON Pacientes(cpf);
CREATE INDEX idx_medicos_crm ON Medicos(crm);
CREATE INDEX idx_agendamentos_data ON Agendamentos(data_agendamento);
CREATE INDEX idx_agendamentos_status ON Agendamentos(status);
CREATE INDEX idx_prontuarios_paciente ON Prontuarios(id_paciente);
CREATE INDEX idx_prontuarios_data ON Prontuarios(data_consulta);