-- -- peek folded lines under cursor on hover
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
-- 	group = vim.api.nvim_create_augroup("UfoFoldingHover", { clear = true }),
-- 	callback = function()
-- 		require("ufo").peekFoldedLinesUnderCursor()
-- 	end,
-- })

-- naming of backups
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("UpdateTimestampOnBackup", { clear = true }),
	callback = function()
		vim.o.backupext = "." .. vim.fn.strftime("%Y%m%d_%H%m%s") .. ".tmp"
	end,
})

-- get oil on startup
vim.api.nvim_create_autocmd({ "User" }, {
	group = vim.api.nvim_create_augroup("OilOnUserEventForStartup", { clear = true }),
	pattern = "StartupNvimReady",
	callback = function(args)
		print("User event '" .. args.match .. "' triggered!")

		local oil_is_already_open = false
		for _, winid in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(winid) then
				local buf_in_win = vim.api.nvim_win_get_buf(winid)
				if vim.api.nvim_buf_is_valid(buf_in_win) and vim.bo[buf_in_win].filetype == "oil" then
					oil_is_already_open = true
					break
				end
			end
		end

		if not oil_is_already_open then
			vim.schedule(function()
				vim.cmd("Oil --float")
			end)
		end
	end,
	desc = "Open Oil in a float when the startup dashboard is ready",
})

-- highlight last yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight when yanking text",
	group = vim.api.nvim_create_augroup("yanker", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "CurSearch", timeout = 1000 })
	end,
})

-- writing to shada when deleting
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	group = vim.api.nvim_create_augroup("wshada_on_delete", { clear = true }),
	desc = "Write to ShaDa when deleting/wiping out buffers",
	command = "wshada",
})

-- showcasing hexcolors with the color as the background
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("Colorizer", { clear = true }),
	desc = "showcase color backgrounds for hexcodes",
	callback = function()
		vim.cmd([[ ColorizerToggle ]])
	end,
})
