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
        imgui.Text(u8'Проверка')
        imgui.InputText(u8'Введите текст',inputRteg)
        if imgui.Button(u8'Потдвердить') then
            print(u8:decode(inputRteg.v))
        end
        imgui.PushItemWidth(75)
        imgui.End()
    end
end


-----------------------------------------------------
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Londrina Solid', 10, font_flag.BOLD + font_flag.SHADOW)

local chekerPlayer = {}

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('imgui',imgui_main_menu)
    sampRegisterChatCommand('imgui1',settings_window_menu)
    sampRegisterChatCommand('panel',cmd_panel)
    sampRegisterChatCommand('pract',cmd_pract)
    
    

    imgui.Process = false

    while true do
        wait(0)

        if cheker then
            if #chekerPlayer == 0 then
            else
                renderFontDrawText(my_font,'{004080}[Панель слежки]:{ffffff}\n',10,380,0xFFFFFFFF)
                
                    j = #chekerPlayer
                    x = 10
                    y = 380
                    while j > 0 do
                        y = y + 20
                        i = chekerPlayer[j]
                        result, Ped = sampGetCharHandleBySampPlayerId(i)
                    
                        if result then
                            privet = true
                        else
                            privet = false
                        end
                        getName = sampGetPlayerNickname(i)
                        color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(i)))
                        if privet then
                            renderFontDrawText(my_font,'{'..color..'}'..getName..' ['..i..'] - {00BF80} в зоне стрима', x, y, 0xFFFFFFFF)
                        else
                            renderFontDrawText(my_font,'{'..color..'}'..getName..' ['..i..'] - {FF0000} вне зоне стрима', x, y, 0xFFFFFFFF)
                        end
                            j = j - 1
                    end
            end
        end

    
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

function cmd_panel(arg)
    var1,var2 = string.match(arg,"(.+) (.+)")
    if var1 == 'add' and var2 then
        lua_thread.create(function()
            cheker = true
            if var2:match('%d+') then 
                id = var2:match('%d+')
                table.insert( chekerPlayer, var2 )
            end 
        end)
    elseif var1 == 'del' and var2 then 
        for j in ipairs(chekerPlayer) do
            if var2 == chekerPlayer[j] then
                sampAddChatMessage('Елемент удалён',-1)
                table.remove( chekerPlayer, j)
            else
                sampAddChatMessage('Елемент не найден',-1)
            end
        end
    end
end

------------------- settings color

function getColor(ID)
	PlayerColor = sampGetPlayerColor(id)
	a, r, g, b = explode_argb(PlayerColor)
	return r/255, g/255, b/255, 1
end

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function ARGBtoRGB(color)
    local a = bit.band(bit.rshift(color, 24), 0xFF)
    local r = bit.band(bit.rshift(color, 16), 0xFF)
    local g = bit.band(bit.rshift(color, 8), 0xFF)
    local b = bit.band(color, 0xFF)
    local rgb = b
    rgb = bit.bor(rgb, bit.lshift(g, 8))
    rgb = bit.bor(rgb, bit.lshift(r, 16))
    return rgb
end

---------------------------------------------------------


function cmd_pract(arg)
    var1,var2 = string.match(arg,"(.+) (.+)")
    if arg == '' or arg == nil then
        for i in ipairs(chekerPlayer) do
            sampAddChatMessage(chekerPlayer,-1)
        end
    elseif var1 == 'add' and var2 then
        table.insert( chekerPlayer, var2 )
        sampAddChatMessage('Вы добавили елемент',-1)
    elseif var1 == 'del' and var2 then
       
    end
end