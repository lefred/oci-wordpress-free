variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default = ""
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "region" {
  description = "OCI Region"
}

variable "existing_vcn_ocid" {
  description = "OCID of an existing VCN to use"
  default     = ""
}

variable "existing_public_subnet_ocid" {
  description = "OCID of an existing public subnet to use"
  default     = ""
}

variable "existing_internet_gateway_ocid" {
  description = "OCID of an existing internet gateway to use"
  default     = ""
}

variable "existing_public_route_table_ocid" {
  description = "OCID of an existing public route table to use"
  default     = ""
}

variable "existing_public_security_list_ocid" {
  description = "OCID of an existing public security list (ssh) to use"
  default     = ""
}

variable "existing_public_security_list_http_ocid" {
  description = "OCID of an existing security list allowing https and https to use"
  default     = ""
}

variable "vcn" {
  description = "VCN Name"
  default     = "mysql_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "fingerprint" {
  description = "Key Fingerprint"
  default     = ""
}

variable "dns_label" {
  description = "Allows assignment of DNS hostname when launching an Instance. "
  default     = ""
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard.A1.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 4
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 24
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}

variable "admin_password" {
  description = "Password for the root user for MySQL Database Service"
  default = "MyPassw0rd!"
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "private_key_path" {
  description = "The private key path to pem. DO NOT FILL WHEN USING RESOURCE MANAGER STACK! "
  default     = ""
}

variable "wp_name" {
  description = "WordPress Database User Name."
  default     = "wp"
}

variable "wp_password" {
  description = "WordPress Database User Password."
  default     = "MyWPpassw0rd!"
}

variable "wp_schema" {
  description = "WordPress MySQL Schema"
  default     = "wordpress"
}

variable "wp_instance_name" {
  description = "Name of the WordPress compute instance"
  default     = "WordPressServer"
}

variable "nb_of_webserver" {
    description = "Amount of Webservers to deploy"
    default = 1
}

