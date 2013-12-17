#!/bin/sh

# Sleep for "first argument seconds"
sleep "$1"

# Launch "second argument command"
$2

# Launch "second argument command", if any
$3
