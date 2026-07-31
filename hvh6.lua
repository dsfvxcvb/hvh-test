local HVH = {
    Enabled = false,
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
    if not AutoKill.Enabled then return end
    if AutoKill.GunMethod.StompRunning then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    if (hum.Health / hum.MaxHealth) * 100 > 70 then return end

    -- find any KO'd player
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local tc = p.Character
            if tc then
                local b = tc:FindFirstChild("BodyEffects")
                local ko = b and b:FindFirstChild("K.O") and b["K.O"].Value
                local dead = b and b:FindFirstChild("Dead") and b["Dead"].Value
                if ko and not dead then
                    -- use the exact same stomp system AutoKill already uses
                    AutoKill.AutoStomp(p)
                    return
                end
            end
        end
    end
end)
