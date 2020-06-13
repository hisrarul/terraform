#!/bin/bash
yum install vim -y
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo useradd g101-admin
usermod -g wheel g101-admin

echo "g101-admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudouser

# Apply the latest security patches
yum update -y --security

# Disable source / destination check. It cannot be disabled from the launch configuration
region=ap-south-1
instanceid=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
aws ec2 modify-instance-attribute --no-source-dest-check --instance-id $instanceid --region $region

# Install and start Squid
yum install -y squid
systemctl start squid || service squid start
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 3130

# Create a SSL certificate for the SslBump Squid module
mkdir /etc/squid/ssl
cd /etc/squid/ssl
openssl genrsa -out squid.key 4096
openssl req -new -key squid.key -out squid.csr -subj "/C=XX/ST=XX/L=squid/O=squid/CN=squid"
openssl x509 -req -days 365 -in squid.csr -signkey squid.key -out squid.crt
cat squid.key squid.crt >> squid.pem

# Refresh the Squid configuration files from S3
mkdir /etc/squid/old
cat > /etc/squid/squid-conf-refresh.sh << 'EOF'
cp /etc/squid/* /etc/squid/old/
aws s3 sync s3://${s3_bucket_name} /etc/squid
/usr/sbin/squid -k parse && /usr/sbin/squid -k reconfigure || (cp /etc/squid/old/* /etc/squid/; exit 1)
EOF
chmod +x /etc/squid/squid-conf-refresh.sh
/etc/squid/squid-conf-refresh.sh

# Schedule tasks
cat > ~/mycron << 'EOF'
* * * * * /etc/squid/squid-conf-refresh.sh
0 0 * * * sleep $(($RANDOM % 3600)); yum -y update --security
EOF
crontab ~/mycron
rm ~/mycron

# Install and configure the CloudWatch Agent
rpm -Uvh https://amazoncloudwatch-agent-ap-south-1.s3.ap-south-1.amazonaws.com/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
