local M = {}

---@class UnityProcessInfo SyntaxTree.VisualStudio.Unity.Messaging.UnityProcess
---@field processId integer
---@field address string
---@field machine string
---@field projectName string
---@field information string
---@field profilerPort integer
---@field debuggerPort integer
---@field messagerPort integer
---@field unityPlayer table SyntaxTree.VisualStudio.Unity.Messaging.UnityPlayer
---@field type string (Editor | Player)
---@field discoveryType string (Manual | Automatic | AutoConnect)
---@field debuggerEngine string (VSTU | CoreCLR)
---@field isBackground boolean
---@field isProcessDetection boolean
---@field displayType string
---@field displayConnection string
---@field isValidForAttachment boolean

---@class ProjectInfo
---@field process_id integer
---@field version string Unity version
---@field app_path string Path to Unity Editor executable binary
---@field app_contents_path string Path to Unity Editor Data

---Get list of Unity processes that available to work with
---@return UnityProcessInfo[]|nil
local function list_unity_processes()
    local config = require("unity-dap.config")
    local obj = vim.system(config.attach_probe_cmd, { text = true })
    local out = obj:wait(5000)

    if out.code ~= 0 then
        vim.notify(
            "Failed to call UnityAttachProbe.\n" .. out.stderr,
            vim.log.levels.ERROR,
            { title = "unity-dap.nvim" }
        )
        return nil
    end

    if out.stdout == nil or #out.stdout == 0 then
        vim.notify("Failed to find a running Unity Editor.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
        return nil
    end

    local rs = {}
    for line in out.stdout:gmatch("[^\n]+") do
        if line ~= "" then
            local json = vim.json.decode(line, { luanil = { object = true, array = true } })
            for _, item in ipairs(json) do
                table.insert(rs, item)
            end
        end
    end

    return rs
end

---Get project info
---@param path string Path to Unity project
---@return ProjectInfo?
local function get_project_info(path)
    path = vim.fs.joinpath(path, "Library", "EditorInstance.json")
    local file = io.open(path, "r")
    if file then
        local data = file:read("*a")
        local rs = vim.json.decode(data)
        io.close(file)
        return rs
    end
    return nil
end

---Returns project root path
---@param source? integer|string Number of buffer (0 = current) or path to a project file from which to start searching for the project root
---@return string?
function M.get_project_root_path(source)
    if source == nil then
        source = 0
    end

    local path = vim.fs.root(source, function(name, path)
        if name == "Assets" then
            local p = vim.fs.find({ "ProjectSettings", "Packages" }, { type = "directory", path = path, limit = 2 })
            return #p > 0
        end
        return false
    end)

    if path == nil then
        vim.notify("Failed to resolve the project root path.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
    end

    return path
end

---Returns Unity process info for project that contains specified source (file or buffer)
---@param source? integer|string Number of buffer (0 = current) or path to a project file from which to start searching for the project root
---@return UnityProcessInfo?
function M.get_unity_process(source)
    -- try get project root path
    local project_root_path = M.get_project_root_path(source)
    if project_root_path == nil then
        return nil
    end

    -- try get project info
    local project_info = get_project_info(project_root_path)
    if project_info == nil then
        vim.notify(
            "Failed to get Unity project data. Is project open?",
            vim.log.levels.ERROR,
            { title = "unity-dap.nvim" }
        )
        return nil
    end

    -- try get unity info
    local unity_processes = list_unity_processes()
    if unity_processes == nil then
        vim.notify(
            "Failed to find Unity Editor with the project. Is Unity running?",
            vim.log.levels.ERROR,
            { title = "unity-dap.nvim" }
        )
        return nil
    end

    -- try find relevant unity editor process
    ---@type UnityProcessInfo?
    local unity_info = nil
    for _, info in ipairs(unity_processes) do
        if info.processId == project_info.process_id then
            unity_info = info
            break
        end
    end

    if unity_info == nil then
        vim.notify(
            "Failed to find Unity Editor process with the project. Is project open?",
            vim.log.levels.ERROR,
            { title = "unity-dap.nvim" }
        )
        return nil
    end

    -- validate unity process
    if unity_info.debuggerEngine ~= "VSTU" then
        vim.notify(
            "Unity Debugger is running in unsupported mode '" .. "'. Expected 'VSTU'.",
            vim.log.levels.ERROR,
            { title = "unity-dap.nvim" }
        )
        return nil
    end

    if not unity_info.isValidForAttachment then
        vim.notify("Unity Editor doesn't allow to attach to.", vim.log.levels.ERROR, { title = "unity-dap.nvim" })
        return nil
    end

    return unity_info
end

return M
