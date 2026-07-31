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

task.spawn(function()
    while true do
        task.wait()
        if not HVH.Enabled or HVH.Running then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        if not char or not hrp or not hum then continue end

        local healthPct = (hum.Health / hum.MaxHealth) * 100
        if healthPct > 70 then continue end

        for _, t in pairs(Players:GetPlayers()) do
            if t ~= LocalPlayer then
                local tc = t.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
                    local dead = b and b:FindFirstChild("Dead") and b["Dead"].Value
                    if ko and not dead then
                        local ut = tc:FindFirstChild("UpperTorso")
                        if ut then
                            HVH.Running = true
                            local o = hrp.CFrame
                            hum.Sit = false
                            hum.PlatformStand = false
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                            hrp.Velocity = Vector3.new()
                            hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
                            RunService.RenderStepped:Wait()
                            for i = 1, 5 do task.spawn(function() ReplicatedStorage.MainEvent:FireServer("Stomp") end) end
                            hrp.CFrame = o
                            task.wait(0.5)
                            HVH.Running = false
                        end
                    end
                end
            end
        end
    end
end)
