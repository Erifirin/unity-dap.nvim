# unity-dap.nvim

Adaptation of [Unity for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=VisualStudioToolsForUnity.vstuc)
for nvim.

> [!WARNING]
> Work in progress.
> The plugin is in development stage.

> [!Caution]
> You will be in breach of the license terms for the extension if you use it for Neovim development. To quote the license terms:
>
>> (a) Use with In-Scope Products and Services. You may install and use the Software only with Microsoft Visual Studio Code, vscode.dev, GitHub Codespaces (“Codespaces”) from GitHub, Inc. (“GitHub”), and successor Microsoft, GitHub, and other Microsoft affiliates’ products and services (collectively, the “In-Scope Products and Services”).

Tested in:

- Linux/Windows
- Unity: 2022.3, 6000.0
- Unity for Visual Studio Code: 1.1, 1.1.1, 1.1.2

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
    -- Path to vscode dotfiles.
    -- type: string | nil
    -- By default - nil. In this case the path will be resolved automatically.
    -- ($HOME/.vscode, $HOME/.vscode-oss)
    vscode_dotfiles_root = nil,

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
