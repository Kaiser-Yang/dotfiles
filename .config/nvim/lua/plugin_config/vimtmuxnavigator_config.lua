-- 2: Write all buffers bfore navigating from vim to tmux pane
vim.g.tmux_navigator_save_on_switch = 2
-- If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
-- 0 disable this
vim.g.tmux_navigator_preserve_zoom = 1
-- Disable tmux navigator when zooming the Vim pane
-- 1: disable
-- 0: enable
vim.g.tmux_navigator_disable_when_zoomed = 0
