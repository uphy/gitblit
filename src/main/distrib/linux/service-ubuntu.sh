#!/bin/bash
# chkconfig: 3 21 91
# Source function library.
. /lib/init/vars.sh
. /lib/lsb/init-functions

PATH=/sbin:/bin:/usr/bin:/usr/sbin

# change theses values (default values)
GITBLIT_PATH=/opt/gitblit
GITBLIT_BASE_FOLDER=/opt/gitblit/data
GITBLIT_USER="gitblit"
source ${GITBLIT_PATH}/java-proxy-config.sh
ARGS="-server -Xmx1024M ${JAVA_PROXY_CONFIG} -Djava.awt.headless=true -jar gitblit.jar --baseFolder $GITBLIT_BASE_FOLDER"

RETVAL=0

case "$1" in
  start)
    if [ -f $GITBLIT_PATH/gitblit.jar ];
      then
      echo $"Starting gitblit server"
      start-stop-daemon --start --quiet --background --oknodo --make-pidfile --pidfile /var/run/gitblit.pid --exec /usr/bin/java --chuid $GITBLIT_USER --chdir $GITBLIT_PATH -- $ARGS
      exit $RETVAL
    fi
  ;;

  stop)
    if [ -f $GITBLIT_PATH/gitblit.jar ];
      then
      echo $"Stopping gitblit server"
      start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/gitblit.pid
      exit $RETVAL
    fi
  ;;
  
  force-reload|restart)
      $0 stop
      $0 start
  ;;

  *)
    echo $"Usage: /etc/init.d/gitblit {start|stop|restart|force-reload}"
    exit 1
  ;;
esac

exit $RETVAL
