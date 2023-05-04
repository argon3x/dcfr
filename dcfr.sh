#!/bin/bash

### By: Argon3x
### Soportado: Sistemas basados en debian y Termux
### Version: 1.0

# Cifrador y Descifrador de contraseñas

# colores
verde="\e[01;32m"; rojo="\e[01;31m"; amarillo="\e[01;33m"
purpura="\e[01;35m"; azul="\e[01;34m"; fin="\e[00m"

# Señal Cancelar
CTRL_C(){
  echo -e "\n${azul}>>> ${rojo}Proceso Cancelado ${azul}<<<${fin}\n"
  exit 1
}
trap CTRL_C INT


# Menu de Ayuda
HELP_MENU(){
  echo -e "${azul}--------------------------------------------${fin}"
  echo -e "${amarillo} Menu De Ayuda. ${fin}"
  echo -e "${purpura}  -c             Cifra La Contraseña${fin}"
  echo -e "${purpura}  -d             Decifrar La Contraseña${fin}"
  echo -e "${purpura}  -h, --help     Muestra El Menu De Ayuda${fin}"
  echo -e "${azul}--------------------------------------------${fin}"
}

# Cifrar Contraseña
CIFRAR(){
  local onlyread password="$1"

  if [ -n $password ]; then
    echo -e "${azul}[${verde}*${azul}] ${verde}Cifrando Contraseña${fin}..."; sleep 0.5
    local cipher_password=$(echo $password | tr 'A-Za-z' 'N-ZA-Mn-za-m' | base64)
    if [ -n $cipher_password ]; then
      echo -e "${purpura}Contraseña Cifrada -> ${fin}${cipher_password}"
      #echo -e "${azul}Contraseña Copiada Al Portapapeles [${verde}ok${azul}]${fin}"
      #echo -e $cipher_password | xclip -sel clip 2>/dev/null
    fi
  fi
  unset $password
  unset $cipher_password
}

# Descifrar Contraseña
DESCIFRAR(){
  local onlyread cipher_password="$1"

  if [ -n $cipher_password ]; then
    echo -e "${azul}[${verde}*${azul}] ${verde}Decifrando Contraseña${fin}..."; sleep 0.5
    local decipher_password=$(echo $cipher_password | base64 -d | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    if [ -n $decipher_password ]; then
      echo -e "${purpura}Contraseña Descifrada -> ${fin}${decipher_password}"
      #echo -e "${azul}Contraseña Copiada Al Portapapeles [${verde}ok${azul}]${fin}"
      #echo $decipher_password | xclip -sel clip 2>/dev/null
    fi
  fi
  unset $cipher_password
  unset $decipher_password
}

declare -i x=0
while getopts ":c:d:h" args; do
  case $args in
    c) CIFRAR=$OPTARG; let x+=1 ;;
    d) DESCIFRAR=$OPTARG; let x+=2 ;;
  esac
done

if [ $x -eq 1 ]; then
  CIFRAR "$CIFRAR"
elif [ $x -eq 2 ]; then
  DESCIFRAR "$DESCIFRAR"
else
  HELP_MENU
fi
