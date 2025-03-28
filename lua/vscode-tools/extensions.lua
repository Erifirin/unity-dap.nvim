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

---Returns version form path or nil.
---@param path string Path to extension.
---@return string? Version of the extension or nil.
local function get_version_from_path(path)
    path = vim.fs.basename(path)

    local ver = vim.fn.matchstr(path, "-[0-9.]*-")
    if ver ~= nil and ver ~= "" and ver ~= "--" then
        return string.sub(ver, 2, string.len(ver) - 1)
    end

    ver = vim.fn.matchstr(path, "-[0-9.]*$")
    if ver ~= nil and ver ~= "" and ver ~= "-" then
        return string.sub(ver, 2, string.len(ver))
    end

    return nil
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
        local ver = get_version_from_path(path)
        if ver ~= nil and (lastver == nil or vim.version.cmp(ver, lastver) > 0) then
            lastver = ver
            lastpath = path
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
