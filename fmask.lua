script_author('n1cho')

local key = require "vkeys"

local idMask = {18911,18912,18913,18914,18915,18916,18917,18918,18919,18920}
local listItem = {}

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end

    sampAddChatMessage('/fmaska by n1cho work',-1)

    sampRegisterChatCommand('fmaska',cmd_fmas)

    while true do
        wait(0)
    end
end

function cmd_fmas(arg)
    lua_thread.create(function()
        sampSendChat('/items')
        wait(100)
        n = 2188
        for arg = 2188,2195 do
            if sampTextdrawIsExists(arg) then
                model, rotX,rotY, rotZ,zoom, clr1, clr2 = sampTextdrawGetModelRotationZoomVehColor(arg)
                for i = 0,#idMask do
                    if model == idMask[i] then
                        fin = true
                        n = arg
                    else
                        find = false
                    end
                    
                end
            end
        end
        if find == false and fin then
            sampSendClickTextdraw(n)
            wait(50)
            nad()
        else
            sampSendClickTextdraw(2184)
            wait(100)
            for arg = 2188,2195 do
                if sampTextdrawIsExists(arg) then
                    model, rotX,rotY, rotZ,zoom, clr1, clr2 = sampTextdrawGetModelRotationZoomVehColor(arg)
                    for i = 0,#idMask do
                        if model == idMask[i] then
                            sampSendClickTextdraw(arg)
                            wait(50)
                            nad()
                        end
                    end
                end
            end
        end
    end)
end

function nad()
    lua_thread.create(function()
        wait(50)
        if sampIsDialogActive() then
            text = sampGetDialogText()
            if text:find('Снять аксессуар') then

            else
                sampSendDialogResponse(24700, 1, 1)
            end
        end
        sampCloseCurrentDialogWithButton(0)
        wait(100)
        setVirtualKeyDown(key.VK_ESCAPE,true)
        wait(100)
        setVirtualKeyDown(key.VK_ESCAPE,false)
        wait(1000)
        sampSendChat('/mask')
    end)
end
