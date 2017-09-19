#!/bin/bash



export GRID_MAX_SESSION=5
# In milliseconds, maps to "newSessionWaitTimeout"
export GRID_NEW_SESSION_WAIT_TIMEOUT=-1
# As a boolean, maps to "throwOnCapabilityNotPresent"
export GRID_THROW_ON_CAPABILITY_NOT_PRESENT=true
# As an integer
export GRID_JETTY_MAX_THREADS=-1
# In milliseconds, maps to "cleanUpCycle"
export GRID_CLEAN_UP_CYCLE=5000
# In seconds, maps to "browserTimeout"
export GRID_BROWSER_TIMEOUT=0
# In seconds, maps to "timeout"
export GRID_TIMEOUT=30
# Debug
export GRID_DEBUG=false



ROOT=/opt/selenium
CONF=$ROOT/config.json

/opt/bin/generate_config > $CONF

echo "starting selenium hub with configuration:"
cat $CONF

if [ ! -z "$SE_OPTS" ]; then
  echo "appending selenium options: ${SE_OPTS}"
fi

function shutdown {
    echo "shutting down hub.."
    kill -s SIGTERM $NODE_PID
    wait $NODE_PID
    echo "shutdown complete"
}

java ${JAVA_OPTS} -jar /opt/selenium/selenium-server-standalone.jar \
  -role hub \
  -hubConfig $CONF \
  ${SE_OPTS} &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
wait $NODE_PID
