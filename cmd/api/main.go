package main

import (
	"os"

	routes "github.com/jatinfoujdar/go-api/internal/routes"

	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/cmd/initializers"
)

func init() {
	initializers.LoadEnvVariable()
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	router := gin.Default()

	routes.AuthRoutes(&(router.RouterGroup))
	routes.UserRoutes(&(router.RouterGroup))

	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": "ok",
		})
	})
	router.Run(":" + port)
}
