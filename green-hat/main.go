// Sample run-helloworld is a minimal Cloud Run service.
package main

import (
	"encoding/json"
	"fmt"
	"google.io/green-hat/infra"
	"google.io/green-hat/models"
	"log"
	"net/http"
	"os"
)

type HttpServer struct {
	token *string
}

func main() {
	log.Print("starting server...")

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("defaulting to port %s", port)
	}

	token := os.Getenv("API_TOKEN")
	if token == "" {
		token = "api-key"
		fmt.Print("Using DEFAULT TOKEN")
	}

	s := &HttpServer{token: &token}

	http.HandleFunc("/ingest", s.handler)

	// Start HTTP server.
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func (server HttpServer) handler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "StatusMethodNotAllowed", http.StatusMethodNotAllowed)

		return
	}
	var data models.RoadConfig

	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	fmt.Printf("Data Recieved: %v", data)
	fmt.Printf("HOST: %s", r.Host)

	err = infra.PublishRoadData(data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
}
