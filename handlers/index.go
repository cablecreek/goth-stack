package handlers

import (
	"go_htmx_lambda/cmd"
	"go_htmx_lambda/data"
	"go_htmx_lambda/views"

	"github.com/labstack/echo/v4"
	"github.com/rs/zerolog/log"
)

type IndexHandler struct {
	ServerConfig *cmd.ServerConfig
}

func (h IndexHandler) GetIndexPage(c echo.Context) error {

	log.Info().Msg("render dashboard overview")

	metrics := data.GetMetrics()
	logs := data.GetLogs()

	component := views.Index(metrics, logs)

	// render the full page
	return cmd.RenderPage(c, "Overview", component)
}

func (h IndexHandler) GetHealth(c echo.Context) error {

	log.Info().Msg("get health component")

	health := data.GetHealth()
	component := views.HealthCard(health)

	// render just the component
	return cmd.Render(c, component)
}
