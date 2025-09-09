module "network" {
    source = "./modules/network"
    vpc_name = "caladan"
    region = "ap-southeast-1"
    env = "test"
}

module "app_instance" {
    source = "./modules/docker-instance/"

    subnet_id = module.network.subnet_id
    sg_id = module.network.sg_id

    instance_name = "app-instance"

    key_pair_name = "app-instance"
    private_key_file_name = "app_openssh_private_key"
    ami_id = "ami-015927f8ee1bc0293"

    instance_type = "t3.medium"
    s3_bucket_name = "thuan-nguyen"
    DOCKER_USERNAME = var.DOCKER_USERNAME
    DOCKER_PASSWORD = var.DOCKER_PASSWORD


    files_to_copy = [
        {
            source      = "${path.root}/../docker/app_instance/Docker-compose.yaml"
            destination = "/home/ec2-user/Docker-compose.yaml"
        },
        {
            source      = "${path.root}/../docker/app_instance/app_env.env"
            destination = "/home/ec2-user/.env"
        },
        {
            source      = "${path.root}/../docker/app_instance/otel-collector-config.yml"
            destination = "/home/ec2-user/otel-collector-config.yml"
        },
    ]
    monitor_instance_private_ip = module.monitor_instance.instance_private_ip
    env = "test"
}

module "monitor_instance" {
    source = "./modules/docker-instance/"

    subnet_id = module.network.subnet_id
    sg_id = module.network.sg_id

    instance_name = "monitor-instance"

    key_pair_name = "monitor-instance"
    private_key_file_name = "monitor_openssh_private_key"
    ami_id = "ami-015927f8ee1bc0293"

    instance_type = "t3.medium"
    s3_bucket_name = "thuan-nguyen"
    DOCKER_USERNAME = var.DOCKER_USERNAME
    DOCKER_PASSWORD = var.DOCKER_PASSWORD

    files_to_copy = [
        {
            source      = "${path.root}/../docker/monitor_instance/Docker-compose.yaml"
            destination = "/home/ec2-user/Docker-compose.yaml"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/monitor_env.env"
            destination = "/home/ec2-user/.env"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/prometheus/prometheus-config.yaml"
            destination = "/home/ec2-user/prometheus-config.yaml"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/grafana/grafana.yaml"
            destination = "/home/ec2-user/grafana.yaml"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/grafana/datasource.yaml"
            destination = "/home/ec2-user/datasource.yaml"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/grafana/dashboard.yaml"
            destination = "/home/ec2-user/dashboard.yaml"
        },
        {
            source      = "${path.root}/../docker/monitor_instance/grafana/dashboard.json"
            destination = "/home/ec2-user/dashboard.json"
        },
    ]
    monitor_instance_private_ip = module.app_instance.instance_private_ip
    env = "test"
}