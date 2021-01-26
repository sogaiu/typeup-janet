package typeup

import "testing"

func TestStreamRenderHTML(t *testing.T) {
	cases := []struct {
		in, out string
		opts    Option
	}{
		{"# hi", "<h1>hi</h1>"},
		{"###### hi", "<h6>hi</h6>"},
		{"x y z=hi, things= hi", "x y z<b>hi, things</b> hi"},
	}
	for _, c := range cases {
		t.Log(c)
	}
}
