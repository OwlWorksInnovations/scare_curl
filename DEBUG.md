Check Railway logs:

1. Go to https://railway.app/dashboard
2. Select your project → scarecurl service
3. Click "Logs" tab

Or use Railway CLI:
```bash
npm i -g railway
railway login
railway logs --service scarecurl
```

Common issues:
- PORT env var not set (server listens on wrong port)
- Missing express dependency
- bash not available in container

Let me update the server to use the PORT env var Railway provides:
