script_name("Delta Script")
script_author("N1CHO")

local sname = '{004080}[Delta Force]: {ffffff}'

local key = require "vkeys"
--------- к фаст меню
local dialogArr = {'Связать бойца','Развязать бойца',"Показать удостоверение",'Сорвать маску с бойца','Вызвать на плац','Запросить место положение(на ответ 30 секунд)'}
local dialogStr = ""

for _, str in ipairs(dialogArr) do
    dialogStr = dialogStr .. str .. "\n"
end
-------------------------


local dlstatus = require('moonloader').download_status
local monikQuant = {}

local sampev = require 'lib.samp.events'

function download_handler(id, status, p1, p2)
    if stop_downloading then
      stop_downloading = false
      download_id = nil
      print('Загрузка отменена.')
      return false -- прервать загрузку
    end
    if status == dlstatus.STATUS_DOWNLOADINGDATA then
      print(string.format('Загружено %d из %d.', p1, p2))
    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
      print('Загрузка завершена.')
    end
  end

-------------------------------------------------

----------------------- inicfg ------------------

local inicfg = require "inicfg"

local directFolder = getWorkingDirectory().."\\cfg"

local resultFold = doesDirectoryExist(directFolder)

if resultFold then

else
    result = createDirectory(directFolder)
    if result then
        print('Folder Create')
    else
        print('Folder 404')
    end
end

local result = doesFileExist('moonloader\\cfg\\config.ini')
if result and resultFold then

else
    local url = 'https://raw.githubusercontent.com/n1cho/DeltaScript/main/cfg/config.ini'
    local file_path = getWorkingDirectory()..'\\cfg\\config.ini'
    download_id = downloadUrlToFile(url, file_path, download_handler)
    print('Загрузка config\'aначата.')
end

local result = doesFileExist('moonloader\\cfg\\binder.lua')
if result and resultFold then
    local binder = require 'cfg\\binder'
else
    local url = 'https://raw.githubusercontent.com/n1cho/DeltaScript/main/cfg/binder.lua'
    local file_path = getWorkingDirectory()..'\\cfg\\binder.lua'
    download_id = downloadUrlToFile(url, file_path, download_handler)
    print('Загрузка binder\'a начата.')
end

local result = doesFileExist('moonloader\\cfg\\sostav.ini')
if result and resultFold then

else
    local url = 'https://raw.githubusercontent.com/n1cho/EvolveRochester/main/cfg/sostav.ini'
    local file_path = getWorkingDirectory()..'\\cfg\\sostav.ini'
    download_id = downloadUrlToFile(url, file_path, download_handler)
    print('Загрузка sostav\'a начата..')

end


local mainini = {
    config = {
        testIni = 'Отстутсвует файл с настройками, если что-то \nпоменяете в настройках,изменения при \nрелоге анулируються',
        senseTag = '[Delta]: ',
        autoClist = false,
        changeUdost = false,
        numberClist = '21',
        sostav = false,
        chekerMembers = false
    }
}

local directSettings = "moonloader\\cfg\\config.ini"
local mainIni = inicfg.load(mainini,directSettings)
local directSostav = "moonloader\\cfg\\sostav.ini"
local online = inicfg.load(nil,directSostav)
--------------------------------------------


--------------------- all in imgui -----
local imgui = require "imgui"

local encoding = require 'encoding' 
encoding.default = 'CP1251' 
u8 = encoding.UTF8


local mws = imgui.ImBool(false)
local sws = imgui.ImBool(false)
local uws = imgui.ImBool(false)
local cws = imgui.ImBool(false)


local sw,sh = getScreenResolution()

local inputRteg = imgui.ImBuffer(36)
local inputPosition = imgui.ImBuffer(64)
local inputInvName = imgui.ImBuffer(48)
local inputInvDate = imgui.ImBuffer(16)
local inputRang = imgui.ImBuffer(36)


