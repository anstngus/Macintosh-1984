# 💾 Macintosh 1984

![Macintosh 1984 Banner](https://img.shields.io/badge/macOS-10.7%2B-lightgrey?style=for-the-badge&logo=apple)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

**Macintosh 1984** is a lightweight, nostalgic utility studio that brings the iconic 1984 Mac System 1.0 desktop environment back to life. Built natively for macOS using Objective-C, WebKit, and IOKit, it serves as a distraction-free sanctuary equipped with classic Desk Accessories (DAs), real-time hardware telemetry, and focus tools. 

Specially optimized to run flawlessly on vintage machines like the 2009 MacBook (A1181) all the way up to modern Intel Macs.

## ✨ Features

### 🖥️ 4 Built-in Desk Accessories (DAs)
1. **Desk Clock & D-Day Tracker:** A master flip clock with a built-in D-Day calculator for tracking important deadlines or exams.
2. **System Telemetry:** Real-time hardware monitoring using Mach Kernel and AppleSMC. Displays CPU Load, RAM Usage, Battery Status, CPU Temperature, Fan RPM, and Free Disk Space.
3. **Pomodoro Chronometer:** A dedicated focus timer featuring preset intervals (50m Focus, 25m Pomodoro, 10m Break) and daily session tracking to keep your workflow in check.
4. **8-Page Note Pad:** An iconic 1984-style "dog-ear" scratchpad for jotting down quick thoughts, complete with page-flipping mechanics.

### 🎨 4 Authentic Retro Themes
Switch instantly between beautifully crafted CSS themes directly from the top menu bar:
- **1984 B&W:** The original crisp, 1-bit monochrome experience.
- **Amber CRT:** A warm, high-contrast amber phosphor terminal glow.
- **Green CRT:** The classic Apple II green phosphor aesthetic.
- **Braun Edition:** Inspired by Dieter Rams' industrial design (Warm beige & orange accents).

### 🔊 Procedural 1-Bit Audio Engine
No external audio files are used. The app dynamically synthesizes retro sound waves in real-time using Objective-C and C math functions (`sin()`, `exp()`):
- **Mouse Clicks:** 12ms crisp 1-bit pulses.
- **System Beeps:** 90ms square-wave (880Hz) alerts.
- **Startup Chime:** A 550ms F# Major chord arpeggio that plays on launch and when a Pomodoro session completes.

## 🛠️ Installation

### Option 1: Quick Install (Recommended)
1. Go to the [Releases](../../releases) page.
2. Download the latest `Macintosh1984.dmg`.
3. Open the `.dmg` and drag the **Macintosh 1984** app to your `/Applications` folder.

### Option 2: Build from Source
If you want to compile the app yourself (no Xcode required, just the macOS Command Line Tools):
1. Download the `build_macintosh1984.py` script.
2. Run it in your terminal:
   ```bash
   python3 build_macintosh1984.py
   ```
3. The script will automatically compile the Objective-C backend, bundle the HTML/CSS frontend, generate the skeuomorphic app icon, and create a `.dmg` on your Desktop.

## 🏗️ Architecture
Macintosh 1984 uses a Hybrid App Architecture:
- **Backend:** Objective-C / Cocoa handles the window management, IOKit/AppleSMC hardware polling, and procedural audio synthesis.
- **Frontend:** HTML5, CSS3, and Vanilla JavaScript handle the 1984 skeuomorphic UI rendering.
- **Bridge:** `WebScriptObject` bridges the native hardware data and audio triggers directly into the JavaScript environment with near-zero latency.

## 📝 License
This project is licensed under the MIT License. See the `LICENSE` file for details.

---
*Stay focused. Keep it simple. Think different.*