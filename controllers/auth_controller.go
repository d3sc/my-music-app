package controllers

import (
	"go-music-api/config"
	"go-music-api/models"
	"go-music-api/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}
type RegisterRequest struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

func Register(c *gin.Context) {
	var input RegisterRequest
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

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
	var input LoginRequest

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	// c.JSON(200, gin.H{"message": input})
	// return

	var user models.User
	result := config.DB.Where("email = ?", input.Email).First(&user)

	if result.Error != nil {
		c.JSON(401, gin.H{"error": "Invalid credentials"})
		return
	}

	// c.JSON(200, gin.H{"message": user.Password + " " + input.Password})
	// return

	err := bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(input.Password),
	)

	if err != nil {
		c.JSON(401, gin.H{"error": "Invalid credentials"})
		return
	}

	token, err := utils.GenerateToken(user.ID)
	if err != nil {
		c.JSON(500, gin.H{"error": "Token generation failed"})
		return
	}

	c.JSON(200, gin.H{"token": token})
}

func Logout(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Logged out successfully!"})
}
