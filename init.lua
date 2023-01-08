local player_moods = {}

minetest.register_on_joinplayer(function (player)
    player_moods[player:get_player_name()] = 0
end)

minetest.register_on_leaveplayer(function (player)
    player_moods[player:get_player_name()] = nil
end)

minetest.register_globalstep(function (dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        local player_pos = player:get_pos()
        player_pos.y = player_pos.y + 1

        if minetest.get_node_light(player_pos, 0.5) ~= 15 then
            local light = minetest.get_node_light(player_pos)
            local current_mood = player_moods[player_name]

            if light ~= nil and light < 7 then
                player_moods[player_name] = current_mood + (7 - light) / (dtime * 1000)
            else
                player_moods[player_name] = current_mood - 0.2
            end
        else
            local current_mood = player_moods[player_name]

            player_moods[player_name] = current_mood - 0.2
        end

        if player_moods[player_name] > 100 then
            minetest.sound_play({to_player=player_name, name='cave'})

            player_moods[player_name] = 0
        elseif player_moods[player_name] < 0 then
            player_moods[player_name] = 0
        end
    end
end)
