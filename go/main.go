package main

import (
	"fmt"
	"io/ioutil"

	"os"
)

func main() {
	b, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}
	fmt.Println(stringRenderHTML(string(b)))
}
