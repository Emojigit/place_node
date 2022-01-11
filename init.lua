minetest.register_privilege("setblock", {
	description = "Player can use place and setblock command.",
	give_to_singleplayer= false,
})

local function split (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

minetest.register_chatcommand("place", {
	params = "<x> <y> <x> <nodename>",
	description = "Place block",
	privs = {setblock = true},
	func = function(name, param)
		splited = split(param," ")
		if not(tonumber(splited[1]) and tonumber(splited[2]) and tonumber(splited[3])) then
			return false, "Pos error: please give int!"
		end
		x,y,z,node = tonumber(splited[1]),tonumber(splited[2]),tonumber(splited[3]),splited[4]
		if node == "ignore" then
			return false, "You can't place \"ignore\"!"
		end
		if minetest.registered_nodes[node] then
			minetest.place_node({x=x, y=y, z=z}, {name=node})
			return true, "Setted node "..node.." at "..tostring(x)..tostring(y)..tostring(z)
		else
			return false, "Cannot place a unknown node."
		end
	end,
})

minetest.register_chatcommand("place_here", {
	params = "<node>",
	privs = {setblock = true},
	description = "Place block at player's pos",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player is not online."
		end
		if param == "ignore" then
			return false, "You can't place \"ignore\"!"
		end
		if minetest.registered_nodes[param] then
			minetest.place_node(player:get_pos(), {name=param})
			return true, "Placed node "..param.." at "
				..tostring(math.floor(player:get_pos().x))..","
				..tostring(math.floor(player:get_pos().y))..","
				..tostring(math.floor(player:get_pos().z))
		else
			return false, "Cannot place a unknown node."
		end
	end,
})

-- minetest.set_node

minetest.register_chatcommand("setblock", {
	params = "<x> <y> <x> <nodename>",
		privs = {setblock = true},
	description = "Set a block",
	func = function(name, param)
		splited = split(param," ")
		if not(tonumber(splited[1]) and tonumber(splited[2]) and tonumber(splited[3])) then
			return false, "Pos error: please give int!"
		end
		x,y,z,node = tonumber(splited[1]),tonumber(splited[2]),tonumber(splited[3]),splited[4]
		if node == "ignore" then
				return false, "You can't set \"ignore\"!"
		end
		if minetest.registered_nodes[node] then
			minetest.set_node({x=x, y=y, z=z}, {name=node})
			return true, "Setted node "..node.." at "..tostring(x)..", "..tostring(y)..", "..tostring(z)
		else
			return false, "Cannot set a unknown node."
		end
	end,
})

minetest.register_chatcommand("fill", {
	params = "<x> <y> <x> <x> <y> <x> <nodename>",
		privs = {setblock = true},
	description = "Set a block",
	func = function(name, param)
		splited = split(param," ")
		if not(tonumber(splited[1]) and tonumber(splited[2]) and tonumber(splited[3])) then
			return false, "Pos error: please give int!"
		end
		x1,y1,z1,x2,y2,z2,node = 
			tonumber(splited[1]),
			tonumber(splited[2]),
			tonumber(splited[3]),
			tonumber(splited[4]),
			tonumber(splited[5]),
			tonumber(splited[6]),
			splited[7]
		if node == "ignore" then
			return false, "You can't set \"ignore\"!"
		end
		if minetest.registered_nodes[node] then
			for i=x1, x2 do 
				for j=y1, y2 do
					for k=z1, z2 do
						minetest.set_node({x=i, y=j, z=k}, {name=node})
					end
				end
			end
			return true, "Setted node "..node.." at from "..tostring(x1)..", "..tostring(y1)..", "..tostring(z1).." to "
				..tostring(x2)..", "..tostring(y2)..", "..tostring(z2)
		else
			return false, "Cannot set a unknown node."
		end
	end,
})

minetest.register_chatcommand("setblock_here", {
	params = "<node>",
	privs = {setblock = true},
	description = "Set a block at player's pos",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player is not online."
		end
		if param == "ignore" then
			return false, "You can't set \"ignore\"!"
		end
		if minetest.registered_nodes[param] then
			minetest.set_node(player:get_pos(), {name=param})
			return true, "Setted node "..param.." at "..tostring(math.floor(player:get_pos().x))..","..tostring(math.floor(player:get_pos().y))..","..tostring(math.floor(player:get_pos().z))
		else
			return false, "Cannot set a unknown node."
		end
	end,
})
