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

-- Stomp function with locking
local function StompTarget(hrp, hum, target, mainevent)
    local targetChar = target.Character
    if not targetChar then return end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    -- Save original position
    local originalCF = hrp.CFrame
    
    -- Lock character position to target
    local lockConnection = nil
    local stompCount = 0
    local maxStomps = 8
    
    -- Create a connection to constantly update position
    lockConnection = RunService.RenderStepped:Connect(function()
        if not targetChar or not targetChar.Parent then
            return
        end
        
        local koBody = targetChar:FindFirstChild("BodyEffects")
        if koBody then
            local ko = koBody:FindFirstChild("K.O")
            local dead = koBody:FindFirstChild("Dead")
            -- If no longer KO'd or dead, stop
            if not ko or not ko.Value or (dead and dead.Value) then
                return
            end
        end
        
        -- Get the UpperTorso for stomp position
        local ut = targetChar:FindFirstChild("UpperTorso")
        if ut then
            -- Lock position above the target
            local targetPos = ut.Position + Vector3.new(0, 3.5, 0)
            hrp.CFrame = CFrame.new(targetPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
    
    -- Stomp rapidly while locked
    for i = 1, maxStomps do
        -- Check if target still exists and is KO'd
        if not targetChar or not targetChar.Parent then
            break
        end
        
        local koBody = targetChar:FindFirstChild("BodyEffects")
        if koBody then
            local ko = koBody:FindFirstChild("K.O")
            local dead = koBody:FindFirstChild("Dead")
            if not ko or not ko.Value or (dead and dead.Value) then
                break
            end
        end
        
        -- Reset humanoid state
        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        
        -- Fire stomp multiple times rapidly
        for j = 1, 3 do
            mainevent:FireServer("Stomp")
        end
        
        stompCount = stompCount + 1
        task.wait(0.05) -- Very fast stomp cycle
    end
    
    -- Disconnect the lock
    if lockConnection then
        lockConnection:Disconnect()
    end
    
    -- Return to original position
    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    return stompCount
end

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.15)
        
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
        
        print(string.format("[HVH] Health %d%%, Stomping: %s", math.floor(healthPercent), koTarget.Name))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== STOP AUTO KILL =====
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        task.wait(0.15)
        
        -- ===== FAST STOMP =====
        local stompCount = StompTarget(hrp, hum, koTarget, mainevent)
        print(string.format("[HVH] Stomped %d times", stompCount or 0))
        
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
        AutoKill.HVHPause = false
        
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        HVH.OriginalTarget = nil
        task.wait(0.3)
        HVH.Running = false
    end
end)

print("[HVH] Loaded - Fast stomping with position lock")
