package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/brushed-charts/backend/lib/cloudlogging"
)

func main() {
	projname := os.Args[1]
	pid := os.Args[2]
	pname := os.Args[3]
	cloudlogging.Init(projname, "logexit")

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
	cloudlogging.ReportEmergency(cloudlogging.LogEntry{
		Error:   err,
		IsQuiet: true,
	})
}
