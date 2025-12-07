# What is Bash?

**Bash** (Bourne Again SHell) is a Unix shell and command language. It is widely used as the default shell on Linux and macOS systems. Bash allows users to interact with the operating system by executing commands, running scripts, automating tasks, and managing files and processes.

Key features of Bash include:
- Command-line editing and history
- Scripting capabilities for automation
- Support for variables, loops, and conditionals
- Job control and process management

Bash is an essential tool for system administrators, developers, and anyone working with Unix-like operating systems.

## Bash Variables and Data Types

Bash variables are used to store data that can be referenced and manipulated within scripts or the command line. Variables are created by assigning a value to a name, without spaces:

```bash
name="Alice"
count=5
```

Bash does not have explicit data types like other programming languages. All variables are treated as strings, but Bash can perform arithmetic operations on variables containing numeric values.

### Examples

```bash
greeting="Hello, World!"
number=42

echo $greeting           # Output: Hello, World!
echo $((number + 8))     # Output: 50
```

#### Example: Using Variables in a Script

```bash
#!/bin/bash
set -euo pipefail
set -x

user="Bob"
age=30

echo "User: $user"
echo "Age: $age"
echo "Next year, age will be $((age + 1))"
```

### Special Variable Types

- **Environment variables**: Available to child processes.
- **Positional parameters**: `$1`, `$2`, etc., represent script arguments.
- **Read-only variables**: Declared with `readonly`.

#### Example: Read-only Variable

```bash
readonly pi=3.14159
echo "Value of pi: $pi"
# Attempting to modify will result in an error
# pi=3.15  # This will cause an error
```

To unset a variable, use `unset variable_name`.

## Bash Loops

Loops in Bash allow you to execute a block of code multiple times. The most common loop types are `for`, `while`, and `until`.

### For Loop

The `for` loop iterates over a list of items:

```bash
for i in 1 2 3 4 5; do
    echo "Number: $i"
done
```

**Real-world example:** Renaming multiple files in a directory.

```bash
for file in *.jpg; do
    mv "$file" "backup_$file"
done
```

You can also use C-style syntax:

```bash
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done
```

**Real-world example:** Sending multiple ping requests.

```bash
for ((i=1; i<=3; i++)); do
    ping -c 1 example.com
done
```

---

### While Loop

The `while` loop executes as long as a condition is true:

```bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```

**Real-world example:** Reading lines from a file.

```bash
while read line; do
    echo "Line: $line"
done < myfile.txt
```

---

### Until Loop

The `until` loop executes until a condition false.

```bash
n=1
until [ $n -gt 5 ]; do
    echo "n is $n"
    ((n++))
done
```

**Real-world example:** Waiting for a service to start.

```bash
until systemctl is-active --quiet myservice; do
    echo "Waiting for myservice to start..."
    sleep 2
done
echo "Service started!"
```

---

### Looping Through Files

```bash
for file in *.txt; do
    echo "Processing $file"
done
```

**Real-world example:** Compressing all log files.

```bash
for log in *.log; do
    gzip "$log"
done
```
Loops are essential for automating repetitive tasks in Bash scripts.

## Bash Conditions

Bash uses conditional statements to make decisions in scripts. The most common conditional statements are `if`, `elif`, and `else`.

### Basic If Statement

```bash
if [ $number -gt 10 ]; then
    echo "Number is greater than 10"
fi
```

### If-Else Statement

```bash
if [ "$name" = "Alice" ]; then
    echo "Hello, Alice!"
else
    echo "You are not Alice."
fi
```

### If-Elif-Else Statement

```bash
if [ $score -ge 90 ]; then
    echo "Grade: A"
elif [ $score -ge 80 ]; then
    echo "Grade: B"
else
    echo "Grade: C or below"
fi
```

### Test Operators

- Numeric: `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`
- String: `=`, `!=`, `<`, `>`, `-z` (empty), `-n` (not empty)
- File: `-e` (exists), `-f` (regular file), `-d` (directory), `-r` (readable), `-w` (writable), `-x` (executable)

### Example: File Existence Check

