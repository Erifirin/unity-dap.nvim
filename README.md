# unity-dap.nvim

Adaptation of [Unity for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=VisualStudioToolsForUnity.vstuc)
for nvim.

> [!WARNING]
> Work in progress.
> The plugin is in development stage.

Tested in:

- Unity: 2022.3
- Unity for Visual Studio Code: 1.1

## ⚡️ Requirements

- Neovim >= 0.10.0
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [Unity for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=VisualStudioToolsForUnity.vstuc) extension installed via VS Code
- .NET SDK installed and `dotnet` command available

Also recommended [roslyn.nvim](https://github.com/seblyng/roslyn.nvim) language server.

## Demo

TODO

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "erifirin/unity-dap.nvim",
    opts = {
        -- your configuration; leave empty for default settings
    }
}
```

## ⚙️ Configuration

By default the plugin starts with following settings:

```lua
{
    -- Command to run UnityAttachProbe.
    -- type: string[] | nil
    -- By default - nil. In this case the plugin will use UnityAttachProbe.dll shipped with
    -- Unity for Visual Studio Code extension (should be pre-installed).
    attach_probe_cmd = nil,

    -- Command to run Unity debug adapter.
    -- type: string[] | nil
    -- By default - nil. In this case the plugin will use UnityDebugAdapter.dll shipped with
    -- Unity for Visual Studio Code extension (should be pre-installed).
    debug_adapter_cmd = nil,

    -- Log file.
    -- type: string
    -- By default - unity-dap.log located in vim logs default directory.
    log_file = ... ,
}
```

## Unity Setup

TODO: Maybe required to install [Visual Studio Editor](https://docs.unity3d.com/Packages/com.unity.ide.visualstudio@2.0/manual/index.html) package.
