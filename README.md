# Desafio para Fullstack - Impulso

:page_with_curl: [Enunciado do problema](https://drive.google.com/file/d/1t-iMzVf1TuZuE46V0Tt61-Q02Omr0zWe/view?ts=6536cc58)

#### Conceitos e ferramentas utilizadas na resolução do problema
`Docker`

`Ruby on Rails` `Dry-rb` `Sidekiq`

`React` `Redux` `Redis` `RSpec` `RSwag`

`SOLID` `DDD` `Clear Code` `Clean Arch`

`PostgreSQL`

# .devcontainer :whale:

1. Rode o comando no Visual Code `> Dev Containers: Clone Repository in Container Volume...` e dê `Enter`.
2. Informe a url: `https://github.com/leandrolasnor/impulso` e dê `Enter`
4. :hourglass_flowing_sand: Aguarde até [+] Building **352.7s** (31/31) FINISHED

## Com o processo de build concluido, faça:

* Rode o comando no terminal: `foreman start`
* Acesse o [`frontend`](http://localhost:3001)

## Swagger

* Acesse o [`Swagger`](http://localhost:3000/api-docs)
* Verifique o campo `defaultHost` na interface do [`Swagger`](http://localhost:3000/api-docs) e avalie se a url esta correta (_127.0.0.1:3000_ ou _localhost:3000_)

* Nessa interface você poderá validar a documentação dos endpoints e testá-los, enviando algumas requisições http
    - cria proponente
    - lista os proponentes
    - atualiza os dados de um proponente
    - atualiza o salário de um proponente
    - remove um proponente
    - mostra um gráfico de quantidades de proponentes agrupados por alícota de INSS