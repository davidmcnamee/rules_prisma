module github.com/davidmcnamee/rules_prisma

go 1.19

require (
	github.com/iancoleman/strcase v0.0.0-20190422225806-e506e3ef7365
	github.com/joho/godotenv v1.5.1
	github.com/shopspring/decimal v1.3.1
	github.com/steebchen/prisma-client-go v0.20.0
	github.com/takuoki/gocase v1.0.0
	golang.org/x/text v0.10.0
)

replace github.com/steebchen/prisma-client-go v0.20.0 => github.com/davidmcnamee/prisma-client-go v0.20.5
