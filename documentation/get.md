# Requests:Get()
## Parameters
|   |   | 
--- | ---
| **Name** | data |
| **Type** | variant |
| **Default** |  |
| **Summary** | Determines how the request is sent and what data is included. |
| **Example** | ```lua
Requests:Get({
  url = string url,
  cookies = {
    ['Cookie Name'] = string cookieValue,
  },
  headers = {
    ['Header Name'] = string headerValue,
  },
})```
