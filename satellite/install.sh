export ORG=NAPS
export LOCATION=Earth

sed -i 's/127.0.0.1/127.0.0.1   satellite.redhatgov.io satellite/g' /etc/hosts
hostnamectl set-hostname satellite.redhatgov.io 

yum -y update
yum -y install satellite


satellite-installer --scenario satellite \
--foreman-initial-organization "$ORG" \
--foreman-initial-location "$LOCATION" \
--foreman-admin-password redhat \
--foreman-proxy-puppetca true \
--foreman-proxy-tftp true \
--enable-foreman-plugin-discovery
