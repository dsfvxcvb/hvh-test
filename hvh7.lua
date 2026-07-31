local HVH = {
    Enabled = false,
    Running = false,
}
print("LOAD HOLY FUCK")

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then HVH.Running = false end
    end
})

RunService.Heartbeat:Connect(function()
    if not HVH.Enabled then return end
    if HVH.Running then return end
    if not AutoKill.Enabled then return end
    if AutoKill.GunMethod.StompRunning then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    if (hum.Health / hum.MaxHealth) * 100 > 70 then return end

    local koTarget = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local tc = p.Character
            if tc then
                local b = tc:FindFirstChild("BodyEffects")
                local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
                local dead = b and b:FindFirstChild("Dead") and b["Dead"].Value
                if ko and not dead and tc:FindFirstChild("UpperTorso") then
                    koTarget = p
                    break
                end
            end
        end
    end

    if not koTarget then return end

    HVH.Running = true

    task.spawn(function()
        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum2 or not me then
            HVH.Running = false
            return
        end

        local ut = koTarget.Character and koTarget.Character:FindFirstChild("UpperTorso")
        if not ut then
            HVH.Running = false
            return
        end

        -- kill the cycle by disabling autokill entirely so the loop exits
        local savedTarget = AutoKill.Target
        AutoKill.Enabled = false
        AutoKill.CycleActive = false
        -- wait enough frames for the running task.spawn loop to see Enabled=false and stop
        task.wait(0.15)

        local ret = hrp.CFrame

        hum2.Sit = false
        hum2.PlatformStand = false
        hum2:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.Velocity = Vector3.new()
        hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do task.spawn(function() me:FireServer("Stomp") end) end
        hrp.CFrame = ret
        me:FireServer("Stomp")

        task.wait(0.2)

        -- restore and restart
        AutoKill.Target = savedTarget
        AutoKill.Enabled = true
        AutoKill.StartCycle()

        task.wait(0.5)
        HVH.Running = false
    end)
end)