```bash
if [ -f "myfile.txt" ]; then
    echo "File exists."
else
    echo "File does not exist."
fi
```

### Compound Conditions

You can combine multiple conditions using `&&` (and), `||` (or), or within a single `[ ]` using `-a` (and) and `-o` (or):

#### Using `&&` and `||` (preferred for clarity):

```bash
if [ $age -ge 18 ] && [ "$citizen" = "yes" ]; then
    echo "Eligible to vote"
fi

if [ $score -ge 50 ] || [ "$retake" = "yes" ]; then
    echo "You can proceed to the next round."
fi
```

#### Using `-a` (and) and `-o` (or) inside `[ ]`:

```bash
if [ $age -ge 18 -a "$citizen" = "yes" ]; then
    echo "Eligible to vote"
fi

if [ $score -ge 50 -o "$retake" = "yes" ]; then
    echo "You can proceed to the next round."
fi
```

#### More Examples:

```bash
# Check if a file exists and is writable
if [ -f "data.txt" ] && [ -w "data.txt" ]; then
    echo "File exists and is writable."
fi

# Check if a directory exists or a file exists
if [ -d "backup" ] || [ -e "archive.zip" ]; then
    echo "Backup directory or archive file found."
fi

# Using -a and -o for the same checks
if [ -f "data.txt" -a -w "data.txt" ]; then
    echo "File exists and is writable."
fi

if [ -d "backup" -o -e "archive.zip" ]; then
    echo "Backup directory or archive file found."
fi
```

> **Note:** Using `&&` and `||` is generally preferred for readability and to avoid ambiguity.
Conditional statements are fundamental for controlling the flow of Bash scripts.

## Bash `case` Statement

The `case` statement in Bash is used for pattern matching and branching based on the value of a variable. It is similar to `switch` statements in other languages and is useful when you have multiple possible values to check.

### Syntax

```bash
case "$variable" in
    pattern1)
        # commands
        ;;
    pattern2)
        # commands
        ;;
    *)
        # default commands
        ;;
esac
```

- Each `pattern` can include wildcards like `*` and `?`.
- The `*)` pattern acts as a default (catch-all).

### Example: Simple Menu

```bash
read -p "Enter a fruit (apple/banana/cherry): " fruit

case "$fruit" in
    apple)
        echo "You chose apple."
        ;;
    banana)
        echo "You chose banana."
        ;;
    cherry)
        echo "You chose cherry."
        ;;
    *)
        echo "Unknown fruit."
        ;;
esac
```

### Real-world Example: File Extension Handling

```bash
filename="document.pdf"

case "$filename" in
    *.txt)
        echo "Text file"
        ;;
    *.jpg|*.jpeg)
        echo "JPEG image"
        ;;
    *.pdf)
        echo "PDF document"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
```
The `case` statement is powerful for handling multiple conditions and makes scripts more readable when dealing with many options.


Bash supports two types of arrays: indexed arrays and associative arrays.
### Indexed Arrays

Indexed arrays use integer indices starting from 0.

```bash
fruits=("apple" "banana" "cherry")
echo ${fruits[0]}        # Output: apple
echo ${fruits[1]}        # Output: banana
echo ${fruits[@]}        # Output: apple banana cherry
echo ${#fruits[@]}          # will get length of array
```

You can add or update elements:

```bash
fruits[3]="date"
```

Loop through an array:

```bash
for fruit in "${fruits[@]}"; do
    echo $fruit
done
```

### Associative Arrays

Associative arrays use keys/value paris and require Bash version 4.0 or higher.
```
declare -A colors
colors[apple]="red"
colors[banana]="yellow"
colors[cherry]="red"

echo ${colors[banana]}   # Output: yellow
echo ${!colors[@]}       # To print all keys - apple banana cherry
echo ${colors[@]}        # To print all values
echo ${#colors[@]}       # To count length - 3
echo ${colors[@]}        # To print all values
echo ${colors[#]}        # To count length - 3
```

Loop through keys and values:

```bash
for key in "${!colors[@]}"; do
    echo "$key is ${colors[$key]}"
done
```
## Bash Functions

