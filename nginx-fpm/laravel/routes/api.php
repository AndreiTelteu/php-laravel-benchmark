<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


Route::get('/products', function () {
    $products = [
        [
            'id' => 1,
            'name' => 'Product 1',
            'price' => 100,
        ],
        [
            'id' => 2,
            'name' => 'Product 2',
            'price' => 200,
        ],
        [
            'id' => 3,
            'name' => 'Product 3',
            'price' => 300,
        ]
    ];
    return response()->json($products);
});
