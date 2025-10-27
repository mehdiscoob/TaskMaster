<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Auth\AuthenticationException;

class ApiAuthenticate extends Middleware
{
    protected function redirectTo($request): null
    {
        return null;
    }

    public function handle($request, Closure $next, ...$guards)
    {
        try {
            return parent::handle($request, $next, ...$guards);
        } catch (AuthenticationException $e) {
            report($e);
            return response()->json(['message' => 'Unauthenticated'], 401);
        }
    }
}
