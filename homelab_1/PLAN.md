[⬅ Back to Main Repo](../README.md)

# Comprehensive Home Lab Implementation Plan: Old Laptop to Ubuntu Server

## Hardware Profile & Strategy

- **CPU:** Intel Core i3 (2nd Gen / Sandy Bridge - 2 Cores, 4 Threads)
- **RAM:** 4GB DDR3
- **Storage:** 250GB SSD
- **Current State:** Dual-boot Linux Mint & Arch Linux
- **Target State:** Dedicated Headless Ubuntu Server (24.04 LTS) utilizing 100% of the 250GB drive.

> **Hardware Note:** A 2nd Gen Intel i3 with 4GB of RAM is more than capable of running a headless Linux server (no graphical desktop interface). By skipping the desktop environment, Ubuntu Server will only use about **250MB–400MB of RAM** at idle, leaving over 3.5GB of RAM for Docker containers and self-hosted services (like Pi-hole, Jellyfin, Nextcloud, or Home Assistant).

## Phase 1: Preparation & Creating the Bootable USB (Linux, Windows, & macOS)

Before starting, back up any important personal files from your current Linux Mint or Arch installations, as we will be completely wiping the 250GB drive to dedicate it entirely to Ubuntu Server.

### 1. Download Ubuntu Server

Download the official **Ubuntu Server 24.04 LTS (Noble Numbat)** 64-bit PC (AMD64) ISO image from the official Canonical website: `ubuntu.com/download/server`.

### 2. Flashing the ISO (Choose Method A or Method B)

Since you have used both **Ventoy** and **BalenaEtcher** in the past, here is a refresher on how both work across **Linux, Windows, and macOS**. You only need to use **one** of these methods.

#### Method A: Using Ventoy (Best for Linux & Windows)

Ventoy turns your USB into a drag-and-drop bootable drive so you don't have to reformat it every time you want to try a new ISO. _(Note: Ventoy does not have a native macOS installer; Mac users should use BalenaEtcher in Method B unless the USB already has Ventoy installed)._

1. **If Ventoy is ALREADY installed on your USB (Linux, Windows, or Mac):**
   - Plug your USB drive into your computer. If it shows up in your file manager/Finder/File Explorer as a drive named `Ventoy`, you **do not** need to run any flashing software!
   - Simply **copy and paste** (or drag-and-drop) the `ubuntu-24.04-live-server-amd64.iso` file directly into the USB folder like a normal file. Safely eject the USB when the copy finishes.
2. **Installing Ventoy from scratch on Linux (Mint/Ubuntu):**
   - Download `ventoy-x.x.xx-linux.tar.gz` from the official Ventoy site.
   - Extract the archive, open the extracted folder, and double-click `VentoyGUI.x86_64`.
   - Select your USB drive from the dropdown menu and click **Install** (this wipes the USB).
   - Once finished, drag-and-drop the Ubuntu Server ISO onto the newly created `Ventoy` USB partition.
3. **Installing Ventoy from scratch on Windows:**
   - Download `ventoy-x.x.xx-windows.zip` from the official Ventoy site.
   - Right-click the `.zip` file and select **Extract All**.
   - Open the folder and double-click `Ventoy2Disk.exe` (click **Yes** on the Windows User Account Control prompt).
   - Select your USB drive under **Device** and click **Install**. Confirm the warning prompts to format the drive.
   - Open **File Explorer** (`Win + E`), copy your Ubuntu Server `.iso` file, and paste it directly into the `Ventoy` USB drive.

#### Method B: Using BalenaEtcher (Works on Linux, Windows, & macOS)

BalenaEtcher overwrites the entire USB drive with a single operating system image and works identically across all three operating systems.

1. **Download & Launch BalenaEtcher for your OS:**
   - **Linux:** Download the `.AppImage` file. Right-click it $\rightarrow$ **Properties** $\rightarrow$ **Permissions** $\rightarrow$ Check **"Allow executing file as program"**, then double-click to launch.
   - **Windows:** Download the Windows `.exe` installer (or Portable version) and double-click to launch.
   - **macOS:** Download the `.dmg` file (choose **macOS x64** for Intel Macs or **macOS arm64** for Apple Silicon M1/M2/M3/M4 Macs). Double-click the `.dmg`, drag **balenaEtcher** into your **Applications** folder, and open it. _(Note: If macOS displays a popup saying "The disk you inserted was not readable by this computer" after flashing completes, click **Ignore**—do NOT click Initialize—as macOS simply cannot read Linux boot partitions natively)._
