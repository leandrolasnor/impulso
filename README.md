# Desafio para Fullstack - Impulso

Este documento descreve o passo a passo para rodar a aplicação referente ao desafio da vaga de Fullstack da Impulso

[Enunciado do problema](https://drive.google.com/file/d/1t-iMzVf1TuZuE46V0Tt61-Q02Omr0zWe/view?ts=6536cc58)

## Considerações sobre o ambiente

```
# docker-compose.yml
version: '2.22'
services:
  sidekiq:
    image: leandrolasnor/ruby:impulso
    container_name: impulso.sidekiq
    command: sh -c "bundle exec sidekiq"
    depends_on:
      - redis

  api:
    image: leandrolasnor/ruby:impulso
    container_name: impulso.api
    stdin_open: true
    tty: true
    command: sh
    ports:
      - "3000:3000"
    depends_on:
      - db
      - redis

  db:
    image: postgres:16.0
    container_name: impulso.postgresql
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: user
      POSTGRES_DB: impulso
    ports:
      - "5432:5432"

  redis:
    image: redis:alpine
    container_name: impulso.redis
    environment:
        ALLOW_EMPTY_PASSWORD: 'yes'
    ports:
        - "6379:6379"

  react:
    image: leandrolasnor/ruby:impulso
    container_name: impulso.react
    ports:
        - "3001:3001"

```

* Uma image docker foi publicada no [Docker Hub](https://hub.docker.com/layers/leandrolasnor/ruby/impulso/images/sha256-f9eecea10e8ae9a222031cbdfe7434f3d4fdc9ee2a1a1431704acfcaad9939a9?context=repo)

#### Conceitos e ferramentas utilizadas na resolução do problema
* Princípio de Inversão de Dependência
* Princípio da Segregação da Interface
* Princípio da responsabilidade única
* Princípio da substituição de Liskov
* Princípio Aberto-Fechado
* Background Processing
* Domain Driven Design
* Código Limpo
* Rubocop
* Bullet
* Dry-rb
* RSpec

## Considerações sobre a aplicação

```
# makefile
prepare:
	docker compose up db api react -d
	docker compose exec api bundle exec rake db:migrate:reset
	docker compose exec api bundle exec rake db:seed

frontend:
	docker compose exec react yarn --cwd ./reacting start
backend:
	docker compose exec api foreman start
```

* Faça o clone deste repositório ou copie os arquivos `makefile` e `docker-compose.yml` para um pasta na sua máquina

* Use o comando `make prepare` para baixar a imagem e subir os containers _api_, _react_, _db_ e _redis_

__Nessa etapa as `migrations` foram executadas e o banco de dados se encontra populado com alguns dados__

## Passo a Passo de como executar a solução

_presumo que nesse momento seu ambiente esteja devidamente configurado e o banco de dados criado e populado_

##### Frontend
* Use o comando `make frontend` para rodar o frontend
##### Backend
* Use o comando `make backend` para rodar o backend


_Acesse o frontend [`http://localhost:3001`](http://localhost:3001) e a documentação [`http://localhost:3000/api-docs`](http://localhost:3000/api-docs)_

## Swagger

* Acesse a interface do [`Swagger`](http://localhost:3000/api-docs)
* Verifique o campo `defaultHost` na interface do [`Swagger`](http://localhost:3000/api-docs) e avalie se a url esta correta (_127.0.0.1:3000_ ou _localhost:3000_)

* Nessa interface você poderá validar a documentação dos endpoints e testá-los, enviando algumas requisições http

    - cria proponente
    - lista os proponentes
    - atualiza os dados de um proponente
    - atualiza o salário de um proponente
    - remove um proponente
    - mostra um gráfico de quantidades de proponentes agrupados por alícota de INSS
