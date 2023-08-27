local M = {}

---@class PomodoroFocusContext
---@field h integer
---@field m integer
---@field s integer
---@field cycles integer
---@field timer_mode TimerMode
---@field timer_state TimerState

---@class PomodoroBreakContext
---@field h integer
---@field m integer
---@field s integer
---@field is_long_break boolean
---@field timer_mode TimerMode
---@field timer_state TimerState

---@class PomodoroFocusCompleteContext

---@class PomodoroBreakCompleteContext
---@field is_long_break boolean

---@class PomodoroOpts
---@field focus_time integer
---@field break_time integer
---@field long_break_time integer
---@field long_break_interval integer|nil
---@field auto_start_breaks boolean
---@field auto_start_pomodoros boolean
---@field on_start fun()
---@field on_update fun()
---@field on_pause fun()
---@field on_complete_focus_time fun(ctx: PomodoroFocusCompleteContext)
---@field on_complete_break_time fun(ctx: PomodoroBreakCompleteContext)
---@field focus_format fun(ctx: PomodoroFocusContext):string
---@field break_format fun(ctx: PomodoroBreakContext):string

---@type PomodoroOpts
M.defaults = {
  focus_time = 25, -- minutes
  break_time = 5, -- minutes
  long_break_time = 15, -- minutes
  long_break_interval = 4,
  auto_start_breaks = false,
  auto_start_pomodoros = false,
  on_start = function() end,
  on_update = function() end,
  on_pause = function() end,
  on_complete_focus_time = function() end,
  on_complete_break_time = function() end,
  focus_format = function(ctx)
    return string.format("ﲊ focus %02d:%02d:%02d", ctx.h, ctx.m, ctx.s)
  end,
  break_format = function(ctx)
    return string.format("ﲊ break %02d:%02d:%02d", ctx.h, ctx.m, ctx.s)
  end,
}

---@type PomodoroOpts
M.options = {}

function M.setup(ops)
  M.options = vim.tbl_deep_extend("force", M.defaults, ops or {})
end

return M
