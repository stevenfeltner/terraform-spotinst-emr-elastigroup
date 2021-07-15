terraform {
  required_version = ">= 0.13.0"
  required_providers {
    spotinst = {
      source = "spotinst/spotinst"
    }
  }
}

provider "spotinst" {
  token = var.spot_token
  account = var.spot_account
}

locals {
  cmd = "${path.module}/scripts/get-emr"
  cluster_id = data.external.cluster_id.result["cluster_id"]
  dns_name = data.external.dns_name.result["dns_name"]
}

# Create a Elastigroup with EMR integration(Mr Scaler) with New strategy
resource "spotinst_mrscaler_aws" "MrScaler" {
  name                = var.name
  description         = var.description
  region              = var.region
  strategy            = var.strategy
  cluster_id          = var.cluster_id
  expose_cluster_id   = var.expose_cluster_id

  provisioning_timeout {
    timeout           = var.timeout
    timeout_action    = var.timeout_action
  }
  retries             = var.retries

  release_label       = var.release_label

  availability_zones  = var.availability_zones

  // --- CLUSTER ------------
  log_uri                             = var.log_uri
  additional_info                     = var.additional_info
  security_config                     = var.security_config
  service_role                        = var.service_role
  job_flow_role                       = var.job_flow_role
  termination_protected               = var.termination_protected
  keep_job_flow_alive                 = var.keep_job_flow_alive


  custom_ami_id                       = var.custom_ami_id
  ec2_key_name                        = var.ec2_key_name

  managed_primary_security_group      = var.master_sg_id
  managed_replica_security_group      = var.slave_sg_id
  service_access_security_group       = var.service_sg_id

  additional_primary_security_groups  = var.additional_master_sg_ids
  additional_replica_security_groups  = var.additional_slave_sg_ids

  dynamic applications {
    for_each = var.applications == null ? [] : var.applications
    content {
      name = applications.value["name"]
      version = applications.value["version"]
    }
  }

  /* Uncomment if you need to use steps or configurations file
  steps_file {
    bucket  = var.steps_bucket
    key     = var.steps_key
  }

  configurations_file {
    bucket  = var.config_bucket
    key     = var.config_key
  }
*/

  bootstrap_actions_file {
    bucket  = var.bootstrap_bucket
    key     = var.bootstrap_key
  }
  // -------------------------

  // --- MASTER GROUP -------------
  master_instance_types = var.master_instance_type
  master_lifecycle      = var.master_lifecycle
  master_ebs_optimized  = var.master_ebs_optimized

  master_ebs_block_device {
    volumes_per_instance = var.master_volume_per_instance
    volume_type          = var.master_volume_type
    size_in_gb           = var.master_size_in_gb
  }
  // ------------------------------

  // --- CORE GROUP -------------
  core_instance_types     = var.core_instance_types
  core_min_size           = var.core_min_size
  core_max_size           = var.core_max_size
  core_desired_capacity   = var.core_desired_capacity
  core_lifecycle          = var.core_lifecycle
  core_ebs_optimized      = var.core_ebs_optimized
  core_unit               = var.core_unit

  core_ebs_block_device {
    volumes_per_instance  = var.core_volume_per_instance
    volume_type           = var.core_volume_type
    size_in_gb            = var.core_size_in_gb
  }
  // ----------------------------

  // --- TASK GROUP -------------
  task_instance_types     = var.task_instance_types
  task_min_size           = var.task_min_size
  task_max_size           = var.task_max_size
  task_desired_capacity   = var.task_desired_capacity
  task_lifecycle          = var.task_lifecycle
  task_ebs_optimized      = var.task_ebs_optimized
  task_unit               = var.task_unit

  task_ebs_block_device {
    volumes_per_instance = var.task_volume_per_instance
    volume_type          = var.task_volume_type
    size_in_gb           = var.task_size_in_gb
  }
  // ----------------------------

  dynamic tags {
    for_each = var.tags == null ? [] : var.tags
    content {
      key = tags.value["key"]
      value = tags.value["value"]
    }
  }
}



### Call script to get the cluster ID using Spot APIs ###
data "external" "cluster_id" {
    depends_on = [spotinst_mrscaler_aws.MrScaler]
    program = [local.cmd, "get-logs", spotinst_mrscaler_aws.MrScaler.id]
}

### Call script to get the DNS name/Ip address from the cluster###
data "external" "dns_name" {
  depends_on = [data.external.cluster_id]
  program = [local.cmd, "get-dns", local.cluster_id, var.region]
}