Functions in Bash allow you to group commands into reusable blocks. They help organize scripts and avoid code duplication.

### Defining and Using Functions

```bash
greet() {
    echo "Hello, $1!"
}

greet "Alice"   # Output: Hello, Alice!
```

You can also use the `function` keyword (optional):

```bash
function add_numbers() {
    sum=$(( $1 + $2 ))
    echo "Sum: $sum"
}

add_numbers 5 7   # Output: Sum: 12
```

### Returning Values

Bash functions can return an exit status (0 for success, non-zero for failure) using `return`, or output values using `echo`:

```bash
get_length() {
    echo "${#1}"
}

length=$(get_length "banana")
echo "Length: $length"   # Output: Length: 6
```

### Example: Return and Exit Status Code

You can use `return` to set an exit status code, which can be checked with `$?`:

```bash
is_even() {
    if (( $1 % 2 == 0 )); then
        return 0    # Success: number is even
    else
        return 1    # Failure: number is odd
    fi
}

is_even 4
if [ $? -eq 0 ]; then
    echo "Number is even"
else
    echo "Number is odd"
fi
```

### Real-world Example: Checking Disk Space

```bash
check_disk_space() {
    threshold=80
    usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$usage" -ge "$threshold" ]; then
        echo "Warning: Disk usage is ${usage}%!"
    else
        echo "Disk usage is normal (${usage}%)."
    fi
}

check_disk_space
```

### Real-world Example: Backing Up Files

```bash
backup_file() {
    src="$1"
    dest="$2"
    if [ -f "$src" ]; then
        cp "$src" "$dest"
        echo "Backup of $src completed."
    else
        echo "Source file $src does not exist."
    fi
}

backup_file "data.txt" "backup/data.txt"
```

Functions make Bash scripts modular and easier to maintain.

## Bash Error Handling

Error handling in Bash is crucial for writing robust scripts. By default, Bash continues executing commands even if one fails. You can control this behavior and handle errors gracefully.

### Exit Status

Every command returns an exit status (`$?`): `0` means success, any other value indicates an error.

```bash
ls /nonexistent
echo $?   # Output: non-zero (error)
```

### Using `set -e`, `set -u`, and `set -o pipefail`

- `set -e`: Exit immediately if any command exits with a non-zero status.
- `set -u`: Treat unset variables as an error and exit immediately.
- `set -o pipefail`: Return the exit status of the last command in a pipeline that failed.

You can combine these for safer scripts:

```bash
set -euo pipefail

cp file1.txt /tmp/
echo "This will not run if the previous command fails or if an unset variable is used."
```

### Error Handling with `trap`

Use `trap` to execute commands on errors or script exit:

```bash
trap 'echo "An error occurred. Exiting."' ERR

cp file1.txt /tmp/
cp file2.txt /tmp/
```

### Checking Command Success

You can check the exit status after a command:

```bash
cp file.txt /backup/
if [ $? -ne 0 ]; then
    echo "Copy failed!"
    exit 1
fi
```

Or use `&&` and `||`:

```bash
cp file.txt /backup/ && echo "Copy succeeded." || echo "Copy failed."
```

### Custom Error Functions

Define a function to handle errors:

```bash
error_exit() {
    echo "Error on line $1"
    exit 1
}

trap 'error_exit $LINENO' ERR
```

### Real-world Example: Handling Missing Files

```bash
file="important.txt"
if [ ! -f "$file" ]; then
    echo "File $file not found!"
    exit 1
fi

echo "Processing $file..."
```

Proper error handling makes your Bash scripts safer and easier to debug.
## Understanding `trap` in Bash

The `trap` command in Bash allows you to specify commands to execute when the shell receives certain signals or when specific events occur (such as script exit or error). This is useful for cleaning up resources, handling errors, or performing custom actions before a script terminates.

### Common Uses for `trap`

- Cleaning up temporary files on exit
- Handling script interruptions (e.g., Ctrl+C)
- Logging errors or script termination

### Syntax

```bash
trap 'commands' SIGNAL
```

