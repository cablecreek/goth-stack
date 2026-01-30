package data

type Metric struct {
	Label string
	Value string
}

func GetMetrics() []Metric {

	return []Metric{

		{Label: "Deploy window", Value: "08m"},
		{Label: "Tests", Value: "142"},
		{Label: "Latency", Value: "112ms"},
	}

}
