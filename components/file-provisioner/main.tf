resource "null_resource" "this" {
  count = length(var.contents)
  triggers = {
    when = timestamp()
    // work around, value to trigger to run destroy hook
    destroy_cmd = var.destroy_cmd
    user        = var.user
    host        = var.host
    private_key = var.private_key
  }
  // destroy file which was provisoned
  // recommend not to do this because we need to set private key to self instance
  # provisioner "remote-exec" {
  #   when = destroy
  #   inline = [
  #     "${self.triggers.destroy_cmd != null ? self.triggers.destroy_cmd : "echo \"destroyed but no command ran\""}"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     user        = self.triggers.user
  #     host        = self.triggers.host
  #     private_key = self.triggers.private_key
  #   }
  # }

  // @depricated
  // this code use to create dir on remote server
  // use before-cmd instead of
  provisioner "remote-exec" {
    inline = [
      "${var.contents[count.index].create_dir != null ? "mkdir -p ${var.contents[count.index].create_dir}" : "echo 1"}"
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = var.host
      private_key = var.private_key
    }
  }
  // before cmd
  provisioner "remote-exec" {
    inline = [
      "${var.contents[count.index].before_inline_cmd != null ? var.contents[count.index].before_inline_cmd : "echo not_executed"}"
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = var.host
      private_key = var.private_key
    }
  }
  // provision file
  provisioner "file" {
    source      = var.contents[count.index].source
    destination = var.contents[count.index].destination
    connection {
      type        = "ssh"
      user        = var.user
      host        = var.host
      private_key = var.private_key
    }
  }
  // after cmd
  provisioner "remote-exec" {
    inline = [
      "${var.contents[count.index].after_inline_cmd != null ? var.contents[count.index].after_inline_cmd : "echo not_executed"}"
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = var.host
      private_key = var.private_key
    }
  }
}
