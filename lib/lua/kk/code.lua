
local string = require('string')

return function(page,code) 
	
	if page == nil then
		page = {}
	end

	local fn,err = loadstring('return function(page) return '..code..'; end')

	if fn == nil then
		return {errmsg = err, errno = 1000};
	else

		fn = fn();

		if type(fn) == 'function' then

			local v = fn(page);

			if type(v) == 'function' then
				return v();
			else
				return v;
			end
		else
			return fn;
		end

	end
end


