-- Diffview.nvim configuration (modern API, v0.4+)
local actions = require("diffview.actions")

require("diffview").setup({
  diff_binaries = false,
  enhanced_diff_hl = false,
  use_icons = true,
  icons = {
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    listing_style = "tree",
    win_config = {
      position = "left",
      width = 35,
    },
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      height = 16,
    },
    log_options = {
      git = {
        single_file = { max_count = 256, follow = false },
        multi_file  = { max_count = 256 },
      },
    },
  },
  keymaps = {
    view = {
      { "n", "<tab>",      actions.select_next_entry },
      { "n", "<s-tab>",    actions.select_prev_entry },
      { "n", "gf",         actions.goto_file_edit },
      { "n", "<C-w><C-f>", actions.goto_file_split },
      { "n", "<C-w>gf",    actions.goto_file_tab },
      { "n", "<leader>e",  actions.focus_files },
      { "n", "<leader>td", actions.toggle_files },
    },
    file_panel = {
      { "n", "j",             actions.next_entry },
      { "n", "<down>",        actions.next_entry },
      { "n", "k",             actions.prev_entry },
      { "n", "<up>",          actions.prev_entry },
      { "n", "<cr>",          actions.select_entry },
      { "n", "l",             actions.select_entry },
      { "n", "o",             actions.select_entry },
      { "n", "<2-LeftMouse>", actions.select_entry },
      { "n", "-",             actions.toggle_stage_entry },
      { "n", "S",             actions.stage_all },
      { "n", "U",             actions.unstage_all },
      { "n", "X",             actions.restore_entry },
      { "n", "R",             actions.refresh_files },
      { "n", "<tab>",         actions.select_next_entry },
      { "n", "<s-tab>",       actions.select_prev_entry },
      { "n", "gf",            actions.goto_file_edit },
      { "n", "<C-w><C-f>",    actions.goto_file_split },
      { "n", "<C-w>gf",       actions.goto_file_tab },
      { "n", "i",             actions.listing_style },
      { "n", "f",             actions.toggle_flatten_dirs },
      { "n", "<leader>e",     actions.focus_files },
      { "n", "<leader>td",    actions.toggle_files },
    },
    file_history_panel = {
      { "n", "g!",            actions.options },
      { "n", "<C-A-d>",       actions.open_in_diffview },
      { "n", "y",             actions.copy_hash },
      { "n", "zR",            actions.open_all_folds },
      { "n", "zM",            actions.close_all_folds },
      { "n", "j",             actions.next_entry },
      { "n", "<down>",        actions.next_entry },
      { "n", "k",             actions.prev_entry },
      { "n", "<up>",          actions.prev_entry },
      { "n", "<cr>",          actions.select_entry },
      { "n", "o",             actions.select_entry },
      { "n", "<2-LeftMouse>", actions.select_entry },
      { "n", "<tab>",         actions.select_next_entry },
      { "n", "<s-tab>",       actions.select_prev_entry },
      { "n", "gf",            actions.goto_file_edit },
      { "n", "<C-w><C-f>",    actions.goto_file_split },
      { "n", "<C-w>gf",       actions.goto_file_tab },
      { "n", "<leader>e",     actions.focus_files },
      { "n", "<leader>td",    actions.toggle_files },
    },
    option_panel = {
      { "n", "<tab>",      actions.select },
      { "n", "<leader>q",  actions.close },
    },
  },
})
