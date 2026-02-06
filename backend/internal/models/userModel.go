package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type User struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	Name      string             `bson:"name" json:"name" binding:"required"`
	Email     string             `bson:"email" json:"email" binding:"required,email"`
	Password  string             `bson:"password" json:"-" binding:"required,min=8"`
	UserType  string             `bson:"user_type" validate:"required,eq=USER|eq=ADMIN" json:"user_type"`
	CreatedAt time.Time          `bson:"created_at,omitempty" json:"created_at,omitempty"`
}
