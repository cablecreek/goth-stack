package main

import (
	"github.com/labstack/echo/v4"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"go_htmx_lambda/handlers"
	"net/http"
	"os"
	"strconv"
)

var (
	ENV_IS_PROD = getEnvBool("ENV_IS_PROD", false)
	VERSION     = getEnv("VERSION", "0.1")
	PORT        = getEnv("PORT", "8080")
)

func getEnv(key, defaultVal string) string {
	if val, ok := os.LookupEnv(key); ok && val != "" {
		return val
	}
	return defaultVal
}

func getEnvBool(key string, defaultVal bool) bool {
	if val, ok := os.LookupEnv(key); ok && val != "" {
		if b, err := strconv.ParseBool(val); err == nil {
			return b
		}
	}
	return defaultVal
}

func main() {

	// logging
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	if !ENV_IS_PROD {
		log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
	}
	log.Info().Msg("Server setup start")

	// create app
	app := echo.New()
	app.HideBanner = true
	app.HidePort = true

	// static: htmx and tailwind
	app.Static("/static", "static")

	// icon
	app.GET("/static/favicon.ico", func(c echo.Context) error {
		return c.File("/static/favicon.ico")
	})

	// system routes
	system := app.Group("sys")

	system.GET("/version", func(c echo.Context) error {
		return c.String(http.StatusOK, VERSION)
	})

	// root routes
	root := app.Group("")

	indexHandler := &handlers.IndexHandler{}
	logsHandler := &handlers.LogsHandler{}

	root.GET("/", indexHandler.GetIndexPage)
	root.GET("/health", indexHandler.GetHealth)
	root.GET("/logs", logsHandler.GetLogsPage)

	// start the server
	if err := app.Start(":" + PORT); err != nil {
		log.Fatal().Err(err).Msg("failed to start server")
	}
}
