#!/bin/bash
Unlimited_loop_test () {
    bot_ip=`sudo /opt/butler_server/bin/butler_server rpcterms butlerinfo get_by_id $1. | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
    echo "Butler Ip: $bot_ip"
    echo "<br>" 
    if [ ! -n "$bot_ip" ]
    then
        echo "Wrong Butler ID"
    else
        ping -c1 -W 1 $bot_ip   >/dev/null
        if [ $? -eq 0 ]; then
            sudo /opt/butler_server/erts-7.3.1/bin/escript /home/gor/rpc_call.escript butler_test_functions test_butler_loop_start "[$1, [{\""$2"\",$3},{\""$4"\",$5}]]."
            echo "<br>"
            echo "OK Done...."
        else
            echo "Butler is not ON.....turn on Butler FIRST"
        fi
    fi
}
echo "Content-type: text/html"
echo ""

echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>Loop test with count</title>'
echo '</head>'
echo '<body style="background-color:#B8B8B8">'

echo '<img src="https://scmtech.in/assets/images/grey.png" style="position:fixed; TOP:5px; LEFT:850px; WIDTH:400px; HEIGHT:80px;"></img>'
echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"

  echo "<form method=GET action=\"${SCRIPT}\">"\
       '<table nowrap>'\
          '<tr><td>Butler_ID</TD><TD><input type="number" name="Butler_ID" size=12></td></tr>'\
      '<tr><td>Source Barcode</TD><TD><input type="text" name="Source_Barcode" size=12></td></tr>'\
      '<tr><td>Source Direction</TD><TD><input type="number" name="Source_Direction" size=12></td></tr>'\
      '<tr><td>Destination Barcode</TD><TD><input type="text" name="Destination_Barcode" size=12></td></tr>'\
      '<tr><td>Destination Direction</TD><TD><input type="number" name="Destination_Direction" size=12></td></tr>'\
          '</tr></table>'

  echo '<br><input type="submit" value="SUBMIT">'\
       '<input type="reset" value="Reset"></form>'

  # Make sure we have been invoked properly.

  if [ "$REQUEST_METHOD" != "GET" ]; then
        echo "<hr>Script Error:"\
             "<br>Usage error, cannot complete request, REQUEST_METHOD!=GET."\
             "<br>Check your FORM declaration and be sure to use METHOD=\"GET\".<hr>"
        exit 1
  fi

  # If no search arguments, exit gracefully now.
  echo "$QUERY_STRING<br>"
  echo "<br>"
  if [ -z "$QUERY_STRING" ]; then
        exit 0
  else
   # No looping this time, just extract the data you are looking for with sed:
     XX=`echo "$QUERY_STRING" | sed -r 's/([^0-9]*([0-9]*)){1}.*/\2/'`
     YY=`echo "$QUERY_STRING" | sed -n 's/^.*Source_Barcode=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
     ZZ=`echo "$QUERY_STRING" | sed -r 's/([^0-9]*([0-9]*)){4}.*/\2/'`
     AA=`echo "$QUERY_STRING" | sed -n 's/^.*Destination_Barcode=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
     BB=`echo "$QUERY_STRING" | sed -r 's/([^0-9]*([0-9]*)){7}.*/\2/'`
     
     echo "Butler_ID: " $XX
     echo '<br>'
     echo "Source_Barcode: " $YY
     echo '<br>'
     echo "Source Direction: " $ZZ
     echo '<br>'
     echo "Destination_Barcode: " $AA
     echo '<br>'
     echo "Destination Direction: " $BB
     echo '<br>'

     Unlimited_loop_test $XX $YY $ZZ $AA $BB
     
     
  fi
echo '</body>'
echo '</html>'

exit 0

