# 🛒 Sistema de Banco de Dados para um Mercado Local

Projeto acadêmico de Banco de Dados (Ciência de Dados e IA · PUC-SP) desenvolvido com **SQLite** e **Python**.

![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white) ![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white) ![SQL](https://img.shields.io/badge/SQL-joins%20%7C%20group%20by%20%7C%20constraints-blue)

**Destaques:** modelagem relacional com 7 tabelas, chaves primárias e estrangeiras, restrições `CHECK`, tabela associativa para N:N, 8 consultas de validação (JOIN, GROUP BY, agregações) e uma aplicação de terminal em Python que registra vendas e dá baixa no estoque.

## Tema do projeto
Sistema de banco de dados para um **mercado local**, capaz de organizar e
recuperar informações sobre produtos, categorias, fornecedores, clientes,
funcionários, vendas e itens vendidos.

## Objetivo
Criar um sistema simples para auxiliar na **organização, armazenamento e
recuperação** das informações do dia a dia de um mercado local.

## Problema resolvido (Diagnóstico)
Atualmente, um mercado local que controla tudo em cadernos ou planilhas soltas
enfrenta vários problemas:

- Dificuldade para saber o **estoque real** de cada produto.
- Falta de controle sobre **quais produtos vêm de cada fornecedor**.
- Nenhum histórico organizado de **vendas, clientes e funcionários**.
- Demora para responder perguntas simples como *"qual foi o faturamento do mês?"*
  ou *"quais produtos estão acabando?"*.

Um **banco de dados centralizado** resolve isso: guarda as informações em um
único lugar, evita dados duplicados e permite consultas rápidas e confiáveis.

## Entidades utilizadas
- **Categoria** — agrupa os produtos por tipo.
- **Produto** — itens vendidos pelo mercado.
- **Fornecedor** — empresas que fornecem os produtos.
- **Cliente** — quem realiza as compras.
- **Funcionario** — quem registra as vendas.
- **Venda** — cada compra realizada.
- **ItemVenda** — os produtos que fazem parte de cada venda.

## Relacionamentos
- Uma **categoria** pode ter **vários produtos** (1:N).
- Um **fornecedor** pode fornecer **vários produtos** (1:N).
- Um **cliente** pode realizar **várias vendas** (1:N).
- Um **funcionário** pode registrar **várias vendas** (1:N).
- Uma **venda** pode possuir **vários itens** (1:N).
- Um **produto** pode aparecer em **vários itens de venda** (1:N).
- Juntas, as tabelas **Venda**, **ItemVenda** e **Produto** representam o
  relacionamento **N:N** entre vendas e produtos (resolvido pela tabela
  associativa `ItemVenda`).

## Estrutura dos arquivos
| Arquivo | Descrição |
|---------|-----------|
| `schema.sql` | Criação de todas as tabelas (DROP + CREATE + chaves + CHECK). |
| `seed.sql` | Dados fictícios para teste. |
| `queries.sql` | Consultas SELECT de validação. |
| `mercado_local.db` | Banco SQLite já gerado a partir dos scripts. |
| `app.py` | Aplicação de terminal com menu (opcional). |
| `docs/apresentacao_mercado_local.pptx` | Slides de apresentação do projeto. |
| `README.md` | Esta documentação. |

## Como executar o projeto

### Pré-requisitos
- Ter o **SQLite** instalado (comando `sqlite3`) **ou** o **Python 3**
  (que já traz o módulo `sqlite3` embutido).

### Opção A — usando o comando `sqlite3`
```bash
# 1. Cria as tabelas
sqlite3 mercado_local.db < schema.sql

# 2. Insere os dados de teste
sqlite3 mercado_local.db < seed.sql

# 3. Executa as consultas de validação
sqlite3 mercado_local.db < queries.sql
```

Para abrir o banco no modo interativo:
```bash
sqlite3 mercado_local.db
```
Dentro do prompt do SQLite, dicas úteis:
```sql
.tables          -- lista as tabelas
.headers on      -- mostra os nomes das colunas
.mode column     -- formata a saída em colunas
SELECT * FROM Produto;
.quit            -- sai
```

### Opção B — usando Python (sem instalar o sqlite3)
```bash
python3 -c "import sqlite3; c=sqlite3.connect('mercado_local.db'); c.executescript(open('schema.sql').read()); c.executescript(open('seed.sql').read()); c.commit()"
```

### Executar a aplicação de terminal (opcional)
```bash
python3 app.py
```
O menu permite: listar produtos, listar vendas, buscar produto por nome,
cadastrar um novo produto, registrar uma venda simples e sair.

## Exemplos de consultas
As consultas completas estão em `queries.sql`. Alguns exemplos:

**Produtos com categoria e fornecedor**
```sql
SELECT p.nome, c.nome AS categoria, f.nome AS fornecedor
FROM Produto p
JOIN Categoria  c ON p.id_categoria  = c.id_categoria
JOIN Fornecedor f ON p.id_fornecedor = f.id_fornecedor;
```

**Valor total de cada venda**
```sql
SELECT v.id_venda, SUM(iv.quantidade * iv.preco_unitario) AS total
FROM Venda v
JOIN ItemVenda iv ON v.id_venda = iv.id_venda
GROUP BY v.id_venda;
```

**Produtos com estoque baixo**
```sql
SELECT nome, estoque FROM Produto WHERE estoque < 10;
```

**Faturamento total do mercado**
```sql
SELECT SUM(iv.quantidade * iv.preco_unitario) AS faturamento
FROM ItemVenda iv
JOIN Venda v ON iv.id_venda = v.id_venda
WHERE v.status = 'Concluida';
```

---

> Todos os dados de `seed.sql` são fictícios.

Autor: **Lucas Ambra Cordeiro** · [LinkedIn](https://www.linkedin.com/in/lucas-ambra)
