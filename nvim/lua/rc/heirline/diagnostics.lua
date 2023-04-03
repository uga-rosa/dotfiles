local conditions = require("heirline.conditions")

return {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = " ",
    warn_icon = " ",
    info_icon = " ",
    hint_icon = " ",
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  {
    provider = " \u{E0B0} ", -- [[ ]]
  },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors)
    end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self)
      return self.errors > 0 and self.warnings > 0 and " "
    end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings)
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and self.info > 0 and " "
    end,
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info)
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.info > 0 and self.hints > 0 and " "
    end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = "diag_hint" },
  },
}
