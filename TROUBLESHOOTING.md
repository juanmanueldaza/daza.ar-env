# Troubleshooting Guide for daza.ar-env

This guide covers common issues you might encounter when setting up and using the daza.ar-env development environment.

## Quick Diagnostics

First, run the provided scripts for automated checks:

```bash
./setup.sh   # Checks prerequisites and sets up your environment
./status.sh  # Checks project health and running servers
```

If a script reports an error, refer to the relevant section below for solutions.

## Common Issues

- If `setup.sh` or `status.sh` reports a missing tool, follow the installation instructions in the script output.
- For authentication errors, run:
  ```bash
  gh auth login
  # Follow the prompts to authenticate
  gh auth status  # Verify authentication
  ```
- For permission errors, make scripts executable:
  ```bash
  chmod +x setup.sh dev.sh workflow.sh
  ./setup.sh
  ```
- For missing directories or dependencies, follow the script’s suggestions or see the detailed solutions below.

### 1. Setup Script Fails

#### Problem: "Command 'gh' not found"

**Solution:**

1. Install GitHub CLI: https://cli.github.com/
2. For Ubuntu/Debian: `sudo apt install gh`
3. For macOS: `brew install gh`
4. For Windows: Download from GitHub CLI website

#### Problem: "GitHub CLI not authenticated"

**Solution:**

```bash
gh auth login
# Follow the prompts to authenticate
gh auth status  # Verify authentication
```

#### Problem: "Permission denied" when running setup.sh

**Solution:**

```bash
chmod +x setup.sh dev.sh workflow.sh
./setup.sh
```

#### Problem: "Failed to clone repository"

**Possible causes and solutions:**

1. **Network issues**: Check your internet connection
2. **Authentication**: Run `gh auth login` again
3. **Repository access**: Verify the repository exists and is accessible
4. **Git configuration**: Check `git config --list`

### 2. Development Server Issues

#### Problem: "Sites directory not found"

**Solution:**

```bash
# Run setup first
./setup.sh

# Or manually create and clone
mkdir sites
cd sites
gh repo clone juanmanueldaza/cv
gh repo clone juanmanueldaza/onepager
# ... etc for all repos
```

#### Problem: "UNMET DEPENDENCY vite@^7.0.0"

**Solution:**

```bash
npm install
# or
npm install vite@^7.0.0
```

#### Problem: "Cannot start development servers"

**Solution:**

1. Check if sites directory exists: `ls -la sites/`
2. Check if each site has proper structure:
   ```bash
   cd sites/cv
   ls -la  # Should contain package.json, index.html, etc.
   ```
3. Install dependencies in each site:
   ```bash
   cd sites/cv && npm install
   cd ../onepager && npm install
   # Repeat for all sites
   ```

#### Problem: "Port already in use"

**Solution:**

1. Check what's using the ports:
   ```bash
   lsof -i :3001
   lsof -i :3002
   # ... etc
   ```
2. Kill the processes:
   ```bash
   pkill -f "vite.*3001"
   # or
   kill -9 [PID]
   ```

### 3. Domain Resolution Issues

#### Problem: "cv.local" doesn't resolve in browser

**Solution:**

1. Check `/etc/hosts` file:
   ```bash
   grep "\.local" /etc/hosts
   ```
2. If missing, add manually:
   ```bash
   sudo nano /etc/hosts
   # Add these lines:
   127.0.0.1   cv.local
   127.0.0.1   onepager.local
   127.0.0.1   start.local
   127.0.0.1   navbar.local
   127.0.0.1   mdsite.local
   127.0.0.1   data.local
   127.0.0.1   wallpapers.local
   ```
3. Flush DNS cache:
   - **Linux**: `sudo systemctl flush-dns` or `sudo /etc/init.d/networking restart`
   - **macOS**: `sudo dscacheutil -flushcache`
   - **Windows**: `ipconfig /flushdns`

#### Problem: Browser shows "This site can't be reached"

**Solution:**

1. Verify the dev server is running: `ps aux | grep vite`
2. Check if the port is listening: `netstat -tulpn | grep :3001`
3. Try accessing via localhost: `http://localhost:3001`
4. Restart your browser after modifying `/etc/hosts`

### 4. Configuration Issues

#### Problem: "Cannot resolve module" errors

**Solution:**

1. Check if using correct module system:
   - Ensure `package.json` has `"type": "module"`
   - Use ES6 imports: `import { something } from 'module'`
