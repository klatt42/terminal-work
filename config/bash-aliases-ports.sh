#!/bin/bash
# Port Management Aliases for Multi-Project Development

# Port Manager Commands
alias ports='~/projects/terminal-work/scripts/port-manager.sh show'
alias ports-running='~/projects/terminal-work/scripts/port-manager.sh running'
alias ports-status='~/projects/terminal-work/scripts/port-manager.sh running'
alias port-check='~/projects/terminal-work/scripts/port-manager.sh check'
alias port-kill='~/projects/terminal-work/scripts/port-manager.sh kill'

# Quick Open Aliases (Incognito)
alias open-serp='~/projects/terminal-work/scripts/port-manager.sh open serp-master'
alias open-erp='~/projects/terminal-work/scripts/port-manager.sh open my-erp-plan'
alias open-rok='~/projects/terminal-work/scripts/port-manager.sh open rok-copilot'
alias open-prism='~/projects/terminal-work/scripts/port-manager.sh open prism-specialties-dmv-empire'
alias open-recipe='~/projects/terminal-work/scripts/port-manager.sh open recipe-keeper-app'

# Project-Specific Port Getters
alias serp-port='~/projects/terminal-work/scripts/port-manager.sh get serp-master frontend'
alias erp-port='~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend'
alias rok-port='~/projects/terminal-work/scripts/port-manager.sh get rok-copilot frontend'
alias prism-port='~/projects/terminal-work/scripts/port-manager.sh get prism-specialties-dmv-empire frontend'

# Quick Kill Common Ports
alias kill-3000='~/projects/terminal-work/scripts/port-manager.sh kill 3000'
alias kill-3001='~/projects/terminal-work/scripts/port-manager.sh kill 3001'
alias kill-3002='~/projects/terminal-work/scripts/port-manager.sh kill 3002'
alias kill-3003='~/projects/terminal-work/scripts/port-manager.sh kill 3003'
alias kill-8000='~/projects/terminal-work/scripts/port-manager.sh kill 8000'

# Development Server Starters with Port Management
start-serp() {
    cd ~/serp-master
    local frontend_port=$(~/projects/terminal-work/scripts/port-manager.sh get serp-master frontend)
    local backend_port=$(~/projects/terminal-work/scripts/port-manager.sh get serp-master backend)
    echo "Starting SERP Master - Frontend: $frontend_port, Backend: $backend_port"
    ./restart-project.sh
}

start-erp() {
    cd ~/projects/genesis-skills-test/my-erp-plan
    local port=$(~/projects/terminal-work/scripts/port-manager.sh get my-erp-plan frontend)
    echo "Starting My-ERP-Plan on port $port"
    PORT=$port npm run dev
}

start-rok() {
    cd ~/projects/rok-copilot
    local port=$(~/projects/terminal-work/scripts/port-manager.sh get rok-copilot frontend)
    echo "Starting ROK Copilot on port $port"
    PORT=$port npm run dev
}

start-prism() {
    cd ~/prism-specialties-dmv-empire
    local port=$(~/projects/terminal-work/scripts/port-manager.sh get prism-specialties-dmv-empire frontend)
    echo "Starting Prism Specialties on port $port"
    npx live-server public --port=$port
}

# Show help
ports-help() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PORT MANAGEMENT COMMANDS                        ║
╚══════════════════════════════════════════════════════════════╝

View Ports:
  ports                - Show all registered ports
  ports-running        - Show currently running services
  ports-status         - Alias for ports-running

Check & Kill:
  port-check <port>    - Check if port is in use
  port-kill <port>     - Kill service on port
  kill-3000            - Quick kill port 3000
  kill-3001            - Quick kill port 3001
  kill-3002            - Quick kill port 3002
  kill-3003            - Quick kill port 3003
  kill-8000            - Quick kill port 8000

Open Projects (Incognito):
  open-serp            - Open SERP Master
  open-erp             - Open My-ERP-Plan
  open-rok             - Open ROK Copilot
  open-prism           - Open Prism Specialties
  open-recipe          - Open Recipe Keeper

Get Port Numbers:
  serp-port            - Get SERP Master port
  erp-port             - Get My-ERP-Plan port
  rok-port             - Get ROK Copilot port
  prism-port           - Get Prism Specialties port

Start Servers:
  start-serp           - Start SERP Master with correct ports
  start-erp            - Start My-ERP-Plan with correct port
  start-rok            - Start ROK Copilot with correct port
  start-prism          - Start Prism Specialties with correct port

Examples:
  ports                # Show all port assignments
  ports-running        # See what's currently running
  open-erp             # Open My-ERP-Plan in incognito
  kill-3000            # Free up port 3000
  start-serp           # Start SERP Master

══════════════════════════════════════════════════════════════
EOF
}
