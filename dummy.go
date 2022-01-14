// This file is here only to make "go mod tidy" not complain when I run it against go.mod without having an actual package.
// The only reason I have a go.mod in here in the first place is in order to specify dependencies in a standard way. Those dependencies are actually fetched by Docker - they aren't real golang dependencies.

package main

import (
	"github.com/edouardparis/lntop"
)

func main() {

}
