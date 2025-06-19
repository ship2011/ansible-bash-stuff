# What is Ansible?

**Ansible** is an open-source automation tool used for configuration management, application deployment, and task automation. It allows you to define infrastructure as code using simple, human-readable YAML files. Ansible operates agentlessly, connecting to remote systems over SSH, making it easy to manage servers and automate IT processes efficiently.

## How to Install Ansible on Red Hat and Debian Based Linux

> Note: These instructions assume your repositories already include the Ansible package.

### On Red Hat Based Systems (RHEL, CentOS, Fedora)

1. **Install Ansible:**
    ```bash
    sudo yum install ansible
    ```

2. **Verify installation:**
    ```bash
    ansible --version
    ```

### On Debian Based Systems (Ubuntu, Debian)

1. **Install Ansible:**
    ```bash
    sudo apt install ansible
    ```

2. **Verify installation:**
    ```bash
    ansible --version
    ```

### Next Steps

- Configure your inventory file (usually `/etc/ansible/hosts`) or use a local inventory file in your Ansible project directory (e.g., `./ANSIBLE-PROJECT/hosts`).
- Test connectivity to your managed nodes using:
  ```bash
  ansible all -m ping
  ```
- Give your inventory path during execution
  ```bash
  ansible -i ./ANSIBLE-PROJECT/hosts all -m ping
  ```
## Ansible Ad-hoc Commands

Ad-hoc commands are simple one-line commands used to perform quick tasks without writing a playbook. They are useful for tasks like checking connectivity, copying files, managing packages, running shell commands, and more.
In the examples below, it is assumed that you have already set up SSH keys for passwordless connection. If you do not want to use passwordless connection, you can add the `-k` and `-b` parameters at the end of the ad-hoc command; this will prompt you for the connection user's password.
- `-k`: Ask for the SSH connection password (for the user used to establish the connection)
- `-b`: Become the sudo user (use this to execute commands as a sudo user)
- `-K`: when running a playbook or ad-hoc command to prompt for the privilege escalation password (usually the sudo password).
- `-u`:  the -u parameter is used to specify the remote user that Ansible should use to connect to the managed hosts.
**Examples:**

- **Ping all hosts:**
    ```bash
    ansible all -m ping
    ```

- **Check disk space on all hosts:**
    ```bash
    ansible all -m shell -a "df -h" -k
    ansible all -m shell -a "systemctl stop firewalld" -u testuser -k -K -b
    ```

- **Install a package (e.g., httpd) on all hosts:**
    ```bash
    ansible all -m yum -a "name=httpd state=present" -k -b
    ```

- **Copy a file to all hosts:**
    ```bash
    ansible all -m copy -a "src=/tmp/file.txt dest=/tmp/file.txt" -k
    ```

- **Restart a service (e.g., nginx) on all hosts:**
    ```bash
    ansible all -m service -a "name=httpd state=restarted" -k -b
    ```
Replace `all` with a specific group or host as needed.

## What is an Ansible Playbook?

An **Ansible Playbook** is a YAML file that defines a series of tasks to be executed on managed hosts. Playbooks allow you to automate complex workflows, such as configuring servers, deploying applications, and orchestrating multi-step processes. Each playbook consists of one or more "plays," where each play targets a group of hosts and specifies the tasks to run.

Playbooks are more powerful and reusable than ad-hoc commands, making them ideal for automating repetitive tasks and maintaining infrastructure as code.

**Example of a simple playbook:**

```yaml
- name: Install and start httpd service
    hosts: web
    become: yes
    tasks:
        - name: Install httpd
          apt:
            name: httpd
            state: present

        - name: start httpd service
          service:
             name: httpd
             state: started
```

You can run a playbook using:

```bash
ansible-playbook playbook.yml
```
## Ansible Variable Types

Ansible supports several types of variables that help you customize playbooks and roles for different environments and hosts. Here are the main types, each with a short example:

- **Inventory variables:** Defined in the inventory file for hosts or groups.
    - *Example (in `hosts` file):*
      ```
      [web]
      server1 ansible_user=ubuntu http_port=8080
      ```

- **Playbook variables:** Defined directly in playbooks using the `vars` section.
    - *Example:*
      ```yaml
      - hosts: web
        vars:
          app_env: production
        tasks:
          - debug:
              msg: "Environment is {{ app_env }}"
      ```

- **Host variables:** Specific to a single host, usually defined in `host_vars/hostname`.
    - *Example (in `host_vars/server1.yml`):*
      ```yaml
      db_user: admin
      ```

- **Group variables:** Apply to all hosts in a group, defined in `group_vars/groupname`.
    - *Example (in `group_vars/web.yml`):*
      ```yaml
      max_clients: 200
      ```

- **Facts:** Automatically gathered information about hosts (e.g., OS, IP address).
    - *Example (using a fact in a task):*
      ```yaml
      - debug:
          msg: "The OS is {{ ansible_distribution }}"
      ```

- **Registered variables:** Store the output of a task for use in later tasks.
    - *Example:*
      ```yaml
      - shell: uptime
        register: uptime_result
      - debug:
          msg: "Uptime is {{ uptime_result.stdout }}"
      ```

