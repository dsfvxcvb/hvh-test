local HVH = { Enabled = false, Running = false }

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then HVH.Running = false end
    end
})
print("not a nigger")

task.spawn(function()
    while true do
        task.wait()
        if not HVH.Enabled or HVH.Running then continue end
        if not AutoKill.Enabled then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hrp or not hum then continue end
        if (hum.Health / hum.MaxHealth) * 100 > 70 then continue end

        local koTarget = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tc = p.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    local ko = b and b:FindFirstChild("K.O")
                    local dead = b and b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        local ut = tc:FindFirstChild("UpperTorso")
                        if ut then koTarget = {player = p, ut = ut} break end
                    end
                end
            end
        end

        if not koTarget then continue end
        HVH.Running = true

        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then HVH.Running = false continue end

        local ret = hrp.CFrame
        local ut = koTarget.ut

        -- pause the autokill loop
        AutoKill.HVHPause = true
        for _ = 1, 5 do RunService.Heartbeat:Wait() end

        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do me:FireServer("Stomp") end
        hrp.CFrame = ret
        hrp.AssemblyLinearVelocity = Vector3.zero

        task.wait(0.2)

        AutoKill.HVHPause = false
        AutoKill.CycleActive = false
        AutoKill.StartCycle()

        task.wait(0.5)
        HVH.Running = false
    end
end)
