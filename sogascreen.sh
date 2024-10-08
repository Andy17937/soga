#!/bin/bash

# 读取用户输入的 node_id
read -p "请输入node_id: " node_id


# 下载配置文件
wget -q https://raw.githubusercontent.com/Andy17937/soga/refs/heads/main/soga2.conf -O /etc/soga/soga2.conf

# 替换 node_id 并运行 soga
sed -i "s/node_id=363/node_id=$node_id/" /etc/soga/soga2.conf

# 创建 systemd 服务单元文件
USERNAME="root"
WORKING_DIRECTORY="/usr/local/soga"
SOGA_COMMAND="/usr/local/soga/soga -c /etc/soga/soga2.conf"

cat <<EOF > /etc/systemd/system/soga1.service
[Unit]
Description=Soga1 Service
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKING_DIRECTORY
ExecStart=$SOGA_COMMAND
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 配置并启用并启动服务
sudo systemctl daemon-reload
sudo systemctl enable soga1
sudo systemctl start soga1

echo "Soga 服务已经配置并启动。"
