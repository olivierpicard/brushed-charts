package bigquery

import (
	"cloud.google.com/go/bigquery"
)

// CandleOHLC ss
type CandleOHLC struct {
	Open  float64 `json:"open"`
	High  float64 `json:"high"`
	Low   float64 `json:"low"`
	Close float64 `json:"close"`
}

// Save ss
func (c *CandleOHLC) Save() (map[string]bigquery.Value, string, error) {
	return map[string]bigquery.Value{
		"open":  c.Open,
		"high":  c.High,
		"low":   c.Low,
		"close": c.Close,
	}, "", nil
}

// CandleRow ssd
type CandleRow struct {
	Instrument  string     `json:"instrument"`
	Date        string     `json:"date"`
	Granularity string     `json:"granularity"`
	Bid         CandleOHLC `json:"bid"`
	Ask         CandleOHLC `json:"ask"`
	Volume      int        `json:"volume"`
}

// Save sdsd
func (c *CandleRow) Save() (map[string]bigquery.Value, string, error) {
	return map[string]bigquery.Value{
		"instrument":  c.Instrument,
		"date":        c.Date,
		"granularity": c.Granularity,
		"bid":         c.Bid,
		"ask":         c.Ask,
		"volume":      c.Volume,
	}, "", nil
}

// func (c *CandleRow) Equal(row CandleRow) bool {
// 	if c.Date != row.Date {
// 		return false
// 	}
// 	if c.Instrument != row.Instrument {
// 		return false
// 	}
// 	if c.Granularity != row.Granularity {
// 		return false
// 	}
// 	return true
// }

// func (c *CandleRow) EqualIgnoreDate(row CandleRow) bool {
// 	if c.Instrument != row.Instrument {
// 		return false
// 	}
// 	if c.Granularity != row.Granularity {
// 		return false
// 	}
// 	return true
// }

// func (candArr *latestCandlesArray) parseForBigQuery() []bigQueryCandleRow {
// 	rows := make([]bigQueryCandleRow, 0)
// 	for _, meta := range candArr.LatestCandles {
// 		bqRow := bigQueryCandleRow{}
// 		bqRow.Granularity = meta.Granularity
// 		bqRow.Instrument = meta.Instrument

// 		for _, cand := range meta.Candles {
// 			if !cand.Complete {
// 				continue
// 			}

// 			bqRow.Date = cand.Time
// 			bqRow.Bid, _ = cand.Bid.parseForBigQuery()
// 			bqRow.Ask, _ = cand.Ask.parseForBigQuery()
// 			bqRow.Volume = cand.Volume

// 			if bqRow.Bid == (bigQueryCandleData{}) || bqRow.Ask == (bigQueryCandleData{}) {
// 				err := fmt.Errorf("Error during CandlesData parsing to float")
// 				cloudlogging.ReportCritical((cloudlogging.EntryFromError(err)))
// 			}
// 		}

// 		if bqRow.Date == "" {
// 			continue
// 		}

// 		rows = append(rows, bqRow)
// 	}
// 	return rows
// }

// func (data *candlestickData) parseForBigQuery() (bigQueryCandleData, error) {
// 	open, err := strconv.ParseFloat(data.Open, 64)
// 	if err != nil {
// 		return bigQueryCandleData{}, err
// 	}

// 	high, err := strconv.ParseFloat(data.High, 64)
// 	if err != nil {
// 		return bigQueryCandleData{}, err
// 	}

// 	low, err := strconv.ParseFloat(data.Low, 64)
// 	if err != nil {
// 		return bigQueryCandleData{}, err
// 	}

// 	close, err := strconv.ParseFloat(data.Close, 64)
// 	if err != nil {
// 		return bigQueryCandleData{}, err
// 	}

// 	return bigQueryCandleData{
// 		Open:  open,
// 		High:  high,
// 		Low:   low,
// 		Close: close,
// 	}, nil
// }
