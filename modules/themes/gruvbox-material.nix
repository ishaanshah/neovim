{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.theme.gruvbox-material;
in {
  options.vim.theme.gruvbox-material = {
    enable = mkEnableOption "Enable gruvbox material theme";
  };

  config = mkIf (cfg.enable) {
    # Configuration for the theme has to be done before calling
    # `colorscheme gruvbox-material so can't use `vim.globals`
    # :help gruvbox_material.txt for all configuration options
    vim.configRC = ''
      let g:gruvbox_material_background = 'hard'
      let g:gruvbox_material_enable_bold = 1
      let g:gruvbox_material_enable_italic = 1
      let g:gruvbox_material_spell_foreground = "colored"
      let g:gruvbox_material_show_eob = 0
      let g:gruvbox_material_ui_contrast = "high"

      colorscheme gruvbox-material
    '';

    vim.startPlugins = with pkgs.neovimPlugins; [gruvbox-material];
  };
}
