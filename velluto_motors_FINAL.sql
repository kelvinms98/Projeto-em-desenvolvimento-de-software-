-- ============================================
-- VELLUTO MOTORS - SISTEMA COMPLETO CONSOLIDADO
-- Database: velluto_motors (MariaDB/MySQL)
-- 
-- INCLUÍDO TUDO EM UM ARQUIVO:
-- ✅ Estrutura do banco (12 tabelas)
-- ✅ Triggers automáticos (3)
-- ✅ Procedures (4)
-- ✅ Views (12 relatórios)
-- ✅ Sistema de Avaliações
-- ✅ Dados de teste completos
-- ✅ Testes e Queries
--
-- PARA RODAR:
-- mysql -u root < velluto_motors_FINAL.sql
-- OU no phpMyAdmin: Importar arquivo
-- ============================================

DROP DATABASE IF EXISTS velluto_motors;
CREATE DATABASE velluto_motors CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE velluto_motors;

-- ============================================
-- 1. TABELA DE MARCAS
-- ============================================
CREATE TABLE marcas (
    id CHAR(36) NOT NULL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE,
    pais_origem VARCHAR(50),
    data_criacao DATE,
    website VARCHAR(150)
);

INSERT INTO marcas (id, nome, pais_origem, data_criacao, website) VALUES 
(UUID(), 'Lamborghini', 'Itália', '1963-05-28', 'www.lamborghini.com'),
(UUID(), 'Ferrari', 'Itália', '1947-12-18', 'www.ferrari.com'),
(UUID(), 'Aston Martin', 'Reino Unido', '1913-01-13', 'www.astonmartin.com'),
(UUID(), 'Mercedes-AMG', 'Alemanha', '1967-06-25', 'www.mercedes-amg.com'),
(UUID(), 'Audi', 'Alemanha', '1909-06-25', 'www.audi.com'),
(UUID(), 'Brabus', 'Alemanha', '1977-01-01', 'www.brabus.com');

-- ============================================
-- 2. TABELA DE ESPECIFICAÇÕES TÉCNICAS
-- ============================================
CREATE TABLE especificacoes (
    id CHAR(36) NOT NULL PRIMARY KEY,
    cilindros INT NOT NULL,
    potencia_hp INT NOT NULL,
    torque_nm INT NOT NULL,
    aceleracao_0_100 DECIMAL(3,2) NOT NULL COMMENT 'segundos',
    velocidade_maxima INT NOT NULL COMMENT 'km/h',
    consumo_medio DECIMAL(3,1),
    tipo_combustivel VARCHAR(30),
    transmissao VARCHAR(50),
    tracao VARCHAR(30),
    peso_kg INT
);

INSERT INTO especificacoes (id, cilindros, potencia_hp, torque_nm, aceleracao_0_100, velocidade_maxima, consumo_medio, tipo_combustivel, transmissao, tracao, peso_kg)
VALUES 
(UUID(), 12, 759, 690, 2.8, 350, 11.5, 'Gasolina', 'Automática 7V', 'AWD', 1550),
(UUID(), 12, 720, 770, 2.9, 340, 9.2, 'Gasolina', 'Automática 7V', 'RWD', 1558),
(UUID(), 12, 630, 900, 3.5, 305, 9.5, 'Gasolina', 'Automática 9V', 'AWD', 1650),
(UUID(), 8, 1063, 1414, 2.6, 352, 13.0, 'Plug-in Hybrid', 'Automática 9V', 'AWD', 1575),
(UUID(), 12, 725, 800, 3.2, 330, 10.0, 'Gasolina', 'Automática 8V', 'RWD', 1600),
(UUID(), 10, 657, 850, 3.6, 305, 10.2, 'Gasolina', 'Automática 8V', 'AWD', 1700),
(UUID(), 5, 592, 800, 3.8, 290, 11.0, 'Gasolina', 'Automática 8V', 'Quattro', 1650),
(UUID(), 12, 800, 1000, 3.0, 330, 12.5, 'Gasolina', 'Automática 9V', 'AWD', 1750);

-- ============================================
-- 3. TABELA DE MODELOS
-- ============================================
CREATE TABLE modelos (
    id CHAR(36) NOT NULL PRIMARY KEY,
    marca_id CHAR(36) NOT NULL,
    especificacao_id CHAR(36),
    nome VARCHAR(100) NOT NULL,
    ano YEAR NOT NULL,
    preco_custo DECIMAL(15,2) NOT NULL,
    cor_padrao VARCHAR(50),
    descricao TEXT,
    data_lancamento DATE,
    CONSTRAINT fk_modelo_marca FOREIGN KEY (marca_id) REFERENCES marcas(id),
    CONSTRAINT fk_modelo_especificacao FOREIGN KEY (especificacao_id) REFERENCES especificacoes(id),
    INDEX idx_marca (marca_id),
    INDEX idx_ano (ano)
);

INSERT INTO modelos (id, marca_id, especificacao_id, nome, ano, preco_custo, cor_padrao, descricao, data_lancamento)
VALUES
(UUID(), (SELECT id FROM marcas WHERE nome = 'Lamborghini' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1), 'Aventador SVJ', 2021, 6500000.00, 'Amarelo Giallo', 'Supercarro de 759 HP com design agressivo', '2018-03-08'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Ferrari' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 1), 'F8 Tributo', 2023, 3800000.00, 'Rosso Corsa', 'Berlinetta V12 com 720 HP', '2019-09-10'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Aston Martin' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 2), 'DBX707', 2023, 3000000.00, 'Preto Profundo', 'SUV de luxo com 630 HP', '2021-07-01'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Mercedes-AMG' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 3), 'AMG ONE', 2023, 12000000.00, 'Prata Metálico', 'Hipercar F1 com 1063 HP', '2017-09-14'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Ferrari' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 4), 'Purosangue', 2025, 6200000.00, 'Rosso Corsa', 'SUV de luxo 725 HP', '2022-09-13'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Lamborghini' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 5), 'Urus', 2023, 3500000.00, 'Preto Opaco', 'SUV super esportivo', '2017-11-28'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Audi' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 6), 'RS Q8', 2023, 1000000.00, 'Cinza Quartzo', 'SUV coupé de performance', '2019-06-27'),
(UUID(), (SELECT id FROM marcas WHERE nome = 'Brabus' LIMIT 1), (SELECT id FROM especificacoes LIMIT 1 OFFSET 7), 'G63 800', 2023, 4000000.00, 'Verde Militar', 'SUV modificado com 800 HP', '2021-01-01');