local autoClist_cb = imgui.ImBool(mainIni.config.autoClist)
local changeUdost_cb = imgui.ImBool(mainIni.config.changeUdost)
local nC_slider = imgui.ImInt(mainIni.config.numberClist)
local chekerMembers = imgui.ImBool(mainIni.config.chekerMembers)
local sostavOnlines = imgui.ImBool(mainIni.config.sostav)

local mouseCord = false

function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end


function imgui.OnDrawFrame()
    if not mws.v and not sws.v and not uws.v and not cws.v then
        imgui.Process = false
    end

    local _ , myId = sampGetPlayerIdByCharHandle(PLAYER_PED) 
    MyName = sampGetPlayerNickname(myId):gsub('_', ' ')


    if mws.v then
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Main Window',mws)
        imgui.CentrText('Delta Script')
        imgui.Separator()
        if imgui.Button(u8'Команды скрипта',btn_size) then cws.v = not cws.v end
        if imgui.Button(u8'Settings',btn_size) then sws.v = not sws.v end
        imgui.Text(u8(mainIni.config.testIni))
        imgui.End()
    end
    
    if cws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(400, 270), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin(u8'Команды скрипта',cws)
        imgui.Text(u8'/dm - главное меню скрипта\n/getm - мониторинг гос.складов(работает только на территории армии)')
        imgui.Text(u8'/ccl - РП клист\n/pr - бинды для транспорта(покидание территории,сопровод и т.д)\n/stream - ники всех игроков в зоне стрима')
        imgui.Text(u8'/panel add/del - добавить/убрать игрока с панеля слежки\n/udost - показать удостоверение\n/agit - агитации в рацию')
        imgui.Text(u8'/disarm - обезвредить бомбу\n/fmon - надать первую медицинскую помощь\n/lec - лекции для бойцов\n/sos - кинуть сигнал СОС')
        imgui.Text(u8'/vz - вызвать на плац бойца\n/ms - узнать местоположение бойца\n/fmaska - надеть маску(как акс и команду)')
        imgui.Separator()
        imgui.Text(u8'Так сочитания клавиш:\nПравая Кнопка Мыши + Z - меню действия с бойцом\nЛевый Alt + G кинуть сигнал СОС (в рацию)')
        imgui.End()
    end

    if sws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Settings Window',sws)

        if imgui.InputText(u8'Введите тег',inputRteg) then
            mainIni.config.senseTag = u8:decode(inputRteg.v)
            if inicfg.save(mainIni,directSettings) then

            end
        end
        imgui.Text(u8('На данный момент ваш тег в рацию: '..mainIni.config.senseTag))
        imgui.Separator()
        if imgui.Checkbox(u8'Использовать авто-clist',autoClist_cb) then
            mainIni.config.autoClist = autoClist_cb.v
            if inicfg.save(mainIni,directSettings) then
                   
            end
        end

        if mainIni.config.autoClist then
            imgui.SliderInt(u8"Выберите клист", nC_slider, 1, 33)
            mainIni.config.numberClist = nC_slider.v
            if inicfg.save(mainIni,directSettings) then
                   
            end
        end
        imgui.Separator()
        if imgui.Checkbox(u8'Напоминане о проверке мемберса',chekerMembers) then
            mainini.config.chekerMembers = chekerMembers.v
            if inicfg.save(mainini,directSettings) then

            end
        end
        imgui.Separator()
        if imgui.Button(u8'Настройка удостоверения')then uws.v = not uws.v end
        imgui.PushItemWidth(75)
        imgui.Separator()
        if imgui.Checkbox(u8'Показывать онлайн состава Delta',sostavOnlines) then 
            mainIni.config.sostav  = sostavOnlines.v
            if inicfg.save(mainIni,directSettings) then
                   
            end
        end
        imgui.SameLine()
        if mainIni.config.sostav then
            if imgui.Button(u8'Изменить местопложение') then 
                mouseCord = true
            end
        end
        imgui.End()
    end

    if uws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(450, 225), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin(u8'Настройки удостоверение',uws)
        imgui.CentrText(u8'Наданый момент удостоверение выглядит так:')
        imgui.CentrText(u8' Army LV | ' ..MyName.. ' | '..u8(mainIni.udost.position).. ' | '..u8(mainIni.udost.nameRank)..'.')
        imgui.CentrText(u8'/do Выдано: '..u8(mainIni.udost.inviteName)..u8' |  Дата: '..mainIni.udost.inviteDate..'')
        imgui.Separator()
        imgui.PushItemWidth(185)
        if imgui.Checkbox(u8'Изменить удостоверение',changeUdost_cb) then
            mainIni.config.changeUdost = changeUdost_cb.v
            inicfg.save(mainIni,directIni)
        end
        if mainIni.config.changeUdost then
            if imgui.InputText(u8'Изменить должность',inputPosition) then mainIni.udost.position = u8:decode(inputPosition.v) end
            if imgui.InputText(u8'Изменить звание',inputRang) then mainIni.udost.nameRank = u8:decode(inputRang.v) end
            if imgui.InputText(u8'Изменить имя выдавшего удостоверение',inputInvName) then mainIni.udost.inviteName = u8:decode(inputInvName.v) end
            if imgui.InputText(u8'Изменить дату выдачи удостоверения',inputInvDate) then mainIni.udost.inviteDate = u8:decode(inputInvDate.v) end
        end
        imgui.End()
    end
