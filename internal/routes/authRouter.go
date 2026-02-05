package routes

import(
	controllers "github.com/jatinfoujdar/go-api/internal/controllers"
	"github.com/gin-gonic/gin"
)


func AuthRoutes(incomingRoutes *gin.RouterGroup){
	incomingRoutes.POST("users/signup", controllers.Signup)
	// incomingRoutes.POST("users/login", controllers.Login)
}