2. Update vite.config.js to use ES modules
3. Clear node_modules and reinstall:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

#### Problem: "Vite config is not working"

**Solution:**

1. Check vite.config.js syntax:
   ```bash
   node -c vite.config.js
   ```
2. Ensure all referenced files exist:
   ```bash
   ls sites/*/index.html
   ```

### 5. Script Execution Issues

#### Problem: "workflow.sh fails with merge conflicts"

**Solution:**

1. Check current git status: `git status`
2. Resolve conflicts manually:
   ```bash
   git add .
   git commit -m "resolve conflicts"
   ```
3. Ensure working directory is clean before running workflow.sh

#### Problem: "Permission denied" on script execution

**Solution:**

```bash
chmod +x *.sh
```

### 6. Performance Issues

#### Problem: "Vite is slow to start"

**Solution:**

1. Enable polling in vite.config.js (already configured)
2. Exclude node_modules from file watching:
   ```javascript
   server: {
     watch: {
       ignored: ['**/node_modules/**'];
     }
   }
   ```
3. Close unnecessary browser tabs
4. Check available disk space: `df -h`

#### Problem: "High CPU usage"

**Solution:**

1. Limit concurrent dev servers:
   ```bash
   # Start only specific sites
   npm run dev:cv
   npm run dev:onepager
   ```
2. Use `--no-open` flag to prevent auto-opening browsers
3. Monitor with: `htop` or `top`

## Environment-Specific Issues

### Linux/WSL

- **Issue**: Permission issues with /etc/hosts
- **Solution**: Use `sudo` for hosts file modification, or run setup.sh as root

### macOS

- **Issue**: Firewall blocking local connections
- **Solution**: System Preferences > Security & Privacy > Firewall > Allow Vite

### Windows

- **Issue**: .local domains not resolving
- **Solution**: Use Windows host file at `C:\Windows\System32\drivers\etc\hosts`

## Debugging Steps

### 1. Check System Requirements

```bash
# Node.js version
node --version  # Should be v18+

# Available memory
free -h

# Disk space
df -h
```

### 2. Verbose Logging

```bash
# Run with debug output
DEBUG=vite:* npm run dev:cv

# Git operations
GIT_TRACE=1 git status
```

### 3. Clean Reset

```bash
# Nuclear option: start fresh
npm run clean  # or rm -rf sites/ node_modules/
./setup.sh
npm install
npm run dev
```

## Getting Help

If none of these solutions work:

1. **Check GitHub Issues**: https://github.com/juanmanueldaza/daza.ar-env/issues
2. **Create a New Issue**: Include:
   - Operating system and version
   - Node.js version (`node --version`)
   - Complete error messages
   - Steps to reproduce
   - Output of `npm run check`

3. **Useful Debug Information**:
   ```bash
   # Create a debug report
   echo "=== System Info ===" > debug.txt
   uname -a >> debug.txt
   node --version >> debug.txt
   npm --version >> debug.txt
   gh --version >> debug.txt
   echo "" >> debug.txt
   echo "=== Project State ===" >> debug.txt
   ls -la >> debug.txt
   ls -la sites/ >> debug.txt
   npm ls >> debug.txt
   echo "" >> debug.txt
   echo "=== Git Status ===" >> debug.txt
   git status >> debug.txt
   cat debug.txt
   ```

## Prevention Tips

1. **Regular Updates**: Keep Node.js, npm, and GitHub CLI updated
2. **Clean Installs**: Periodically run `npm run clean` and reinstall
3. **Backup**: Keep a backup of your `/etc/hosts` file
4. **Documentation**: Document any custom modifications you make
5. **Environment Consistency**: Use the same Node.js version across team members

## Advanced Troubleshooting

### Network Diagnostics

```bash
# Test connectivity to GitHub
curl -I https://github.com

# Test local ports
telnet localhost 3001

# DNS resolution
nslookup cv.local
```

### Process Management

```bash
# Find all Vite processes
ps aux | grep vite

# Kill all Node processes (careful!)
pkill -f node

# Monitor system resources
htop
```

### Log Analysis

```bash
# Check system logs
journalctl -f  # Linux
tail -f /var/log/system.log  # macOS

# Check npm logs
npm config get logs-dir
```

---

**Last Updated**: December 2024  
**Version**: 1.0.0

For more information, see the main [README.md](README.md) or visit [daza.ar](https://daza.ar).
