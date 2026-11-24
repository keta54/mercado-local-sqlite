-- =====================================================================
-- queries.sql
-- Consultas SELECT para demonstrar a recuperação de informações
-- Execute depois de schema.sql e seed.sql
-- =====================================================================

PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------
-- 1) Listar todos os produtos com sua categoria e fornecedor
-- ---------------------------------------------------------------------
SELECT
    p.nome        AS produto,
    p.preco       AS preco,
    c.nome        AS categoria,
    f.nome        AS fornecedor
FROM Produto p
JOIN Categoria  c ON p.id_categoria  = c.id_categoria
JOIN Fornecedor f ON p.id_fornecedor = f.id_fornecedor
ORDER BY p.nome;

-- ---------------------------------------------------------------------
-- 2) Consultar o estoque atual dos produtos
-- ---------------------------------------------------------------------
SELECT
    nome    AS produto,
    estoque AS quantidade_em_estoque
FROM Produto
ORDER BY estoque ASC;

-- ---------------------------------------------------------------------
-- 3) Listar vendas com nome do cliente e do funcionário responsável
-- ---------------------------------------------------------------------
SELECT
    v.id_venda     AS venda,
    v.data_venda   AS data,
    cl.nome        AS cliente,
    fu.nome        AS funcionario,
    v.status       AS status
FROM Venda v
JOIN Cliente     cl ON v.id_cliente     = cl.id_cliente
JOIN Funcionario fu ON v.id_funcionario = fu.id_funcionario
ORDER BY v.id_venda;

-- ---------------------------------------------------------------------
-- 4) Mostrar os itens de uma venda específica (exemplo: venda 1)
-- ---------------------------------------------------------------------
SELECT
    iv.id_venda                       AS venda,
    p.nome                            AS produto,
    iv.quantidade                     AS qtd,
    iv.preco_unitario                 AS preco_unit,
    (iv.quantidade * iv.preco_unitario) AS subtotal
FROM ItemVenda iv
JOIN Produto p ON iv.id_produto = p.id_produto
WHERE iv.id_venda = 1;

-- ---------------------------------------------------------------------
-- 5) Calcular o valor total de cada venda
-- ---------------------------------------------------------------------
SELECT
    v.id_venda                                AS venda,
    cl.nome                                   AS cliente,
    SUM(iv.quantidade * iv.preco_unitario)    AS valor_total
FROM Venda v
JOIN Cliente   cl ON v.id_cliente = cl.id_cliente
JOIN ItemVenda iv ON v.id_venda   = iv.id_venda
GROUP BY v.id_venda, cl.nome
ORDER BY v.id_venda;

-- ---------------------------------------------------------------------
-- 6) Mostrar produtos com estoque baixo (menos de 10 unidades)
-- ---------------------------------------------------------------------
SELECT
    nome    AS produto,
    estoque AS quantidade_em_estoque
FROM Produto
WHERE estoque < 10
ORDER BY estoque ASC;

-- ---------------------------------------------------------------------
-- 7) Mostrar o faturamento total do mercado
--    (soma de todos os itens de vendas concluídas)
-- ---------------------------------------------------------------------
SELECT
    SUM(iv.quantidade * iv.preco_unitario) AS faturamento_total
FROM ItemVenda iv
JOIN Venda v ON iv.id_venda = v.id_venda
WHERE v.status = 'Concluida';

-- ---------------------------------------------------------------------
-- 8) Mostrar os produtos mais vendidos (por quantidade total)
-- ---------------------------------------------------------------------
SELECT
    p.nome                  AS produto,
    SUM(iv.quantidade)      AS total_vendido
FROM ItemVenda iv
JOIN Produto p ON iv.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome
ORDER BY total_vendido DESC;
