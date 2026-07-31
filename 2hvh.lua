local HVH = {
    Enabled = false,
    StompRunning = false,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
    end
})

RunService.Heartbeat:Connect(function()
    if not HVH.Enabled then return end
    if HVH.StompRunning then return end
    if not Toggles.AutoKillEnabled.Value then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    if (hum.Health / hum.MaxHealth) * 100 > 70 then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local koTarget = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local tc = p.Character
            if tc then
                local b = tc:FindFirstChild("BodyEffects")
                local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
                local dead = b and b:FindFirstChild("Dead") and b["Dead"].Value
                local ut = tc:FindFirstChild("UpperTorso")
                if ko and not dead and ut then
                    koTarget = ut
                    break
                end
            end
        end
    end

    if not koTarget then return end

    HVH.StompRunning = true

    task.spawn(function()
        Toggles.AutoKillEnabled:SetValue(false)
        task.wait(0.1)

        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        local returnCF = hrp.CFrame

        if hum then
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end

        -- exact same pattern as the working autostomp
        hrp.Velocity = Vector3.new()
        hrp.CFrame = CFrame.new(koTarget.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do
            task.spawn(function() if me then me:FireServer("Stomp") end end)
        end

        task.wait(0.1)

        hrp.CFrame = returnCF
        hrp.Velocity = Vector3.new()
        hrp.AssemblyLinearVelocity = Vector3.new()

        task.wait(0.15)
        Toggles.AutoKillEnabled:SetValue(true)
        task.wait(0.3)
        HVH.StompRunning = false
    end)
end)