- `'commands'`: The commands to execute when the signal/event occurs.
- `SIGNAL`: The name or number of the signal/event (e.g., `EXIT`, `ERR`, `INT`).
These are common Bash trap signals or keywords used in shell scripting to handle specific events:
- `EXIT` triggers when a script exits, regardless of the reason.
- `ERR` triggers when a command fails (returns a non-zero exit status).
- `INT` triggers when the script receives an interrupt signal, such as when you press Ctrl+C.

You can use these in the `trap` command to run custom cleanup or error-handling code when these events occur. For example, `trap 'echo "Exiting..."' EXIT` will print a message whenever the script ends.

### Real-world Example: Cleaning Up Temporary Files

Suppose your script creates a temporary file and you want to ensure it's deleted whether the script finishes normally or is interrupted:

```bash
#!/bin/bash

temp_file=$(mktemp)

# Set up trap to remove temp file on EXIT or interruption
trap 'rm -f "$temp_file"; echo "Cleaned up temp file."' EXIT INT TERM

echo "Working with temp file: $temp_file"
# Simulate some work
sleep 5

echo "Script completed."
```

In this example:
- The `trap` ensures the temporary file is deleted and a message is printed when the script exits (normally or via interruption).
- This prevents leftover files and keeps your system clean.

`trap` is a powerful tool for robust and maintainable Bash scripts.

## Manipulating Variables in Bash

Bash provides several ways to manipulate variables, including string operations, arithmetic, and parameter expansion.

### String Manipulation

- **Concatenation:**
    ```bash
    first="Hello"
    second="World"
    combined="$first, $second!"
    echo "$combined"  # Output: Hello, World!
    ```

- **Substring Extraction:**
    ```bash
    text="abcdef"
    echo "${text:2:3}"  # Output: cde (start at index 2, length 3)
    ```

- **String Length:**
    ```bash
    str="Bash"
    echo "${#str}"  # Output: 4
    ```

- **Replace Substring:**
    ```bash
    phrase="I like apples"
    echo "${phrase/apples/oranges}"  # Output: I like oranges
    ```

### Arithmetic Operations

Use `$(( ))` for arithmetic:

```bash
a=5
b=3
sum=$((a + b))
echo "$sum"  # Output: 8
```

You can also increment or decrement variables:

```bash
count=10
((count++))
echo "$count"  # Output: 11
```

### Parameter Expansion

- **Default Value if Empty:**
    ```bash
    name=""
    echo "${name:-Guest}"  # Output: Guest
    ```

- **Assign Default if Empty:**
    ```bash
    name=""
    echo "${name:=Guest}"  # Output: Guest
    echo "$name"           # Output: Guest
    ```

#### Common Parameter Expansion Patterns

Here are some useful parameter expansion patterns for manipulating file names in Bash:

- `${file%.txt}`  
    Removes `.txt` from the end of the variable.  
    Example: If `file="archive.backup.2025.txt"`, the result is `archive.backup.2025`.

- `${file%%.txt}`  
    Also removes `.txt` from the end. This only differs from the previous pattern if the pattern contains wildcards.

- `${file#*.}`  
    Removes the shortest match of `*.` from the start of the variable.  
    Example: `backup.2025.txt`.

- `${file##*.}`  
    Removes the longest match of `*.` from the start, effectively extracting the file extension.  
    Example: `txt`.

- `${file%%.*}`  
    Removes everything after the first dot, leaving only the base name.  
    Example: `archive`.

These patterns help you quickly extract or modify parts of filenames and other strings in your Bash scripts.

These techniques allow you to efficiently manipulate and work with variables in your Bash scripts.

## Debugging Bash Scripts

Debugging Bash scripts helps you identify and fix errors quickly. Here are some common techniques:

- **Enable Debug Mode:**  
  Add `set -x` at the top of your script to print each command and its arguments as they are executed.
  ```bash
  #!/bin/bash
  set -x
  # Your script here
  ```

- **Combine Options:**  
  For robust debugging, combine options:
  ```bash
  set -euxo pipefail
  ```

These techniques will help you debug and maintain error-free Bash scripts.
## Running a Bash Script in Debug Mode

