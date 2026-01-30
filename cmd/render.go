package cmd

import (
	"go_htmx_lambda/views"

	"github.com/a-h/templ"
	"github.com/labstack/echo/v4"
)

func Render(c echo.Context, component templ.Component) error {

	return component.Render(c.Request().Context(), c.Response())

}

// RenderPage wraps generic html, e.g. header, scripts, etc.
func RenderPage(c echo.Context, title string, component templ.Component) error {

	spa := views.SPA(component, title)

	return spa.Render(c.Request().Context(), c.Response())
}
