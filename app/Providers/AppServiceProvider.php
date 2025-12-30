<?php

declare(strict_types=1);

namespace App\Providers;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Model::preventLazyLoading(! $this->app->isProduction());
        Model::preventSilentlyDiscardingAttributes(! $this->app->isProduction());
        Model::preventAccessingMissingAttributes(! $this->app->isProduction());

        DB::prohibitDestructiveCommands($this->app->isProduction());
        DB::whenQueryingForLongerThan(500, function ($connection, $event) {
            Log::warning('Медленный запрос обнаружен', [
                'sql' => $event->sql,
                'bindings' => $event->bindings,
                'time' => $event->time . 'ms',
            ]);
        });
    }
}
