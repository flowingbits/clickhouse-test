package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/ClickHouse/clickhouse-go/v2/lib/driver"
	"log"
	"time"
)

func main() {
	chAddr := flag.String("ch-addr", "127.0.0.1:9000", "ClickHouse <host>:<port> to connect to")
	chDatabase := flag.String("ch-database", "default", "ClickHouse database to connect to")
	chUsername := flag.String("ch-username", "default", "ClickHouse username to use")
	chPassword := flag.String("ch-password", "", "ClickHouse password")
	iteractiveMode := flag.Bool("interactive-mode", false, "")

	flag.Parse()

	conn, err := connect(*chAddr, *chDatabase, *chUsername, *chPassword)
	if err != nil {
		log.Fatal(err)
	}

	ctx := context.Background()
	rows, err := conn.Query(ctx, `
         select p.*, li.createdAt impTimestamp, impTimestamp != toDateTime('1970-01-01 00:00:00') impAttributed
         from pixels p
                  left join last_impressions li
                            on p.advertiserId = li.advertiserId and p.extId = li.extId
         settings join_algorithm = 'full_sorting_merge'
	`)
	if err != nil {
		log.Fatalf("Unable to fetch data: %v", err)
	}

	defer rows.Close()

	if *iteractiveMode {
		for {
			fmt.Println("\nHow many rows would you like to read? Please enter a number:")
			var numRows int
			_, err := fmt.Scanf("%d", &numRows)
			if err != nil {
				log.Fatalf("Failed to read the number of rows: %v", err)
			}
			for ; numRows > 0 && rows.Next(); numRows-- {
				readAndPrintPixel(rows)
			}
		}
	} else {
		for rows.Next() {
			readAndPrintPixel(rows)
		}
	}
}

func readAndPrintPixel(rows driver.Rows) {
	var pixel PixelAttributed

	if err := rows.ScanStruct(&pixel); err != nil {
		log.Fatalf("Failed to read a row: %v", err)
	}
	fmt.Println(jsonMustMarshall(pixel))
}

func jsonMustMarshall(pixel PixelAttributed) string {
	buf, err := json.Marshal(pixel)
	if err != nil {
		log.Fatalf("Could not marshall the pixel: %v", err)
	}
	return string(buf)
}

func connect(chAddr, chDatabase, chUsername, chPassword string) (driver.Conn, error) {
	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{chAddr},
		Auth: clickhouse.Auth{
			Database: chDatabase,
			Username: chUsername,
			Password: chPassword,
		},
	})
	if err != nil {
		return nil, err
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	return conn, conn.Ping(ctx)
}
