-- ===================================================
-- MAIN ENGINE BROADCAST CORE (HOSTED ON GITHUB)
-- ===================================================

colors = {"`2", "`9", "`6", "`9", "`5", "`e", "`c", "`^", "`o", "`$"}
emotes = {"(wl)", "(yes)", "(no)", "(love)", "(oops)", "(shy)", "(wink)", "(tongue)", "(agree)", "(Sleep)", "(punch)", "(music)", "(build)", "(megaphone)", "(sigh)", "(mad)", "(wow)", "(dance)", "(see-no-evil)", "(bheart)", "(heart)", "(grow)", "(gems)", "(kiss)", "(gtoken)", "(lol)", "(smile)", "(cool)", "(cry)", "(vend)", "(bunny)", "(cactus)", "(pine)", "(peace)", "(terror)", "(troll)", "(evil)", "(fireworks)", "(football)", "(alien)", "(party)", "(pizza)", "(clap)", "(song)", "(ghost)", "(nuke)", "(halo)", "(turkey)", "(gift)", "(cake)", "(heartarrow)", "(lucky)", "(shamrock)", "(grin)", "(ill)", "(eyes)", "(weary)", "(moyai)", "(plead)"}

function chat(text) SendPacket(2, "action|input\ntext|"..text) end
function sz(str) return str:gsub("Dr%.", ""):gsub("``", ""):gsub("`.", ""):gsub("@", ""):gsub(" of Legend", ""):gsub("%[BOOST%]", ""):gsub("%[ELITE%]", ""):gsub("`w", "") end
function chg() chat("/nick `#@"..sz(data.name).."`9["..data.worldName.."]") end

function checkWhitelist()
    local userURL = "https://raw.githubusercontent.com/Cibay351/DataBaseBuyerMayori/refs/heads/main/whitelistedsb.json"
    local myID = tostring(GetLocal().userid)
    console("`5Checking UserID: " .. myID)
    Sleep(1000)
    local response = MakeRequest(userURL, "GET")
    if response and response.content and response.content ~= "" then
        if response.content:find('"' .. myID .. '"') or response.content:find(myID) then
            console("`2[SUCCESS] UserID Verified!")
            return true
        end
    end
    console("`4[ERROR] UserID Not Registered!")
    return false
end

if not checkWhitelist() then return end

function Filter(str) return str:gsub("`(%S)", "") end
function shuffle(arr)
  for i = #arr, 2, -1 do
    local j = math.random(1, i)
    arr[i], arr[j] = arr[j], arr[i]
  end
  return arr
end

function FTime(sec)
  local minutes = math.floor(sec % 3600 / 60)
  local seconds = math.floor(sec % 60)
  return string.format("%sm %ss", minutes, seconds)
end

function FNum(num)
  num = tonumber(num) or 0
  if num >= 1000000.0 then return string.format("%.2fM", num / 1000000.0)
  elseif num >= 1000.0 then return string.format("%.1fK", num / 1000.0)
  else return tostring(num) end
end

function move(x, y)
    if GetWorld() == nil then return end 
    local iX, iY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32) 
    SendPacketRaw(false, {type = 3, state = 1, px = x, py = y, x = x * 32, y = y * 32}) 
    SendVariantList({[0] = "OnSetPos",[1] = {x = x*32, y = y*32}}, GetLocal().netid)
    Sleep(100) 
end

