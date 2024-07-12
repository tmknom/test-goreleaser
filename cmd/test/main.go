package main

import (
	"fmt"
)

var (
	name    = ""
	version = ""
	commit  = ""
	date    = ""
	url     = ""
)

func main() {
	fmt.Printf("%s %s %s %s\n%s\n", name, version, commit, date, url)
}
