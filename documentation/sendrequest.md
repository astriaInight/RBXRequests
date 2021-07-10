# Requests:SendRequest()

## About
A function that can send both get or post requests.

## Returns
Returns either the [response body](https://github.com/astriaInight/RBXRequests/blob/main/documentation/responsebody.md) (string) or decoded json (array/dictionary), depending on the HTTP content type. 

## Parameters

|   |   |
--- | ---
|**Name** | data |
| **Type** | dictionary |
| **Default** |   |
| **Summary** | A single dictionary, determines how the request is sent and what data is included. |

# data
## Parameters

|   |   |
--- | ---
| **Name** | url |
| **Type** | string |
| **Default** |  |
| **Optional** | false |
| **Summary** | The URL/link the request is sent to. |
| **Example** | ```"https://google.com"``` |

# 

|   |   |
--- | ---
| **Name** | cookies |
| **Type** | dictionary |
| **Default** |  |
| **Optional** | true |
| **Summary** | Sets the cookies of the request. |
| **Example** | ```{['Cookie Name'] = "Cookie Value"}``` |

# 

|   |   |
--- | ---
| **Name** | method |
| **Type** | string |
| **Default** |  |
| **Optional** | false |
| **Summary** | Determines the type of request. |
| **Example** | `"GET"` or `"POST"` |

# data Example
```lua
{
    url = "https://google.com",
    method = "GET",
    cookies = {
        ["Cookie name"] = "Cookie value",
        ["Cookie2"] = "Test"
    },
    headers = {
        ["Header1"] = "Test",
        ["Header2"] = "Test2"
    }
}
```


