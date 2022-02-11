{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable =  mkEnableOption "Enable git support"; 
  };

  config = mkIf cfg.enable {

    vim.nnoremap = {
      "<leader>gs" = "<cmd>Magit<cr>";
    };

    vim.startPlugins = with pkgs.neovimPlugins; [ 
      vimagit 
      fugitive
    ];
    
    vim.luaConfigRC = ''
      local wk = require("which-key")

      wk.register({
        g = {
          name = "Git",
          s = {"Status "},
        },
      }, { prefix = "<leader>" })
    '';
  };
}

