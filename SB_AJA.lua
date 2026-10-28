-- SCRIPT BROADCAST BY MAYORI X MEKANIK 
-- MEMBUAT AUTO BUY CHEAT

local user = "https://raw.githubusercontent.com/Cibay351/DataBaseBuyerMayori/refs/heads/main/whitelistedsb.json"
startSb = 0
countSb = 0
textSb = "" 
customTag = "Mekanik"
wm = "`bMAYORI(shamrock)" 
copySign = true
IgnoreOther = false
webhook = true
webhookLink = "https://discord.com/api/webhooks/1557993134653448262/4KfV_bfM_X6Ae7ynpqFKkK5D3f2rds0k0Va3C-JDjo7l4JCGmrN6LbHar5ZwfGWI8bE2"
roleMod = false
running = false
world_done = ""
dcdc = false
inWorld = true
pindah = false
TileX = nil
TileY = nil


jam = 0
menit = 0

-- GUI
hide = false
lock = false
autoExit = false
blokSDB = false
blokSpammer = false
blokSpin = false
lonelyMode = false
appliedSettings = false
rawText = ""
Tx = nil
Ty = nil

data = {
    succes = false,
    tgems = " `9Gems",
    totalGemsUsed = 0,
    totalBgemsUsed = 0,
    gemsUsed = 0,
    gemsLeft = 0,
    BgemsUsed = 0,
    BgemsLeft = 0,
    worldName = GetWorld().name,
    remainingSb = countSb - startSb,
    name = GetLocal().name:match("%S+"),
    cheat = true
}
RemoveHooks()

colors = {"`2", "`9", "`6", "`9", "`5", "`e", "`c", "`^", "`o", "`$"}
emotes = {"(wl)", "(yes)", "(no)", "(love)", "(oops)", "(shy)", "(wink)", "(tongue)", "(agree)", "(Sleep)", "(punch)", "(music)", "(build)", "(megaphone)", "(sigh)", "(mad)", "(wow)", "(dance)", "(see-no-evil)", "(bheart)", "(heart)", "(grow)", "(gems)", "(kiss)", "(gtoken)", "(lol)", "(smile)", "(cool)", "(cry)", "(vend)", "(bunny)", "(cactus)", "(pine)", "(peace)", "(terror)", "(troll)", "(evil)", "(fireworks)", "(football)", "(alien)", "(party)", "(pizza)", "(clap)", "(song)", "(ghost)", "(nuke)", "(halo)", "(turkey)", "(gift)", "(cake)", "(heartarrow)", "(lucky)", "(shamrock)", "(grin)", "(ill)", "(eyes)", "(weary)", "(moyai)", "(plead)"}

--[[ === MESSAGE === ]]
function console(mekanik)
    LogToConsole("`b[`2M`4e`#k`9a`0n`5i`3k`b] `w" ..mekanik)
end

function chat(text)
    SendPacket(2, "action|input\ntext|"..text)
end

function tolay(text)
    SendVariantList({
      [0] = "OnTextOverlay",
      [1] = text
    })
end


-- [[ === NAME === ]]
function sz(str)
  return str:gsub("Dr%.", ""):gsub("``", ""):gsub("`.", ""):gsub("@", ""):gsub(" of Legend", ""):gsub("%[BOOST%]", ""):gsub("%[ELITE%]", ""):gsub("`w", "")
end

function chg()
    chat("/nick `#@"..sz(data.name).."`9["..data.worldName.."]")
end


-- [[ === VALIDASI === ]]
function checkWhitelist()
    local myID = tostring(GetLocal().userid)
    console("`5Checking UserID : ")
    Sleep(3000)
    
    local response = MakeRequest(user, "GET")
    
    if response and response.content and response.content ~= "" then
        if response.content:find('"' .. myID .. '"') or response.content:find(myID) then
            console("`2[SUCCESS] UserID Verified!")
            Sleep(3000)
            return true
        else
            console("`4[ERROR] UserID (" .. myID .. ") Not Registered!")
            tolay("`4Access Denied! Contact Admin to purchase.")
            return false
        end
    else
        console("`4[ERROR] Failed to connect to Auth Server!")
        return false
    end
end

if not checkWhitelist() then
    RemoveHooks()
    return 
end