end


-----------------------------------------------------
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Segoe UI', 10, font_flag.BOLD + font_flag.SHADOW)

local my_font2 = renderCreateFont('Verdana', 13, font_flag.BOLD + font_flag.SHADOW)

local chekerPlayer = {}

local idMask = {18911,18912,18913,18914,18915,18916,18917,18918,18919,18920}
local listItem = {}

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end


    sampAddChatMessage(sname..'Скрипт запущен. Меню скрипта {004080}/dm{ffffff}.Автор - Nicho',-1)


    sampRegisterChatCommand('dm',imgui_main_menu)

    sampRegisterChatCommand('ccl',cmd_ccl)
    sampRegisterChatCommand('getm',cmd_getm)
    sampRegisterChatCommand('sos',cmd_sos)
    sampRegisterChatCommand('panel',cmd_panel)
    sampRegisterChatCommand('stream',cmd_stream)
    sampRegisterChatCommand('pr',cmd_pr)
    sampRegisterChatCommand('udost',cmd_udost)
    sampRegisterChatCommand('lec',cmd_lecture)
    sampRegisterChatCommand('disarm',cmd_disarm)
    sampRegisterChatCommand('agit',cmd_agit)
    sampRegisterChatCommand('fmon',cmd_mon)
    sampRegisterChatCommand('vz',cmd_vz)
    sampRegisterChatCommand('ms',cmd_ms)
    sampRegisterChatCommand('sostav',cmd_sostav)
    sampRegisterChatCommand('fmaska',cmd_fmask)

    imgui.Process = false

    lua_thread.create(function ()
        if mainIni.config.chekerMembers then
            
            while os.date("%M") % 2 == 0 do
                wait(0)
                if os.date("%S") == "00" then
                    sampTextdrawCreate(44453, 'Check Members na progyl', 20, 300)
                end
                if os.date("%S") == "10" then
                    sampTextdrawDelete(44453)
                end
            end
        end
    end)

    imgui.SwitchContext()

        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4

        style.WindowRounding = 2
        style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
        style.ChildWindowRounding = 4.0
        style.FrameRounding = 3
        style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
        style.ScrollbarSize = 13.0
        style.ScrollbarRounding = 0
        style.GrabMinSize = 8.0
        style.GrabRounding = 1.0
        style.WindowPadding = imgui.ImVec2(4.0, 4.0)
        style.FramePadding = imgui.ImVec2(3.5, 3.5)
        style.ButtonTextAlign = imgui.ImVec2(0.0, 0.5)

        colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
        colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
        colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
        colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
        colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
        colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
        colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
        colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
        colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
        colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
        colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
        colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
        colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
        colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
        colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)


    while true do
        wait(0)


         ------------ Target Settings ---------------

         local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE) -- получить хендл персонажа, в которого целится игрок
         if valid and doesCharExist(ped) then -- если цель есть и персонаж существует
            result, id = sampGetPlayerIdByCharHandle(ped) -- получаем Target ID игрока
            if result then
                tname = sampGetPlayerNickname(id):gsub('_', ' ') -- получаем ник без '_'
                local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(id))) -- цвет ника (не потерять)
                if result and isKeyJustPressed(VK_Z) then
                    cmd_fastmenu(id)
                elseif result and isKeyJustPressed(VK_P) then
                    sampSendChat('/report '..id..' +C vne ghetto')
                elseif result and isKeyJustPressed(VK_O) then
                    sampSendChat('/report '..id..' sbiv')
                end
            end
         end
 


        local result, button, list, input = sampHasDialogRespond(10) -- Фаст Меню

        if result then
            if button == 1 then
                if list == 0 then
                    lua_thread.create(function()
                        sampSendChat('/me заломил руки человеку напротив, затем достал веревку и связял '..tname)
                        wait(1000)
                        sampSendChat('/tie '..id)
                    end)
                elseif list == 1 then
                    lua_thread.create(function()
                        sampSendChat('/do На ноге пристегнута кобура для ножа.')
                        wait(1000)
                        sampSendChat('/me достал из кобуры нож, затем резким движением разрезал верёвку')
                        wait(1000)
                        sampSendChat('/untie '.. id)
                    end)
                elseif list == 2 then
                    lua_thread.create(function()
                        local _ , myId = sampGetPlayerIdByCharHandle(PLAYER_PED) 
                        MyName = sampGetPlayerNickname(myId):gsub('_', ' ')
						sampSendChat('/me достал удостоверение с заднего кармана.')
						wait(1200)
						sampSendChat('/me показал удостоверение '..tname)
						wait(1200)
						sampSendChat('/do Army LV | ' ..MyName.. ' | '..mainIni.udost.position.. ' | '..mainIni.udost.nameRank..'.')
						wait(1000)
						sampSendChat('/do Выдано: '..mainIni.udost.inviteName..' |  Дата: '..mainIni.udost.inviteDate..'')
					end)
                elseif list == 3 then
                    sampSendChat('/me сорвал маску с лица '..tname)
                elseif list == 4 then
                    sampSendChat('/r '..mainIni.config.senseTag..' '..tname..' на плац, у вас 5 минут')
                elseif list == 5 then
                    sampSendChat('/r '..mainIni.config.senseTag..' '..tname..' ваше местонахождение. На ответ у вас 30 секунд.')
                end
            else

            end
        end
        if doesFileExist('moonloader\\cfg\\sostav.ini') then
            if mainIni.config.sostav then
                x = mainIni.config.sx
                y = mainIni.config.sy
                renderFontDrawText(my_font,'[Состав Онлайн]:', x, y, 0xFFFFFFFF)
                for i = 0,1001 do
                    if sampIsPlayerConnected(i) then
                        ScoreName = sampGetPlayerNickname(i)
                        color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(i)))
                        if #online.delta then
                            for d=0,#online.delta+20 do
                                
                                if ScoreName == online.delta[d] then
                                    y = y + 20
                                    textSostav = '{'..color..'}'..ScoreName..' ['..i..']'
                                    renderFontDrawText(my_font,textSostav, x, y, 0xFFFFFFFF)
                                end
                            end
                        end
                    end
                end
                if mouseCord then
                    sampToggleCursor(true)
                    mouseX, mouseY = getCursorPos()
                    imgui.Process = false
                end
                if mouseCord then
                    renderFontDrawText(my_font, '[Состав Онлайн]:', mouseX, mouseY, -1)
                    if isKeyDown(VK_LBUTTON) then
                        mouseCord = false
                    
                        mainIni.config.sx = mouseX
                        mainIni.config.sy = mouseY
                        inicfg.save(mainIni,directSettings)
                        sampToggleCursor(false)
                    end
                end
                panelCheker()
            else
                panelCheker()
            end
        else 
            panelCheker()
        end

        dds = {}


        
        


        if isKeyDown(VK_LMENU) and isKeyJustPressed(VK_G) then
            cmd_sos() 
        end


        
        local res,myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if res and doesCharExist(PLAYER_PED) then

            local result = isCharInArea2d(PLAYER_PED, 411.8054, 1698.6595, -41.8243, 2174.0203)

            local myskin = getCharModel(PLAYER_PED)
            if myskin == 287 or myskin == 191 or myskin == 179 or myskin == 61 or myskin == 255 or myskin == 73 then
                rabden = true
            end

            local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(myId)))
            if tostring(color) ~= '51964D' and result and not rabden then
                wait(1000)
                sampSendChat('/clist 7')
            end
        end
    
    end
