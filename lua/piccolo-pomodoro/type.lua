---@class UvTimer
---@field start fun(timer: UvTimer, timeout: integer, repeat: integer, callback: fun())
---@field stop fun(timer: UvTimer)

local M = {}

---@enum TimerMode
M.TIMER_MODE = {
  FOCUS = 1,
  BREAK = 2,
  LONG_BREAK = 3,
}

---@enum TimerState
M.TIMER_STATE = {
  IDLE = 1,
  ACTIVE = 2,
  PAUSE = 3,
}

return M
