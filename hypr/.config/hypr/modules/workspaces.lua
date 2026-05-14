------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1920x1080@75",
    position = "-1920x0",
    scale    = "auto",
})

--------------------
---- WORKSPACES ----
--------------------

-- Keep startup workspaces mapped to monitors
hl.workspace_rule({ workspace = "1",  monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-2" })

-- Persistent monitor assignments
for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

for i = 11, 20 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-2" })
end