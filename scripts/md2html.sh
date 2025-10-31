#!/bin/bash

# Markdown to HTML Viewer
# Converts markdown input to styled HTML and opens in browser

# Usage:
#   cat file.md | md2html
#   morning | md2html
#   md2html < report.md
#   md2html file.md

HTML_DIR="$HOME/projects/terminal-work/superdesign/design_iterations"
OUTPUT_FILE="$HTML_DIR/md-viewer-$(date +%s).html"
VIEWER_INDEX="$HTML_DIR/md-viewer-latest.html"

# Function to convert markdown to HTML (basic implementation)
convert_markdown() {
    local content="$1"

    # Escape HTML special characters in content first
    content=$(echo "$content" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

    # Convert markdown syntax (order matters!)
    # Headers
    content=$(echo "$content" | sed -E 's/^######\s+(.+)$/<h6>\1<\/h6>/g')
    content=$(echo "$content" | sed -E 's/^#####\s+(.+)$/<h5>\1<\/h5>/g')
    content=$(echo "$content" | sed -E 's/^####\s+(.+)$/<h4>\1<\/h4>/g')
    content=$(echo "$content" | sed -E 's/^###\s+(.+)$/<h3>\1<\/h3>/g')
    content=$(echo "$content" | sed -E 's/^##\s+(.+)$/<h2>\1<\/h2>/g')
    content=$(echo "$content" | sed -E 's/^#\s+(.+)$/<h1>\1<\/h1>/g')

    # Code blocks (preserve for later syntax highlighting)
    content=$(echo "$content" | awk '
        BEGIN { in_code = 0 }
        /^```/ {
            if (in_code) {
                print "</code></pre>"
                in_code = 0
            } else {
                lang = substr($0, 4)
                if (lang == "") lang = "plaintext"
                print "<pre class=\"code-block\"><code class=\"language-" lang "\">"
                in_code = 1
            }
            next
        }
        in_code { print; next }
        { print }
    ')

    # Inline code
    content=$(echo "$content" | sed -E 's/`([^`]+)`/<code class="inline-code">\1<\/code>/g')

    # Bold and italic
    content=$(echo "$content" | sed -E 's/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g')
    content=$(echo "$content" | sed -E 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g')
    content=$(echo "$content" | sed -E 's/\*([^*]+)\*/<em>\1<\/em>/g')

    # Links
    content=$(echo "$content" | sed -E 's/\[([^\]]+)\]\(([^)]+)\)/<a href="\2" target="_blank">\1<\/a>/g')

    # Horizontal rules
    content=$(echo "$content" | sed -E 's/^---$/<hr>/g')
    content=$(echo "$content" | sed -E 's/^═+$/<hr class="double">/g')

    # Lists (bullet points)
    content=$(echo "$content" | sed -E 's/^[•\-\*]\s+(.+)$/<li>\1<\/li>/g')

    # Checkboxes
    content=$(echo "$content" | sed -E 's/- \[ \] (.+)/<li class="todo">☐ \1<\/li>/g')
    content=$(echo "$content" | sed -E 's/- \[x\] (.+)/<li class="done">☑ \1<\/li>/g')

    # Blockquotes
    content=$(echo "$content" | sed -E 's/^>\s+(.+)$/<blockquote>\1<\/blockquote>/g')

    # Line breaks (preserve blank lines)
    content=$(echo "$content" | sed -E 's/^$/<br>/g')

    echo "$content"
}

# Read input (from pipe or file)
if [ -t 0 ]; then
    # No pipe, check for file argument
    if [ -n "$1" ] && [ -f "$1" ]; then
        INPUT=$(cat "$1")
        TITLE=$(basename "$1" .md)
    else
        echo "Usage: md2html [file.md] or pipe markdown content"
        echo "Examples:"
        echo "  cat report.md | md2html"
        echo "  morning | md2html"
        echo "  md2html STRATEGIC_ROADMAP.md"
        exit 1
    fi
else
    # Reading from pipe
    INPUT=$(cat)
    TITLE="Markdown Viewer"
fi

# Convert markdown to HTML
HTML_CONTENT=$(convert_markdown "$INPUT")

# Generate full HTML page with styling
cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
EOF

echo "    <title>$TITLE - MD Viewer</title>" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #e4e4e7;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(30, 41, 59, 0.6);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 3rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(148, 163, 184, 0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #3b82f6;
        }

        .title {
            font-size: 2rem;
            color: #60a5fa;
            font-weight: 700;
        }

        .timestamp {
            color: #94a3b8;
            font-size: 0.9rem;
        }

        .content {
            color: #e4e4e7;
            font-size: 1rem;
            line-height: 1.8;
        }

        h1, h2, h3, h4, h5, h6 {
            color: #60a5fa;
            margin: 1.5rem 0 1rem 0;
            font-weight: 600;
        }

        h1 { font-size: 2rem; border-bottom: 2px solid #3b82f6; padding-bottom: 0.5rem; }
        h2 { font-size: 1.75rem; border-bottom: 1px solid #475569; padding-bottom: 0.5rem; }
        h3 { font-size: 1.5rem; }
        h4 { font-size: 1.25rem; }
        h5 { font-size: 1.1rem; }
        h6 { font-size: 1rem; }

        p {
            margin: 1rem 0;
        }

        .code-block {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 8px;
            padding: 1.5rem;
            overflow-x: auto;
            margin: 1.5rem 0;
            font-family: 'Fira Code', 'Courier New', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .code-block code {
            color: #86efac;
            display: block;
            white-space: pre;
        }

        .inline-code {
            background: #1e293b;
            color: #86efac;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-family: 'Fira Code', 'Courier New', monospace;
            font-size: 0.9em;
            border: 1px solid #334155;
        }

        hr {
            border: none;
            border-top: 1px solid #475569;
            margin: 2rem 0;
        }

        hr.double {
            border-top: 3px double #475569;
        }

        ul, ol {
            margin: 1rem 0 1rem 2rem;
        }

        li {
            margin: 0.5rem 0;
            list-style-position: outside;
        }

        li.todo {
            list-style: none;
            color: #94a3b8;
        }

        li.done {
            list-style: none;
            color: #86efac;
            text-decoration: line-through;
        }

        blockquote {
            border-left: 4px solid #3b82f6;
            padding-left: 1rem;
            margin: 1.5rem 0;
            color: #94a3b8;
            font-style: italic;
        }

        a {
            color: #60a5fa;
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: all 0.2s;
        }

        a:hover {
            border-bottom-color: #60a5fa;
        }

        strong {
            color: #fbbf24;
            font-weight: 600;
        }

        em {
            color: #a78bfa;
            font-style: italic;
        }

        .footer {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #475569;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            .container {
                padding: 1.5rem;
            }
            .title {
                font-size: 1.5rem;
            }
        }

        /* Print styles */
        @media print {
            body {
                background: white;
                color: black;
            }
            .container {
                box-shadow: none;
                border: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
EOF

echo "            <div class=\"title\">$TITLE</div>" >> "$OUTPUT_FILE"
echo "            <div class=\"timestamp\">$(date '+%Y-%m-%d %H:%M:%S')</div>" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
        </div>
        <div class="content">
EOF

echo "$HTML_CONTENT" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'EOF'
        </div>
        <div class="footer">
            Generated by MD Viewer | Terminal-Work
        </div>
    </div>
</body>
</html>
EOF

# Create symlink to latest
ln -sf "$(basename "$OUTPUT_FILE")" "$VIEWER_INDEX"

# Open in browser
echo "✓ HTML generated: $(basename "$OUTPUT_FILE")"
echo "✓ Opening in browser..."

# Use the same HTTP server as dashboard (port 8888)
xdg-open "http://localhost:8888/$(basename "$OUTPUT_FILE")" 2>/dev/null || \
    echo "⚠️  Could not open browser. Manual URL: http://localhost:8888/$(basename "$OUTPUT_FILE")"

echo ""
echo "View at: http://localhost:8888/$(basename "$OUTPUT_FILE")"
echo "Latest:  http://localhost:8888/md-viewer-latest.html"
