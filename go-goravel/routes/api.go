package routes

import (
	"github.com/goravel/framework/contracts/http"
	"github.com/goravel/framework/facades"
)

type Product struct {
	Id    int     `json:"id"`
	Name  string  `json:"name"`
	Price float64 `json:"price"`
}

func Api() {

	// userController := controllers.NewUserController()
	// facades.Route().Get("/users/{id}", userController.Show)

	facades.Route().Get("/products", func(ctx http.Context) http.Response {
		products := []Product{
			{1, "Product 1", 100},
			{2, "Product 2", 200},
			{3, "Product 3", 300},
		}
		return ctx.Response().Success().Json(products)
	})
}