-- PATH CONFIG (Folder dibuat manual oleh pembeli)
local configFile = "/storage/emulated/0/Android/com.rtsoft.growtopia/media/mayori/config_sb.txt"

-- [[ === CONFIG SYSTEM === ]]
function saveConfig()
    -- Mode "w" otomatis membuat file baru jika belum ada, atau menimpa isi file lama jika sudah ada
    local file = io.open(configFile, "w")
    if file then
        file:write("webhookLink=" .. tostring(webhookLink) .. "\n")
        file:write("customTag=" .. tostring(customTag) .. "\n")
        file:write("world_done=" .. tostring(world_done) .. "\n")
        file:write("blokSDB=" .. tostring(blokSDB) .. "\n")
        file:write("blokSpammer=" .. tostring(blokSpammer) .. "\n")
        file:write("blokSpin=" .. tostring(blokSpin) .. "\n")
        file:write("webhook=" .. tostring(webhook) .. "\n")
        file:close()
        console("`2[SUCCESS] Config Saved!")
        tolay("`2Config Saved Successfully!")
    else
        console("`4[ERROR] Folder 'mayori' belum dibuat! Buat folder manual di internal storage.")
        tolay("`4Folder 'mayori' Not Found!")
    end
end

function loadConfig()
    local file = io.open(configFile, "r")
    if file then
        for line in file:lines() do
            local key, value = line:match("([^=]+)=(.*)")
            if key and value then
                if key == "webhookLink" then webhookLink = value
                elseif key == "customTag" then customTag = value
                elseif key == "world_done" then world_done = value
                elseif key == "blokSDB" then blokSDB = (value == "true")
                elseif key == "blokSpammer" then blokSpammer = (value == "true")
                elseif key == "blokSpin" then blokSpin = (value == "true")
                elseif key == "webhook" then webhook = (value == "true")
                end
            end
        end
        file:close()
        console("`2[SUCCESS] Config Loaded!")
        tolay("`2Config Loaded!")
    else
        console("`4[ERROR] File config_sb.txt tidak ditemukan di folder mayori!")
        tolay("`4No Config Saved Yet!")
    end
end

-- [[ === FORMATER === ]]
function FSymbol(str)
  return str:gsub("%W", "")
end

function Filter(str)
  return str:gsub("`(%S)", "")
end

function shuffle(arr)
  for i = #arr, 2, -1 do
    local j = math.random(1, i)
    arr[i], arr[j] = arr[j], arr[i]
  end
  return arr
end

function FTime(sec)
  days = math.floor(sec / 86400)
  hours = math.floor(sec % 86400 / 3600)
  minutes = math.floor(sec % 3600 / 60)
  seconds = math.floor(sec % 60)
  if days > 0 then
    return string.format("%sd %sh", days, hours)
  elseif hours > 0 then
    return string.format("%sh %sm", hours, minutes)
  elseif minutes > 0 then
    return string.format("%sm %ss", minutes, seconds)
  elseif seconds >= 0 then
    return string.format("%ss", seconds)
  end
end

function FNum(num)
  num = tonumber(num)
  if num >= 1.0E9 then
    return string.format("%.2fB", num / 1.0E9)
  elseif num >= 1000000.0 then
    return string.format("%.2fM", num / 1000000.0)
  elseif num < 1000000.0 then
    return string.format("%.1fK", num / 1000.0)
  else
    return tostring(num)
  end
end

-- [[ === MOVE === ]]
function GoPath(t, s, v, x, y)
    if GetWorld() == nil then 
        return 
    end 
    SendPacketRaw(false, {
        type = t, -- pake apa? (8 = punch, move)
        state = s, -- 
        value = v, -- id item 
        px = x, 
        py = y, 
        x = x * 32, 
        y = y * 32
    }) 
    if t == nil then 
         SendVariantList({[0] = "OnSetPos",[1] = {x = x*32, y = y*32}}, GetLocal().netid)
    end 
end

