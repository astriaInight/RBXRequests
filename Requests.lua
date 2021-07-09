local httpService = game:GetService("HttpService")

local requests = {}

-- Functions
local function getRawCookie(cookie)
	return string.gsub(cookie, "_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_", "")
end

local function removeLastChar(str)
	return string.sub(str, 0, #str - 1)
end

local function cookiesToHeader(cookies)
	local headersStr = "Cookie="
	
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
	for _, t in (...) do
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
	--[[ #Sample data
	{
		url = "https://roblox.com",
		cookies = {
			['.ROBLOSECURITY'] = "cookie goes here",
		}
		headers = {
			['x-csrf-token'] = "token goes here"
		}
	}
	]]
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
	data.headers = mergeTables(data.headers, cookiesToHeader(data.cookies))
	
	-- Send request
	local response = httpService:GetAsync(data.url, false, data.headers)
	
	return response
end

return requests