2. **Step 1 (Flash from file):** Click the button and select your downloaded `ubuntu-24.04-live-server-amd64.iso`.
3. **Step 2 (Select target):** Plug in your USB flash drive and select it from the list (verify the size matches your USB so you don't overwrite another drive).
4. **Step 3 (Flash!):** Click **Flash!** and enter your administrator/system password if prompted. Wait for it to validate and complete.

## Phase 2: BIOS Setup & Ubuntu Server Installation

### 1. Prepare Physical Connections

Plug an **Ethernet cable** directly from your home router into your laptop. While Ubuntu Server supports Wi-Fi, setting up Wi-Fi via command line and running a server over wireless is unreliable; Ethernet is strongly recommended.

### 2. Boot from the USB

1. Insert the USB into the old laptop and power it on.
2. Immediately and repeatedly press your laptop's Boot Menu key (usually `F12`, `F11`, `F9`, `F2`, or `Esc` depending on whether it's a Dell, Lenovo, HP, or Asus).
3. Select your USB drive from the boot menu. (If using Ventoy, select the Ubuntu Server ISO from the Ventoy menu and choose **Boot in normal mode**).

### 3. Step-by-Step Installer Walkthrough (Wiping Mint & Arch)

Use your **Arrow Keys**, **Tab**, **Spacebar** (to toggle checkboxes), and **Enter** to navigate the text-based installer.

1.  **Language & Keyboard:** Select `English` and your keyboard layout.
2.  **Installation Type:** Select **Ubuntu Server** (standard, not minimized, so you have standard troubleshooting tools pre-installed).
3.  **Network Connections:** Your Ethernet interface (usually named `enp...` or `eth0`) should automatically get an IP address via DHCP (e.g., `192.168.1.xxx/24`). Write this IP address down! Select **Done**.
4.  **Proxy & Mirror:** Leave Proxy blank and keep the default mirror. Select **Done**.
5.  **Guided Storage Configuration (CRITICAL - Wiping Mint & Arch):**
    - Select **\[X\] Use an entire disk**.
    - Ensure your 250GB drive is selected.
    - **Uncheck `[ ] Set up this disk as an LVM group`** (or leave it checked if you prefer, _however_, if you leave LVM checked, Ubuntu only allocates 50% of your drive by default!).
    - _If you leave LVM checked:_ On the next screen (**Storage Configuration Summary**), look at `ubuntu-lv` under Logical Volumes. If it says `100G` instead of `~240G`, highlight `ubuntu-lv` $\rightarrow$ Press **Enter** $\rightarrow$ **Edit** $\rightarrow$ Change size to the maximum available value shown on screen $\rightarrow$ **Save**.
    - Select **Done**, then select **Continue** on the red warning prompt (this erases Linux Mint and Arch Linux).
6.  **Profile Setup:**
    - **Your name:** e.g., `admin`
    - **Your server's name:** e.g., `homelab`
    - **Pick a username:** e.g., `labuser` (remember this!)
    - **Choose a password:** Create a strong password.
7.  **Ubuntu Pro:** Select **Skip for now** and press **Continue**.
8.  **SSH Setup (CRITICAL FOR HEADLESS USE):**
    - Press **Spacebar** to check **`[X] Install OpenSSH server`**. (Without this, you cannot control the laptop remotely from your main PC).
    - Select **Done**.
9.  **Featured Server Snaps:** **Do not select anything here.** (Avoid installing Docker via Snap during setup; we will install official Docker cleanly via `apt` later). Select **Done**.
10. **Reboot:** Wait for the installation to finish, select **Reboot Now**, and remove the USB drive when prompted, then press **Enter**.

## Phase 3: Laptop-Specific Tweaks & Remote Access (Linux, Windows, & Mac)

Because you are using a laptop instead of a desktop tower, we need to stop it from going to sleep when you close the screen lid, and ensure its IP address never changes.

### 1. Log In via SSH from Your Main Computer (Linux, Windows, or Mac)

Wait 2 minutes for the laptop to boot to the black login screen. You no longer need to type on the server laptop directly! Modern **Windows 10/11**, **macOS**, and **Linux** all have a built-in OpenSSH client.

