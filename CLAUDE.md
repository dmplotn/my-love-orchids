# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Обзор проекта

Это приложение Laravel 12 с использованием PHP 8.2+, PostgreSQL и Tailwind CSS v4. Проект использует Laravel Sail для локальной разработки на Docker.

## Среда разработки

### Использование Laravel Sail (Docker)

Запуск окружения разработки:
```bash
./vendor/bin/sail up -d
```

Остановка окружения разработки:
```bash
./vendor/bin/sail down
```

Доступ к shell контейнера:
```bash
./vendor/bin/sail shell
```

Выполнение artisan команд:
```bash
./vendor/bin/sail artisan <команда>
```

Выполнение composer команд:
```bash
./vendor/bin/sail composer <команда>
```

### Использование Composer скриптов (без Docker)

Запуск полного стека разработки (сервер, очереди, логи и Vite):
```bash
composer dev
```

Это параллельно запускает:
- `php artisan serve` - Сервер разработки
- `php artisan queue:listen --tries=1` - Обработчик очередей
- `php artisan pail --timeout=0` - Логи в реальном времени
- `npm run dev` - Vite dev сервер для ассетов

### Первоначальная настройка

```bash
composer setup
```

Выполняет: composer install, создание .env, генерацию app key, миграции, npm install и сборку ассетов.

## Основные команды

### Тестирование

Запуск всех тестов:
```bash
composer test
# или
php artisan test
# или с Sail
./vendor/bin/sail artisan test
```

Запуск конкретного набора тестов:
```bash
php artisan test --testsuite=Unit
php artisan test --testsuite=Feature
```

Запуск конкретного файла тестов:
```bash
php artisan test tests/Feature/ExampleTest.php
```

Запуск конкретного тестового метода:
```bash
php artisan test --filter test_example
```

### База данных

Выполнение миграций:
```bash
php artisan migrate
# или с Sail
./vendor/bin/sail artisan migrate
```

Откат миграций:
```bash
php artisan migrate:rollback
```

Пересоздание БД с заполнением:
```bash
php artisan migrate:fresh --seed
```

### Качество кода

Форматирование кода (Laravel Pint):
```bash
./vendor/bin/pint
```

Статический анализ кода (Larastan):
```bash
./vendor/bin/phpstan analyse
# или с Sail
./vendor/bin/sail phpstan analyse
```

Конфигурация Larastan находится в `phpstan.neon.dist`. Текущий уровень анализа: 5 (из 9).

### Фронтенд ассеты

Сборка ассетов для разработки:
```bash
npm run dev
```

Сборка ассетов для продакшена:
```bash
npm run build
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
