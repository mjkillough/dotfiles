import libqtile
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget

mod = "mod4"

keys = [
    Key([], 'XF86MonBrightnessUp', lazy.spawn("xbacklight -inc 10")),
    Key([], 'XF86MonBrightnessDown', lazy.spawn("xbacklight -dec 10")),
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -q set Master 5%+')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -q set Master 5%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer -q set Master toggle')),

    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod], "Right", lazy.layout.grow()),
    Key([mod], "Left", lazy.layout.shrink()),
    Key([mod], "Down", lazy.layout.normalize()),
    Key([mod], "Up", lazy.layout.maximize()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    Key([mod], "x", lazy.to_screen(0)),
    Key([mod], "z", lazy.to_screen(1)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawn("lighthouse-launcher")),
    Key([mod], "e", lazy.spawncmd()),
    Key([mod], "q", lazy.spawn("random-wallpaper")),
    Key([mod], "Return", lazy.spawn("urxvt")),
]

groups = [Group(i) for i in "asdf"]

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(Key([mod], i.name, lazy.group[i.name].toscreen()))
    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(Key([mod, "shift"], i.name, lazy.window.togroup(i.name)))

layouts = [
    layout.Max(),
    layout.xmonad.MonadTall(border_width=1, border_focus='#efefef'),
]

widget_defaults = dict(
    font='SourceCodePro',
    fontsize=28,
    padding=8
)

screens = [
    Screen(bottom=bar.Bar(
        [
            widget.GroupBox(highlight_method='block', padding=0, padding_x=8, margin=0, borderwidth=0),
            widget.Prompt(),
            widget.WindowName(),
            widget.ThermalSensor(tag_sensor='Core 0', threshold=86),
            widget.ThermalSensor(tag_sensor='Core 1', threshold=86),
            widget.Systray(),
            widget.Volume(),
            widget.Battery(format='({percent:2.0%} - {hour:d}:{min:02d})'),
            widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
        ],
        34,
    ))
    for _ in range(2)
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True

@libqtile.hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()