end

function panelCheker()
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
                    if sampIsPlayerConnected(i) then
                        
                        getName = sampGetPlayerNickname(i)
                        color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(i)))
                        
                        if privet then
                            renderFontDrawText(my_font,'{'..color..'}'..getName..' ['..i..'] - {00BF80} в зоне стрима', x, y, 0xFFFFFFFF)
                        else
                            renderFontDrawText(my_font,'{'..color..'}'..getName..' ['..i..'] - {FF0000} вне зоны стрима', x, y, 0xFFFFFFFF)
                        end
                    else
                        sampAddChatMessage(sname..'Игрок вышел из игры',-1)
                        table.remove( chekerPlayer, j)
                    end
                        j = j - 1
                end
        end
    end
end


function cmd_fmask(arg)
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

function cmd_fastmenu(arg)
    tname = sampGetPlayerNickname(arg):gsub('_', ' ')
    id = arg
    sampShowDialog(10,sname.."Меню действий на: "..tname,dialogStr,"Выбрать","Выход",2)
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

function cmd_sos()
	sampSendChat("/r "..mainIni.config.senseTag.." СОС " ..kvadrat(),-1)
end


function cmd_sostav(arg)
    var1,var2 = string.match(arg,"(.+) (.+)")
    if var1 == 'add' and var2 then
        if var2:match('.+_.+') then
            AddName = var2
        elseif var2:match('%d') then
            if sampIsPlayerConnected(var2) then
                AddName = sampGetPlayerNickname(var2)
            end
        end
        dlina = #online.delta + 1
        online.delta[dlina] = AddName
        if inicfg.save(online,directSostav) then
            sampAddChatMessage(sname..AddName..' додан в список, номер игрока '..dlina,-1)
        end
    elseif var1 == 'remove' and var2 then
        if var2:match('.+_.+') then
            DelName = var2
        elseif var2:match('%d') then
            if sampIsPlayerConnected(var2) then
                DelName = sampGetPlayerNickname(var2)
            end
        end
        for i = 0,#online.delta + 20 do
            if online.delta[i] == DelName then
                online.delta[i] = nil
                if inicfg.save(online,directSostav) then
                    sampAddChatMessage(sname..DelName..' удалён из списка состава, его номер был '..i,-1)
                end
            end
        end
    else
        sampAddChatMessage(sname..'Вы неверно ввели значение команды, {004080}/sostav{ffffff} add/remove id/nick',-1)
    end
