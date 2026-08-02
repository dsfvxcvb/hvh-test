local HVH = {
    Enabled = false,
    Stomping = false,
    LastHealth = nil,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "Auto Heal",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then
            HVH.Stomping = false
            HVH.LastHealth = nil
        end
    end
})

CombatAutoKill:AddSlider('AutoHealThreshold', {
    Text = "Health %",
    Min = 1,
    Max = 100,
    Default = 50,
    Rounding = 0,
    Callback = function(Value)
        getgenv().HVHHealthThreshold = Value
    end
})

local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

local function GetKOTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local b = c and c:FindFirstChild("BodyEffects")
            local ko = b and b:FindFirstChild("K.O")
            local dead = b and b:FindFirstChild("Dead")
            if ko and ko.Value and dead and not dead.Value then
                return p
            end
        end
    end
end

local function IsStillKOd(player)
    if not player or not player.Character then return false end
    local be = player.Character:FindFirstChild("BodyEffects")
    if not be then return false end
    local ko = be:FindFirstChild("K.O")
    local dead = be:FindFirstChild("Dead")
    return ko and ko.Value and (not dead or not dead.Value)
end

local function RunStomp(target)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local tc = target.Character
    if not tc then return end

    local returnCF = hrp.CFrame
    local returnVel = hrp.AssemblyLinearVelocity

    -- Pause AutoKill
    local wasEnabled = AutoKill.Enabled
    AutoKill.Enabled = false
    AutoKill.StopCycle()
    if getgenv().AutoStompState then
        getgenv().AutoStompState.autostomp = false
    end

    -- Use EXACT same spoof as AutoKill teleport:
    -- anchor setback at real pos, swap cam subject to it, teleport for 1 frame, snap back
    local cam = workspace.CurrentCamera
    local setback = getgenv().AutoKillSetback
    local useSpoof = getgenv().AutoKillSpoof and setback

    local timeout = tick() + 8
    while tick() < timeout and IsStillKOd(target) do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
        local ut = tc:FindFirstChild("UpperTorso") or tc:FindFirstChild("HumanoidRootPart")
        if not ut then break end

        hum.Sit = false
        hum.PlatformStand = false

        local stompCF = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        local originalVel = hrp.AssemblyLinearVelocity

        if useSpoof then
            -- anchor setback at our real position so camera stays there
            local originalSubject = cam.CameraSubject
            setback.CFrame = CFrame.new(returnCF.Position)
            cam.CameraSubject = setback
            -- teleport
            hrp.CFrame = stompCF
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            RunService.RenderStepped:Wait()
            -- fire stomp
            for _ = 1, 5 do
                task.spawn(function()
                    if getgenv().MainEvent then
                        getgenv().MainEvent:FireServer("Stomp")
                    end
                end)
            end
            -- snap back before camera subject is restored
            hrp.CFrame = returnCF
            hrp.AssemblyLinearVelocity = originalVel
            cam.CameraSubject = originalSubject
        else
            hrp.CFrame = stompCF
            hrp.AssemblyLinearVelocity = Vector3.zero
            RunService.RenderStepped:Wait()
            for _ = 1, 5 do
                task.spawn(function()
                    if getgenv().MainEvent then
                        getgenv().MainEvent:FireServer("Stomp")
                    end
                end)
            end
            hrp.CFrame = returnCF
            hrp.AssemblyLinearVelocity = originalVel
        end
    end

    -- ensure back at real pos
    pcall(function()
        hrp.CFrame = returnCF
        hrp.AssemblyLinearVelocity = returnVel
    end)

    local success = not IsStillKOd(target)
    print(string.format("[HVH] Stomp on %s: %s", target.Name, success and "✅" or "❌ timed out"))

    if wasEnabled then
        AutoKill.Enabled = true
        if AutoKill.Target or AutoKill.HasSelectedTargets() then
            AutoKill.StartCycle()
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not HVH.Enabled or HVH.Stomping then return end
    if not AutoKill.Enabled then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local hp = hum.Health
    local maxHp = hum.MaxHealth
    if maxHp <= 0 then return end

    local pct = (hp / maxHp) * 100
    local lastHp = HVH.LastHealth
    HVH.LastHealth = hp

    if pct >= (getgenv().HVHHealthThreshold or 75) then return end
    if not lastHp then return end
    if hp >= lastHp then return end
    if hp <= 0 then return end

    local target = GetKOTarget()
    if not target then return end

    HVH.Stomping = true
    print(string.format("[HVH] HP dropped to %d%%, stomping %s", math.floor(pct), target.Name))

    task.spawn(function()
        RunStomp(target)
        HVH.Stomping = false
        HVH.LastHealth = nil
    end)
end)

print("[HVH] Loaded - triggers on every health drop below 75%, stomps immediately")
print("niccer")
print("yeah bro last try")
