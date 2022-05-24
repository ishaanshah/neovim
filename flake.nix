{
  description = "Wil Taylor's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    rnix-lsp = { url = "github:nix-community/rnix-lsp"; };

    # Vim plugins
    gruvbox-material = { url = "github:sainnhe/gruvbox-material"; flake = false; };
    # dasboard-nvim = { url = "github:glepnir/dashboard-nvim"; flake = false; };
    lualine-nvim = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    luasnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
    # TODO: Setup friendly-snippets
    cmp-nvim-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    cmp-path = { url = "github:hrsh7th/cmp-path"; flake = false; };
    cmp-buffer = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    cmp-cmdline = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
    cmp-luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
    # TODO: completion for LaTeX symbols
    vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };
    vim-glsl = { url = "github:tikhomirov/vim-glsl"; flake = false; };
    nvim-dap = { url = "github:mfussenegger/nvim-dap"; flake = false; };
    nvim-telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    telescope-dap = { url = "github:nvim-telescope/telescope-dap.nvim"; flake = false; };
    popup-nvim = { url = "github:nvim-lua/popup.nvim"; flake = false; };
    plenary-nvim = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    nvim-web-devicons = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    nvim-tree-lua = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };
    vimagit = { url = "github:jreybert/vimagit"; flake = false; };
    fugitive = { url = "github:tpope/vim-fugitive"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-treesitter-context = { url = "github:romgrk/nvim-treesitter-context"; flake = false; };
    editorconfig-vim = { url = "github:editorconfig/editorconfig-vim"; flake = false; };
    indentline = { url = "github:Yggdroot/indentLine"; flake = false; };
    indent-blankline-nvim = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
    nvim-dap-virtual-text = { url = "github:theHamsta/nvim-dap-virtual-text"; flake = false; };
    vim-cursorword = { url = "github:itchyny/vim-cursorword"; flake = false; };
    vim-test = { url = "github:vim-test/vim-test"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, neovim, rnix-lsp, ... }@inputs:
    let
      plugins = [
        "gruvbox-material"
        # "dashboard-nvim"
        "lualine-nvim"
        "nvim-cmp"
        "luasnip"
        "cmp-nvim-lsp"
        "cmp-path"
        "cmp-buffer"
        "cmp-cmdline"
        "cmp-luasnip"
        "nvim-lspconfig"
        "vim-glsl"
        "vim-nix"
        "nvim-dap"
        "nvim-telescope"
        "popup-nvim"
        "plenary-nvim"
        "nvim-web-devicons"
        "nvim-tree-lua"
        "telescope-dap"
        "vimagit"
        "fugitive"
        "nvim-lightbulb"
        "nvim-treesitter-context"
        "editorconfig-vim"
        "indent-blankline-nvim"
        "indentline"
        "nvim-dap-virtual-text"
        "vim-cursorword"
        "vim-test"
        "nvim-which-key"
      ];

      externalBitsOverlay = top: last: {
        rnix-lsp = rnix-lsp.defaultPackage.${top.system};
        neovim-nightly = neovim.defaultPackage.${top.system};
      };

      pluginOverlay = top: last:
        let
          buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
          };
        in
        {
          neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
        };

      allPkgs = lib.mkPkgs {
        inherit nixpkgs;
        cfg = { };
        overlays = [
          pluginOverlay
          externalBitsOverlay
        ];
      };

      lib = import ./lib;

      mkNeoVimPkg = pkgs: lib.neovimBuilder {
        inherit pkgs;
        config = {
          vim.viAlias = true;
          vim.vimAlias = true;
          # vim.dashboard.enable = true;
          vim.theme.gruvbox-material.enable = true;
          vim.disableArrows = true;
          vim.statusline.lualine.enable = true;
          vim.lsp.enable = true;
          vim.lsp.bash = true;
          vim.lsp.go = true;
          vim.lsp.nix = true;
          vim.lsp.python = true;
          vim.lsp.ruby = true;
          vim.lsp.rust = true;
          vim.lsp.terraform = true;
          vim.lsp.typescript = true;
          vim.lsp.vimscript = true;
          vim.lsp.yaml = true;
          vim.lsp.docker = true;
          vim.lsp.tex = true;
          vim.lsp.css = true;
          vim.lsp.html = true;
          vim.lsp.json = true;
          vim.lsp.clang = true;
          vim.lsp.cmake = false; # Currently broken
          # vim.lsp.lightbulb = true;
          # vim.lsp.variableDebugPreviews = true;
          vim.fuzzyfind.telescope.enable = true;
          vim.filetree.nvimTreeLua.enable = true;
          vim.git.enable = true;
          vim.formatting.editorConfig.enable = true;
          vim.editor.indentGuide = true;
          vim.editor.underlineCurrentWord = true;
          vim.test.enable = true;
        };
      };

    in
    {

      apps = lib.withDefaultSystems (sys:
        {
          nvim = {
            type = "app";
            program = "${self.defaultPackage."${sys}"}/bin/nvim";
          };
        });

      defaultApp = lib.withDefaultSystems (sys: {
        type = "app";
        program = "${self.defaultPackage."${sys}"}/bin/nvim";
      });

      defaultPackage = lib.withDefaultSystems (sys: self.packages."${sys}".neovimWT);

      packages = lib.withDefaultSystems (sys: {
        neovimWT = mkNeoVimPkg allPkgs."${sys}";
      });
    };
}