end

function cmd_panel(arg)
    var1,var2 = string.match(arg,"(.+) (.+)")
    if var1 == 'add' and var2 then
        lua_thread.create(function()
            cheker = true
            if var2:match('%d+') then 
                id = var2:match('%d+')
                if sampIsPlayerConnected(id) then
                    table.insert( chekerPlayer, var2 )
                    getName2 = sampGetPlayerNickname(id)
                    color2 = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(id)))
                    sampAddChatMessage(string.format(sname.. "В панель слежки добавлен {%s} %s",color2,getName2 ),-1)
                else
                    sampAddChatMessage(sname..'Данный игрок оффлайн',-1)
                end
            end 
        end)
    elseif var1 == 'del' and var2 then 
        for j in ipairs(chekerPlayer) do
            if var2 == chekerPlayer[j] then
                delName = sampGetPlayerNickname(var2)
                sampAddChatMessage(string.format(sname..'Вы удалили %s из панели слежки',delName),-1)
                table.remove( chekerPlayer, j)
            else
                sampAddChatMessage(sname..'Игрок с таким ником не найден в панели',-1)
            end
        end
    else
        sampAddChatMessage(sname..'Вы не верно указали значение команды, {004080}/panel{ffffff} add/del id',-1)
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

function cmd_ccl(arg)
	lua_thread.create(function()
    if arg == '' or arg == nil then

        sampAddChatMessage(sname..'Вы не указали значение. {004080}/ccl{ffffff}',-1)
	else
        sampSendChat('/clist '..arg)
        wait(1000)
        if arg == '32' then

            sampSendChat('/me надел именной черный берет Спец.Взвода «Delta Force»')

        elseif arg == '26' then

            sampSendChat('/me надел кевларовую каску Взвода Внутренней Охраны')

        elseif arg == '31' then

            sampSendChat('/me надел серебристый берет ОСН «Alpha»')

        elseif arg == '30' then

            sampSendChat('/me надел серую кевларовую каску ОСН «Alpha»')

        elseif arg == '19' then

            sampSendChat('/me надел синий берет Взвода Тылового Обеспечения')

        elseif arg == '16' then

            sampSendChat('/me надел кевларовую каску Взвода Тылового Обеспечения')

        elseif arg == '21' then

            sampSendChat('/me надел именной тёмно-синий берет Спец.Взвода «Delta Force»')

        elseif arg == '7' then

            sampSendChat('/me надел серо-зеленную повязку №7')

        elseif arg == '0' then

            sampSendChat('/me снял берет с головы')

        elseif arg == '' or arg == nil then

            sampAddChatMessage(sname..'Вы не указали значение. {004080}/ccl{ffffff}',-1)

        else

            sampSendChat('/me поправил берeт')
        end
    end
	end)
