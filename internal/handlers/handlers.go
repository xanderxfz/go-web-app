package handlers

import (
	"html/template"
	"net/http"
	"time"
)

var (
	funcMap = template.FuncMap{
		"year": func() int { return time.Now().Year() },
	}
)

func renderTemplate(w http.ResponseWriter, data map[string]any) {
	tmpl, err := template.New("").Funcs(funcMap).ParseGlob("internal/templates/*.html")
	if err != nil {
		http.Error(w, "Template error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := tmpl.ExecuteTemplate(w, "layout.html", data); err != nil {
		http.Error(w, "Render error: "+err.Error(), http.StatusInternalServerError)
	}
}

func Index(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, map[string]any{
		"Title":   "Home",
		"Active":  "home",
		"Year":    time.Now().Year(),
	})
}

func About(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, map[string]any{
		"Title":   "About",
		"Active":  "about",
		"Year":    time.Now().Year(),
	})
}

func Health(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(`{"status":"ok"}`))
}
