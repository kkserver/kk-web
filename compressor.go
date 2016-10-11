package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

func help() {
	fmt.Println("go run compressor.go -home . -o a.html -i a.html.view")
}

func parse(in string, out *os.File, home string, r *regexp.Regexp) {

	var cd = filepath.Dir(in)

	var fd, err = os.Open(in)

	if err != nil {
		log.Fatal(err.Error())
		return
	}

	defer fd.Close()

	var rd = bufio.NewReader(fd)

	text, err := rd.ReadString(0)

	if err != nil && err != io.EOF {
		log.Fatal(err.Error())
		return
	}

	for text != "" {

		var idx = r.FindStringSubmatchIndex(text)

		if idx == nil {
			break
		} else {
			out.WriteString(text[:idx[0]])
		}

		var p = text[idx[2]:idx[3]]

		if strings.HasPrefix(p, "~") {
			parse(home+p[1:], out, home, r)
		} else {
			parse(filepath.Join(cd, p), out, home, r)
		}

		text = text[idx[1]:]

	}

	out.WriteString(text)

}

func main() {

	var home = "."
	var out = ""
	var in = ""
	var c = len(os.Args)

	for i := 1; i < c; i++ {
		var arg = os.Args[i]
		if arg == "-home" && i+1 <= c {
			home = os.Args[i+1]
			i = i + 1
		} else if arg == "-o" && i+1 <= c {
			out = os.Args[i+1]
			i = i + 1
		} else if arg == "-i" && i+1 <= c {
			in = os.Args[i+1]
			i = i + 1
		}
	}

	if out == "" || in == "" {

		help()

		return
	}

	fd, err := os.Create(out)

	if err != nil {
		log.Fatal(err.Error())
		return
	}

	defer fd.Close()

	parse(in, fd, home, regexp.MustCompile("<!-- #include\\((.*)\\) -->"))

}
