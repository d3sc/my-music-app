package controllers

import (
	"go-music-api/config"
	"go-music-api/models"
	"go-music-api/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

func Register(c *gin.Context) {
	var input models.User
	c.ShouldBindJSON(&input)

	hash, _ := bcrypt.GenerateFromPassword([]byte(input.Password), 14)

	user := models.User{
		Name:     input.Name,
		Email:    input.Email,
		Password: string(hash),
	}

	config.DB.Create(&user)

	c.JSON(201, gin.H{"message": "User created"})
}

func Login(c *gin.Context) {
	var input models.User
	c.ShouldBindJSON(&input)

	var user models.User
	config.DB.Where("email = ?", input.Email).First(&user)

	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(input.Password))
	if err != nil {
		c.JSON(401, gin.H{"error": "Invalid credentials"})
		return
	}

	token, _ := utils.GenerateToken(user.ID)

	c.JSON(200, gin.H{"token": token})
}

func Logout(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Logged out successfully!"})
}
