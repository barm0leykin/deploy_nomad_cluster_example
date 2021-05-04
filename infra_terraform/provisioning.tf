########################################
# Template
# inventory
data "template_file" "inventory" {
  template = templatefile("templates/inv_template.tpl", { hosts = var.hosts })
}
resource "local_file" "inventory" {
  content  = data.template_file.inventory.rendered
  filename = "../infra_ansible/inventory"

  depends_on = [aws_instance.host, cloudflare_record.dns-record]
}

#########################################
# Ansible

# Запуск основного плейбука, используется ранее сгенерированный файл inventory
resource "null_resource" "ansible-playbook" {
  count      = length(var.hosts)
  depends_on = [local_file.inventory, aws_instance.host]
  triggers = {
    count = 1
  }
  provisioner "local-exec" {
    command = "cd ../infra_ansible/ && ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u root --private-key=~/.ssh/id_rsa -i inventory playbook.yml"
  }
}
