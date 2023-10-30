local wezterm = require 'wezterm'

local launch_menu = {}


-- Title
function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane

    local index = ""
    if #tabs > 1 then
        index = string.format("%d: ", tab.tab_index + 1)
    end

    local process = basename(pane.foreground_process_name)

    return {{
        Text = ' ' .. index .. process .. ' '
    }}
end)

-- Initial startup
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  ssh_cmd = { "powershell.exe" }

  table.insert(
    launch_menu,
    {
      label = "PowerShell",
      args = { "powershell.exe", "-NoLogo" }
    }
  )

  table.insert(
    launch_menu,
    {
      label = "wsl-code", -- 学习 rust 有一个单独的目录，可以从这个吗lauch menu 单独进入
      args = {  "wsl.exe", "--cd", "/home/jws/code" }
    }
  )



  table.insert(
    launch_menu,
    {
      label = "Bash",
      args = { "bash.exe" }
    }
  )

  table.insert(
    launch_menu,
    {
      label = "CMD",
      args = { "cmd.exe" }
    }
  )
end


return {
    font = wezterm.font 'JetBrains Mono',
    default_prog = { 'powershell' },
    -- The default text color
    foreground = "#f8f8f2",
    -- The default background color
    -- background = "#282a36",

    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = "#f8f8f2",
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = "#282a36",
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = "#f8f8f2",

    -- the foreground color of selected text
    selection_fg = "none",
    -- the background color of selected text
    selection_bg = "rgba(68,71,90,0.5)",

    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = "#44475a",

    -- The color of the split lines between panes
    split = "#6272a4",

    ansi = {"#21222C", "#FF5555", "#50FA7B", "#F1FA8C", "#BD93F9", "#FF79C6", "#8BE9FD", "#F8F8F2"},
    brights = {"#6272A4", "#FF6E6E", "#69FF94", "#FFFFA5", "#D6ACFF", "#FF92DF", "#A4FFFF", "#FFFFFF"},

    -- Since: nightly builds only
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    -- compose_cursor = "#FFB86C",

    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = "#282a36",

        -- The active tab is the one that has focus in the window
        active_tab = {
            -- The color of the background area for the tab
            bg_color = "#bd93f9",
            -- The color of the text for the tab
            fg_color = "#282a36",

            -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
            -- label shown for this tab.
            -- The default is "Normal"
            intensity = "Normal",

            -- Specify whether you want "None", "Single" or "Double" underline for
            -- label shown for this tab.
            -- The default is "None"
            underline = "None",

            -- Specify whether you want the text to be italic (true) or not (false)
            -- for this tab.  The default is false.
            italic = false,

            -- Specify whether you want the text to be rendered with strikethrough (true)
            -- or not for this tab.  The default is false.
            strikethrough = false
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
            bg_color = "#6272a4",
            fg_color = "#f8f8f2",
            italic = true

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab`.
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
            bg_color = "#ff79c6",
            fg_color = "#f8f8f2",
            italic = true

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab_hover`.
        }
    },





    check_for_updates = false,
    switch_to_last_active_tab_when_closing_tab = false,
    enable_scroll_bar = true,

    -- Window
    native_macos_fullscreen_mode = true,
    adjust_window_size_when_changing_font_size = true,
    window_background_opacity = 0.95, -- 如果设置为1.0会明显卡顿
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    },
    window_background_image_hsb = {
        brightness = 0.8,
        hue = 1.0,
        saturation = 1.0
    },
     -- Tab bar
     enable_tab_bar = true,
     hide_tab_bar_if_only_one_tab = false,
     show_tab_index_in_tab_bar = false,
     tab_max_width = 25,
     scrollback_lines = 99999,
     -- tab_bar_at_bottom = true,
     -- use_fancy_tab_bar = false,


    -- Keys
    keys = {
        { key = 'z', mods = 'ALT', action = wezterm.action.ShowLauncher },
        {
            key = '[',
            mods = 'CTRL',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        {
            key = ']',
            mods = 'CTRL',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },

        {
            key = 'k',
            mods = 'CTRL',
            action = wezterm.action.Multiple {wezterm.action.ClearScrollback 'ScrollbackAndViewport',
                                              wezterm.action.SendKey {
                key = 'L',
                mods = 'CTRL'
            }}
        },
        { -- 控制左右移动面板
            key = '',
            mods = 'CTRL|TAB',
            action = wezterm.action {
                ActivateTabRelative = 1
            }
        },
        {
            key = 'LeftArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'RightArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'UpArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'DownArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        { -- 关闭当前pane
            key = 'w',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.CloseCurrentPane {
                confirm = true
            }
        },
        { -- 展示启动器
            key = 'l',
            mods = 'CTRL',
            action = wezterm.action.ShowLauncher
        },
        { -- 新建窗口
            key = 'n',
            mods = 'CTRL',
            action = wezterm.action.SpawnCommandInNewTab {
                label = 'PowerShell',
            }
        },
    },

    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0
    },


    mouse_bindings = { -- Paste on right-click
        {
            event = {
                Down = {
                    streak = 1,
                    button = 'Right'
                }
            },
            mods = 'NONE',
            action = wezterm.action {
                PasteFrom = 'Clipboard'
            }
        }, -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
            event = {
                Up = {
                    streak = 1,
                    button = 'Left'
                }
            },
            mods = 'NONE',
            action = wezterm.action {
                CompleteSelection = 'PrimarySelection'
            }
        }, -- CTRL-Click open hyperlinks
        {
            event = {
                Up = {
                    streak = 1,
                    button = 'Left'
                }
            },
            mods = 'CMD',
            action = 'OpenLinkAtMouseCursor'
        }
    },



    launch_menu  = launch_menu,
}
