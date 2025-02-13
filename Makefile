database:
	docker compose up -d db

bundle:
	docker compose run --rm --no-deps web bundle

migrate:
	docker compose run --rm --no-deps web bundle exec rails db:migrate

web:
	docker compose up --no-deps -d web

test_web:
	docker compose -f docker-compose.test.yml up --no-deps -d test_web

# test_clobber:
# 	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rake assets:clobber
# 	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rake assets:clean

test_precompile:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rails assets:precompile

test_bundle:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle

test_db:
	docker compose -f docker-compose.test.yml up -d test_db

test_migrate:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rails db:create RAILS_ENV=test
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web bundle exec rails db:migrate RAILS_ENV=test

rspec:
	docker compose -f docker-compose.test.yml run --rm --no-deps test_web rspec spec/

rspec_down:
	docker compose -f docker-compose.test.yml down -v
