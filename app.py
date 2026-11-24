#!/usr/bin/env python3
# =====================================================================
# app.py
# Aplicação simples de terminal para o Mercado Local
# Usa o módulo sqlite3 (já incluído no Python, não precisa instalar)
# =====================================================================

import sqlite3
import os

BANCO = "mercado_local.db"


def conectar():
    """Abre conexão com o banco e ativa as chaves estrangeiras."""
    conn = sqlite3.connect(BANCO)
    conn.execute("PRAGMA foreign_keys = ON;")
    return conn


def listar_produtos():
    """Mostra todos os produtos com categoria, fornecedor, preço e estoque."""
    conn = conectar()
    cur = conn.cursor()
    cur.execute("""
        SELECT p.id_produto, p.nome, p.preco, p.estoque, c.nome, f.nome
        FROM Produto p
        JOIN Categoria  c ON p.id_categoria  = c.id_categoria
        JOIN Fornecedor f ON p.id_fornecedor = f.id_fornecedor
        ORDER BY p.id_produto
    """)
    print("\n--- PRODUTOS ---")
    print(f"{'ID':<3} {'Nome':<22} {'Preço':>8} {'Estoque':>8}  {'Categoria':<12} {'Fornecedor'}")
    for id_p, nome, preco, est, cat, forn in cur.fetchall():
        print(f"{id_p:<3} {nome:<22} {preco:>8.2f} {est:>8}  {cat:<12} {forn}")
    conn.close()


def listar_vendas():
    """Mostra as vendas com cliente, funcionário e valor total."""
    conn = conectar()
    cur = conn.cursor()
    cur.execute("""
        SELECT v.id_venda, v.data_venda, cl.nome, fu.nome,
               COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0)
        FROM Venda v
        JOIN Cliente     cl ON v.id_cliente     = cl.id_cliente
        JOIN Funcionario fu ON v.id_funcionario = fu.id_funcionario
        LEFT JOIN ItemVenda iv ON v.id_venda = iv.id_venda
        GROUP BY v.id_venda
        ORDER BY v.id_venda
    """)
    print("\n--- VENDAS ---")
    print(f"{'ID':<3} {'Data':<12} {'Cliente':<16} {'Funcionário':<16} {'Total':>8}")
    for id_v, data, cli, func, total in cur.fetchall():
        print(f"{id_v:<3} {data:<12} {cli:<16} {func:<16} {total:>8.2f}")
    conn.close()


def buscar_produto():
    """Busca produtos cujo nome contém o texto digitado."""
    termo = input("Digite parte do nome do produto: ").strip()
    conn = conectar()
    cur = conn.cursor()
    cur.execute("""
        SELECT id_produto, nome, preco, estoque
        FROM Produto
        WHERE nome LIKE ?
        ORDER BY nome
    """, (f"%{termo}%",))
    resultados = cur.fetchall()
    print("\n--- RESULTADO DA BUSCA ---")
    if not resultados:
        print("Nenhum produto encontrado.")
    for id_p, nome, preco, est in resultados:
        print(f"{id_p:<3} {nome:<22} R$ {preco:.2f}  (estoque: {est})")
    conn.close()


def cadastrar_produto():
    """Cadastra um novo produto pedindo os dados ao usuário."""
    conn = conectar()
    cur = conn.cursor()

    print("\n--- CADASTRAR PRODUTO ---")
    nome = input("Nome do produto: ").strip()

    try:
        preco = float(input("Preço (ex.: 9.90): ").replace(",", "."))
        estoque = int(input("Estoque inicial: "))
    except ValueError:
        print("Valor inválido. Cadastro cancelado.")
        conn.close()
        return

    # Mostra categorias disponíveis
    print("\nCategorias disponíveis:")
    for r in cur.execute("SELECT id_categoria, nome FROM Categoria"):
        print(f"  {r[0]} - {r[1]}")
    id_cat = input("ID da categoria: ").strip()

    # Mostra fornecedores disponíveis
    print("\nFornecedores disponíveis:")
    for r in cur.execute("SELECT id_fornecedor, nome FROM Fornecedor"):
        print(f"  {r[0]} - {r[1]}")
    id_forn = input("ID do fornecedor: ").strip()

    try:
        cur.execute("""
            INSERT INTO Produto (nome, preco, estoque, id_categoria, id_fornecedor)
            VALUES (?, ?, ?, ?, ?)
        """, (nome, preco, estoque, id_cat, id_forn))
        conn.commit()
        print(f"Produto '{nome}' cadastrado com sucesso!")
    except sqlite3.Error as e:
        print(f"Erro ao cadastrar: {e}")
    conn.close()


