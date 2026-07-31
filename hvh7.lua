local HVH = {
    Enabled = false,
    Running = false,
}
print("holy code")

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
        local targetHRP = koTarget.player.Character and koTarget.player.Character:FindFirstChild("HumanoidRootPart")

        -- reset physics rep AND re-own both parts so AutoKill can't re-glue us
        pcall(function()
            sethiddenproperty(hrp, "PhysicsRepRootPart", hrp)
            if targetHRP then hrp:SetNetworkOwner(LocalPlayer) end
        end)

        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- hold position for 10 frames fighting off AutoKill's re-glue each frame
        local stompPos = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        for _ = 1, 10 do
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
            hrp.CFrame = stompPos
            hrp.AssemblyLinearVelocity = Vector3.zero
            RunService.RenderStepped:Wait()
            -- update stomp pos in case target moved
            if ut and ut.Parent then
                stompPos = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
            end
        end

        for _ = 1, 5 do me:FireServer("Stomp") end

        -- return home fighting re-glue
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
        hrp.CFrame = ret
        hrp.AssemblyLinearVelocity = Vector3.zero

        task.wait(0.5)
        HVH.Running = false
    end
end)
