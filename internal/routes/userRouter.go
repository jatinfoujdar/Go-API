package routes

import (
	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/internal/controllers"
	"github.com/jatinfoujdar/go-api/internal/middleware"
)

func UserRoutes(incomingRoutes *gin.RouterGroup) {
	incomingRoutes.Use(middleware.Authenticate())

	incomingRoutes.GET("/users", controllers.GetUsers)
	incomingRoutes.GET("/users/:user_id", controllers.GetUser)
}
