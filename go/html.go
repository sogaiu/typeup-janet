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
	// BUG: panics if there's less than 2 parts in the [[]]
}

var funcs = map[string]func(string) string{
	`\[\[(.*)\]\]`: link,
}

var replaces = map[string]string{
	`^:\/\/(.*)\/\/ `: " <i>$1</i> ",
	`_(.*)_`:          "<i>$1</i>",
	`==(.*)==`:        "<b>$1</b>",
	`\*(.*)\*`:        "<b>$1</b>",
	`'(.*)'`:          "<code>$1</code>",
	"`(.*)`":          "<code>$1</code>",
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

	return fmt.Sprintf("<h%d>%s</h%d>", level, strings.TrimSpace(in[level:]), level)
}

func stringRenderHTML(in string) string {
	// TODO: correctly handle paragraphs
	var (
		buf strings.Builder
		inP bool
	)
	for _, line := range strings.Split(in, "\n") {
		if len(line) == 0 {
			if inP {
				buf.WriteString("</p>")
			}
			continue
		}

		switch line[0] {
		case '#':
			inP = false
			buf.WriteString(renderTitleHTML(line))
		default:
			if !inP {
				buf.WriteString("<p>")
			}
			buf.WriteString(renderSimpleHTML(line) + " ")
			inP = true
		}
	}
	if inP {
		buf.WriteString("</p>")
		inP = false
	}
	return buf.String()
}
