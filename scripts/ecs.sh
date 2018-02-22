#!/bin/bash
# based on https://docs.aws.amazon.com/AmazonECS/latest/developerguide/example_user_data_scripts.html
# Set iptables rules
# echo 'net.ipv4.conf.all.route_localnet = 1' >> /etc/sysctl.conf
# sysctl -p /etc/sysctl.conf
# iptables -t nat -A PREROUTING -p tcp -d 169.254.170.2 --dport 80 -j DNAT --to-destination 127.0.0.1:51679
# iptables -t nat -A OUTPUT -d 169.254.170.2 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 51679

# # Write iptables rules to persist after reboot
# iptables-save > /etc/iptables/rules.v4

# Create directories for ECS agent
mkdir -p /var/log/ecs /var/lib/ecs/data /etc/ecs


if [ -z "$DOCKERHUB_USERNAME" ]; then
    echo "error: Need to set DOCKERHUB_USERNAME"
    exit 1
fi

if [ -z "$DOCKERHUB_PASSWORD" ]; then
    echo "error: Need to set DOCKERHUB_PASSWORD"
    exit 1
fi

if [ -z "$DOCKERHUB_EMAIL" ]; then
    echo "error: Need to set DOCKERHUB_EMAIL"
    exit 1
fi

# Write ECS config file
cat << EOF > /etc/ecs/ecs.config
ECS_DATADIR=/data
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_LOGFILE=/log/ecs-agent.log
ECS_AVAILABLE_LOGGING_DRIVERS=["awslogs","fluentd","gelf","json-file","journald","syslog"]
ECS_LOGLEVEL=debug
ECS_ENGINE_AUTH_TYPE=docker
ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"username":"${DOCKERHUB_USERNAME}","password":"${DOCKERHUB_PASSWORD}","email":"${DOCKERHUB_EMAIL}"}}
EOF

# Write systemd unit file
cat << EOF > /etc/systemd/system/docker-container@ecs-agent.service
[Unit]
Description=Docker Container %I
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStartPre=-/usr/bin/docker rm -f %i 
ExecStart=/usr/bin/docker run --name %i \
--restart=on-failure:10 \
--volume=/var/run:/var/run \
--volume=/var/log/ecs/:/log \
--volume=/var/lib/ecs/data:/data \
--volume=/etc/ecs:/etc/ecs \
--net=host \
--env-file=/etc/ecs/ecs.config \
amazon/amazon-ecs-agent:latest
ExecStop=/usr/bin/docker stop %i

[Install]
WantedBy=default.target
EOF

systemctl enable docker-container@ecs-agent.service