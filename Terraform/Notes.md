# HCL(Hashicorp Configuration Language) Basics
---------------------------------------------
## Basic Syntax 
```bash
    <block> <paramter> {
        key1 = value1
        key2 = value2
    }
```

Example: local.tf
```bash
    resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = "We love Pets!"
    }
```
Here,

``
    resource =  Block name,
    local_file =  Resource type (local=provider;file=resource),
    pet = Resource name,
    filename = "/root/pets.txt" (Arguments in key-value format),
    content = "We love Pets!" 
``



# Steps to running this .tf file
- Run `terraform init` command.
    - This will initialize a terraform directory and install all the dependent provider mention in the local.tf file
- Run `terraform plan` command
    - This will show the plan of executing the local.tf file to user.
    - User can confirm the file and plan using this command.
- Run `terraform apply` command
    - Terraform will apply the changes in local.tf file

## Inspect resource details in terraform.
-  `terraform show`

# Update and Destory infrastructure using Terraform.
Taking previous example:
```bash
    resource "local_file" "pet" {
        filename = "/root/pets.txt"
        content = "We love Pets!"
        +file_permissions = "0700"            ---> I have added this line in my local.tf file.
    }
```

In this case, terraform will destory the infrastructure and re-create it since we added the `file_permissions` argument in the local.tf file. This type of infrastructure is called `Immutable Infrastructure`.

- Run `terraform plan` command to see the changes. Then,
- Run `terraform apply` command to make the changes

To delete the infrastructure, run `terraform destory` command and it will destory the resource completely.


# Providers in Terraform
- Terraform uses plugin-based architecture to connect with different infrastructure platforms.
- You can find them in the link: https://registry.terraform.io/

- We can have diffrent .tf file in a working or configuration directory. Some of them maybe:
    - `main.tf`       - Main config file containing resource definition.
    - `variables.tf`  - Contains declared variables.
    - `outputs.tf`    - Contains output from resource.
    - `provider.tf`   - Contains providers definition.

## Using input variables

Example: `main.tf` file

```bash
    resource "local_file" "pet_name" {
            content = "We love pets!"
            filename = "/Users/kanishqk77/Desktop/DevOps/Terraform/dev/pets.txt"
    }

    resource "random_pet" "my-pet" {
            prefix = "Mrs"
            separator = "."
            length = "1"
    }
```
- Create another file called `variables.tf` in confiuration directory and add the vaiables in this file like,


`variables.tf` file
---
```bash
    variable "content" {
        default = "We love pets!"
    }
    variable "filename" {
        default = "/Users/kanishqk77/Desktop/DevOps/Terraform/dev/pets.txt"
    }
    variable "separator" {
        default = "Mrs"
    }
    variable "content" {
        default = "."
    }
    variable "length" {
        default = "1"
    }

```

- With this change, our `main.tf` file will also change,


Updated `main.tf` file
--- 
```bash
    resource "local_file" "pet_name" {
            content = var.content
            filename = var.filename
    }

    resource "random_pet" "my-pet" {
            prefix = var.prefix
            separator = var.seperator
            length = var.length
    }

```

- We can define the `type` and `description` inside the particular variable block.
- Types can be:
    - string
    - int
    - bool
    - any(default)
    - list
    - maps
    - sets
    - complex

# Linking two resources together using resource attributes
- In this given example `main.tf` file, we want the `id` genrated by `my-pet` resource is used by the `pet_name` resource.


Given `main.tf` file:

```bash
    resource "local_file" "pet_name" {
            content = var.content
            filename = "My favourite pet is Mr.cat"
    }

    resource "random_pet" "my-pet" {
            prefix = var.prefix
            separator = var.seperator
            length = var.length
    }

```

We can do this by replacing the `filename` value inside `pet_name` as,
`"My favourite pet is ${random_pet.my-pet.id}"`

- With this the `pet_name` resource uses the value of `id` generasted by resource `my-pet`.   

## Implicit & Explicit dependencies
- When we are specifing the resource which is being used by another resource using reference expression(like `${random_pet.my-pet.id}`), this is called `Implicit` dependency.
- Otherhand, if we use keyword called `depends_on` in the resource block by specifing the number of resources which depends, this is called `Explicit` dependency.

Exaample of `depends_on`:

``` bash
    resource "local_file" "pet_name" {
            content = var.content
            filename = "My favourite pet is Mr.cat"
            depends_on [
                random_pet.my-pet
            ]
    }

    resource "random_pet" "my-pet" {
            prefix = var.prefix
            separator = var.seperator
            length = var.length
    }
```


# Some terraform commands:

## To check the syntax of the configuration file(.tf)
- `terraform validate`

## Format the code into canonical format
- `terraform fmt` (improve readability of the configuration file)

## Check current state of the infrastructure
- `terraform show`
(use `--json` option to print it in JSON format)

## Check providers in configuration files
- `terraform providers`

## Mirror the providers configuration to a new file
- `terraform providers mirror /path/to/new_file`

## To update the state of the terraform config file
- `terraform refresh`

## See dependencies in your config file in config directory
- `terraform graph`



# Data Sources in Terraform
- Datasources allows terraform to read attributes of the resources that are provision poutside its control.

Example:

```bash
        resource "local_file" "pet" {
            filename = "/root/pets.txt"
            content = "We love pets!!"
        }

        data "local_file" "dog" {
            filename = "/root/dogs.txt"
        }
```

