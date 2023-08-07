package main

import (
	db "github.com/davidmcnamee/rules_prisma/test/gen/client_go"
)

func main() {
	client := db.NewClient()
	err := client.Connect()
}
