#!/bin/bash

# MCP Container Orchestrator - Launch Script
# Spin up MCP servers on-demand from the registry

set -e

REGISTRY_FILE="$HOME/projects/terminal-work/config/mcp-registry.json"
MCP_NETWORK="terminal-work-mcp"
STATE_DIR="$HOME/.config/terminal-work/mcp"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Create state directory
mkdir -p "$STATE_DIR"

# Ensure MCP network exists
ensure_network() {
    if ! docker network inspect "$MCP_NETWORK" >/dev/null 2>&1; then
        echo -e "${BLUE}Creating MCP network: $MCP_NETWORK${NC}"
        docker network create "$MCP_NETWORK" >/dev/null
    fi
}

# Get MCP config from registry
get_mcp_config() {
    local mcp_name="$1"
    jq -r ".mcpServers.\"$mcp_name\"" "$REGISTRY_FILE"
}

# Check if MCP is already running
is_running() {
    local container_name="$1"
    docker ps --filter "name=$container_name" --format "{{.Names}}" 2>/dev/null | grep -q "^${container_name}$"
}

# Wait for health check
wait_for_health() {
    local container_name="$1"
    local health_endpoint="$2"
    local port="$3"
    local max_wait=60
    local elapsed=0

    echo -e "${YELLOW}Waiting for health check...${NC}"

    while [ $elapsed -lt $max_wait ]; do
        if curl -sf "http://localhost:${port}${health_endpoint}" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ MCP is healthy${NC}"
            return 0
        fi

        sleep 2
        elapsed=$((elapsed + 2))
        echo -n "."
    done

    echo -e "${RED}✗ Health check timeout${NC}"
    return 1
}

# Launch MCP container
launch_mcp() {
    local mcp_name="$1"

    # Get config
    local config=$(get_mcp_config "$mcp_name")

    if [ "$config" == "null" ]; then
        echo -e "${RED}Error: MCP '$mcp_name' not found in registry${NC}"
        echo "Available MCPs: $(jq -r '.mcpServers | keys[]' "$REGISTRY_FILE" | tr '\n' ' ')"
        exit 1
    fi

    # Parse config
    local image=$(echo "$config" | jq -r '.image // empty')
    local container_name=$(echo "$config" | jq -r '.containerName // empty')
    local port=$(echo "$config" | jq -r '.port')
    local health_endpoint=$(echo "$config" | jq -r '.healthEndpoint // "/health"')
    local mcp_display_name=$(echo "$config" | jq -r '.name')
    local managed_externally=$(echo "$config" | jq -r '.managedExternally // false')

    # Set container name
    if [ -z "$container_name" ]; then
        container_name="mcp-${mcp_name}"
    fi

    # Check if managed externally (like Archon-MCP)
    if [ "$managed_externally" == "true" ]; then
        echo -e "${YELLOW}$mcp_display_name is managed externally${NC}"
        if is_running "$container_name"; then
            echo -e "${GREEN}✓ Already running on port $port${NC}"
        else
            echo -e "${RED}✗ Not running - please start it manually${NC}"
        fi
        return 0
    fi

    # Check if already running
    if is_running "$container_name"; then
        echo -e "${GREEN}$mcp_display_name is already running${NC}"
        echo -e "${CYAN}Container:${NC} $container_name"
        echo -e "${CYAN}Port:${NC} $port"
        echo -e "${CYAN}Endpoint:${NC} http://localhost:$port"
        return 0
    fi

    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}           Launching MCP: $mcp_display_name${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Image:${NC} $image"
    echo -e "${CYAN}Container:${NC} $container_name"
    echo -e "${CYAN}Port:${NC} $port"
    echo ""

    # Ensure network exists
    ensure_network

    # Build environment variables
    local env_args=""
    local env_vars=$(echo "$config" | jq -r '.env // {} | to_entries[] | "-e \(.key)=\(.value)"')
    if [ -n "$env_vars" ]; then
        env_args="$env_vars"
    fi

    # Pull image if needed
    echo -e "${YELLOW}Pulling image (if not cached)...${NC}"
    if docker pull "$image" 2>&1 | grep -q "Error"; then
        echo -e "${YELLOW}⚠️  Could not pull image - will use local cache or fail${NC}"
    fi

    # Launch container
    echo -e "${YELLOW}Starting container...${NC}"
    docker run -d \
        --name "$container_name" \
        --network "$MCP_NETWORK" \
        -p "${port}:${port}" \
        --restart unless-stopped \
        $env_args \
        "$image" >/dev/null

    # Save state
    echo "{\"name\":\"$mcp_name\",\"container\":\"$container_name\",\"port\":$port,\"startedAt\":\"$(date -Iseconds)\"}" > "$STATE_DIR/${mcp_name}.json"

    # Wait for health check
    if ! wait_for_health "$container_name" "$health_endpoint" "$port"; then
        echo -e "${RED}MCP failed to become healthy${NC}"
        echo -e "${YELLOW}Showing logs:${NC}"
        docker logs "$container_name" | tail -20
        exit 1
    fi

    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ MCP Launched Successfully${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Endpoint:${NC} http://localhost:$port"
    echo -e "${CYAN}Health:${NC} http://localhost:$port${health_endpoint}"
    echo -e "${CYAN}Container:${NC} $container_name"
    echo ""
    echo -e "${YELLOW}Stop with:${NC} mcp-stop $mcp_name"
    echo -e "${YELLOW}View logs:${NC} docker logs $container_name"
    echo ""
}

# Show usage
show_usage() {
    echo ""
    echo -e "${CYAN}MCP Container Orchestrator - Launch${NC}"
    echo ""
    echo "Usage: mcp-launch <mcp-name>"
    echo ""
    echo "Available MCPs:"
    jq -r '.mcpServers | to_entries[] | "  • \(.key) - \(.value.description)"' "$REGISTRY_FILE"
    echo ""
    echo "Examples:"
    echo "  mcp-launch docker-hub       # Launch Docker Hub MCP"
    echo "  mcp-launch playwright       # Launch Playwright MCP"
    echo "  mcp-launch perplexity       # Launch Perplexity MCP"
    echo "  mcp-launch youtube-transcript  # Launch YouTube Transcript MCP"
    echo ""
}

# Main
if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

MCP_NAME="$1"
launch_mcp "$MCP_NAME"
