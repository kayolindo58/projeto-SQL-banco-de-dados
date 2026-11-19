-- Active: 1794677877797@@127.0.0.1@3306@biblioteca_sql_3

CREATE DATABASE IF NOT EXISTS biblioteca_sql_3;

USE biblioteca_sql_3;

CREATE TABLE socios (
    id_socio INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    estado CHAR(2)
);

CREATE TABLE emprestimos (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT,
    id_livro INT,
    emprestimo DECIMAL(10, 2),
    data_emprestimo DATE DEFAULT(CURRENT_DATE),
    multa DECIMAL(10, 2),
    data_devolucao DATE DEFAULT NULL,
    CONSTRAINT fk_emprestimos_socios_livros FOREIGN KEY (id_socio) REFERENCES socios (id_socio),
    FOREIGN KEY (id_livro) REFERENCES livros (id_livro)
);

CREATE TABLE livros (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    preco DECIMAL(10, 2)
);

CREATE TABLE autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    id_livro INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    CONSTRAINT fk_autores_livros FOREIGN KEY (id_livro) REFERENCES livros (id_livro)
);

INSERT INTO
    livros (nome, preco)
VALUES ("O Príncipe", 15.96),
    ("A Arte da Guerra", 13.30),
    ("1984", 21.95),
    (
        "A Revolução dos Bichos",
        22.00
    ),
    ("O Estrangeiro", 35.18);

INSERT INTO
    autores (id_livro, nome)
VALUES (1, "Nicolau Maquiavel"),
    (2, "Sun Tzu"),
    (3, "George Orwell"),
    (4, "George Orwell"),
    (5, "Albert Camus");

INSERT INTO
    socios (nome, estado)
VALUES ("wagner", "BA"),
    ("filipe", "BA"),
    ("gabriel", "BA"),
    ("Robson", "BA");

INSERT INTO
    emprestimos (
        id_socio,
        id_livro,
        multa,
        emprestimo,
        data_devolucao,
        data_emprestimo
    )
VALUES (
        2,
        2,
        4.00,
        2,
        '2026-11-18',
        '2026-11-30'
    ),
    (
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    );

INSERT INTO
    emprestimos (
        id_socio,
        id_livro,
        multa,
        emprestimo,
        data_devolucao,
        data_emprestimo
    )
VALUES (
        4,
        1,
        NULL,
        10.00,
        '2026-08-08',
        '2027-02-02'
    ),
    (
        3,
        4,
        15.00,
        2.00,
        '2026-08-07',
        '2026-12-08'
    ),
    (
        3,
        5,
        27.00,
        30.00,
        '2026-08-07',
        '2026-12-08'
    );

INSERT INTO livros (nome, preco) VALUES ("O homem de giz", 34.43);

INSERT INTO autores (id_livro, nome) VALUES (6, "C. J. Tudor");

INSERT INTO
    emprestimos (
        id_socio,
        id_livro,
        multa,
        emprestimo,
        data_emprestimo,
        data_devolucao
    )
VALUES (
        4,
        6,
        NULL,
        50.00,
        '2026-08-08',
        NULL
    );

-- PARTE 3 CRUD

-- CREATE

INSERT INTO socios (nome, estado) VALUES ("rafael", "MG");

INSERT INTO
    livros (nome, preco)
VALUES (
        "Sapiens: Uma Breve História da Humanidade",
        30.00
    );

INSERT INTO autores (id_livro, nome) VALUES (7, "Yuval Noah Harari");

-- READ

SELECT * FROM socios;

SELECT * FROM livros WHERE preco >= 30.00;

SELECT * FROM livros WHERE preco >= 30.00 ORDER BY preco DESC;

SELECT c.estado, m.emprestimo
FROM socios c
    INNER JOIN emprestimos m ON c.id_socio = m.id_emprestimo;

SELECT c.estado, SUM(m.emprestimo) - SUM(m.multa) AS total
FROM socios c
    INNER JOIN emprestimos m ON c.id_socio = m.id_emprestimo
GROUP BY
    c.estado
ORDER BY total;

-- UPDATE

INSERT INTO socios (nome, estado) VALUES ("sampaio araujo", "BA");

UPDATE socios
SET
    nome = "thiago sampaio araujo",
    estado = "SP"
WHERE
    id_socio = 6;

SELECT * FROM livros WHERE id_livro = 5;

UPDATE livros SET preco = 30.00 WHERE id_livro = 5;

SELECT * FROM livros WHERE id_livro = 5;

-- DELETE

SELECT * FROM emprestimos;

DELETE FROM socios WHERE id_socio = 1;

SELECT * FROM socios;

-- PARTE 4 JOIN's

-- A)

