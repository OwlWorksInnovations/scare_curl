#!/usr/bin/env node

const express = require('express');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.status(200).setHeader('Content-Type', 'text/html; charset=utf-8');
    res.setHeader('Cache-Control', 'no-cache');

    res.write(`<!DOCTYPE html>
<html>
<head>
    <title>Scare Stream</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background-color: #000;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Courier New', monospace;
        }
        .terminal {
            width: 100%;
            max-width: 900px;
            padding: 20px;
        }
        .header {
            color: #0f0;
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .instructions {
            color: #666;
            text-align: center;
            margin-bottom: 10px;
            font-size: 12px;
        }
        pre {
            color: #0f0;
            font-size: 12px;
            line-height: 1.2;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <div class="terminal">
        <div class="header">╔═══════════════════════════════════════════════════════════════╗</div>
        <div class="header">║  Run with: curl https://your-domain.com/raw               ║</div>
        <div class="header">╚═══════════════════════════════════════════════════════════════╝</div>
        <div class="instructions">Terminal: curl https://your-domain.com/raw</div>
        <pre id="output"></pre>
    </div>
    <script>
        const eventSource = new EventSource('/stream');
        eventSource.onmessage = function(e) {
            document.getElementById('output').textContent += e.data;
            window.scrollTo(0, document.body.scrollHeight);
        };
    </script>
</body>
</html>`);
    res.end();
});

app.get('/stream', (req, res) => {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders();

    const scriptPath = path.join(__dirname, 'scare.sh');
    const child = spawn('bash', [scriptPath], {
        env: { ...process.env, TERM: 'dumb' }
    });

    child.stdout.on('data', (data) => {
        res.write(`data: ${data}\n\n`);
    });

    child.stderr.on('data', (data) => {
        res.write(`data: ${data}\n\n`);
    });

    child.on('close', (code) => {
        res.write(`data: \n\n[+] Stream ended. Run again with: curl ${req.headers.host}/stream\n\n`);
        res.end();
    });

    req.on('close', () => {
        child.kill();
    });
});

app.get('/raw', (req, res) => {
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    res.setHeader('Cache-Control', 'no-cache');

    const scriptPath = path.join(__dirname, 'scare.sh');
    const child = spawn('bash', [scriptPath], {
        env: { ...process.env, TERM: 'dumb' }
    });

    child.stdout.pipe(res);
    child.stderr.pipe(res);

    child.on('close', (code) => {
        res.end();
    });
});

app.get('/favicon.ico', (req, res) => {
    res.status(204).send();
});

app.listen(PORT, () => {
    console.log(`Scare server running on port ${PORT}`);
    console.log(`curl localhost:${PORT}/raw`);
});
