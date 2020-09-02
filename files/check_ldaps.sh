#!/bin/bash
# GGA 22/11/2018

#Make anonymous bind that return "no object found" error code 32
output=`LDAPTLS_REQCERT=never ldapsearch -x -H "ldaps://$1:$2" -b "" -o nettimeout=10 2>&1`

#If return code is 32, LDAP works :)
if [[ $? = 32 ]]
then
        exit 0
else
        exit 1
fi

