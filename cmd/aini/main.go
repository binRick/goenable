//go:generate ./../../bin/goenable -input $GOFILE

package main

import "C"

import (
	"fmt"

	"github.com/bashgo/goenable/bash"
)

//export mybuiltin
func mybuiltin(args []string) C.int {
	for _, a := range args {
		fmt.Println(a)
	}
	aini1()
	return bash.EXECUTION_SUCCESS
}

//export gohello
func gohello(args []string) C.int {
	for _, a := range args {
		fmt.Println("HELLO,", a)
	}
	return bash.EXECUTION_SUCCESS
}

var (
	cmd1 = bash.Enable{
		"mybuiltin",
		[]string{"doc line 1", "doc line 2"},
		"mybuilt in just prints out all parameters, on on each line",
	}
)

// main function is need to compile a c-shared library
func main() {
}
