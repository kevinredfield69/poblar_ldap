#!/bin/bash

#Abrimos el fichero y contamos las líneas que tiene, donde cada línea, hace referencia a un alumno
users=`cat usuarios.csv | wc -l`

#Variable donde empezará el uid de cada usuario a crearse en el equipo servidor
uid=1101

#Mientras haya un usuario como minimo en el fichero, ejecuta la instrucción

while [ $users -gt 0 ]
do

#Extrae cada campo del fichero separados por dos puntos, al ser un fichero CSV

	nombre=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f1`
	apellidos=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f2`
	email=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f3`
	usuarioGN=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f4`
	clavessh=`cat usuarios.csv | head -$users | tail -1 | cut -d ":" -f5`

#Añade cada campo y objeto para el árbol de LDAP que tenemos creado, atentiendo a la cantidad de lineas almacenadas en el fichero, que hace referencia a un usuario

	echo "dn:" uid=$usuarioGN,ou=People,dc=gonzalonazareno,dc=org >> usuarios.ldif
	echo "objectClass: inetOrgPerson" >> usuarios.ldif
	echo "objectClass: posixAccount" >> usuarios.ldif
	echo "objectClass: top" >> usuarios.ldif
	echo "objectClass: ldapPublicKey" >> usuarios.ldif
	echo "uid:" $usuarioGN >> usuarios.ldif
	echo "gidNumber: 2100" >> usuarios.ldif
	echo "uidNumber:" $uid >> usuarios.ldif
	echo "homeDirectory:" /home/$usuarioGN >> usuarios.ldif
	echo "loginShell: /bin/bash" >> usuarios.ldif
	echo "description: 1" >> usuarios.ldif
	echo "sn:" $apellidos >> usuarios.ldif
	echo "givenName:" $nombre >> usuarios.ldif
	echo "cn:" $nombre $apellidos >> usuarios.ldif
	echo "mail:" $email >> usuarios.ldif
	echo "l:" Dos Hermanas >> usuarios.ldif
	echo "sshPublicKey:" $clavessh >> usuarios.ldif
	echo "" >> usuarios.ldif

#Añade una entrada al fichero ldif y le añade un uid mayor al sistema a cada usuario añadido al fichero

	let users=users-1
	let uid=uid+1
done

#Añade los usuarios al arbol del LDAP, mediante el fichero .ldif que hemos generado anteriormente

ldapadd -x -D cn=admin,dc=gonzalonazareno,dc=org -W -f usuarios.ldif

