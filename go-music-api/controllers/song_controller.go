package controllers

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"time"

	"go-music-api/config"
	"go-music-api/models"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GetSongs(c *gin.Context) {
	var songs []models.Song
	config.DB.Find(&songs)

	c.JSON(200, songs)
}

func StreamSong(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid ID"})
		return
	}

	var song models.Song
	result := config.DB.First(&song, id)

	if result.Error != nil {
		c.JSON(404, gin.H{"error": "Song not found"})
		return
	}

	basePath := os.Getenv("UPLOAD_PATH")
	if basePath == "" {
		basePath = "/app/storage"
	}

	file, err := os.Open(filepath.Join(basePath, song.FilePath))
	if err != nil {
		c.JSON(404, gin.H{"error": "File not found"})
		return
	}

	fileInfo, _ := file.Stat()

	c.Header("Content-Type", "audio/mpeg")

	http.ServeContent(
		c.Writer,
		c.Request,
		fileInfo.Name(),
		fileInfo.ModTime(),
		file,
	)
}

func parseDuration(d string) int {
	val, _ := strconv.Atoi(d)
	return val
}

func AddSong(c *gin.Context) {
	title := c.PostForm("title")
	artist := c.PostForm("artist")
	duration := c.PostForm("duration")

	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "File is required"})
		return
	}

	// create folder year/month
	now := time.Now()
	year := now.Year()
	month := int(now.Month())

	basePath := os.Getenv("UPLOAD_PATH")
	if basePath == "" {
		basePath = "/app/storage"
	}

	uploadDir := fmt.Sprintf("%s/songs/%d/%02d", basePath, year, month)

	err = os.MkdirAll(uploadDir, os.ModePerm)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create directory"})
		return
	}

	// generate unique filename
	ext := filepath.Ext(file.Filename)
	filename := uuid.New().String() + ext

	fullPath := filepath.Join(uploadDir, filename)

	// save file
	if err := c.SaveUploadedFile(file, fullPath); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save file"})
		return
	}

	// save to database
	song := models.Song{
		Title:    title,
		Artist:   artist,
		FilePath: fmt.Sprintf("songs/%d/%02d/%s", year, month, filename),
		Duration: parseDuration(duration),
	}

	config.DB.Create(&song)

	c.JSON(http.StatusCreated, gin.H{
		"message": "Song added successfully!",
		"data":    song,
	})
}
