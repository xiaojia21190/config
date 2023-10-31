local wezterm = require "wezterm"

local launch_menu = {}
local ssh_cmd = {"ssh"}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    ssh_cmd = {"powershell.exe", "ssh"}

    table.insert(
        launch_menu,
        {
            label = "Bash",
            args = {"C:/Program Files/Git/bin/bash.exe", "-li"}
        }
    )

    table.insert(
        launch_menu,
        {
            label = "CMD",
            args = {"cmd.exe"}
        }
    )

    table.insert(
        launch_menu,
        {
            label = "PowerShell",
            args = {"powershell.exe", "-NoLogo"}
        }
    )

end

local ssh_config_file = wezterm.home_dir .. "/.ssh/config"
local f = io.open(ssh_config_file)
if f then
    local line = f:read("*l")
    while line do
        if line:find("Host ") == 1 then
            local host = line:gsub("Host ", "")
            local args = {}
            for i,v in pairs(ssh_cmd) do
                args[i] = v
            end
            args[#args+1] = host
            table.insert(
                launch_menu,
                {
                    label = "SSH " .. host,
                    args = args,
                }
            )
            -- default open vm
            if host == "vm" then
                config.default_prog = {"powershell.exe", "ssh", "vm"}
            end
        end
        line = f:read("*l")
    end
    f:close()
end


wezterm.on( "update-right-status", function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S   ")
    window:set_right_status(
        wezterm.format(
            {
                {Text = date}
            }
        )
    )
end)

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

wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window{}
  window:gui_window():maximize()
end)


return {
    font = wezterm.font 'JetBrains Mono',
    default_prog = { 'powershell' },
    color_scheme = 'Darcula (base16)',

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


     mouse_bindings = {
        -- 右键粘贴
        {
            event = {Down = {streak = 1, button = "Right"}},
            mods = "NONE",
            action = wezterm.action {PasteFrom = "Clipboard"}
        },
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
            event = {Up = {streak = 1, button = "Left"}},
            mods = "NONE",
            action = wezterm.action {CompleteSelection = "PrimarySelection"}
        },
        -- and make CTRL-Click open hyperlinks
        {
            event = {Up = {streak = 1, button = "Left"}},
            mods = "CTRL",
            action = "OpenLinkAtMouseCursor"
        }
    },
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

    launch_menu  = launch_menu,
}