function move(x, y)
    if GetWorld() == nil then 
        return 
    end 
    iX, iY = math.floor(GetLocal().pos.x / 32), math.floor(GetLocal().pos.y / 32) 
    DistX = x - iX 
    DistY = y - iY 
    if DistY > 1 then 
        for i = 1, math.floor(DistY / 1) do 
            iY = iY + 1 
            GoPath(3, 1, 0, iX, iY) 
            GoPath(nil, nil, nil, iX, iY) 
            Sleep(100)
        end 
    elseif DistY < -1 then 
        for i = 1, math.floor(DistY / -1) do 
            iY = iY - 1 
            GoPath(3, 1, 0, iX, iY) 
            GoPath(nil, nil, nil, iX, iY) 
            Sleep(100) 
        end 
    end 
    if DistX > 1 then 
        for i = 1, math.floor(DistX / 1) do 
            iX = iX + 1 
            GoPath(3, 1, 0, iX, iY) 
            GoPath(nil, nil, nil, iX, iY) 
            Sleep(100) 
        end 
    elseif DistX < -1 then 
        for i = 1, math.floor(DistX / -1) do 
            iX = iX - 1 
            GoPath(3, 1, 0, iX, iY) 
            GoPath(nil, nil, nil, iX, iY) 
            Sleep(100) 
        end 
    end 
    iX, iY = x, y 
    GoPath(3, 1, 0, iX, iY) 
    GoPath(nil, nil, nil, iX, iY) 
    Sleep(100) 
end

