## Installation

## Installation

**Clone the Repository**

- Clone this repository into your local machine.

```bash
git clone --depth=1 https://github.com/OceanePez/DevOps-Projects-Roadmap.git
```

- Now go to cloned directory

```bash
cd DevOps-Projects-Roadmap/Log-Archive-Tool
```
## Usage

- Give Permission and Run the script

```bash
chmod +x log-archive
./log-archive.sh <path-to-log>
```


## Explanation
The tool should run from the command line, accept the log directory as an argument, compress the logs, and store them in a new directory. The user should be able to:

Provide the log directory as an argument when running the tool.

bash

log-archive <log-directory>
The tool should compress the logs in a tar.gz file and store them in a new directory.

The tool should log the date and time of the archive to a file.

bash

logs_archive_20240816_100648.tar.gz
You can learn more about the tar command here.

If you are looking to build a more advanced version of this project, you can consider adding functionality to the tool like emailing the user updates on the archive, or sending the archive to a remote server or cloud storage.
