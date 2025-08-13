data "template_file" "userdata-mara" {
  template = file("Apache-Installation.tpl")
}

data "template_file" "userdata-mysql-mara" {
  template = file("mysql.tpl")
}