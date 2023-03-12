---@class Hover
---@field contents MarkedString | MarkedString[] | MarkupContent
---@field range? Range

---@alias MarkedString string | { language: string, value: string }

---@class MarkupContent
---@field kind MarkupKind
---@field value string

---@alias MarkupKind "plaintext" | "markdown"

---@class Range
---@field start Position
---@field end Position

---@class Position
---@field line integer
---@field character integer
