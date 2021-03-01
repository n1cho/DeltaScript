script_name("Delta Script")
script_version("01.03.2021.1")
script_author("N1CHO")

local imgui = require 'imgui'
local key = require 'vkeys'

local encoding = require 'encoding' -- загружаем библиотеку
encoding.default = 'CP1251' -- указываем кодировку по умолчанию, она должна совпадать с кодировкой файла. CP1251 - это Windows-1251
u8 = encoding.UTF8

local settings_window_state = imgui.ImBool(false)
local settings_buffer = imgui.ImBuffer(256)
local sw,sh = getScreenResolution()

local sname = '{004080}[Delta Script]:{FFFFFF}'

function imgui.OnDrawFrame()
    if settings_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(250, 300), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2),imgui.Cond.FirstUseEver,imgui.ImVec2(0.5,0.5))
        imgui.Begin('Settings Window',settings_window_state)
        imgui.Text('Hello World')
        imgui.End()
    end
end



function main()
    autoupdate("https://raw.githubusercontent.com/n1cho/DeltaScript/main/upd.json", '['..string.upper(thisScript().name)..']: ', "https://github.com/n1cho/DeltaScript")

    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampLoaded() do wait(100) end

    imgui.Process = true


    while true do
        wait(0)

        if wasKeyPressed(key.VK_X) then -- активация по нажатию клавиши X
            settings_window_state.v = not settings_window_state.v -- переключаем статус активности окна, не забываем про .v
        end
        imgui.Process = settings_window_state.v
    end
end


-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  sampAddChatMessage((sname..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('Загрузка обновления завершена.')
                        sampAddChatMessage((sname..'Обновление завершено!'), color)
                        thisScript().version = updateversion
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                          sampAddChatMessage((sname..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                print('v'..thisScript().version..': Обновление не требуется.')
              end
            end
          else
            print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end
