# Arch linux setup

![2022-02-08_23-54](https://user-images.githubusercontent.com/85462420/153124501-184c5032-5d63-4e65-8555-d28113140f6c.png)

- [Resumen](#resumen)
- [Instalación de Arch Linux](#instalación-de-arch-linux)
  
# Resumen

Esta es mi configuración de Arch linux con Qtile y alacritty.

# Instalación de Arch Linux

#### Descarga **[Arch](https://archlinux.org/download/)**.
#### Bootea Arch en una usb.
#### Una vez booteado Arch, podemos ejecutar los siguientes comandos:

Cambiamos la distribución de teclado:
```bash
loadkeys la-latin1
```

Nos conectamos a wifi:

```bash
lwctl --passphrase "contraseñaWifi" station wlan0 connect "nombreWifi"

```

Verificar conexión:

```bash
ping 8.8.8.8
```

Actualizar reloj:

```bash
timedatectl set-ntp true
```

Ver todas las particiones de disco:

```bash
lsblk
```

Particionar los discos:

```bash
cfdisk
```
Crear 3 particiones así:

| CANTIDAD   | TIPO DE PARTICION |
| ---------------| -----------------------|
| **512M** | UEFI           |
| **TUS GB DE RAM** | SWAP (linux swap)         |
|**RESTO DE GB**| ROOT (linux filesystem) |
Darle a **write**, y escribir **yes** para guardar.

Formatear los discos:

```bash
mkfs.fat -F32 /dev/aqui_UEFI_partition       <-para UEFI
mkfs.ext4 /dev/aqui_ROOT_partition          <-para ROOT
mkswap /dev/aqui_SWAP_partition            <-para SWAP
```
#### Montar los discos:

Primero crear una montura para UEFI:

```bash
mkdir /mnt/efi
```
```bash
mount /dev/aqui_EFI_partition /mnt/efi       <-para UEFI
mount /dev/aqui_ROOT_partition /mnt       <-para ROOT
swapon /dev/aqui_SWAP_partition              <-para SWAP
```

Instalar paquetes esenciales:

```bash
pacstrap /mnt base linux linux-firmware neovim iwd
```

Ejecutar fstab:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Ejecutar chroot:

```bash
arch-chroot /mnt
```

Configurar zona horaria:

```bash
ln -sf /usr/share/zoneinfo/America/Bogota /etc/localtime
```
Ejecutar:

```bash
hwclock –-systohc
```

Editar localización: 
```bash
nvim /etc/locale.gen
```
 - *Descomentar: **es_CO.UTF-8 UTF-8**.*

Crear locale.conf:
```bash
nvim /etc/locale.conf
```
- *Escribir**LANG=es_CO.UTF-8**.*

Configurar teclado:
```bash
nvim /etc/vconsole.conf
```
- *Escribir **KEYMAP=la-latin1***

Configurar hostname:
```bash
nvim /etc/hostname
```
- *Escribe un nombre para tu **pc**, en mi caso pondré **rxtsel***

Configurar host:
```bash
nvim /etc/hosts
```
![image](https://user-images.githubusercontent.com/85462420/152463120-22b7cd94-42d2-40a1-8dda-d3320d9fc1a0.png)

- *Escribe tal cuál la imagen. sólo reemplaza myhostname por el nombre que pusiste en  tu host*

Ejecutar initframs:
```bash
mkinitcpio -P
```

Instalar grub y otros paquetes:
```bash
pacman -S grub base-devel efibootmgr os-prober mtools dosfstools linux-headers networkmanager nm-connection-editor pulseaudio pavucontrol dialog gvfs xdg-user-dirs dhcp
```

Crear Directorio EFI:
```bash
mkdir /boot/EFI
```
Montar la partición EFI:
```bash
mount /dev/partition_efi /boot/EFI
```

Instalar grub:
```bash
grub-install --target=x86_64-efi –-bootloader-id=grub_uefi –-recheck
```

Configurar grub:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Encender NetworkManager y iwd:
```bash
systemctl enable NetworkManager
```

Agregar un nuevo usario:
```bash
useradd -m -G wheel rxtsel
```

Ejecutar: 
```bash
EDITOR=nvim visudo
```
- ***Descomentar: %wheel ALL=(ALL) ALL y guardar.***

Contraseña para el nuevo usuario:
```bash
passwd rxtsel
```
- *Pon una contraseña para el usuario que creaste, en mi caso, **rxtsel***.

Configurar contraseña de root:
```bash
passwd root
```
- *Pon una contraseña para el usuario **root**.*

---

#### Instalar driver de display:
Si tienes gpu **INTEL**, ejecuta el siguiente comando:
```bash
pacman -S xf86-video-intel
```
Si tienes gpu **AMD**, ejecuta el siguiente comando:
```bash
pacman -S vulkan-radeon vulkan-icd-loader mesa
```

---
Instalar servidor de display:
```bash
pacman -S xorg xorg-server xorg-init
```

# Instalar ventana de login: (opcional)
```bash
pacman -S lightdm lightdm-gtk-greeter
```

Configurar lightdm:
```bash
nvim /etc/lightdm/lightdm.conf
```
- ***UBICAR*** *greeter-session=example-gtk-gnome y **REMPLAZAR** por greeter-sesion=lightdm-gtk-greeter*.

Encender lightdm:
```bash
systemctl enable lightdm
```

Instalar un entorno de escritorio:
- Aqui puedes instalar xfce4, gnome... etc. Elige el que tu quieras.
por ejemplo:
```
bash
sudo pacman -S bspwm
sudo pacman -S gnome
sudo pacman -S xfce4
sudo pacman -S plasma
```

Una vez instalado el entorno de escritorio ejecutamos:
```bash
exit
```

```bash
umount -a
```

```bash
reboot
```

Y quitamos la usb
