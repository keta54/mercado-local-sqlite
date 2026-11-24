-- =====================================================================
-- schema.sql
-- Sistema de Banco de Dados para um Mercado Local
-- Criação das tabelas (Modelo Lógico)
-- Compatível com SQLite
-- =====================================================================

-- Garante que as chaves estrangeiras serão verificadas pelo SQLite
PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------
-- Remoção das tabelas na ordem correta (das dependentes para as base)
-- Evita erros de chave estrangeira ao recriar o banco
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS ItemVenda;
DROP TABLE IF EXISTS Venda;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS Categoria;

-- ---------------------------------------------------------------------
-- Tabela: Categoria
-- Agrupa os produtos por tipo (ex.: Bebidas, Limpeza, Hortifruti)
-- ---------------------------------------------------------------------
CREATE TABLE Categoria (
    id_categoria   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome           TEXT NOT NULL,
    descricao      TEXT
);

-- ---------------------------------------------------------------------
-- Tabela: Fornecedor
-- Empresas que fornecem os produtos ao mercado
-- ---------------------------------------------------------------------
CREATE TABLE Fornecedor (
    id_fornecedor  INTEGER PRIMARY KEY AUTOINCREMENT,
    nome           TEXT NOT NULL,
    telefone       TEXT,
    email          TEXT,
    cidade         TEXT
);

-- ---------------------------------------------------------------------
-- Tabela: Cliente
-- Clientes cadastrados que realizam compras no mercado
-- ---------------------------------------------------------------------
CREATE TABLE Cliente (
    id_cliente     INTEGER PRIMARY KEY AUTOINCREMENT,
    nome           TEXT NOT NULL,
    cpf            TEXT,
    telefone       TEXT,
    email          TEXT
);

-- ---------------------------------------------------------------------
-- Tabela: Funcionario
-- Funcionários que registram as vendas (caixas, atendentes)
-- ---------------------------------------------------------------------
CREATE TABLE Funcionario (
    id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
    nome           TEXT NOT NULL,
    cargo          TEXT,
    salario        REAL CHECK (salario >= 0)
);

-- ---------------------------------------------------------------------
-- Tabela: Produto
-- Itens vendidos pelo mercado
-- Relaciona-se com Categoria (1:N) e Fornecedor (1:N)
-- ---------------------------------------------------------------------
CREATE TABLE Produto (
    id_produto     INTEGER PRIMARY KEY AUTOINCREMENT,
    nome           TEXT NOT NULL,
    preco          REAL NOT NULL CHECK (preco >= 0),
    estoque        INTEGER NOT NULL CHECK (estoque >= 0),
    id_categoria   INTEGER NOT NULL,
    id_fornecedor  INTEGER NOT NULL,
    FOREIGN KEY (id_categoria)  REFERENCES Categoria (id_categoria),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor (id_fornecedor)
);

-- ---------------------------------------------------------------------
-- Tabela: Venda
-- Registra cada compra realizada
-- Relaciona-se com Cliente (1:N) e Funcionario (1:N)
-- status controla a situação da venda
-- ---------------------------------------------------------------------
CREATE TABLE Venda (
    id_venda       INTEGER PRIMARY KEY AUTOINCREMENT,
    data_venda     TEXT NOT NULL,
    id_cliente     INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    status         TEXT NOT NULL DEFAULT 'Concluida'
                   CHECK (status IN ('Concluida', 'Cancelada', 'Pendente')),
    FOREIGN KEY (id_cliente)     REFERENCES Cliente (id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario (id_funcionario)
);

-- ---------------------------------------------------------------------
-- Tabela: ItemVenda
-- Tabela associativa que resolve o relacionamento N:N
-- entre Venda e Produto. Cada linha é um produto dentro de uma venda.
-- preco_unitario guarda o preço no momento da venda.
-- ---------------------------------------------------------------------
CREATE TABLE ItemVenda (
    id_item        INTEGER PRIMARY KEY AUTOINCREMENT,
    id_venda       INTEGER NOT NULL,
    id_produto     INTEGER NOT NULL,
    quantidade     INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario REAL NOT NULL CHECK (preco_unitario >= 0),
    FOREIGN KEY (id_venda)   REFERENCES Venda (id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produto (id_produto)
);
