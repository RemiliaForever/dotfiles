utf8str = {}

local function charsize(ch)
    if not ch then return 0
    elseif ch >=252 then return 6
    elseif ch >= 248 and ch < 252 then return 5
    elseif ch >= 240 and ch < 248 then return 4
    elseif ch >= 224 and ch < 240 then return 3
    elseif ch >= 192 and ch < 224 then return 2
    elseif ch < 192 then return 1
    end
end

function utf8str.len(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = charsize(char)
        currentIndex = currentIndex + cs
        len = len +1
        if cs == 1 then
            aNum = aNum + 1
        elseif cs >= 2 then
            hNum = hNum + 1
        end
    end
    return len, aNum, hNum
end


function utf8str.sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        local charsize = charsize(char)
        startIndex = startIndex + charsize
        -- if charsize >= 2 then
        --     startChars = startChars - 2
        -- else
            startChars = startChars - 1
        -- end
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local charsize = charsize(char)
        currentIndex = currentIndex + charsize
        if charsize >= 2 then
            numChars = numChars - 2
        else
            numChars = numChars - 1
        end
    end
    return str:sub(startIndex, currentIndex - 1)
end

return utf8str
