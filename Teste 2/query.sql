CREATE TABLE operadoras_ativas (
    registro_ans INT PRIMARY KEY,
    cnpj VARCHAR(20),
    razao_social VARCHAR(255),
    nome_fantasia VARCHAR(255),
    modalidade VARCHAR(100),
    logradouro VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(255),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    cep VARCHAR(15),
    ddd VARCHAR(5),
    telefone VARCHAR(20),
    fax VARCHAR(20),
    endereco_eletronico VARCHAR(255),
    representante VARCHAR(255),
    cargo_representante VARCHAR(100),
    regiao_comercializacao TEXT,
    data_registro_ans DATE
);

CREATE TABLE demonstracoes_contabeis (
    data DATE,
    reg_ans INT,
    cd_conta_contabil VARCHAR(50),
    descricao VARCHAR(255),
    vl_saldo_inicial DECIMAL(15,2),
    vl_saldo_final DECIMAL(15,2),
    PRIMARY KEY (data, reg_ans, cd_conta_contabil),
    FOREIGN KEY (reg_ans) REFERENCES operadoras_ativas(registro_ans)
);

-- no caminho para o arquivo, precisa ser o caminho onde está baixado no seu computador 
LOAD DATA INFILE '/caminho/para/operadoras_ativas.csv'
INTO TABLE operadoras_ativas
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(registro_ans, cnpj, razao_social, nome_fantasia, modalidade, logradouro, numero, complemento, bairro, cidade, uf, cep, ddd, telefone, fax, endereco_eletronico, representante, cargo_representante, regiao_comercializacao, data_registro_ans);

LOAD DATA INFILE '/caminho/para/demonstracoes_contabeis.csv'
INTO TABLE demonstracoes_contabeis
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final);

SELECT dc.reg_ans, op.nome_fantasia, SUM(dc.vl_saldo_final) AS total_despesas
FROM demonstracoes_contabeis dc
JOIN operadoras_ativas op ON dc.reg_ans = op.registro_ans
WHERE dc.descricao LIKE '%SINISTROS CONHECIDOS OU AVISADOS%'
AND dc.data >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)  -- MySQL
-- AND dc.data >= CURRENT_DATE - INTERVAL '3 months'  -- PostgreSQL
GROUP BY dc.reg_ans, op.nome_fantasia
ORDER BY total_despesas DESC
LIMIT 10;

SELECT dc.reg_ans, op.nome_fantasia, SUM(dc.vl_saldo_final) AS total_despesas
FROM demonstracoes_contabeis dc
JOIN operadoras_ativas op ON dc.reg_ans = op.registro_ans
WHERE dc.descricao LIKE '%SINISTROS CONHECIDOS OU AVISADOS%'
AND dc.data >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)  -- MySQL
-- AND dc.data >= CURRENT_DATE - INTERVAL '1 year'  -- PostgreSQL
GROUP BY dc.reg_ans, op.nome_fantasia
ORDER BY total_despesas DESC
LIMIT 10;

