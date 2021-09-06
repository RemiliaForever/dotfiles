local awful = require("awful")
local beautiful = require("beautiful")
local gears = require('gears')

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gimp",
          "Wine",
          "Minecraft",
          "Steam",
          "Display",
          "Animation",
          "matplotlib",
          },
        name = {
          "Event Tester",  -- xev.
          "Gnuplot",
        },
        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },
    { rule = { class = "jetbrains-idea"},
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { name = "Steam" },
       properties = { screen = 1, tag = "文档", maximized = false } },
    { rule = { name = "Firefox" },
       properties = { screen = 1, tag = "网络", maximized = true } },
    { rule = { class = "netease-cloud-music" },
        properties = { screen = 2, tag = "音乐" } },
    { rule = { class = "TelegramDesktop" },
        properties = { screen = 2, tag = "聊天" } },
    { rule = { name = "WeeChat" },
        properties = { screen = 1, tag = "聊天" } },
}
