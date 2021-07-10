# Requests:SendRequest()

## Parameters

|   |   |
--- | ---
| **Name** | data |
| **Type** | dictionary |
| **Default** |   |
| **Summary** | Determines how the request is sent and what data is included. |

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


