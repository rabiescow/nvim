return {
    "nomnivore/ollama.nvim",
    dependencies = {"nvim-lua/plenary.nvim"},

    cmd = {"Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop"},

    keys = {
        {
            "<leader>op",
            "<CMD>lua require('ollama').prompt()<CR>",
            desc = "ollama prompt",
            mode = {"n", "v"}
        }, {
            "<leader>og",
            "<CMD>lua require('ollama').prompt('Generate_Code')<CR>",
            desc = "ollama Generate Code",
            mode = {"n", "v"}
        }
    },

    ---@type Ollama.Config
    opts = {
        model = "gemma3",
        url = "http://127.0.0.1:11434",
        serve = {
            on_start = true,
            command = "ollama",
            args = {"serve"},
            stop_command = "pkill",
            stop_args = {"-SIGTERM", "ollama"}
        },
        -- View the actual default prompts in ./lua/ollama/prompts.lua
        prompts = {
            Sample_Prompt = {
                prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
                input_label = "> ",
                model = "deepseek-r1",
                action = "display"
            }
        }
    }
}
