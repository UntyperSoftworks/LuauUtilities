-- Returns encoded message and key (optional)
function encode(text: string, key: string?): (string, string)
	local n1, n2 = 65, 90
	
	local len = #text
	local obf: buffer = buffer.create(len)
	local currentKey = ""
	
	if key then
		currentKey = key
	else
		local tlen0 = math.random(1, 16)
		for i = 1,tlen0 do
			currentKey ..= tostring(math.random(0, 9))
		end
	end
	
	local sptext = string.split(text, "")
	local spkey = string.split(currentKey, "")
	local keyIndex = 1
	for i,v in sptext do
		local offset = tonumber(spkey[keyIndex])
		local byte = string.byte(v)
		local newByte = (byte * 2) - offset
		buffer.writeu8(obf, i - 1, newByte)
		
		keyIndex += 1
		if keyIndex > #currentKey then
			keyIndex = 1
		end
	end
	
	local encoded: string = `{currentKey}\\=`
	encoded ..= buffer.tostring(obf)
	return encoded, currentKey
end

function decode(encoded: string, key: string?)
	local currentKey = ""
	local spe = string.split(encoded, "\\=")
	if key then
		currentKey = key
	else
		currentKey = spe[1]
	end
	local result: string = ""
	local obf: buffer = buffer.fromstring(spe[2])
	
	local spkey = string.split(currentKey, "")
	local keyIndex = 1
	local len = #(spe[2])
	for i = 1, len do
		local offset = tonumber(spkey[keyIndex])
		local b = buffer.readu8(obf, i - 1)
		local b2 = (b + offset) / 2
		result ..= string.char(b2)
		keyIndex += 1
		if keyIndex > #currentKey then
			keyIndex = 1
		end
	end
	
	return result
end

-- testing
local m = encode("Hello world!")
print(m)
print(decode(m))
