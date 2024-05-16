package cmd

import "github.com/spf13/cobra"

var (
	Qemu = cobra.Command{
		Use:   "qemu",
		Short: "Build an image using qemu-system-x86",
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			// Run the qemu command
		},
	}
)
