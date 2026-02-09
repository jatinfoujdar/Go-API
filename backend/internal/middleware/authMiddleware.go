package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jatinfoujdar/go-api/internal/handler"
)

func Authenticate() gin.HandlerFunc {
	return func(c *gin.Context) {
		clientToken := c.Request.Header.Get("Authorization")
		if clientToken == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "No Authorization header provided"})
			c.Abort()
			return
		}

		// Handle "Bearer <token>" format
		if len(clientToken) > 7 && clientToken[:7] == "Bearer " {
			clientToken = clientToken[7:]
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