To execute a Bash script in debug mode (printing each command before it runs), use the `-x` option with `bash`:

```bash
bash -x yourscript.sh
```

This is useful for troubleshooting and understanding script flow. You can also combine options, such as `-e` (exit on error):

```bash
bash -ex yourscript.sh
```

**Example output:**

```bash
+ echo 'Starting script'
Starting script
+ cp file.txt /backup/
+ echo 'Copy complete'
Copy complete
```
This output shows each command prefixed with a `+` as it executes.
## Difference Between `[]` and `[[]]` in Bash

Bash provides two types of test constructs for evaluating conditions: `[]` (also known as `test`) and `[[]]` (extended test or conditional expression). Understanding their differences is important for writing robust Bash scripts.

### What is POSIX?

**POSIX** (Portable Operating System Interface) is a family of standards specified by the IEEE for maintaining compatibility between operating systems. POSIX defines a set of common interfaces and behaviors for Unix-like systems, ensuring that scripts and programs can run across different environments with minimal changes. Tools and commands that are POSIX-compliant are portable and work in various shells, not just Bash.

### `[]` (test command)

- Traditional POSIX test command.
- Supports basic string and integer comparisons.
- Limited pattern matching (no regex).
- Variables should be quoted to avoid errors with spaces or empty values.
- Portable across POSIX-compliant shells (e.g., sh, dash, ksh).

**Example:**
```bash
if [ "$name" = "Alice" ]; then
    echo "Hello, Alice!"
fi
```

### `[[]]` (extended test, Bash-specific)

- Bash-specific, not available in all shells.
- Supports advanced string operations, pattern matching (`==`, `!=`), and regular expressions (`=~`).
- No word splitting or pathname expansion inside the brackets.
- Safer with unquoted variables.
- Not POSIX-compliant (works only in Bash and some compatible shells).

**Example:**
```bash
if [[ $name == A* ]]; then
    echo "Name starts with A"
fi

if [[ $input =~ ^[0-9]+$ ]]; then
    echo "Input is a number"
fi
```

### Key Differences

| Feature                | `[]` (test) | `[[]]` (extended test) |
|------------------------|:-----------:|:----------------------:|
| POSIX compatible       | Yes         | No (Bash only)         |
| Pattern matching       | No          | Yes (`==`, `!=`)       |
| Regex support          | No          | Yes (`=~`)             |
| Word splitting         | Yes         | No                     |
| Safer with variables   | No          | Yes                    |

> **Tip:** Use `[[ ... ]]` in Bash scripts for more features and safer comparisons, but use `[ ... ]` for portability to other shells.
## STDIN, STDOUT, and STDERR in Bash

In Bash (and Unix-like systems), every process has three standard data streams:

- **STDIN (Standard Input)**: The input stream, usually from the keyboard.
- **STDOUT (Standard Output)**: The output stream, usually to the terminal.
- **STDERR (Standard Error)**: The error output stream, also usually to the terminal.

These streams are represented by file descriptors:
- `0` — STDIN
- `1` — STDOUT
- `2` — STDERR

### Redirection

Redirection allows you to change where input comes from and where output goes.

#### Redirecting Output

- Redirect STDOUT to a file (overwrite):
    ```bash
    echo "Hello" > output.txt
    ```
- Redirect STDOUT to a file (append):
    ```bash
    echo "World" >> output.txt
    ```
- Redirect STDERR to a file:
    ```bash
    ls non_existent_file 2> error.log
    ```
- Redirect both STDOUT and STDERR to a file:
    ```bash
    command > all.log 2>&1
    ```
    or (Bash 4+):
    ```bash
    command &> all.log
    ```

#### Redirecting Input

- Redirect STDIN from a file:
    ```bash
    wc -l < input.txt
    ```

#### Piping

You can send STDOUT of one command as STDIN to another using `|`:
```bash
ls | grep ".txt"
```

#### Examples

- Save both output and errors:
    ```bash
    ./myscript.sh > output.log 2> error.log
    ```
- Discard errors:
    ```bash
    command 2>/dev/null
    ```
