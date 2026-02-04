package main

import (
    "os"

	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/cmd/initializers"
)


func init(){
	initializers.LoadEnvVariable()
}

func main() {
	router := gin.Default()

	router.GET("/health", func(c *gin.Context){
       c.JSON(200, gin.H{
	    "status": "ok",
	})		
})
    port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
   router.Run(":" + port)
}