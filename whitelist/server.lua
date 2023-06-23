Config = {
    accesskey = 'authorizedkey' -- Will be the license key
}

local endpoint = 'http://localhost:8080/auth' -- authentication endpoint

if debug.getinfo(1) == nil or debug.getinfo(math.random, "S").what ~= 'C' or debug.getinfo(math.pow, "S").what ~= 'C' or debug.getinfo(math.fmod, "S").what ~= 'C' or debug.getinfo(json.decode, "S").what ~= 'C' or debug.getinfo(PerformHttpRequest, "S").source ~= '@citizen:/scripting/lua/scheduler.lua' or debug.getinfo(math.ceil, "S").what ~= 'C' or debug.getinfo(os.time, "S").what ~= 'C' or debug.getinfo(PerformHttpRequestInternalEx, "S").what ~= 'Lua' or debug.getinfo(pcall, "S").what ~= 'C' or debug.getinfo(debug.getinfo).what ~= 'C' or debug.getinfo(debug.getinfo).source ~= '=[C]' then
    if debug.getinfo(math.random, "S").source ~= '=[C]' or debug.getinfo(math.pow, "S").source ~= '=[C]' or debug.getinfo(math.fmod, "S").source ~= '=[C]' or debug.getinfo(json.decode, "S").source ~= '=[C]' or debug.getinfo(math.ceil, "S").source ~= '=[C]' or debug.getinfo(os.time, "S").source ~= '=[C]' or debug.getinfo(PerformHttpRequestInternalEx, "S").source ~= '@PerformHttpRequestInternalEx.lua' or debug.getinfo(pcall, "S").source ~= '=[C]' then
        return error('Exploit detected')
    end
    return error('Exploit detected')
end

local function decrypt(encoded, key)
    local decoded = ""
    for i = 1, encoded:len() do
        decoded = decoded .. string.char(encoded:byte(i) ~ key:byte(1))
    end
    return decoded
end

local t = math.random(4, 85256)
local a = math.random(68, 16879)
local b = math.random(math.fmod(t, a), math.pow(10, 8) - 1)

local auth_constants = {}
CreateThread(function()
    local success, result = pcall(function()
    PerformHttpRequest(endpoint, function(err, text, headers)
        if err == 200 then
        local response = json.decode(text)
        for i = 1, #response do
            if type(response[i].n) ~= 'number' then
                response[i].n = decrypt(response[i].n, b .. 'd')
            end
            auth_constants[response[i].k] = response[i].n
        end
        if math.ceil(b * a / t % os.time() + 7193) == auth_constants[2] then
            print(auth_constants[1])
            -- YOUR CODE HERE
        else
            return error('Authentication failed')
        end
    elseif err == 403 then
        return error('Authentication failed')
    else 
        return error('Authentication failed')
        end
    end, 'GET', '', {
        ['Content-Type'] = 'application/json',
        ['o'] = ' ' .. b .. ' ',
        ['l'] = ' ' .. a .. ' ',
        ['m'] = ' ' .. t .. ' ',
        ['productkey'] = Config.accesskey,
    })
    end)
    if not success then
        return error('Error while authenticating')
    end
end)