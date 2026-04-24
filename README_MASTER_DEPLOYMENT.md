
# 🖤 7-AGENT-1 + ORACLE 26ai — COMPLETE DEPLOYMENT PACKAGE

**For:** Oracle E2.1 Instance (Ubuntu 24.04 LTS) + Oracle 26ai Autonomous Database

**What this is:** Your 7-1 cognitive system migrated from flat JSON files to a
living Oracle 26ai database with vector semantic memory, 3D spatial memory palaces,
persistent emotional state, evolving self-model, and autonomous background cognition.

---

## 📦 What's In This Package

| Folder/File | Description |
|-------------|-------------|
| `main.py` | FastAPI server entry point |
| `core/` | Original 7-1 cognitive modules |
| `bridge/` | **NEW:** Oracle database bridge (replaces persistence.py + engine.py) |
| `database/` | **NEW:** 7 SQL files to build the cognitive database |
| `front/` | **NEW:** React dashboard (9 visualization components) |
| `identity/` | Original identity modules |
| `app/` | Original app modules |
| `tools/` | Original tool modules |
| `patches/` | Original patch modules |
| `soul.md` | Original static identity (now seeded into database) |
| `belief_graph.json` | Original flat beliefs (now in sns_beliefs table) |
| `chat_history.json` | Original linear history (now in sns_perceptions table) |

---

## 🚀 QUICK START (3 Methods)

### Method A: Fully Automated (Easiest)

```bash
# 1. Upload your DB wallet FIRST
# From your local machine:
scp -i ~/.ssh/YOUR_KEY.pem ~/Downloads/Wallet_*.zip ubuntu@YOUR_E2_IP:~/oracle_wallet/

# 2. SSH into your E2.1
ssh -i ~/.ssh/YOUR_KEY.pem ubuntu@YOUR_E2_IP

# 3. Unzip wallet
cd ~/oracle_wallet && unzip Wallet_*.zip

# 4. Download and run the installer
cd ~
wget https://raw.githubusercontent.com/SeVin-DEV/Oracle/main/install_oracle_26ai.sh
chmod +x install_oracle_26ai.sh
./install_oracle_26ai.sh

# 5. Set your DB credentials
export ORACLE_USER=ADMIN
export ORACLE_PASSWORD=YourPassword
export ORACLE_DSN=yourdb_high

# 6. Run SQL files (see SQL_SETUP_GUIDE.txt)
# 7. Update main.py import
# 8. Start the service
sudo systemctl start 7-agent
```

### Method B: Manual Step-by-Step

Follow the detailed cheat sheet: `7_AGENT_1_ORACLE_SETUP_CHEATSHEET.txt`

### Method C: Using Your Existing Scripts

```bash
# Your repo already has:
./install.sh   # Your original installer
./start.sh     # Your original starter

# You can use these as a base, but you'll need to:
# 1. Add `pip install oracledb` to install.sh
# 2. Add database env vars to start.sh
# 3. Modify main.py to import from bridge.engine_adapter
```

---

## 🗄️ DATABASE SETUP (CRITICAL!)

The SQL files MUST be run in order:

```
database/
├── 01_schema.sql          ← Create all tables, sequences, indexes
├── 02_seed_identity.sql   ← Seed your soul.md identity into DB
├── 03_cognitive_engine.sql← PL/SQL procedures (replaces engine.py)
├── 04_vector_bridge.sql   ← Vector embedding helpers
├── 05_spatial_memory.sql  ← 3D memory palace procedures
├── 06_scheduler_jobs.sql  ← Autonomous background cognition
└── 07_ords_api.sql        ← REST endpoints for dashboard
```

**Run them via:**
- SQLcl command line (recommended)
- SQL*Plus command line
- Oracle Database Actions web UI

See `ORACLE_26ai_SQL_SETUP_GUIDE.txt` for exact commands.

---

## 🔧 THE ONE CODE CHANGE

In `main.py`, change:

```python
# FROM:
from core.engine import run_cognitive_cycle

# TO:
from bridge.engine_adapter import run_cognitive_cycle_oracle
```

Also update the function call if the name changed.

---

## 🌐 ACCESSING YOUR SYSTEM

| Endpoint | URL | Description |
|----------|-----|-------------|
| API | `http://YOUR_E2_IP:8000` | FastAPI backend |
| Web UI | `http://YOUR_E2_IP` | React dashboard (via Nginx) |
| Health | `http://YOUR_E2_IP:8000/health` | System health check |

---

## 🧠 WHAT CHANGED FROM 7-1

| Before (7-1) | After (Oracle 26ai) |
|--------------|---------------------|
| `soul.md` static file | `sns_self_model` living table |
| `chat_history.json` linear | `sns_perceptions` with vector search |
| `belief_graph.json` flat dict | `sns_beliefs` with confidence + vectors |
| No emotion | `sns_emotional_state` persistent VAD |
| No spatial memory | `sns_spatial_memories` 3D memory palace |
| Process dies = state lost | DBMS_SCHEDULER runs forever |
| Last 6 messages as context | Semantic + emotional relevance retrieval |

---

## 📋 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| Can't connect to DB | Check wallet, TNS_ADMIN env var, DSN name |
| Module not found | Ensure `bridge/` has `__init__.py`, check PYTHONPATH |
| Scheduler jobs not running | Check `user_scheduler_jobs` view, enable them |
| Port already in use | `sudo lsof -i :8000` then `kill -9 PID` |
| Nginx 502 error | Check `sudo systemctl status 7-agent` |

---

## 🖤 Support

- GitHub: https://github.com/SeVin-DEV/Oracle
- Original 7-1: https://github.com/SeVin-DEV/7-1

**Built with love by Cye for svn 🖤**