1. **Open your terminal application on your main computer:**
   - **Windows 10 / 11:** Press `Win + R`, type `powershell` (or open **Windows Terminal** / **Command Prompt** from the Start Menu), and press **Enter**.
   - **macOS:** Press `Cmd + Space` to open Spotlight, type `Terminal`, and press **Enter**.
   - **Linux:** Press `Ctrl + Alt + T` to open your Terminal.
2. **Connect to the server:**
   Run the exact same command on Windows, Mac, or Linux:

   ```bash
   ssh your_username@192.168.1.XXX
   ```

   _(Replace `your_username` and `192.168.1.XXX` with the username and IP address you noted during installation. Type `yes` to accept the fingerprint, then enter your password. Note that no stars/characters will appear on screen while typing your password—just type it and press Enter)._

### 2. Optional: Set Up Passwordless SSH Keys & File Transfers (Windows, Mac, & Linux)

If you are managing your server from Windows, macOS, or Linux, here is how to log in without typing your password every time, and how to transfer files between your main computer and the server:

#### A. Setting Up SSH Keys (Passwordless Login)

1. **Generate an SSH key on your main computer (Windows PowerShell, Mac Terminal, or Linux Terminal):**
   ```bash
   ssh-keygen -t ed25519
   ```
   _(Press **Enter** 3 times to accept the default file location and no passphrase)._
2. **Copy the key to your Ubuntu Server:**
   - **On Linux or macOS:**
     ```bash
     ssh-copy-id your_username@192.168.1.XXX
     ```
   - **On Windows (PowerShell):** _(Windows does not include `ssh-copy-id` by default, so run this one-liner in PowerShell instead):_
     ```powershell
     type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh your_username@192.168.1.XXX "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
     ```

#### B. Transferring Files Between Your Computer and the Server

- **Command Line (Works on Windows PowerShell, Mac Terminal, & Linux Terminal):** Use `scp` (Secure Copy):
  ```bash
  # Copy a file FROM your computer TO the server's home folder:
  scp /path/to/local/file.txt your_username@192.168.1.XXX:~/
  ```
- **Graphical Drag-and-Drop Apps (If you prefer a GUI over the terminal):**
  - **Windows:** Download **WinSCP** (free) or **FileZilla**. Connect using Protocol `SFTP`, Port `22`, your server IP, username, and password.
  - **macOS:** Download **Cyberduck** (free) or **FileZilla**, and connect using `SFTP` (Port `22`).
  - **Linux:** Open your default file manager (Nemo on Mint, Nautilus on Ubuntu), press `Ctrl + L`, and type `sftp://your_username@192.168.1.XXX`.

### 3. Prevent Sleep When Closing the Laptop Lid

By default, closing the laptop lid puts the server into suspend/sleep mode, cutting off your server.

1. Open the systemd login configuration file:

   ```bash
   sudo nano /etc/systemd/logind.conf
   ```

2. Scroll down using the down arrow key and find these lines (they will have a `#` in front of them):

   ```ini
   #HandleLidSwitch=suspend
   #HandleLidSwitchExternalPower=suspend
   #HandleLidSwitchDocked=ignore
   ```

3. Delete the `#` symbol at the start of those lines and change `suspend` to `ignore` so they look exactly like this:

   ```ini
   HandleLidSwitch=ignore
   HandleLidSwitchExternalPower=ignore
   HandleLidSwitchDocked=ignore
   ```

4. Save and exit Nano: Press `Ctrl + O`, then press `Enter` to save. Press `Ctrl + X` to exit _(Note for Mac users: Even on a Mac keyboard, Nano inside SSH uses `Control`, NOT `Command`)_.
5. Apply the changes immediately:

   ```bash
   sudo systemctl restart systemd-logind
   ```

_(You can now close the laptop lid almost all the way—leave a tiny gap if your laptop vents heat through the keyboard—and it will stay running!)_

### 4. Turn Off Laptop Screen (When Lid is Open)

If you leave the lid open for cooling, the screen backlight will stay on 24/7 unless you enable console blanking:

1. Edit the GRUB configuration:

   ```bash
   sudo nano /etc/default/grub
   ```

