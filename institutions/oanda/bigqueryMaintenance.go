package main

import (
	"context"
	"fmt"
	"strings"
	"time"

	"cloud.google.com/go/bigquery"
	"google.golang.org/api/iterator"
)

type bigQueryCandleRowMaintenance struct {
	Instrument string
	Date       time.Time
	Interval   string
	Bid        bigQueryCandleData
	Ask        bigQueryCandleData
	Volume     int
}

func bigqueryDeduplication() {
	ctx := context.Background()
	client, err := bigquery.NewClient(ctx, projectID)
	if err != nil {
		// return fmt.Errorf("bigquery.NewClient: %v", err)
	}
	defer client.Close()

	rows, err := getDuplicatedRow(&ctx, client)
	if err != nil {
		fmt.Printf(err.Error())
	}
	rows, err = getFullDuplicatedRows(&ctx, client, rows)
	if err != nil {
		fmt.Printf(err.Error())
	}

}

func getDuplicatedRow(ctx *context.Context, client *bigquery.Client) ([]bigQueryCandleRowMaintenance, error) {
	q := client.Query(`
        SELECT date, instrument, ` + "`interval`" + `, count(*) 
        FROM ` + "`" + bigQueryDataset + "." + bqPriceShortterm + "`" + `
        WHERE 
            date >= TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL -1 DAY) 
        GROUP BY 
            ` + "`interval`" + `,
            instrument, 
            date 
        HAVING count(*) > 1
        ORDER BY date DESC `)

	it, err := q.Read(*ctx)
	if err != nil {
		return nil, err
	}

	var rows = make([]bigQueryCandleRowMaintenance, 0)
	for {
		var row bigQueryCandleRowMaintenance
		err := it.Next(&row)
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}
		rows = append(rows, row)
		// fmt.Printf("%+v\n", row)
	}
	return rows, nil
}

func getFullDuplicatedRows(ctx *context.Context, client *bigquery.Client, rows []bigQueryCandleRowMaintenance) ([]bigQueryCandleRowMaintenance, error) {
	queries := `
        SELECT *
        FROM ` + "`" + bigQueryDataset + "." + bqPriceShortterm + "`" + `
        WHERE`
	for _, row := range rows {
		queries += `
		(date = TIMESTAMP("` + row.Date.Format(time.RFC3339Nano) + `") AND
		` + "`interval` = \"" + row.Interval + `" AND
		instrument = "` + row.Instrument + `") OR`
	}
	queries = strings.TrimSuffix(queries, "OR")
	queries += `
	GROUP BY
		` + "`interval`" + `,
		instrument,
		date`

	fmt.Println(queries)
	fmt.Println("")
	return nil, nil

	q := client.Query(queries)

	it, err := q.Read(*ctx)
	if err != nil {
		return nil, err
	}

	for {
		var row bigQueryCandleRowMaintenance
		err := it.Next(&row)
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}
		rows = append(rows, row)
		fmt.Printf("%+v\n", row)
	}
	return rows, nil
}
