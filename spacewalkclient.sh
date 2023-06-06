#!/bin/sh
#script for registering CentOS 7 client to spacewalk.badmanstudies.club
#set verbose mode
set x
sudo echo "search divinesolutionsusa.com" > /etc/resolv.conf
sudo echo "nameserver 192.168.1.100" >> /etc/resolv.conf
rpm -Uvh http://yum.spacewalkproject.org/2.6/RHEL/7/x86_64/spacewalk-client-repo-2.6-0.el7.noarch.rpm
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
cd /etc/pki/rpm-gpg
curl -O http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2015
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-spacewalk-2015
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
#do the same for epel gpg key if it doesnt exist already
yum install --nogpgcheck rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin rhnmd spacewalk-oscap osad rhncfg* openssh-clients autofs nfs-utils net-snmp net-snmp-utils scap-security-guide screen ntp logwatch xauth setools-console setools setroubleshoot -y
cd /usr/share/rhn/
curl -O  http://spacewalk.divinesolutionsusa.com/pub/RHN-ORG-TRUSTED-SSL-CERT
curl -O http://spacewalk.divinesolutionsusa.com/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
rhnreg_ks --serverUrl=https://spacewalk.divinesolutionsusa.com/XMLRPC --activationkey=1-4e6ad3f9c6e2ab8789f7ebe39bddc384 --force
rhn-actions-control --enable-all
firewall-cmd --permanent --add-port=5222/tcp
firewall-cmd --reload
systemctl restart osad
systemctl enable osad
systemctl restart rhnsd
systemctl enable rhnsd
mkdir /yum
mv /etc/yum.repos.d/* /yum
yum clean all
cd /var/cache/yum/x86_64/7
rm -rf updates spacewalk-client extras epel base
