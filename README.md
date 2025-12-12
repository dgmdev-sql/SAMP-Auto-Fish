# Auto Fish Mod for GTA SA:MP

**Author:** Ryu S. Yamaguchi

**Discord:** ryu.sql

---

# Description

A simple Lua mod for **GTA San Andreas: Multiplayer** (SA:MP) using **MoonLoader**.

It automatically fishes at Santa Maria Pier or in any boat in the ocean. It keeps fish above a set weight, and it automatically uses `/throwback` to release low-weight fish.

---

## Features

- Automatically `/fish`.
- Checks fish weight after each catch.  
- Automatically throws back fish below the configured minimum weight using `/throwback`.
- Toggle auto-fishing with `/afish`.

---

## Installation

1. Ensure **MoonLoader** is installed in your SA:MP client.  
2. Place `auto_fish.lua` in your `MoonLoader` folder.  
3. Start GTA SA:MP.
4. Type `/afish` in chat to toggle auto-fishing.

---

## Configuration

You can edit the following values at the top of `auto_fish.lua`:

```lua
local minWeight = 20     -- Minimum fish weight to keep
local castDelay = 1000   -- Delay between /fish casts in milliseconds
