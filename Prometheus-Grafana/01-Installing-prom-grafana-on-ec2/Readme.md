# Hands-on Prometheus & Grafana-01: Prometheus & Grafana Basic

Purpose of the this hands-on training is to give students the knowledge of basic operations about Prometheus & Grafana.

## Learning Outcomes

At the end of this hands-on training, students will be able to;

* Learn how to install Prometheus and Grafana
* Learn how to monitor with Prometheus
* Learn how to create a monitoring dashboard with Grafana

## Outline

- Part 1 - Install, configure, and use a simple Prometheus instance

- Part 2 - Monitoring with Prometheus WebUI

- Part 3 - Install, configure, and use a simple Grafana instance 

- Part 4 - Creating a monitoring dashboard with Grafana 

## Part 1 - Learn install, configure, and use a simple Prometheus instance

- Launch an Amazon EC2 instance with setting seen below: 

AMI: "Amazon Linux 2"  
Instance Type : "t2micro"  
Region: "N.Virginia"  
VPC: "Default VPC"  
Securtiy Group: "Port 22, 3000, 9090, 9100"  

- [Download the latest release](https://prometheus.io/download/) of Prometheus for linux. Select *.linux-*.tar.gz

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-amd64.tar.gz
```

Extract and run it.

```bash
tar xvfz prometheus-*.tar.gz
cd prometheus-*
```

- Check the basic prometheus configuration.

```
cat prometheus.yml
```

Output:

```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
```

- Start Prometheus.

```bash
./prometheus --config.file=prometheus.yml
```

- Open the prometheus web UI from your browser.

```
http://<public ip>:9090
```

