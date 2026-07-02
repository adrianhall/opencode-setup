winget install -h --accept-package-agreements Microsoft.PowerShell
winget install -h --accept-package-agreements  OpenJS.NodeJS
winget install -h --accept-package-agreements  Git.Git
winget install -h --accept-package-agreements  Microsoft.VisualStudioCode
winget install -h --accept-package-agreements  Microsoft.VisualStudioCode.CLI
winget install -h --accept-package-agreements  Microsoft.WindowsTerminal
winget install -h --accept-package-agreements Google.Chrome
winget install -e --id Cloudflare.Warp

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

npm config set allow-scripts=opencode-ai --location=user
npm i -g opencode-ai
npx skills add cloudflare/skills -y -g

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

$opencodeConfig = @"
{
  "mcp": {
    "cloudflare": { 
        "type": "remote", 
        "url": "https://mcp.cloudflare.com/mcp", 
        "enabled": true 
    },
    "cloudflare-docs": { 
        "type": "remote", 
        "url": "https://docs.mcp.cloudflare.com/mcp", 
        "enabled": true 
    },
    "cloudflare-bindings": { 
        "type": "remote", 
        "url": "https://bindings.mcp.cloudflare.com/mcp", 
        "enabled": true 
    },
    "cloudflare-builds": { 
        "type": "remote", 
        "url": "https://builds.mcp.cloudflare.com/mcp", 
        "enabled": true 
    },
    "cloudflare-observability": { 
        "type": "remote", 
        "url": "https://observability.mcp.cloudflare.com/mcp", 
        "enabled": true 
    }
  }
}

"@

New-Item -Type Directory -Force ~/.config/opencode
New-Item -Path ~/.opencode.jsonc -ItemType File -Force -Value $opencodeConfig
New-Item -Path ~/.config/opencode/opencode.jsonc -ItemType File -Force -Value $opencodeConfig
