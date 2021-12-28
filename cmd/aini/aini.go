package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/k0kubun/pp"
	"github.com/relex/aini"
)

func aini1() {

	inventoryReader := strings.NewReader(`
	host1:2221
	[web]
	host2 ansible_ssh_user=root
    `)
	inventory, err := aini.Parse(inventoryReader)
	if err != nil {
		panic(err)
	}

	fmt.Fprintf(os.Stderr, "host1 Name=%s\n", inventory.Hosts["host1"].Name)

	pp.Fprintf(os.Stdout, "%s", inventory.Hosts["host1"].Port)

}

func init() {
	aini1()
}
