<?php

use App\Http\Middleware\ApiAuthenticate;
use Illuminate\Foundation\Application;
use Illuminate\Routing\Router;


return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(function (Router $router): void {
        $router->aliasMiddleware('auth', ApiAuthenticate::class);

        $router->middleware('auth:api')
            ->prefix('api')
            ->group(base_path('routes/api.php'));

        $router->middleware('web')
            ->group(base_path('routes/web.php'));
    })
    ->withExceptions(function ($exceptions): void {
        //
    })
    ->create();
