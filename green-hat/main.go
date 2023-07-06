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
	Token        *string
	AllowedHosts *string
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
		fmt.Print("Using DEFAULT API TOKEN\n")
	}

	hosts := os.Getenv("ALLOWED_HOSTS")
	if hosts == "" {
		hosts = "http://localhost"
		fmt.Print("Using DEFAULT API TOKEN\n")
	}

	s := &HttpServer{Token: &token, AllowedHosts: &hosts}

	http.HandleFunc("/ingest", s.handler)

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
	var data models.RoadDataInput

	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Printf("Data Recieved: %+v\n", data)
	for name, values := range r.Header {
		for _, value := range values {
			fmt.Println(name, value)
		}
	}

	err = infra.PublishRoadData(data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
}
