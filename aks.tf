# needed for private load balancers in subnets
resource "azurerm_user_assigned_identity" "base" {
  name                = "base"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_role_assignment" "base" {
  # needed since default AKS identity would have permissions only in  the AKS itself 
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Network Contributor" 
  principal_id         = azurerm_user_assigned_identity.base.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${local.env}-${local.eks_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "${local.env}dnsaks"

  kubernetes_version        = local.eks_version
  
  # @TODO: i prefer to disable update cluster as this will cause incompatibility issues   
  automatic_channel_upgrade = "stable" 
  
  private_cluster_enabled   = false # no VPN or bastion host required
  node_resource_group       = "${local.resource_group_name}-${local.env}-${local.eks_name}"

  # For production change to "Standard" 
  sku_tier = "Free"

  # required if with workload identity
  # oidc_issuer_enabled       = true
  # workload_identity_enabled = true

  network_profile {
    network_plugin = "azure" # other networking/service mesh
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }

  default_node_pool {
    name                 = "general"
    vm_size              = "Standard_D2_v2"
    vnet_subnet_id       = azurerm_subnet.subnet1.id
    orchestrator_version = local.eks_version
    type                 = "VirtualMachineScaleSets"
    enable_auto_scaling  = true
    node_count           = 1
    min_count            = 1
    max_count            = 2

    node_labels = {
      role = "general"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base.id]
  }

  tags = {
    env = local.env
  }

  # autoscaling enabled
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  depends_on = [
    azurerm_role_assignment.base
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = azurerm_subnet.subnet1.id
  orchestrator_version  = local.eks_version
  priority              = "Spot"
  spot_max_price        = -1
  eviction_policy       = "Delete"

  enable_auto_scaling = true
  node_count          = 1
  min_count           = 1
  max_count           = 10

  node_labels = {
    role                                    = "spot"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "spot:NoSchedule",
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = {
    env = local.env
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
