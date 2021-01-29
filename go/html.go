package main

import (
	"fmt"
	"regexp"
	"strings"
)

func link(s string) string {
	parts := strings.SplitN(s[2:len(s)-2], ":", 2)
	return fmt.Sprintf("<a href=\"%s\">%s</a>", strings.TrimSpace(parts[1]), strings.TrimSpace(parts[0]))
	// TODO: allow HTML in link text
}

var funcs = map[string]func(string) string{
	`\[\[(.*)\]\]`: link,
}

var replaces = map[string]string{
	` \/\/(.*)\/\/ `: " <i>$1</i> ",
	`_(.*)_`:         "<i>$1</i>",
	`==(.*)==`:       "<b>$1</b>",
	`\*(.*)\*`:       "<b>$1</b>",
	`'(.*)'`:         "<code>$1</code>",
	"`(.*)`":         "<code>$1</code>",
}

func renderSimpleHTML(in string) string {
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

func renderTitleHTML(in string) string {
	// TODO: not require a space here
	// jesus christ this is opaque
	var level int
	for i, c := range in {
		if c != '#' {
			level = i
			break
		}
	}

	return fmt.Sprintf("<h%d>%s</h%d>", level, in[level:], level)
}

func renderLineHTML(in string) string {
	if len(in) < 1 {
		return ""
	}

	switch in[0] {
	case '#':
		return renderTitleHTML(in)
	}
	return renderSimpleHTML(in)
}

func stringRenderHTML(in string) string {
	// TODO: correctly handle paragraphs
	var buf strings.Builder
	for _, l := range strings.Split(in, "\n") {
		buf.WriteString(renderLineHTML(l) + "\n")
	}
	return buf.String()
}