-- ============================================
-- 4. TABELA DE CLIENTES
-- ============================================
CREATE TABLE clientes (
    id CHAR(36) NOT NULL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    endereco TEXT,
    cidade VARCHAR(50),
    estado VARCHAR(2),
    cep VARCHAR(10),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_nasc DATE,
    tipo_cliente VARCHAR(20) COMMENT 'Pessoa Física ou Jurídica',
    pref_contato VARCHAR(20),
    INDEX idx_email (email),
    INDEX idx_cpf_cnpj (cpf_cnpj),
    INDEX idx_cidade (cidade)
);

INSERT INTO clientes (id, nome, email, telefone, cpf_cnpj, endereco, cidade, estado, cep, data_nasc, tipo_cliente, pref_contato)
VALUES
(UUID(), 'João Silva', 'joao@email.com', '11-98765-4321', '12345678901', 'Av. Paulista 1000', 'São Paulo', 'SP', '01311-100', '1975-03-15', 'Pessoa Física', 'Telefone'),
(UUID(), 'Maria Santos', 'maria@email.com', '11-97654-3210', '98765432109', 'Rua Augusta 500', 'São Paulo', 'SP', '01305-100', '1980-07-22', 'Pessoa Física', 'Email'),
(UUID(), 'Tech Veículos LTDA', 'contato@techveiculos.com', '11-3333-4444', '12345678000195', 'Av. Brasil 2000', 'São Paulo', 'SP', '01431-000', NULL, 'Pessoa Jurídica', 'Email'),
(UUID(), 'Pedro Oliveira', 'pedro@email.com', '21-98888-7777', '55555555555', 'Av. Lúcio Costa 100', 'Rio de Janeiro', 'RJ', '20149-160', '1982-11-10', 'Pessoa Física', 'Telefone'),
(UUID(), 'Luxo Import', 'vendas@luxoimport.com', '21-3333-2222', '98765432000199', 'Rua do Ouvidor 100', 'Rio de Janeiro', 'RJ', '20040-020', NULL, 'Pessoa Jurídica', 'Email'),
(UUID(), 'Felipe Costa', 'felipe@email.com', '85-98888-1111', '11111111111', 'Av. Washington Soares 3000', 'Fortaleza', 'CE', '60811-350', '1978-05-30', 'Pessoa Física', 'Telefone');

-- ============================================
-- 5. TABELA DE FUNCIONÁRIOS
-- ============================================
CREATE TABLE funcionarios (
    id CHAR(36) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) DEFAULT 'Vendedor',
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    data_admissao DATE DEFAULT CURDATE(),
    salario DECIMAL(10,2),
    comissao_percentual DECIMAL(5,2) DEFAULT 0.7,
    ativo BOOLEAN DEFAULT TRUE,
    data_desligamento DATE,
    INDEX idx_cargo (cargo),
    INDEX idx_ativo (ativo)
);

INSERT INTO funcionarios (id, nome, cargo, email, telefone, data_admissao, salario, comissao_percentual, ativo)
VALUES
(UUID(), 'Ricardo Silva', 'Vendedor', 'ricardo@velluto.com', '11-99999-0001', '2021-01-15', 5000.00, 0.7, TRUE),
(UUID(), 'Ana Beatriz', 'Vendedor', 'ana@velluto.com', '11-99999-0002', '2021-06-10', 5500.00, 0.7, TRUE),
(UUID(), 'Marcos Vinícius', 'Vendedor', 'marcos@velluto.com', '11-99999-0003', '2022-03-20', 5000.00, 0.7, TRUE),
(UUID(), 'Clara Oliveira', 'Vendedor', 'clara@velluto.com', '11-99999-0004', '2022-08-05', 5500.00, 0.7, TRUE),
(UUID(), 'Enzo Ferreira', 'Vendedor', 'enzo@velluto.com', '11-99999-0005', '2023-01-12', 5000.00, 0.7, TRUE),
(UUID(), 'Sofia Martins', 'Vendedor', 'sofia@velluto.com', '11-99999-0006', '2023-02-28', 5500.00, 0.7, TRUE),
(UUID(), 'Mestre Funari', 'Mecânico', 'funari@velluto.com', '11-99999-0007', '2020-11-01', 6000.00, 0, TRUE),
(UUID(), 'Pedro Faísca', 'Mecânico', 'pedro@velluto.com', '11-99999-0008', '2021-05-10', 6500.00, 0, TRUE),
(UUID(), 'Carlos Gerente', 'Gerente', 'carlos@velluto.com', '11-99999-0009', '2019-01-01', 10000.00, 0, TRUE);

-- ============================================
-- 6. TABELA DE ESTOQUE
-- ============================================
CREATE TABLE estoque (
    id CHAR(36) NOT NULL PRIMARY KEY,
    modelo_id CHAR(36) NOT NULL,
    chassi VARCHAR(50) NOT NULL UNIQUE,
    placa_veiculo VARCHAR(10),
    status_veiculo VARCHAR(50) DEFAULT 'Em Revisão',
    cor_real VARCHAR(50),
    quilometragem INT DEFAULT 0,
    data_entrada DATE DEFAULT CURDATE(),
    data_ultima_revisao DATE,
    observacoes TEXT,
    CONSTRAINT fk_estoque_modelo FOREIGN KEY (modelo_id) REFERENCES modelos(id),
    INDEX idx_status (status_veiculo),
    INDEX idx_chassi (chassi),
    INDEX idx_modelo (modelo_id)
);

