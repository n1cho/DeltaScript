-- This script create for Las Venturas Army Evolve Role Play 02
-- Script author Nicho. Contacts - https://vk.com/n1chooff
-- version 0.7

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

local DopBind = {'{MyId} - ваш ID','{MyName} - ваш ник с "_"','{MyNameR} - ваш ник без "_"','{TarName} - ник цели(Target)','{TarNameR} - ник цели(Target) без "_"',
    '{CarName} - название машины','{CarHealt} - состояние машины','{PassegerName} - Ник(-и) пасажиров без "_"',"{PassegerID} - ID(-ы) ваших пасажиров",
    '{KV} - пишет ваш квадрат','{MyTeg} - ваш тег в рацию','{MyRang} - ваш ранг','{NowDate} - возвращает время в формате H:M:S'}
local DopText = ""

for _, str in ipairs(DopBind) do
    DopText = DopText .. str .. "\n"
end

dayName = {"Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"}
dayNameS = {'Mon','Tue','Wed','Thu','Fri','Sat','Sun'}
----------------------
-- import ------
local sampev = require 'lib.samp.events'
local imgui = require "imgui"
local inicfg = require "inicfg"
local key = require "vkeys"
local imadd = require 'imgui_addons'
local weapons = require 'game.weapons'
local memory = require "memory"
local dlstatus = require('moonloader').download_status
local pie = nil
-----------------

------- locals
local complete = false
local mouseCord = false
local fastmenu = false
local imwin = nil -- для меню настроек
local autoBP = 1
local line_binder = 50
local changeBind = nil
local levelBinder = {}
local pric = ''
local modBinder = {}
local tid = nil
local startTime = nil
local afkTime = 0
local sesionOnline = 0
local sesionOnline1 = 0
------ settings -------