end

function cmd_udost()
	local _ , myId = sampGetPlayerIdByCharHandle(PLAYER_PED) 
    MyName = sampGetPlayerNickname(myId):gsub('_', ' ')
	lua_thread.create(function()
		lua_thread.create(function()
			sampSendChat('/me достал удостоверение с заднего кармана.')
			wait(1200)
			sampSendChat('/me показал удостоверение')
			wait(1200)
			sampSendChat('/do Army LV | ' ..MyName.. ' | '..mainIni.udost.position.. ' | '..mainIni.udost.nameRank..'.')
			wait(1000)
			sampSendChat('/do Выдано: '..mainIni.udost.inviteName..' |  Дата: '..mainIni.udost.inviteDate..'' )
		end)
	end)
end


function cmd_stream()
	lua_thread.create(function()
			sampAddChatMessage(string.format("{FFFFFF}-------------------------------Зона стрима-------------------------------"), 0x004080)
			for i = 0, sampGetMaxPlayerId(true) do
				local bool, playerHandle = sampGetCharHandleBySampPlayerId(i)
				if bool and doesCharExist(playerHandle) then
					local mX, mY, mZ = getCharCoordinates(PLAYER_PED)
					local pX, pY, pZ = getCharCoordinates(playerHandle)
					local playerNickname =  sampGetPlayerNickname(i)
                    local color = string.format("%06X", ARGBtoRGB(sampGetPlayerColor(i)))
					wait(200)
					sampAddChatMessage(string.format("{"..color.."}%s", playerNickname.. '{ffffff} ID:['..i..']' ), 0xFFFFFF)
				end
			end
	end)
end




------------------- Мониторинг (не трогать) --------------

function Search3Dtext(x, y, z, radius, patern)
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false
    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end