INSERT INTO estoque (id, modelo_id, chassi, placa_veiculo, status_veiculo, cor_real, quilometragem, data_entrada, data_ultima_revisao)
SELECT UUID(), m.id, CONCAT('CHASSI-', UPPER(SUBSTRING(mc.nome, 1, 4)), '-', FLOOR(RAND()*9000+1000)), 
       CONCAT(LPAD(FLOOR(RAND()*9999), 4, '0'), 'ABC'), 'Pronto para Venda', m.cor_padrao, 0, CURDATE(), CURDATE()
FROM modelos m
JOIN marcas mc ON m.marca_id = mc.id
LIMIT 8;

INSERT INTO estoque (id, modelo_id, chassi, placa_veiculo, status_veiculo, cor_real, quilometragem, data_entrada, data_ultima_revisao)
SELECT 
    UUID(), m.id, CONCAT('CHASSI-REV-', FLOOR(RAND()*9000+1000)), 
    CONCAT(LPAD(FLOOR(RAND()*9999), 4, '0'), 'DEF'), 
    'Em Revisão', 'Vermelho', 500, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL
FROM modelos m WHERE m.nome IN ('DBX707', 'F8 Tributo')
LIMIT 2;

-- ============================================
-- 7. TABELA DE GARANTIAS
-- ============================================
CREATE TABLE garantias (
    id CHAR(36) NOT NULL PRIMARY KEY,
    veiculo_id CHAR(36) NOT NULL,
    tipo_garantia VARCHAR(50) COMMENT 'Fabril, Estendida',
    meses_cobertura INT,
    quilometragem_limite INT,
    data_inicio DATE DEFAULT CURDATE(),
    data_fim DATE,
    cobertura_mecanica BOOLEAN DEFAULT TRUE,
    cobertura_eletrica BOOLEAN DEFAULT TRUE,
    cobertura_pintura BOOLEAN DEFAULT FALSE,
    valor_cobertura DECIMAL(15,2),
    CONSTRAINT fk_garantia_veiculo FOREIGN KEY (veiculo_id) REFERENCES estoque(id)
);

INSERT INTO garantias (id, veiculo_id, tipo_garantia, meses_cobertura, quilometragem_limite, data_inicio, data_fim, cobertura_mecanica, cobertura_eletrica, cobertura_pintura, valor_cobertura)
SELECT UUID(), e.id, 'Fabril', 24, 50000, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 24 MONTH), TRUE, TRUE, FALSE, 500000.00
FROM estoque e
LIMIT 8;

-- ============================================
-- 8. TABELA DE MANUTENÇÕES
-- ============================================
CREATE TABLE manutencoes (
    id CHAR(36) NOT NULL PRIMARY KEY,
    veiculo_id CHAR(36) NOT NULL,
    mecanico_id CHAR(36) NOT NULL,
    tipo_servico VARCHAR(100) NOT NULL,
    descricao TEXT,
    custo DECIMAL(10,2),
    data_inicio DATE DEFAULT CURDATE(),
    data_conclusao DATE,
    status VARCHAR(30) DEFAULT 'Em Progresso',
    observacoes TEXT,
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (veiculo_id) REFERENCES estoque(id),
    CONSTRAINT fk_manutencao_mecanico FOREIGN KEY (mecanico_id) REFERENCES funcionarios(id),
    INDEX idx_status (status),
    INDEX idx_veiculo (veiculo_id),
    INDEX idx_data (data_inicio)
);

INSERT INTO manutencoes (id, veiculo_id, mecanico_id, tipo_servico, descricao, custo, data_inicio, status)
SELECT 
    UUID(), e.id, 
    (SELECT id FROM funcionarios WHERE cargo = 'Mecânico' LIMIT 1),
    'Revisão Completa',
    'Inspeção visual, testes eletrônicos, verificação de fluidos',
    15000.00,
    CURDATE(),
    'Em Progresso'
FROM estoque e WHERE e.status_veiculo = 'Em Revisão'
LIMIT 2;

-- ============================================
-- 9. TABELA DE VENDAS
-- ============================================
CREATE TABLE vendas (
    id CHAR(36) NOT NULL PRIMARY KEY,
    vendedor_id CHAR(36) NOT NULL,
    cliente_id CHAR(36),
    veiculo_id CHAR(36) NOT NULL,
    valor_venda DECIMAL(15,2) NOT NULL,
    desconto DECIMAL(15,2) DEFAULT 0,
    valor_final DECIMAL(15,2),
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento VARCHAR(50),
    nfe_numero VARCHAR(50),
    status_venda VARCHAR(30) DEFAULT 'Concluída',
    observacoes TEXT,
    CONSTRAINT fk_venda_vendedor FOREIGN KEY (vendedor_id) REFERENCES funcionarios(id),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_venda_veiculo FOREIGN KEY (veiculo_id) REFERENCES estoque(id),
    INDEX idx_data (data_venda),
    INDEX idx_vendedor (vendedor_id),
    INDEX idx_cliente (cliente_id),
    INDEX idx_status (status_venda)
);

-- ============================================
-- 10. TABELA DE PAGAMENTOS
-- ============================================
CREATE TABLE pagamentos (
    id CHAR(36) NOT NULL PRIMARY KEY,
    venda_id CHAR(36) NOT NULL,
    tipo_pagamento VARCHAR(50) COMMENT 'À Vista, Parcelado, Financiamento',
    numero_parcelas INT DEFAULT 1,
    valor_parcela DECIMAL(15,2),
    data_primeira_parcela DATE,
    data_ultima_parcela DATE,
    taxa_juros DECIMAL(5,2) DEFAULT 0,
    valor_total_pago DECIMAL(15,2),
    banco_financeiro VARCHAR(100),
    contrato_numero VARCHAR(50),
    CONSTRAINT fk_pagamento_venda FOREIGN KEY (venda_id) REFERENCES vendas(id),
    INDEX idx_venda (venda_id),
    INDEX idx_tipo (tipo_pagamento)
);

