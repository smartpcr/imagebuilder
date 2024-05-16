package main

import (
	"os"

	"github.com/smartpcr/ImageBuilder/cmd"
	"github.com/spf13/cobra"
)

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
)

func main() {
	var root = &cobra.Command{
		Use: "image-builder",
	}

	root.AddCommand(&cmd.Qemu)

	root.AddCommand(&cobra.Command{
		Use:   "version",
		Short: "Print the version information",
		Run: func(cmd *cobra.Command, args []string) {
			println("Version:", version)
			println("Commit:", commit)
			println("Date:", date)
		},
	})

	if err := root.Execute(); err != nil {
		os.Exit(1)
	}
}
