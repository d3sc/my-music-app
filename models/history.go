package models

import "gorm.io/gorm"

type PlayHistory struct {
	gorm.Model
	UserID uint `json:"user_id"`
	SongID uint `json:"song_id"`
}
