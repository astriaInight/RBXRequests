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
function requests:SendRequest(requestOptions)
	-- requestOptions: url, method, cookies, headers
	-- Errors
	if not requestOptions then
		error("No requestOptions provided")
	end
	if not requestOptions.url then
		error("No URL provided")
	end
	if not requestOptions.method then
		error("No method provided")
	end

	-- Defaults
	if not requestOptions.cookies then
		requestOptions.cookies = {}
	end
	if not requestOptions.headers then
		requestOptions.headers = {}
	end
	requestOptions.method = string.upper(requestOptions.method) -- Make method uppercase
	requestOptions.url = trustBypass(requestOptions.url) -- Allow access to roblox sites

	-- Setup cookies
	requestOptions.headers['Cookie'] = cookiesToHeader(requestOptions.cookies)

	-- Send request
	local response = {
		statusCode = 200 -- Default status code
	}

	if requestOptions.method == "GET" then
		response = {}
		local res

		local _, httpErr = pcall(function()
			res = httpService:GetAsync(requestOptions.url, false, requestOptions.headers)
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

	elseif requestOptions.method == "POST" then
		-- Errors
		if not requestOptions.data then
			error("No POST data provided")
		end

		-- Defaults
		if requestOptions.contentType == nil then
			requestOptions.contentType = Enum.HttpContentType.ApplicationJson -- Default
		end
		
		-- Convert dictionary to json
		if not isJSON(requestOptions.data) then
			if type(requestOptions.data) == "table" then
				requestOptions.data = httpService:JSONEncode(requestOptions.data)
			end
		end
		
		-- Send request
		local _, httpErr = pcall(function()
			response = httpService:PostAsync(requestOptions.url, requestOptions.data, requestOptions.contentType, false, requestOptions.headers)
		end)
		
		-- Set statusCode
		if httpErr then
			response.statusCode = string.match(httpErr, "%d+") -- Get just the status code number
			error(httpErr)
		end
	end

	return response
end

function requests:Get(requestOptions)
	-- Errors
	if not requestOptions then
		error("No requestOptions provided")
	end
	if not requestOptions.url then
		error("No URL provided")
	end

	-- Defaults
	if not requestOptions.cookies then
		requestOptions.cookies = {}
	end
	if not requestOptions.headers then
		requestOptions.headers = {}
	end

	-- Send request
	local response = requests:SendRequest({
		url = requestOptions.url,
		cookies = requestOptions.cookies,
		headers = requestOptions.headers,
		method = "GET"
	})

	return response
end

function requests:Post(requestOptions)
	-- Errors
	if not requestOptions then
		error("No requestOptions provided")
	end
	if not requestOptions.url then
		error("No URL provided")
	end

	-- Defaults
	if not requestOptions.cookies then
		requestOptions.cookies = {}
	end
	if not requestOptions.headers then
		requestOptions.headers = {}
	end

	-- Send request
	local response = requests:SendRequest({
		url = requestOptions.url,
		cookies = requestOptions.cookies,
		headers = requestOptions.headers,
		data = requestOptions.data,
		method = "POST"
	})

	return response
end

return requests
