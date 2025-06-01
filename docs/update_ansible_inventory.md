# Updating Ansible Inventory from Terraform Output

This document explains how to update the `ansible/inventory.txt` file using the IP address output from the Terraform configuration for `gcp-vm1`.

## Background

The Terraform configuration in `terraform/gcp_compute.tf` now includes an output named `gcp_vm1_ip`:

```terraform
output "gcp_vm1_ip" {
  description = "The private IP address of GCP VM1"
  value       = google_compute_instance.gcp-vm1.network_interface[0].network_ip
}
```

This output provides the private IP address of the `gcp-vm1` instance after it has been provisioned by Terraform. The Ansible inventory file (`ansible/inventory.txt`) needs to use this IP address to correctly target `gcp-vm1` for configuration and deployment.

There are two main ways to update the Ansible inventory: manually and via an automated approach.

## 1. Querying the Terraform Output

After you have successfully run `terraform apply` and the infrastructure is provisioned, you can query the output value for `gcp-vm1_ip` using the following Terraform command in the `terraform/` directory:

```bash
terraform output gcp_vm1_ip
```

This command will print the IP address of `gcp-vm1` to the console. For example:

```
10.128.0.9
```
*(The actual IP address may vary based on your Terraform configuration or runtime variables.)*

## 2. Manual Method to Update `ansible/inventory.txt`

This method is suitable for simple setups or when you prefer manual control.

1.  **Navigate to the Terraform directory**:
    ```bash
    cd path/to/your/repository/terraform
    ```

2.  **Query the IP address**: Run the command:
    ```bash
    terraform output gcp_vm1_ip
    ```
    Note down the IP address displayed.

3.  **Edit the Ansible inventory file**:
    Open `ansible/inventory.txt` in a text editor. The file will look something like this:
    ```ini
    db_and_webserver1 ansible_host=OLD_IP_ADDRESS
    ```
    Replace `OLD_IP_ADDRESS` with the new IP address you obtained from the `terraform output` command. For example, if the output was `10.128.0.9`, the updated line should be:
    ```ini
    db_and_webserver1 ansible_host=10.128.0.9
    ```

4.  **Save the `inventory.txt` file.**

Your Ansible playbook will now target the correct IP address for `gcp-vm1`.

## 3. Automated Approach (Conceptual)

For more advanced, repeatable, or CI/CD workflows, you can automate the process of updating the Ansible inventory. Here's a conceptual outline:

A script (e.g., Bash, Python) could be created to perform the following steps:

1.  **Run `terraform output` in JSON format**:
    It's often easier to parse JSON output. You can get all outputs in JSON format or a specific one:
    ```bash
    terraform output -json
    ```
    Or, for a specific output (though the `-json` flag with a specific output name might vary by Terraform version, getting all outputs and then parsing is common):
    ```bash
    # Get all outputs and parse with jq
    terraform output -json | jq -r .gcp_vm1_ip.value
    ```
    Alternatively, you can parse the plain string output of `terraform output gcp_vm1_ip`.

2.  **Parse the output**:
    Extract the IP address value from the JSON or string output. Tools like `jq` (for JSON) or string manipulation functions in your scripting language can be used.

3.  **Generate or Update `inventory.txt`**:
    *   **Templating**: Use a templating engine (like Jinja2 if using Python) to generate the `inventory.txt` file from a template, injecting the queried IP address.
    *   **String Manipulation/File I/O**: Read the existing `inventory.txt`, replace the relevant line using string replacement (e.g., `sed`, or Python's file I/O and string methods), and write the changes back.
    *   **Ansible Dynamic Inventory**: For a fully integrated solution, you could develop an Ansible dynamic inventory script. This script would be executed by Ansible at runtime, query Terraform outputs (or directly query GCP for resource information), and provide the inventory to Ansible on-the-fly.

**Example (Conceptual Bash using `sed` after `terraform output`):**

```bash
# (In the terraform directory)
NEW_IP=$(terraform output gcp_vm1_ip)

# Ensure NEW_IP is not empty and looks like an IP (basic check)
if [[ -n "$NEW_IP" && "$NEW_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  # (Adjust path to inventory.txt as needed)
  sed -i "s/db_and_webserver1 ansible_host=.*/db_and_webserver1 ansible_host=$NEW_IP/" ../ansible/inventory.txt
  echo "Ansible inventory updated with IP: $NEW_IP"
else
  echo "Failed to get a valid IP address from Terraform output."
fi
```

This automated approach reduces the chance of manual errors and is highly recommended for production or frequently changing environments.
