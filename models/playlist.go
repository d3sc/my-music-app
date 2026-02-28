package models

import "gorm.io/gorm"

type Playlist struct {
	gorm.Model
	Name   string `json:"name"`
	UserID uint   `json:"user_id"`
}
