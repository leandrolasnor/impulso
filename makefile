# makefile
all: prepare run

prepare:
  docker compose up db api react -d
  docker compose exec api bundle exec rake db:migrate:reset
  docker compose exec api bundle exec rake db:seed

run:
  docker compose exec react yarn --cwd ./reacting start
  docker compose exec api rails s -b 0.0.0.0
  docker compose exec api foreman start
