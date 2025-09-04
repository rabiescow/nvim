-- order of which to load the modules
require("config.options")
require(".lazy")
require("config.keymaps")
require(".lsp")
require("utils.autocmd")
local util = require("utils.utils")

package.path = package.path .. ";" .. util.get_rocks_paths(false)
package.cpath = package.cpath .. ";" .. util.get_rocks_paths(true)
