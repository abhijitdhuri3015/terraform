# terraform

**What is Terraform?**

Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. This includes low-level components like compute instances, storage, and networking; and high-level components like DNS entries and SaaS features.

Terraform plugins called providers let Terraform interact with cloud platforms and other services via their application programming interfaces (APIs).

Find providers for many of the platforms and services you already use in the Terraform Registry. 

<img width="846" height="432" alt="image" src="https://github.com/user-attachments/assets/8350a034-3b18-4348-b6ff-fd3b9b7041c6" />

**Terraform Commands:**
1. terraform init: Initializes a Terraform working directory by downloading necessary provider plugins and setting up the backend.
2. terraform plan: Creates an execution plan, showing what actions Terraform will take to achieve the   desired state defined in the configuration files.
3. terraform apply: Applies the changes required to reach the desired state of the configuration. It    executes the actions proposed in the terraform plan.
4. terraform destroy: Destroys all the infrastructure managed by the current configuration, effectively tearing down the environment.
5. terraform fmt: Automatically formats Terraform configuration files to a canonical format and style.
6. terraform validate: Validates the syntax and internal consistency of Terraform configuration files without accessing any remote services.
7. terraform show: Provides a human-readable output of the current state or a plan file,
8. terraform state: Manages the Terraform state file, allowing you to view, modify, or remove resources from the state.
9. terraform import: Imports existing infrastructure into Terraform state, allowing you to manage it with Terraform going forward.
10. terraform output: Extracts the value of an output variable from the state file, useful
    for passing information between modules or to external systems.
11. terraform graph: Generates a visual representation of the resource dependencies in the configuration, which can be used for understanding and debugging complex configurations. 
12. terraform workspace: Manages multiple workspaces, allowing you to have different states for different environments (e.g., dev, staging, prod) within the same configuration.
13. terraform login: Authenticates Terraform with a remote service, such as Terraform Cloud, to enable features like remote state management and collaboration.
14. terraform logout: Logs out of a remote service, revoking any authentication tokens and preventing further interactions with that service until you log in again. 
15. terraform version: Displays the current version of Terraform installed on your system, along with any installed provider versions.
16. terraform providers: Lists the providers required by the current configuration, along with their versions and source information.
17. terraform workspace list: Lists all available workspaces in the current Terraform configuration, showing which one is currently active.
18. terraform workspace new <name>: Creates a new workspace with the specified name.
19. terraform workspace select <name>: Switches to the specified workspace, allowing you to work with a different state.
20. terraform workspace delete <name>: Deletes the specified workspace, removing its associated state file. 
21. terraform workspace show: Displays the name of the currently active workspace.

📝 Core Terraform Commands
1. The Core Lifecycle Workflow (The "Big Four")
    terraform init
    What it does: Prepares your working directory. Downloads provider plugins (like AWS, Azure), sets up module paths, and initializes the backend state storage.
    Interview Insight: Safe to run multiple times (idempotent). You must run it again if you change backend configurations or add new providers.

    terraform plan
    What it does: Reads the current state, compares it against your code, and generates an execution plan showing what it will create (+), update (~), or destroy (-). It does not make any real-world changes.
    CI/CD Best Practice: In a pipeline, always use terraform plan -out=tfplan. This saves the plan to a file, ensuring that the subsequent apply step executes exactly what was approved, with zero race conditions.

    terraform apply
    What it does: Executes the actions proposed in the plan to reach the desired state.
    Key Flags: Use terraform apply -auto-approve in non-interactive CI/CD pipelines to bypass the manual "yes" confirmation prompt.

    terraform destroy
    What it does: Removes all infrastructure managed by the current configuration.
    Interview Warning: It is structurally equivalent to running terraform apply with an empty configuration. Never run this in production without absolute certainty.

2. Code Quality & Formatting
    terraform fmt
    What it does: Automatically rewrites Terraform configuration files to follow canonical HCL style conventions (spacing, alignment, etc.).
    CI/CD Best Practice: Run terraform fmt -check in your pull request pipelines. It won't modify the files but will exit with an error code if anyone submits poorly formatted code.

    terraform validate
    What it does: Checks whether the configuration is syntactically valid and internally consistent (e.g., checks attribute names, type mismatches).
    Interview Note: It runs locally and does not look at existing state or talk to cloud provider APIs. Run it after init but before plan.

3. State Management (The "Senior Engineer" Commands)
    Knowledge on state modification, as these commands directly manipulate your single source of truth.

    terraform refresh
    What it does: Queries the real-world cloud provider to update the local state file with any changes that happened outside of Terraform (drift).
    Interview Note: Note that terraform plan automatically runs a refresh under the hood first, so running a standalone refresh is rarely necessary anymore.

    terraform target (The -target Flag)
    What it does: Used with plan/apply to isolate changes to one specific resource: terraform apply -target=aws_instance.web.
    Interview Warning: Call this an exceptional tool/last resort. Using -target can break dependencies and leave your state file in an inconsistent tracking state.

    terraform import
    What it does: Brings an existing, manually created cloud resource under Terraform management.
    How it works: You write a blank resource block in your code, then run terraform import aws_instance.web i-1234567890abcdef0. This pulls the real asset data into your state file, but you must manually update your .tf file to match it.

    terraform state (Subcommands)
    terraform state list: Lists all resources currently tracked in the state file.

    terraform state rm: Removes a resource from the state file without destroying it in the real world (useful if you want to stop tracking something or move it to a different module).

    terraform state mv: Renames or moves a resource within your state file without forcing a destroy/recreate cycle in the cloud.

