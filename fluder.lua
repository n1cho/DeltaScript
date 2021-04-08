local sampev = require 'lib.samp.events'
local vk = require 'vkeys'
function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end

    sampAddChatMessage("flooder by {FF0000}n1cho{ffffff}, /capts",-1)

    sampRegisterChatCommand('capts',cmd_capt)

    while true do
        wait(0)
        if wasKeyPressed(vk.VK_Z) then
            stop = true
        end
    end
end

function cmd_capt(arg)
    lua_thread.create(function()
        id = tonumber(arg)
        if id < 0 or id > 28 then
            sampAddChatMessage('Неверный аргумент',-1)
        else
            capt = true
            if capt then
                capt = false
                stop = false
                sampSendChat('/capture')
                wait(1000)
                if sampIsDialogActive() then
                    sampSendDialogResponse(32700, arg-1, 1)
                end
                sampCloseCurrentDialogWithButton(0)
                if stop then
                    sampAddChatMessage('флуд закончен',-1)            
                else
                    stop = false
                    return cmd_capt(arg)
                end
            end
        end
        end)
end

function sampev.onServerMessage(color, text)
    if text:find('спровоцировала войну с') and text:find('за территорию') then
        stop = true
    end
end