SELECT m.emprestimo, c.nome, a.nome, t.nome
FROM
    emprestimos m
    INNER JOIN socios c ON m.id_emprestimo = c.id_socio
    INNER JOIN livros a ON c.id_socio = a.id_livro
    INNER JOIN autores t ON a.id_livro = t.id_autor;

-- B)

SELECT c.nome, c.estado, m.emprestimo
FROM socios c
    LEFT JOIN emprestimos m ON c.id_socio = m.id_emprestimo;

-- C)

SELECT a.nome, a.preco, m.emprestimo
FROM livros a
    LEFT JOIN emprestimos m ON a.id_livro = m.id_emprestimo
WHERE
    emprestimo IS NULL;

-- D)

SELECT c.nome, c.estado, m.emprestimo
FROM socios c
    RIGHT JOIN emprestimos m ON c.id_socio = m.id_emprestimo;

-- right join e left join é a mesma coisa mas em lados difernetes.

-- E)

SELECT a.nome, a.preco, t.nome
FROM livros a
    INNER JOIN autores t ON a.id_livro = t.id_autor;

-- PARTE 5 AGREGAÇÃO

-- A)

SELECT COUNT(m.emprestimo) FROM emprestimos m;

-- B)

SELECT SUM(m.multa) FROM emprestimos m;

-- C)

SELECT AVG(a.preco) FROM livros a;

SELECT MAX(a.preco) FROM livros a;

SELECT MIN(a.preco) FROM livros a;

-- D)

SELECT COUNT(DISTINCT m.emprestimo) FROM emprestimos m;

-- E)

SELECT c.estado, COUNT(m.multa) AS total_multa
FROM emprestimos m
    INNER JOIN socios c ON m.id_emprestimo = c.id_socio
GROUP BY
    c.estado
ORDER BY total_multa;

-- F)

SELECT c.estado, COUNT(m.emprestimo) AS total_emprestimo
FROM socios c
    INNER JOIN emprestimos m ON c.id_socio = m.emprestimo
WHERE
    m.data_emprestimo > '2026-11-01'
GROUP BY
    c.estado
HAVING
    COUNT(*) > 2;

-- PARTE 6 CONSULTAS AVANÇADAS

-- A)

SELECT c.nome, c.preco
FROM livros c
WHERE
    preco > (
        SELECT AVG(preco)
        FROM livros
    );

-- B)

-- IN
SELECT c.id_socio, c.nome
FROM socios c
WHERE
    c.id_socio IN (
        SELECT m.id_socio
        FROM emprestimos m
    );

-- IN em not exists
SELECT c.id_socio, c.nome
FROM socios c
WHERE
    NOT EXISTS (
        SELECT 1
        FROM emprestimos m
        WHERE
            m.id_socio = c.id_socio
    );


-- C)

SELECT c.id_socio, c.nome
FROM socios c
WHERE EXISTS (
        SELECT 1
        FROM emprestimos m
        WHERE
            m.id_socio = c.id_socio
    );

-- D)

SELECT DISTINCT
c.nome,
c.id_socio
FROM socios c
INNER JOIN emprestimos m
ON c.id_socio = m.id_socio;

SELECT DISTINCT
c.nome,
c.id_socio
FROM socios c
LEFT JOIN emprestimos m
ON c.id_socio = m.id_socio
WHERE m.id_socio IS NULL;

-- esse foi mais facil

-- E)

EXPLAIN SELECT
m.id_emprestimo, 
m.emprestimo 
FROM emprestimos m 
WHERE m.id_socio = m.id_emprestimo;

-- F) 

-- INNER JOIN é otimo pra consulta
-- SELECT
-- GROUP BY e ORDER BY

-- PARTE 7 CENARIOS DE CONSULTAS

-- RELATORIO

SELECT
c.nome,
COALESCE(SUM(m.multa), 0) AS multa_total
FROM emprestimos m
LEFT JOIN socios c
ON m.id_emprestimo = c.id_socio
GROUP BY m.multa, c.nome
ORDER BY multa_total DESC;

-- RANKING

SELECT
p.id_livro,
p.nome,
COUNT(m.id_emprestimo) AS total_emprestimos
FROM livros p
LEFT JOIN emprestimos m
ON m.id_livro = p.id_livro
GROUP BY p.id_livro, p.nome
ORDER BY total_emprestimos DESC, p.nome ASC
LIMIT 3;

-- CRUZAMENTO

SELECT
c.estado,
COUNT(DISTINCT m.id_emprestimo) AS total_emprestimos,
COALESCE(SUM(m.multa), 0) AS total_multas
FROM socios c
LEFT JOIN emprestimos m
ON c.id_socio = m.id_emprestimo
GROUP BY c.id_socio, c.nome
ORDER BY total_emprestimos DESC, total_multas DESC, c.estado ASC;

-- 