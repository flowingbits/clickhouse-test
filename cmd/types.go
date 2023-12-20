package main

import "time"

type Pixel struct {
	AdvertiserId   int64      `ch:"advertiserId"`
	CreatedAt      time.Time  `ch:"createdAt"`
	ExtId          string     `ch:"extId"`
	FpID           *uint64    `ch:"fpId"`
	Wlid           *int64     `ch:"wlid"`
	PixelId        *int64     `ch:"pixelId"`
	Ua             *string    `ch:"ua"`
	Ip             *string    `ch:"ip"`
	Geo            *string    `ch:"geo"`
	City           *string    `ch:"city"`
	Language       *string    `ch:"language"`
	Os             *string    `ch:"os"`
	OsVersion      *string    `ch:"osVersion"`
	Browser        *string    `ch:"browser"`
	BrowserVersion *string    `ch:"browserVersion"`
	DeviceMake     *string    `ch:"deviceMake"`
	Device         *string    `ch:"device"`
	EventName      *string    `ch:"eventName"`
	TransactionId  *int64     `ch:"transactionId"`
	Amount         *float64   `ch:"amount"`
	Currency       *string    `ch:"currency"`
	Site           *string    `ch:"site"`
	ClickId        *string    `ch:"clickId"`
	BidreqId       *string    `ch:"bidreqId"`
	ProductId      *int64     `ch:"productId"`
	Category       *string    `ch:"category"`
	AffId          *string    `ch:"affId"`
	S2s            *int64     `ch:"s2s"`
	UserCreatedAt  *time.Time `ch:"userCreatedAt"`
	Page           *string    `ch:"page"`
	CreatedDate    *time.Time `ch:"createdDate"`
	Hour           *int64     `ch:"hour"`
	RecordTs       *time.Time `ch:"recordTs"`
}

type PixelAttributed struct {
	Pixel
	ImpTimestamp  time.Time `ch:"impTimestamp"`
	ImpAttributed bool      `ch:"impAttributed"`
}
