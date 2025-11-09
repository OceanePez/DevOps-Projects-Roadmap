# Nginx Log Analyser

This project is related to the website [roadmap.sh] : [Log Archive Tool](https://roadmap.sh/projects/log-archive-tool)

## Installation

**Clone the Repository**

- Clone this repository into your local machine.

```bash
git clone --depth=1 https://github.com/OceanePez/DevOps-Projects-Roadmap.git
```

- Now go to cloned directory

```bash
cd DevOps-Projects-Roadmap/nginx-log-analyser
```

## Usage

- Give Permission and run the script

```bash
chmod +x log-archive
./nginx-analyser.sh <path-to-log> or ./nginx-analyser.sh
```

./nginx-analyser.sh`will use the default file`nginx-access.log` provided in the repository.

- The script will output the following metrics:
  - Top 5 IP addresses with the most requests
  - Top 5 most requested paths
  - Top 5 response status codes
  - Top 5 user agents
