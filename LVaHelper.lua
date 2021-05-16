-- This script create for Las Venturas Army Evolve Role Play 02
-- Script author Nicho. Contacts - https://vk.com/n1chooff
-- version 0.2

script_name("LVa Helper")
local sname = '{51964D}[LVa Helper]:{ffffff} '
-- import ------
local sampev = require 'lib.samp.events'
local imgui = require "imgui"
local inicfg = require "inicfg"
local key = require "vkeys"
local mainIni = inicfg.load(nil,directConfig)
local imadd = require 'imgui_addons'
-----------------

------- locals
local complete = false
------ settings -------
local EnterInfo = {
    test ={
        nick = ''
    }
}

local newIni = {
    config = {
        rteg = '',
        acls = '7',
        inf = false,
        modRacia=false,
        modMembers=false
    },
    settings = {
        autoTeg = false,
        autoClist = false,
        autoBP = false,
        chatT = false
    },
    abp = {
        deagle = false,
        shot = false,
		smg = false,
		m4 = false,
		rifle = false,
		armour = false,
		spec = false
    }
}
function sampev.onSendClientJoin(version, mod, nick)
    checkDirectory(nick)
end

---------- imgui -------------
local encoding = require 'encoding' 
encoding.default = 'CP1251' 
u8 = encoding.UTF8

local mws = imgui.ImBool(false) -- main window state
local sws = imgui.ImBool(false) -- settings window state


--------------
local sw,sh = getScreenResolution()

function imgui.OnDrawFrame()
    if not mws.v and not sws.v then
        imgui.Process = false
    end

    local _,MyId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local MyName = sampGetPlayerNickname(MyId)
    
    dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)

    --- buffer ---
    local inputRteg = imgui.ImBuffer(tostring(u8(mainIni.config.rteg)),32)
    ------ check box -----
    local useAutoTeg = imgui.ImBool(mainIni.settings.autoTeg)
    local useChatT = imgui.ImBool(mainIni.settings.chatT)
    local useAutoClist = imgui.ImBool(mainIni.settings.autoClist)
    local useModRacia = imgui.ImBool(mainIni.config.modRacia)
    local useModMembers = imgui.ImBool(mainIni.config.modMembers)

    local numClist = imgui.ImInt(mainIni.config.acls)

    if mws.v then
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5)) -- in center monitor
        imgui.Begin(u8'Главное меню',mws)
        if imgui.Button(u8'Настройки',btn_size) then sws.v = not sws.v end
        imgui.End()
    end

    if sws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(450, 250), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin(u8'Настройки',sws)
        if imadd.ToggleButton("##modr", useModRacia) then
            mainIni.config.modRacia = useModRacia.v
            inicfg.save(mainIni,dcf)
        end
        imgui.SameLine()
        imgui.Text(u8'Модифицированая Рация')
        if imadd.ToggleButton("##modm", useModMembers) then
            mainIni.config.modMembers = useModMembers.v
            inicfg.save(mainIni,dcf)
        end
        imgui.SameLine()
        imgui.Text(u8'Модифицированая Members')
        if imgui.Checkbox(u8'Открывать чат на Т',useChatT) then
            mainIni.settings.chatT = useChatT.v
            inicfg.save(mainIni,dcf)
        end
        if imgui.Checkbox(u8'Использовать Авто-тег',useAutoTeg) then
            mainIni.settings.autoTeg = useAutoTeg.v
            inicfg.save(mainIni,dcf)
        end
        if mainIni.settings.autoTeg then
            if imgui.InputText(u8'Введите ваш тег',inputRteg) then
                mainIni.config.rteg = u8:decode(inputRteg.v)
                inicfg.save(mainIni,dcf)
            end
        end
        if imgui.Checkbox(u8'Использовать Авто-Клист',useAutoClist) then
            mainIni.settings.autoClist = useAutoClist.v
            inicfg.save(mainIni,dcf)
        end
        if mainIni.settings.autoClist then
            imgui.SliderInt(u8"Номер клиста", numClist, 1, 33)
            mainIni.config.acls = numClist.v
            inicfg.save(mainIni,dcf)
        end
        imgui.Separator()
        imgui.End()
    end

