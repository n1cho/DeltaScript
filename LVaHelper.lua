-- This script create for Las Venturas Army Evolve Role Play 02
-- Script author Nicho. Contacts - https://vk.com/n1chooff
-- version 1.0 - УРАААААААА

script_name("LVa Helper")
local sname = '{51964D}[LVa Helper]:{ffffff} '
-------- trash -------
local CarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
----------------------
-- import ------
local sampev = require 'lib.samp.events'
local imgui = require "imgui"
local inicfg = require "inicfg"
local key = require "vkeys"
local mainIni = inicfg.load(nil,directConfig)
local imadd = require 'imgui_addons'
local weapons = require 'game.weapons'
local memory = require "memory"
-----------------

------- locals
local complete = false
local editHotkey = nil
local mouseCord = false
local imwin = nil -- для меню настроек
local autoBP = 1
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
        infbr = false,
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
		spec = false,
        close = false
    }
}
local newInf = {
    sett = {
        ShowNick = true,
        ShowStut = true,
        ShowTarget = true,
        ShowGuns = true,
        ShowCar = true,
        ShowCord = true,
        ShowDate = true,
        x = 600,
        y = 500
    }
}
function sampev.onSendClientJoin(version, mod, nick)
    checkDirectory(nick)
end
keyAdminMenu = ""
---------- imgui -------------
local encoding = require 'encoding' 
encoding.default = 'CP1251' 
u8 = encoding.UTF8

local mws = imgui.ImBool(false) -- main window state
local sws = imgui.ImBool(false) -- settings window state


local hotKeyAdminMenu = imgui.ImBuffer('', 256)
--------------
local sw,sh = getScreenResolution()