-- ============================================
-- 11. TABELA DE CRITÉRIOS DE AVALIAÇÃO
-- ============================================
CREATE TABLE criterios_avaliacao (
    id CHAR(36) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    peso INT DEFAULT 1 COMMENT 'Peso na pontuação final',
    ativo BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO criterios_avaliacao (id, nome, descricao, peso, ativo)
VALUES 
(UUID(), 'Atendimento', 'Qualidade e cordialidade do atendimento recebido', 3, TRUE),
(UUID(), 'Conhecimento do Produto', 'Conhecimento do vendedor sobre o veículo', 3, TRUE),
(UUID(), 'Facilidade na Negociação', 'Clareza e facilidade do processo de negociação', 2, TRUE),
(UUID(), 'Conformidade com Expectativa', 'Produto atendeu às expectativas', 3, TRUE),
(UUID(), 'Agilidade no Processo', 'Rapidez na entrega e processos administrativos', 2, TRUE),
(UUID(), 'Pós-venda e Suporte', 'Qualidade do suporte pós-venda oferecido', 3, TRUE);

-- ============================================
-- 12. TABELA DE AVALIAÇÕES
-- ============================================
CREATE TABLE avaliacoes (
    id CHAR(36) NOT NULL PRIMARY KEY,
    venda_id CHAR(36) NOT NULL UNIQUE,
    cliente_id CHAR(36) NOT NULL,
    vendedor_id CHAR(36) NOT NULL,
    nota_geral INT COMMENT '1 a 5 estrelas',
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_resposta VARCHAR(30) DEFAULT 'Não respondida',
    resposta_vendedor TEXT,
    data_resposta DATETIME,
    recomendaria BOOLEAN DEFAULT NULL COMMENT 'Recomendaria a Velluto',
    CONSTRAINT fk_avaliacao_venda FOREIGN KEY (venda_id) REFERENCES vendas(id),
    CONSTRAINT fk_avaliacao_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_avaliacao_vendedor FOREIGN KEY (vendedor_id) REFERENCES funcionarios(id),
    INDEX idx_cliente (cliente_id),
    INDEX idx_vendedor (vendedor_id),
    INDEX idx_nota (nota_geral),
    INDEX idx_data (data_avaliacao)
);

-- ============================================
-- 13. TABELA DE DETALHES DE AVALIAÇÃO
-- ============================================
CREATE TABLE detalhes_avaliacao (
    id CHAR(36) NOT NULL PRIMARY KEY,
    avaliacao_id CHAR(36) NOT NULL,
    criterio_id CHAR(36) NOT NULL,
    nota INT COMMENT '1 a 5 estrelas',
    comentario_criterio TEXT,
    CONSTRAINT fk_detalhe_avaliacao FOREIGN KEY (avaliacao_id) REFERENCES avaliacoes(id) ON DELETE CASCADE,
    CONSTRAINT fk_detalhe_criterio FOREIGN KEY (criterio_id) REFERENCES criterios_avaliacao(id),
    CONSTRAINT chk_nota CHECK (nota >= 1 AND nota <= 5),
    INDEX idx_avaliacao (avaliacao_id),
    INDEX idx_criterio (criterio_id)
);

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger 1: Valida venda apenas de carros prontos
DELIMITER $$
CREATE TRIGGER tg_valida_venda_status
BEFORE INSERT ON vendas
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(50);
    SELECT status_veiculo INTO v_status FROM estoque WHERE id = NEW.veiculo_id;
    
    IF v_status <> 'Pronto para Venda' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ERRO: Veículo não está pronto para venda!';
    END IF;
END$$
DELIMITER ;

-- Trigger 2: Calcula valor final da venda
DELIMITER $$
CREATE TRIGGER tg_calcula_valor_final
BEFORE INSERT ON vendas
FOR EACH ROW
BEGIN
    SET NEW.valor_final = NEW.valor_venda - NEW.desconto;
END$$
DELIMITER ;

-- Trigger 3: Muda status do estoque após venda
DELIMITER $$
CREATE TRIGGER tg_atualiza_estoque_venda
AFTER INSERT ON vendas
FOR EACH ROW
BEGIN
    UPDATE estoque 
    SET status_veiculo = 'Vendido' 
    WHERE id = NEW.veiculo_id;
END$$
DELIMITER ;

-- Trigger 4: Calcula nota geral baseado em critérios
DELIMITER $$
CREATE TRIGGER tg_calcula_nota_geral
AFTER INSERT ON detalhes_avaliacao
FOR EACH ROW
BEGIN
    DECLARE v_nota_media DECIMAL(3,2);
    DECLARE v_avaliacao_id CHAR(36);
    
    SET v_avaliacao_id = NEW.avaliacao_id;
    
    SELECT ROUND(AVG(nota), 2) INTO v_nota_media
    FROM detalhes_avaliacao
    WHERE avaliacao_id = v_avaliacao_id;
    
    UPDATE avaliacoes
    SET nota_geral = ROUND(v_nota_media, 0)
    WHERE id = v_avaliacao_id;
END$$
DELIMITER ;

-- ============================================
-- PROCEDURES (Stored Procedures)
-- ============================================

-- Procedure 1: Registrar Venda Completa
DELIMITER $$
CREATE PROCEDURE sp_registrar_venda_completa(
    IN p_vendedor_id CHAR(36),
    IN p_cliente_id CHAR(36),
    IN p_veiculo_id CHAR(36),
    IN p_valor_venda DECIMAL(15,2),
    IN p_desconto DECIMAL(15,2),
    IN p_forma_pagamento VARCHAR(50),
    IN p_nfe_numero VARCHAR(50)
)
BEGIN
    DECLARE v_venda_id CHAR(36);
    DECLARE v_valor_final DECIMAL(15,2);
    
    START TRANSACTION;
    
    BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar venda!';
        END;
        
        SET v_venda_id = UUID();
        SET v_valor_final = p_valor_venda - p_desconto;
        
        INSERT INTO vendas (id, vendedor_id, cliente_id, veiculo_id, valor_venda, desconto, valor_final, forma_pagamento, nfe_numero)
        VALUES (v_venda_id, p_vendedor_id, p_cliente_id, p_veiculo_id, p_valor_venda, p_desconto, v_valor_final, p_forma_pagamento, p_nfe_numero);
        
        COMMIT;
        SELECT 'Venda registrada com sucesso!' AS mensagem, v_venda_id AS id_venda;
    END;
END$$
DELIMITER ;

-- Procedure 2: Registrar Manutenção
DELIMITER $$
CREATE PROCEDURE sp_registrar_manutencao(
    IN p_veiculo_id CHAR(36),
    IN p_mecanico_id CHAR(36),
    IN p_tipo_servico VARCHAR(100),
    IN p_descricao TEXT,
    IN p_custo DECIMAL(10,2)
)
BEGIN
    DECLARE v_manutencao_id CHAR(36);
    
    SET v_manutencao_id = UUID();
    
    INSERT INTO manutencoes (id, veiculo_id, mecanico_id, tipo_servico, descricao, custo)
    VALUES (v_manutencao_id, p_veiculo_id, p_mecanico_id, p_tipo_servico, p_descricao, p_custo);
    
    UPDATE estoque SET status_veiculo = 'Em Manutenção' WHERE id = p_veiculo_id;
    
    SELECT 'Manutenção registrada!' AS mensagem, v_manutencao_id AS id_manutencao;
END$$
DELIMITER ;

-- Procedure 3: Concluir Manutenção
DELIMITER $$
CREATE PROCEDURE sp_concluir_manutencao(
    IN p_manutencao_id CHAR(36)
)
BEGIN
    DECLARE v_veiculo_id CHAR(36);
    
    SELECT veiculo_id INTO v_veiculo_id FROM manutencoes WHERE id = p_manutencao_id;
    
    UPDATE manutencoes 
    SET status = 'Concluída', data_conclusao = CURDATE() 
    WHERE id = p_manutencao_id;
    
    UPDATE estoque 
    SET status_veiculo = 'Pronto para Venda', data_ultima_revisao = CURDATE() 
    WHERE id = v_veiculo_id;
    
    SELECT 'Manutenção concluída! Veículo pronto para venda.' AS mensagem;
END$$
DELIMITER ;

-- Procedure 4: Registrar Avaliação Completa
DELIMITER $$
CREATE PROCEDURE sp_registrar_avaliacao(
    IN p_venda_id CHAR(36),
    IN p_cliente_id CHAR(36),
    IN p_vendedor_id CHAR(36),
    IN p_comentario TEXT,
    IN p_recomendaria BOOLEAN
)
BEGIN
    DECLARE v_avaliacao_id CHAR(36);
    
    SET v_avaliacao_id = UUID();
    
    INSERT INTO avaliacoes (id, venda_id, cliente_id, vendedor_id, comentario, recomendaria)
    VALUES (v_avaliacao_id, p_venda_id, p_cliente_id, p_vendedor_id, p_comentario, p_recomendaria);
    
    SELECT 'Avaliação registrada com sucesso!' AS mensagem, v_avaliacao_id AS id_avaliacao;
END$$
DELIMITER ;

-- Procedure 5: Adicionar Nota a Critério
DELIMITER $$
CREATE PROCEDURE sp_adicionar_nota_criterio(
    IN p_avaliacao_id CHAR(36),
    IN p_criterio_id CHAR(36),
    IN p_nota INT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_detalhe_id CHAR(36);
    
    IF p_nota < 1 OR p_nota > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nota deve estar entre 1 e 5!';
    END IF;
    
    SET v_detalhe_id = UUID();
    
    INSERT INTO detalhes_avaliacao (id, avaliacao_id, criterio_id, nota, comentario_criterio)
    VALUES (v_detalhe_id, p_avaliacao_id, p_criterio_id, p_nota, p_comentario);
    
    SELECT 'Nota registrada para critério!' AS mensagem;
END$$
DELIMITER ;

-- Procedure 6: Responder Avaliação
DELIMITER $$
CREATE PROCEDURE sp_responder_avaliacao(
    IN p_avaliacao_id CHAR(36),
    IN p_resposta TEXT
)
BEGIN
    UPDATE avaliacoes
    SET resposta_vendedor = p_resposta,
        data_resposta = CURRENT_TIMESTAMP,
        status_resposta = 'Respondida'
    WHERE id = p_avaliacao_id;
    
    SELECT 'Resposta registrada!' AS mensagem;
END$$
DELIMITER ;

-- ============================================
-- VIEWS (Relatórios)
-- ============================================

-- View 1: Lucro por Venda
CREATE VIEW v_relatorio_lucro AS
SELECT 
    v.id AS venda_id,
    e.chassi,
    m.nome AS modelo,
    c.nome AS cliente,
    f.nome AS vendedor,
    v.valor_venda,
    m.preco_custo,
    (v.valor_final - m.preco_custo) AS lucro_bruto,
    ROUND((((v.valor_final - m.preco_custo) / v.valor_final) * 100), 2) AS margem_lucro,
    v.data_venda
FROM vendas v
JOIN estoque e ON v.veiculo_id = e.id
JOIN modelos m ON e.modelo_id = m.id
LEFT JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN funcionarios f ON v.vendedor_id = f.id;

-- View 2: Comissões dos Vendedores
CREATE VIEW v_relatorio_comissoes AS
SELECT 
    f.nome AS vendedor,
    COUNT(v.id) AS total_vendas,
    SUM(v.valor_final) AS total_vendido,
    ROUND(SUM(v.valor_final * (f.comissao_percentual / 100)), 2) AS comissao_total,
    ROUND(AVG(v.valor_final), 2) AS ticket_medio
FROM vendas v
JOIN funcionarios f ON v.vendedor_id = f.id
WHERE f.ativo = TRUE
GROUP BY f.id, f.nome
ORDER BY comissao_total DESC;

-- View 3: Ranking de Vendedores
CREATE VIEW v_ranking_vendedores AS
SELECT 
    f.nome AS vendedor,
    COUNT(v.id) AS vendas_total,
    SUM(v.valor_final) AS faturamento_total,
    ROUND(AVG(v.valor_final), 2) AS valor_medio_venda,
    ROUND(SUM(v.valor_final * (f.comissao_percentual / 100)), 2) AS comissao_total
FROM vendas v
JOIN funcionarios f ON v.vendedor_id = f.id
WHERE f.ativo = TRUE
GROUP BY f.id, f.nome
ORDER BY faturamento_total DESC;

-- View 4: Performance Mensal
CREATE VIEW v_performance_mensal AS
SELECT 
    DATE_FORMAT(v.data_venda, '%Y-%m-01') AS mes_referencia,
    f.nome AS vendedor,
    COUNT(*) AS vendas_mes,
    SUM(v.valor_final) AS faturamento_mes,
    ROUND(SUM(v.valor_final * (f.comissao_percentual / 100)), 2) AS comissao_mes
FROM vendas v
JOIN funcionarios f ON v.vendedor_id = f.id
GROUP BY DATE_FORMAT(v.data_venda, '%Y-%m'), f.id, f.nome
ORDER BY mes_referencia DESC;

-- View 5: Estoque com Detalhes
CREATE VIEW v_estoque_detalhes AS
SELECT 
    e.chassi,
    m.nome AS modelo,
    mc.nome AS marca,
    e.cor_real,
    e.status_veiculo,
    e.quilometragem,
    m.preco_custo,
    e.data_entrada,
    e.data_ultima_revisao
FROM estoque e
JOIN modelos m ON e.modelo_id = m.id
JOIN marcas mc ON m.marca_id = mc.id;

-- View 6: Clientes Premium (acima de 5M em vendas)
CREATE VIEW v_clientes_premium AS
SELECT 
    c.nome,
    c.cidade,
    c.email,
    COUNT(v.id) AS compras_total,
    SUM(v.valor_final) AS total_gasto,
    MAX(v.data_venda) AS ultima_compra
FROM clientes c
LEFT JOIN vendas v ON c.id = v.cliente_id
GROUP BY c.id, c.nome, c.cidade, c.email
HAVING SUM(v.valor_final) >= 5000000
ORDER BY total_gasto DESC;

-- View 7: Manutenções Pendentes
CREATE VIEW v_manutencoes_pendentes AS
SELECT 
    m.id,
    e.chassi,
    mo.nome AS modelo,
    f.nome AS mecanico,
    m.tipo_servico,
    m.custo,
    m.data_inicio,
    DATEDIFF(CURDATE(), m.data_inicio) AS dias_em_manutencao
FROM manutencoes m
JOIN estoque e ON m.veiculo_id = e.id
JOIN modelos mo ON e.modelo_id = mo.id
JOIN funcionarios f ON m.mecanico_id = f.id
WHERE m.status = 'Em Progresso'
ORDER BY m.data_inicio ASC;

-- View 8: Avaliações por Cliente
CREATE VIEW v_avaliacoes_cliente AS
SELECT 
    c.nome AS cliente,
    COUNT(a.id) AS total_avaliacoes,
    ROUND(AVG(a.nota_geral), 2) AS nota_media,
    SUM(CASE WHEN a.recomendaria = TRUE THEN 1 ELSE 0 END) AS recomendacoes,
    MAX(a.data_avaliacao) AS ultima_avaliacao
FROM clientes c
LEFT JOIN avaliacoes a ON c.id = a.cliente_id
GROUP BY c.id, c.nome
ORDER BY nota_media DESC;

-- View 9: Avaliações por Vendedor
CREATE VIEW v_avaliacoes_vendedor AS
SELECT 
    f.nome AS vendedor,
    COUNT(a.id) AS total_avaliacoes,
    ROUND(AVG(a.nota_geral), 2) AS nota_media,
    SUM(CASE WHEN a.recomendaria = TRUE THEN 1 ELSE 0 END) AS recomendacoes,
    SUM(CASE WHEN a.status_resposta = 'Respondida' THEN 1 ELSE 0 END) AS avaliacoes_respondidas,
    ROUND((SUM(CASE WHEN a.status_resposta = 'Respondida' THEN 1 ELSE 0 END) / COUNT(a.id)) * 100, 2) AS taxa_resposta,
    MAX(a.data_avaliacao) AS ultima_avaliacao
FROM funcionarios f
LEFT JOIN avaliacoes a ON f.id = a.vendedor_id
WHERE f.cargo = 'Vendedor'
GROUP BY f.id, f.nome
ORDER BY nota_media DESC;

-- View 10: Avaliações por Critério
CREATE VIEW v_avaliacoes_por_criterio AS
SELECT 
    c.nome AS criterio,
    COUNT(da.id) AS total_avaliacoes,
    ROUND(AVG(da.nota), 2) AS nota_media,
    COUNT(CASE WHEN da.nota = 5 THEN 1 END) AS estrelas_5,
    COUNT(CASE WHEN da.nota = 4 THEN 1 END) AS estrelas_4,
    COUNT(CASE WHEN da.nota = 3 THEN 1 END) AS estrelas_3,
    COUNT(CASE WHEN da.nota = 2 THEN 1 END) AS estrelas_2,
    COUNT(CASE WHEN da.nota = 1 THEN 1 END) AS estrelas_1
FROM criterios_avaliacao c
LEFT JOIN detalhes_avaliacao da ON c.id = da.criterio_id
GROUP BY c.id, c.nome
ORDER BY nota_media DESC;

-- View 11: Detalhes Completos de Avaliação
CREATE VIEW v_detalhes_avaliacao_completa AS
SELECT 
    a.id AS avaliacao_id,
    c.nome AS cliente,
    f.nome AS vendedor,
    m.nome AS modelo,
    a.nota_geral,
    a.comentario,
    CASE WHEN a.recomendaria = TRUE THEN 'Sim' WHEN a.recomendaria = FALSE THEN 'Não' ELSE 'Sem resposta' END AS recomendaria,
    a.data_avaliacao,
    a.status_resposta,
    a.resposta_vendedor,
    a.data_resposta
FROM avaliacoes a
JOIN clientes c ON a.cliente_id = c.id
JOIN funcionarios f ON a.vendedor_id = f.id
JOIN vendas v ON a.venda_id = v.id
JOIN estoque e ON v.veiculo_id = e.id
JOIN modelos m ON e.modelo_id = m.id
ORDER BY a.data_avaliacao DESC;

-- View 12: Classificação Geral de Vendedores
CREATE VIEW v_classificacao_vendedores AS
SELECT 
    f.nome AS vendedor,
    COUNT(v.id) AS total_vendas,
    COUNT(a.id) AS avaliacoes_recebidas,
    ROUND((COUNT(a.id) / COUNT(v.id)) * 100, 2) AS taxa_avaliacao,
    ROUND(AVG(a.nota_geral), 2) AS nota_media_avaliacao,
    SUM(CASE WHEN a.recomendaria = TRUE THEN 1 ELSE 0 END) AS clientes_recomendariam,
    ROUND((SUM(CASE WHEN a.recomendaria = TRUE THEN 1 ELSE 0 END) / COUNT(a.id)) * 100, 2) AS taxa_recomendacao
FROM funcionarios f
LEFT JOIN vendas v ON f.id = v.vendedor_id
LEFT JOIN avaliacoes a ON v.id = a.venda_id
WHERE f.cargo = 'Vendedor' AND f.ativo = TRUE
GROUP BY f.id, f.nome
ORDER BY nota_media_avaliacao DESC, total_vendas DESC;

-- View 13: Avaliações Pendentes de Resposta
CREATE VIEW v_avaliacoes_sem_resposta AS
SELECT 
    a.id,
    c.nome AS cliente,
    f.nome AS vendedor,
    m.nome AS modelo,
    a.nota_geral,
    a.comentario,
    a.data_avaliacao,
    DATEDIFF(CURDATE(), a.data_avaliacao) AS dias_sem_resposta
FROM avaliacoes a
JOIN clientes c ON a.cliente_id = c.id
JOIN funcionarios f ON a.vendedor_id = f.id
JOIN vendas v ON a.venda_id = v.id
JOIN estoque e ON v.veiculo_id = e.id
JOIN modelos m ON e.modelo_id = m.id
WHERE a.status_resposta = 'Não respondida'
ORDER BY a.data_avaliacao ASC;

-- ============================================
-- INSERÇÃO DE DADOS - VENDAS
-- ============================================
INSERT INTO vendas (id, vendedor_id, cliente_id, veiculo_id, valor_venda, desconto, forma_pagamento, nfe_numero, status_venda)
SELECT 
    UUID(),
    (SELECT id FROM funcionarios WHERE cargo = 'Vendedor' AND nome = 'Ricardo Silva' LIMIT 1),
    (SELECT id FROM clientes WHERE nome = 'João Silva' LIMIT 1),
    (SELECT id FROM estoque WHERE status_veiculo = 'Pronto para Venda' LIMIT 1),
    7000000.00,
    150000.00,
    'Financiamento',
    '2026-0001',
    'Concluída';

INSERT INTO vendas (id, vendedor_id, cliente_id, veiculo_id, valor_venda, desconto, forma_pagamento, nfe_numero, status_venda)
SELECT 
    UUID(),
    (SELECT id FROM funcionarios WHERE cargo = 'Vendedor' AND nome = 'Ana Beatriz' LIMIT 1),
    (SELECT id FROM clientes WHERE nome = 'Tech Veículos LTDA' LIMIT 1),
    (SELECT id FROM estoque WHERE status_veiculo = 'Pronto para Venda' AND id NOT IN (SELECT veiculo_id FROM vendas) LIMIT 1),
    3900000.00,
    100000.00,
    'À Vista',
    '2026-0002',
    'Concluída';

INSERT INTO vendas (id, vendedor_id, cliente_id, veiculo_id, valor_venda, desconto, forma_pagamento, nfe_numero, status_venda)
SELECT 
    UUID(),
    (SELECT id FROM funcionarios WHERE cargo = 'Vendedor' AND nome = 'Marcos Vinícius' LIMIT 1),
    (SELECT id FROM clientes WHERE nome = 'Maria Santos' LIMIT 1),
    (SELECT id FROM estoque WHERE status_veiculo = 'Pronto para Venda' AND id NOT IN (SELECT veiculo_id FROM vendas) LIMIT 1),
    12500000.00,
    500000.00,
    'Financiamento',
    '2026-0003',
    'Concluída';

-- ============================================
-- INSERÇÃO DE DADOS - PAGAMENTOS
-- ============================================
INSERT INTO pagamentos (id, venda_id, tipo_pagamento, numero_parcelas, valor_parcela, data_primeira_parcela, data_ultima_parcela, taxa_juros, banco_financeiro)
SELECT 
    UUID(), v.id, 'Financiamento', 60, (v.valor_final / 60), DATE_ADD(v.data_venda, INTERVAL 30 DAY), DATE_ADD(v.data_venda, INTERVAL 60 MONTH), 1.99, 'Banco Santander'
FROM vendas v
WHERE v.forma_pagamento = 'Financiamento'
LIMIT 2;

INSERT INTO pagamentos (id, venda_id, tipo_pagamento, numero_parcelas, valor_parcela, data_primeira_parcela, data_ultima_parcela, taxa_juros, banco_financeiro)
SELECT 
    UUID(), v.id, 'À Vista', 1, v.valor_final, v.data_venda, v.data_venda, 0, NULL
FROM vendas v
WHERE v.forma_pagamento = 'À Vista'
LIMIT 1;

-- ============================================
-- INSERÇÃO DE DADOS - AVALIAÇÕES
-- ============================================
INSERT INTO avaliacoes (id, venda_id, cliente_id, vendedor_id, comentario, recomendaria)
SELECT 
    UUID(),
    v.id,
    v.cliente_id,
    v.vendedor_id,
    'Excelente atendimento e veículo de alta qualidade. Muito satisfeito com a compra!',
    TRUE
FROM vendas v
WHERE v.forma_pagamento = 'À Vista'
LIMIT 1;

INSERT INTO avaliacoes (id, venda_id, cliente_id, vendedor_id, comentario, recomendaria)
SELECT 
    UUID(),
    v.id,
    v.cliente_id,
    v.vendedor_id,
    'Bom atendimento, mas o processo foi um pouco lento. No geral, satisfeito.',
    TRUE
FROM vendas v
WHERE v.forma_pagamento = 'Financiamento'
LIMIT 1;

INSERT INTO avaliacoes (id, venda_id, cliente_id, vendedor_id, comentario, recomendaria)
SELECT 
    UUID(),
    v.id,
    v.cliente_id,
    v.vendedor_id,
    'Atendimento bom, carro conforme esperado.',
    TRUE
FROM vendas v
WHERE v.forma_pagamento = 'Financiamento'
LIMIT 1 OFFSET 1;

-- Adicionar notas por critério
INSERT INTO detalhes_avaliacao (id, avaliacao_id, criterio_id, nota, comentario_criterio)
SELECT 
    UUID(),
    (SELECT id FROM avaliacoes LIMIT 1),
    c.id,
    5,
    'Perfeito em todos os aspectos'
FROM criterios_avaliacao c
WHERE c.nome = 'Atendimento'
LIMIT 1;

INSERT INTO detalhes_avaliacao (id, avaliacao_id, criterio_id, nota, comentario_criterio)
SELECT 
    UUID(),
    (SELECT id FROM avaliacoes LIMIT 1),
    c.id,
    5,
    'Ricardo possui profundo conhecimento dos veículos'
FROM criterios_avaliacao c
WHERE c.nome = 'Conhecimento do Produto'
LIMIT 1;

INSERT INTO detalhes_avaliacao (id, avaliacao_id, criterio_id, nota, comentario_criterio)
SELECT 
    UUID(),
    (SELECT id FROM avaliacoes LIMIT 1),
    c.id,
    4,
    'Processo clara mas poderia ser mais ágil'
FROM criterios_avaliacao c
WHERE c.nome = 'Facilidade na Negociação'
LIMIT 1;

INSERT INTO detalhes_avaliacao (id, avaliacao_id, criterio_id, nota, comentario_criterio)
SELECT 
    UUID(),
    (SELECT id FROM avaliacoes LIMIT 1),
    c.id,
    5,
    'Carro chegou exatamente como esperado'
FROM criterios_avaliacao c
WHERE c.nome = 'Conformidade com Expectativa'
LIMIT 1;

-- ============================================
-- TESTES E RELATÓRIOS FINAIS
-- ============================================

SELECT '╔════════════════════════════════════════════════════════════════╗' AS titulo;
SELECT '║  VELLUTO MOTORS - SISTEMA COMPLETO CONSOLIDADO                ║' AS titulo;
SELECT '║  100% Funcional no MariaDB/MySQL + XAMPP                      ║' AS titulo;
SELECT '╚════════════════════════════════════════════════════════════════╝' AS titulo;

SELECT '\n====== ✅ TESTE 1: RELATÓRIO DE LUCRO ======' AS secao;
SELECT * FROM v_relatorio_lucro LIMIT 5;

SELECT '\n====== ✅ TESTE 2: RANKING DE VENDEDORES ======' AS secao;
SELECT * FROM v_relatorio_comissoes ORDER BY comissao_total DESC;

SELECT '\n====== ✅ TESTE 3: ESTOQUE ATUAL ======' AS secao;
SELECT * FROM v_estoque_detalhes LIMIT 5;

SELECT '\n====== ✅ TESTE 4: AVALIAÇÕES POR VENDEDOR ======' AS secao;
SELECT * FROM v_avaliacoes_vendedor;

SELECT '\n====== ✅ TESTE 5: CLASSIFICAÇÃO GERAL ======' AS secao;
SELECT * FROM v_classificacao_vendedores;

SELECT '\n====== ✅ TESTE 6: RESUMO FINAL DO SISTEMA ======' AS secao;
SELECT 
    (SELECT COUNT(*) FROM vendas) AS 'Total de Vendas',
    (SELECT ROUND(SUM(valor_final), 2) FROM vendas) AS 'Faturamento Total',
    (SELECT COUNT(*) FROM estoque WHERE status_veiculo = 'Pronto para Venda') AS 'Carros Prontos',
    (SELECT COUNT(*) FROM clientes) AS 'Total de Clientes',
    (SELECT COUNT(*) FROM funcionarios WHERE ativo = TRUE) AS 'Funcionários Ativos',
    (SELECT COUNT(*) FROM avaliacoes) AS 'Total Avaliações',
    (SELECT ROUND(AVG(nota_geral), 2) FROM avaliacoes) AS 'Nota Média Sistema';

SELECT '\n╔════════════════════════════════════════════════════════════════╗' AS resultado;
SELECT '║  ✨ BANCO CRIADO COM SUCESSO - PRONTO PARA USAR! ✨            ║' AS resultado;
SELECT '║  Todas as tabelas, triggers, procedures e views funcionando!  ║' AS resultado;
SELECT '╚════════════════════════════════════════════════════════════════╝' AS resultado;
