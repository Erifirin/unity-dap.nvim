---@class UnityDap.Config
---@field attach_probe_cmd string[]? Command to run UnityAttachProbe.
---@field debug_adapter_cmd string[]? Command ro run Unity debug adapter.
---@field log_file string? Path to log file

---@class UnityDap.InternalConfig
---@field attach_probe_cmd string[] Command to run UnityAttachProbe.
---@field debug_adapter_cmd string[] Command ro run Unity debug adapter.
---@field log_file string Path to log file

-- ------------------------------------------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------------------------------------------

local vstu = {}

---Returns path to Unity for Visual Studio Code extension
---or nil if it not installed.
---@return string?
local function get_vstu_path()
    if not vstu.resolved then
        vstu.path = require("vscode-tools.extensions").find_extension_path("visualstudiotoolsforunity.vstuc")
        vstu.resolved = true
        if vstu.path == nil then
            vim.notify(
                "Unity for Visual Studio Code extension not installed.",
                vim.log.levels.ERROR,
                { title = "unity-dap.nvim" }
            )
        end
    end

    return vstu.path
end

---Returns default command to run UnityAttachProbe.
---@return string[]?
local function get_default_attach_probe_cmd()
    local path = get_vstu_path()
    return path and { "dotnet", vim.fs.joinpath(path, "bin", "UnityAttachProbe.dll") } or nil
end

---Returns default command ro run Unity debug adapter
---@return string[]?
local function get_default_debug_adapter_cmd()
    local path = get_vstu_path()
    return path and { "dotnet", vim.fs.joinpath(path, "bin", "UnityDebugAdapter.dll") } or nil
end

---Returns full path to default log file
---@return string
local function get_default_log_file()
    local path = vim.fn.stdpath("log") --[[@as string]]
    return vim.fs.joinpath(path, "unity-dap.log")
end

-- ------------------------------------------------------------------------------------------------
-- Setup
-- ------------------------------------------------------------------------------------------------

local M = {}

---@type UnityDap.InternalConfig
local config = {
    attach_probe_cmd = nil, --[[@diagnostic disable-line]] -- for lazy auto resolve
    debug_adapter_cmd = nil, --[[@diagnostic disable-line]] -- for lazy auto resolve
    log_file = get_default_log_file(),
}
-- M.config = {
--     attach_probe_cmd = nil, --[[@diagnostic disable-line]] -- for lazy auto resolve
--     debug_adapter_cmd = nil, --[[@diagnostic disable-line]] -- for lazy auto resolve
--     log_file = get_default_log_file(),
-- }

---Extends default config with custom options and checks whether the plugin can works.
---@param opts UnityDap.Config? Custom config options
---@return UnityDap.InternalConfig? # Internal config or nil if something went wrong.
function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})

    -- try resolve UnityAttachProbe
    if config.attach_probe_cmd == nil then
        local path = get_default_attach_probe_cmd()
        if not path then
            return nil
        end
        config.attach_probe_cmd = path
    end

    -- try resolve UnityAttachProbe
    if config.debug_adapter_cmd == nil then
        local path = get_default_debug_adapter_cmd()
        if not path then
            return nil
        end
        config.debug_adapter_cmd = path
    end

    return config
end

---Returns current config
---@return UnityDap.InternalConfig
function M.get_current_config()
    return config
end

return setmetatable(M, {
    __index = function(_, k)
        return config[k]
    end,
})
