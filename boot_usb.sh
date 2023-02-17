#!/bin/bash


echo "
______      # ______      # __          # __          # ______      # __  __      #
/_____/\     #/_____/\     #/_/\         #/_/\         #/_____/\     #/_/\/_/\     #
\:::__\/     #\::::_\/_    #\:\ \        #\:\ \        #\:::_ \ \    #\:\ \:\ \    #
 \:\ \  __   # \:\/___/\   # \:\ \       # \:\ \       # \:\ \ \ \   # \:\ \:\ \   #
  \:\ \/_/\  #  \::___\/_  #  \:\ \____  #  \:\ \____  #  \:\ \ \ \  #  \:\ \:\ \  #
   \:\_\ \ \ #   \:\____/\ #   \:\/___/\ #   \:\/___/\ #   \:\_\ \ \ #   \:\_\:\ \ #
    \_____\/ #    \_____\/ #    \_____\/ #    \_____\/ #    \_____\/ #    \_____\/ #
             ##             ##             ##             ##             ##             ##œ

"


#Ce script permet de créer une clé usb bootable

# Récupération des noms des périphériques USB
USB_DEVICES=$(lsblk -o NAME,SIZE,TYPE | grep 'disk' | awk '{print $1}')
NUM_USB_DEVICES=$(echo "$USB_DEVICES" | wc -l)

# Si un seul périphérique différent de /dev/sda est détécté, il est automatiquement choisi
if [[ $NUM_USB_DEVICES -eq 1 ]] && [[ "$USB_DEVICES" != "sda" ]]
then
    USB_DEVICE="$USB_DEVICES"
    echo "Périphérique USB détecté: ${USB_DEVICE}"
else
    # Si plusieurs périphériques USB sont détectés, demander à l'utilisateur de choisir le périphérique
    echo "Les périphériques USB suivants ont été détectés:"
    lsblk -o NAME,SIZE,TYPE | grep 'disk'
    echo

    
    echo "Veuillez choisir le périphérique USB:"
    select USB_DEVICE in $USB_DEVICES
    do
        if [[ "$USB_DEVICE" != "sda" ]]
        then
            echo "Vous avez choisi le périphérique USB $USB_DEVICE."
            break
        else
            echo "Le périphérique /dev/sda n'est pas pris en charge. Veuillez choisir un autre périphérique."
        fi
    done
fi


# Demander confirmation avant d'écraser les données sur le périphérique USB
read -p "Attention: toutes les données sur ${USB_DEVICE} seront écrasées. Continuer? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Copier le fichier sur le périphérique USB
    echo "Copie du fichier en cours..."
    dd if=$1 of=/dev/${USB_DEVICE} bs=4M status=progress && sync
    echo "Copie terminée."
else
    echo "Opération annulée."
fi

