# NDRP Job Center

A comprehensive job center system for FiveM roleplay servers featuring a skill progression system, NUI-based job selection, and automatic level advancement.

## 📋 Table of Contents

- [Features](#features)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Job System](#job-system)
- [Level Progression](#level-progression)
- [Project Structure](#project-structure)
- [Author](#author)

## ✨ Features

- **NUI Job Menu** - Beautiful, interactive job selection interface with real-time player statistics
- **Level Progression System** - Automatic skill progression based on work time (1 hour = 1 level)
- **Job Requirements** - Required level system for accessing advanced jobs
- **NPC Interaction** - Interactive job center NPC with ox_target support
- **Job Tutorials** - Built-in tutorial system for each job with step-by-step instructions
- **Real-time Statistics** - Track active workers per job and individual player progress
- **Metadata Tracking** - Server-side work time tracking integrated with qbx_core
- **Blip System** - Map markers for job center and job locations

## 🔧 Dependencies

This resource requires the following dependencies to be installed on your FiveM server:

| Dependency | Purpose | Repository |
|---|---|---|
| `ox_lib` | Library framework for notifications, callbacks, and NUI handling | [ox-framework/ox_lib](https://github.com/ox-framework/ox_lib) |
| `ox_target` | Targeting/interaction system for NPC interactions | [ox-framework/ox_target](https://github.com/ox-framework/ox_target) |
| `qbx_core` | Core framework providing player data, jobs, and metadata management | [Qbox-project/qbx_core](https://github.com/Qbox-project/qbx_core) |

### Frontend Dependencies

- **Font Awesome 6.5.1** - Icon library (CDN hosted, no installation needed)
- **Google Fonts (Inter)** - Typography (CDN hosted, no installation needed)

## 📦 Installation

### Prerequisites
- A working FiveM server running a compatible qbx_core framework
- All dependencies listed above must be installed and running

### Installation Steps

1. **Download the Resource**
    
    Press on `code` and then `download zip`. Extact the script and put it in your scripts folder.

2. **Verify Dependencies are Installed**
   Ensure these are in your `resources` folder:
   ```
   ✓ ox_lib
   ✓ ox_target
   ✓ qbx_core
   ```

3. **Add to server.cfg**
   Add the following line to your `server.cfg`:
   ```cfg
   ensure ndrp_jobcenter
   ```

4. **Start/Restart Server**
   ```
   restart ndrp_jobcenter
   ```
   Or restart your entire server to load all resources.

5. **Verify Installation**
   - Check server console for any errors related to `ndrp_jobcenter`
   - Approach the Job Center NPC (located at `vector4(-262.38, -963.38, 30.22, 159.14)`)
   - A blip labeled "Job Center" should appear on your map

## ⚙️ Configuration

Edit `config.lua` to customize the job center for your server:

### NPC Configuration

```lua
Config.Ped = {
    model = 'a_f_y_business_04',              -- Ped model
    coords = vector4(-262.38, -963.38, 30.22, 159.14), -- Location & heading
    scenario = 'WORLD_HUMAN_CLIPBOARD',       -- Animation
    blip = { ... }                             -- Map marker settings
}
```

### Level System

```lua
Config.MinutesPerLevel = 60  -- Work minutes required per level (default: 1 hour)
```

### Available Jobs

Each job entry in `Config.Jobs` supports:
- `id` - Unique job identifier
- `name` - Display name
- `description` - Job description shown in menu
- `icon` - Font Awesome icon class
- `salary` - Display salary (informational)
- `recommended` - Highlight as recommended job
- `requiredLevel` - Minimum level to access (1 = no requirement)
- `location.coords` - Job location coordinates
- `tutorial` - Step-by-step tutorial entries

### Adding a New Job

```lua
{
    id = 'mechanic',
    name = 'Mechanic',
    description = 'Repair vehicles and maintain automobile systems',
    icon = 'fas fa-wrench',
    salary = '$1200/hour',
    recommended = false,
    requiredLevel = 5,
    location = {
        coords = vector3(150.0, -200.0, 50.0),
        blip = { sprite = 446, color = 3, scale = 0.9, label = 'Mechanic Job' },
    },
    tutorial = {
        { icon = 'fas fa-map-marker-alt', text = 'Drive to the marked location' },
        { icon = 'fas fa-wrench', text = 'Start working on vehicles' },
        { icon = 'fas fa-coins', text = 'Complete repairs to earn money' },
    },
}
```

## 🎮 Usage

### For Players

1. **Visit the Job Center** - Navigate to the marked location on your map
2. **Interact with NPC** - Use your target system (default: right-click) to interact
3. **Open Menu** - The job selection menu will appear
4. **Select a Job** - Click on any available job to accept it
5. **Check Progress** - View your current level and work time progress
6. **Complete Work** - Work in your assigned job to earn experience
7. **Level Up** - Automatically receive notifications when you level up

### For Administrators

**Checking Player Job Data:**
```lua
-- In console or through a debug script
local player = exports.qbx_core:GetPlayer(source)
local workMinutes = player.PlayerData.metadata.jc_workminutes or 0
local level = math.floor(workMinutes / 60) + 1
```

**Resetting Player Progress:**
```lua
player.Functions.SetMetaData('jc_workminutes', 0)
```

## 📈 Job System

### Current Available Jobs

#### 1. Electrician
- **Description**: Install and maintain electrical systems in buildings
- **Salary**: $1,000/hour
- **Required Level**: 1 (starter job)
- **Location**: Vector3(152.16, -3210.88, 5.91)
- **Recommended**: Yes

#### 2. Garbage Collector
- **Description**: Collect garbage and manage waste recycling
- **Salary**: $1,000/hour  
- **Required Level**: 1 (starter job)
- **Location**: Vector3(152.16, -3210.88, 5.91)
- **Recommended**: Yes

## 📊 Level Progression

### How Leveling Works

- **Starting Level**: 1
- **Progression Formula**: `Level = floor(Total Work Minutes / 60) + 1`
- **Default Rate**: 1 level per 60 minutes of work
- **Tracking**: Automatic server-side tracking every 60 seconds

### Level Requirements for Jobs

Jobs can have minimum level requirements via the `requiredLevel` configuration. Players cannot access jobs above their current level.

### Player Notifications

- Players receive a notification when they level up
- Progress bar shows minutes towards next level in the UI
- Multiple players can see job count statistics in real-time

## 📁 Project Structure

```
ndrp_jobcenter/
├── fxmanifest.lua      # Resource manifest & dependencies
├── config.lua          # Configuration file (customize here)
├── README.md           # This file
├── ui.html             # NUI interface
├── client/
│   └── main.lua        # Client-side logic (NPC spawning, menu interaction)
└── server/
    └── main.lua        # Server-side logic (level progression, job assignment)
```

### File Descriptions

| File | Purpose |
|---|---|
| `fxmanifest.lua` | FiveM resource manifest defining version, dependencies, and file structure |
| `config.lua` | All customizable settings (jobs, NPC location, level rates, etc.) |
| `client/main.lua` | Handles NPC spawning, NUI menu display, and client-side events |
| `server/main.lua` | Server-side callbacks, level tracking, and job data management |
| `ui.html` | Beautiful NUI interface with interactive job selection |

## 🔄 How It Works

### Client-Side Flow

1. Player targets the Job Center NPC via ox_target
2. `openJobMenu()` is called, requesting job data from server
3. Server returns player data and current job info
4. NUI menu is displayed with available jobs
5. Player selects a job and makes a request to server
6. Menu closes and player is assigned to job

### Server-Side Flow

1. Work time increments every 60 seconds for employed players
2. `jc_workminutes` metadata increases by 1 per minute
3. Level is calculated: `floor(workMinutes / 60) + 1`
4. When level increases, client receives `levelUp` event
5. Player notification is triggered
6. Job data is cached and sent to clients on request

## 🛠️ Technical Details

### Callbacks

- **`ndrp_jobcenter:getJobData`** - Returns player job data, level, and active job counts
- **`ndrp_jobcenter:setJob`** - Assigns a job to player (validates level requirements)

### Events

- **`ndrp_jobcenter:levelUp`** - Client event triggered when player levels up

### Metadata Keys

- **`jc_workminutes`** - Total work minutes accumulated by player

## 📝 License

This project was created by **thedshadow**. Keep credited when using or modifying.

## 🤝 Support

For issues, suggestions, or modifications needed:
1. Check the configuration file for customization options
2. Ensure all dependencies are properly installed
3. Check server console for error messages
4. Verify player is using ox_target correctly

## 📌 Version History

- **v1.0.0** (Current) - Initial release with Electrician and Garbage Collector jobs, complete level progression system
