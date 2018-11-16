#!/bin/bash
export factory_image=rhel-server-7.5-update-4-x86_64-kvm.qcow2
export image=rhel7.qcow2
export destination_folder=satellite
export destination_image=satellite.qcow2

export name=
export password=
export pool_id=

mkdir -p $destination_folder

echo "######################"
echo "# Make working image #"
rm $image
echo "# Copy Factory image #"
echo "######################"
cp $factory_image $image

sync
echo "######################"
echo "# Subscribing system #"
echo "######################"
virt-customize -a $image --run-command "subscription-manager register --username=$name --password=$password" --run-command "subscription-manager attach --pool $pool_id" --run-command 'subscription-manager repos --disable "*"' --run-command 'subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-server-rhscl-7-rpms --enable=rhel-7-server-satellite-6.4-rpms --enable=rhel-7-server-satellite-maintenance-6-rpms --enable=rhel-7-server-ansible-2.6-rpms' --upload "$destination_folder/install.sh:/root" --run-command "chmod +x /root/install.sh"

virt-customize -a $image --root-password password:redhat --uninstall cloud-init
echo "########################"
echo "# Unsubscribing system #"
echo "########################"
#virt-customize -a $image --run-command 'subscription-manager remove --all' --run-command 'subscription-manager unregister'
echo "#######################"
echo "# Copy to destination #"
echo "#######################"
cp $image $destination_folder/$destination_image ; sync
chmod -R 777 $destination_folder/