💡 Top 3 "Gotchas" to Remember
    1. Plan Outdatedness: A terraform plan is just a snapshot in time. If someone changes an EC2 instance manually right after your plan completes, your saved plan file doesn't know about it until the apply phase checks again.
    2. Locking: When you run commands that change state (apply, destroy), Terraform automatically locks the state backend (e.g., via DynamoDB for S3). If a pipeline crashes mid-run, the lock might get stuck, requiring terraform force-unlock <LOCK_ID>.
    3. The validate vs plan difference: validate only checks if your HCL syntax and references are valid. It cannot tell you if an AMI ID is wrong or if you lack AWS permissions; only plan and apply talk to the cloud APIs to verify those.

**Folder Structure:**
basic: Contains one ec2instance.tf file with a single resource defined.

**Variables**
===============
Variables serve as parameters for Terraform modules, acting exactly like function arguments in a programming language. 
They allow you to write dynamic, reusable configurations without hardcoding values.

Key Advanced Parameters:
1. sensitive: Keeps values out of the terminal output during plans and applies. Gotcha: It is still saved in plain text in the .tfstate file!  
2. validation: Allows custom business logic checks. You use a boolean condition expression and provide a clear error_message. If it fails, terraform plan stops immediately.  
3. optional() Modifier: Allows certain attributes inside complex structural objects to be completely omitted by the caller without breaking the code.  

🗂️ Type Constraints Cheat Sheet
Primitive versus complex data types:
1. string, number, bool : Primitives. The absolute core building blocks.
2. list(<type>) : Collection. Ordered sequence of elements. Accessed by index (var.list[0]). Duplicates allowed.
3. set(<type>) : Collection. Unordered, unique elements. Duplicates are automatically removed. Cannot index into a set.
4. map(<type>) : Collection. Key-value lookup table where keys must be strings. Useful for lookup configurations.
5. object({ ... }) : Structural. Complex custom schema where every key can have a different data type. Best practice for complex module arguments.

Here is the strict order of precedence (highest to lowest):
-----------------------------------------------------------
    1.  -var or -var-file flags passed explicitly in the command line (e.g., terraform apply -var="env=prod").
    2.  *.auto.tfvars or *.auto.tfvars.json files (loaded in alphabetical order).
    3.  terraform.tfvars.json file.
    4.  terraform.tfvars file.
    5.  Environment Variables prefixed with TF_VAR_ (e.g., export TF_VAR_region="us-east-1").
    6.  default value specified inside the variable block itself.

💡 Top 3 "Gotchas" to Remember
    1. State Vulnerability: Marking a variable as sensitive = true only masks CLI output. Anyone with access to your backend S3 bucket or state file can read the variable in clear, raw text.
    2. Variable vs. Local: Variables are input arguments meant to be passed in by users or automation. Locals are internal private constants meant to prevent code repetition (DRY concept) and cannot be overridden from the outside.  
    3. No Dynamic Logic in Defaults: The default parameter of a variable block can only accept literal constant values. You cannot reference other variables, resources, or functions inside a variable's default assignment.

Variables folder: Contains a variables.tf file with multiple variable blocks demonstrating different types and validation rules.

**Provisioners**
===============
Provisioners are used to execute scripts or file transfers on a local machine or a remote resource (like an EC2 instance) during the creation or destruction phase of that resource

⚠️ Crucial Point: Always note that HashiCorp considers provisioners a last resort. 
Because they break Terraform's declarative model (Terraform cannot track the internal state of what the script actually did), 
you should always prefer cloud-init (user_data in AWS), custom AMIs (Packer), or configuration management tools (Ansible/Chef) first.

The Big Three Provisioners
1. file Provisioner
    Purpose: Copies files or directories from your local machine to the newly created remote resource.
    Requires: A connection block (SSH or WinRM).
    Key Attributes: source (local path) and destination (absolute remote path).

2. remote-exec Provisioner
    Purpose: Invokes scripts or commands directly on the remote resource after it is created.
    Requires: A connection block.
    Key Attributes: inline (list of command strings) or script/scripts (paths to local files to be executed remotely).

3. local-exec Provisioner
    Purpose: Invokes a local command or script on the machine running the terraform apply command (your laptop or CI/CD runner).
    Requires: Nothing extra (does not need a connection block).
    Key Attributes: command (the execution string) and optionally interpreter (e.g., ["PowerShell", "-Command"] or ["/bin/bash", "-c"]).

Null Resources / Terraform Data
--------------------------------
If you need to run a provisioner that isn't tied to a specific piece of infrastructure (e.g., just running a local database migration script), 
you use a null_resource or terraform_data resource combined with a provisioner.

Creation-Time vs. Destruction-Time
----------------------------------
Creation-Time (Default): Runs only when a resource is being created. If it fails, Terraform marks the resource as tainted (tainted resources are destroyed and recreated on the next apply).
Destruction-Time: Runs before a resource is destroyed. Defined by setting when = destroy. (Great for gracefully deregistering a node from a cluster before killing it).

By default, if a provisioner fails, terraform apply fails. You can change this behavior using the on_failure setting:
    on_failure = fail: (Default) Error out and taint the resource.
    on_failure = continue: Ignore the error and carry on with the deployment.

💡 Top 3 "Gotchas" to Remember
        Network Access: A remote-exec provisioner will fail if the machine running Terraform doesn't have direct network access (like a public IP or VPN) to the target machine on port 22/5985.
        No Idempotency: Provisioners do not run on subsequent terraform apply commands unless the resource itself is being replaced or triggered by a change in triggers.
        Tainting: If a provisioner fails halfway through, Terraform considers the resource "dirty" or tainted. The next run will completely recreate that resource from scratch.

Provisioners folder: Contains a ec2instance.tf file with a single resource defined and a provisioner block to run a script on the instance after it is created.
Generate the SSH Key Pair : ssh-keygen -t rsa -b 4096 -f .\keyfiles\practice_key
