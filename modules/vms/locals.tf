locals {
  tags = merge(var.tags, { biv = var.biv })
}