Understanding and using these streams and redirections is essential for effective Bash scripting and automation.

## Input Redirection in Bash: `<`, `<<`, and `<<<`

Bash provides several ways to redirect input to commands and scripts. The most common input redirection operators are `<`, `<<`, and `<<<`.

### `<` (Redirect STDIN from a File)

The `<` operator redirects the contents of a file as the standard input (STDIN) to a command.

**Example:**
```bash
sort < unsorted.txt
```
This sorts the contents of `unsorted.txt` and prints the result.

**While loop example:**
```bash
while read line; do
    echo "Line: $line"
done < input.txt
```
This reads each line from `input.txt` and processes it inside the loop.

---

### `<<` (Here Document)

The `<<` operator, known as a "here document," allows you to provide multiline input directly within the script or command until a specified delimiter is reached.

**Example:**
```bash
cat <<EOF
Line 1
Line 2
Line 3
EOF
```
This sends the three lines as input to `cat`.

**While loop example:**
```bash
while read line; do
    echo "Line: $line"
done <<EOF
Apple
Banana
Cherry
EOF
```
This processes each line from the here document inside the loop.

---

### `<<<` (Here String)

The `<<<` operator, called a "here string," sends a single string as input to a command.

**Example:**
```bash
grep "foo" <<< "foo bar baz"
```
This searches for "foo" in the provided string.

**While loop example:**
```bash
while read word; do
    echo "Word: $word"
done <<< "one two three"
```
This treats the string as input and processes it in the loop (by default, `read` reads the whole line, but you can use `read -a` to split into words).

**More Examplea:**

**Example:**
You can also use here documents to provide input to interactive commands:
```bash
mysql -u user -p <<ENDSQL
SELECT * FROM users;
ENDSQL
```
**Example:**
Another example:
```bash
read name <<< "Alice"
echo $name  # Output: Alice
```

### Summary Table

| Operator | Description                        | Example Usage                  |
|----------|------------------------------------|-------------------------------|
| `<`      | Redirect input from a file         | `sort < file.txt`             |
| `<<`     | Here document (multiline input)    | `cat <<EOF ... EOF`           |
| `<<<`    | Here string (single line input)    | `grep "pattern" <<< "string"` |

These input redirection techniques are powerful tools for automating and scripting in Bash.

## Importing One Bash Script into Another

You can "import" or source one Bash script into another using the `source` command or the shorthand `.` (dot). This runs the imported script in the current shell, making its functions and variables available.

**Example:**

Suppose you have a script called `utils.sh`:

```bash
# utils.sh
greet() {
    echo "Hello, $1!"
}
```

You can import it in another script:

```bash
#!/bin/bash
source ./utils.sh   # or: . ./utils.sh

greet "Alice"       # Output: Hello, Alice!
```

**Notes:**
- Use `source` or `.` followed by the path to the script you want to import.
- The imported script should have executable permissions if you plan to run it directly, but for sourcing, read permissions are sufficient.
- Sourcing is useful for sharing functions, variables, and configuration between scripts.
- Relative or absolute paths can be used.

This technique helps modularize and reuse code in Bash scripting.

## Positional Parameters in Bash

Positional parameters are special variables that hold the arguments passed to a Bash script or function. They are referenced as `$1`, `$2`, `$3`, etc., where `$1` is the first argument, `$2` is the second, and so on. `$0` refers to the script name.

### Example: Accessing Script Arguments

```bash
#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "Total arguments: $#"
```

If you run the script as `./myscript.sh apple banana`, the output will be:

```
Script name: ./myscript.sh
First argument: apple
Second argument: banana
All arguments: apple banana
Total arguments: 2
```

### Looping Over All Arguments

```bash
for arg in "$@"; do
    echo "Argument: $arg"
done
```

### Special Variables

- `$@` — All arguments as separate words.
- `$*` — All arguments as a single word.
- `$#` — Number of arguments.
- `$0` — Script name.
- `"$@"` — Preserves each argument as a separate quoted string (preferred in loops).

Positional parameters are essential for writing flexible and reusable Bash scripts that accept user input.

