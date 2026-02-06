package initializers

import (
	"log"

	"github.com/joho/godotenv"
)

func LoadEnvVariable() {
	// Try loading .env from current directory
	err := godotenv.Load()
	if err != nil {
		err = godotenv.Load("../../.env")
		if err != nil {
			log.Println("Warning: .env file not found, using system environment variables")
		}
	}
}
