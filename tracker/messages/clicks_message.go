package messages

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/service/sqs/types"
)

type Click struct {
	UrlHash   string    `url_hash:"string"`
	CreatedAt time.Time `created_at:"string"`
	UserAgent string    `user_agent:"string"`
}

type ClicksBroker struct {
	client *sqs.Client
	url    string
}

func NewClicksBroker(config map[string]string) *ClicksBroker {

	if config["url"] == "" {
		panic("SQS must have an url as destin")
	}

	cfg, err := awsconfig.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
	}

	sqsClient := sqs.NewFromConfig(cfg)

	return &ClicksBroker{
		url:    config["url"],
		client: sqsClient,
	}
}

func (s *ClicksBroker) GetMessages() []types.Message {
	msgResult, err := s.client.ReceiveMessage(context.TODO(), &sqs.ReceiveMessageInput{
		QueueUrl:            aws.String(s.url),
		MaxNumberOfMessages: 10,
		WaitTimeSeconds:     20,
	})
	if err != nil {
		log.Fatalf("Unable to receive messages from queue %v: %v", s.url, err)
	}

	return msgResult.Messages
}

func (s *ClicksBroker) Send(messageBody string) error {
	input := &sqs.SendMessageInput{
		QueueUrl:    &s.url,
		MessageBody: &messageBody,
	}

	result, err := s.client.SendMessage(context.TODO(), input)
	if err != nil {
		log.Fatalf("unable to send message to queue %q, %v", s.url, err)
		return err
	}

	fmt.Printf("Message sent successfully. Message ID: %s\n", *result.MessageId)
	return nil
}

func (s *ClicksBroker) Delete(message types.Message) error {
	_, err := s.client.DeleteMessage(context.TODO(), &sqs.DeleteMessageInput{
		QueueUrl:      &s.url,
		ReceiptHandle: message.ReceiptHandle,
	})

	return err
}