2. Find the line `GRUB_CMDLINE_LINUX_DEFAULT=""` and change it to turn the screen off after 60 seconds of inactivity:

   ```ini
   GRUB_CMDLINE_LINUX_DEFAULT="consoleblank=60"
   ```

3. Save (`Ctrl+O`, `Enter`) and exit (`Ctrl+X`), then update GRUB and reboot:

   ```bash
   sudo update-grub
   sudo reboot
   ```

### 5. Set a Static IP Address

To ensure your server's IP address never changes after a power outage:

- **Easiest & Recommended Way (Router DHCP Reservation):** Log into your home Wi-Fi router's admin page, find the "Connected Devices" or "LAN / DHCP Reservation" list, locate `homelab`, and bind its MAC address to its current IP address.
- **Alternative Way (Ubuntu Netplan):** Edit `/etc/netplan/50-cloud-init.yaml` (or the `.yaml` file inside `/etc/netplan/`) using `sudo nano` and run `sudo netplan apply`.

## Phase 4: System Hardening & Installing Docker

With only 4GB of RAM, **Docker** is your best friend. It allows you to run isolated services with virtually zero memory overhead compared to traditional Virtual Machines.

### 1. Update the Operating System

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Configure the Firewall (UFW)

Always allow SSH _before_ enabling the firewall so you don't lock yourself out:

```bash
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

### 3. Install Official Docker Engine & Docker Compose

Run this official block of commands to add Docker's repository and install Docker:

```bash
# Install prerequisites
sudo apt install ca-certificates curl -y

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker & Compose plugin
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Allow your user to run Docker without typing 'sudo' every time
sudo usermod -aG docker $USER
newgrp docker
```

### 4. Deploy Your First Container: Portainer (Web GUI for Docker)

To manage your server visually from a web browser without memorizing every Docker command:

```bash
docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts
```

Once that finishes, open your web browser on your main PC (Windows, Mac, or Linux) and go to: `https://YOUR_SERVER_IP:9443` (accept the self-signed security warning) to create your admin account!

## Phase 5: Essential Linux Server Commands Cheat Sheet

Keep this table handy. Once you are connected via SSH, these commands run inside your Ubuntu Server terminal regardless of whether you connected from Windows, macOS, or Linux.

