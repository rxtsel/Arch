#!/bin/sh

gnome_schema="org.gnome.desktop.interface"

gsettings set "$gnome_schema" gtk-theme "Orchis-Dark"
gsettings set "$gnome_schema" icon-theme "kora"
gsettings set "$gnome_schema" cursor-theme "Bibata-Modern-Classic"
gsettings set "$gnome_schema" font-name "Noto Sans 11"

gsettings set org.gnome.desktop.interface color-scheme prefer-dark