function split(inputstr, sep)
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
function cmd_getm()
	local x,y,z = getCharCoordinates(PLAYER_PED)
	local result, text = Search3Dtext(x,y,z, 1000, "FBI")
	local temp = split(text, "\n")
	for k, val in pairs(temp) do
		monikQuant[k] = val
	end
	if monikQuant[6] == nil then
                -- anti-freeze de script
	else
		monikQuantNum = {}
		for i = 1, table.getn(monikQuant) do
				number1, number2, monikQuantNum[i] = string.match(monikQuant[i],"(%d+)[^%d]+(%d+)[^%d]+(%d+)")
				monikQuantNum[i] = monikQuantNum[i]/1000
		end
		sampAddChatMessage("============= Мониторинг ============", 0xFFFFFF)
		sampSendChat('/r '..mainIni.config.senseTag.." LSPD - "..monikQuantNum[1].." | SFPD - "..monikQuantNum[2].." | LVPD - "..monikQuantNum[3].." | SFa - "..monikQuantNum[4].." | FBI - "..monikQuantNum[6])
	end
end

----------------------------------------------------------------------------

function cmd_agit(arg)
	lua_thread.create(function()
		local _, my_id = sampGetPlayerIdByCharHandle(PLAYER_PED) -- получить свой ид
		if arg == nil or arg == '' then
			sampAddChatMessage(sname..'Введите {004080}/agit{ffffff}: [Номер]',-1)
			sampAddChatMessage('1 - Про доклады | 2 - Про повязку №7 | 3 - Про тэг и clist | 4 - Устав | 5 - Фиксация нарушения | 6 - Для сдачи устава | 7 - Коронавирус',0xFFFFFF)
		elseif arg == '1' then
			wait(100)
			sampSendChat('/r '..mainIni.config.senseTag..' Бойцы ВВО, не забываем делать доклады о заступлении/покидании поста!')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' А так же о состоянии поста каждые 5 минут часа!')
			wait(5000)
			sampSendChat('/rb по /time')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Например: 15:00, 15:05, 15:10, 15:15, 15:20, 15:25, 15:30 и так далее.')
			wait(5000)
			sampSendChat("/r "..mainIni.config.senseTag.." ОСН «Alpha» в Порту LS доклады с постов делаются строго каждые 10 минут часа!")
        elseif arg == '2' then
			wait(100)
			sampSendChat('/r '..mainIni.config.senseTag..' Уважаемые военнослужащие! Перед тем, как попасть на базу...')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Не забываем надевать серо-зеленную повязку №7 и показывать документы на КПП!')
			wait(5000)
			sampSendChat('/rb /clist 7 ; /showpass id ')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Это является нарушение устава, пунктов: 2.8, 2.9, 9.3.')
			wait(5000)
			sampSendChat("/r "..mainIni.config.senseTag.." Благодарю за внимание.")
        elseif arg == '3' then
			wait(100)
			sampSendChat('/r '..mainIni.config.senseTag..' Уважаемые военнослужащие!')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Не забываем проговаривать свой взвод в рацию и надевать каску своего подразделения!')
			wait(5000)
			sampSendChat('/rb [Тэг] - тэг взвода; /clist № - каска своего подразделения')
			wait(5000)
			sampSendChat("/r "..mainIni.config.senseTag.." Благодарю за внимание.")
		elseif arg == '4' then
			wait(100)
			sampSendChat('/r '..mainIni.config.senseTag..' Уважаемые военнослужащие, прошу пару минут вашего внимания.')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Напоминаю вам про соблюдение общевоинского устава - это основа армии.')
			wait(5000)
			sampSendChat('/r '..mainIni.config.senseTag..' Несоблюдение и нарушение определенных порядков - подлежат наказанию.')
			wait(5000)
			sampSendChat("/r "..mainIni.config.senseTag.." Благодарю за внимание.")
		elseif arg == '5' then
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Уважаемые военнослужащие, прошу пару минут вашего внимания.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' В случае, если вы зафиксировали какое-либо нарушение.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' И желаете посодействовать в его устранении.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Обращайтесь напрямую к сотрудникам Delta.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Благодарю за внимание.')
		elseif arg == '6' then 
			sampSendChat('/r '..mainIni.config.senseTag.. ' Внимание ефрейторы, для того чтобы сдать устав, обратитесь на пейджер '..my_id)
			elseif arg == '7' then
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Уважаемые военнослужащие, прошу пару минут вашего внимания.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Недавно губернатор выпустил постановление о защите здоровья, масочный режим.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Каждому бойцу нужно носить маску от коронавируса, под свой взвод.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Кто не имеет маски в распоряжении, обратитесь к своему руководству.')
			wait(5000)
			sampSendChat('/r ' ..mainIni.config.senseTag.. ' Благодарю за внимание.')
		else
			sampAddChatMessage(sname..'Введите {004080}/agit{ffffff}: [Номер]',-1)
			sampAddChatMessage('1 - Про доклады | 2 - Про повязку №7 | 3 - Про тэг и clist | 4 - Устав | 5 - Фиксация нарушения',0xFFFFFF,0xFFFFFF)
		end
	end)
