.PHONY: help setup up down shell install migrate migrate-fresh seed test format analyse check serve queue clear-cache optimize clean tinker routes

# Определяем, запущен ли Docker
DOCKER_RUNNING := $(shell docker ps -q 2>/dev/null)
ifdef DOCKER_RUNNING
    SAIL := ./vendor/bin/sail
    ARTISAN := $(SAIL) artisan
    COMPOSER := $(SAIL) composer
else
    SAIL :=
    ARTISAN := php artisan
    COMPOSER := composer
endif

# PHPStan всегда запускается напрямую
PHPSTAN := ./vendor/bin/phpstan

# Цвета для вывода
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

## Помощь
help: ## Показать эту справку
	@echo ''
	@echo 'Использование:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Доступные команды:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "  ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

## Установка и настройка
setup: ## Первоначальная настройка проекта
	@echo "${GREEN}Установка зависимостей...${RESET}"
	$(COMPOSER) install
	@if [ ! -f .env ]; then \
		echo "${GREEN}Создание .env файла...${RESET}"; \
		cp .env.example .env; \
	fi
	@echo "${GREEN}Генерация ключа приложения...${RESET}"
	$(ARTISAN) key:generate
	@echo "${GREEN}Запуск миграций...${RESET}"
	$(ARTISAN) migrate --force
	@echo "${GREEN}✓ Настройка завершена!${RESET}"

install: ## Установка composer зависимостей
	$(COMPOSER) install

## Docker команды
up: ## Запустить Docker контейнеры
	./vendor/bin/sail up -d

down: ## Остановить Docker контейнеры
	./vendor/bin/sail down

shell: ## Войти в shell контейнера
	./vendor/bin/sail shell

logs: ## Показать логи контейнеров
	./vendor/bin/sail logs -f

## База данных
migrate: ## Запустить миграции
	$(ARTISAN) migrate

migrate-fresh: ## Пересоздать БД с миграциями
	$(ARTISAN) migrate:fresh

migrate-fresh-seed: ## Пересоздать БД с заполнением
	$(ARTISAN) migrate:fresh --seed

seed: ## Заполнить БД тестовыми данными
	$(ARTISAN) db:seed

## Тестирование
test: ## Запустить все тесты
	$(ARTISAN) config:clear
	$(ARTISAN) test

test-unit: ## Запустить юнит-тесты
	$(ARTISAN) test --testsuite=Unit

test-feature: ## Запустить функциональные тесты
	$(ARTISAN) test --testsuite=Feature

test-coverage: ## Запустить тесты с покрытием
	$(ARTISAN) test --coverage

## Качество кода
format: ## Форматировать код (Pint)
	./vendor/bin/pint

format-test: ## Проверить форматирование без изменений
	./vendor/bin/pint --test

analyse: ## Статический анализ кода (Larastan)
	$(PHPSTAN) analyse --memory-limit=256M

check: format-test analyse test ## Полная проверка (форматирование + анализ + тесты)

## Разработка
serve: ## Запустить dev сервер
	$(ARTISAN) serve

queue: ## Запустить обработчик очередей
	$(ARTISAN) queue:listen

queue-work: ## Запустить queue worker
	$(ARTISAN) queue:work

## Очистка
clear-cache: ## Очистить все кеши
	$(ARTISAN) cache:clear
	$(ARTISAN) config:clear
	$(ARTISAN) route:clear
	$(ARTISAN) view:clear

optimize: ## Оптимизировать приложение для production
	$(ARTISAN) config:cache
	$(ARTISAN) route:cache
	$(ARTISAN) view:cache

clean: ## Очистить временные файлы
	rm -rf bootstrap/cache/*.php
	rm -rf storage/framework/cache/data/*
	rm -rf storage/framework/sessions/*
	rm -rf storage/framework/views/*
	rm -rf storage/logs/*.log

## Утилиты
tinker: ## Запустить tinker (REPL)
	$(ARTISAN) tinker

routes: ## Показать все маршруты
	$(ARTISAN) route:list
