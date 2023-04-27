set -e

if [ -z "${prefix:-}" ]; then
    prefix="$out";
fi

for curPhase in ${phases}; do
  echo Starting $curPhase
  if [ -n "${!curPhase}" ]; then
    eval "${!curPhase}"
  fi
  
  if [ "$curPhase" = unpackPhase ]; then
    cd *
  fi
done