function imgui.OnDrawFrame()
    infbr = imgui.ImBool(mainIni.config.infbr) 

    if not mws.v and not sws.v and not infbr.v then
        imgui.Process = false
    end
    
    local _,MyId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local MyName = sampGetPlayerNickname(MyId)
    local MyColor = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(MyId)))
    local MyHealth = getCharHealth(PLAYER_PED)
    local MyArmor = sampGetPlayerArmor(MyId)
    local IDweapon = getCurrentCharWeapon(PLAYER_PED)
    -- vehicle --
    local CarHandle = getCarCharIsUsing(PLAYER_PED)
    -- target ---
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    -------------

    dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)

    dci = getWorkingDirectory()..'\\cfg\\'..MyName..'\\infbar.ini'
    infIni = inicfg.load(nil,dci)

    ------- infobar --------
    local ISX = infIni.sett.x
    local ISY = infIni.sett.y
    -------------------------
    ---- auto-bp ---------
    local useAutoBP = imgui.ImBool(mainIni.settings.autoBP)

    local abpDeagle = imgui.ImBool(mainIni.abp.deagle)
    local abpShot = imgui.ImBool(mainIni.abp.shot)
    local abpSMG = imgui.ImBool(mainIni.abp.smg)
    local abpM4 = imgui.ImBool(mainIni.abp.m4)
    local abpRifle = imgui.ImBool(mainIni.abp.rifle)
    local abpArmour = imgui.ImBool(mainIni.abp.armour)
    local abpSpec = imgui.ImBool(mainIni.abp.spec)
    local abpClose = imgui.ImBool(mainIni.abp.close)
    ----------------------
    --- buffer ---
    local inputRteg = imgui.ImBuffer(tostring(u8(mainIni.config.rteg)),32)
    ------ check box -----
    local useAutoTeg = imgui.ImBool(mainIni.settings.autoTeg)
    local useChatT = imgui.ImBool(mainIni.settings.chatT)
    local useAutoClist = imgui.ImBool(mainIni.settings.autoClist)
    local useModRacia = imgui.ImBool(mainIni.config.modRacia)
    local useModMembers = imgui.ImBool(mainIni.config.modMembers)
    local useInfBr = imgui.ImBool(mainIni.config.infbr)

    local numClist = imgui.ImInt(mainIni.config.acls)

    -------- check box infobar------
    local useShowNick = imgui.ImBool(infIni.sett.ShowNick)
    local useShowStut = imgui.ImBool(infIni.sett.ShowStut)
    local useShowTarget = imgui.ImBool(infIni.sett.ShowTarget)
    local useShowGuns = imgui.ImBool(infIni.sett.ShowGuns)
    local useShowCar = imgui.ImBool(infIni.sett.ShowCar)
    local useShowCord = imgui.ImBool(infIni.sett.ShowCord)
    local useShowDate = imgui.ImBool(infIni.sett.ShowDate)
    --------------------------------

    if mws.v then
        
        imgui.ShowCursor = true

        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5)) -- in center monitor
        imgui.Begin(u8'Главное меню',mws)
        
        if imgui.Button(u8'Настройки',btn_size) then
            sws.v = not sws.v 
            imwin = 0
        end
        imgui.AlignTextToFramePadding()
        if imgui.Hotkey(u8"Панель администратора", hotKeyAdminMenu, 80) then
            nextLockKey = hotKeyAdminMenu.v
            keyAdminMenu = hotKeyAdminMenu.v
        end

        imgui.End()
    end

    if sws.v then
        
        imgui.SetNextWindowSize(imgui.ImVec2(550, 250), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin(u8'Настройки',sws,imgui.WindowFlags.NoResize + imgui.WindowFlags.ShowBorders)

        imgui.BeginChild('Основные',imgui.ImVec2(80,215),true)

            if imgui.Selectable(u8'Основные') then imwin = 0 end
            if imgui.Selectable(u8'Инфо-Бар') then imwin = 1 end
            if imgui.Selectable(u8'Авто-БП') then imwin = 2 end

        imgui.EndChild()

        imgui.SameLine()
        
        imgui.BeginChild(u8'Настройки',_,true)
            if imwin == 0 then

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

            elseif imwin == 1 then
                
                imgui.Text(u8'Использовать Инфо-Бар')

                imgui.SameLine()

                if imadd.ToggleButton("##infbr", useInfBr) then
                    mainIni.config.infbr = useInfBr.v
                    inicfg.save(mainIni,dcf)
                end

                imgui.Separator()

                if mainIni.config.infbr then
                    imgui.Text(u8'Показывать ник')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usn", useShowNick) then
                        infIni.sett.ShowNick = useShowNick.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать HP и Armor')

                    imgui.SameLine()

                    if imadd.ToggleButton("##ust", useShowStut) then
                        infIni.sett.ShowStut = useShowStut.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать ник цели')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usT", useShowTarget) then
                        infIni.sett.ShowTarget = useShowTarget.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать информацию о оружие')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usg", useShowGuns) then
                        infIni.sett.ShowGuns = useShowGuns.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать информация о состоянии машины')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usc", useShowCar) then
                        infIni.sett.ShowCar = useShowCar.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать местонахождение')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usC", useShowCord) then
                        infIni.sett.ShowCord = useShowCord.v
                        inicfg.save(infIni,dci)
                    end

                    imgui.Text(u8'Показывать Дату')

                    imgui.SameLine()

                    if imadd.ToggleButton("##usd", useShowDate) then
                        infIni.sett.ShowDate = useShowDate.v
                        inicfg.save(infIni,dci)
                    end

                    if imgui.Button(u8'Изменить местоположение Инфо-Бара') then
                        mouseCord = true
                    end
                end
            elseif imwin == 2 then

                imgui.Text(u8'Использовать Авто-БП')

                imgui.SameLine()

                if imadd.ToggleButton("##autoBP", useAutoBP) then
                    mainIni.settings.autoBP = useAutoBP.v
                    inicfg.save(mainIni,dcf)
                end

                imgui.Separator()

                if mainIni.settings.autoBP then
                    imgui.Text(u8'Deagle')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbd", abpDeagle) then
                        mainIni.abp.deagle = abpDeagle.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'Shotgun')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbs", abpShot) then
                        mainIni.abp.shot = abpShot.v
                        inicfg.save(mainIni,dcf)
                    end


                    imgui.Text(u8'SMG')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbSMG", abpSMG) then
                        mainIni.abp.smg = abpSMG.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'M4')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbm", abpM4) then
                        mainIni.abp.m4 = abpM4.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'Rifle')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbr", abpRifle) then
                        mainIni.abp.rifle = abpRifle.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'Armour')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apba", abpArmour) then
                        mainIni.abp.armour = abpArmour.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'Парашут')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbp", abpSpec) then
                        mainIni.abp.spec = abpSpec.v
                        inicfg.save(mainIni,dcf)
                    end

                    imgui.Text(u8'Автоматически закрывать окно')

                    imgui.SameLine()

                    if imadd.ToggleButton("##apbc", abpClose) then
                        mainIni.abp.close = abpClose.v
                        inicfg.save(mainIni,dcf)
                    end
                end
            end
        imgui.EndChild()
        imgui.End()
    end

    if mainIni.config.infbr then
        imgui.SetNextWindowPos(imgui.ImVec2(ISX,ISY),imgui.ImVec2(0.5,0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(350, 160), imgui.Cond.FirstUseEver)
        imgui.Begin('Main Window',_,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)

        imgui.CenterText('LVa Helper')

        imgui.Separator()

        if infIni.sett.ShowNick then imgui.TextColoredRGB(u8(string.format('Ник: {%s}%s{SSSSSS}. Ваш ID: %s',MyColor,MyName,MyId))) end
        
        if infIni.sett.ShowStut then imgui.Text(string.format('HP: %s. Armor: %s',MyHealth,MyArmor)) end

        if infIni.sett.ShowTarget then
            if valid and doesCharExist(ped) then
                _,TargetID = sampGetPlayerIdByCharHandle(ped)
                TargetName = sampGetPlayerNickname(TargetID)
                TargetHealth = sampGetPlayerHealth(TargetID)
                imgui.Text(u8(string.format('Цель: %s[%s] HP: %s',TargetName,TargetID,TargetHealth)))
            else
                imgui.Text(u8'Цель: Отсутсвует')
            end
        end

        if infIni.sett.ShowGuns then
            if weapons.get_name(IDweapon) == 'Fist' then
                imgui.Text(u8'Оружие: '..weapons.get_name(IDweapon))
            else
                imgui.Text(u8(string.format('Оружие: %s[%s/%s]',weapons.get_name(IDweapon),getAmmoInClip(),getAmmoInCharWeapon(PLAYER_PED, IDweapon)-getAmmoInClip())))
            end
        end

        if infIni.sett.ShowCar then
            if isCharInAnyCar(PLAYER_PED) then
                local IDcar = getCarModel(CarHandle)
                local CarHealth = getCarHealth(CarHandle)
                local CarSpeed = math.floor(getCarSpeed(CarHandle)*2)
                local CarName = CarsName[IDcar-399]
                imgui.Text(u8(string.format('Транспорт: %s | HP: %s | Скорость: %s',CarName,CarHealth,CarSpeed)))
            end
        end

        if infIni.sett.ShowCord then imgui.Text(u8'Местоположение: '..u8(kvadrat())) end

        if infIni.sett.ShowDate then imgui.Text(u8(os.date('Время: %H:%M:%S | %A %d.%m.%Y'))) end

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
    

    dci = getWorkingDirectory()..'\\cfg\\'..MyName..'\\infbar.ini'
    infIni = inicfg.load(nil,dci)
    

    checkDirectory(MyName)

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
    if mainIni.config.infbr then
        imgui.Process = true
        imgui.ShowCursor = false
    else
        imgui.Process = false
    end

    if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and isPlayerPlaying(playerHandle) and editKeys == 0 then
        
        if isKeysDown(keyAdminMenu) then
                sampSendChat("/stats")
          end
     end

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

        if mainIni.config.infbr then
            imgui.ShowCursor = false
        end

        
        if mouseCord then
			sampToggleCursor(true)
			CPX, CPY = getCursorPos()
			infIni.sett.x = CPX
            infIni.sett.y = CPY
            if imgui.IsMouseClicked(0) and mouseCord then
                sampToggleCursor(false)
                mouseCord = false
                imgui.Process = true
            end
            inicfg.save(infIni,dci)
		end

        wait(0)
    end
end


function cmd_f(arg)
    sampSendChat('/r '..mainIni.config.rteg..' '..arg)
end

------ function in imgui ------

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end


function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], text[i])
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(w) end
        end
    end

    render_text(text)