function backToTile()
    if pindah and TileX and TileY then
        if GetWorld() ~= nil and GetLocal() ~= nil then
            local posX, posY = math.floor(GetLocal().pos.x // 32), math.floor(GetLocal().pos.y // 32)
            if posX ~= TileX or posY ~= TileY then
                move(TileX, TileY)
                Sleep(1000)
            else
                pindah = false
            end
        end
    end
end

function buyCheat()
    if not data.cheat then
        SendPacket(2, "action|dialog_return\ndialog_name|buycheat\n")
        data.cheat = true
    end
end

function sendWebhook(url, payloadData)
    MakeRequest(url, "POST", { ["Content-Type"] = "application/json" }, payloadData)
end

function SendInfoWebhook()
    if not webhook or webhookLink == "" then return end
    local currentGems = GetPlayerInfo().gems or 0
    local payload = string.format([[{
      "username": "Mayori Engine",
      "embeds": [{
        "title": "🔥 BROADCAST REPORT 🔥",
        "fields": [
          {"name": "World", "value": "%s", "inline": true},
          {"name": "Sending SB", "value": "%d/%d", "inline": true},
          {"name": "Current Gems", "value": "%s", "inline": true}
        ]
      }]
    }]], data.worldName, startSb, countSb, FNum(currentGems))
    sendWebhook(webhookLink, payload)
end

function onvariant(var)
    if var[0] == "OnSDBroadcast" and blokSDB then return true
    elseif var[0] == "OnDialogRequest" then
        if var[1]:find("display_text") and copySign and not running then
            rawText = var[1]:match("display_text||(.+)|128") or ""
            if rawText ~= "" then
                textSb = rawText .. " `##" .. customTag .. " " .. wm
                console("`2[COPY SIGN] Text: " .. rawText)
            end
            return true
        end
    elseif var[0] == "OnConsoleMessage" then
        if var[1]:find("sent. Used") then data.succes = true
        elseif var[1]:find("Spammer Slave") and blokSpammer then return true
        elseif var[1]:find("spun the wheel") and blokSpin then return true end
    end
    return false
end

function onsendpacket(type, str)
    if str:find("action|friends\ndelay|0\n") then hide = not hide return true end
    return false
end

AddHook('OnVariant', 'variant', onvariant)
AddHook('OnSendPacket', 'sendpacket', onsendpacket)

TileX, TileY = math.floor(GetLocal().pos.x // 32), math.floor(GetLocal().pos.y // 32)

-- MAIN LOOP
while true do
    if TileX ~= nil and TileY ~= nil then
        if running then
            if not appliedSettings then
                if roleMod then chg() Sleep(500) end
                if IgnoreOther or lonelyMode then
                    buyCheat()
                    local checkLonely = lonelyMode and 1 or 0
                    local checkIgnore = IgnoreOther and 1 or 0
                    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_lonely|" .. checkLonely .. "\ncheck_ignoref|" .. checkIgnore .. "\n")
                end
                appliedSettings = true
            end
            
            repeat
                if pcall(GetTile) then
                    color = shuffle(colors)
                    emote = shuffle(emotes)
                    SendPacket(2, "action|input\ntext|" .. color[1] .. "Sending Super-Broadcast")
                    Sleep(1000)
                    
                    if #(textSb .. emote[2]) > 115 then
                        SendPacket(2, "action|input\ntext|/sb " .. textSb)
                    else
                        SendPacket(2, "action|input\ntext|/sb " .. textSb .. emote[2])
                    end
                    
                    backToTile()
                    Sleep(4000)
                    
                    if data.succes then
                        startSb = startSb + 1
                        data.remainingSb = countSb - startSb
                        timeLeft = FTime(data.remainingSb * 3 * 60)
                        console("`2[SUCCESS] Sent SB " .. startSb .. "/" .. countSb)
                        SendInfoWebhook()
                        data.succes = false
                        
                        if startSb < countSb then
                            for sec = 1, 180 do
                                backToTile()
                                Sleep(1000)
                            end
                        end
                    else
                        console("`4SB Pending, retrying in 10s...")
                        Sleep(10000)
                    end
                end
            until startSb == countSb
            
            if startSb == countSb then break end
        else
            appliedSettings = false
            Sleep(1000)
        end
    else
        Sleep(2000)
    end
end

if autoExit and world_done ~= "" then
    SendPacket(3, "action|join_request\nname|" .. world_done .. "\ninvitedWorld|0")
end
