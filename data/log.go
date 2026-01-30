package data

type LogEntry struct {
	ID        int
	Service   string
	Level     string
	Message   string
	Timestamp string
	TraceID   string
}

func GetLogs() []LogEntry {

	return []LogEntry{
		{ID: 1, Service: "auth-api", Level: "INFO", Message: "login success", Timestamp: "10:02:11", TraceID: "trc-8f2a"},
		{ID: 2, Service: "auth-api", Level: "WARN", Message: "suspicious login window", Timestamp: "10:01:49", TraceID: "trc-5aa1"},
		{ID: 3, Service: "billing-worker", Level: "ERROR", Message: "stripe webhook signature mismatch", Timestamp: "09:59:03", TraceID: "trc-e3bf"},
		{ID: 4, Service: "cron-cleanup", Level: "INFO", Message: "sweep completed", Timestamp: "09:55:42", TraceID: "trc-1110"},
		{ID: 5, Service: "edge-gateway", Level: "ERROR", Message: "upstream timeout to profile-api", Timestamp: "09:50:21", TraceID: "trc-93ce"},
	}
}
