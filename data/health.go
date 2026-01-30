package data

import (
	"math/rand"
	"time"
)

type Health struct {
	Value     string
	Timestamp string
}

func GetHealth() Health {

	now := time.Now().Format("15:04:05")

	if rand.Intn(2) == 1 {

		return Health{"ok", now}
	}

	return Health{"not ok", now}

}
