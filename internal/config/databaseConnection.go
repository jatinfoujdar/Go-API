package config

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func DBinstance() *mongo.Client {
	// Load .env file
	err := godotenv.Load()
	if err != nil {
		// If not found in current directory, try parent directory
		err = godotenv.Load("../../.env")
		if err != nil {
			log.Println("Warning: .env file not found, will use system environment variables")
		}
	}

	mongoURL := os.Getenv("MONGO_URI")
	if mongoURL == "" {
		panic("MONGO_URI not set in environment")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(mongoURL))
	if err != nil {
		panic(err)
	}

	// Ping to verify connection
	if err := client.Ping(ctx, nil); err != nil {
		panic(err)
	}

	fmt.Println("✅ Connected to MongoDB!")
	return client
}

var DB *mongo.Client = DBinstance()

func OpenCollection(client *mongo.Client, collectionName string) *mongo.Collection {
	collection := client.Database("go_api").Collection(collectionName)
	return collection
}
