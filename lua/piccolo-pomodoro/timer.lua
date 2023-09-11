---@class Timer
---@field timer UvTimer
---@field mode TimerMode
---@field state TimerState
---@field timer_started_at integer
---@field cycle integer
---@field duration integer
---@field left_seconds integer
---@field focus_time integer
---@field break_time integer
---@field long_break_time integer
---@field long_break_interval integer|nil
---@field auto_start_breaks boolean
---@field auto_start_pomodoros boolean
---@field on_update fun()
---@field on_complete_focus_time fun(ctx: PomodoroFocusCompleteContext)
---@field on_complete_break_time fun(ctx: PomodoroBreakCompleteContext)
local Timer = {}

local Type = require("piccolo-pomodoro.type")

-- seconds to { hours, minutes, seconds }.
---@param seconds integer
---@return integer, integer, integer
local function seconds_to_hms(seconds)
  local h = math.floor(seconds / 3600)
  local m = math.floor(seconds / 60) % 60
  ---@type integer
  local s = seconds % 60
  return h, m, s
end

-- constructor.
---@param opts PomodoroOpts
---@return Timer
Timer.new = function(opts)
  ---@type Timer
  local self = setmetatable({}, { __index = Timer })
  ---@type UvTimer
  self.timer = vim.uv.new_timer()
  self.timer_started_at = os.time()
  self.cycle = 1

  self.focus_time = opts.focus_time
  self.break_time = opts.break_time
  self.long_break_time = opts.long_break_time
  self.long_break_interval = opts.long_break_interval
  self.auto_start_breaks = opts.auto_start_breaks
  self.auto_start_pomodoros = opts.auto_start_pomodoros
  self.on_update = opts.on_update
  self.on_complete_focus_time = opts.on_complete_focus_time
  self.on_complete_break_time = opts.on_complete_break_time

  self:set_mode(Type.TIMER_MODE.FOCUS)

  return self
end

-- set timer mode helper.
---@param self Timer
---@param mode TimerMode
Timer.set_mode = function(self, mode)
  self.mode = mode
  self.state = Type.TIMER_STATE.IDLE
  if mode == Type.TIMER_MODE.FOCUS then
    self.duration = self.focus_time * 60
  elseif mode == Type.TIMER_MODE.BREAK then
    self.duration = self.break_time * 60
  else
    self.duration = self.long_break_time * 60
  end
  self.left_seconds = self.duration
end

-- update timer.
---@param self Timer
Timer.update = function(self)
  self.left_seconds = math.max(self.duration - (os.time() - self.timer_started_at), 0)
  if self.left_seconds <= 0 then
    self:next()
  end
end

-- start timer.
---@param self Timer
Timer.start = function(self)
  if self.state == Type.TIMER_STATE.ACTIVE then
    -- ignore
    return
  end

  self.timer_started_at = os.time()
  self.timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      self:update()
      -- user defined action
      self.on_update()
    end)
  )
  self.state = Type.TIMER_STATE.ACTIVE
end

-- stop timer.
---@param self Timer
Timer.stop = function(self)
  if self.state ~= Type.TIMER_STATE.ACTIVE then
    -- ignore
    return
  end
  self.timer:stop()
  self.duration = math.max(self.duration - (os.time() - self.timer_started_at), 0)
  self.state = Type.TIMER_STATE.PAUSE
end

-- get current timer status.
---@param self Timer
---@return PomodoroFocusContext|PomodoroBreakContext
Timer.status = function(self)
  local h, m, s = seconds_to_hms(self.left_seconds)
  return {
    h = h,
    m = m,
    s = s,
    cycles = self.cycle,
    is_long_break = self.mode == Type.TIMER_MODE.LONG_BREAK,
    timer_mode = self.mode,
    timer_state = self.state,
  }
end


-- reset current session.
---@param self Timer
Timer.reset = function(self)
    self:stop()
    self:set_mode(self.mode)
end

-- skip current session.
---@param self Timer
Timer.skip = function(self)
  self:next()
end

-- move to next session.
---@param self Timer
Timer.next = function(self)
    local current_mode = self.mode

    self:stop()

    if current_mode == Type.TIMER_MODE.FOCUS then
      self.on_complete_focus_time({})
      if self.cycle % self.long_break_interval == 0 then
        self:set_mode(Type.TIMER_MODE.LONG_BREAK)
      else
        self:set_mode(Type.TIMER_MODE.BREAK)
      end
      if self.auto_start_breaks then
        self:start()
      end
    else
      self.on_complete_break_time({ is_long_break = self.mode == Type.TIMER_MODE.LONG_BREAK })
      self.cycle = self.cycle + 1
      self.mode = Type.TIMER_MODE.FOCUS
      self:set_mode(Type.TIMER_MODE.FOCUS)
      if self.auto_start_pomodoros then
        self:start()
      end
    end
end

return Timer
