-- Clipboard configuration for WSL
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        g = {
          clipboard = {
            name = "WslClipboard",
            copy = {
              ["+"] = "clip.exe",
              ["*"] = "clip.exe",
            },
            paste = {
              ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
          },
        },
      },
    },
  },
}