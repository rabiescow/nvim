return {
  "norcalli/nvim-colorizer.lua",
  lazy = false,
  config = function()
    require("colorizer").setup({
      DEFAULT_OPTIONS = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = 'background',
      }
    })
  end,
}

-- blue
-- Blue
-- BLUE
-- #1111dd
-- #1111DD
-- abc0,0,0;
-- rgb(0,0,0)
-- rgb(11,11,221)
-- rgb   (    187   ,   17,221)
-- Rgb(17,17,221)
-- RGB(17,17,221)
-- rgba(11,11,221,0.4)
-- rgba(  11  ,  11  ,   221  ,   0.4)

-- RGBA(11,11,221,0.4)
-- hsl(0,0%,0%)
-- HSL(0,0%,0%)
-- hsl( 0, 0%, 0% )
-- hsla(0,0%,0%,0);