end


function cmd_vz(arg)
	var1,var2 = string.match(arg,"(.+) (.+)")
		local id = tonumber(var1)
		if id ~= nil then
			if sampIsPlayerConnected(id) then
				if var1 == nil or var2 == "" then
				    
					sampAddChatMessage(sname.. 'Введите: {004080}/vz{FFFFFF}: [id] [Минуты]',-1)
				else
                    if var2 == '1' then
					    sampSendChat(('/r '..mainIni.config.senseTag..' %s явитесь на плац. У вас '..var2..' минута.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                    elseif var2 == '2' or var2 == '3' or var2 == '4' then
                        sampSendChat(('/r '..mainIni.config.senseTag..' %s явитесь на плац. У вас '..var2..' минуты.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                    else
                        sampSendChat(('/r '..mainIni.config.senseTag..' %s явитесь на плац. У вас '..var2..' минут.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                    end
				end
			else
				sampAddChatMessage(sname.. 'Данный игрок оффлайн',-1)
			end
		else
			sampAddChatMessage(sname.. 'Введите: {004080}/vz{FFFFFF}: [id] [Минуты]',-1)
		end
end

function cmd_ms(arg)
	var1,var2 = string.match(arg,"(.+) (.+)")
	local id = tonumber(var1)
	if id ~= nil then
		if sampIsPlayerConnected(id) then
			if var1 == nil or var2 == "" then
				
				sampAddChatMessage(sname.. 'Введите: {004080}/ms{FFFFFF}: [id] [Минуты]',-1)
			else
                if var2 == '30' then
                    sampSendChat(('/r '..mainini.config.senseTag..' %s ваше местонахождение. На ответ у вас '..var2..' секунд.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                elseif var2 == '2' or var2 == '3' or var2 == '4' then
                    sampSendChat(('/r '..mainini.config.senseTag..' %s ваше местонахождение. На ответ у вас '..var2..' минуты.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                else
				    sampSendChat(('/r '..mainini.config.senseTag..' %s ваше местонахождение. На ответ у вас '..var2..' минут.'):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                end
			end
		else
			sampAddChatMessage(sname.. 'Данный игрок оффлайн',-1)
		end
	else
		sampAddChatMessage(sname.. 'Введите: {004080}/ms{FFFFFF}: [id] [Минуты]',-1)
	end
end

function sampev.onServerMessage(color, text)
	lua_thread.create(function()
        
        if text:find('самовол') or text:find('Самовол') or text:find('САМОВОЛ') or text:find('cfvjdjk') or text:find('samovol') or text:find('SAMOVOL') and color and color == -1920073984 then
			sampAddChatMessage(sname..'Информация о {ff0000}самоволе{ffffff}.Начинайте реагировать.',-1)
		end

        if mainini.config.autoClist then
            if text:find('Рабочий день начат') then
                wait(1000)
                cmd_ccl(mainini.config.numberClist)
            end
        end
        
    end)
end

function sampev.onSendSpawn()
	if mainIni.config.autoClist then
		lua_thread.create(function()
			wait(100)
			sampAddChatMessage(sname..'Clist был успешно изменён',-1)
			sampSendChat('/clist '..mainIni.config.numberClist)
			wait(1500)
			sampSendChat('/me поправил(-а) берет')
		end)
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