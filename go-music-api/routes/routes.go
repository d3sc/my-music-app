package routes

import (
	"go-music-api/controllers"
	"go-music-api/middleware"
	"os"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {

	api := r.Group("/api")

	api.POST("/register", controllers.Register)
	api.POST("/login", controllers.Login)
	api.POST("/logout", controllers.Logout)

	protected := api.Group("/")
	protected.Use(middleware.AuthMiddleware())

	protected.GET("/songs", controllers.GetSongs)
	protected.GET("/songs/:id/stream", controllers.StreamSong)
	protected.POST("/songs", controllers.AddSong)

	uploadPath := os.Getenv("UPLOAD_PATH")
	if uploadPath == "" {
		uploadPath = "/app/storage"
	}

	protected.Static("/storage", uploadPath)
}
