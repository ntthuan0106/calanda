# Calanda

This project provisions two virtual machines in a cloud environment and deploys a simple application on one of them to measure and expose the network latency to the second machine.

## Technologies

- Terraform → Chosen for infrastructure provisioning due to wide adoption and strong AWS support.

- AWS EC2 → Preferred cloud provider, but code can be adapted for others.

- Docker + Python (Flask) + Java (Springboot) → Simple and portable way to run the latency app.

- Open Telemetry: Provides vendor-neutral observability (metrics, logs, traces) and makes it easy to instrument the application for distributed tracing.

- Prometheus: Metrics collection system used to scrape and store latency data from the applications /metrics endpoint.

- Shell scripts → Lightweight automation without requiring extra configuration management tools.

## Architecture

![images](./documentation/calanda.png)

1. User access to application
2. Otel Collector collect customized metrics defined in code
3. Prometheus scrapes metrics from OTel Collector
4. Grafana visualize metrics

## Metrics

| OTel Instrument Name              | Prometheus Metric Name(s)                                                                 | Description                                                                 |
|-----------------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| `index_counter`                   | `index_called_request_total`                                                              | Counter – number of times the **index** API is called                       |
| `add_counter`                     | `add_called_request_total`                                                                | Counter – number of times the **add** API is called                         |
| `delete_counter`                  | `delete_called_request_total`                                                             | Counter – number of times the **delete** API is called                      |
| `error_rate`                      | `error_rate_request_total`                                                                | Counter – number of requests that returned errors                           |
| `http.server.request.duration`    | `http_server_request_duration_seconds_bucket`, `http_server_request_duration_seconds_sum`, `http_server_request_duration_seconds_count` | Histogram – measures HTTP request latency (bucket: latency distribution, sum: total time, count: total number of requests) |

- Notes: When Otel collector send metrics to Prometheus has some changes in name because of Metric and label naming rules of Prometheus

Reference: [Prometheus conventions](https://prometheus.io/docs/practices/naming)

## Guideline

### Manual deploy

```bash
export DOCKER_USERNAME=""
export DOCKER_PASSWORD=""

# login Docker Hub
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

# build backend
docker build -t "$DOCKER_USERNAME/backend:v1" ./todobackend-springboot

# build frontend
docker build -t "$DOCKER_USERNAME/frontend:v1" ./todoui-flask

# build loadgenerator
docker build -t "$DOCKER_USERNAME/loadgenerator:v1" ./loadgenerator


docker push "$DOCKER_USERNAME/backend:v1"
docker push "$DOCKER_USERNAME/frontend:v1"
docker push "$DOCKER_USERNAME/loadgenerator:v1"

export TF_WORKING_DIR="./terraform"
export TF_VAR_DOCKER_USERNAME="$DOCKER_USERNAME"
export TF_VAR_DOCKER_PASSWORD="$DOCKER_PASSWORD"
terraform -chdir=${TF_WORKING_DIR} init
terraform -chdir=${TF_WORKING_DIR} apply -auto-approve
```

### Automate deploy by using Github action

1. Create secret variables

- DOCKER_USERNAME
- DOCKER_PASSWORD
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

2. Create S3 bucket and update in file **./terraform/versions.tf**

3. Go to Github Action and click **Run workflow**

![images](./documentation/github_action.png)

- Notes: Sometimes it maybe have Error: remote-exec provisioner error. You can wait a short time and run workflow again
