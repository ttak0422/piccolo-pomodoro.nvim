local M = {}

local Config = require("piccolo-pomodoro.config")
local Timer = require("piccolo-pomodoro.timer")
local Type = require("piccolo-pomodoro.type")

---@type fun(): Timer
local timer = (function()
  local instance = nil
  return function()
    if instance ~= nil then
      return instance
    else
      instance = Timer.new(Config.options)
      return instance
    end
  end
end)()

-- setup.
M.setup = function(opts)
  Config.setup(opts)
end

-- start pomodoro.
M.start = function()
  timer():start()
  Config.options.on_start()
end

-- pause pomodoro.
M.pause = function()
  timer():stop()
  Config.options.on_pause()
end

-- toggle pomodoro.
M.toggle = function()
  local status = timer():status()
  if status.timer_state == Type.TIMER_STATE.ACTIVE then
    M.pause()
  else
    M.start()
  end
end

-- reset current session.
M.reset = function()
  timer():reset()
end

-- skip current session.
M.skip = function()
  timer():skip()
end

-- get status.
---@return string
M.status = function()
  local status = timer():status()
  if status.timer_mode == Type.TIMER_MODE.FOCUS then
    return Config.options.focus_format({
      h = status.h,
      m = status.m,
      s = status.s,
      cycles = status.cycles,
      timer_mode = status.timer_mode,
      timer_state = status.timer_state,
    })
  else
    return Config.options.break_format({
      h = status.h,
      m = status.m,
      s = status.s,
      is_long_break = status.is_long_break,
      timer_mode = status.timer_mode,
      timer_state = status.timer_state,
    })
  end
end

-- print status.
M.print_status = function()
  print(M.status())
end

return M
