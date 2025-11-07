local n1, n2 = 65, 90
local a = {"%","/","^","$","~","&","."}
local len = 1920

local res = ""

for i = 1,len do
	local rng0 = math.random(1, 3)
	for i2 = 1,rng0 do
		if math.random(1, 2) == 1 then
			res ..= "#"
		else
			res ..= a[math.random(1, #a)]
		end
	end
	local rng = math.random(1, 8)
	for i3 = 1,rng do
		local b = math.random(n1, n2)
		local ss = string.char(b)
		if math.random(1, 3) == 1 then
			ss = string.lower(ss)
		end
		res ..= ss
	end
end

print(res)