local newIni = {
    config = {
        rteg = '',
        acls = '7',
        infbr = false,
        modRacia=false,
        modMembers=false,
        rangName = nil,
        sex = 0,
        fraction = nil
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
local newOnl = {
    day = {
        MonOnl = 0,
        MonAFK = 0,
        TueOnl = 0,
        TueAFK = 0,
        WedOnl = 0,
        WedAFK = 0,
        ThuOnl = 0,
        ThuAFK = 0,
        FriOnl = 0,
        FriAFK = 0,
        SatOnl = 0,
        SatAFK = 0,
        SunOnl = 0,
        SunAFK = 0
    },
    week = {
        onl = 0,
        afk = 0,
        weak = os.date('%W')
    }
}
function sampev.onSendClientJoin(version, mod, nick)
    
end

---------- imgui -------------
local encoding = require 'encoding' 
encoding.default = 'CP1251' 
u8 = encoding.UTF8

local mws = imgui.ImBool(false) -- main window state
local sws = imgui.ImBool(false) -- settings window state
local bws = imgui.ImBool(false) -- binder window state
local lws = imgui.ImBool(false) -- law window state
local dws = imgui.ImBool(false) -- dop window state
local ows = imgui.ImBool(false) -- online window state

local choseLaw = imgui.ImInt(0)
local chosePlace = imgui.ImInt(1)
local choseCH = imgui.ImInt(0)

local success = imgui.ImBool(false)
--------------
local sw,sh = getScreenResolution()

function imgui.OnDrawFrame()
    infbr = imgui.ImBool(mainIni.config.infbr) 

    if not mws.v and not sws.v and not infbr.v and not bws.v and not fastmenu and not lws.v and not dws.v and not ows.v then
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

    dcb = getWorkingDirectory()..'\\cfg\\'..MyName..'\\binder.ini'
    binderIni = inicfg.load(nil,dcb)


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
    local inputPrichina = imgui.ImBuffer(u8(pric),256)
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
        
        if imgui.Button(u8'Биндер',btn_size) then bws.v = not bws.v end

        if imgui.Button(u8'Онлайн',btn_size) then ows.v = not ows.v end

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

        imgui.Text(u8'Отыграно: '..get_clock(onlineIni.day[os.date('%a')..'Onl'])..' AFK: '..get_clock(onlineIni.day[os.date('%a')..'AFK']))

        imgui.End()
    end

    if bws.v then

        imgui.ShowCursor = true

        imgui.SetNextWindowSize(imgui.ImVec2(780, 314), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5)) -- in center monitor
        imgui.Begin(u8'Биндер',bws,imgui.WindowFlags.NoResize)

        imgui.BeginChild('Редактирование',imgui.ImVec2(640,280),true)
        i = 0
        if changeBind then
            if binderIni[changeBind] then
                levelBinder[1] = imgui.ImBuffer(u8(binderIni[changeBind].name),32) -- название
                levelBinder[2] = imgui.ImBuffer(u8(binderIni[changeBind].act),24) -- команда активации
                levelBinder[3] = imgui.ImBuffer(u8(binderIni[changeBind].wait),16) -- пауза
                levelBinder[4] = imgui.ImBuffer(1024) -- редактор
            
                for g = 1, 30 do
                    if binderIni[changeBind][g] == nil then
                        break
                    else
                        if g == 1 then
                            levelBinder[4].v = u8(binderIni[changeBind][g])
                        else
                            levelBinder[4].v = levelBinder[4].v .. "\n" .. u8(binderIni[changeBind][g])
                            levelBinder[4].v = levelBinder[4].v
                        end
                    end
                end
            
                imgui.PushItemWidth(175)
                
                imgui.SetCursorPosX( 220,320)
                if imgui.InputText(u8"Название бинда", levelBinder[1]) then
                    binderIni[changeBind].name = u8:decode(levelBinder[1].v)
                end
                imgui.PopItemWidth()

                imgui.PushItemWidth(125)
                if imgui.InputText(u8'Команда активации',levelBinder[2]) then
                    binderIni[changeBind].act = u8:decode(levelBinder[2].v)
                end

                imgui.SameLine()

                imgui.SetCursorPosX( 405,_)

                imgui.Text(u8'Задержка(в мс):')
                
                imgui.SameLine()

                imgui.SetCursorPosX( 505,_)

                if imgui.InputText(u8'##6',levelBinder[3]) then
                    binderIni[changeBind].wait = u8:decode(levelBinder[3].v)
                end

                imgui.PopItemWidth()


                imgui.CenterText(u8'Редактор')
                imgui.InputTextMultiline('##2', levelBinder[4], imgui.ImVec2(640, 178))

                for b = 1, 30 do
                    if binderIni[changeBind] ~= nil then
                        if binderIni[changeBind][b] ~= nil then
                            binderIni[changeBind][b] = nil
                        else
                            break
                        end
                    else
                        break
                    end
                end

                for s in string.gmatch(u8:decode(levelBinder[4].v), "[^\r\n]+") do
                    i = i + 1
                    binderIni[changeBind][i] = s
                end

                if imgui.Button(u8'Доп.Возможности') then
                    dws.v = not dws.v
                end

                imgui.SameLine()

                imgui.TextQuestion("( ? )", u8"Что-бы закрыть окно,нажмите ещё раз на кнопку")

                imgui.SameLine()

                imgui.SetCursorPosX( 544,_)

                if imgui.Button(u8'Удалить бинд') then
                    for i = 0,30 do
                        binderIni[changeBind][i] = nil
                    end
                    binderIni[changeBind].wait = nil
                    binderIni[changeBind].act = nil
                    binderIni[changeBind].name = nil
                    binderIni[changeBind] = nil
                    imgui.CloseCurrentPopup()
                end
            end
            inicfg.save(binderIni,dcb)
        end

        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginChild('Выбор',imgui.ImVec2(120,280),true)
            for i = 0, line_binder + 10 do
                if binderIni[i] then
                    if imgui.Selectable(u8(binderIni[i].name)) then changeBind = i end
                end
            end
            if imgui.Button(u8'Добавить бинд') then
                for i = 1,line_binder + 10 do
                    if binderIni[i] == nil or binderIni[i] == '' then
                        binderIni[i] = {}
                        g = 'name'
                        binderIni[i][g] = 'Бинд №'..i
                        binderIni[i][1] = ''
                        binderIni[i].act = ''
                        binderIni[i].wait = 1000
                        inicfg.save(binderIni,dcb)
                        break
                    end
                end
            end
        imgui.EndChild()

        if dws.v then
            imgui.SetNextWindowPos(imgui.ImVec2((sw/2 + 385),(sh/2)-100),imgui.ImVec2(0.5,0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
            imgui.Begin('dop',_,imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
            imgui.Text(u8(DopText))
            imgui.End()
        end
    

        imgui.End()
    end

    if lws.v then
        imgui.ShowCursor = true

        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5)) -- in center monitor
        imgui.Begin(u8'Наказание',lws)

        imgui.RadioButton(u8"Наряд", choseLaw, 1)
        imgui.SameLine()
        imgui.RadioButton(u8"Выговор", choseLaw, 2)
        imgui.SameLine()
        imgui.RadioButton(u8'Увольнение',choseLaw,3)
        imgui.Separator()

        
        if choseLaw.v == 1 then
            imgui.RadioButton(u8'Вокруг ГС',chosePlace,1)
            imgui.SameLine()
            imgui.RadioButton(u8'Вокруг Части',chosePlace,2)

            if chosePlace then
                if chosePlace.v == 1 then
                    place = 'ГС'
                elseif chosePlace.v == 2 then
                    place = 'части'
                end
                imgui.PushItemWidth(300)
                if imgui.InputText(u8'Причина',inputPrichina) then
                    pric = u8:decode(inputPrichina.v)
                end
                imgui.Text(string.format(u8'/r %s %s получает наряд вокруг %s, за %s',u8(mainIni.config.rteg),tname,u8(place),u8(pric)))
                if imgui.Checkbox(u8'Потдвердить',success) then end
                if success.v then
                    if imgui.Button(u8'Выдать') then
                        sampSendChat(string.format('/r %s %s получает наряд вокруг %s, за %s',mainIni.config.rteg,tname,place,pric))
                    end
                end
            end
        elseif choseLaw.v == 2 then
            if imgui.InputText(u8'Причина',inputPrichina) then
                pric = u8:decode(inputPrichina.v)
            end
            imgui.Text(string.format(u8'/r %s %s получает выговор, за %s',u8(mainIni.config.rteg),tname,u8(pric)))
            if imgui.Checkbox(u8'Потдвердить',success) then end
            if success.v then
                if imgui.Button(u8'Выдать') then
                    sampSendChat(string.format('/r %s %s получает выговор, за %s',mainIni.config.rteg,tname,pric))
                end
            end
        elseif choseLaw.v == 3 then
            imgui.RadioButton(u8'Без ЧС',choseCH,0)
            imgui.SameLine()
            imgui.RadioButton(u8'С ЧС',choseCH,1)

            if choseCH.v == 0 then
                ch = ''
            elseif choseCH.v == 1 then
                ch = ' с занесением в Черный Список'
            end
            if imgui.InputText(u8'Причина',inputPrichina) then
                pric = u8:decode(inputPrichina.v)
            end
            imgui.Text(string.format(u8'/r %s %s уволен с рядов армии%s, за %s',u8(mainIni.config.rteg),tname,u8(ch),u8(pric)))
            if imgui.Checkbox(u8'Потдвердить',success) then end
            if success.v then
                if imgui.Button(u8'Выдать') then
                    sampSendChat(string.format('/r %s %s уволен с рядов армии%s, за %s',mainIni.config.rteg,tname,ch,pric))
                end
            end
        end

        imgui.End()
    end


    if fastmenu then
        
        NowIp = sampGetCurrentServerAddress()

        imgui.OpenPopup('PieMenu')
        if pie.BeginPiePopup('PieMenu') then
            imgui.ShowCursor = true
            if pie.BeginPieMenu(u8'Действия')  then
                if pie.PieMenuItem(u8'Сорвать маску') then
                    if mainIni.config.sex == 'Мужчина' then
                        sampSendChat('/me сорвал маску с лица '..tname)
                    else
                        sampSendChat('/me сорвала маску с лица '..tname)
                    end
                    fastmenu=false
                end
                if pie.PieMenuItem(u8'Связать') then
                    lua_thread.create(function()
                        if mainIni.config.sex == 'Мужчина' then
                            sampSendChat('/me заломил руки человеку напротив,затем достал веревку и связал человека')
                        else
                            sampSendChat('/me заломилa руки человеку напротив,затем достал веревку и связал человека')
                        end
                        wait(1500)
                        sampSendChat('/tie '..id)
                    end)
                    fastmenu = false
                end
                if pie.PieMenuItem(u8'Развязать') then
                    lua_thread.create(function()
                        sampSendChat('/do На ноге пристегнута кобура для ножа.')
                        wait(1000)
                        if mainIni.config.sex == 'Мужчина' then
                            sampSendChat('/me достал из кобуры нож,затем резким движение разрезал верёвку')
                        else
                            sampSendChat('/me досталa из кобуры нож,затем резким движение разрезал верёвку')
                        end
                        wait(1000)
                        sampSendChat('/untie '..id)
                    end)
                    fastmenu = false
                end
                pie.EndPieMenu()
            end

            if pie.BeginPieMenu(u8'Запросить') then
                if pie.PieMenuItem(u8'Местоположение\n(30 секунд)') then
                    sampSendChat(string.format('/w %s ваше местоположение, на ответ 30 секнду',tname))
                    fastmenu = false
                end
                if pie.PieMenuItem(u8'Документы') then
                    sampSendChat(string.format('Здравия желаю,%s %s %s, предъявите ваши документы',mainIni.config.rangName,mainIni.config.fraction,MyName:gsub('_',' ')))
                    fastmenu = false
                end
                pie.EndPieMenu()
            end

            if pie.BeginPieMenu(u8'Показать') then
                if pie.PieMenuItem(u8'Паспорт') then
                    sampSendChat('/showpass '..id)
                    fastmenu = false
                end

                if pie.PieMenuItem(u8'Лицензии') then
                    sampSendChat('/showlicenses '..id)
                    fastmenu = false
                end
                
                pie.EndPieMenu()
            end

            if pie.BeginPieMenu(u8'Выдать') then
                if pie.PieMenuItem(u8'Наказание') then
                   lws.v = true
                   imgui.Process = lws.v
                   fastmenu = false
                end 
                if tostring(NowIp) == '185.169.134.68' and mainIni.config.fraction == 'LVA' then 
                    if pie.BeginPieMenu(u8'Берет') then
                        if pie.BeginPieMenu(u8'ВВО') then
                            if pie.PieMenuItem(u8'Боец') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал каску Бойца ВВО '..tname)
                                else
                                    sampSendChat('/me передала каску Бойца ВВО '..tname)
                                end
                                fastmenu = false
                            end
                            if pie.PieMenuItem(u8'СП') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал берет Старшего Постового ВВО '..tname)
                                else
                                    sampSendChat('/me передала берет Старшего Постового ВВО '..tname)
                                end
                                fastmenu = false
                            end
                            pie.EndPieMenu()
                        end

                        if pie.BeginPieMenu(u8'Спецура') then
                            if pie.BeginPieMenu('Delta') then
                                if pie.PieMenuItem(u8'Стажёр') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Cтажер Delta '..tname)
                                    else
                                        sampSendChat('/me передалa берет Cтажер Delta '..tname)
                                    end
                                    fastmenu = false
                                end
            
                                if pie.PieMenuItem(u8'Инструктор') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Инструктор Delta '..tname)
                                    else
                                        sampSendChat('/me передалa берет Инструктор Delta '..tname)
                                    end
                                    fastmenu = false
                                end
            
                                if pie.PieMenuItem(u8'Агент') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Агент Delta '..tname)
                                    else
                                        sampSendChat('/me передалa берет Агент Delta '..tname)
                                    end
                                    fastmenu = false
                                end
            
                                pie.EndPieMenu()
                            end
            
                            if pie.BeginPieMenu(u8'СОБР') then
                                if pie.PieMenuItem(u8'Стажер') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Стажер СОБР '..tname)
                                    else
                                        sampSendChat('/me передалa берет Стажер СОБР '..tname)
                                    end
                                    fastmenu = false
                                end
            
                                if pie.PieMenuItem(u8'Основа') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Основа СОБР '..tname)
                                    else
                                        sampSendChat('/me передалa берет Основа СОБР '..tname)
                                    end
                                    fastmenu = false
                                end
            
                                if pie.PieMenuItem(u8'Инструктор') then
                                    if mainIni.config.sex == 'Мужчина' then
                                        sampSendChat('/me передал берет Инструктор СОБР '..tname)
                                    else
                                        sampSendChat('/me передалa берет Инструктор СОБР '..tname)
                                    end
                                    fastmenu = false
                                end
                                pie.EndPieMenu()
                            end
                            pie.EndPieMenu()
                        end


                        if pie.BeginPieMenu(u8'Альфа') then
                            if pie.PieMenuItem(u8'Курсант') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал каску Курсанта ОСН "Альфа" '..tname)
                                else
                                    sampSendChat('/me передала каску Курсанта ОСН "Альфа" '..tname)
                                end
                                fastmenu = false
                            end

                            if pie.PieMenuItem(u8'Основа') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал каску Бойца ОСН "Альфа" '..tname)
                                else
                                    sampSendChat('/me передала каску Бойца ОСН "Альфа" '..tname)
                                end
                                fastmenu = false
                            end

                            if pie.PieMenuItem(u8'ОП') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал берет Отдела Подготовки ОСН "Альфа" '..tname)
                                else
                                    sampSendChat('/me передала берет Отдела Подготовки ОСН "Альфа" '..tname)
                                end
                                fastmenu = false
                            end
                            
                            pie.EndPieMenu()
                        end


                        if pie.BeginPieMenu(u8'Снабжение') then
                            if pie.PieMenuItem(u8'Стажер') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал каску Стажера Снабжения '..tname)
                                else
                                    sampSendChat('/me передалa каску Стажера Снабжения '..tname)
                                end
                                fastmenu = false
                            end

                            if pie.PieMenuItem(u8'Основы') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал каску Основы Снабжения '..tname)
                                else
                                    sampSendChat('/me передалa каску Основы Снабжения '..tname)
                                end
                                fastmenu = false
                            end

                            if pie.PieMenuItem(u8'Заведующего') then
                                if mainIni.config.sex == 'Мужчина' then
                                    sampSendChat('/me передал берет Заведующего Снабжения '..tname)
                                else
                                    sampSendChat('/me передалa берет Заведующего Снабжения '..tname)
                                end
                                fastmenu = false
                            end

                            pie.EndPieMenu()
                        end

                        pie.EndPieMenu()
                    end

                end

            
                pie.EndPieMenu() 
            end
            if pie.PieMenuItem(u8'Отмена') then fastmenu = false end        
        end
        pie.EndPiePopup()
    end

    if ows.v then
        imgui.SetNextWindowSize(imgui.ImVec2(550, 250), imgui.Cond.FirstUseEver) -- resoluthion window
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5)) -- in center monitor
        imgui.Begin(u8'Онлайн',ows,imgui.WindowFlags.NoResize)
        imgui.BeginChild('days',imgui.ImVec2(350,215),true)
            imgui.BeginChild('day',imgui.ImVec2(120,150))
                imgui.Text(u8'День:')
                for i =1,#dayName do
                    imgui.Text(u8(dayName[i]))
                end
            imgui.EndChild()

            imgui.SameLine()


            imgui.BeginChild('onl',imgui.ImVec2(120,150))
                imgui.Text(u8'Онлайн:')
                for i = 1,#dayNameS do
                    imgui.Text(u8(get_clock(onlineIni.day[dayNameS[i]..'Onl'])))
                end
            imgui.EndChild()

            imgui.SameLine()


            imgui.BeginChild('afk')
                imgui.Text(u8'AFK:')
                for i = 1,#dayNameS do
                    imgui.Text(u8(get_clock(onlineIni.day[dayNameS[i]..'AFK'])))
                end
            imgui.EndChild()
        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginChild('weekANDsesion',imgui.ImVec2(180,215))
            imgui.BeginChild('sesion',imgui.ImVec2(180,106),true)
                imgui.CenterText(u8'За сесию:')
                imgui.Text(u8'Онлайн: '..u8(get_clock(sesionOnline)))
                imgui.Text('AFK: '..u8(get_clock(afkTimeS)))
                imgui.Text(u8'Всего: '..u8(get_clock((afkTimeS+sesionOnline))))
            imgui.EndChild()

            imgui.BeginChild('week',imgui.ImVec2(180,105),true)
            imgui.CenterText(u8'За неделю:')
            imgui.Text(u8'Онлайн: '..u8(get_clock(onlineIni.week.onl)))
            imgui.Text('AFK: '..u8(get_clock(onlineIni.week.afk)))
            imgui.Text(u8'Всего: '..u8(get_clock((onlineIni.week.afk+onlineIni.week.onl))))
            imgui.EndChild()
        imgui.EndChild()
        --imgui.Text(u8'Отыграно: '..get_clock(onlineIni.day[os.date('%a')..'Onl'])..' AFK: '..get_clock(onlineIni.day[os.date('%a')..'AFK']))
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

    mainDirectory = getWorkingDirectory()..'\\cfg\\'..MyName

    dcf = mainDirectory..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)
    
    dcb = mainDirectory..'\\binder.ini'
    binderIni = inicfg.load(nil,dcb)

    dco = mainDirectory..'\\online.ini'
    onlineIni = inicfg.load(nil,dco)

    dci = mainDirectory..'\\infbar.ini'
    infIni = inicfg.load(nil,dci)
    
    updateTime()

    checkDirectory(MyName)

    sampAddChatMessage(sname..'Скрипт загружен',-1)


    sampRegisterChatCommand('lv',function()
        mws.v = not mws.v
        if imgui.Process then
            
        else
            imgui.Process = mws.v
        end
    end)
    
    
    while not sampIsLocalPlayerSpawned() do wait(0) end
    check_stats()

    startTime = os.time()

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

    lua_thread.create(time)

    while true do

        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE) 
        if valid and doesCharExist(ped) then 
            result, id = sampGetPlayerIdByCharHandle(ped) 
            if result then
                tid = id
                tname = sampGetPlayerNickname(id):gsub('_', ' ') 
                local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(id))) 
                if result and isKeyJustPressed(key.VK_Z) then
                   fastmenu = true
                   imgui.Process = fastmenu
                end
            end
        end

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

