package messages

import (
	"database/sql"
	"errors"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

type ClicksRepository struct {
	db *sql.DB
}

func NewClicksRepository(config map[string]string) *ClicksRepository {
	if config["urlConnection"] == "" {
		panic("An urlConnection must be provided")
	}
	db, err := sql.Open("sqlite3", config["urlConnection"])
	if err != nil {
		log.Fatal(err)
		panic("the connection can't be stablished")

	}
	return &ClicksRepository{
		db: db,
	}
}

func (r *ClicksRepository) linkExists(urlHash string) (bool, int) {
	var linkID int
	err := r.db.QueryRow("SELECT id FROM links WHERE url_hash = ?", urlHash).Scan(&linkID)
	if err != nil {
		if err == sql.ErrNoRows {
			return false, 0
		}
		log.Fatal(err)
	}
	return true, linkID
}

func (r *ClicksRepository) Insert(click Click) error {
	ok, linkID := r.linkExists(click.UrlHash)
	if !ok {
		fmt.Println("link doen't exist")
		return errors.New("This link doesn't exists")
	}
	fmt.Println("link exists")
	insertSQL := `INSERT INTO clicks (link_id, created_at, updated_at, user_agent) VALUES (?, ?, ?, ?)`
	statement, err := r.db.Prepare(insertSQL)
	if err != nil {
		fmt.Println(err.Error())
		return err
	}
	defer statement.Close()

	_, err = statement.Exec(linkID, click.CreatedAt, click.CreatedAt, click.UserAgent)
	if err != nil {
		fmt.Println("NOT inseted with success")

		fmt.Println(err.Error())
		log.Fatalln(err)
	}

	fmt.Println("inseted with success")
	return nil
}