- **Extra variables:** Passed at runtime using the `-e` flag.
    - *Example (command line):*
      ```bash
      ansible-playbook playbook.yml -e "version=2.0"
      ```
    - *Usage in playbook:*
      ```yaml
      - debug:
          msg: "Version is {{ version }}"
      ```
You can use variables in your tasks and templates by referencing them with double curly braces, like `{{ variable_name }}`.

## Importing Variable Files in a Playbook

You can import variables from external YAML files using the `vars_files` directive in your playbook. This helps to keep your playbooks clean and allows you to reuse variable definitions.

**Example:**

Suppose you have a variable file named `vars.yml`:

```yaml
# vars.yml
app_port: 8080
app_debug: true
```

You can include it in your playbook like this:

```yaml
- hosts: web
    vars_files:
        - vars.yml
    tasks:
        - debug:
            msg: "App will run on port {{ app_port }} with debug={{ app_debug }}"
```

## Ansible Variable Data Types

Ansible variables can hold different data types, which determine how values are stored and used in playbooks. The main data types are:

- **String:** A sequence of characters.
    - *Example:*
      ```yaml
      app_name: "myapp"
      ```
    multiline strings (|) preserving newline
      ```yaml
         multi_line_str_with_newline: |   
                   user name test
                   group name testing
                   no sudo access given to user
      ```
     multiline strings (>) that convert newline to spaces
     ```yaml
         multi_line_str_with_newline: >   
                   user name test
                   group name testing
                   no sudo access given to user
      ```

- **Integer:** Numeric values without quotes.
    - *Example:*
      ```yaml
      max_connections: 100
      ```

- **Boolean:** True or false values (`true`/`false` or `yes`/`no`).
    - *Example:*
      ```yaml
      debug_mode: true
      ```

- **List (Array):** An ordered collection of items.
    - *Example:*
      ```yaml
      packages:
        - nginx
        - git
        - curl
      ```

- **Dictionary (Hash/Map):** Key-value pairs.
    - *Example:*
      ```yaml
      db_config:
        host: localhost
        port: 5432
        user: admin
      ```

You can use these data types to structure your variables for simple or complex configurations in your Ansible projects.

## Useful Ansible Modules

Ansible provides a wide range of built-in modules to automate various tasks. Here are some commonly used modules with brief descriptions:

- **ping:** Checks connectivity to hosts.
    ```bash
    ansible all -m ping
    ```

- **shell / command:** Executes shell commands on remote hosts.
    ```bash
    ansible all -m shell -a "uptime"
    ```

- **copy:** Copies files from the control machine to remote hosts.
    ```bash
    ansible all -m copy -a "src=/tmp/file.txt dest=/tmp/file.txt"
    ```

- **file:** Manages file properties (permissions, ownership, etc.).
    ```yaml
    - name: Ensure a directory exists
      file:
        path: /tmp/mydir
        state: directory
        mode: '0755'
    ```

- **yum / apt:** Installs or removes packages using the system package manager.
    ```yaml
    - name: Install nginx on Red Hat
      yum:
        name: nginx
        state: present
    - name: Install nginx on Debian
      apt:
        name: nginx
        state: present
    ```

- **service:** Manages services (start, stop, restart).
    ```yaml
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
    ```

- **user:** Manages user accounts.
    ```yaml
    - name: Create a user
      user:
        name: johndoe
        state: present
    ```

- **git:** Clones or updates repositories from Git.
    ```yaml
    - name: Clone a repository
      git:
        repo: 'https://github.com/example/repo.git'
        dest: /opt/repo
    ```

- **template:** Renders Jinja2 templates and transfers them to hosts.
    ```yaml
    - name: Deploy a configuration file from template
      template:
        src: config.j2
        dest: /etc/myapp/config.conf
    ```

- **lineinfile:** Ensures a particular line is present (or absent) in a file.
    ```yaml
    - name: Ensure a line exists in /etc/myapp/config.conf
      lineinfile:
        path: /etc/myapp/config.conf
        line: 'ENABLE_FEATURE=true'
    ```
    *Regular expression example:*
    ```yaml
    - name: Update the port number using regex
      lineinfile:
        path: /etc/myapp/config.conf
        regexp: '^port='
        line: 'port=9090'
    ```

- **blockinfile:** Inserts, updates, or removes a block of lines in a file.
    ```yaml
    - name: Insert a block of configuration into /etc/myapp/config.conf
      blockinfile:
        path: /etc/myapp/config.conf
        block: |
          [myapp]
          debug=true
          port=8080
    ```
    *Regular expression example:*
    ```yaml
    - name: Replace a configuration block using regex marker
      blockinfile:
        path: /etc/myapp/config.conf
        marker: "# {mark} ANSIBLE MANAGED BLOCK"
        block: |
          [myapp]
          debug=false
          port=9090
        insertafter: '^# Application settings'
    ```

- **replace:** Replaces all instances of a pattern in a file using regular expressions.
    ```yaml
    - name: Replace all occurrences of 8080 with 9090 in config file
      replace:
        path: /etc/myapp/config.conf
        regexp: '8080'
        replace: '9090'
    ```

- **synchronize:** Efficiently synchronizes files and directories between the control machine and remote hosts (uses `rsync`).
    ```yaml
    - name: Synchronize local directory to remote server
      synchronize:
        src: /home/user/app/
        dest: /var/www/app/
        recursive: yes
    ```

