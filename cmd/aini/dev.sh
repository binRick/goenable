run="make"
cmd="nodemon -I -w main.go -e go -V --delay .2 -x sh -- -c \"$run||true\""

eval "$cmd"
