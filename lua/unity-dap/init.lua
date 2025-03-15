local M = {}

---Setup plugin
---@param opts UnityDap.Config?
M.setup = function(opts)
    local config = require("unity-dap.config").setup(opts)
    if config == nil then
        vim.notify("Failed to setup.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
        return
    end

    local resolvers = require("unity-dap.resolvers")
    local dap = require("dap")
    local da_cmd = config.debug_adapter_cmd[1]
    local da_args = vim.list_slice(config.debug_adapter_cmd, 2)

    dap.adapters.unity = {
        type = "executable",
        command = da_cmd,
        args = da_args,
        name = "Attach to Unity Engine",
    }

    dap.configurations.cs = {
        {
            type = "unity",
            request = "attach",
            name = "Attach to Unity Engine",
            logFile = config.log_file,
            endPoint = function()
                local unity_info = resolvers.get_unity_process()
                if unity_info == nil then
                    return ""
                end

                vim.notify(
                    "Connecting to " .. unity_info.displayConnection,
                    vim.log.levels.INFO,
                    { title = "unity-dap.nvim" }
                )
                return unity_info.address .. ":" .. unity_info.debuggerPort
            end,
            projectPath = function()
                local path = resolvers.get_project_root_path()
                return path or ""
            end,
        },
    }
end

return M
