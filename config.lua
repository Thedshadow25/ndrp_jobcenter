Config = {}

-- ===================================================
-- JOB CENTER NPC CONFIGURATION
-- ===================================================
Config.Ped = {
    model = 'a_f_y_business_04',
    coords = vector4(-262.38, -963.38, 30.22, 159.14),
    scenario = 'WORLD_HUMAN_CLIPBOARD',
    blip = {
        sprite = 480,
        color = 3,
        scale = 0.85,
        label = 'Job Center',
    },
    interactLabel = 'Visit Job Center',
    interactIcon = 'fas fa-briefcase',
}

-- ===================================================
-- LEVEL SYSTEM
-- 1 hour of working = 1 level up (tracked automatically)
-- ===================================================
Config.MinutesPerLevel = 60 -- minutes of work time per level

-- ===================================================
-- AVAILABLE JOBS
-- requiredLevel = 1 means no requirement (everyone starts at 1)
-- ===================================================
Config.Jobs = {}
Config.Jobs = {
    {
        id = 'electrician',
        name = 'Electrician',
        description = 'Install and maintain electrical systems in buildings throughout the city',
        icon = 'fas fa-bolt',
        salary = '$1000/hour',
        recommended = true,
        requiredLevel = 1,
        location = {
            coords = vector3(152.16, -3210.88, 5.91),
            blip = { sprite = 477, color = 3, scale = 0.9, label = 'Job' },
        },
        tutorial = {
            { icon = 'fas fa-map-marker-alt',  text = 'Drive to the marked location on the map' },
            { icon = 'fas fa-briefcase',           text = 'Start the job with your employer' },
            { icon = 'fas fa-bolt',   text = 'Drive around in your work vehicle and wait for jobs to come in' },
            { icon = 'fas fa-coins', text = 'Return to your employer when finished to complete the job and receive payment' },
        },
    },
    {
        id = 'garbage',
        name = 'Garbage Collector',
        description = 'Collect garbage from trash bins around the city and manage waste recycling',
        icon = 'fas fa-trash',
        salary = '$1000/hour',
        recommended = true,
        requiredLevel = 1,
        location = {
            coords = vector3(152.16, -3210.88, 5.91),
            blip = { sprite = 477, color = 3, scale = 0.9, label = 'Job' },
        },
        tutorial = {
            { icon = 'fas fa-recycle',  text = 'Drive to the marked location on the map' },
            { icon = 'fas fa-briefcase',           text = 'Start the job with your employer' },
            { icon = 'fas fa-trash',   text = 'Drive around in the garbage truck and collect trash or recycling bags' },
            { icon = 'fas fa-coins', text = 'Return to your employer when finished to complete the job and receive payment' },
        },
    },
}
