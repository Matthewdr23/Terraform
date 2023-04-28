#Kubernetes Cluster

data "civo_size" "xsmall" {
    filter {
      key = "name"
      values = ["g4s.kube.xsmall"]
      match_by = "re"
    }
}

resource "civo_kubernetes_cluster" "k8s_demo_1" {
    name = "k8s_demo_1"
    applications = ""
    num_target_nodes = 2
    target_nodes_size = element(data.civo_size.xsmall, 0).name
  
}

resource "civo_firewall" "fw_demo_1" {
    name = "fw_demo_1"

# The reason as to why we set the default rule to false si because if we had set it to
# true the it would allow all IPs from all ports to access the cluster and that is not
# What we want.
    create_default_rules = false

  
}

resource "civo_firewall_rule" "Kubernetes_http" {
  
  firewall_id = civo_firewall.fw_demo_1.id
  protocol = "tcp"
  start_port = "80"
  end_port = "80"
  cidr = ["0.0.0.0/0"]
  direction = "Ingress"
  action = "allow"
  label = "Kubernetes_http"
}   

resource "civo_firewall_rule" "Kubernetes_https" {
    firewall_id = civo_firewall.fw_demo_1.id
    protocol = "tcp"
    start_port = "443"
    end_port = "443"
    cidr = [ "0.0.0.0/0" ]
    direction = "Ingress"
    action = "allow"
    label = "Kubernetes_https"

  
}

#This is needed for Terraform to communicate with the cluster adn you also need it to -
# Connect via Kubectl

resource "civo_firewall_rule" "Kubernetes_api" {
    firewall_id = civo_firewall.fw_demo_1.id
    protocol = "tcp"
    start_port = "6443"
    end_port = "6443"
    cidr = [ "0.0.0.0/0" ]
    direction = "Ingress"
    action = "allow"
    label = "Kubernetes_api"

  
}