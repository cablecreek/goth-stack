package handlers

import (
	"go_htmx_lambda/cmd"
	"go_htmx_lambda/data"
	"go_htmx_lambda/views"

	"github.com/labstack/echo/v4"
	"github.com/rs/zerolog/log"
)

type LogsHandler struct {
	ServerConfig *cmd.ServerConfig
}

func (h LogsHandler) GetLogsPage(c echo.Context) error {

	log.Info().Msg("render logs page")

	logs := data.GetLogs()
	component := views.LogsPage(logs)

	return cmd.RenderPage(c, "Logs", component)
}
