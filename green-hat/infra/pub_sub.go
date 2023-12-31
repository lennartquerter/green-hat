package infra

import (
	"cloud.google.com/go/pubsub"
	"context"
	"encoding/json"
	"fmt"
	"google.io/green-hat/models"
)

func PublishRoadData(roadData models.RoadDataInput) error {
	projectID := "qwiklabs-gcp-02-f86a07b06de4"
	topicID := "green-hat-ingest-schema"

	ctx := context.Background()
	client, err := pubsub.NewClient(ctx, projectID)
	if err != nil {
		return fmt.Errorf("pubsub.NewClient: %w", err)
	}
	defer client.Close()

	t := client.Topic(topicID)

	b, err := json.Marshal(roadData)
	if err != nil {
		return err
	}

	result := t.Publish(ctx, &pubsub.Message{
		Data: b,
	})

	id, err := result.Get(ctx)
	if err != nil {
		fmt.Printf("Failed to publish: %v\n", err)
		return err
	}

	fmt.Printf("Published message; msg ID: %v\n", id)

	return nil
}