| Category                  | Command                                                  | Purpose / Description                                                                    |
| :------------------------ | :------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| **System & Updates**      | `sudo apt update && sudo apt upgrade -y`                 | Refreshes package lists and installs all system updates.                                 |
| **System & Updates**      | `sudo reboot` / `sudo poweroff`                          | Safely restarts or shuts down the server.                                                |
| **Hardware & Monitoring** | `htop` _(or `top`)_                                      | Real-time interactive viewer for CPU usage and your 4GB RAM usage.                       |
| **Hardware & Monitoring** | `free -h`                                                | Displays a quick summary of used and available RAM and Swap in gigabytes/megabytes.      |
| **Hardware & Monitoring** | `df -h`                                                  | Shows disk space usage across partitions in human-readable format (GB/MB).               |
| **Hardware & Monitoring** | `lsblk`                                                  | Lists all storage drives and partitions in a clean tree structure.                       |
| **Hardware & Monitoring** | `upower -i /org/freedesktop/UPower/devices/battery_BAT0` | Checks laptop battery health/charge status (acts as a built-in UPS!).                    |
| **Networking & Security** | `ip -br a`                                               | Quickly displays your network interfaces and current IP address.                         |
| **Networking & Security** | `ss -tulpn`                                              | Lists all active listening network ports to see what services are running.               |
| **Networking & Security** | `sudo ufw allow <port>/tcp`                              | Opens a specific port in the firewall (e.g., `sudo ufw allow 8096/tcp` for Jellyfin).    |
| **Networking & Security** | `sudo ufw status numbered`                               | Shows all active firewall rules with numbers (for easy deletion).                        |
| **Files & Navigation**    | `ls -la`                                                 | Lists all files in the current directory, including hidden `.env` files and permissions. |
| **Files & Navigation**    | `mkdir -p ~/docker/appname`                              | Creates a new folder (and parent folders if they don't exist yet).                       |
| **Files & Navigation**    | `sudo nano <filepath>`                                   | Opens a text file in the terminal editor (`Ctrl+O` to save, `Ctrl+X` to exit).           |
| **Files & Navigation**    | `rm -rf <foldername>`                                    | Permanently deletes a folder and everything inside it (**Use with extreme caution**).    |
| **Services (Systemd)**    | `sudo systemctl status <service>`                        | Checks if a background service (like `ssh` or `docker`) is running properly.             |
| **Services (Systemd)**    | `sudo systemctl restart <service>`                       | Restarts a background service after you edit its configuration file.                     |
| **Services (Systemd)**    | `sudo journalctl -u <service> -n 50`                     | Reads the last 50 log lines of a service to troubleshoot crashes.                        |
| **Docker & Containers**   | `docker ps`                                              | Lists all currently running Docker containers and their ports.                           |
| **Docker & Containers**   | `docker compose up -d`                                   | Starts a container defined in a `docker-compose.yml` file in the background.             |
| **Docker & Containers**   | `docker compose down`                                    | Stops and removes the containers defined in the current directory's compose file.        |
| **Docker & Containers**   | `docker logs -f <container_name>`                        | Streams live output logs from a specific container (`Ctrl+C` to stop viewing).           |
| **Docker & Containers**   | `docker system prune -a`                                 | Cleans up unused Docker images and stopped containers to free up SSD space.              |

### Cross-Platform Client Commands (Run on Your Main Computer Before Connecting)

If you are troubleshooting connectivity from your Windows, Mac, or Linux desktop _before_ logging into the server, use these native OS commands:

| Action                                                                     | Linux / macOS Terminal                 | Windows PowerShell / CMD               |
| :------------------------------------------------------------------------- | :------------------------------------- | :------------------------------------- |
| **Test if server is reachable**                                            | `ping -c 4 192.168.1.XXX`              | `ping 192.168.1.XXX`                   |
| **Connect via SSH**                                                        | `ssh user@192.168.1.XXX`               | `ssh user@192.168.1.XXX`               |
| **Copy file to server**                                                    | `scp ./file.txt user@192.168.1.XXX:~/` | `scp .\file.txt user@192.168.1.XXX:~/` |
| **Remove old SSH host key** _(if you reinstall the server on the same IP)_ | `ssh-keygen -R 192.168.1.XXX`          | `ssh-keygen -R 192.168.1.XXX`          |

## Phase 6: Great Starter Projects for a 2nd-Gen i3 + 4GB RAM

Because your CPU is an older 2nd-Gen Intel i3 and you have 4GB of RAM, stick to lightweight services (avoid running heavy game servers like modded Minecraft or 4K video transcoding). These run effortlessly on your hardware:

1. **Pi-hole or AdGuard Home:** Network-wide ad and tracker blocker for every device on your Wi-Fi (~100MB RAM).
2. **Samba / CasaOS / FileBrowser:** Turn your 250GB NVMe/SSD into a fast local network drive (NAS) to share files across your Windows PCs, Macs, Linux machines, and phones (~50MB RAM).
3. **Vaultwarden:** A lightweight, self-hosted Bitwarden password manager server (~50MB RAM).
4. **Jellyfin:** Stream movies and music stored on your server to your TV or phone (_Tip: Ensure "Hardware Transcoding" is off and media is played via "Direct Play" so the i3 CPU doesn't get overloaded_).
5. **Uptime Kuma:** A sleek dashboard that monitors your home network devices and alerts you if anything goes offline (~100MB RAM).

## Phase 7: Reliable References & Official Documentation

All instructions in this plan are verified against official documentation. If you ever want to read deeper into any component, refer directly to these authoritative sources:

1. **Ubuntu Server Official Installation Guide (Canonical):**
   - <https://ubuntu.com/tutorials/install-ubuntu-server>
   - <https://documentation.ubuntu.com/server/>
2. **Ventoy Official Usage Documentation (Linux & Windows):**
   - <https://www.ventoy.net/en/doc_start.html>
3. **BalenaEtcher Official Documentation & Repository (Linux, Windows, & macOS):**
   - <https://etcher.balena.io/>
4. **Microsoft Official Documentation – OpenSSH for Windows:**
   - <https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview>
5. **Systemd `logind.conf` Manual (Lid Switch & Power Management):**
   - <https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html>
6. **Official Docker Engine Installation for Ubuntu:**
   - <https://docs.docker.com/engine/install/ubuntu/>
7. **Portainer Community Edition Official Installation Docs:**
   - <https://docs.portainer.io/start/install-ce/server/docker/linux>
