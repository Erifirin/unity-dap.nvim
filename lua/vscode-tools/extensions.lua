local M = {}

local dotfiles_path = vim.fs.joinpath(vim.env.HOME, ".vscode")
local extensions_path = vim.fs.joinpath(dotfiles_path, "extensions")

---Return all paths
---@param name string Extension name
---@return string[]
local function get_all_versions_paths(name)
    local search_pattern = vim.fs.joinpath(extensions_path, name .. "-*")
    ---@type string[]
    ---@diagnostic disable-next-line: assign-type-mismatch
    return vim.fn.expand(search_pattern, nil, true)
end

---Returns path with last version or nil
---@param paths? string[] list of paths to work with
---@return string?
local function get_last_version_path(paths)
    if paths == nil then
        return nil
    end

    local lastpath = nil
    local lastver = nil

    for _, path in ipairs(paths) do
        local ver = vim.fn.matchstr(path, "-[0-9.]*")
        if ver ~= "" then
            ver = string.sub(ver, 2, string.len(ver))
            if lastver == nil or vim.version.cmp(ver, lastver) > 0 then
                lastver = ver
                lastpath = path
            end
        end
    end

    return lastpath
end

---Returns path to specified extension or nil
---@param name string Extension name
---@return string?
function M.find_extension_path(name)
    local paths = get_all_versions_paths(name)
    return get_last_version_path(paths)
end

return M
