# EMR Terraform Example for Spot.io

## Introduction
Provided is an example Terraform module leveraging the Spotinst Provider calling the Mr Scaler resource. The following module will automatically create an Elastigroup and create a new or integrate with an existing EMR cluster. 
This module will also leverage a python script to retrieve the cluster identifier and the master public dns ip of a cluster.

## Pre-Req
- Spot token placed in environment variable `SPOTINST_TOKEN` 
- Python3

## Example
```hcl
### Create Elastigroup EMR Cluster in Spot.io ###
module "elastigroup_emr" {
  source = "stevenfeltner/emr-elastigroup/spotinst"

  spotinst_token = ""
  
  ### Cluster Configurations ###
  name = "Example-Spot-EMR-Terraform"
  region = "us-east-1"
  strategy = "new"
  release_label = "emr-5.24.0"

  log_uri = "s3://test-123456789/logs/"
  custom_ami_id = "ami-068c8ed05785be1c4"
  
  keep_job_flow_alive = false
  applications = [{name = "hive", version = "2.37"},{name = "spark", version = "2.47"}]
  tags = [{key="CreatedBy",value="Terraform"}]

  ### Network ###
  availability_zones = ["us-east-1a:subnet-123456789","us-east-1b:subnet-123456789"]
  master_sg_id = "sg-123456789"
  slave_sg_id = "sg-123456789"

  ### Config/step Files ###
  # Bootstrap arguments stored in a file on s3
  bootstrap_bucket = "test-bucket"
  bootstrap_key = "bootstrap.json"

  #configuration file stored in a file on s3. Note uncomment line 60 in the module main.tf
  #steps_bucket = ""
  #steps_key = ""

  #configuration file stored in a file on s3. Note uncomment line 66 in the module main.tf
  #config_bucket = ""
  #config_key = ""

  ### Master Node Configs ###
  master_instance_type = ["m4.large"]

  ### Core Node Configs ###
  core_instance_types = [
    "m4.2xlarge",
    "m4.4xlarge",
    "m5.4xlarge",
    "m5.2xlarge",
    "m5.8xlarge",
    "r5.4xlarge",
    "r5d.4xlarge",
    "m5.8xlarge",
    "m5d.4xlarge"
  ]
  core_lifecycle = "SPOT"
  core_desired_capacity = 1

  ### Task node configs ###
  task_instance_types = [
    "m4.2xlarge",
    "m4.4xlarge",
    "m5.4xlarge",
    "m5.2xlarge",
    "m5.8xlarge",
    "r5.4xlarge",
    "r5d.4xlarge",
    "m5.8xlarge",
    "m5d.4xlarge"
  ]
  task_desired_capacity = 0
}

### Outputs ###
output "eg_id" {
  value = module.elastigroup_emr.elastigroup_id
}
output "cluster_id" {
  value = module.elastigroup_emr.cluster_id
}
output "ip" {
  value = module.elastigroup_emr.ip
}
```