Explore the [Ansible documentation](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html) for a full list of modules and their usage.


## Ansible Logic and Loops

Ansible provides mechanisms for adding logic and iterating over items in your playbooks, making automation more flexible and powerful.

### Conditionals

You can use the `when` keyword to run tasks only when certain conditions are met.

**Example:**

```yaml
- name: Install Apache only on RedHat systems
  yum:
    name: httpd
    state: present
  when: ansible_os_family == "RedHat"
```

You can also use logical operators :

```yaml
when: ansible_os_family == "RedHat" and httpd_enabled
when: ansible_os_family == "RedHat" or ansible_os_family == CentOs
```

### Loops

Loops allow you to repeat a task for multiple items. The most common way is using the `loop` keyword for loops.

**Example: Install multiple packages with list**

```yaml
- name: Install a list of packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl
```

**With dictionaries:**

```yaml
- name: Create multiple users
  user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.group }}"
  loop:
    - { name: 'alice', group: 'admin' }
    - { name: 'bob', group: 'users' }
```

### Loop Control

You can use `loop_control` to customize loop behavior, such as setting a label and changing loop variable name for output.
Common loop_control
label	Changes the label shown in task output per iteration (usually item)
loop_var	Rename the default item variable to something else
pause	Adds a pause in seconds between loop iterations

```yaml
- name: Print each user
  debug:
      msg: "User is {{ user }}"
  loop:
    - alice
    - bob
  loop_control:
     label: "{{ user }}"
     loop_var: user
    ```

### Combining Loops and Conditionals

You can use `when` inside a loop to apply conditions per item.

```yaml
- name: Install only selected packages
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - apache2
  when: item != "apache2"
```

For more details, see the [Ansible documentation on conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html) and [loops](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html).


## Block and Error Handling in Ansible

Ansible provides the `block` directive to group related tasks together. This is useful for organizing playbooks and for applying common directives (like `when`, `become`, or `tags`) to multiple tasks at once.

### Using Blocks

**Example:**

```yaml
- name: Example block usage
  hosts: all
  tasks:
    - block:
        - name: Install nginx
          apt:
            name: nginx
            state: present

        - name: Start nginx
          service:
            name: nginx
            state: started
      become: yes
      when: ansible_os_family == "Debian"
```

### Error Handling with `rescue` and `always`

Blocks can include `rescue` and `always` sections for error handling, similar to try/except/finally in programming.

- **`block`:** Main tasks to try.
- **`rescue`:** Tasks to run if any task in the block fails.
- **`always`:** Tasks to run regardless of success or failure.

**Example:**

```yaml
- name: Block with error handling
  hosts: all
  tasks:
    - block:
        - name: Try to copy a file
          copy:
            src: /tmp/source.txt
            dest: /tmp/dest.txt
      rescue:
        - name: Handle failure
          debug:
            msg: "Copy failed, handling error."
      always:
        - name: Always run this task
          debug:
            msg: "This runs no matter what."
```

### Ignoring Errors with `ignore_errors`

You can use `ignore_errors: yes` to continue playbook execution even if a task fails. This is useful when a failure is non-critical.

**Example:**

```yaml
- name: Try to remove a file (ignore errors if it doesn't exist)
  file:
    path: /tmp/nonexistent.txt
    state: absent
  ignore_errors: yes
```

### Failing a Task Conditionally with `failed_when`

Use `failed_when` to mark a task as failed based on a custom condition, even if the task itself does not return an error.

**Example:**

```yaml
- name: Run a command and fail if output contains 'error'
  shell: cat /var/log/app.log
  register: log_output
  failed_when: "'error' in log_output.stdout"
```
## Using `changed_when` in Ansible

The `changed_when` directive allows you to control when a task is marked as "changed" based on custom conditions. This is useful when a module's default changed status does not accurately reflect whether a change occurred.

**Example: Mark a task as changed only if output contains "updated"**

```yaml
- name: Run a command and mark changed only if output contains 'updated'
  shell: some_command
  register: cmd_result
  changed_when: "'updated' in cmd_result.stdout"
```

**Example: Mark a task as unchanged regardless of module output**

```yaml
- name: Run a command but never mark as changed
  shell: some_command
  changed_when: false
```

**Example: Mark as changed if a file was actually modified**

```yaml
- name: Replace a line in a file
  lineinfile:
    path: /etc/myapp/config.conf
    regexp: '^option='
    line: 'option=enabled'
  register: line_result
  changed_when: line_result.changed
```

Use `changed_when` to ensure Ansible reports changes accurately in your playbook runs.