function time()
    while true do
        wait(1000)
        sesionOnline = sesionOnline + 1
        sesionOnline1 = sesionOnline1 + 1
        onlineIni.week.onl = onlineIni.week.onl + 1
        onlineIni.day[os.date('%a')..'Onl'] = onlineIni.day[os.date('%a')..'Onl'] + 1
        fullTime = os.time() - startTime
        afkTime = fullTime - sesionOnline
        afkTimeS = fullTime - sesionOnline1
        onlineIni.day[os.date('%a')..'AFK'] = onlineIni.day[os.date('%a')..'AFK'] + afkTime
        onlineIni.week.afk = onlineIni.week.afk + afkTime
        sesionOnline = sesionOnline + afkTime
        inicfg.save(onlineIni,dco)
    end
end

function updateTime() 
    if tonumber(onlineIni.week.weak) ~= tonumber(os.date('%W')) then
        text = string.format(sname..'Началась новая неделя. За предыдущую неделю отыграли %s',get_clock((onlineIni.week.onl + onlineIni.week.afk)))
        sampAddChatMessage(text,-1)
        for i = 1,#dayNameS do
            onlineIni.day[dayNameS[i]..'Onl'] = 0
            onlineIni.day[dayNameS[i]..'AFK'] = 0
        end
        onlineIni.week.onl = 0
        onlineIni.week.afk = 0
        onlineIni.week.weak = os.date('%W')
    end
    inicfg.save(onlineIni,dco)
