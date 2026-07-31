local HVH = {
    Enabled = false,
    Running = false,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then
            HVH.Running = false
        end
    end
})

RunService.Heartbeat:Connect(function()
    if not HVH.Enabled then return end
    if HVH.Running then return end

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

    HVH.Running = true

    task.spawn(function()
        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then HVH.Running = false return end

        -- fully stop autokill
        Toggles.AutoKillEnabled:SetValue(false)
        task.wait(0.1)

        local ret = hrp.CFrame

        -- run the exact same loop as the working autostomp
        local stomped = false
        local elapsed = 0
        while not stomped and elapsed < 3 do
            if not koTarget.Parent then break end

            local c = LocalPlayer.Character
            hrp = c and c:FindFirstChild("HumanoidRootPart")
            hum = c and c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then break end

            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = Vector3.new()
            hrp.CFrame = CFrame.new(koTarget.Position + Vector3.new(0, 3.5, 0))
            rs.RenderStepped:Wait()
            for _ = 1, 5 do task.spawn(function() me:FireServer("Stomp") end) end
            hrp.CFrame = ret

            -- return to ret and keep firing stomp like the working script does
            while (hrp.Position - ret.Position).Magnitude > 5 do
                hrp.CFrame = ret
                task.wait()
            end

            me:FireServer("Stomp")
            task.wait()
            elapsed = elapsed + task.wait()

            -- check if target is now dead/no longer KO'd = stomp landed
            if koTarget.Parent then
                local b = koTarget.Parent:FindFirstChild("BodyEffects")
                local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
                if not ko then stomped = true end
            else
                stomped = true
            end
        end

        -- return home
        if hrp then
            hrp.CFrame = ret
            hrp.Velocity = Vector3.new()
        end

        task.wait(0.1)
        Toggles.AutoKillEnabled:SetValue(true)
        task.wait(0.3)
        HVH.Running = false
    end)
end)
