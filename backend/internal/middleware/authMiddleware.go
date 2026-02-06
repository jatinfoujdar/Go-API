package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/internal/handler"
)

func Authenticate() gin.HandlerFunc {
	return func(c *gin.Context) {
		clientToken := c.Request.Header.Get("token")
		if clientToken == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "No Authorization header provided"})
			c.Abort()
			return
		}

		claims, msg := handler.ValidateToken(clientToken)
		if msg != "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": msg})
			c.Abort()
			return
		}

		c.Set("email", claims.Email)
		c.Set("name", claims.Name)
		c.Set("uid", claims.Uid)
		c.Set("user_type", claims.UserType)
		c.Next()
	}
}