end


function cmd_f(arg)
    sampSendChat('/r '..mainIni.config.rteg..' '..arg)
end


function check_stats()
    lua_thread.create(function()
        sampSendChat('/stats')
        wait(50)
        while not sampIsDialogActive() or sampGetCurrentDialogId() ~= 9901 do wait(0) end
        textDialog = sampGetDialogText()
        MyName = textDialog:match('Имя%s+(%a+_%a+)')

        dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
        mainIni = inicfg.load(nil,dcf)

        frac = textDialog:match('Организация%s+(.-)\n')
        full= textDialog:match('Должность%s+(.-)\n')
        idRang,nameRang = full:match('(%d+) %((.+)%)')        
        sex = textDialog:match('Пол%s+(.-)\n')

        sampCloseCurrentDialogWithButton(0)
        
        mainIni.config.fraction = frac
        mainIni.config.rangName = nameRang
        mainIni.config.sex = sex

        if inicfg.save(mainIni,dcf) then
            print('Информация обновлена')
        end


    end)
end

------ function in imgui ------
function imgui.TextQuestion(label, description)
    imgui.TextDisabled(label)

    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
            imgui.PushTextWrapPos(600)
                imgui.TextUnformatted(description)
            imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end


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

function sampev.onSendCommand(command)
    _,MyId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    MyName = sampGetPlayerNickname(MyId)
    TargetNick = sampGetPlayerNickname(tid)
    NowDate = os.date('%H:%M:%S')


    if isCharInAnyCar(PLAYER_PED) then
        CarHandle = getCarCharIsUsing(PLAYER_PED)
        IDcar = getCarModel(CarHandle)
        CarHealth = getCarHealth(CarHandle)
        CarName = CarsName[IDcar-399]

        n = 0

        for i = 0, sampGetMaxPlayerId(true) do
            bool, playerHandle = sampGetCharHandleBySampPlayerId(i)
            if bool and doesCharExist(playerHandle) then
                passCar = getCarCharIsUsing(playerHandle)
                if doesVehicleExist(passCar) and CarHandle == passCar then
                    n = n + 1
                    if n > 1 then
                        PassegerID = PassegerID..','..i
                        name = sampGetPlayerNickname(i)
                        PassegerName = PassegerName..','..name:gsub('_',' ')
                    else
                        PassegerName = sampGetPlayerNickname(i):gsub('_',' ')
                        PassegerID = i
                    end
                end
            end
        end
    end
    modBinder = {['MyId']=MyId,['MyName']=MyName,['MyNameR'] = MyName:gsub('_',' '),['TarName'] = TargetNick,
    ['TarNameR'] = TargetNick:gsub('_',' '),['CarName']=CarName,['CarHealth'] = CarHealth,['PassegerName'] = PassegerName,
    ['PassegerID'] = PassegerID,['KV']=kvadrat(),['MyTeg']=mainIni.config.rteg,['MyRang']=mainIni.config.rangName,
    ['NowDate'] = NowDate}
    for i = 1,line_binder do
        if binderIni[i] then
            if binderIni[i].act:find('/') then
                act = binderIni[i].act
            else
                act = '/'..binderIni[i].act
            end
            if act == command then
                lua_thread.create(function()
                    for s = 1,#binderIni[i] do
                        text = binderIni[i][s]
                        for word in string.gmatch(text, "{(%a+)}") do
                            if modBinder[word] then
                                text = string.gsub(text,'{'..word..'}',modBinder[word])
                            end
                        end
                        sampSendChat(text)
                        wait(binderIni[i].wait)
                    end
                end)
            end
        end
    end
