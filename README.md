

### Step 1: Set up the **frp** server on a VPS (or any public server)

1. **Download and extract frp** on your VPS or public server:
   ```bash
   wget https://github.com/fatedier/frp/releases/download/v0.43.0/frp_0.43.0_linux_amd64.tar.gz
   tar -xzf frp_0.43.0_linux_amd64.tar.gz
   cd frp_0.43.0_linux_amd64
   ```

2. **Configure the frp server (frps)**:
   - Create a configuration file for the frp server (`frps.ini`):
     ```ini
     [common]
     bind_port = 7000
     ```

3. **Start the frp server**:
   ```bash
   ./frps -c ./frps.ini
   ```

### Step 2: Set up the **frp** client on your local game server

1. **Download and extract frp** on your game server (or your local machine where the game server is hosted):
   ```bash
   wget https://github.com/fatedier/frp/releases/download/v0.43.0/frp_0.43.0_linux_amd64.tar.gz
   tar -xzf frp_0.43.0_linux_amd64.tar.gz
   cd frp_0.43.0_linux_amd64
   ```

2. **Configure the frp client (frpc)**:
   - Create a configuration file for the frp client (`frpc.ini`). The client will forward the UDP port used by the game (default: `20595`) to the frp server.
     ```ini
     [common]
     server_addr = your-vps-ip
     server_port = 7000

     [0ad-game]
     type = udp
     local_ip = 127.0.0.1
     local_port = 20595
     remote_port = 20595
     ```

   - Replace `your-vps-ip` with the public IP address of the VPS where your **frp server** is running.

3. **Start the frp client**:
   ```bash
   ./frpc -c ./frpc.ini
   ```

### Step 3: Open the required ports on your VPS and local machine

- On the VPS (frp server), make sure that port `7000` (or whichever port you configured for frp) and the UDP port `20595` are open in the firewall.
  - If using `ufw`, run:
    ```bash
    sudo ufw allow 7000
    sudo ufw allow 20595/udp
    ```

- On your local machine or game server, ensure that UDP port `20595` is open.

### Step 4: Test the connection

1. Players should now connect to your game server using the IP address of the **frp server** (the VPS) and port `20595`.
   - Example: `your-vps-ip:20595`

2. Test if players can join the game successfully.

## TESTING

### 1. **Check if the UDP Port is Open (Using netcat or nc)**

One way to test if the UDP port `20595` is open and reachable is by using the `netcat` (or `nc`) command.

#### **On the game server (local machine)**:

1. **Install netcat (if it's not already installed)**:
   - On Debian/Ubuntu-based systems:
     ```bash
     sudo apt-get install netcat
     ```

2. **Start listening on UDP port 20595**:
   ```bash
   nc -u -l 20595
   ```

   This command tells netcat to listen for UDP traffic on port `20595`.

#### **On a remote machine** 

1. **Install netcat** (if not installed) as described above.
   ```bash
   sudo apt-get install netcat
```
2. **Send a test message to the server**:
   Replace `your-vps-ip` with your actual VPS IP address.
   ```bash
   echo "test" | nc -u your-vps-ip 20595
   ```

## More Troubleshooting


### Option 2: Use `ss` (socket statistics)
`ss` is a modern replacement for `netstat` and should already be installed on most Linux distributions.

You can check active listening ports using:
```bash
sudo ss -tunlp | grep 20595
```

This will show you which processes are listening on the UDP port `20595` and can help verify that the game server is correctly listening on the expected port.

### Expected output
```bash
sudo ss -tunlp | grep 20595
udp   UNCONN 0      0            0.0.0.0:20595      0.0.0.0:*    users:(("main",pid=603394,fd=36))
```

