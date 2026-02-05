package routes

import (
	"github.com/gin-gonic/gin"
	controllers "github.com/jatinfoujdar/go-api/internal/controllers"
)

func AuthRoutes(incomingRoutes *gin.RouterGroup) {
	incomingRoutes.POST("users/signup", controllers.Signup)
	incomingRoutes.POST("users/login", controllers.Login)
}
