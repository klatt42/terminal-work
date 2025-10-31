#!/bin/bash

# Markdown to HTML Viewer
# Converts markdown input to styled HTML and opens in browser

HTML_DIR="$HOME/projects/terminal-work/superdesign/design_iterations"
OUTPUT_FILE="$HTML_DIR/md-viewer-$(date +%s).html"
VIEWER_INDEX="$HTML_DIR/md-viewer-latest.html"
PYTHON_CONVERTER="$HOME/projects/terminal-work/scripts/md2html.py"

# Check if Python converter exists
if [ ! -f "$PYTHON_CONVERTER" ]; then
    echo "Error: Python converter not found at $PYTHON_CONVERTER"
    exit 1
fi

# Generate HTML using Python script
if [ -n "$1" ] && [ -f "$1" ]; then
    # File argument provided
    python3 "$PYTHON_CONVERTER" "$1" > "$OUTPUT_FILE"
else
    # Read from stdin
    python3 "$PYTHON_CONVERTER" > "$OUTPUT_FILE"
fi

# Create symlink to latest
cd "$HTML_DIR"
ln -sf "$(basename "$OUTPUT_FILE")" "$(basename "$VIEWER_INDEX")"
cd - > /dev/null

# Open in browser
echo "✓ HTML generated: $(basename "$OUTPUT_FILE")"
echo "✓ Opening in browser..."

xdg-open "http://localhost:8888/$(basename "$OUTPUT_FILE")" 2>/dev/null || \
    echo "⚠️  Could not open browser. Manual URL: http://localhost:8888/$(basename "$OUTPUT_FILE")"

echo ""
echo "View at: http://localhost:8888/$(basename "$OUTPUT_FILE")"
echo "Latest:  http://localhost:8888/md-viewer-latest.html"
