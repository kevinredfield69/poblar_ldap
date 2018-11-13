#!/bin/bash

users=`cat equipos.csv | wc -l`

while [ $users -gt 0 ]
do
        hostname=`cat equipos.csv | head -$users | tail -1 | cut -d ":" -f1`
        direccionip=`cat equipos.csv | head -$users | tail -1 | cut -d ":" -f2`
        clavessh=`cat equipos.csv | head -$users | tail -1 | cut -d ":" -f3`

        echo "dn:" uid=$direccionip,ou=Equipos,dc=gonzalonazareno,dc=org >> equipos.ldif
        echo "objectClass: device" >> equipos.ldif
        echo "objectClass: ipHost" >> equipos.ldif
        echo "objectClass: top" >> equipos.ldif
        echo "objectClass: ldapPublicKey" >> equipos.ldif
        echo "objectClass: extensibleObject" >> equipos.ldif
        echo "cn:" $hostname >> equipos.ldif
        echo "ipHostNumber:" $direccionip >> equipos.ldif
        echo "sshPublicKey:" $clavessh >> equipos.ldif
        echo "" >> equipos.ldif
        let users=users-1
done

ldapadd -x -D cn=admin,dc=gonzalonazareno,dc=org -W -f equipos.ldif

