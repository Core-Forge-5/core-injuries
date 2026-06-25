# core-injuries  — Premium FiveM Injury System

> **Professional-grade injury tier system for FiveM roleplay servers** — featuring crutches, wheelchairs, arm slings, knockout mechanics, EMS integration, and full persistence. Built for QBox, QBCore, ESX, and Standalone frameworks.

[![FiveM Ready](https://img.shields.io/badge/FiveM-3095%2B-blue?style=for-the-badge&logo=fivem)](https://fivem.net/)
[![ox_lib](https://img.shields.io/badge/ox_lib-v3.28.0%2B-orange?style=for-the-badge)](https://overextended.github.io/ox_lib/)
[![ox_inventory](https://img.shields.io/badge/ox_inventory-required-green?style=for-the-badge)](https://overextended.github.io/ox_inventory/)
[![Framework](https://img.shields.io/badge/Framework-QBox%20%7C%20QBCore%20%7C%20ESX%20%7C%20Standalone-purple?style=for-the-badge)](#framework-support)
[![Performance](https://img.shields.io/badge/Client%20Budget-0.21ms%2Fframe-brightgreen?style=for-the-badge)](#performance--optimization)
[![License](https://img.shields.io/badge/License-Commercial-red?style=for-the-badge)](#license--support)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Injury Tiers](#-injury-tiers)
- [Framework Support](#-framework-support)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [ox_inventory Items](#-ox_inventory-items-setup)
- [Database Setup](#-database-setup-persistence)
- [Commands](#-commands)
- [Exports API](#-exports-api)
- [Performance & Optimization](#-performance--optimization)
- [v1 Migration Guide](#-v1-migration-guide)
- [Troubleshooting](#-troubleshooting--faq)
- [License & Support](#-license--support)

---

## 🎯 Overview

**core-injuries ** is a complete rewrite of the original injury system, designed from the ground up for modern FiveM development. It provides a **tier-based injury system** with 5 distinct injury levels, each with unique visual props, movement animations, and gameplay penalties.

### Why Choose core-injuries ?

| Feature | Benefit |
|---------|---------|
| **4 Injury Tiers** | Minor → Moderate → Severe → Wheelchair |
| **Real-time Sync** | Statebag-based replication — zero latency, no manual triggers |
| **Tier Transitions** | Seamless upgrade/downgrade without relogging |
| **EMS Roleplay Tools** | Proximity context menu, custom durations, audit trail |
| **Knockout System** | Melee + weapon damage triggers with configurable thresholds |
| **Full Persistence** | oxmysql integration — injuries survive server restarts |
| **Framework Agnostic** | Auto-detects QBox, QBCore, ESX, or Standalone (Ace) |
| **Performance First** | ≤0.21ms/frame client budget with adaptive sleep threads |
| **v1 Compatible** | Drop-in replacement — legacy commands/exports preserved |

---

## ✨ Key Features

### 🏥 Injury Tier System (4 Tiers)
Each tier is fully configurable via `config/injury.lua`:
- **Clipset/Animation** — Unique walking style per tier
- **Prop Attachment** — Crutch, or any prop you have. Like Arm Sling for example
- **Movement Penalties** — Sprint/jump disabled, walk speed reduced
- **Duration Bounds** — Min/Max/Default minutes per tier
- **Self-Removal Toggle** — Allow players to remove minor injuries by using an item

### 🚑 EMS Integration
- **Proximity Context Menu** — Approach injured players (3.0m default) to open menu
- **Visual Tier Selector** — Click to apply Minor/Moderate/Severe/or custom tier
- **Live Status Display** — See target's current tier + remaining time instantly
- **Custom Duration Input** — EMS can set exact minutes (clamped to tier bounds)
- **Commands** — `/emsinjury`, `/emsheal`, `/emsmenu` with permission checks

### 🥊 Knockout Mechanics
- **Melee Threshold** — Health-based knockout from fist fights
- **Weapon Threshold** — Damage-based knockout from gunshots
- **Screen Effects** — Blur, vignette, color grading during knockout
- **Ragdoll Physics** — Realistic collapse with health regeneration

### 💾 Persistence Layer (Optional)
- **oxmysql Integration** — Injuries persist across server restarts
- **Auto Table Creation** — Schema created on first run
- **Cleanup Jobs** — Expired injuries purged automatically
- **Audit Trail** — Tracks clearance reason: `ems_cleared`, `expired`, `self_removed`, `crutch_used`

### 🔧 Framework Support

core-injuries  **auto-detects** your framework on resource start. No manual configuration required.
Core logic **never touches framework code**. All framework interactions route through the encrypted bridge layer:
- **QBox** — Native `qbx_core` exports
- **QBCore** — `qb-core` shared object
- **ESX** — `es_extended` shared object
- **Standalone** — Ace permission fallbacks

---

## 🏥 Injury Tiers

| Tier | Label | Prop | Clipset | Walk Speed | Sprint | Jump | Vehicle | Duration (min) | Item Required |
|------|-------|------|---------|------------|--------|------|---------|----------------|---------------|
| **minor** | Minor Injury | Crutch | `move_lester_CaneUp` | 0.8x | ❌ | ❌ | ✅ | 5–30 (default 15) | `crutch` |
| **moderate** | Moderate Injury | Crutch | `move_m@injured` | 0.5x | ❌ | ❌ | ✅ | 15–60 (default 30) | `crutch` |
| **severe** | Severe Injury | Crutch | `move_m@drunk@verydrunk` | 0.3x | ❌ | ❌ | ✅ | 30–120 (default 60) | `crutch` |
| **wheelchair** | Wheelchair Bound | Wheelchair | `wheelchair bound` |  | ❌ | ❌ | ❌ | 60–240 (default 120) |  |

> **All values editable in `config/injury.lua`** — add custom tiers, change clipsets, adjust penalties.

---

### Custom Job Names
Override EMS job name in `config/main.lua`:
```lua
Config.Framework = {
    ForceFramework = nil,  -- "qbox" | "qbcore" | "esx" | "standalone" (nil = auto)
    EMSJobName = "ambulance",  -- Your EMS job name
    AdminPermission = "admin"  -- Ace permission for admin commands
}
```

---

## 📦 Requirements

| Dependency | Minimum Version | Purpose |
|------------|-----------------|---------|
| **FiveM Server Artifacts** | 3095+ (June 2024) | Statebags, modern natives |
| **ox_lib** | v3.28.0+ | Notifications, context menus, callbacks, commands |
| **ox_inventory** | Latest | Crutch/wheelchair/armsling usable items |
| **oxmysql** | Latest | **Optional** — only for persistence feature |

> ⚠️ **oxmysql is optional** — disable `Config.Persistence.Enabled = false` if not using.

---

## 🚀 Installation

### 1. Download & Place
```bash
# Place in your resources directory
/resources/[core]/core-injuries/
```

### 2. Server.cfg Load Order
```cfg
ensure ox_lib
ensure ox_inventory
ensure oxmysql          # Only if using persistence
ensure core-injuries
```

### 3. Configure (Required)
Edit files in `config/` — all are **unescrow'd and fully editable**:
```bash
config/
├── ems.lua             # EMS commands, menu settings
├── knockout.lua        # Knockout thresholds
├── main.lua       # Main toggles | Job names, framework override
├── persistence.lua     # Database settings
└── injury.lua           # Injury tier definitions | Prop models, bones, offsets

```

### 4. Add ox_inventory Items
Add to your `ox_inventory/data/items.lua`:
```lua
['crutch'] = {
    label = 'Crutch',
    weight = 1500,
    stack = false,
    close = true,
    description = 'A medical crutch for walking assistance'
},
```

### 5. Database (If Persistence Enabled)
```sql
-- Run database/schema.sql manually, or enable AutoCreateTable in config/persistence.
-- Then restart once if using Auto Create
-- Table: core_crutches_injuries
```

### 6. Start Server
```bash
# Check console for:
# [core-injuries] Framework bridge: QBox (or QBCore/ESX/Standalone)
# [core-injuries] Version check: Latest version .x.x
```

---

## ⚙️ Configuration

All configuration files are in `config/` and **unescrow'd** — modify freely without touching encrypted core logic.

### config/main.lua — Main Toggles
```lua
Config.Enabled = true
Config.Debug = false
Config.DefaultTier = "minor"

Config.Features = {
    InjuryTiers = true,      -- Enable tier system
    Knockout = true,         -- Enable knockout mechanics
    Persistence = false,     -- Requires oxmysql
    EMSMenu = true,          -- Enable EMS context menu
    Commands = true,         -- Enable all commands
    LegacyCompat = true,     -- v1 event/command compatibility
    SkinReloadWatch = true,  -- Re-apply props on clothing change
    PropValidation = true    -- Periodic prop re-attachment check
}
```

### config/main.lua — Framework Overrides
```lua
Config.Framework = {
    ForceFramework = nil,     -- nil=auto, or "qbox"/"qbcore"/"esx"/"standalone"
    EMSJobName = "ambulance",
    AdminPermission = "admin"
}
```

### config/main.lua — EMS Commands & Menu
```lua
Config.EMS = {
    Commands = {
        ApplyInjury = "emsinjury",
        Heal = "emsheal",
        Menu = "emsmenu"
    },
    ContextMenu = {
        Enabled = true,
        Title = "EMS Injury Management",
        Icon = "fa-solid fa-user-injured"
    },
    DurationBounds = {
        minor = { min = 5, max = 30 },
        moderate = { min = 15, max = 60 },
        severe = { min = 30, max = 120 },
        wheelchair = { min = 60, max = 240 },
        armsling = { min = 10, max = 60 }
    },
    AllowCustomDuration = true,
    InteractionRange = 3.0
}
```

### config/injury.lua — Define Tiers
```lua
Config.Tiers = {
    minor = {
        Label = "Minor Injury",
        ClipSet = "move_lester_CaneUp",
        Prop = "crutch",
        RequiredItem = "crutch",
        MovementPenalty = { Sprint = true, Jump = true, WalkSpeed = 0.8 },
        MinDuration = 5, MaxDuration = 15, DefaultDuration = 5,
        CanSelfRemove = true
    },
    -- moderate, severe, wheelchair, armsling...
}
```

### config/injury.lua — Prop Definitions
```lua
Config.Props = {
    crutch = {
        Model = `v_med_crutch01`,
        Bone = "SKEL_R_Hand",
        Offsets = { x = 1.18, y = -0.36, z = -0.20, rotX = -20.0, rotY = -87.0, rotZ = -20.0 },
        Collision = false, Scale = 1.0
    }
}
```

### config/knockout.lua — Knockout Settings
```lua
Config.Knockout = {
    Enabled = true,
    MeleeEnabled = true,
    MeleeHealthThreshold = 155,
    WeaponEnabled = true,
    WeaponDamageThreshold = 35,
    Duration = 5500,          -- ms unconscious
    Regeneration = 2,         -- HP per tick
    RegenInterval = 450,      -- ms per tick
    Cooldown = 30000,         -- ms before re-knockout
    PostKnockoutTier = "minor",
    PostKnockoutDuration = nil  -- nil = tier default
}
```

### config/persistence.lua — Database
```lua
Config.Persistence = {
    Enabled = false,
    TableName = "core_crutches_injuries",
    AutoCreateTable = true,
    LoadOnStart = true,
    SyncInterval = 30000,     -- ms between DB flushes
    CleanupInterval = 300000  -- ms between expired row cleanup
}
```

---

## 🎒 ox_inventory Items Setup

The system requires **usable items** in ox_inventory. Each tier's `RequiredItem` must exist in your items.lua.

### Required Items
| Item Name | Used By Tiers | Type | Weight |
|-----------|---------------|------|--------|
| `crutch` | minor, moderate, severe | Usable | 1000 |

### Item Usage Flow
1. Player has active injury requiring specific item
2. Player uses item from inventory (right-click → Use)
3. Client calls `exports['core-injuries']:UseCrutch()`
4. Server validates: injury active + item count ≥ 1 + tier matches item
5. Server removes 1 item, clears injury, syncs to client

> 💡 **Tip**: Configure `CanSelfRemove = false` on severe/wheelchair tiers to force EMS interaction.

---

## 🗄️ Database Setup (Persistence)

### Auto-Create (Recommended)
Enable in `config/persistence.lua`:
```lua
Config.Persistence = {
    Enabled = true,
    AutoCreateTable = true,  -- Creates table on resource start
    -- ...
}
```

### Manual Schema
Run `database/schema.sql`:
```sql
CREATE TABLE `core_crutches_injuries` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(60) NOT NULL,
    `tier` VARCHAR(32) NOT NULL,
    `expiry` BIGINT NOT NULL,
    `source` VARCHAR(16) NOT NULL,
    `custom_duration` BOOLEAN DEFAULT FALSE,
    `cleared_by` VARCHAR(32) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_player` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Persistence Behavior
| Event | Database Action |
|-------|-----------------|
| Injury Applied | Saved to DB |
| Injury Cleared | Deleted from DB |
| Server Start |  Restores active injuries |

---

## 💬 Commands

### EMS Commands (Requires EMS job)
| Command | Syntax | Description |
|---------|--------|-------------|
| `/emsinjury` | `/emsinjury <id> <tier> [minutes]` | Apply injury to player |
| `/emsheal` | `/emsheal <id>` | Clear player's injury |
| `/emsmenu` | `/emsmenu` | Open proximity context menu |

### Admin (Requires Admin permission)
| Command | Syntax | Description |
|---------|--------|-------------|
| `/admininjury` | `/admininjury <id> <tier> [minutes]` | Apply injury (bypasses EMS check) |
| `/adminheal` | `/adminheal <id>` | Clear injury (bypasses EMS check) |
| `/knockout` | `/knockout <id> [duration]` | Force knockout on player |

### Player Commands
| Command | Syntax | Description |
|---------|--------|-------------|
| `/injury` | `/injury` | Check your injury status & time remaining |
| `/crutchtime` | `/crutchtime` | Legacy v1 — check remaining time |

### Legacy v1 Commands (Compatibility)
| Command | Syntax | Notes |
|---------|--------|-------|
| `/applycrutch` | `/applycrutch [id] [minutes]` | Applies "minor" tier |
| `/crutchtime` | `/crutchtime` | Shows remaining time |

---

## 🔌 Exports API

### Client Exports (Lua)
```lua
-- Check if player has ANY injury tier active
local isInjured = exports['core-injuries']:IsInjured()
-- Returns: boolean

-- Get current injury tier name
local tier = exports['core-injuries']:GetInjuryTier()
-- Returns: string|nil ("minor", "moderate", "severe", "wheelchair", "armsling")

-- Get remaining time in seconds
local seconds = exports['core-injuries']:GetRemainingTime()
-- Returns: number|nil

-- Get injury source ("ems", "admin", "knockout", "command")
local source = exports['core-injuries']:GetInjurySource()
-- Returns: string|nil

-- Set injury VISUALLY ONLY (no server sync) — for cutscenes, scenes
local success = exports['core-injuries']:SetInjuryTier("moderate")
-- Returns: boolean

-- Clear injury VISUALLY ONLY (no server sync)
local success = exports['core-injuries']:ClearInjury()
-- Returns: boolean

-- Attempt to use crutch item from inventory (triggers server validation)
local success = exports['core-injuries']:UseCrutch()
-- Returns: boolean

-- Force re-apply visuals (prop + clipset) — useful after clothing change
exports['core-injuries']:ReapplyInjuryVisuals()
-- Returns: void
```

### Server Exports (Lua)
```lua
-- Apply injury to player (REPLACES existing injury — tier transition)
-- @param src number - Player server ID
-- @param tier string - Tier key from Config.Tiers
-- @param minutes number|nil - Duration in minutes (nil = tier default, clamped to min/max)
-- @return boolean, string - success, errorMessage
local success, err = exports['core-injuries']:ApplyInjury(src, "moderate", 30)

-- Clear injury from player
-- @param src number - Player server ID
-- @param clearedBy string|nil - "ems_cleared", "expired", "self_removed", "crutch_used"
-- @return boolean, string - success, errorMessage
local success, err = exports['core-injuries']:ClearInjury(src, "ems_cleared")

-- Get full injury data for player
-- @param src number - Player server ID
-- @return table|nil - { tier, expiry, source, customDuration, clearedBy } or nil
local injury = exports['core-injuries']:GetInjury(src)

-- Check if player has active injury
-- @param src number - Player server ID
-- @return boolean
local isInjured = exports['core-injuries']:IsInjured(src)

-- Get remaining time in seconds
-- @param src number - Player server ID
-- @return number|nil - Seconds remaining or nil if not injured
local seconds = exports['core-injuries']:GetRemainingTime(src)
```

---

## ⚡ Performance & Optimization

core-injuries  is built for **production servers** with strict performance budgets.

### Client Thread Budgets
| Thread | Idle Sleep | Active Sleep | Idle Budget | Active Budget |
|--------|------------|--------------|-------------|---------------|
| Injury Enforcement | 2000ms | 500ms | ≤0.02ms | ≤0.05ms |
| Control Disable | 1000ms | 0ms | ≤0.01ms | ≤0.08ms |
| Knockout Monitor | 500ms | 50ms | ≤0.02ms | ≤0.05ms |
| Skin Reload Watch | 5000ms | 200ms | ≤0.01ms | ≤0.03ms |
| Prop Validation | 5000ms | 1000ms | ≤0.01ms | ≤0.02ms |

**Total Active: ≤0.21ms/frame** — well under 1ms frame budget.

### Server Thread Budgets
| Thread | Interval | Budget |
|--------|----------|--------|
| Injury Expiry Cleanup | 10000ms | ≤0.05ms |
| Persistence Flush | 30000ms | ≤0.10ms |
| Framework Bridge Calls | Per-call | ≤0.02ms |

### Optimization Features
- **Adaptive Sleep** — Threads sleep 2s when idle, 500ms when active
- **Statebag Sync** — Zero bandwidth when no changes
- **Model/Anim Caching** — Loaded once, reused across tiers
- **Early Returns** — Guard clauses prevent unnecessary work
- **Optional Features** — Disable knockout, persistence, EMS menu if unused

### Monitoring Performance
```lua
-- In-game console (client)
/resmon  -- Check "core-injuries" CPU time

-- Or add to any client thread for custom profiling
local start = GetGameTimer()
-- ... work ...
print(('core-injuries: %sms'):format(GetGameTimer() - start))
```


---

## 🔄 v1 Migration Guide

Upgrading from core-injuries v1? **Drop-in compatible** — no code changes required.

### Preserved v1 Exports
| Export | v1 Behavior |  Behavior |
|--------|-------------|-------------|
| `IsInjured()` | `boolean` — crutch active | `boolean` — **any** injury tier active |
| `UseCrutch()` | Removes crutch, notifies server | Same, validates tier allows crutch use |

### Preserved v1 Events (Deprecated but Functional)
| Event | v1 Payload |  Behavior |
|-------|------------|-------------|
| `core-injuries:client:setInjured` | `true` | Applies "minor" tier with default duration |
| `core-injuries:client:setInjured` | `false` | Clears injury |

### Preserved v1 Commands
| Command |  Mapping |
|---------|------------|
| `/applycrutch [id] [minutes]` | Applies "minor" tier |
| `/crutchtime` | Shows remaining time |

### Breaking Changes (Config)
| v1 Config |  Replacement |
|-----------|----------------|
| `Config.crutchModel` | `Config.Tiers.minor.Prop` → `Config.Props.crutch.Model` |
| `Config.clipSet` | `Config.Tiers.minor.ClipSet` |
| `Config.Knockout` (flat) | `config/knockout.lua` (expanded) |
| `Config.Persistence` (flat) | `config/persistence.lua` |
| Hardcoded `'ambulance'` job | `Config.Framework.EMSJobName` |

### Migration Steps
1. **Backup** your v1 `config.lua`
2. **Replace** resource folder with 
3. **Migrate** values from old `config.lua` to new `config/*.lua` files
4. **Test** — v1 commands/exports work automatically

---

## 🛠️ Troubleshooting & FAQ

### Common Issues

#### "Resource failed to start — ox_lib not found"
```cfg
# Ensure load order in server.cfg:
ensure ox_lib
ensure ox_inventory
ensure oxmysql
ensure core-injuries
```

#### "Injury not applying / props not showing"
- Verify `Config.Features.InjuryTiers = true`
- Check `Config.Tiers[tier]` exists with valid `ClipSet` and `Prop`
- Ensure `Config.Props[propKey].Model` is valid (check console for model load errors)
- Verify player ped exists: `DoesEntityExist(PlayerPedId())`

#### "EMS menu not opening"
- Verify `Config.Features.EMSMenu = true`
- Check `Config.Framework.EMSJobName` matches your EMS job exactly
- Ensure `ox_lib` context menu dependency loaded
- Player must be within `Config.EMS.InteractionRange` (default 3.0m) of target

#### "Knockout not triggering"
- Verify `Config.Knockout.Enabled = true`
- Check `Config.Knockout.MeleeEnabled` / `WeaponEnabled`
- Adjust `MeleeHealthThreshold` (default 155) or `WeaponDamageThreshold` (default 35)
- Check `Config.Knockout.Cooldown` (default 30s) — prevent spam

#### "Persistence not working"
- Verify `Config.Persistence.Enabled = true`
- Ensure `oxmysql` is started **before** core-injuries
- Check database connection in `oxmysql` config
- Run `database/schema.sql` manually if `AutoCreateTable = false`
- Check server console for `[core-injuries] [Persistence]` logs

#### "Framework not detected"
- Set `Config.Framework.ForceFramework = "qbox"` (or qbcore/esx/standalone)
- Verify framework resource name matches: `qbx_core`, `qb-core`, `es_extended`
- Check console for `[core-injuries] Framework bridge: <name>`

#### "Performance issues / lag"
- Disable unused features in `Config.Features`
- Increase thread sleep times in config (not recommended — edit encrypted files)
- Check `resmon` for core-injuries CPU usage
- Ensure no other resources conflict (multiple injury systems)

### Debug Mode
Enable in `config/config.lua`:
```lua
Config.Debug = true
```
Shows detailed console logs for:
- Injury apply/clear events
- Statebag changes
- Prop creation/deletion
- Knockout triggers
- Database queries

---

## 📄 License & Support

### Commercial License
core-injuries  is a **paid asset** distributed via Tebex/CoreForge. Licensed per server instance.

### What's Included
- ✅ Encrypted core logic (bridge/, shared/, client/, server/)
- ✅ Unencrypted config/ folder (fully customizable)
- ✅ Database schema (database/schema.sql)
- ✅ Documentation (README.md, ARCHITECTURE.md, CONSTRAINTS.md, STYLE_GUIDE.md)
- ✅ v1 Compatibility layer
- ✅ Automatic updates via `lib.versionCheck`

### Support Channels
- **GitHub Issues**: https://github.com/Core-Forge-5/core-injuries/issues
- **Discord**: CoreForge Support Server (link in Tebex purchase)
- **Documentation**: This README + ARCHITECTURE.md + CONSTRAINTS.md

---

## 📈 SEO Keywords (For Discovery)

FiveM injury system, FiveM crutch script, FiveM wheelchair script, FiveM arm sling, FiveM EMS script, FiveM knockout system, FiveM medical roleplay, FiveM QBCore medical, FiveM ESX injury, FiveM QBox crutches, FiveM ox_lib resources, FiveM ox_inventory items, FiveM persistence oxmysql, FiveM statebag synchronization, FiveM roleplay scripts, FiveM server resources, CoreForge FiveM assets

---

## 📝 Changelog

### .0.0 (Current)
- Complete rewrite with tier-based injury system
- 4 injury tiers: Minor, Moderate, Severe, Wheelchair
- Statebag-based real-time synchronization
- EMS proximity context menu with live status
- Knockout system: melee + weapon thresholds
- oxmysql persistence with audit trail
- Framework bridge: QBox, QBCore, ESX, Standalone
- v1 compatibility layer
- Performance optimized: ≤0.21ms/frame

### v1.x (Legacy)
- Single crutch tier
- Basic apply/remove commands
- No persistence, no EMS menu, no knockout

---

**core-injuries ** — Built by **CoreForge** for the FiveM community.  
🌐 Repository: https://github.com/Core-Forge-5/core-injuries  
📦 Purchase: Tebex / CoreForge Store