Diffrences between `resource` and `data` block in terraform:

Resource block
- Keyword: `resource`
- **Creates**, **Updates**, **Destroys** infrastructure
- Also called **Managed Resource**

Data Block
- Keyword: `data`
- Only **reads** infrastructure
- Also called **Data Resource**


```bash
    -- main.tf
    resource "local_sensitive_file" "name" {
        filename = var.users[count.index]
        content = var.content
        count = length(var.users)
    }

    -- variable.tf
    variable "users" {
        type = list
    }
    variable "content" {
        default = "password: S3cr3tP@ssw0rd"
    }
```

```bash
    resource "local_sensitive_file" "name" {
        filename = each.value
        for_each = toset(var.users)
        content = var.content

    }
```

## Remote States

What does state file in terraform does?
- Mapping configurations to real world.
- Tracking Metadata.
- Performance
- Collaboration and provisioning.

- Cannot store the state file into a version control system because it contains sensitive information regarding configurations.

- Terraform does not allow multiple operations against the same configuration file.
- Prevents corruption of the state file, this is called the `State Locking` in Terraform.

- Version control system does not support `state locking`. Multiple users can access the state file simultanously, which leads to data loss in a state file.

- It is recommended to store the Terraform state file in a `Remote state backend` such as `AWS S3`, `Hashicorp Consul`, `Google Cloud Storage`, `Terraform Cloud` etc.

- `Remote State Backend` supports `State Locking` and provides security using encryption of the state file stored.


## Terraform State Commands

Syntax: `terraform state <subcommand> [options] [args]`

### Resources recorded by the terraform state file
- `terraform state list`

### Show attributes of resources recorded by the terraform state file
- `terraform state show <resource_name>`

### Move items in terraform state file
- `terraform state mv [options] SOURCE DESTINATION` 

### Pull terraform state file from remote state backend
- `terraform state PULL` 

### Delete items from terraform state file
- `terraform state rm ADDRESS` 
ex: terraform state rm aws_s3_bucket.finance-20240325


## Terraform Provisioners
- Provide a way to carry out task like running commands, scripts on remote resource or locally where terraform is installed.

Ex: remote_exec

```bash
resource "aws_instance" "webserver" {
    ami = "ami-1212698324312"
    instance_type = "t2.micro"

    provisioner "remote_exec" {
        inline = [
            "sudo apt update"
            "sudo apt install nginx -y"
            "sudo systemctl enable nginx"
            "sudo systemctl start nginx"
        ]
    }
    ....
}
```


Ex: local_exec

```bash
resource "aws_instance" "webserver" {
    ami = "ami-1212698324312"
    instance_type = "t2.micro"

    provisioner "local_exec" {
      command = "echo ${aws_instance.webserver.public_ip} >> /tmp/ips.txt"
    }
    ....
}
```

- Provisioners runs after the resource is created. (Create time Provisioner)


Ex: `Destroy Time Provisioners`

```bash
resource "aws_instance" "webserver" {
    ami = "ami-1212698324312"
    instance_type = "t2.micro"

    provisioner "local_exec" {
      command = "echo Instance ${aws_instance.webserver.public_ip} created! >> /tmp/ips.txt"
    }

    provisioner "local_exec" {
      when = destroy
      command = "echo Instance ${aws_instance.webserver.public_ip} destroyed! >> /tmp/ips.txt"
    }
    ....
}
```

Ex: `Failure Behaviour`

```bash
resource "aws_instance" "webserver" {
    ami = "ami-1212698324312"
    instance_type = "t2.micro"

    provisioner "local_exec" {
      command = "echo Instance ${aws_instance.webserver.public_ip} created! >> /temp/ips.txt"
    }

    provisioner "local_exec" {
      when = destroy
      command = "echo Instance ${aws_instance.webserver.public_ip} destroyed! >> /tmp/ips.txt"
    }
    ....
}
```

- Above resource creation will fail due to the incorrect filename.
- To resolve this add the `on_failure = continue` before the command in provisioner block which is failed.


```bash
resource "aws_instance" "webserver" {
    ami = "ami-1212698324312"
    instance_type = "t2.micro"

    provisioner "local_exec" {
      on_failure = continue
      command = "echo Instance ${aws_instance.webserver.public_ip} created! >> /temp/ips.txt"
    }

    provisioner "local_exec" {
      when = destroy
      command = "echo Instance ${aws_instance.webserver.public_ip} destroyed! >> /tmp/ips.txt"
    }
    ....
}
```

- After applying this, provision will be created successfully.

## Tainting in Terraform

- During creation of a resource, we might encounter some issues and it fails.
- which leads to the tainting as terraform marks the resource as `tainted`.
- Terraform tries to re-create this resource during subsequent apply.

If we want to manual force resource to be re-created after apply, we can use `taint` command 
- `terraform taint <resource_name>`

If we want to undo the taint for the resource
- `terraform untaint <resource_name>`


## Logging and Debugging

Before running any terraform command set env variable `export TF_LOG=<log_level>`, this will enable the logging

Log Levels:
- INFO
- WARNING
- ERROR
- DEBUG
- TRACE (Very Verbose)

To store the logs set the env variable which stores the logs in a file
- `export TF_LOG_PATH = "/tmp/terraform.log"`

Remove logging path
- `unset TF_LOG_PATH`


## 