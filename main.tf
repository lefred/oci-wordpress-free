
locals {
  vcn_id = var.existing_vcn_ocid == "" ? oci_core_virtual_network.wordpressvcn[0].id : var.existing_vcn_ocid
  internet_gateway_id = var.existing_internet_gateway_ocid == "" ? oci_core_internet_gateway.internet_gateway[0].id : var.existing_internet_gateway_ocid
  public_route_table_id = var.existing_public_route_table_ocid == "" ? oci_core_route_table.public_route_table[0].id : var.existing_public_route_table_ocid
  public_subnet_id = var.existing_public_subnet_ocid == "" ? oci_core_subnet.public[0].id : var.existing_public_subnet_ocid
  public_security_list_id = var.existing_public_security_list_ocid == "" ? oci_core_security_list.public_security_list[0].id : var.existing_public_security_list_ocid
  public_security_list_http_id = var.existing_public_security_list_http_ocid == "" ? oci_core_security_list.public_security_list_http[0].id : var.existing_public_security_list_http_ocid
  ssh_key = var.ssh_authorized_keys_path == "" ? tls_private_key.public_private_key_pair.public_key_openssh : file(var.ssh_authorized_keys_path)
  ssh_private_key = var.ssh_private_key_path == "" ? tls_private_key.public_private_key_pair.private_key_pem : file(var.ssh_private_key_path)
  private_key_to_show = var.ssh_private_key_path == "" ? local.ssh_private_key : var.ssh_private_key_path
}


data "oci_core_images" "images_for_shape" {
    compartment_id = var.compartment_ocid
    operating_system = "Oracle Linux"
    operating_system_version = "9"
    shape = var.node_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
}

data "oci_identity_availability_domains" "ad" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "ad_names" {
  count    = length(data.oci_identity_availability_domains.ad.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")
}


resource "oci_core_virtual_network" "wordpressvcn" {
  cidr_block = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name = var.vcn
  dns_label = "wordpressvcn"

  count = var.existing_vcn_ocid == "" ? 1 : 0
}


resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway"
  vcn_id = local.vcn_id

  count = var.existing_internet_gateway_ocid == "" ? 1 : 0
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  display_name = "RouteTableForMySQLPublic"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id
  }

  count = var.existing_public_route_table_ocid == "" ? 1 : 0
}


resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to WordPress"
  vcn_id = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  count = var.existing_public_security_list_ocid == "" ? 1 : 0
}

resource "oci_core_security_list" "public_security_list_http" {
  compartment_id = var.compartment_ocid
  display_name = "Allow HTTP(S) to WordPress"
  vcn_id = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  count = var.existing_public_security_list_http_ocid == "" ? 1 : 0
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

resource "oci_core_subnet" "public" {
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name = "mysql_public_subnet"
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  route_table_id = local.public_route_table_id
  security_list_ids = [local.public_security_list_id, local.public_security_list_http_id]
  #dhcp_options_id = var.use_existing_vcn_ocid ? var.existing_vcn_ocid.default_dhcp_options_id : oci_core_virtual_network.wordpressvcn[0].default_dhcp_options_id
  dns_label = "mysqlpub"

  count = var.existing_public_subnet_ocid == "" ? 1 : 0
}

module "wordpress" {
  source                = "./modules/wordpress"
  availability_domains   = data.template_file.ad_names.*.rendered
  compartment_ocid      = var.compartment_ocid
  image_id              = var.node_image_id == "" ? data.oci_core_images.images_for_shape.images[0].id : var.node_image_id
  shape                 = var.node_shape
  label_prefix          = var.label_prefix
  subnet_id             = local.public_subnet_id
  ssh_authorized_keys   = local.ssh_key
  ssh_private_key       = local.ssh_private_key
  admin_password        = var.admin_password
  wp_schema             = var.wp_schema
  wp_name               = var.wp_name
  wp_password           = var.wp_password
  display_name          = var.wp_instance_name
  nb_of_webserver       = var.nb_of_webserver
  flex_shape_ocpus      = var.node_flex_shape_ocpus
  flex_shape_memory     = var.node_flex_shape_memory
}

