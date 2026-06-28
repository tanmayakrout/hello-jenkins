provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Allow Prometheus, Grafana, Node Exporter, and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Prometheus
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Grafana
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Node Exporter
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "monitoring_ec2" {
  ami           = "ami-0f8ca728008ff5af4" # Ubuntu 22.04 LTS in ap-south-1
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = "VPCTest" # replace with your AWS keypair

  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y wget curl tar systemctl

              # Install Prometheus
              useradd --no-create-home --shell /bin/false prometheus
              sudo mkdir -p /var/lib/prometheus
              sudo mkdir -p /etc/prometheus
              sudo chown -R prometheus:prometheus /var/lib/prometheus
              sudo chown -R prometheus:prometheus /etc/prometheus

              wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
              tar -xvf prometheus-2.52.0.linux-amd64.tar.gz
              mv prometheus-2.52.0.linux-amd64/prometheus /usr/local/bin/
              mv prometheus-2.52.0.linux-amd64/promtool /usr/local/bin/
              mv prometheus-2.52.0.linux-amd64/consoles /etc/prometheus
              mv prometheus-2.52.0.linux-amd64/console_libraries /etc/prometheus
              mv prometheus-2.52.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml

              # Custom Prometheus config with Node Exporter scrape job
              cat <<EOT > /etc/prometheus/prometheus.yml
              global:
                scrape_interval: 15s

              scrape_configs:
                - job_name: 'prometheus'
                  static_configs:
                    - targets: ['localhost:9090']

                - job_name: 'node'
                  static_configs:
                    - targets: ['localhost:9100']
              EOT

              # Prometheus service
              cat <<EOT > /etc/systemd/system/prometheus.service
              [Unit]
              Description=Prometheus
              After=network.target

              [Service]
              User=prometheus
              ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --web.listen-address=:9090
              Restart=always

              [Install]
              WantedBy=multi-user.target
              EOT

              systemctl daemon-reload
              systemctl enable prometheus
              systemctl start prometheus

              # Install Node Exporter
              useradd --no-create-home --shell /bin/false node_exporter
              wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
              tar -xvf node_exporter-1.8.1.linux-amd64.tar.gz
              mv node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/

              cat <<EOT > /etc/systemd/system/node_exporter.service
              [Unit]
              Description=Node Exporter
              After=network.target

              [Service]
              User=node_exporter
              ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9100
              Restart=always

              [Install]
              WantedBy=multi-user.target
              EOT

              systemctl daemon-reload
              systemctl enable node_exporter
              systemctl start node_exporter

              # Install Grafana
              wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
              add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
              sudo apt-get update -y
              sudo apt-get install -y grafana
              systemctl enable grafana-server
              systemctl start grafana-server
              EOF

  tags = {
    Name = "Monitoring-EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.monitoring_ec2.public_ip
}

output "prometheus_url" {
  value = "http://${aws_instance.monitoring_ec2.public_ip}:9090"
}

output "grafana_url" {
  value = "http://${aws_instance.monitoring_ec2.public_ip}:3000"
}

output "node_exporter_url" {
  value = "http://${aws_instance.monitoring_ec2.public_ip}:9100"
}
