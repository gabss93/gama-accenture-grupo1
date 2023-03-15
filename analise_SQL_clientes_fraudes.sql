# Cria uma tabela "clientes_cadastro" que une todos os clientes cadastrados da tabela "clients" com os clientes não cadastrados presentes na tabela "transactions" e indica que o cliente possui um id mas não tem cadastro 

SELECT DISTINCT
    ISNULL(t.cliente_id, c.id) AS id,
    ISNULL(c.nome, 'Cliente não cadastrado') AS Nome,
    ISNULL(c.email, 'Não cadastrado') AS Email,
    ISNULL(c.telefone, 'Não cadastrado') AS Telefone,
    ISNULL(CONVERT(VARCHAR(15), c.data_cadastro, 120), 'Não cadastrado') AS Data_cadastro
INTO clientes_cadastro
FROM transactions t
FULL OUTER JOIN clients c ON t.cliente_id = c.id;


# Cria uma tabela "transacao_clientes_fraudes" com as colunas da tabela "transactions" e adiciona uma nova coluna "Fraude" que indica se a transação é fraudulenta ou não.

SELECT 
    t.id, 
    t.cliente_id, 
    t.valor, 
    t.tipo_transacao, 
    t.data, 
    CASE 
        WHEN DATEDIFF(SECOND, LAG(t.data) OVER (PARTITION BY t.cliente_id ORDER BY t.data), t.data) <= 120 
            THEN 'Sim' 
        ELSE 'Não' 
    END AS fraude,
    ISNULL(DATEDIFF(SECOND, LAG(t.data) OVER (PARTITION BY t.cliente_id ORDER BY t.data), t.data), 0) AS diferenca_tempo
INTO transacao_clientes_fraudes
FROM transactions t