end



------------------------------

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(0) end

    apply_custom_style()

    local _,MyId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local MyName = sampGetPlayerNickname(MyId)
    dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)
    

    sampAddChatMessage(sname..'Скрипт загружен',-1)


    sampRegisterChatCommand('lv',function()
        mws.v = not mws.v
        imgui.Process = mws.v
    end)
    

    if doesFileExist(dcf) then
        if mainIni.settings.autoTeg then
            sampRegisterChatCommand('r',cmd_f) 
        else
            sampUnregisterChatCommand('r')
        end
    else
        checkDirectory(MyName)
    end
    

    imgui.Process = false


    while true do
        if doesFileExist(dcf) then
            mainIni = inicfg.load(nil,dcf)
            if mainIni.settings.chatT then
                if isKeyJustPressed(key.VK_T) then
                    if sampIsChatInputActive() then
                    
                    else
                    sampSetChatInputEnabled(true)
                    end
                end
            end
        end
        wait(0)
    end
end


function cmd_f(arg)
    sampSendChat('/r '..mainIni.config.rteg..' '..arg)
end

------ function in imgui ------

function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

---- sampev ------
function sampev.onSendSpawn()
    if myskin == 287 or myskin == 191 or myskin == 179 or myskin == 61 or myskin == 255 or myskin == 73 then
        rabden = true
    end
    if rabden then
        if mainIni.settings.autoClist then
            lua_thread.create(function()
            wait(100)
            sampSendChat('/clist '..mainIni.config.acls)
            sampAddChatMessage(sname..'Клист изменён',-1)
            end)
        end
    end
end
function sampev.onServerMessage(color, text)
    if text:find('Рабочий день начат') then
        if mainIni.settings.autoClist then
            lua_thread.create(function()
                wait(100)
                sampSendChat('/clist '..mainIni.config.acls)
                sampAddChatMessage(sname..'Клист изменён',-1)
            end)
        end
    end
    if mainIni.config.modRacia then
        if color == 33357768 or color == -1920073984 then
            local nick = text:match('(%S+)%: .+'):gsub(" ", "")
            id = sampGetPlayerIdByNickname(nick)
            if id then
            text = text:gsub(nick, ("{8D8DFF}{%s}%s [%s]{%s}"):format(("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)), nick, id, ("%06X"):format(bit.rshift(color, 8))))
            return {color,text}
            end
        end
    end
    if mainIni.config.modMembers then
        if text:match('ID: .+ | .+ | .+: .+ %- .+') then
            local id, data, nick, rang, stat = text:match('ID: (%d+) | (.+) | (.+): (.+) %- (.+)')
            color = bit.lshift(sampGetPlayerColor(id), 8)
            return {color,text}
        end
    end
end
-------
function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
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
function checkDirectory(arg)
    local directFolder = getWorkingDirectory().."\\cfg\\"..arg
    if doesDirectoryExist(directFolder) then
        complete = true
    else
        crfld = createDirectory(directFolder)
        if crfld then
            print('Папка аккаунта успешно создана.')
            complete = true
        else
            print('Во время создание папки аккаунта произошла ошибка')
        end
    end
    if complete then
        complete = false
        directFileConfig = directFolder.."\\config.ini"
        if doesFileExist(directFileConfig) then
            print('Конфиг загружен')
        else
            file = io.open(directFileConfig,'w')
            file.close()
            if inicfg.save(newIni,directFileConfig) then
                print('Конфиг создан')
            end
        end
    end
end
---- thems ----------
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.42, 0.48, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.85, 0.98, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.85, 0.98, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.42, 0.48, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.85, 0.98, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.77, 0.88, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.85, 0.98, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.85, 0.98, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.85, 0.98, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.82, 0.98, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.85, 0.98, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.85, 0.98, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.85, 0.98, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.63, 0.75, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.63, 0.75, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.85, 0.98, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.85, 0.98, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.85, 0.98, 0.26, 0.95)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.81, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.85, 0.98, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end