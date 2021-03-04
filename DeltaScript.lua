script_name("Delta Script")
script_author("N1CHO")




--------------------- all in imgui -----
local imgui = require "imgui"

local encoding = require 'encoding'  
encoding.default = 'CP1251'  
u8 = encoding.UTF8


local mws = imgui.ImBool(false)

local sw,sh = getScreenResolution()

function imgui.OnDrawFrame()
    if mws then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 100), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Main Window',mws)
        imgui.Text('Hello World')
        imgui.End()
    end
end


-----------------------------------------------------
function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('imgui',imgui_main_menu)


    imgui.Process = true

    while true do
        wait(0)

        if mws.v == false then
            imgui.Process = false
        end


    end
end

function imgui_main_menu()
    mws.v = not mws.v
    imgui.Process = true
end
