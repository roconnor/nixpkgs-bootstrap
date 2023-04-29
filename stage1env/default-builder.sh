set -e

if [ -z "${prefix:-}" ]; then
    prefix="$out";
fi

for curPhase in ${phases}; do
  if [ -n "${!curPhase}" ]; then
    echo Starting $curPhase
    eval "${!curPhase}"
  
    if [ "$curPhase" = unpackPhase ]; then
      cd *
    fi
  fi
done
