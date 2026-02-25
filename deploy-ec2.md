## Deploy Metabase Demo Stack to EC2

This document assumes:
- You have AWS credentials and permissions to create EC2 instances and security groups.
- You want a simple proof-of-concept (not fully production-hardened).

### 1. Provision an EC2 instance

1. In the AWS console, create a new EC2 instance:
   - AMI: Ubuntu 22.04 LTS (or Amazon Linux 2023).
   - Instance type: t3.small or t3.medium.
   - Storage: 20–40 GB gp3.
2. Security group:
   - Inbound:
     - SSH (22) from your IP.
     - HTTP (3030) from your IP (or a restricted CIDR).
3. Key pair:
   - Create or select an SSH key pair and download the private key.

### 2. Install Docker and Docker Compose plugin on EC2

SSH into the instance, then run (Ubuntu example):

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
newgrp docker
```

Verify:

```bash
docker --version
docker compose version
```

### 3. Copy the metabase_demo stack and seed files to EC2

On your local machine (PowerShell), from `C:\Sites`:

```powershell
scp -r -i "C:\path\to\your-key.pem" `
  C:\Sites\metabase_demo `
  ubuntu@EC2_PUBLIC_DNS:/home/ubuntu/metabase_demo
```
If you want to reuse data from an existing Apiary stack, run `scripts\export-from-apiary.ps1` locally before copying so that `seed\metabase.db` and `seed\hub_analytics.sql` are populated. This is optional; the stack can also start fresh without these files.

### 4. Configure environment on EC2

On the EC2 instance:

```bash
cd ~/metabase_demo
cp .env.example .env
```

Edit `.env` as needed:
- Keep `POSTGRES_USER`, `POSTGRES_DB` as-is.
- Set a stronger `POSTGRES_PASSWORD`.
- Optionally set `MB_SITE_URL` to `http://EC2_PUBLIC_DNS:3030`.

### 5. Start the stack (and optionally import data) on EC2

From `~/metabase_demo`:

```bash
docker compose up -d
```

If you have a `seed/hub_analytics.sql` dump you want to load, import it after Postgres is healthy:

```bash
docker compose exec -T postgres bash -c "psql -U apiary -d apiary -f /seed/hub_analytics.sql"
```

Metabase will use `seed/metabase.db` (if present) automatically via the bind mount in `docker-compose.yml`, or create a new application database file there on first run if it does not exist.

### 6. Access Metabase

- Open `http://EC2_PUBLIC_DNS:3030` in your browser.
- Complete the Metabase setup wizard to create an admin user.
- Add a database connection pointing at the `postgres` service (host `postgres`, port `5432`) using the credentials from your `.env`.
- If you imported seed data, verify that your dashboards and questions can query the seeded `hub`/`analytics` data.

