package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"url-shortener.com/messages"
)

type ClicksProcessor struct {
	clicksBroker     *messages.ClicksBroker
	clicksRepository *messages.ClicksRepository
}

func NewProcessor(clicksBroker *messages.ClicksBroker, clicksRepository *messages.ClicksRepository) *ClicksProcessor {

	return &ClicksProcessor{
		clicksBroker:     clicksBroker,
		clicksRepository: clicksRepository,
	}
}

func (p *ClicksProcessor) ProcessCallback(message types.Message) error {
	click := &messages.Click{}
	err := json.Unmarshal([]byte(*message.Body), click)
	if err != nil {
		return err
	}

	return p.clicksRepository.Insert(*click)
}

func (p *ClicksProcessor) FailCallback(message types.Message) error {
	approximateReceiveCount, err := strconv.Atoi(message.Attributes["ApproximateReceiveCount"])
	if err != nil {
		return p.clicksBroker.Delete(message)

	}
	if approximateReceiveCount > 3 {
		return p.clicksBroker.Delete(message)
	}
	return nil
}

func (p *ClicksProcessor) SuccessCallback(message types.Message) error {
	return p.clicksBroker.Delete(message)
}

func main() {
	queueUrl := os.Getenv("DEV_SQS_TRACKER_CLICKS")

	sqsConfig := map[string]string{
		"url": queueUrl,
	}

	clicksBroker := messages.NewClicksBroker(sqsConfig)

	dbConfig := map[string]string{
		"urlConnection": "../../url-shortener/storage/development.sqlite3",
	}

	clicksRepository := messages.NewClicksRepository(dbConfig)

	processor := NewProcessor(clicksBroker, clicksRepository)

	for {
		messages := clicksBroker.GetMessages()
		for _, message := range messages {
			fmt.Printf("Received message with ID: %s, body: %s\n", *message.MessageId, *message.Body)
			err := processor.ProcessCallback(message)
			if err == nil {
				err := processor.FailCallback(message)
				if err != nil {
					log.Fatalf("A failCallback cannot fail")
				}
				continue
			}
			err = processor.SuccessCallback(message)
			if err != nil {
				log.Fatalf("A successCallback cannot fail")
				continue
			}
			fmt.Println("message processed")

		}
	}
}
