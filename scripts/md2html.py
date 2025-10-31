#!/usr/bin/env python3
"""
Simple Markdown to HTML converter
"""
import sys
import re
from datetime import datetime
from pathlib import Path

def convert_markdown(text):
    """Convert markdown text to HTML"""
    lines = text.split('\n')
    html_lines = []
    in_code_block = False

    for line in lines:
        # Code blocks
        if line.startswith('```'):
            if in_code_block:
                html_lines.append('</code></pre>')
                in_code_block = False
            else:
                lang = line[3:].strip() or 'plaintext'
                html_lines.append(f'<pre class="code-block"><code class="language-{lang}">')
                in_code_block = True
            continue

        if in_code_block:
            html_lines.append(line)
            continue

        # Escape HTML
        line = line.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')

        # Headers
        if line.startswith('######'):
            line = re.sub(r'^######\s+(.+)$', r'<h6>\1</h6>', line)
        elif line.startswith('#####'):
            line = re.sub(r'^#####\s+(.+)$', r'<h5>\1</h5>', line)
        elif line.startswith('####'):
            line = re.sub(r'^####\s+(.+)$', r'<h4>\1</h4>', line)
        elif line.startswith('###'):
            line = re.sub(r'^###\s+(.+)$', r'<h3>\1</h3>', line)
        elif line.startswith('##'):
            line = re.sub(r'^##\s+(.+)$', r'<h2>\1</h2>', line)
        elif line.startswith('#'):
            line = re.sub(r'^#\s+(.+)$', r'<h1>\1</h1>', line)

        # Bold and italic
        line = re.sub(r'\*\*\*([^*]+)\*\*\*', r'<strong><em>\1</em></strong>', line)
        line = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', line)
        line = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', line)

        # Inline code
        line = re.sub(r'`([^`]+)`', r'<code class="inline-code">\1</code>', line)

        # Links
        line = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2" target="_blank">\1</a>', line)

        # Horizontal rules
        if line.strip() == '---':
            line = '<hr>'
        elif re.match(r'^═+$', line.strip()):
            line = '<hr class="double">'

        # Lists
        if re.match(r'^[•\-\*]\s+', line):
            line = re.sub(r'^[•\-\*]\s+(.+)$', r'<li>\1</li>', line)

        # Checkboxes
        line = re.sub(r'^- \[ \] (.+)$', r'<li class="todo">☐ \1</li>', line)
        line = re.sub(r'^- \[x\] (.+)$', r'<li class="done">☑ \1</li>', line)

        # Blockquotes
        if line.startswith('>'):
            line = re.sub(r'^>\s+(.+)$', r'<blockquote>\1</blockquote>', line)

        # Empty lines
        if not line.strip():
            line = '<br>'

        html_lines.append(line)

    return '\n'.join(html_lines)

def generate_html(title, content):
    """Generate full HTML page"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - MD Viewer</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #e4e4e7;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            padding: 2rem;
        }}

        .container {{
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(30, 41, 59, 0.6);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 3rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(148, 163, 184, 0.1);
        }}

        .header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #3b82f6;
        }}

        .title {{
            font-size: 2rem;
            color: #60a5fa;
            font-weight: 700;
        }}

        .timestamp {{
            color: #94a3b8;
            font-size: 0.9rem;
        }}

        .content {{
            color: #e4e4e7;
            font-size: 1rem;
            line-height: 1.8;
        }}

        h1, h2, h3, h4, h5, h6 {{
            color: #60a5fa;
            margin: 1.5rem 0 1rem 0;
            font-weight: 600;
        }}

        h1 {{ font-size: 2rem; border-bottom: 2px solid #3b82f6; padding-bottom: 0.5rem; }}
        h2 {{ font-size: 1.75rem; border-bottom: 1px solid #475569; padding-bottom: 0.5rem; }}
        h3 {{ font-size: 1.5rem; }}
        h4 {{ font-size: 1.25rem; }}
        h5 {{ font-size: 1.1rem; }}
        h6 {{ font-size: 1rem; }}

        .code-block {{
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 8px;
            padding: 1.5rem;
            overflow-x: auto;
            margin: 1.5rem 0;
            font-family: 'Fira Code', 'Courier New', monospace;
            font-size: 0.9rem;
            line-height: 1.5;
        }}

        .code-block code {{
            color: #86efac;
            display: block;
            white-space: pre;
        }}

        .inline-code {{
            background: #1e293b;
            color: #86efac;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-family: 'Fira Code', 'Courier New', monospace;
            font-size: 0.9em;
            border: 1px solid #334155;
        }}

        hr {{
            border: none;
            border-top: 1px solid #475569;
            margin: 2rem 0;
        }}

        hr.double {{
            border-top: 3px double #475569;
        }}

        ul, ol {{
            margin: 1rem 0 1rem 2rem;
        }}

        li {{
            margin: 0.5rem 0;
        }}

        li.todo {{
            list-style: none;
            color: #94a3b8;
        }}

        li.done {{
            list-style: none;
            color: #86efac;
            text-decoration: line-through;
        }}

        blockquote {{
            border-left: 4px solid #3b82f6;
            padding-left: 1rem;
            margin: 1.5rem 0;
            color: #94a3b8;
            font-style: italic;
        }}

        a {{
            color: #60a5fa;
            text-decoration: none;
            border-bottom: 1px solid transparent;
            transition: all 0.2s;
        }}

        a:hover {{
            border-bottom-color: #60a5fa;
        }}

        strong {{
            color: #fbbf24;
            font-weight: 600;
        }}

        em {{
            color: #a78bfa;
            font-style: italic;
        }}

        .footer {{
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #475569;
            text-align: center;
            color: #64748b;
            font-size: 0.9rem;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="title">{title}</div>
            <div class="timestamp">{timestamp}</div>
        </div>
        <div class="content">
{content}
        </div>
        <div class="footer">
            Generated by MD Viewer | Terminal-Work
        </div>
    </div>
</body>
</html>'''

if __name__ == '__main__':
    if len(sys.argv) > 1:
        # Read from file
        input_file = Path(sys.argv[1])
        title = input_file.stem
        markdown_text = input_file.read_text()
    else:
        # Read from stdin
        title = "Markdown Viewer"
        markdown_text = sys.stdin.read()

    html_content = convert_markdown(markdown_text)
    full_html = generate_html(title, html_content)
    print(full_html)
