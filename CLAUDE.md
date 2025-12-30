# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Обзор проекта

Это приложение Laravel 12 с использованием PHP 8.2+, PostgreSQL и Tailwind CSS v4. Проект использует Laravel Sail для локальной разработки на Docker.

## Среда разработки

### Использование Makefile

Проект использует Makefile для унификации команд. Makefile автоматически определяет, запущен ли Docker, и использует соответствующие команды (Sail или напрямую).

Справка по доступным командам:
```bash
make help
```

### Первоначальная настройка

```bash
make setup
```

Выполняет: composer install, создание .env, генерацию app key, миграции.

### Docker команды

```bash
make up              # Запустить Docker контейнеры
make down            # Остановить Docker контейнеры
make shell           # Войти в shell контейнера
make logs            # Показать логи контейнеров
```

## Основные команды

### База данных

```bash
make migrate              # Запустить миграции
make migrate-fresh        # Пересоздать БД с миграциями
make migrate-fresh-seed   # Пересоздать БД с заполнением
make seed                 # Заполнить БД тестовыми данными
```

### Тестирование

```bash
make test                 # Запустить все тесты
make test-unit            # Запустить юнит-тесты
make test-feature         # Запустить функциональные тесты
make test-coverage        # Запустить тесты с покрытием
```

Для запуска конкретного файла или метода используйте artisan напрямую:
```bash
php artisan test tests/Feature/ExampleTest.php
php artisan test --filter test_example
```

### Качество кода

```bash
make format               # Форматировать код (Pint)
make format-test          # Проверить форматирование без изменений
make analyse              # Статический анализ кода (Larastan)
make check                # Полная проверка (форматирование + анализ + тесты)
```

Конфигурация Larastan находится в `phpstan.neon.dist`. Текущий уровень анализа: 5 (из 9).

### Разработка

```bash
make serve                # Запустить dev сервер
make queue                # Запустить обработчик очередей
make queue-work           # Запустить queue worker
make tinker               # Запустить tinker (REPL)
make routes               # Показать все маршруты
```

### Очистка и оптимизация

```bash
make clear-cache          # Очистить все кеши
make optimize             # Оптимизировать для production
make clean                # Очистить временные файлы
```

## Архитектура

### Структура директорий

- `app/Http/Controllers/` - HTTP контроллеры
- `app/Models/` - Eloquent модели
- `app/Providers/` - Сервис-провайдеры
- `routes/web.php` - Веб-маршруты
- `routes/console.php` - Консольные команды
- `resources/views/` - Blade шаблоны
- `resources/css/` - CSS файлы (Tailwind)
- `resources/js/` - JavaScript файлы
- `database/migrations/` - Миграции базы данных
- `database/factories/` - Фабрики моделей
- `database/seeders/` - Сидеры базы данных
- `tests/Feature/` - Функциональные тесты
- `tests/Unit/` - Юнит-тесты

### Технологический стек

- **Backend**: Laravel 12, PHP 8.2+
- **База данных**: PostgreSQL 18
- **Кеш/Очереди**: Valkey (альтернатива Redis)
- **Frontend**: Tailwind CSS v4, Vite 7
- **Тестирование email**: Mailpit
- **Тестирование**: PHPUnit 11
- **Качество кода**: Laravel Pint (форматирование), Larastan (статический анализ)
- **Автоматизация**: Makefile для унификации команд разработки

### Docker сервисы

Файл `compose.yaml` определяет следующие сервисы:
- `laravel.test` - Основное приложение (PHP 8.5)
- `pgsql` - База данных PostgreSQL 18
- `valkey` - Valkey для кеша/сессий/очередей
- `mailpit` - Интерфейс для тестирования email (http://localhost:8025)

### Процесс сборки фронтенда

Vite настроен для:
- Обработки `resources/css/app.css` и `resources/js/app.js`
- Использования Tailwind CSS v4 через плагин `@tailwindcss/vite`
- Игнорирования изменений в `storage/framework/views/` для предотвращения лишних пересборок
- Hot reload при изменении файлов в режиме разработки

### Конфигурация тестирования

PHPUnit настроен с:
- Раздельными наборами тестов для Unit и Feature
- Тестовой базой данных с именем "testing"
- Array драйверами для mail, cache, session во время тестов
- Покрытием кода для директории `app/`
