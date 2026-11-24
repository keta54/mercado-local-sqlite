-- =====================================================================
-- seed.sql
-- Dados fictícios para teste e validação do sistema
-- Execute SEMPRE depois do schema.sql
-- =====================================================================

PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------
-- Categorias (4)
-- ---------------------------------------------------------------------
INSERT INTO Categoria (nome, descricao) VALUES
    ('Bebidas',    'Refrigerantes, sucos, água e bebidas em geral'),
    ('Limpeza',    'Produtos de limpeza e higiene da casa'),
    ('Hortifruti', 'Frutas, verduras e legumes'),
    ('Mercearia',  'Alimentos secos e enlatados');

-- ---------------------------------------------------------------------
-- Fornecedores (4)
-- ---------------------------------------------------------------------
INSERT INTO Fornecedor (nome, telefone, email, cidade) VALUES
    ('Distribuidora Sol',     '11-3001-1000', 'contato@sol.com',    'São Paulo'),
    ('Atacado Bom Preço',     '11-3002-2000', 'vendas@bompreco.com','Guarulhos'),
    ('Frutas da Serra',       '11-3003-3000', 'serra@frutas.com',   'Campinas'),
    ('Limpa Tudo Ltda',       '11-3004-4000', 'sac@limpatudo.com',  'Osasco');

-- ---------------------------------------------------------------------
-- Clientes (5)
-- ---------------------------------------------------------------------
INSERT INTO Cliente (nome, cpf, telefone, email) VALUES
    ('Ana Souza',      '111.111.111-11', '11-90001-0001', 'ana@email.com'),
    ('Bruno Lima',     '222.222.222-22', '11-90002-0002', 'bruno@email.com'),
    ('Carla Mendes',   '333.333.333-33', '11-90003-0003', 'carla@email.com'),
    ('Diego Rocha',    '444.444.444-44', '11-90004-0004', 'diego@email.com'),
    ('Elaine Costa',   '555.555.555-55', '11-90005-0005', 'elaine@email.com');

-- ---------------------------------------------------------------------
-- Funcionários (3)
-- ---------------------------------------------------------------------
INSERT INTO Funcionario (nome, cargo, salario) VALUES
    ('Fernando Alves', 'Caixa',      1800.00),
    ('Gabriela Dias',  'Caixa',      1850.00),
    ('Henrique Melo',  'Gerente',    3500.00);

-- ---------------------------------------------------------------------
-- Produtos (8)
-- id_categoria / id_fornecedor seguem a ordem inserida acima
-- ---------------------------------------------------------------------
INSERT INTO Produto (nome, preco, estoque, id_categoria, id_fornecedor) VALUES
    ('Refrigerante 2L',      8.50,  40, 1, 1),  -- Bebidas / Sol
    ('Suco de Laranja 1L',   6.00,  25, 1, 1),  -- Bebidas / Sol
    ('Detergente 500ml',     2.80,  60, 2, 4),  -- Limpeza / Limpa Tudo
    ('Sabão em Pó 1kg',     12.90,  8,  2, 4),  -- Limpeza / Limpa Tudo (estoque baixo)
    ('Banana Prata kg',      4.50,  30, 3, 3),  -- Hortifruti / Frutas da Serra
    ('Maçã Gala kg',         7.20,  5,  3, 3),  -- Hortifruti / Frutas da Serra (estoque baixo)
    ('Arroz 5kg',           24.90,  20, 4, 2),  -- Mercearia / Bom Preço
    ('Feijão 1kg',           8.90,  35, 4, 2);  -- Mercearia / Bom Preço

-- ---------------------------------------------------------------------
-- Vendas (5)
-- ---------------------------------------------------------------------
INSERT INTO Venda (data_venda, id_cliente, id_funcionario, status) VALUES
    ('2025-06-01', 1, 1, 'Concluida'),
    ('2025-06-01', 2, 2, 'Concluida'),
    ('2025-06-02', 3, 1, 'Concluida'),
    ('2025-06-03', 4, 3, 'Concluida'),
    ('2025-06-03', 5, 2, 'Concluida');

-- ---------------------------------------------------------------------
-- Itens de Venda (12)
-- preco_unitario reflete o preço do produto no momento da venda
-- ---------------------------------------------------------------------
INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES
    -- Venda 1
    (1, 1, 2, 8.50),
    (1, 3, 3, 2.80),
    (1, 7, 1, 24.90),
    -- Venda 2
    (2, 5, 4, 4.50),
    (2, 8, 2, 8.90),
    -- Venda 3
    (3, 2, 3, 6.00),
    (3, 6, 1, 7.20),
    (3, 1, 1, 8.50),
    -- Venda 4
    (4, 7, 2, 24.90),
    (4, 4, 1, 12.90),
    -- Venda 5
    (5, 8, 3, 8.90),
    (5, 5, 2, 4.50);
