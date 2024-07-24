# devopsfetch

`DevOpsFetch` is a comprehensive DevOps tool designed to collect and display crucial system information. It provides details about active ports, user logins, Nginx configurations, Docker images, and container statuses. Additionally, it can be configured to run as a systemd service, continuously monitoring and logging these activities.

## Features

- **Active Ports**: Lists all active ports and their corresponding services.
- **User Logins**: Displays recent user login information.
- **Nginx Configurations**: Provides a summary of Nginx server names and listening ports.
- **Docker Images**: Lists all Docker images available on the system.
- **Docker Containers**: Displays the status of all running Docker containers.
- **Time Range**: Displays activities within a specified time range

## Prerequisites

Before running the `DevOpsFetch` script, ensure your system meets the following requirements:

- **Bash**: The script is written in Bash and requires a Bash-compatible environment.
- **net-tools**: For the `netstat` command used to list active ports.
- **Docker**: Installed and running, to list Docker images and containers.
- **Nginx**: If you want to list Nginx configurations, Nginx should be installed and its configurations should be accessible.

## Installation

1. **Clone the repository or download the script**:
   ```
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Make the script executable**:
   ```bash
   sudo chmod +x devopsfetch.sh
   ```

3. **Install necessary dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install -y net-tools docker.io
   ```

4. **(Optional) Set up as a systemd service**:
   - Create a systemd service file `/etc/systemd/system/devopsfetch.service` with the following content:

     ```ini
     [Unit]
     Description=DevOps Fetch Service
     After=network.target

     [Service]
     Type=simple
     ExecStart=/path/to/devopsfetch.sh --monitor
     Restart=on-failure
     User=your_username

     [Install]
     WantedBy=multi-user.target
     ```

   - Replace `/path/to/devopsfetch.sh` with the actual path to the script.
   - Replace `your_username` with the user under which the service should run.
   - Reload the systemd daemon and enable the service:
     ```bash
     sudo systemctl daemon-reload
     sudo systemctl enable devopsfetch.service
     ```
   - Start the service:
     ```bash
     sudo systemctl start devopsfetch.service
     ```

## Usage

To use `DevOpsFetch`, you can run the script directly or start the systemd service for continuous monitoring.

### Running the Script Manually

1. **Display Current System Information**:
   ```bash
   ./devopsfetch.sh
   ```

2. **Monitor and Log System Information Continuously**:
   ```bash
   ./devopsfetch.sh --monitor
   ```

### Systemd Service

- **Start the Service**:
  ```bash
  sudo systemctl start devopsfetch.service
  ```

- **Check Service Status**:
  ```bash
  sudo systemctl status devopsfetch.service
  ```

- **View Logs**:
  The log file is located at `/var/log/devopsfetch.log`. To view the log:
  ```bash
  sudo cat /var/log/devopsfetch.log
  ```

## Notes

- Ensure Docker is installed and running if you wish to collect Docker-related information. You may need to add the user running the script to the `docker` group:
  ```bash
  sudo usermod -aG docker your_username
  ```
- The script assumes Nginx configuration files are in the default locations (`/etc/nginx/sites-available` and `/etc/nginx/nginx.conf`). Adjust the paths in the script if your configuration files are elsewhere.
- The script collects data every hour when run in monitoring mode. Adjust the `sleep` interval in the `monitor_system` function as needed.

## Contributing

Contributions are welcome! Please fork this repository, make your changes, and submit a pull request.

---

This `README.md` provides a comprehensive guide to using and setting up the `devopsfetch.sh` script, making it easy for users and contributors to understand its functionality and requirements.
