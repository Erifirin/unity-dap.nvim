local M = {}

M.setup = function()
    local extensions = require("unity-dap.vscode.extensions")
    local ex_root = extensions.find_extension_path("visualstudiotoolsforunity.vstuc")
    if ex_root == nil then
        vim.notify("Unity Debug Adapter not found.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
        return
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local logFile = vim.fs.joinpath(vim.fn.stdpath("log"), "unity-dap.log")

    local dap = require("dap")
    dap.adapters.unity = {
        type = "executable",
        command = "dotnet",
        args = { vim.fs.joinpath(ex_root, "bin", "UnityDebugAdapter.dll") },
        name = "Attach to Unity Engine",
    }

    dap.configurations.cs = {
        {
            type = "unity",
            request = "attach",
            name = "Attach to Unity Engine",
            logFile = logFile,
            endPoint = function()
                local unity_info = require("unity-dap.resolvers").get_unity_process()
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
                local path = require("unity-dap.resolvers").get_project_root_path()
                if path == nil then
                    vim.notify("Failed to get project root path.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
                    return ""
                end
                return path
            end,
        },
    }
end

return M
