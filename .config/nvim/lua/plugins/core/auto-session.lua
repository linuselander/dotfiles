return {
  "rmagatti/auto-session",
  opts = {
    auto_session_enable_last_session = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
    log_level = "error",
  }
}

