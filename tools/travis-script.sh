#!/bin/bash
set -evu

if [[ "$PLATFORM" == "js" ]]; then
  export SCALAJS_VERSION="$PLUGIN_VERSION"
else
  export SCALANATIVE_VERSION="$PLUGIN_VERSION"
fi

sbt_cmd=(sbt ++$TRAVIS_SCALA_VERSION)

if [[ "$PLATFORM" == "js" ]]; then
  TESTS=100
else
  TESTS=1000
fi

sbt_cmd+=("set ThisBuild / parallelExecution := $SBT_PARALLEL")

for t in clean compile "testOnly * -- -s $TESTS -w $WORKERS" mimaReportBinaryIssues package; do
  sbt_cmd+=("$PLATFORM/$t")
done

echo "Running sbt: ${sbt_cmd[@]}"

"${sbt_cmd[@]}"
