package config

import (
	"context"
	"fmt"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func DBinstance() *mongo.Client {
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
