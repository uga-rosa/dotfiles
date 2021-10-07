#!/bin/bash

lazyenv.load() {
  local func=$1
  shift

  echo "_lazyenv_${func}_commands=($@)"

  for cmd in $@; do
    echo "$cmd() { eval \"\$(_lazyenv.init $cmd $func \$@)\"; }"
  done
}

lazyenv.shell.loadstart() {
  _lazyenv_shell_loading=true
}

lazyenv.shell.loadfinish() {
  if [ ! -z "$_lazyenv_shell_loading" ]; then
    unset _lazyenv_shell_loading
  fi
}

_lazyenv.init() {
  local cmd=$1
  local func=$2
  shift
  shift

  if [ ! -z "$_lazyenv_shell_loading" ]; then
    cat <<EOF
command $cmd "\$@"
EOF
    return
  fi

  cat <<EOF
for _cmd in \${_lazyenv_${func}_commands[@]}; do
	unset -f \$_cmd
done
unset _lazyenv_${func}_commands
eval '$func $cmd'
unset -f $func
eval '$cmd "\$@"'
EOF
}
