package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/middleware"
	chi "github.com/go-chi/chi/v5"
	"url-shortener.com/messages"
)

func main() {

	queueUrl := os.Getenv("DEV_SQS_TRACKER_CLICKS")

	sqsConfig := map[string]string{
		"url": queueUrl,
	}
	sender := messages.NewClicksBroker(sqsConfig)

	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Get("/{urlHash}", func(w http.ResponseWriter, r *http.Request) {
		urlHash := chi.URLParam(r, "urlHash")

		click := messages.Click{
			CreatedAt: time.Now(),
			UserAgent: r.UserAgent(),
			UrlHash:   urlHash,
		}

		jsonResponse, err := json.Marshal(click)
		if err != nil {
			w.Write([]byte(err.Error()))
		}

		messageBody := string(jsonResponse)

		err = sender.Send(messageBody)
		if err != nil {
			log.Fatalf(err.Error())
		}

		w.Write(jsonResponse)
	})
	http.ListenAndServe(":3000", r)
}
