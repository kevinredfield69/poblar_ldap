#!/bin/bash

users=`cat usuarios.csv | wc -l`

while [ $users -gt 0 ]
do
        usuarios=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f4`
        ldapdelete -x -D 'cn=admin,dc=gonzalonazareno,dc=org' 'uid='$usuarios',ou=People,dc=gonzalonazareno,dc=org' -w kevinasir2
        let users=users-1
done

