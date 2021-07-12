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

local function trustBypass(url)
	return string.gsub(url, "roblox.com", "rprxy.xyz")
end



-- Module functions
function requests:SendRequest(data)
	-- data: url, method, cookies, headers
	-- Errors
	if not data then
		error("No data provided")
	end
	if not data.url then
		error("No URL provided")
	end
	if not data.method then
		error("No method provided")
	end

	-- Defaults
	if not data.cookies then
		data.cookies = {}
	end
	if not data.headers then
		data.headers = {}
	end
	data.method = string.upper(data.method) -- Make method uppercase
	data.url = trustBypass(data.url) -- Allow access to roblox sites

	-- Setup cookies
	data.headers['Cookie'] = cookiesToHeader(data.cookies)

	-- Send request
	local response
	response.statusCode = 200 -- Default status code

	if data.method == "GET" then
		response = {}
		local res

		local _, httpErr = pcall(function()
			res = httpService:GetAsync(data.url, false, data.headers)
		end)

		-- Auto convert json
		if isJSON(res) then
			response.data = httpService:JSONDecode(res)
		else
			response.data = res
		end

		-- Set statusCode
		if httpErr then
			response.statusCode = string.match(httpErr, "%d+") -- Get just the status code number
			error(httpErr)
		end

	elseif data.method == "POST" then
		-- Errors
		if not data.data then
			error("No POST data provided")
		end

		-- Defaults
		if data.contentType == nil then
			data.contentType = Enum.HttpContentType.ApplicationJson -- Default
		end
		
		local _, httpErr = pcall(function()
			response = httpService:PostAsync(data.url, data.data, data.contentType, false, data.headers)
		end)
		
		-- Set statusCode
		if httpErr then
			response.statusCode = string.match(httpErr, "%d+") -- Get just the status code number
			error(httpErr)
		end
	end

	return response
end

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

	-- Send request
	local response = httpService:GetAsync(data.url, false, data.headers)

	return response
end

return requests
