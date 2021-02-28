local imgui = require 'imgui'
local key = require 'vkeys'

local encoding = require 'encoding' -- ��������� ����������
encoding.default = 'CP1251' -- ��������� ��������� �� ���������, ��� ������ ��������� � ���������� �����. CP1251 - ��� Windows-1251
u8 = encoding.UTF8

local settings_window_state = imgui.ImBool(false)
local settings_buffer = imgui.ImBuffer(256)
local sw,sh = getScreenResolution()


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
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampLoaded() do wait(100) end

    imgui.Process = true

    while true do
        wait(0)

        if wasKeyPressed(key.VK_X) then -- ��������� �� ������� ������� X
            settings_window_state.v = not settings_window_state.v -- ����������� ������ ���������� ����, �� �������� ��� .v
        end
        imgui.Process = settings_window_state.v
    end
end

