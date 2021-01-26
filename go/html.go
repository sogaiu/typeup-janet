package typeup

import "io"

type options struct {
	strict bool
}

type Option func(options) options

func streamRenderHTML(from io.Reader, to io.Writer, opts ...Option) error {
	return nil
}
