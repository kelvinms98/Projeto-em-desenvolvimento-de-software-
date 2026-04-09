CREATE table if NOT EXISTS velluto_motors ()
index idx_slug (slug)
index isx_status (status)
.)engine=innodb;
CREATE DATABASE IF NOT EXISTS luxury_cars 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE luxury_cars;

-- 1. Marcas de luxo
CREATE TABLE marcas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    pais_origem VARCHAR(50),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Modelos de carros
CREATE TABLE modelos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marca_id INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    ano_base YEAR NOT NULL,
    preco_base DECIMAL(12,2) NOT NULL,
    motor VARCHAR(100),
    potencia_cv INT,
    tipo_carrocaria ENUM('Sedan', 'SUV', 'Coupe', 'Convertible', 'Hypercar') NOT NULL,
    FOREIGN KEY (marca_id) REFERENCES marcas(id) ON DELETE RESTRICT
);

-- 3. Carros em estoque (unidades específicas)
CREATE TABLE carros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    modelo_id INT NOT NULL,
    vin VARCHAR(17) UNIQUE, -- Vehicle Identification Number
    cor VARCHAR(40) NOT NULL,
    ano_fabricacao YEAR NOT NULL,
    preco_venda DECIMAL(12,2) NOT NULL,
    quilometragem INT DEFAULT 0,
    status ENUM('Em Estoque', 'Reservado', 'Vendido', 'Em Manutenção') DEFAULT 'Em Estoque',
    data_entrada DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (modelo_id) REFERENCES modelos(id) ON DELETE RESTRICT
);

-- 4. Vendedores
CREATE TABLE vendedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_admissao DATE NOT NULL,
    salario_base DECIMAL(10,2) DEFAULT 8000.00,
    comissao_percentual DECIMAL(5,2) DEFAULT 2.50, -- % sobre vendas
    status ENUM('Ativo', 'Inativo', 'Férias') DEFAULT 'Ativo',
    INDEX idx_vendedor_nome (nome)
);

-- 5. Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco TEXT,
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    tipo_cliente ENUM('Pessoa Física', 'Empresa') DEFAULT 'Pessoa Física'
);

-- 6. Vendas
CREATE TABLE vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    carro_id INT NOT NULL,
    cliente_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_venda DECIMAL(12,2) NOT NULL,
    forma_pagamento ENUM('À Vista', 'Financiamento', 'Troca + Dinheiro') NOT NULL,
    status ENUM('Concluída', 'Cancelada', 'Em Processamento') DEFAULT 'Concluída',
    FOREIGN KEY (carro_id) REFERENCES carros(id) ON DELETE RESTRICT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id) ON DELETE RESTRICT
);

-- 7. Comissão por venda (para auditoria)
CREATE TABLE comissoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venda_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    valor_comissao DECIMAL(10,2) NOT NULL,
    data_calculo DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (venda_id) REFERENCES vendas(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(id)
);

-- Marcas de luxo
INSERT INTO marcas (nome, pais_origem) VALUES
('Ferrari', 'Itália'),
('Lamborghini', 'Itália'),
('Porsche', 'Alemanha'),
('Rolls-Royce', 'Reino Unido'),
('Bentley', 'Reino Unido');

-- Modelos
INSERT INTO modelos (marca_id, nome, ano_base, preco_base, motor, potencia_cv, tipo_carrocaria) VALUES
(1, '488 Pista', 2023, 1450000.00, 'V8 Biturbo', 720, 'Coupe'),
(2, 'Huracán STO', 2024, 1850000.00, 'V10', 640, 'Coupe'),
(3, '911 Turbo S', 2025, 980000.00, 'Flat-6 Biturbo', 650, 'Coupe'),
(4, 'Phantom VIII', 2024, 3200000.00, 'V12', 563, 'Sedan');

-- Vendedores
INSERT INTO vendedores (nome, cpf, email, telefone, data_admissao, salario_base, comissao_percentual) VALUES
('Lucas Mendes', '123.456.789-01', 'lucas@luxurycars.com.br', '(11) 99999-1111', '2023-01-15', 12000.00, 3.50),
('Amanda Ferrari', '987.654.321-00', 'amanda@luxurycars.com.br', '(11) 98888-2222', '2022-06-01', 11000.00, 3.00),
('Rafael Santos', '456.789.123-45', 'rafael@luxurycars.com.br', '(11) 97777-3333', '2024-01-10', 9500.00, 2.80);

- Marcas
INSERT INTO marcas (nome, pais_origem) VALUES
('Porsche', 'Alemanha'),
('Ferrari', 'Itália'),
('Rolls-Royce', 'Reino Unido'),
('Mercedes-Benz', 'Alemanha'),
('BMW', 'Alemanha'),
('Lamborghini', 'Itália');

-- Veículos em estoque (março 2026)
INSERT INTO veiculos (id_marca, modelo, versao, ano, cor, combustivel, quilometragem, preco_compra, preco_venda, status, data_entrada, chassi) VALUES
(1, '911 Carrera', 'Turbo S', 2025, 'Guards Red', 'Gasolina', 0, 1850000.00, 2450000.00, 'EM_ESTOQUE', '2026-02-10', 'WP0ZZZ99ZRS123456'),
(2, 'SF90 Spider', 'Stradale', 2025, 'Rosso Corsa', 'Híbrido', 150, 3200000.00, 4200000.00, 'EM_ESTOQUE', '2026-01-15', 'ZFF90XXX123456789'),
(3, 'Cullinan', 'Black Badge', 2024, 'Black Diamond', 'Gasolina', 800, 2800000.00, 3490000.00, 'EM_ESTOQUE', '2026-03-01', 'SCAUD123456789012'),
(4, 'G 63 AMG', '4x4 Squared', 2025, 'Matte Black', 'Gasolina', 0, 2100000.00, 2790000.00, 'EM_ESTOQUE', '2026-02-20', 'W1NYC123456789012');

 1. Estoque atual (veículos disponíveis)
SELECT 
    m.nome AS Marca,
    v.modelo,
    v.versao,
    v.ano,
    v.cor,
    v.quilometragem,
    v.preco_venda AS Preco,
    v.status
FROM veiculos v
JOIN marcas m ON v.id_marca = m.id_marca
WHERE v.status = 'EM_ESTOQUE'
ORDER BY v.preco_venda DESC;

-- 2. Veículos com valor total em estoque
SELECT 
    COUNT(*) AS Total_Veiculos,
    SUM(preco_venda) AS Valor_Total_Estoque
FROM veiculos 
WHERE status = 'EM_ESTOQUE';

-- 3. Histórico de movimentações de um veículo específico
SELECT 
    mv.data_movimentacao,
    mv.tipo,
    mv.descricao,
    v.modelo
FROM movimentacoes_veiculo mv
JOIN veiculos v ON mv.id_veiculo = v.id_veiculo
WHERE v.id_veiculo = 1
ORDER BY mv.data_movimentacao DESC;

-- 4. Agendamentos de test drive para os próximos dias
SELECT 
    a.data_horario,
    c.nome AS Cliente,
    m.nome AS Marca,
    v.modelo,
    a.status
FROM agendamentos_test_drive a
JOIN veiculos v ON a.id_veiculo = v.id_veiculo
JOIN marcas m ON v.id_marca = m.id_marca
LEFT JOIN clientes c ON a.id_cliente = c.id_cliente
WHERE a.data_horario >= CURRENT_DATE
ORDER BY a.data_horario;
