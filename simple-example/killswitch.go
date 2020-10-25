package main

import (
	"fmt"
	"time"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
	"golang.org/x/net/context"
)

func main() {
	cli, err := client.NewEnvClient()
	if err != nil {
		panic(err)
	}

	var start = time.Now()
	var d time.Duration

	// actual start
	var sig string = "SIGKILL"
	var filter = filters.NewArgs()
	filter.Add("label", "safety=false")

	// return filtered containers
	containers, err := cli.ContainerList(context.Background(), types.ContainerListOptions{
		Filters: filter,
	})
	if err != nil {
		panic(err)
	}

	for _, c := range containers {
		cli.ContainerKill(context.Background(), c.ID, sig)
	}

	d = time.Since(start)
	fmt.Println(d.Nanoseconds())
}
