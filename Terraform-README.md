## What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows you to define, provision, and manage cloud infrastructure and resources using a declarative configuration language called HashiCorp Configuration Language (HCL). With Terraform, you can automate the setup and management of resources across various cloud providers such as AWS, Azure, Google Cloud, and many others.

**Key Features:**
- Infrastructure as Code (IaC)
- Supports multiple cloud providers
- Declarative configuration files
- Resource provisioning, modification, and destruction
- State management and change automation

Terraform helps teams achieve consistent, repeatable infrastructure deployments and simplifies cloud resource management.

## Installing Terraform

### Prerequisites
- Supported operating system (Windows, macOS, or Linux)
- Command-line interface (CLI) access

### Installation Steps

#### Windows
1. Download the [Terraform ZIP package](https://www.terraform.io/downloads.html) for Windows.
2. Extract the ZIP file to a directory of your choice.
3. Add the directory to your system's `PATH` environment variable.
4. Verify installation by running:
    ```sh
    terraform -version
    ```

#### Linux
1. Download the appropriate package from the [Terraform downloads page](https://www.terraform.io/downloads.html).
2. Unzip the package:
    ```sh
    unzip terraform_<VERSION>_linux_amd64.zip
    ```
3. Move the binary to `/usr/local/bin`:
    ```sh
    sudo mv terraform /usr/local/bin/
    ```
4. Verify installation:
    ```sh
    terraform -version
    ```

For more details, refer to the [official installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
## Basic Terraform Commands

Once Terraform is installed and your configuration files are ready, you can use the following core commands to manage your infrastructure:

### 1. `terraform init`
Initializes a working directory containing Terraform configuration files. This command downloads the necessary provider plugins and sets up the backend.

```sh
terraform init
```

### 2. `terraform plan`
Creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in your configuration files. This helps you review changes before applying them.

```sh
terraform plan
```

### 3. `terraform apply`
Applies the changes required to reach the desired state of the configuration. Terraform will prompt for approval before making any changes unless you use the `-auto-approve` flag.

```sh
terraform apply
```

### 4. `terraform destroy`
Destroys the infrastructure managed by your Terraform configuration. This command removes all resources defined in your configuration files.

```sh
terraform destroy
```

These commands form the core workflow for provisioning, updating, and tearing down infrastructure with Terraform.

## Terraform Providers and Initialization

### What are Providers?

Providers are plugins that allow Terraform to interact with APIs of cloud platforms and other services (such as Azure, Google Cloud, AWS, and more). Each provider manages the lifecycle of resources for a specific platform.

You specify providers in your configuration file using a `provider` block. For example, to use Azure and Google Cloud:

```hcl
provider "azurerm" {
    features {}
}

provider "google" {
    project = "your-gcp-project-id"
    region  = "us-central1"
}
```

### Initializing Providers

When you run `terraform init`, Terraform:

- Downloads the required provider plugins (like AzureRM and Google).
- Installs them in a local `.terraform` directory.
- Prepares the working directory for other commands.

Example:

```sh
terraform init
```

You must run this command whenever you add a new provider or update provider versions in your configuration.

For more details, see the [Terraform Providers documentation](https://developer.hashicorp.com/terraform/docs/language/providers).


## Terraform State File

Terraform uses a state file (`terraform.tfstate`) to keep track of the resources it manages. This file records the current state of your infrastructure, mapping your configuration to real-world resources.

### Key Points:
- The state file is critical for Terraform to determine what actions are required to achieve the desired infrastructure state.
- By default, the state file is stored locally, but it can be stored remotely (e.g., in AWS S3, Azure Blob Storage) for team collaboration and enhanced security.
- Sensitive data may be stored in the state file, so handle it securely and avoid committing it to version control.

### Common State File Commands

- **Show current state:**
    ```sh
    terraform show
    ```
- **List resources in state:**
    ```sh
    terraform state list
    ```
- **Move or remove resources from state:**
    ```sh
    terraform state mv <source> <destination>
    terraform state rm <address>
    ```

For more information, see the [Terraform State documentation](https://developer.hashicorp.com/terraform/language/state).

## Defining Variables in Terraform

Variables in Terraform allow you to parameterize your configuration, making it reusable and flexible. You can define variables in a `variables.tf` file and provide their values through `.tfvars` files, environment variables, or CLI arguments.

### Example: Variables for Azure and GCP

**variables.tf**
```hcl
variable "azure_region" {
    description = "The Azure region to deploy resources"
    type        = string
    default     = "eastus"
}

variable "gcp_project" {
    description = "The GCP project ID"
    type        = string
}

variable "gcp_region" {
    description = "The GCP region"
    type        = string
    default     = "us-central1"
}
```

**Usage in provider blocks:**
```hcl
provider "azurerm" {
    features {}
    location = var.azure_region
}

provider "google" {
    project = var.gcp_project
    region  = var.gcp_region
}
```

**Supplying variable values:**

- Using a `terraform.tfvars` file:
        ```hcl
        gcp_project = "your-gcp-project-id"
        ```

- Or via CLI:
        ```sh
        terraform apply -var="gcp_project=your-gcp-project-id"
        ```

For more details, see the [Terraform Input Variables documentation](https://developer.hashicorp.com/terraform/language/values/variables).

## Terraform Variable Data Types

Terraform supports several variable data types to help you define and validate input values in your configuration. The main types are:

- **string**: A sequence of Unicode characters.
- **number**: Any numeric value (integer or float).
- **bool**: Boolean values (`true` or `false`).
- **list(type)**: An ordered sequence of values, all of the specified type.
- **map(type)**: A collection of key-value pairs, where all values are of the specified type.
- **set(type)**: An unordered collection of unique values, all of the specified type.
- **object({attr1=type, ...})**: A collection of named attributes with specified types.
- **tuple([type1, type2, ...])**: A sequence of values, each with a specific type.

### Example Variable Type Declarations

```hcl
variable "instance_count" {
    description = "Number of instances"
    type        = number
    default     = 2
}

variable "tags" {
    description = "Resource tags"
    type        = map(string)
    default     = {
        environment = "dev"
        owner       = "team"
    }
}

variable "allowed_ips" {
    description = "List of allowed IP addresses"
    type        = list(string)
    default     = ["192.168.1.1", "10.0.0.1"]
}

variable "settings" {
    description = "Custom object variable"
    type = object({
        name = string
        enabled = bool
    })
    default = {
        name    = "example"
        enabled = true
    }
}

variable "server_ports" {
    description = "Tuple of ports for different services"
    type        = tuple([number, number, number])
    default     = [80, 443, 8080]
 }
```

For more details, see the [Terraform Type Constraints documentation](https://developer.hashicorp.com/terraform/language/expressions/type-constraints).


## Using Conditionals in Terraform

Terraform supports conditional expressions, allowing you to dynamically set values based on certain conditions. This is useful for customizing resource configurations depending on variables or environment settings.

### Basic Conditional Syntax

The syntax for a conditional expression is:

```hcl
condition ? true_value : false_value
```

### Example 1: Conditional Resource Creation for Azure

Suppose you want to create an Azure resource only if a variable is set to `true`:

```hcl
variable "create_storage" {
    description = "Whether to create an Azure Storage Account"
    type        = bool
    default     = true
}

resource "azurerm_storage_account" "example" {
    count                    = var.create_storage ? 1 : 0
    name                     = "examplestorageacct"
    resource_group_name      = "example-rg"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
}
```

**Explanation:**  
The `count` argument uses a conditional to determine if the resource should be created. If `create_storage` is `true`, one resource is created; otherwise, none.

### Example 2: Conditional Variable Assignment for Google Cloud

You can use conditionals to set variable values based on another variable, such as choosing a region based on the environment:

```hcl
variable "environment" {
    description = "Deployment environment"
    type        = string
    default     = "dev"
}

locals {
    gcp_region = var.environment == "prod" ? "us-central1" : "us-west1"
}

provider "google" {
    project = "your-gcp-project-id"
    region  = local.gcp_region
}
```

**Explanation:**  
The `gcp_region` local value is set to `"us-central1"` if the environment is production, otherwise it defaults to `"us-west1"`.

### Example 3: Conditional Output

You can also use conditionals in outputs to display different values:

```hcl
output "azure_or_gcp" {
    value = var.environment == "prod" ? "Using Azure in production" : "Using GCP in non-production"
}
```

**Explanation:**  
This output will show a different message depending on the value of the `environment` variable.

For more details, see the [Terraform Conditionals documentation](https://developer.hashicorp.com/terraform/language/expressions/conditionals).


## Using Loops in Terraform

Terraform provides two main constructs for looping: `count` and `for_each`. These allow you to create multiple resources or assign multiple values dynamically, making your configurations more scalable and DRY (Don't Repeat Yourself).

### 1. Using `count` for Resource Creation

The `count` meta-argument lets you specify how many instances of a resource to create. This is useful when you want to create a fixed number of similar resources.

**Example: Creating Multiple Azure Virtual Machines**

```hcl
variable "vm_names" {
    description = "List of VM names"
    type        = list(string)
    default     = ["vm1", "vm2", "vm3"]
}

resource "azurerm_virtual_machine" "example" {
    count                 = length(var.vm_names)
    name                  = var.vm_names[count.index]
    resource_group_name   = "example-rg"
    location              = "eastus"
    network_interface_ids = [azurerm_network_interface.example[count.index].id]
    vm_size               = "Standard_DS1_v2"
    # ... other required arguments ...
}

resource "azurerm_network_interface" "example" {
    count               = length(var.vm_names)
    name                = "${var.vm_names[count.index]}-nic"
    location            = "eastus"
    resource_group_name = "example-rg"
    # ... other required arguments ...
}
```

**Explanation:**  
This example creates a virtual machine and a network interface for each name in the `vm_names` list. The `count.index` is used to reference the current index in the list.

---

### 2. Using `for_each` for Resource Creation

The `for_each` meta-argument allows you to create resources based on a map or set of strings, giving you more flexibility and direct access to keys.

**Example: Creating Multiple Google Cloud Subnets**

```hcl
variable "subnets" {
    description = "Map of subnet names to CIDR blocks"
    type        = map(string)
    default     = {
        "subnet-a" = "10.0.1.0/24"
        "subnet-b" = "10.0.2.0/24"
    }
}

resource "google_compute_subnetwork" "example" {
    for_each      = var.subnets
    name          = each.key
    ip_cidr_range = each.value
    region        = "us-central1"
    network       = "default"
}
```

**Explanation:**  
This example creates a subnet for each entry in the `subnets` map. The `each.key` is the subnet name, and `each.value` is the CIDR block.

---

### 3. Using `for` Expressions

Terraform's `for` expressions let you transform or filter lists and maps.

**Example: Generating a List of VM Names**

```hcl
variable "environments" {
    description = "List of environments"
    type        = list(string)
    default     = ["dev", "test", "prod"]
}

locals {
    vm_names = [for env in var.environments : "vm-${env}"]
}

output "generated_vm_names" {
    value = local.vm_names
}
```

**Explanation:**  
This `for` expression iterates over the `environments` list and generates a new list of VM names prefixed with "vm-". The output will be `["vm-dev", "vm-test", "vm-prod"]`.

---

For more details, see the [Terraform Meta-Arguments documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) and [for expressions](https://developer.hashicorp.com/terraform/language/expressions/for).

## Organizing Terraform Code for Enterprise Infrastructure

For enterprise-level infrastructure, it's important to organize your Terraform code for scalability, maintainability, and collaboration. A common structure separates resources, variables, and values into different files and directories.

### Recommended Directory Structure

```
terraform/
├── modules/
│   ├── azure_vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── gcp_network/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── providers.tf
├── variables.tf
└── terraform.tfvars
```

- **modules/**: Reusable resource definitions (e.g., Azure VM, GCP network).
- **environments/**: Environment-specific configurations and variable values.
- **providers.tf**: Provider configuration (Azure, GCP, etc.).
- **variables.tf**: Global variable definitions.
- **terraform.tfvars**: Default variable values.

---

### Example: Azure and Google Cloud Resource Code

#### `providers.tf`
```hcl
provider "azurerm" {
    features {}
}

provider "google" {
    project = var.gcp_project
    region  = var.gcp_region
}
```

#### `variables.tf`
```hcl
variable "azure_region" {
    description = "Azure region"
    type        = string
    default     = "eastus"
}

variable "gcp_project" {
    description = "GCP project ID"
    type        = string
}

variable "gcp_region" {
    description = "GCP region"
    type        = string
    default     = "us-central1"
}
```

#### `main.tf` (Resource Example)
```hcl
module "azure_vm" {
    source       = "../modules/azure_vm"
    vm_name      = "ent-vm"
    resource_group = "ent-rg"
    location     = var.azure_region
}

module "gcp_network" {
    source     = "../modules/gcp_network"
    network_name = "ent-network"
    region     = var.gcp_region
}
```

---

### Example Module: `modules/azure_vm/main.tf`
```hcl
resource "azurerm_virtual_machine" "this" {
    name                  = var.vm_name
    resource_group_name   = var.resource_group
    location              = var.location
    # ... other arguments ...
}
```
**`modules/azure_vm/variables.tf`**
```hcl
variable "vm_name" {}
variable "resource_group" {}
variable "location" {}
```

---

### Defining Variable Values in `.tfvars`

**`terraform.tfvars`**
```hcl
gcp_project = "your-gcp-project-id"
gcp_region  = "us-central1"
azure_region = "eastus"
```

---

This structure enables you to manage complex, multi-cloud infrastructure in a modular, reusable, and environment-specific way. For more details, see the [Terraform Recommended Practices](https://developer.hashicorp.com/terraform/docs/language/modules/develop/structure).

## Example: Creating a Virtual Network, Subnet, and VM on Azure

Below is a modular example for provisioning a Virtual Network (VNet), Subnet, and Virtual Machine (VM) on Azure using Terraform. This follows the recommended directory structure.

### Directory Structure

```
modules/
├── azure_vnet/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── azure_vm/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
environments/
└── dev/
    ├── main.tf
    ├── variables.tf
    └── terraform.tfvars
```

---

### Module: `modules/azure_vnet/main.tf`

```hcl
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_prefixes
}
```

**`modules/azure_vnet/variables.tf`**
```hcl
variable "vnet_name" {}
variable "address_space" { type = list(string) }
variable "location" {}
variable "resource_group" {}
variable "subnet_name" {}
variable "subnet_prefixes" { type = list(string) }
```

**`modules/azure_vnet/outputs.tf`**
```hcl
output "subnet_id" {
  value = azurerm_subnet.this.id
}
```

---

### Module: `modules/azure_vm/main.tf`

```hcl
resource "azurerm_network_interface" "this" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "this" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.this.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
```

**`modules/azure_vm/variables.tf`**
```hcl
variable "vm_name" {}
variable "location" {}
variable "resource_group" {}
variable "subnet_id" {}
variable "vm_size" { default = "Standard_DS1_v2" }
variable "admin_username" {}
variable "admin_password" {}
```

---

### Environment Example: `environments/dev/main.tf`

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group
  location = var.location
}

module "vnet" {
  source         = "../../modules/azure_vnet"
  vnet_name      = "dev-vnet"
  address_space  = ["10.0.0.0/16"]
  location       = var.location
  resource_group = azurerm_resource_group.this.name
  subnet_name    = "dev-subnet"
  subnet_prefixes = ["10.0.1.0/24"]
}

module "vm" {
  source         = "../../modules/azure_vm"
  vm_name        = "dev-vm"
  location       = var.location
  resource_group = azurerm_resource_group.this.name
  subnet_id      = module.vnet.subnet_id
  admin_username = var.admin_username
  admin_password = var.admin_password
}
```

**`environments/dev/variables.tf`**
```hcl
variable "resource_group" { default = "dev-rg" }
variable "location" { default = "eastus" }
variable "admin_username" {}
variable "admin_password" {}
```

**`environments/dev/terraform.tfvars`**
```hcl
admin_username = "azureuser"
admin_password = "P@ssw0rd1234!"
```

---

This setup creates a resource group, VNet, subnet, and a VM attached to the subnet in Azure. Adjust variable values as needed for your environment.

## Using Existing Azure Resources in Terraform

Terraform can reference and use existing resources in your Azure environment by using the `data` block. This allows you to fetch attributes of resources that were not created by Terraform, and use their values in your configuration.

### Example: Referencing an Existing Resource Group and Virtual Network

Suppose you have an existing Azure Resource Group and Virtual Network. You can use data sources to fetch their details and use them as inputs for new resources.

**modules/azure_vm/main.tf**
```hcl
resource "azurerm_network_interface" "this" {
    name                = "${var.vm_name}-nic"
    location            = var.location
    resource_group_name = data.azurerm_resource_group.existing.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = data.azurerm_subnet.existing.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "this" {
    name                  = var.vm_name
    location              = var.location
    resource_group_name   = data.azurerm_resource_group.existing.name
    network_interface_ids = [azurerm_network_interface.this.id]
    vm_size               = var.vm_size
    # ... other arguments ...
}
```

**environments/dev/main.tf**
```hcl
provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "existing" {
    name = var.existing_resource_group_name
}

data "azurerm_virtual_network" "existing" {
    name                = var.existing_vnet_name
    resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "existing" {
    name                 = var.existing_subnet_name
    virtual_network_name = data.azurerm_virtual_network.existing.name
    resource_group_name  = data.azurerm_resource_group.existing.name
}

module "vm" {
    source         = "../../modules/azure_vm"
    vm_name        = "dev-vm"
    location       = data.azurerm_resource_group.existing.location
    admin_username = var.admin_username
    admin_password = var.admin_password
}
```

**environments/dev/variables.tf**
```hcl
variable "existing_resource_group_name" {}
variable "existing_vnet_name" {}
variable "existing_subnet_name" {}
variable "admin_username" {}
variable "admin_password" {}
```

**environments/dev/terraform.tfvars**
```hcl
existing_resource_group_name = "shared-rg"
existing_vnet_name          = "shared-vnet"
existing_subnet_name        = "shared-subnet"
admin_username              = "azureuser"
admin_password              = "P@ssw0rd1234!"
```

---

### Explanation

- The `data` blocks fetch details about existing Azure resources (resource group, virtual network, subnet).
- These values are then used as inputs for new resources, such as network interfaces and virtual machines.
- This approach allows you to integrate Terraform-managed resources with infrastructure that already exists, without recreating or modifying the existing resources.
- Organizing code into modules and environment-specific directories keeps your configuration clean, reusable, and easy to manage.

For more details, see the [Terraform Azure Data Sources documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/).


## Terraform Provisioners

Provisioners in Terraform allow you to execute scripts or commands on a local or remote machine as part of the resource creation or destruction process. They are typically used for bootstrapping, configuration management, or performing tasks that cannot be accomplished through resource arguments alone.

### Types of Provisioners

- **`local-exec`**: Executes a command on the machine running Terraform.
- **`remote-exec`**: Executes commands on the remote resource after it's created (e.g., a VM).
- **File Provisioner**: Uploads files from the local machine to the remote resource.

> **Note:** Provisioners should be used as a last resort. Prefer native resource arguments or configuration management tools (like Ansible, Chef, or Puppet) when possible.

---

### Example: Using `remote-exec` and `file` Provisioners with Azure VM

```hcl
resource "azurerm_virtual_machine" "example" {
    name                  = "example-vm"
    location              = azurerm_resource_group.example.location
    resource_group_name   = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.example.id]
    vm_size               = "Standard_DS1_v2"
    # ... other arguments ...

    os_profile {
        computer_name  = "examplevm"
        admin_username = "azureuser"
        admin_password = "P@ssw0rd1234!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    provisioner "file" {
        source      = "scripts/setup.sh"
        destination = "/tmp/setup.sh"
        connection {
            type     = "ssh"
            user     = "azureuser"
            password = "P@ssw0rd1234!"
            host     = self.public_ip_address
        }
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/setup.sh",
            "sudo /tmp/setup.sh"
        ]
        connection {
            type     = "ssh"
            user     = "azureuser"
            password = "P@ssw0rd1234!"
            host     = self.public_ip_address
        }
    }
}
```

#### Explanation

- The **file provisioner** uploads a local script (`setup.sh`) to the VM's `/tmp` directory.
- The **remote-exec provisioner** runs commands on the VM: it makes the script executable and then executes it.
- The `connection` block specifies how Terraform connects to the VM (using SSH in this example).

---

### Example: Using `local-exec` Provisioner

```hcl
resource "azurerm_resource_group" "example" {
    name     = "example-rg"
    location = "eastus"

    provisioner "local-exec" {
        command = "echo Resource group ${self.name} created in ${self.location}"
    }
}
```

#### Explanation

- The **local-exec provisioner** runs a command on the machine where Terraform is executed (not on the remote resource).
- In this example, it simply echoes a message after the resource group is created.

---

### When to Use Provisioners

- Bootstrapping a server with a script after creation.
- Copying configuration files to a VM.
- Running ad-hoc commands that cannot be modeled as Terraform resources.

**Best Practice:**  
Use provisioners sparingly. If you find yourself using them frequently, consider using configuration management tools or extending your Terraform provider's capabilities.

For more details, see the [Terraform Provisioners documentation](https://developer.hashicorp.com/terraform/language/resources/provisioners).

## Advanced Terraform Commands

Beyond the basic workflow, Terraform provides several advanced commands for state management, resource targeting, debugging, and more. These commands help with troubleshooting, refactoring, and maintaining infrastructure at scale.

### 1. `terraform taint`
Marks a resource as tainted, forcing it to be destroyed and recreated on the next `terraform apply`. Useful when a resource is in a bad state.

```sh
terraform taint <resource_address>
```
*Example:*  
`terraform taint azurerm_virtual_machine.example`

---

### 2. `terraform import`
Brings existing infrastructure under Terraform management by importing resources into the state file.

```sh
terraform import <resource_address> <resource_id>
```
*Example:*  
`terraform import azurerm_resource_group.example /subscriptions/0000/resourceGroups/my-rg`

---

### 3. `terraform state`
Manages the Terraform state file directly. You can list, move, remove, or pull state information.

- List resources:  
    `terraform state list`
- Show resource details:  
    `terraform state show <resource_address>`
- Remove a resource:  
    `terraform state rm <resource_address>`
- Move a resource:  
    `terraform state mv <source> <destination>`

---

### 4. `terraform output`
Displays the values of outputs defined in your configuration. Useful for retrieving information after apply.

```sh
terraform output
terraform output <output_name>
```

---

### 5. `terraform refresh`
Updates the state file with the real infrastructure state, detecting any drift between configuration and actual resources.

```sh
terraform refresh
```

---

### 6. `terraform graph`
Generates a visual graph of Terraform resources and their dependencies in DOT format.

```sh
terraform graph | dot -Tpng > graph.png
```

---

### 7. `terraform workspace`
Manages multiple workspaces (isolated state environments) within a single configuration, useful for managing different environments (dev, prod, etc.).

- List workspaces:  
    `terraform workspace list`
- Create a workspace:  
    `terraform workspace new <name>`
- Switch workspace:  
    `terraform workspace select <name>`

---

### 8. `terraform providers`
Shows information about the providers required by the configuration and their versions.

```sh
terraform providers
```

---

### 9. `terraform validate`
Checks whether the configuration is syntactically valid and internally consistent.

```sh
terraform validate
```

---

### 10. `terraform fmt`
Automatically formats Terraform configuration files to a canonical style.

```sh
terraform fmt
```

---

These advanced commands help you manage complex infrastructure, troubleshoot issues, and maintain clean, consistent Terraform code. For more details, see the [Terraform CLI documentation](https://developer.hashicorp.com/terraform/cli/commands).
