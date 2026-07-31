local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            if AutoKill.HVHPause then
                AutoKill.HVHPause = false
                if AutoKill.Enabled then
                    AutoKill.StartCycle()
                end
            end
        end
    end
})

-- Get MainEvent once
local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

-- Find a KO'd player (exactly like the working autostomp)
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

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.2)
        
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
        
        -- Find KO target
        local koTarget = GetKOTarget()
        if not koTarget then continue end
        
        print(string.format("[HVH] Health below 70%%! Found KO target: %s", koTarget.Name))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== STOP AUTO KILL =====
        print("[HVH] Stopping AutoKill...")
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        task.wait(0.3)
        
        -- ===== STOMP THE KO TARGET =====
        print("[HVH] Stomping...")
        
        local success = pcall(function()
            local koChar = koTarget.Character
            if not koChar then return end
            
            local koBody = koChar:FindFirstChild("BodyEffects")
            if not koBody then return end
            
            local koValue = koBody:FindFirstChild("K.O")
            local deadValue = koBody:FindFirstChild("Dead")
            
            -- Keep stomping while they're still KO'd
            local stompCount = 0
            while koValue and koValue.Value and (not deadValue or not deadValue.Value) and stompCount < 10 do
                local ut = koChar:FindFirstChild("UpperTorso")
                if ut then
                    -- Reset humanoid state (exactly like working autostomp)
                    hum.Sit = false
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    
                    -- Clear velocity
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    
                    -- Teleport above the target
                    hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
                    
                    -- Wait for teleport to register
                    RunService.RenderStepped:Wait()
                    task.wait(0.05)
                    
                    -- Stomp 5 times
                    for i = 1, 5 do
                        mainevent:FireServer("Stomp")
                        task.wait(0.08)
                    end
                    
                    stompCount = stompCount + 1
                    print(string.format("[HVH] Stomp cycle %d/10", stompCount))
                end
                
                -- Check if target is still KO'd
                task.wait(0.1)
                koChar = koTarget.Character
                if koChar then
                    koBody = koChar:FindFirstChild("BodyEffects")
                    if koBody then
                        koValue = koBody:FindFirstChild("K.O")
                        deadValue = koBody:FindFirstChild("Dead")
                    end
                end
            end
        end)
        
        if success then
            print("[HVH] Stomp complete!")
        else
            print("[HVH] Stomp failed!")
        end
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        -- Restore original target if still valid
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            if target and target.Character then
                local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    AutoKill.Target = target
                    print(string.format("[HVH] Restored target: %s", target.Name))
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
        AutoKill.HVHPause = false
        
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        HVH.OriginalTarget = nil
        task.wait(0.5)
        HVH.Running = false
        
        print("[HVH] HVH cycle complete")
    end
end)

print("[HVH] Loaded - Will stomp KO'd players when health drops below 70%")
print("PLEASE WORK")
