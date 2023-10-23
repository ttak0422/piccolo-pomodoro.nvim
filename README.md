<div align="center">
  <h1>piccolo-pomodoro</h1>
  <img alt="neovim" src="https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white">
  <img alt="lua" src="https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white">
  <img alt="license" src="https://img.shields.io/github/license/ttak0422/piccolo-pomodoro.nvim?style=for-the-badge">
  <p>Minimal Pomodoro plugin written in pure Lua.</p>
</div>

## Usage

```lua
-- minimal setup
require("piccolo-pomodoro").setup()

-- default config
require("piccolo-pomodoro").setup({
  focus_time = 25, -- minutes
  break_time = 5, -- minutes
  long_break_time = 15, -- minutes
  long_break_interval = 4,
  auto_start_breaks = false,
  auto_start_pomodoros = false,

  ---@type fun()
  on_start = function() end,

  ---@type fun()
  on_update = function() end,

  ---@type fun()
  on_pause = function() end,

  ---@class PomodoroFocusCompleteContext
  ---@type fun(ctx: PomodoroFocusCompleteContext)
  on_complete_focus_time = function() end,

  ---@class PomodoroBreakCompleteContext
  ---@field is_long_break boolean
  ---@type fun(ctx: PomodoroBreakCompleteContext)
  on_complete_break_time = function() end,

  ---@class PomodoroFocusContext
  ---@field h integer
  ---@field m integer
  ---@field s integer
  ---@field cycles integer
  ---@field timer_mode TimerMode
  ---@field timer_state TimerState
  ---@type fun(ctx: PomodoroFocusContext):string
  focus_format = function(ctx)
    return string.format("󰞌 focus %02d:%02d", ctx.m, ctx.s)
  end,

  ---@class PomodoroBreakContext
  ---@field h integer
  ---@field m integer
  ---@field s integer
  ---@field is_long_break boolean
  ---@field timer_mode TimerMode
  ---@field timer_state TimerState
  ---@type fun(ctx: PomodoroBreakContext):string
  break_format = function(ctx)
    return string.format("󰞌 break %02d:%02d", ctx.m, ctx.s)
  end,
})

-- commands
require("piccolo-pomodoro").start()        -- start pomodoro timer
require("piccolo-pomodoro").pause()        -- pause pomodoro timer
require("piccolo-pomodoro").toggle()       -- toggle start/pause
require("piccolo-pomodoro").print_status() -- print pomodoro status
require("piccolo-pomodoro").status()       -- get pomodoro status string
require("piccolo-pomodoro").reset()        -- reset current session
require("piccolo-pomodoro").skip()         -- skip current session
```
