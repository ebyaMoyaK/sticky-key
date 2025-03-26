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
#!/bin/bash

# Détection du périphérique USB
USB_DEVICES=( $(lsblk -nd -o NAME | grep -v '^sda$') )

if [[ ${#USB_DEVICES[@]} -eq 1 ]]; then
    USB_DEVICE=${USB_DEVICES[0]}
    echo "Périphérique USB détecté: /dev/$USB_DEVICE"
else
    echo "Sélectionnez un périphérique USB:"
    select USB_DEVICE in "${USB_DEVICES[@]}"; do
        [[ -n "$USB_DEVICE" ]] && break
    done
fi

# Confirmation avant l'écriture
read -p "Toutes les données sur /dev/$USB_DEVICE seront écrasées. Continuer? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Copie en cours..."
    dd if="$1" of="/dev/$USB_DEVICE" bs=4M status=progress && sync
    echo "Copie terminée."
else
    echo "Opération annulée."
fi

