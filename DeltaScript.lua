script_name("Delta Script")
script_author("N1CHO")

local sname = '{004080}[Delta Force]: {ffffff}'


local dlstatus = require('moonloader').download_status
local func = require 'cfg\\function'



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
      lua_thread.create(function() wait(500) thisScript():reload() end)
    end
  end


----------------------- inicfg ------------------

local inicfg = require "inicfg"

local directFolder = "D:\\SAMP\\GTA goss\\moonloader\\cfg"

local result = doesDirectoryExist(directFolder)

if result then
    print('Folder est')
else
    result = createDirectory(directFolder)
    if result then
        print('Folder Create')
    else
        print('Folder 404')
    end
end

local result = doesFileExist('moonloader\\cfg\\config.ini')
if result then
    print('File est')
else
    local url = 'https://raw.githubusercontent.com/n1cho/DeltaScript/main/cfg/config.ini'
    local file_path = 'D:\\SAMP\\GTA goss\\moonloader\\cfg\\config.ini'
    download_id = downloadUrlToFile(url, file_path, download_handler)
    print('Загрузка начата. Нажмите F2, чтобы отменить её.')
end


local mainini = {
    config = {
        testIni = 'Отстутсвует файл с настройками, если что-то \nпоменяете в настройках,изменения при \nрелоге анулируються',
        senseTag = '[Delta]: ',
        autoSense = true,
        autoClist = false,
        numberClist = '21'
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
local uws = imgui.ImBool(false)

local sw,sh = getScreenResolution()

local inputRteg = imgui.ImBuffer(36)
local inputPosition = imgui.ImBuffer(64)
local inputInvName = imgui.ImBuffer(48)
local inputInvDate = imgui.ImBuffer(16)
local inputRang = imgui.ImBuffer(36)


local autoSense_cb = imgui.ImBool(mainIni.config.autoSense)
local autoClist_cb = imgui.ImBool(mainIni.config.autoClist)
local changeUdost_cb = imgui.ImBool(mainIni.config.changeUdost)
local nC_slider = imgui.ImInt(mainIni.config.numberClist)


function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end


function imgui.OnDrawFrame()
    if not mws.v and not sws.v and not uws.v then
        imgui.Process = false
    end

    local _ , myId = sampGetPlayerIdByCharHandle(PLAYER_PED) 
    MyName = sampGetPlayerNickname(myId):gsub('_', ' ')


    if mws.v then
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Main Window',mws)
        imgui.CentrText('Hello World')
        imgui.Separator()
        if imgui.Button(u8'Команды скрипта',btn_size) then csws.v = not csws.v end
        if imgui.Button(u8'Settings',btn_size) then sws.v = not sws.v end
        imgui.Text(u8(mainIni.config.testIni))
        imgui.End()
    end
    
    if sws.v then
        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Settings Window',sws)
        imgui.Text(u8'Проверка')
        if imgui.Checkbox(u8'Использовать автотег',autoSense_cb) then
            mainIni.config.autoSense = autoSense_cb.v
            if inicfg.save(mainIni,directSettings) then
                   
            end
        end

        if mainIni.config.autoSense then
            imgui.InputText(u8'Введите тег',inputRteg)
            imgui.Text(u8('На данный момент ваш тег в рацию: '..mainIni.config.senseTag))
            if imgui.Button(u8'Потдвердить') then
                mainIni.config.senseTag = u8:decode(inputRteg.v)
                if inicfg.save(mainIni,directSettings) then
                    sampAddChatMessage(sname..'Вы изменили тег в рацию',-1)
                end
            end
        end

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
        if imgui.Button(u8'Настройка удостоверения')then uws.v = not uws.v end
        imgui.PushItemWidth(75)
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
local my_font = renderCreateFont('Verdana', 10, font_flag.BOLD + font_flag.SHADOW)

local chekerPlayer = {}



function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('dm',imgui_main_menu)

    sampRegisterChatCommand('panel',cmd_panel)
    sampRegisterChatCommand('stream',cmd_stream)
    sampRegisterChatCommand('r',function(arg)
        if #arg ~= 0 then
            if mainIni.config.autoSense then
                sampSendChat(string.format( "/r %s %s",u8:decode(mainIni.config.senseTag),arg ))
            else
                sampSendChat(string.format('/r %s',arg))
            end
        else
            sampAddChatMessage('Введите /r [текст]',-1)
        end
    end)
    
    
    

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