def registrar_venda():
    """Registra uma venda simples com um produto e dá baixa no estoque."""
    conn = conectar()
    cur = conn.cursor()

    print("\n--- REGISTRAR VENDA ---")
    print("Clientes:")
    for r in cur.execute("SELECT id_cliente, nome FROM Cliente"):
        print(f"  {r[0]} - {r[1]}")
    id_cli = input("ID do cliente: ").strip()

    print("Funcionários:")
    for r in cur.execute("SELECT id_funcionario, nome FROM Funcionario"):
        print(f"  {r[0]} - {r[1]}")
    id_func = input("ID do funcionário: ").strip()

    print("Produtos:")
    for r in cur.execute("SELECT id_produto, nome, preco, estoque FROM Produto"):
        print(f"  {r[0]} - {r[1]} (R$ {r[2]:.2f}, estoque: {r[3]})")
    id_prod = input("ID do produto: ").strip()

    try:
        qtd = int(input("Quantidade: "))
    except ValueError:
        print("Quantidade inválida. Venda cancelada.")
        conn.close()
        return

    # Verifica o produto e o estoque
    cur.execute("SELECT preco, estoque FROM Produto WHERE id_produto = ?", (id_prod,))
    prod = cur.fetchone()
    if prod is None:
        print("Produto não encontrado. Venda cancelada.")
        conn.close()
        return

    preco, estoque = prod
    if qtd > estoque:
        print(f"Estoque insuficiente (disponível: {estoque}). Venda cancelada.")
        conn.close()
        return

    try:
        # Cria a venda
        cur.execute("""
            INSERT INTO Venda (data_venda, id_cliente, id_funcionario, status)
            VALUES (date('now'), ?, ?, 'Concluida')
        """, (id_cli, id_func))
        id_venda = cur.lastrowid

        # Cria o item da venda
        cur.execute("""
            INSERT INTO ItemVenda (id_venda, id_produto, quantidade, preco_unitario)
            VALUES (?, ?, ?, ?)
        """, (id_venda, id_prod, qtd, preco))

        # Dá baixa no estoque
        cur.execute("UPDATE Produto SET estoque = estoque - ? WHERE id_produto = ?",
                    (qtd, id_prod))

        conn.commit()
        print(f"Venda nº {id_venda} registrada! Total: R$ {preco * qtd:.2f}")
    except sqlite3.Error as e:
        print(f"Erro ao registrar venda: {e}")
    conn.close()


def menu():
    """Loop principal do menu no terminal."""
    if not os.path.exists(BANCO):
        print(f"Banco '{BANCO}' não encontrado. Crie-o primeiro com schema.sql e seed.sql.")
        return

    opcoes = {
        "1": ("Listar produtos",        listar_produtos),
        "2": ("Listar vendas",          listar_vendas),
        "3": ("Buscar produto por nome", buscar_produto),
        "4": ("Cadastrar novo produto", cadastrar_produto),
        "5": ("Registrar uma venda",    registrar_venda),
    }

    while True:
        print("\n==============================")
        print("   MERCADO LOCAL - MENU")
        print("==============================")
        for chave, (texto, _) in opcoes.items():
            print(f"  {chave} - {texto}")
        print("  0 - Sair")

        escolha = input("Escolha uma opção: ").strip()
        if escolha == "0":
            print("Encerrando... Até logo!")
            break
        elif escolha in opcoes:
            opcoes[escolha][1]()
        else:
            print("Opção inválida. Tente novamente.")


if __name__ == "__main__":
    menu()
