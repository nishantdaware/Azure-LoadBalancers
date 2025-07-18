resource "azurerm_public_ip" "lb_ip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.virtual_machine_rg
  allocation_method   = "Static"
}

resource "azurerm_lb" "vm_lb" {
  name                = "${var.prefix}-load-balancer"
  location            = var.location
  resource_group_name = var.virtual_machine_rg

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "vm_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.vm_lb.id
  name            = "LBBackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "vm_lb_nic_assoc" {
  for_each                = local.nics
  network_interface_id    = each.value.nic_id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.vm_lb_backend_pool.id
}

resource "azurerm_lb_probe" "vm_lb_probe" {
  loadbalancer_id = azurerm_lb.vm_lb.id
  name            = "ssh-running-probe"
  port            = 22
}

resource "azurerm_lb_rule" "vm_lb_rule" {
  loadbalancer_id                = azurerm_lb.vm_lb.id
  name                           = "SSHLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vm_lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.vm_lb_probe.id
}