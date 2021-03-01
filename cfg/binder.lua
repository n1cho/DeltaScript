function pr(arg)
    lua_thread.create(function()
        local patriot = isCharInModel(PLAYER_PED, 470)
        local sultan = isCharInModel(PLAYER_PED,560)
        if sultan then
            if arg == '1' then
                sampSendChat('/do На автомобиле марки "Sultan" установлен громкоговоритель.')
                wait(1000)
                sampSendChat('/s Вы находитесь на охраняемой территории немедленно покиньте её! Иначе мы откроем огонь на поражение!')
                wait(1500)
                sampSendChat('/s У Вас имеется 10 секунд, чтобы покинуть данную территорию! Больше предупреждений не будет!')
            elseif arg == '2' then
                sampSendChat('/s За последующее пересечение территории будет открыт огонь без предупреждений!')
            elseif arg == '3' then
                sampSendChat('/do На автомобиле марки "Sultan" установлен громкоговоритель.')
                wait(1000)
                sampSendChat('/s Любая помеха движению военной колонны расценивается как нападение!')
            else
                sampAddChatMessage(sname..'Введите {004080}/pr{FFFFFF}: [Номер]',-1)
                sampAddChatMessage(sname..'1 - Нахождение на территории | 2 - Последующее пересечение | 3 - Сопровождение ',-1)
        
            end
        elseif patriot then
            if arg == '1' then
                sampSendChat('/m Вы находитесь на охраняемой территории немедленно покиньте её! Иначе мы откроем огонь на поражение!')
                wait(1500)
                sampSendChat('/m У Вас имеется 10 секунд, чтобы покинуть данную территорию! Больше предупреждений не будет!')
            elseif arg == '2' then
                sampSendChat('/m За последующее пересечение территории будет открыт огонь без предупреждений!')
            elseif arg == '3' then
                sampSendChat('/m Любая помеха движению военной колонны расценивается как нападение!')
            else
                sampAddChatMessage(sname..'Введите {004080}/pr{FFFFFF}: [Номер]',-1)
                sampAddChatMessage(sname..'1 - Нахождение на территории | 2 - Последующее пересечение | 3 - Сопровождение ',-1)
        
            end
        else
            if arg == '1' then
                sampSendChat('/s Вы находитесь на охраняемой территории немедленно покиньте её! Иначе мы откроем огонь на поражение!')
                wait(1500)
                sampSendChat('/s У Вас имеется 10 секунд, чтобы покинуть данную территорию! Больше предупреждений не будет!')
            elseif arg == '2' then
                sampSendChat('/s За последующее пересечение территории будет открыт огонь без предупреждений!')
            elseif arg == '3' then
                sampSendChat('/s Любая помеха движению военной колонны расценивается как нападение!')
            else
                sampAddChatMessage(sname..'Введите {004080}/pr{FFFFFF}: [Номер]',-1)
                sampAddChatMessage(sname..'1 - Нахождение на территории | 2 - Последующее пересечение | 3 - Сопровождение ',-1)
            end
        end
    end)
end