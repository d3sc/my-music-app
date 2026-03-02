package main

import (
	"go-music-api/config"
	"go-music-api/models"
	"go-music-api/routes"

	"github.com/gin-gonic/gin"
)

func main() {

	config.ConnectDB()

	config.DB.AutoMigrate(
		&models.User{},
		&models.Song{},
		&models.PlayHistory{},
		&models.Playlist{},
	)

	r := gin.Default()
	routes.SetupRoutes(r)

	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Music API Running",
		})
	})

	r.Run(":8080")
}