end

---- sampev ------
function sampev.onSendSpawn()
    local myskin = getCharModel(PLAYER_PED)
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


function sampev.onShowDialog(dialogID, style, title, button1, button2, text)
    if dialogID == 20053 then
       GetAutoBP()
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
            local mod = text:match('(%S+): .+'):gsub(" ", "")
            if string.match(mod,'(%a+_%a+).(%d+)') then
                nick,id = string.match(mod,'(%a+_%a+).(%d+)')
                colors = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                text = text:gsub(nick, ("{8D8DFF}{%s}%s {%s}"):format(colors, nick, ("%06X"):format(bit.rshift(color, 8))))
            else
                id = sampGetPlayerIdByNickname(mod)
                text = text:gsub(mod, ("{8D8DFF}{%s}%s [%s]{%s}"):format(("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF)), mod,id, ("%06X"):format(bit.rshift(color, 8))))
            end
            return {color,text}
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
        print('Найден пункт конфигурации')
    else
        crfld = createDirectory(directFolder)
        if crfld then
            print('Папка аккаунта успешно создана.')
        else
            print('Во время создание папки аккаунта произошла ошибка')
        end
    end
    if true then
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
        directFileInfbar = directFolder..'\\infbar.ini'
        if doesFileExist(directFileInfbar) then
            print('Инфо-Бар загружен')
        else
            file = io.open(directFileInfbar,'w')
            file.close()
            if inicfg.save(newInf,directFileInfbar) then
                print('Инфо-Бар создан')
            end
        end
    end
end
----------- hot keys ----------------
function getDownKeys()
    local curkeys = ""
    local bool = false
    for k, v in pairs(key) do
        if isKeyDown(v) and (v == VK_MENU or v == VK_CONTROL or v == VK_SHIFT or v == VK_LMENU or v == VK_RMENU or v == VK_RCONTROL or v == VK_LCONTROL or v == VK_LSHIFT or v == VK_RSHIFT) then
            if v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT then
                curkeys = v
            end
        end
    end
    for k, v in pairs(key) do
        if isKeyDown(v) and (v ~= VK_MENU and v ~= VK_CONTROL and v ~= VK_SHIFT and v ~= VK_LMENU and v ~= VK_RMENU and v ~= VK_RCONTROL and v ~= VK_LCONTROL and v ~= VK_LSHIFT and v ~= VK_RSHIFT) then
            if tostring(curkeys):len() == 0 then
                curkeys = v
            else
                curkeys = curkeys .. " " .. v
            end
            bool = true
        end
    end
    return curkeys, bool
end

function isKeysDown(keylist, pressed)
    local tKeys = string.split(keylist, " ")
    if pressed == nil then
        pressed = false
    end
    if tKeys[1] == nil then
        return false
    end
    local bool = false
    local key = #tKeys < 2 and tonumber(tKeys[1]) or tonumber(tKeys[2])
    local modified = tonumber(tKeys[1])
    if #tKeys < 2 then
        if not isKeyDown(VK_RMENU) and not isKeyDown(VK_LMENU) and not isKeyDown(VK_LSHIFT) and not isKeyDown(VK_RSHIFT) and not isKeyDown(VK_LCONTROL) and not isKeyDown(VK_RCONTROL) then
            if wasKeyPressed(key) and not pressed then
                bool = true
            elseif isKeyDown(key) and pressed then
                bool = true
            end
        end
    else
        if isKeyDown(modified) and not wasKeyReleased(modified) then
            if wasKeyPressed(key) and not pressed then
                bool = true
            elseif isKeyDown(key) and pressed then
                bool = true
            end
        end
    end
    if nextLockKey == keylist then
        if pressed and not wasKeyReleased(key) then
            bool = false
--            nextLockKey = ""
        else
            bool = false
            nextLockKey = ""
        end
    end
    return bool
end

function string.split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function imgui.Hotkey(name, keyBuf, width)
    local name = tostring(name)
    local keys, endkey = getDownKeys()
    local keysName = ""
    local ImVec2 = imgui.ImVec2
    local bool = false
    if editHotkey == name then
        if keys == VK_BACK then
            keyBuf.v = ''
            editHotkey = nil
            nextLockKey = keys
            editKeys = 0
        else
            local tNames = string.split(keys, " ")
            local keylist = ""
            for _, v in ipairs(tNames) do
                local key = tostring(key.id_to_name(tonumber(v)))
                if tostring(keylist):len() == 0 then
                    keylist = key
                else
                    keylist = keylist .. " + " .. key
                end
            end
            keysName = keylist
            if endkey then
                bool = true
                keyBuf.v = keys
                editHotkey = nil
                nextLockKey = keys
                editKeys = 0
            end
        end
    else
        local tNames = string.split(keyBuf.v, " ")
        for _, v in ipairs(tNames) do
            local key = tostring(vkeys.id_to_name(tonumber(v)))
            if tostring(keysName):len() == 0 then
                keysName = key
            else
                keysName = keysName .. " + " .. key
            end
        end
    end
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    imgui.PushStyleColor(imgui.Col.Button, colors[clr.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonActive, colors[clr.FrameBg])
    imgui.PushStyleColor(imgui.Col.ButtonHovered, colors[clr.FrameBg])
    imgui.PushStyleVar(imgui.StyleVar.ButtonTextAlign, ImVec2(0.04, 0.5))
    imgui.Button(u8((tostring(keysName):len() > 0 or editHotkey == name) and keysName or "Нет"), ImVec2(width, 20))
    imgui.PopStyleVar()
    imgui.PopStyleColor(3)
    if imgui.IsItemHovered() and imgui.IsItemClicked() and editHotkey == nil then
        editHotkey = name
        editKeys = 100
    end
    if name:len() > 0 then
        imgui.SameLine()
        imgui.Text(name)
    end
    return bool
end

function onWindowMessage(msg, wparam, lparam)
    if(msg == 0x100 or msg == 0x101) then
        if (wparam == VK_ESCAPE or wparam == VK_RETURN or wparam == VK_TAB or wparam == VK_F6 or wparam == VK_F7 or wparam == VK_F8 or wparam == VK_T or wparam == VK_OEM_3) and msg == 0x100 and editKeys > 0 then
            consumeWindowMessage(true, true)
            editHotkey = nil
       end
    end
end
-------------------------------------
function getAmmoInClip()
    local pointer = getCharPointer(playerPed)
    local weapon = getCurrentCharWeapon(playerPed)
    local slot = getWeapontypeSlot(weapon)
    local cweapon = pointer + 0x5A0
    local current_cweapon = cweapon + slot * 0x1C
    return memory.getuint32(current_cweapon + 0x8)
end

function GetAutoBP()
    _,myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    MyName = sampGetPlayerNickname(myid)

    dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)
    if mainIni.settings.autoBP then
        local gun = {}
        if mainIni.abp.deagle then table.insert( gun, 0) end
        if mainIni.abp.shot then table.insert( gun,1 ) end
        if mainIni.abp.smg then table.insert( gun,2 ) end
        if mainIni.abp.m4 then table.insert( gun,3 ) end
        if mainIni.abp.rifle then table.insert( gun,4 ) end
        if mainIni.abp.armour then table.insert( gun,5 ) end
        if mainIni.abp.spec then table.insert( gun,6 ) end
        lua_thread.create(function()
            wait(500)
            if autoBP == #gun + 1 then -- остановка авто-бп 
                autoBP = 1
                if mainIni.abp.close then
                    sampCloseCurrentDialogWithButton(0)
                end
            elseif gun[autoBP] == 5 then
                autoBP = autoBP + 1
                wait(50)
                sampSendDialogResponse(20053, 1, 5)
                wait(500)
                sampSendDialogResponse(32700, 1, 2)
                wait(50)
                sampCloseCurrentDialogWithButton(0)
                return
            else
                sampSendDialogResponse(20053, 1, gun[autoBP])
                autoBP = autoBP + 1
                print(autoBP,gun[autoBP],2,#gun)
            end
        end)
    end
end
--------------------------------------
function kvadrat(KV)
    local KV = {
			[1] = "А",
			 [2] = "Б",
			 [3] = "В",
			 [4] = "Г",
			 [5] = "Д",
			 [6] = "Ж",
			 [7] = "З",
			 [8] = "И",
			 [9] = "К",
			 [10] = "Л",
			 [11] = "М",
			 [12] = "Н",
			 [13] = "О",
			 [14] = "П",
			 [15] = "Р",
			 [16] = "С",
			 [17] = "Т",
			 [18] = "У",
			 [19] = "Ф",
			 [20] = "Х",
			 [21] = "Ц",
			 [22] = "Ч",
			 [23] = "Ш",
			 [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
		local KVX = (Y.."-"..X)
    return KVX
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