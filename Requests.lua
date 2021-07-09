local httpService = game:GetService("HttpService")

local requests = {}

-- Functions
local function getRawCookie(cookie)
	local modifiedCookie = string.gsub(cookie, "-", " ")
	if string.find(modifiedCookie, "DO NOT SHARE THIS") then
		return string.sub(cookie, 117, #cookie)
	else
		return cookie
	end
end

local function removeLastChar(str)
	return string.sub(str, 0, #str - 1)
end

local function cookiesToHeader(cookies)
	local headersStr = ""

	for key, value in pairs(cookies) do
		local template = "%s=%s&"
		local cookieStr = string.format(template, key, getRawCookie(value))
		headersStr = headersStr .. cookieStr
	end

	headersStr = removeLastChar(headersStr)

	return headersStr
end

local function mergeTables(...)
	local newTbl = {}
	for _, t in pairs(table.pack(...)) do
		for _, v in pairs(t) do
			table.insert(newTbl, v)
		end
	end
	return newTbl
end

local function isJSON(str)
	local _, err = pcall(function()
		httpService:JSONDecode(str)
	end)

	if err then
		return false
	else
		return true
	end
end

-- Module functions
function requests:Get(data)
	-- Errors
	if not data then
		error("No data provided")
	end
	if not data.url then
		error("No URL provided")
	end

	-- Defaults
	if not data.cookies then
		data.cookies = {}
	end
	if not data.headers then
		data.headers = {}
	end

	-- Setup cookies
	data.headers['Cookie'] = cookiesToHeader(data.cookies)
	print("Final headers: ")
	print(data.headers)

	-- Send request
	local response = httpService:GetAsync(data.url, false, data.headers)

	return response
end

return requests
