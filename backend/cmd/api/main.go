package main

import (
	"os"

	routes "github.com/jatinfoujdar/go-api/internal/routes"

	"github.com/gin-gonic/gin"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	router := gin.Default()
	router.SetTrustedProxies(nil)

	// Register all routes
	routes.RegisterRoutes(router)

	router.Run(":" + port)
}
