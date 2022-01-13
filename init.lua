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
	params = "<x> <y> <z> <nodename>",
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
	params = "<x> <y> <z> <nodename>",
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

minetest.register_chatcommand("fill", {
	params = "<x1> <y1> <z1> <x2> <y2> <z2> <nodename>",
	privs = {setblock = true},
	description = "Fill a place",
	func = function(name, param)
		local nodes = {}
		local splited = split(param," ")
		local x1,y1,z1,x2,y2,z2,node = 
			tonumber(splited[1]),
			tonumber(splited[2]),
			tonumber(splited[3]),
			tonumber(splited[4]),
			tonumber(splited[5]),
			tonumber(splited[6]),
			splited[7]

		if not(
			x1 and y1 and z1 and
			x2 and y2 and z2
		) then
			return false, "Pos error: please give int!"
		end
		if node == "ignore" then
			return false, "You can't set \"ignore\"!"
		end

		if x1 > x2 then
			x1, x2 = x2, x1
		end
		if y1 > y2 then
			y1, y2 = y2, y1
		end
		if z1 > z2 then
			z1, z2 = z2, z1
		end

		local size = (x2 - x1) * (y2 - y1) * (z2 - z1)

		if minetest.registered_nodes[node] then
			for i=x1, x2 do 
				for j=y1, y2 do
					for k=z1, z2 do
						nodes[#nodes+1] = {x=i, y=j, z=k}
					end
				end
			end
			minetest.bulk_set_node(nodes, {name=node})
			return true, size.." blocks are filled."
		else
			return false, "Cannot set a unknown node."
		end
	end,
})

minetest.register_chatcommand("clone", {
	params = "<x1> <y1> <z1> <x2> <y2> <z2> <x> <y> <z> [filtered|masked|replace] [force|move|normal] <filter>",
	privs = {setblock = true},
	description = "Clone a place",
	func = function(name, param)
		local nodes = {}
		splited = split(param," ")

		if not(
			tonumber(splited[1]) and 
			tonumber(splited[2]) and 
			tonumber(splited[3]) and 
			tonumber(splited[4]) and 
			tonumber(splited[5]) and 
			tonumber(splited[6]) and
			tonumber(splited[7]) and 
			tonumber(splited[8]) and 
			tonumber(splited[9])
		) then
			return false, "Pos error: please give int!"
		end

		x1,y1,z1,x2,y2,z2,x3,y3,z3,mask_mode,clone_mode,node = 
			tonumber(splited[1]),
			tonumber(splited[2]),
			tonumber(splited[3]),
			tonumber(splited[4]),
			tonumber(splited[5]),
			tonumber(splited[6]),
			tonumber(splited[7]),
			tonumber(splited[8]),
			tonumber(splited[9]),
			splited[10],
			splited[11],
			splited[12]

		if not mask_mode then 
			mask_mode = "replace"
		end
		if not clone_mode then
			clone_mode = "normal"
		end

		if mask_mode == "filtered" and not node then
			return false, "Cannot set a unknown node."
		end
		if node == "ignore" then
			return false, "You can't set \"ignore\"!"
		end

		if x1 > x2 then
			x1, x2 = x2, x1
		end
		if y1 > y2 then
			y1, y2 = y2, y1
		end
		if z1 > z2 then
			z1, z2 = z2, z1
		end

		local dx, dy, dz = x2 - x1, y2 - y1, z2 - z1
		local size = 0;

		for i=1, dx do 
			nodes[i] = {}
			for j=1, dy do
				nodes[i][j] = {}
				for k=1, dz do
					local node_name = minetest.get_node({x=x1+i,y=y1+j,z=z1+k}).name
					if mask_mode ~= "filtered" or node_name == node then
						nodes[i][j][k] = node_name
						size = size + 1
					else
						nodes[i][j][k] = "air"
					end
					if mask_mode ~= "filtered" and clone_mode == "move" or node_name == node and clone_mode == "move" then
						minetest.set_node({x=x1+i,y=y1+j,z=z1+k}, {name="air"})
					end
				end
			end
		end

		for i=x3+1, x3+dx do
			for j=y3+1, y3+dy do
				for k=z3+1, z3+dz do
					if mask_mode ~= "masked" or nodes[i-x3][j-y3][k-z3] ~= "air" then
						minetest.set_node({x=i, y=j, z=k}, {name=nodes[i-x3][j-y3][k-z3]})
					end
				end
			end
		end

		local msg
		if clone_mode == "move" then
			msg = " blocks are moved."
		else
			msg = " blocks are cloned."
		end

		return true, size..msg
	end,
})
