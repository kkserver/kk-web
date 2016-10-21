
local string = require('string')
local code = require('kk/code')
local json = require('kk/json')

return function(page,__text) 
	
	local i = 1
	local c = string.len(__text)
	local v = ''

	while i < c do

		local b,e,text = string.find(__text,'%{#(.-)#%}',i)

		if b == nil then
			v = v .. string.sub(__text,i)
			break
		elseif b > i then
			v = v .. string.sub(__text,i,b -1)
		end

		local r = code(page,text)

		if r ~= nil then
			v = v .. r
		end

		i = e + 1

	end

	return v;
end


