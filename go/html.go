package main

import (
	"fmt"
	"regexp"
	"strings"
)

func link(s string) string {
	parts := strings.SplitN(s[2:len(s)-2], ":", 2)
	return fmt.Sprintf("<a href=\"%s\">%s</a>", parts[1], parts[0])
}

var funcs = map[string]func(string) string{
	`\[\[(.*)\]\]`: link,
}

var replaces = map[string]string{
	`\/\/(.*)\/\/`: "<i>$1</i>",
	`_(.*)_`:       "<i>$1</i>",
	`==(.*)==`:     "<b>$1</b>",
	`\*(.*)\*`:     "<b>$1</b>",
	`'(.*)'`:       "<code>$1</code>",
	"`(.*)`":       "<code>$1</code>",
}

func stringRenderHTML(in string) string {
	var (
		buf = in
	)

	for k, v := range funcs {
		re := regexp.MustCompile(k)
		buf = re.ReplaceAllStringFunc(buf, v)
	}

	for k, v := range replaces {
		re := regexp.MustCompile(k)
		buf = re.ReplaceAllString(buf, v)
	}
	return buf
}