For more, see the [Ansible documentation on changed_when](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html#overriding-changed-and-failed-results).

## Failing the Entire Playbook with `any_errors_fatal`

If you want your playbook to stop execution on all hosts as soon as any host encounters a fatal error, you can use the `any_errors_fatal: true` directive. This is useful in scenarios where partial execution is undesirable and you want to ensure consistency across all managed nodes.

**Example:**

```yaml
- name: Critical deployment
  hosts: all
  any_errors_fatal: true
  tasks:
    - name: Run a critical task
      shell: /usr/bin/do-something-important
```

With `any_errors_fatal: true`, if the task fails on any host, Ansible will immediately stop running the playbook on all hosts.

For more details, see the [Ansible documentation on playbook error handling](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html#stopping-on-failure).

For more details, see the [Ansible documentation on blocks and error handling](https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html) and [error handling strategies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html).

## Ansible Lookups

Lookups in Ansible allow you to retrieve data from outside sources and use it within your playbooks, tasks, or variables. They are useful for reading files, fetching environment variables, generating random values, querying databases, and more.

Lookups are invoked using the `lookup` keyword or the Jinja2 `lookup()` function.

### Common Lookup Plugins and Examples

- **file:** Reads the contents of a local file on the control node.
  ```yaml
  - name: Read a file and print its contents
    debug:
    msg: "{{ lookup('file', '/etc/hostname') }}"
  ```

- **env:** Fetches the value of an environment variable from the control node.
  ```yaml
  - name: Get the HOME environment variable
    debug:
    msg: "{{ lookup('env', 'HOME') }}"
  ```

- **password:** Generates or retrieves a password from a file.
  ```yaml
  - name: Generate a random password and save it
    user:
    name: johndoe
    password: "{{ lookup('password', '/tmp/passwordfile chars=ascii_letters') | password_hash('sha512') }}"
  ```

- **pipe:** Executes a shell command on the control node and returns its output.
  ```yaml
  - name: Get the current date from the control node
    debug:
    msg: "{{ lookup('pipe', 'date') }}"
  ```

- **csvfile:** Reads a value from a CSV file.
  ```yaml
  - name: Get a value from a CSV file
    debug:
    msg: "{{ lookup('csvfile', 'username file=users.csv delimiter=, col=1') }}"
  ```

### Using Lookups in Variables

You can use lookups to set variable values dynamically:

```yaml
vars:
  my_secret: "{{ lookup('env', 'MY_SECRET') }}"
```

### Looping with Lookups

Lookups can be used with loops to process multiple items:

```yaml
- name: Read multiple files
  debug:
  msg: "{{ lookup('file', item) }}"
  loop:
  - /etc/hostname
  - /etc/hosts
```
## Using Lookups with Jinja2 Templates

Lookups can be used inside Jinja2 templates to dynamically fetch data during template rendering. This is useful for injecting secrets, configuration values, or external data into files generated by Ansible.

### Example: Injecting Environment Variables into a Template

Suppose you want to include the value of an environment variable in a configuration file:

**Template (`config.j2`):**
```jinja2
[app]
secret_key = {{ lookup('env', 'APP_SECRET_KEY') }}
```

**Playbook:**
```yaml
- name: Render config file with secret key from environment
  template:
    src: config.j2
    dest: /etc/myapp/config.ini
```

### Example: Reading File Contents into a Template

You can read the contents of a file and insert it into a template:

**Template (`motd.j2`):**
```jinja2
Welcome to {{ inventory_hostname }}!

Here is your custom message:
{{ lookup('file', '/etc/custom_message.txt') }}
```

**Playbook:**
```yaml
- name: Generate MOTD with custom message
  template:
    src: motd.j2
    dest: /etc/motd
```

### Example: Generating Random Passwords in Templates

Generate a random password and use it in a configuration file:

**Template (`db.conf.j2`):**
```jinja2
[database]
user = admin
password = {{ lookup('password', '/tmp/dbpassfile length=16 chars=ascii_letters') }}
```

**Playbook:**
```yaml
- name: Create database config with random password
  template:
    src: db.conf.j2
    dest: /etc/myapp/db.conf
```

### Example: Including Each Host's Date Command Output in a Template

To include the output of the `date` command or any other command output from each host in your template, you first need to gather the date output as a fact or registered variable in your playbook, then use it in your Jinja2 template.

**Template (`info.j2`):**
```jinja2
Host: {{ inventory_hostname }}
Current date: {{ host_date }}
```

**Playbook:**
```yaml
- name: Gather date output from each host
  hosts: all
  tasks:
    - name: Get current date
      command: date
      register: date_result

    - name: Render template with date output
      template:
        src: info.j2
        dest: /etc/myapp/info.txt
      vars:
        host_date: "{{ date_result.stdout }}"
```
This approach ensures each host's rendered file contains its own date output.

```yaml
tasks:
    - name: Read /etc/hostname on remote host
      slurp:
        src: /etc/hostname
      register: remote_hostname

    - name: Render template with remote hostname
      template:
        src: template.j2
        dest: /tmp/output.txt
```

The first task uses the slurp module to read the contents of /etc/hostname from the remote host and saves the result in the remote_hostname variable. The second task uses the template module to render a Jinja2 template (template.j2) and write the output to /tmp/output.txt on the remote host. This allows you to include information from the remote file in your generated template. The example template (info.j2) shows how you might display the host name and current date in the rendered file.


### Use Cases of lookups

- **Injecting secrets or API keys** from environment variables or vault files into config files.
- **Embedding file contents** (certificates, SSH keys, license files) directly into templates.
- **Dynamically generating values** (passwords, tokens) at deploy time.
- **Fetching configuration values** from CSV, INI, or other external sources for templating.
- **Including command outputs** (such as the current date) specific to each host in generated files.

For more details, see the [Ansible documentation on using lookups in templates](https://docs.ansible.com/ansible/latest/user_guide/playbooks_templating.html#using-lookups-in-templates).

### More Information

See the [Ansible documentation on lookups](https://docs.ansible.com/ansible/latest/plugins/lookup.html) for a full list of lookup plugins and advanced usage.

## Ansible Filters

Filters in Ansible are used to transform data, manipulate variables, and format output within playbooks and templates. They are based on Jinja2 filters and can be applied using the pipe (`|`) syntax.

### Common Filter Examples

- **String Manipulation:**
  ```yaml
  vars:
    my_string: "Ansible"
  tasks:
    - debug:
      msg: "{{ my_string | upper }}"   # Output: ANSIBLE
    - debug:
      msg: "{{ my_string | lower }}"   # Output: ansible
    - debug:
      msg: "{{ my_string | replace('A', 'a') }}"  # Output: ansible
  ```

- **List Operations:**
  ```yaml
  vars:
    my_list: [1, 2, 3, 4]
  tasks:
    - debug:
      msg: "{{ my_list | sum }}"       # Output: 10
    - debug:
      msg: "{{ my_list | join(', ') }}" # Output: 1, 2, 3, 4
    - debug:
      msg: "{{ my_list | length }}"    # Output: 4
  ```

- **Dictionary Operations:**
  ```yaml
  vars:
    my_dict:
    name: "web"
    port: 80
  tasks:
    - debug:
      msg: "{{ my_dict | dict2items }}"
    # Output: [{'key': 'name', 'value': 'web'}, {'key': 'port', 'value': 80}]
  ```

- **Default Values:**
  ```yaml
  vars:
    my_var: ""
  tasks:
    - debug:
      msg: "{{ my_var | default('default_value') }}"
    # Output: default_value
  ```

- **Formatting and Type Conversion:**
  ```yaml
  vars:
    number: 42
  tasks:
    - debug:
      msg: "{{ '%04d' | format(number) }}"  # Output: 0042
    - debug:
      msg: "{{ number | string }}"          # Output: '42'
  ```

- **Unique and Sort:**
  ```yaml
  vars:
    items: [3, 1, 2, 3, 2]
  tasks:
    - debug:
      msg: "{{ items | unique | sort }}"    # Output: [1, 2, 3]
  ```

### Using Filters in Templates

You can use filters directly in Jinja2 templates:

```jinja2
{{ my_list | join('; ') }}
{{ my_string | upper }}
```

- **Select and Map Filters:** Extract specific values from a list of dictionaries.
  ```yaml
  vars:
    users:
      - name: alice
        uid: 1001
      - name: bob
        uid: 1002
  tasks:
    - debug:
        msg: "{{ users | map(attribute='name') | list }}"
    # Output: ['alice', 'bob']
  ```

- **Selectattr and Rejectattr:** Filter items in a list of dictionaries based on an attribute.
  ```yaml
  vars:
    services:
      - name: nginx
        enabled: true
      - name: apache
        enabled: false
  tasks:
    - debug:
        msg: "{{ services | selectattr('enabled') | map(attribute='name') | list }}"
    # Output: ['nginx']
    - debug:
        msg: "{{ services | rejectattr('enabled') | map(attribute='name') | list }}"
    # Output: ['apache']
  ```

- **Combining Filters:** Chain multiple filters for complex transformations.
  ```yaml
  vars:
    numbers: [1, 2, 3, 4, 5, 6]
  tasks:
    - debug:
        msg: "{{ numbers | select('even') | list | sum }}"
    # Output: 12
  ```

- **JSON Query Filter:** Query complex data structures using JMESPath.
  ```yaml
  vars:
    users:
      - name: alice
        groups: [admin, dev]
      - name: bob
        groups: [dev]
  tasks:
    - debug:
        msg: "{{ users | json_query('[?groups.contains(@, `admin`)].name') }}"
    # Output: ['alice']
  ```

- **Random Choice:** Select a random item from a list.
  ```yaml
  vars:
    colors: ['red', 'green', 'blue']
  tasks:
    - debug:
        msg: "{{ colors | random }}"
  ```

- **Hashing and Encoding:**
  ```yaml
  vars:
    password: "mysecret"
  tasks:
    - debug:
        msg: "{{ password | password_hash('sha512') }}"
    - debug:
        msg: "{{ password | b64encode }}"
  ```
### More Filters

Ansible provides many built-in filters for working with strings, lists, dictionaries, dates, files, and more. You can also use custom filters from collections.

For more advanced filter examples, see the [Ansible filter plugins documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#filter-plugins).

For a full list and advanced usage, see the [Ansible filters documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html).

## Ansible Plays and Roles

### What is a Play?

A **play** in Ansible is a mapping between a group of hosts and the tasks that should run on those hosts. Plays are defined in playbooks and allow you to orchestrate automation across multiple systems.

**Example of a play:**
```yaml
- name: Install and configure web server
  hosts: webservers
  become: yes
  tasks:
    - name: Install httpd
      apt:
        name: httpd
        state: present

    - name: Start httpd
      service:
        name: httpd
        state: started
```

### What is a Role?

A **role** is a way to organize playbook content by breaking it into reusable components. Roles group together tasks, variables, files, templates, handlers, and other resources. This makes your automation modular, shareable, and easier to maintain.

#### Role Directory Structure

A typical role has the following structure:
```
myrole/
  tasks/
    main.yml
  handlers/
    main.yml
  files/
  templates/
  vars/
    main.yml
  defaults/
    main.yml
  meta/
    main.yml
```
- `tasks/`: Main list of tasks to execute.
- `handlers/`: Handlers triggered by tasks.
- `files/`: Static files to copy to hosts.
- `templates/`: Jinja2 templates.
- `vars/`: Variables for the role.
- `defaults/`: Default variables (lowest precedence).
- `meta/`: Role metadata.

#### Using Roles in a Playbook

You can include roles in your playbook using the `roles` keyword:

```yaml
- hosts: webservers
  become: yes
  roles:
    - nginx
    - common
    - patching
```

You can also pass variables to roles or use conditional role inclusion.

#### Creating a Role

To create a new role, use the `ansible-galaxy` command:
```bash
ansible-galaxy init myrole
```

This generates the standard directory structure for your role.

#### Benefits of Roles

- Reusability: Share roles across projects or teams.
- Organization: Keep playbooks clean and modular.
- Scalability: Easily manage complex automation by composing roles.

For more details, see the [Ansible documentation on roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html).

## Ansible Tags and Limit

### Using Tags

Tags in Ansible allow you to run specific parts of your playbook without executing everything. You assign tags to tasks, blocks, or roles, and then use the `--tags` or `--skip-tags` option to control which tasks run.

**Example:**
```yaml
tasks:
  - name: Install nginx
    apt:
      name: nginx
      state: present
    tags: install

  - name: Configure nginx
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    tags:
      - config
      - nginx

  - name: Restart nginx
    service:
      name: nginx
      state: restarted
    tags: restart
```

**Run only tasks tagged `install`:**
```bash
ansible-playbook site.yml --tags install
```

**Skip tasks tagged `restart`:**
```bash
ansible-playbook site.yml --skip-tags restart
```

You can tag entire roles or blocks as well.

### Using Limit

The `--limit` option restricts playbook execution to specific hosts or groups, regardless of what is defined in the inventory or playbook.

**Examples:**

- Run playbook only on `web1`:
  ```bash
  ansible-playbook site.yml --limit web1
  ```

- Run on multiple hosts/groups:
  ```bash
  ansible-playbook site.yml --limit "web1,db1"
  ```

- Use patterns (e.g., all hosts in the `web` group):
  ```bash
  ansible-playbook site.yml --limit web
  ```

**Combining tags and limit:**
```bash
ansible-playbook site.yml --tags config --limit web1
```

For more, see [Ansible documentation on tags](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html) and [limit](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#limiting-playbook-execution).

## Ansible Local Actions and `delegate_to`

### Local Actions

A **local action** is a task that runs on the control node (the machine running Ansible), rather than on the remote hosts. This is useful for tasks like generating files, querying APIs, or running commands that should not execute on the managed nodes.

**Example:**
```yaml
- name: Run a command locally
  local_action: command date
```
Or using the modern syntax:
```yaml
- name: Run a command locally
  command: date
  delegate_to: localhost
```
### Using `delegate_to`

The `delegate_to` keyword allows you to run a specific task on a different host than the one targeted by the play. This is commonly used for:

- Running a task on the control node (`localhost`)
- Running a task on a specific host (e.g., a load balancer or jump host)
- Copying files between remote hosts

**Examples:**

- **Delegate to localhost:**
    ```yaml
    - name: Fetch a file from remote host to control node
      fetch:
        src: /etc/hosts
        dest: /tmp/
      delegate_to: localhost
    ```

- **Delegate to another host:**
    ```yaml
    - name: Restart load balancer after web update
      service:
        name: haproxy
        state: restarted
      delegate_to: loadbalancer
    ```

- **Copy a file from one remote host to another:**
    ```yaml
   - name: Copy file from web1 to web2 via scp
     command: scp /tmp/file.txt web2:/tmp/file.txt
     delegate_to: web1
     run_once: true
    ```
- Or you can use below example
```yaml
- name: Copy file from web1 to web2
  hosts: localhost
  gather_facts: false
  vars:
    src_host: web1
    dest_host: web2
    remote_file_path: /tmp/file.txt
    temp_dir: /tmp  # Local temp dir where file will be fetched

  tasks:

    - name: Fetch file from web1 to control node
      fetch:
        src: "{{ remote_file_path }}"
        dest: "{{ temp_dir }}/"
        flat: yes
      delegate_to: "{{ src_host }}"
      run_once: true

    - name: Copy file from control node to web2
      copy:
        src: "{{ temp_dir }}/file.txt"
        dest: "{{ remote_file_path }}"
      delegate_to: "{{ dest_host }}"
      run_once: true

       ```

### When to Use

- When you need to run a task on the control node (e.g., local file operations, API calls)
- When orchestrating actions between hosts (e.g., updating a load balancer after deploying web servers)
- When you need to gather or process data centrally

For more, see the [Ansible documentation on delegation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html).

## Retrying Tasks and Adding Delays in Ansible

Ansible allows you to retry tasks that might fail due to temporary issues (like network hiccups or service startup delays) using the `retries` and `delay` parameters with the `until` keyword. This is useful for tasks that may not succeed immediately but are expected to succeed after some time.

**Example: Retry a task until it succeeds**

```yaml
- name: Wait for web server to respond
  uri:
    url: http://localhost
    status_code: 200
  register: result
  until: result.status == 200
  retries: 5
  delay: 10
```

- `until`: The condition to check after each try.
- `retries`: Maximum number of attempts.
- `delay`: Seconds to wait between attempts.

**Example: Wait for a file to exist**

```yaml
- name: Wait for file to be created
  stat:
    path: /tmp/somefile
  register: file_stat
  until: file_stat.stat.exists
  retries: 10
  delay: 5
```

This approach is helpful for polling resources, waiting for services, or handling eventual consistency.

For more, see the [Ansible documentation on looping and retries](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#retrying-a-task-until-a-condition-is-met).

## Speeding Up Ansible

Ansible performance can be improved in several ways, especially when managing large inventories or running complex playbooks. Here are some practical tips:

### 1. Enable Pipelining

Pipelining reduces the number of SSH operations required per task.

Add to `ansible.cfg`:
```ini
[ssh_connection]
pipelining = True
```

### 2. Increase Forks

By default, Ansible runs up to 5 parallel tasks. Increasing this can speed up execution on many hosts.

Add to `ansible.cfg`:
```ini
[defaults]
forks = 20
```
Or use `-f` on the command line:
```bash
ansible-playbook -f 20 playbook.yml
```

### 3. Use Fact Caching

Gathering facts can be slow. Enable fact caching to reuse facts between runs.

Add to `ansible.cfg`:
```ini
[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
```

### 4. Limit Fact Gathering

If you don’t need facts, disable or limit them:
```yaml
- hosts: all
  gather_facts: no
```
Or gather only specific facts:
```yaml
- setup:
    filter: "ansible_hostname"
```

### 5. Use SSH Multiplexing

Ansible enables SSH multiplexing by default, but ensure it’s not disabled in your config.

### 6. Use Asynchronous Actions

you can use Ansible's async and poll parameters to run them asynchronously. Setting async: 600 tells Ansible to allow the task up to 600 seconds (10 minutes) to finish. By setting poll: 0, you instruct Ansible not to wait for the task to complete and to move on to the next task immediately. This is useful for starting background jobs or when you want to avoid blocking the playbook execution while waiting for a long-running operation. You can later check the status of the asynchronous task using the async_status module if needed.

```yaml
- name: Run a long task asynchronously
  shell: /path/to/long/script.sh
  async: 600
  poll: 0
  register: async_job

- name: Wait for the async job to finish and check status
  async_status:
    jid: "{{ async_job.ansible_job_id }}"
  register: job_result
  until: job_result.finished
  retries: 30
  delay: 10
```
In this example, the first task starts the script in the background. The second task uses the async_status module to periodically check if the job has finished, retrying up to 30 times with a 10-second delay between checks. This approach lets you manage long-running operations efficiently in your playbooks.

If you want to run async task without async_status

```yaml
- name: Run a long task asynchronously
  shell: /path/to/long/script.sh
  async: 600
  poll: 0
```
### 7. Use Mitogen (Optional)

[Mitogen](https://mitogen.networkgenomics.com/) is a third-party plugin that can significantly speed up Ansible runs. Note: Not officially supported by Ansible.

### 8. Limit Target Hosts

Use `--limit` to restrict execution to only necessary hosts.

### 9. Use Tags

Run only relevant tasks using `--tags` to avoid unnecessary work.

---

For more details, see the [Ansible performance tuning guide](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#performance-tuning).

## Ansible Serial Flag

The `serial` keyword in Ansible controls how many hosts are processed in each batch during a playbook run. This is useful for rolling updates, minimizing downtime, or ensuring that only a subset of hosts are changed at a time.

### Usage

Add `serial` to your play or playbook:

```yaml
- name: Rolling update of web servers
  hosts: webservers
  serial: 2
  tasks:
    - name: Update application
      shell: /usr/local/bin/update_app.sh
```

In this example, Ansible will run the tasks on 2 hosts at a time. Once those complete, it moves to the next 2, and so on.

You can also specify a percentage or a list for more control:

```yaml
serial: "30%"      # 30% of hosts at a time
```

This means Ansible will process 1 host in the first batch, 2 hosts in the second batch, and 5 hosts in the third batch, continuing in this pattern for the remaining hosts. This approach gives you fine-grained control over how updates are rolled out, helping to minimize risk and manage resources during large deployments.

```yaml
serial:
  - 1
  - 2
  - 5
```

### When to Use

- Rolling deployments or restarts
- Minimizing service disruption
- Coordinating changes across clusters

For more, see the [Ansible documentation on serial](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html#rolling-update-batch-size-serial).

## Ansible `import` and `include`

Ansible provides `import` and `include` statements to help you organize and reuse your playbooks, tasks, and other files. These directives allow you to break complex automation into smaller, manageable pieces.

### `import_*` vs `include_*`

- **`import_*` (static):** Files are read and parsed at playbook parse time. All tasks are known before execution starts.
- **`include_*` (dynamic):** Files are included at execution time, allowing for conditional includes and more dynamic behavior.

### Common Usage

#### Importing Playbooks

- **`import_playbook`:** Import another playbook file.
  ```yaml
  # site.yml
  - import_playbook: webservers.yml
  - import_playbook: dbservers.yml
  ```

#### Importing or Including Tasks

- **`import_tasks`:** Statically import a list of tasks.
  ```yaml
  tasks:
    - import_tasks: install.yml
    - import_tasks: configure.yml
  ```
- **`include_tasks`:** Dynamically include tasks, often with `when` conditions.
  ```yaml
  tasks:
    - include_tasks: debug.yml
    when: debug_enabled
  ```

#### Importing or Including Roles

- **`import_role`:** Statically import a role.
  ```yaml
  tasks:
    - import_role:
      name: common
  ```
- **`include_role`:** Dynamically include a role, often with parameters or conditions.
  ```yaml
  tasks:
    - include_role:
      name: monitoring
    vars:
      monitor_port: 9000
    when: enable_monitoring
  ```

### When to Use

- Use `import_*` when you want all tasks to be known up front (e.g., for static analysis, or when using tags).
- Use `include_*` for conditional or dynamic inclusion.

### More Information

See the [Ansible documentation on imports and includes](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_includes.html) for details and best practices.

## The Future of Ansible

Ansible continues to evolve rapidly, driven by community contributions and enterprise needs. Key trends and future directions include:

- **Event-Driven Automation:** Ansible is expanding into event-driven automation, enabling real-time responses to infrastructure or application events (see [Ansible Rulebooks](https://docs.ansible.com/automation-controller/latest/html/userguide/eda_rulebooks.html)).
- **Cloud-Native and Hybrid Support:** Ongoing improvements for managing cloud, container, and hybrid environments, including better Kubernetes and multi-cloud integrations.
- **Collections Ecosystem:** The move to [Ansible Collections](https://docs.ansible.com/ansible/latest/dev_guide/collections_tech.html) allows faster delivery of new modules, plugins, and roles, making Ansible more modular and extensible.
- **Automation Controller (AWX/Ansible Tower):** Enhanced UI, RBAC, and workflow features for enterprise automation at scale.
- **Security and Compliance:** More features for automated security, compliance checks, and policy enforcement.
- **Performance and Scalability:** Continued focus on improving execution speed, parallelism, and handling of large inventories.

Ansible’s open-source model and strong community ensure it remains at the forefront of IT automation, adapting to new technologies and use cases.

For more, see the [Ansible roadmap](https://github.com/ansible/ansible-roadmap) and [community updates](https://www.ansible.com/blog).

## Some usefull examples
Write playbook to create and Configure a "testing" User for Passwordless SSH and sudo access
```yaml
- name: Create testing user for passwordless SSH and sudo access
  hosts: all
  become: yes
  tasks:
    - name: ensure testing user is present with a home directory
      user:
        name: testing
        state: present
        shell: /bin/bash
        create_home: yes

    - name: ensure testing user's .ssh directory exists
      file:
        path: /home/testing/.ssh
        state: directory
        mode: '0700'
        owner: testing
        group: testing

    - name: copy public key to testing user for paswordless ssh connection
      authorized_key:
        user: testing
        key: "{{ lookup('file', '/root/.ssh/id_rsa.pub') }}"
        state: present

    - name: add testing user in sudoers file
      blockinfile:
        path: /etc/sudoers
        block: |
          #allow testing user to run all commands without password
          testing ALL=(ALL) NOPASSWD: ALL
        validate: '/usr/sbin/visudo -cf %s'
   ```
   visudo -cf to validate the sudoers syntax before applying the change

  If you want to set a password for the `testing` user during creation, you can use the `password` parameter in the `user` module. The password must be provided as a hashed value (not plain text). You can generate a hashed password by using the `openssl passwd -6` command on your control node:

  ```bash
  openssl passwd -6
  ```
  Then, update the hashed generated password:

  ```yaml
  - name: ensure testing user is present with a home directory and password
    user:
      name: testing
      state: present
      shell: /bin/bash
      create_home: yes
      password: "$6$round...$hashedpasswordxxxxxxxxx"
  ```
  **Note:**  
  - Never store plain text passwords in playbooks.

Write a playbook to install and configure an Apache web servers and firewall on servers, sets up a test homepage, and ensures HTTP access is allowed. It then verifies that the web servers are running and accessible.

```yaml
- name: Enable intranet services on all web servers
  hosts: webservers
  become: true
  tasks:
    - name: Latest version of httpd and firewalld installed
      dnf:
        name:
          - httpd
          - firewalld
        state: latest

    - name: Test html page is installed
      copy:
        content: "Welcome to the example.com intranet!\n"
        dest: /var/www/html/index.html

    - name: Firewall enabled and running
      service:
        name: firewalld
        enabled: true
        state: started

    - name: Firewall permits access to httpd service
      firewalld:
        service: http
        permanent: true
        state: enabled
        immediate: true

    - name: Web server enabled and running
      service:
        name: httpd
        enabled: true
        state: started

- name: Test intranet web servers from workstations
  hosts: workstations
  become: false
  vars:
    webserver_list: "{{ groups['webservers'] | default([]) }}"
  tasks:
    - name: Connect to intranet web servers
      ansible.builtin.uri:
        url: "http://{{ item }}"
        return_content: true
        status_code: 200
      loop: "{{ webserver_list }}"
```

**Notes:**
- Define your `webservers` and `workstations` groups in your inventory.
- The test task will check all web servers from each workstation host.
