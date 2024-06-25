hexchat.register("Pastes text slowly from a file to avoid channel flooding")

local delay = 3.5 -- Delay in seconds
local lines = {}
local context

function read_file(file_path)
    local file = io.open(file_path, "r")
    if file then
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
    else
        hexchat.print("Error: Could not open file " .. file_path)
    end
end

function paste_slowly()
    if #lines > 0 then
        context:command("say " .. table.remove(lines, 1))
        return hexchat.EAT_NONE
    else
        return hexchat.EAT_ALL
    end
end

hexchat.hook_command("slowpaste", function(word, word_eol)
    local file_path = word_eol[2]
    if not file_path then
        hexchat.print("Usage: /slowpaste <file_path>")
        return hexchat.EAT_ALL
    end
    context = hexchat.get_context()
    read_file(file_path)
    if #lines > 0 then
        hexchat.hook_timer(delay * 1000, paste_slowly)
    end
    return hexchat.EAT_ALL
end)
