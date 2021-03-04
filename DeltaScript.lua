script_name("Delta Script")
script_author("N1CHO")


local inicfg = require "inicfg"

local mainini = {
    config = {
        testIni = 'work'
    }
}

local directSettings = "moonloader\\cfg\\config.ini"
local mainIni = inicfg.load(mainini,directSettings)

--------------------- all in imgui -----
local imgui = require "imgui"

local encoding = require 'encoding' 
encoding.default = 'CP1251' 
u8 = encoding.UTF8


local mws = imgui.ImBool(false)
local sws = imgui.ImBool(false)

local sw,sh = getScreenResolution()

local inputRteg = imgui.ImBuffer(24)

local test_cb = imgui.ImBool(false)

function imgui.OnDrawFrame()
    if not mws.v and not sws.v then
        imgui.Process = false
    end
    if mws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 100), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Main Window',mws)
        imgui.Text('Hello World')
        imgui.Separator()
        imgui.Text(u8(mainIni.config.testIni))
        if imgui.Button(u8'Settings') then
            settings_window_menu()
        end
        
        imgui.End()
    end
    
    if sws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(300, 150), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Settings Window',sws)
        imgui.Text(u8'Это окно настроек')
        imgui.InputText(u8'Введите текст',inputRteg)
        if imgui.Button(u8'Потдвердить') then
            print(u8:decode(inputRteg.v))
        end
        imgui.PushItemWidth(75)
        imgui.End()
    end
end


-----------------------------------------------------
function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('imgui',imgui_main_menu)
    sampRegisterChatCommand('imgui1',settings_window_menu)


    imgui.Process = false

    while true do
        wait(0)

        


    end
end

function imgui_main_menu()
    mws.v = not mws.v
    imgui.Process = mws.v
end

function settings_window_menu()
    sws.v = not sws.v
    if sws.v == false then
        imgui.Process = mws.v
    else
        imgui.Process = sws.v
    end
end