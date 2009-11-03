#!/bin/sh

firefox https://mail.google.com/mail?view=cm\&tf=0i\&to=`echo $1 | sed 's/mailto://'`

