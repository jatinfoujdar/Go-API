package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/internal/controllers"
	"github.com/jatinfoujdar/go-api/internal/middleware"
)

func RegisterRoutes(router *gin.Engine) {
	// Public routes
	public := router.Group("/")
	{
		public.GET("/health", func(c *gin.Context) {
			c.JSON(200, gin.H{"status": "ok"})
		})
		public.POST("/users/signup", controllers.Signup)
		public.POST("/users/login", controllers.Login)
	}

	// Protected routes
	protected := router.Group("/")
	protected.Use(middleware.Authenticate())
	{
		protected.GET("/users", controllers.GetUsers)
		protected.GET("/users/:user_id", controllers.GetUser)
		protected.PUT("/users/profile", controllers.UpdateProfile)
	}
}