function backToTile()
    if dcdc then
        console("`5Tryng join to world again!")
        Sleep(2000)
        SendPacket(3, "action|join_request\nname|" ..data.worldName.. "\ninvitedWorld|0")
        dcdc = false
        Sleep(3000)
    end
    
    if pindah and TileX and TileY then
        if GetWorld() ~= nil and GetLocal() ~= nil then
            local posX, posY = math.floor(GetLocal().pos.x // 32), math.floor(GetLocal().pos.y // 32)
            if posX ~= TileX or posY ~= TileY then
                console("`5 Back To Tile")
                Sleep(800)
                move(TileX, TileY)
                Sleep(2000)
            else
                console("`In position!")
                pindah = false
            end
        end
    end
end

-- [[ === SISTEM === ]]
function buyCheat()
    if not data.cheat then
        SendPacket(2, "action|dialog_return\ndialog_name|buycheat\n")
        data.cheat = true
    end
end

function GemsToLocks(gem)
    gem = tonumber(gem) or 0
    local totalGemsInBase = 0
    
    if data.tgems:find("Bgems") then
        totalGemsInBase = gem * 900
    else 
        totalGemsInBase = gem 
    end
    
    local calculatedWL = math.floor(totalGemsInBase / 2000)
    local totalWL = tostring(calculatedWL)
    
    WL = tonumber(totalWL:sub(-2, -1)) or 0
    DL = tonumber(totalWL:sub(-4, -3)) or 0
    BGL = tonumber(totalWL:sub(-6, -5)) or 0
    BLK = tonumber(totalWL:sub(1, -7)) or 0
    if BLK > 0 then
        return string.format("%sBLK %sBGL %sDL %sWL", BLK, BGL, DL, WL)
    elseif BGL > 0 then
        return string.format("%sBGL %sDL %sWL", BGL, DL, WL)
    elseif DL > 0 then
        return string.format("%sDL %sWL", DL, WL)
    elseif WL > 0 then
        return string.format(":wls:", WL)
    else
        return "0 WL"
    end
end

color = shuffle(colors)
emote = shuffle(emotes)
nick = Filter(data.name)

-- [[ === INFORMASI === ]]
function sendWebhook(url, data)
    MakeRequest(url, "POST", {
        ["Content-Type"] = "application/json"
    }, data)
end

function SendInfoWebhook()
    if not webhook or webhookLink == "" then return end
    
    local currentGems = 0 
    if data.tgems:find("Bgems") then
        currentGems = tonumber(data.BgemsLeft) or 0
    else
        currentGems = GetPlayerInfo().gems or 0
    end
    
    local lastGems = (data.tgems == " `9Gems") and data.gemsUsed or data.BgemsUsed
    local totalGems = (data.tgems == " `9Gems") and data.totalGemsUsed or data.totalBgemsUsed
    
    local totalCostLock = GemsToLocks(totalGems)
    local currentGemsLock = GemsToLocks(currentGems)
    
    local timeFormatted = os.date("%d-%m-%Y %H:%M")
    
    local payload = [[
    {
      "username": "Mayori Broadcast Engine",
      "avatar_url": "https://i.imgur.com/AfFp7pu.png",
      "embeds": [
        {
          "title": "🔥 INFORMASI SB PREMIUM 🔥",
          "color": 3447003,
          "fields": [
            {
              "name": "=== ACCOUNT ===",
              "value": "Name : **]] .. Filter(data.name) .. [[**\nCurrent World : **]] .. data.worldName .. [[**\nWorld Done : **]] .. world_done .. [[**",
              "inline": false
            },
            {
              "name": "=== BROADCAST ===",
              "value": "Text : **]] .. Filter(textSb) .. [[**\nSending : **]] .. startSb .. [[/]] .. countSb .. [[**\nRemaining Time : **]] .. timeLeft .. [[**",
              "inline": false
            },
            {
              "name": "=== CURRENCY ===",
              "value": "Current Gems : **]] .. FNum(currentGems) .. [[**\nGems Used : **]] .. FNum(lastGems) .. " " .. Filter(data.tgems) .. [[**\nTotal Gems : **]] .. FNum(totalGems) .. " " .. Filter(data.tgems) .. [[**",
              "inline": false
            },
            {
              "name": "=== CONVERT TO LOCK ===", 
              "value": "Total Cost : **]] ..totalCostLock.. [[**",
              "inline": false
            }
          ],
          "footer": {
            "text": "Premium Script Broadcast Mayori | ]] .. timeFormatted .. [["
          }
        }
      ]
    }
    ]]
    sendWebhook(webhookLink, payload)
end

-- [[ === HOOKS === ]]
function onvariant(var)
    if var[0] == "OnSDBroadcast" and blokSDB then
        tolay("`4BLOCKED SDB")
        return true
    elseif var[0] == "OnDialogRequest" then
        if var[1] and var[1]:find("display_text") and copySign and not running then
            local extacted = var[1]:match("display_text||(.+)|128")
            if extacted and extacted ~= "" then
                if rawText ~= "" then
                    local full = rawText.. " `##" ..customTag.. " " ..wm
                    if #full <= 116 then
                        textSb = full
                        console("`2[SUCCESS COPY SIGN] `9TEXT : ``" ..rawText)
                    else
                        console("`4[FAILED COPY SIGN] `wText SB / Custom Tag Too Long!")
                    end
                end
            end
            if var[1]:find("`wCheater") then
                data.cheat = true
            end
            return true
        end
    elseif var[0] == "OnConsoleMessage" then
        if var[1]:find("Welcome Back") then
            return true
        elseif var[1]:find("Where would you like to go?") then
            dcdc = true
        elseif var[1]:find("World Locked") then
            if var[1]:find(data.worldName) then
                pindah = true
            end
        elseif var[1]:find("sent. Used") then
            data.succes = true
            if var[1]:find("Black") then
                data.tgems = "`aBgems"
                data.BgemsUsed = var[1]:match("Used `%$(%d+)") or data.BgemsUsed
                data.BgemsLeft = var[1]:match("`%$(%d+)`` left") or data.BgemsLeft
                data.totalBgemsUsed = data.totalBgemsUsed + data.BgemsUsed
            else
                data.tgems = " `9Gems"
                data.gemsUsed = var[1]:match("Used `%$(%d+)") or data.gemsUsed
                data.gemsLeft = var[1]:match("`%$(%d+)`` left") or data.gemsLeft
                data.totalGemsUsed = data.totalGemsUsed + data.gemsUsed
            end
        elseif var[1]:find("Spammer Slave") and blokSpammer then
            return true
        elseif var[1]:find(" spun the wheel and got") and blokSpin then
            return true
        end
    end
    return false
end

function GUI()
    if hide then
        return
    end
    local margin = 10
    if lock then
        ImGui.SetNextWindowPos(ImVec2(margin, margin), ImGui.Cond.Always)
    end
    
    if ImGui.Begin("PREMIUM BROADCAST MAYORI") then
        local windowWidht = ImGui.GetWindowSize().x
        
        -- Locked
        ImGui.Spacing()
        local lc, loc = ImGui.Checkbox("LOCK", lock)
        if lc then
            lock = loc
        end
        
        ImGui.Dummy(ImVec2(0,5))
        
        if ImGui.BeginTabBar("MainTabBar") then
            if ImGui.BeginTabItem("Settings Menu") then
                ImGui.Dummy(ImVec2(0, 5))
                ImGui.Text("___")
                ImGui.SameLine()
                ImGui.TextColored(ImVec4(1,1,0,1), "BROADCAST SETTING")
                ImGui.SameLine()
                ImGui.Text("___")
                
                local cp, cpy = ImGui.Checkbox("Auto Copy Sign", copySign)
                if cp then
                    copySign = cpy
                end
                
                local tx, txt = ImGui.InputTextWithHint("Text To SB","Your Sb Message here!", rawText)
                if tx then
                    rawText = txt 
                    textSb = rawText.. " `##" ..customTag.. " " ..wm
                end
                local tg, tag = ImGui.InputTextWithHint("Custom Tag","Your tag in sb message", customTag)
                if tg then 
                    customTag = tag 
                end
                
                if #textSb > 116 then
                    ImGui.TextColored(ImVec4(1,0,0,1), "Text SB / Custom Tag To Long")
                end
                
                ImGui.Dummy(ImVec2(0,5))
                ImGui.Separator()
                ImGui.Dummy(ImVec2(0,5))
                
                ImGui.Text("___")
                ImGui.SameLine()
                ImGui.TextColored(ImVec4(1,1,0,1), "DURATION SETTING")
                ImGui.SameLine()
                ImGui.Text("___")
                
                ImGui.Text("Time Mode")
                ImGui.SetNextItemWidth(150)
                local h, jamBaru = ImGui.InputInt("Hours", jam)
                if h then
                    jam = jamBaru
                end
                ImGui.SameLine()
                ImGui.SetNextItemWidth(150)
                local m, menitBaru = ImGui.InputInt("Minutes", menit)
                if m then
                    menit = menitBaru
                end
                -- ImGui.SameLine()
                ImGui.Dummy(ImVec2(0,5))
                ImGui.Text("Count Mode")
                ImGui.SetNextItemWidth(150)
                local c, itung = ImGui.InputInt("Count", countSb)
                if c then
                    countSb = itung
                end
                ImGui.Dummy(ImVec2(0, 10))
                if ImGui.Button("Apply Duration", ImVec2(170,40)) then
                    local totalmenit = (jam * 60) + menit
                    countSb = math.floor(totalmenit / 3)
                    
                    if countSb < 1 then
                        countSb = 1 
                    end
                    
                    data.remainingSb = countSb - startSb
                    timeLeft = FTime(data.remainingSb * 3 * 60)
                    local estimasi = countSb * 3
                    console("`2Time Setting : `b" ..jam.. " `9Hour `b" ..menit.. " `9Minutes `2[`b" ..estimasi.. " `9Minutes`b]")
                end
                
                ImGui.Dummy(ImVec2(0,5))
                ImGui.Separator()
                ImGui.Dummy(ImVec2(0,5))
                
                ImGui.Text("___")
                ImGui.SameLine()
                ImGui.TextColored(ImVec4(1,1,0,1), "WORLD SETTING")
                ImGui.SameLine()
                ImGui.Text("___")
                local ex, ext = ImGui.Checkbox("Auto Exit World SB", autoExit)
                if ex then
                    autoExit = ext
                end 
                local wnm, wnme = ImGui.InputTextWithHint("World Done Sb","Warp to world if done Sb", world_done)
                if wnm then
                    world_done = wnme
                end 
                
                ImGui.Dummy(ImVec2(0,5))
                ImGui.Separator()
                ImGui.Dummy(ImVec2(0,5))
                
                ImGui.Text("___")
                ImGui.SameLine()
                ImGui.TextColored(ImVec4(1,1,0,1), "UTILITY")
                ImGui.SameLine()
                ImGui.Text("___")
                local bSDB, vSDB = ImGui.Checkbox("Block SDB", blokSDB)
                if bSDB then
                    blokSDB = vSDB
                end 
                ImGui.SameLine()
                local s, spam = ImGui.Checkbox("Block Spammer", blokSpammer)
                if s then
                    blokSpammer = spam 
                end
                ImGui.SameLine()
                local md, mdd = ImGui.Checkbox("Role MOD", roleMod)
                if md then 
                    roleMod = mdd 
                end
                local bs, spin = ImGui.Checkbox("Block Spin", blokSpin)
                if bs then
                    blokSpin = spin 
                end 
                ImGui.SameLine()
                local lon, lonely = ImGui.Checkbox("Lonely Mode", lonelyMode)
                if lon then
                    lonelyMode = lonely
                end
                ImGui.SameLine()
                local ign, ignore = ImGui.Checkbox("Ignore Mode", IgnoreOther)
                if ign then
                    IgnoreOther = ignore 
                end
                if ImGui.Button("Set AFK POS") then
                    
                    Tx = math.floor(GetLocal().pos.x // 32)
                    Ty = math.floor(GetLocal().pos.y // 32)
                    
                    TileX, TileY = Tx, Ty 
                    -- ImGui.SameLine()
                    -- ImGui.Text("POS X : " ..TileX.. "POS Y : " ..TileY)
                end
                
                --[[ if Tx ~= nil and Ty ~= nil then
                    ImGui.Text("POS X : " ..Tx.. " POS Y : " ..Ty)
                else Tx == nil and Ty == nil then
                    ImGui.Text("POS X :   POS Y :  ")
                end ]]
                
                ImGui.Dummy(ImVec2(0,5))
                ImGui.Separator()
                ImGui.Dummy(ImVec2(0,5))
                
                ImGui.Text("___")
                ImGui.SameLine()
                ImGui.TextColored(ImVec4(1,1,0,1), "WEBHOOK SETING")
                ImGui.SameLine()
                ImGui.Text("___")
                
                local wb, hook = ImGui.Checkbox("Use WebHook", webhook)
                if wb then
                    webhook = hook 
                end
                local li, link = ImGui.InputTextWithHint("Your Webhook Link!","Your Webhook Link" ,webhookLink)
                if li then 
                    webhookLink = link 
                end
                ImGui.Dummy(ImVec2(0,2))
                if ImGui.Button("Save Configuration") then
                   --saveConfig()
                end
                
                if ImGui.Button("Load Configuration") then
                    --loadConfig()
                end
            
                ImGui.Dummy(ImVec2(0, 10))
                if ImGui.Button("START", ImVec2(70, 30)) then
                    running = true
                    appliedSettings = false
                end
                
                ImGui.EndTabItem()
            end
            
            ImGui.EndTabBar()
        end
        ImGui.End()
    end
end

function onsendpacket(type, str)
     if str:find("action|friends\ndelay|0\n") then
        hide = not hide
        return true
    end
    return false
end

if os then
    console("`5SCRIPT AUTO BROADCAST BY YORI COMMUNITY!")
    Sleep(1000)
    console("Thank you for purchasing the script")
    SendPacket(2, "action|input\ntext|/nick")
    Sleep(2000)
    SendPacket(2, "action|wrench\n|netid|"..GetLocal().netid.."\n")
    timeLeft = FTime(data.remainingSb * 3 * 60)
    Sleep(200)
    AddHook('OnVariant', 'variant', onvariant)
    Sleep(200)
    AddHook('OnSendPacket', 'sendpacket', onsendpacket)
    Sleep(1000)
    AddHook('OnDraw', 'Gui', GUI)
    TileX, TileY = math.floor(GetLocal().pos.x // 32), math.floor(GetLocal().pos.y // 32)
    Sleep(500)
    while true do
        if TileX ~= nil and TileY ~= nil then
            if running then
                if not appliedSettings then
                    
                    if roleMod then
                        chg()
                        Sleep(500)
                    end
                    
                    if IgnoreOther or lonelyMode then
                        if not data.cheat then
                            buyCheat()
                        end
                        
                        local checkLonely = lonelyMode and 1 or 0
                        local checkIgnore = IgnoreOther and 1 or 0
                        
                        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_autobuff|0\ncheck_autoremote|0\ncheck_autospam|0\ncheck_autopull|0\ncheck_autoplace|0\ncheck_antibounce|0\ncheck_modfly|0\ncheck_speed|0\ncheck_gravity|0\ncheck_lonely|" ..checkLonely.. "\ncheck_fastdrop|0\ncheck_fastwheel|0\ncheck_gems|0\ncheck_ignoreo|0\ncheck_ignoref|" ..checkIgnore.. "\n")
                    end
                    
                    appliedSettings = true
                end
                repeat
                    if pcall(GetTile) then
                        color = shuffle(colors)
                        emote = shuffle(emotes)
                        
                        SendPacket(2, "action|input\ntext|" ..color[1].. "Sending" ..emote[1].. " " ..color[2].. "Super-Broadcast")
                        Sleep(1500)
                        
                        -- Kirim command /sb
                        if #(textSb .. emote[2]) > 115 then
                            SendPacket(2, "action|input\ntext|/sb " ..textSb)
                        else
                            SendPacket(2, "action|input\ntext|/sb " ..textSb .. emote[2])
                        end
                        
                        backToTile()
                        
                        Sleep(4000)
                        
                        if data.succes then
                            color = shuffle(colors)
                            emote = shuffle(emotes)
                            startSb = startSb + 1
                            data.remainingSb = countSb - startSb
                            timeLeft = FTime(data.remainingSb * 3 * 60)
                            timetotal = countSb * 3
                            
                            local costString = FNum(data.tgems == " `9Gems" and data.gemsUsed or data.BgemsUsed) .. data.tgems
                            
                            local delai = 3500
                            chat("`2Success Sending" ..color[10].. "Super-Broadcast"..emote[3])
                            console("`2Success Sending" ..color[10].. "Super-Broadcast")
                            Sleep(5000)
                            chat("`9Total SB : `b[`2"..startSb.."/"..countSb.."`b] `9OF `b[`2"..timeLeft.." `9minutes`b]")
                            console("`9Total SB : `b[`2"..startSb.."/"..countSb.."`b] `9OF `b[`2"..timeLeft.." `9minutes`b]")
                            Sleep(delai)
                            chat("`9Time Remaining `b["..color[1] .. timeLeft .."/"..color[2] .. timeLeft .."`9 minutes`b]")
                            console("`9Time Remaining `b["..timeLeft.."/"..timetotal.."`9 minutes`b]")
                            Sleep(delai)
                            if data.tgems == " `9Gems" then
                                chat(color[3].."Used `4Gems"..emote[4])
                                console("`#Used `4Gems")
                                Sleep(delai)
                                chat("`#Used `2[`4" ..data.gemsUsed.. "`2] II `#Total : "..data.totalGemsUsed)
                                console("`#Used `2[`4" ..data.gemsUsed.. "`2] II `#Total : "..data.totalGemsUsed)
                                Sleep(delai)
                            else
                                chat(color[3].."Used `bBgems"..emote[4])
                                console("`#Used `bBgems")
                                Sleep(delai)
                                chat("`#Used `2[`4"..data.BgemsUsed.."`2] II `#Total : "..data.totalBgemsUsed)
                                console("`#Used `2[`4"..data.BgemsUsed.."`2] II `#Total : "..data.totalBgemsUsed)
                                Sleep(delai)
                            end
                            
                            chat("`2Sending Webhook"..emote[5])
                            console("`2Sending Webhook")
                            
                            SendInfoWebhook()
                            
                            data.succes = false 
                            if startSb < countSb then
                                for sec = 1, 141 do 
                                    backToTile()
                                    
                                    Sleep(1000)
                                end
                            end
                        else
                            console("`4SB Pending/Queued, mencoba kembali...")
                            Sleep(10000)
                        end
                    else
                        console("`4Terputus dari server, menunggu...")
                        Sleep(5000)
                    end
                until startSb == countSb
                
                if startSb == countSb then
                    break
                end
            else
                appliedSettings = false
                Sleep(5000)
            end
        else
            console("`wTile X and Tile Y have not been set")
            tolay("`2Tile X and Tile Y have not been set")
            Sleep(2000)
        end
    end
    Sleep(1000)
    SendPacket(2, "action|input\ntext|" ..color[9].. "Super-Broadcast Done"..emote[6])
    Sleep(1000)
    SendPacket(2, "action|input\ntext|/nick")
    Sleep(1000)
    if autoExit and world_done and world_done ~= "" then
        SendPacket(3, "action|join_request\nname|" ..world_done.. "\ninvitedWorld|0")
    else
        SendPacket(3, "action|quit_to_exit")
    end
    RemoveHooks()
else
    tolay("`9Turn On API OS, MakeRequest, and GUI To Run The Script!")
end

