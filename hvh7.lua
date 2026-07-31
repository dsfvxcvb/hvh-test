local HVH = {
    Enabled = false,
    Running = false,
}

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
        -- stop the autokill cycle so it stops teleporting us
        AutoKill.StopCycle()
        task.wait(0.1)

        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum2 or not me then
            AutoKill.StartCycle()
            HVH.Running = false
            return
        end

        local ret = hrp.CFrame
        local ut = koTarget.Character and koTarget.Character:FindFirstChild("UpperTorso")
        if not ut then
            AutoKill.StartCycle()
            HVH.Running = false
            return
        end

        -- exact working stomp pattern
        hum2.Sit = false
        hum2.PlatformStand = false
        hum2:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.Velocity = Vector3.new()
        hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do task.spawn(function() me:FireServer("Stomp") end) end
        hrp.CFrame = ret

        -- wait for stomp to land then go back
        while hrp and (hrp.Position - ret.Position).Magnitude > 5 do
            hrp.CFrame = ret
            task.wait()
        end
        me:FireServer("Stomp")
        task.wait(0.3)

        -- resume autokill on original target
        AutoKill.StartCycle()
        task.wait(0.5)
        HVH.Running = false
    end)
end)
