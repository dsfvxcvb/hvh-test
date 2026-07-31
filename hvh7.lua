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

-- Simple one-time stomp
local function DoOneStomp(hrp, hum, target)
    if not target or not target.Character then return false end
    
    local ut = target.Character:FindFirstChild("UpperTorso")
    if not ut then return false end
    
    -- Save position
    local originalCF = hrp.CFrame
    
    -- Reset humanoid
    hum.Sit = false
    hum.PlatformStand = false
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    
    -- Clear velocity
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    -- Teleport above target
    hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
    task.wait(0.05)
    RunService.RenderStepped:Wait()
    
    -- Stomp 5 times quickly
    for i = 1, 5 do
        mainevent:FireServer("Stomp")
        task.wait(0.05)
    end
    
    -- Return
    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    return true
end

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.2)
        
        -- Cooldown between HVH triggers
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
        
        -- Check health below 70%
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then
            continue
        end
        
        -- Find KO target
        local koTarget = GetKOTarget()
        if not koTarget then continue end
        
        print(string.format("[HVH] HP: %d%%, Stomping: %s", math.floor(healthPercent), koTarget.Name))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== PAUSE AUTO KILL =====
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        
        -- Stop any auto-stomp
        if AutoKill.StopAutoStomp then
            AutoKill.StopAutoStomp()
        end
        AutoKill.GunMethod.StompRunning = false
        
        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
            getgenv().AutoStompState.running = false
        end
        
        task.wait(0.15)
        
        -- ===== ONE STOMP =====
        local success = DoOneStomp(hrp, hum, koTarget)
        
        if success then
            print("[HVH] Stomp complete!")
        else
            print("[HVH] Stomp failed!")
        end
        
        task.wait(0.1)
        
        -- ===== RESUME AUTO KILL =====
        -- Restore original target if still alive
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
        
        -- Re-enable AutoKill
        AutoKill.Enabled = true
        
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        -- Reset
        HVH.OriginalTarget = nil
        HVH.Running = false
        
        -- 3 second cooldown before HVH can trigger again
        HVH.Cooldown = tick() + 3
        
        print("[HVH] HVH complete, cooldown 3s")
    end
end)

print("[HVH] Loaded - Single stomp when health < 70%")
print("testig")
