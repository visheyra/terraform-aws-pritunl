data "local_file" "init_script" {
    filename = "${path.module}/cloud_init/${var.ami_flavour}/init.sh"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.local_file.init_script.content}"
  }
}
