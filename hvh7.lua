local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil,
    Cooldown = 0,
    StompAttempts = 0
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            HVH.StompAttempts = 0
        end
    end
})

local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

local function GetKOTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            if c then
                local b = c:FindFirstChild("BodyEffects")
                if b then
                    local ko = b:FindFirstChild("K.O")
                    local dead = b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        return p
                    end
                end
            end
        end
    end
    return nil
end

-- Get all KO targets
local function GetAllKOTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            if c then
                local b = c:FindFirstChild("BodyEffects")
                if b then
                    local ko = b:FindFirstChild("K.O")
                    local dead = b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        local ut = c:FindFirstChild("UpperTorso")
                        if ut then
                            table.insert(targets, {
                                player = p,
                                character = c,
                                upperTorso = ut
                            })
                        end
                    end
                end
            end
        end
    end
    return targets
end

-- Check if stomp was successful (health increased)
local function CheckHealthGain(originalHealth, currentHealth)
    return currentHealth > originalHealth
end

-- Stomp function with retry logic
local function DoStompWithRetry(hrp, hum, target, maxRetries)
    if not target or not target.character then return false end
    
    local targetChar = target.character
    local ut = target.upperTorso
    if not ut then return false end
    
    -- Save original position and health
    local originalCF = hrp.CFrame
    local originalHealth = hum.Health
    
    print(string.format("[HVH] Starting stomp on %s (HP: %.1f)", target.player.Name, originalHealth))
    
    -- Reset humanoid state
    hum.Sit = false
    hum.PlatformStand = false
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    
    -- Clear velocity
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    -- Teleport above target
    local stompPos = ut.Position + Vector3.new(0, 3.5, 0)
    hrp.CFrame = CFrame.new(stompPos)
    
    -- Wait for teleport to register
    task.wait(0.1)
    
    -- Lock position
    local lockConnection = nil
    local stompCount = 0
    local stompSuccess = false
    
    -- Create connection to lock position
    lockConnection = RunService.RenderStepped:Connect(function()
        if not targetChar or not targetChar.Parent then
            return
        end
        
        local currentUT = targetChar:FindFirstChild("UpperTorso")
        if currentUT then
            local currentPos = currentUT.Position + Vector3.new(0, 3.5, 0)
            hrp.CFrame = CFrame.new(currentPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
    
    -- Stomp loop
    for attempt = 1, maxRetries do
        -- Check if target is still KO'd
        local koBody = targetChar:FindFirstChild("BodyEffects")
        if koBody then
            local ko = koBody:FindFirstChild("K.O")
            local dead = koBody:FindFirstChild("Dead")
            if not ko or not ko.Value or (dead and dead.Value) then
                print("[HVH] Target no longer KO'd")
                break
            end
        end
        
        -- Fire stomp remote
        for i = 1, 3 do
            pcall(function()
                mainevent:FireServer("Stomp")
                stompCount = stompCount + 1
            end)
            task.wait(0.05)
        end
        
        -- Check if health increased
        local currentHealth = hum.Health
        if currentHealth > originalHealth then
            local healthGain = currentHealth - originalHealth
            print(string.format("[HVH] ✅ Health increased by %.1f (%.1f → %.1f)", healthGain, originalHealth, currentHealth))
            stompSuccess = true
            break
        end
        
        print(string.format("[HVH] Attempt %d/%d - Health: %.1f (need > %.1f)", attempt, maxRetries, currentHealth, originalHealth))
        task.wait(0.1)
    end
    
    -- Disconnect lock
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    
    -- Return to original position
    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    print(string.format("[HVH] Stomped %d times, Success: %s", stompCount, tostring(stompSuccess)))
    
    return stompSuccess
end

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.2)
        
        if tick() < HVH.Cooldown then
            continue
        end
        
        if not HVH.Enabled or HVH.Running then
            continue
        end
        
        if not AutoKill.Enabled then
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- CHANGED: Health threshold to 50%
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 50 then  -- Changed from 70 to 50
            continue
        end
        
        -- Get all KO targets
        local koTargets = GetAllKOTargets()
        if #koTargets == 0 then
            print("[HVH] No KO targets found")
            continue
        end
        
        print(string.format("[HVH] HP: %d%%, Found %d KO targets", math.floor(healthPercent), #koTargets))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        HVH.StompAttempts = 0
        
        -- ===== STOP AUTO KILL =====
        print("[HVH] Stopping AutoKill...")
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        
        if AutoKill.StopAutoStomp then
            AutoKill.StopAutoStomp()
        end
        AutoKill.GunMethod.StompRunning = false
        
        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
            getgenv().AutoStompState.running = false
        end
        
        task.wait(0.2)
        
        -- ===== TRY STOMP ON TARGETS UNTIL HEALTH RESTORED =====
        local healthRestored = false
        
        -- Shuffle targets to try different ones
        for i = #koTargets, 2, -1 do
            local j = math.random(1, i)
            koTargets[i], koTargets[j] = koTargets[j], koTargets[i]
        end
        
        for _, target in ipairs(koTargets) do
            if healthRestored then
                break
            end
            
            -- Check if target is still valid
            local koBody = target.character:FindFirstChild("BodyEffects")
            if koBody then
                local ko = koBody:FindFirstChild("K.O")
                local dead = koBody:FindFirstChild("Dead")
                if not ko or not ko.Value or (dead and dead.Value) then
                    print(string.format("[HVH] Target %s no longer KO'd, skipping", target.player.Name))
                    continue
                end
            end
            
            HVH.StompAttempts = HVH.StompAttempts + 1
            print(string.format("[HVH] Attempting stomp on %s (Attempt #%d)", target.player.Name, HVH.StompAttempts))
            
            -- Try stomp with 5 retries
            local success = DoStompWithRetry(hrp, hum, target, 5)
            
            if success then
                healthRestored = true
                print(string.format("[HVH] ✅ Health restored! Current HP: %.1f", hum.Health))
                break
            else
                print(string.format("[HVH] ❌ Stomp on %s failed to restore health", target.player.Name))
            end
            
            task.wait(0.2)
        end
        
        if not healthRestored then
            print("[HVH] ⚠️ Failed to restore health after trying all targets!")
            -- Try one more time on any available target
            local anyTarget = GetKOTarget()
            if anyTarget then
                print("[HVH] Emergency stomp on any available target")
                local ut = anyTarget.Character:FindFirstChild("UpperTorso")
                if ut then
                    local emergencyTarget = {
                        player = anyTarget,
                        character = anyTarget.Character,
                        upperTorso = ut
                    }
                    DoStompWithRetry(hrp, hum, emergencyTarget, 3)
                end
            end
        end
        
        task.wait(0.2)
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            if target and target.Character then
                local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    AutoKill.Target = target
                else
                    AutoKill.Target = nil
                    AutoKill.AdvanceTarget()
                end
            else
                AutoKill.Target = nil
                AutoKill.AdvanceTarget()
            end
        else
            AutoKill.Target = nil
            AutoKill.AdvanceTarget()
        end
        
        AutoKill.Enabled = true
        
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        HVH.OriginalTarget = nil
        HVH.Running = false
        HVH.StompAttempts = 0
        
        -- 4 second cooldown
        HVH.Cooldown = tick() + 4
        
        print("[HVH] HVH complete, cooldown 4s")
    end
end)

print("[HVH] Loaded - Health < 50%, stomps KO targets until health restored")