end


function sampev.onServerMessage(color, text)

    local _,MyId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local MyName = sampGetPlayerNickname(MyId)


    dcf = getWorkingDirectory()..'\\cfg\\'..MyName..'\\config.ini'
    mainIni = inicfg.load(nil,dcf)

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
function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == key.VK_ESCAPE and (mws.v or sws.v or bws.v or dws.v)) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                if sws.v then
                    if imwin == 1 or imwin == 2 then
                        imwin = 0
                    else
                        sws.v = false
                    end
                elseif bws.v then
                    if changeBind then
                        changeBind = false
                    else
                        bws.v = false
                    end
                elseif ows.v then
                    ows.v = false
                else
                    mws.v = false
                end
            end
        end
    end
end


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
            if inicfg.save(newIni,directFileConfig) then print('Конфиг создан') end
        end
        directFileInfbar = directFolder..'\\infbar.ini'
        if doesFileExist(directFileInfbar) then
            print('Инфо-Бар загружен')
        else
            file = io.open(directFileInfbar,'w')
            file.close()
            if inicfg.save(newInf,directFileInfbar) then print('Инфо-Бар создан') end
        end
        directFileBinder = directFolder..'\\binder.ini'
        if doesFileExist(directFileBinder) then
            print('Биндер загружен')
        else
            file = io.open(directFileBinder,'w')
            file:write('[a]\n1=')
            file:close()
            print('Биндер создан')
        end
        directFileOnline = directFolder..'\\online.ini'
        if doesFileExist(directFileOnline) then
            print('Счётчик онлайна загружен')
        else
            file = io.open(directFileOnline,'w')
            file:close()
            if inicfg.save(newOnl,directFileOnline) then print('Счётчик онлайна создан') end
        end
    end
    libFolder = getWorkingDirectory()..'\\lib'
    checkPie = libFolder..'\\imgui_piemenu.lua'
    if doesFileExist(checkPie) then
        pie = require 'imgui_piemenu'
    else
        downloadUrlToFile('https://raw.githubusercontent.com/n1cho/EvolveRochester/main/cfg/imgui_piemenu.lua', checkPie, download_handler)
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
            wait(100)
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
            end
        end)
    end
end
--------------------------------------
function download_handler(id, status, p1, p2)
    if stop_downloading then
      stop_downloading = false
      download_id = nil
      return false -- прервать загрузку
    end
    if status == dlstatus.STATUS_DOWNLOADINGDATA then
      
    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
      
    end
end

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
------ timer --------
--[[function onScriptTerminate(script, quitGame)
    if script == thisScript() then
        endTime = os.time() - startTime
        afTime = endTime - onlineTime
        print(get_clock(endTime),get_clock(afTime))
    end
end]]

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
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