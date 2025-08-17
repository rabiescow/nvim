-- order of which to load the modules
require("config.options")
require("config.keymaps")
require("./lazy")
require("./lsp")
require("utils.autocmd")

package.path = package.path .. ";" .. require("utils.utils").get_rocks_paths(false)
package.cpath = package.cpath .. ";" .. require("utils.utils").get_rocks_paths(true)
