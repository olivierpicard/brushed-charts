package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/brushed-charts/backend/lib/cloudlog"
)

func main() {
	projname := os.Args[1]
	pid := os.Args[2]
	pname := os.Args[3]

	os.Setenv("CLOUDLOGGING_PROJECTID", projname)
	os.Setenv("CLOUDLOG_SERVICE_NAME", "logexit")

	cmd := exec.Command("lsof", "-p", pid, "+r", "1")

	err := cmd.Start()
	if err != nil {
		log.Fatalf("Can't start the command : %v", err)
	}

	err = cmd.Wait()
	if err != nil {
		log.Fatalf("Can't wait the command : %v", err)
	}

	err = fmt.Errorf("%v app has stopped working", pname)
	cloudlog.Critical(err)
}
