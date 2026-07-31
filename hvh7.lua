local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil,
    Cooldown = 0
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
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

-- Stomp function with LOCKING and controlled remote firing
local function DoStomp(hrp, hum, target)
    if not target or not target.Character then return false end
    
    local targetChar = target.Character
    local ut = targetChar:FindFirstChild("UpperTorso")
    if not ut then return false end
    
    -- Save original position
    local originalCF = hrp.CFrame
    
    print("[HVH] Starting stomp sequence...")
    
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
    
    -- LOCK POSITION - Keep updating position above target
    local lockConnection = nil
    local stompCount = 0
    local maxStomps = 8
    
    -- Create a connection to lock position during stomps
    lockConnection = RunService.RenderStepped:Connect(function()
        if not targetChar or not targetChar.Parent then
            return
        end
        
        -- Get current UpperTorso position
        local currentUT = targetChar:FindFirstChild("UpperTorso")
        if currentUT then
            local currentPos = currentUT.Position + Vector3.new(0, 3.5, 0)
            -- Keep the player locked above the target
            hrp.CFrame = CFrame.new(currentPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
    
    -- Fire stomps with proper delays
    for i = 1, maxStomps do
        -- Check if target is still KO'd
        local koBody = targetChar:FindFirstChild("BodyEffects")
        if koBody then
            local ko = koBody:FindFirstChild("K.O")
            local dead = koBody:FindFirstChild("Dead")
            if not ko or not ko.Value or (dead and dead.Value) then
                print("[HVH] Target no longer KO'd, stopping stomp")
                break
            end
        end
        
        -- Fire stomp remote
        local success = pcall(function()
            mainevent:FireServer("Stomp")
        end)
        
        if success then
            stompCount = stompCount + 1
        end
        
        -- Wait between stomps (prevents spam and gives server time)
        task.wait(0.12)
    end
    
    -- Disconnect the lock
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    
    print(string.format("[HVH] Stomped %d times", stompCount))
    
    -- Return to original position
    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    return stompCount > 0
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
        
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then
            continue
        end
        
        local koTarget = GetKOTarget()
        if not koTarget then continue end
        
        print(string.format("[HVH] HP: %d%%, Stomping: %s", math.floor(healthPercent), koTarget.Name))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        
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
        
        -- ===== DO STOMP WITH LOCKING =====
        local success = DoStomp(hrp, hum, koTarget)
        
        if success then
            print("[HVH] ✅ Stomp successful!")
        else
            print("[HVH] ❌ Stomp failed!")
        end
        
        task.wait(0.2)
        
        -- ===== RESUME AUTO KILL =====
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
        HVH.Cooldown = tick() + 3
        
        print("[HVH] HVH complete, cooldown 3s")
    end
end)

print("[HVH] Loaded - Teleports, locks, and stomps when health < 70%")
