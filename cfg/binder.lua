function pr(arg)
    lua_thread.create(function()
        local patriot = isCharInModel(PLAYER_PED, 470)
        local sultan = isCharInModel(PLAYER_PED,560)
        if sultan then
            if arg == '1' then
                sampSendChat('/do �� ���������� ����� "Sultan" ���������� ����������������.')
                wait(1000)
                sampSendChat('/s �� ���������� �� ���������� ���������� ���������� �������� �! ����� �� ������� ����� �� ���������!')
                wait(1500)
                sampSendChat('/s � ��� ������� 10 ������, ����� �������� ������ ����������! ������ �������������� �� �����!')
            elseif arg == '2' then
                sampSendChat('/s �� ����������� ����������� ���������� ����� ������ ����� ��� ��������������!')
            elseif arg == '3' then
                sampSendChat('/do �� ���������� ����� "Sultan" ���������� ����������������.')
                wait(1000)
                sampSendChat('/s ����� ������ �������� ������� ������� ������������� ��� ���������!')
            else
                sampAddChatMessage(sname..'������� {004080}/pr{FFFFFF}: [�����]',-1)
                sampAddChatMessage(sname..'1 - ���������� �� ���������� | 2 - ����������� ����������� | 3 - ������������� ',-1)
        
            end
        elseif patriot then
            if arg == '1' then
                sampSendChat('/m �� ���������� �� ���������� ���������� ���������� �������� �! ����� �� ������� ����� �� ���������!')
                wait(1500)
                sampSendChat('/m � ��� ������� 10 ������, ����� �������� ������ ����������! ������ �������������� �� �����!')
            elseif arg == '2' then
                sampSendChat('/m �� ����������� ����������� ���������� ����� ������ ����� ��� ��������������!')
            elseif arg == '3' then
                sampSendChat('/m ����� ������ �������� ������� ������� ������������� ��� ���������!')
            else
                sampAddChatMessage(sname..'������� {004080}/pr{FFFFFF}: [�����]',-1)
                sampAddChatMessage(sname..'1 - ���������� �� ���������� | 2 - ����������� ����������� | 3 - ������������� ',-1)
        
            end
        else
            if arg == '1' then
                sampSendChat('/s �� ���������� �� ���������� ���������� ���������� �������� �! ����� �� ������� ����� �� ���������!')
                wait(1500)
                sampSendChat('/s � ��� ������� 10 ������, ����� �������� ������ ����������! ������ �������������� �� �����!')
            elseif arg == '2' then
                sampSendChat('/s �� ����������� ����������� ���������� ����� ������ ����� ��� ��������������!')
            elseif arg == '3' then
                sampSendChat('/s ����� ������ �������� ������� ������� ������������� ��� ���������!')
            else
                sampAddChatMessage(sname..'������� {004080}/pr{FFFFFF}: [�����]',-1)
                sampAddChatMessage(sname..'1 - ���������� �� ���������� | 2 - ����������� ����������� | 3 - ������������� ',-1)
            end
        end
    end)
end