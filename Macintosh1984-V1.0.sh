setopt NO_BANG_HIST
cat << 'PYEOF' > /tmp/build_macintosh1984.py
import os, shutil, subprocess, plistlib

desktop = os.path.expanduser("~/Desktop")
stage_dir = os.path.join(desktop, "Macintosh1984_Stage")
app_path = os.path.join(stage_dir, "Macintosh1984.app")
dmg_path = os.path.join(desktop, "Macintosh1984.dmg")
installed_app = "/Applications/Macintosh1984.app"

subprocess.run(["pkill", "-9", "-f", "Macintosh1984"], check=False)
for p in [stage_dir, dmg_path]:
    if os.path.exists(p):
        if os.path.isdir(p) and not os.path.islink(p):
            shutil.rmtree(p)
        else:
            os.remove(p)

contents_dir = os.path.join(app_path, "Contents")
macos_dir = os.path.join(contents_dir, "MacOS")
res_dir = os.path.join(contents_dir, "Resources")
os.makedirs(macos_dir, exist_ok=True)
os.makedirs(res_dir, exist_ok=True)

# 1. 1984 System 1.0 UI + 4대 CRT/Braun 테마 + 데스크 액세서리 HTML/CSS/JS 엔진
html_content = r'''<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Macintosh 1984</title>
<style>
  * {
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    -webkit-user-select: none;
    user-select: none;
  }

  :root {
    --fg: #000000;
    --bg: #ffffff;
    --desk-a: #888888;
    --desk-b: #ffffff;
    --accent: #000000;
    --win-shadow: #000000;
  }

  /* Theme 1: 1984 Classic 1-Bit B&W */
  body.theme-bw {
    --fg: #111111;
    --bg: #fbfbf9;
    --desk-a: #777777;
    --desk-b: #e5e5e0;
    --accent: #111111;
    --win-shadow: #000000;
  }

  /* Theme 2: 1984 Amber Phosphor CRT */
  body.theme-amber {
    --fg: #ffb000;
    --bg: #181000;
    --desk-a: #382400;
    --desk-b: #120b00;
    --accent: #ffcc33;
    --win-shadow: #000000;
  }

  /* Theme 3: Apple II Green Phosphor CRT */
  body.theme-green {
    --fg: #33ff66;
    --bg: #051608;
    --desk-a: #0f3818;
    --desk-b: #041006;
    --accent: #66ff99;
    --win-shadow: #000000;
  }

  /* Theme 4: Dieter Rams Braun Industrial */
  body.theme-braun {
    --fg: #222220;
    --bg: #f4f2ec;
    --desk-a: #d4d0c5;
    --desk-b: #dfdcd2;
    --accent: #ea4c1d;
    --win-shadow: #88847a;
  }

  html, body {
    width: 100%;
    height: 100%;
    overflow: hidden;
    font-family: "Chicago", "Geneva", "Monaco", "Courier New", "Apple SD Gothic Neo", monospace;
    font-size: 13px;
    color: var(--fg);
    background-color: var(--desk-a);
    background-image:
      -webkit-linear-gradient(45deg, var(--desk-b) 25%, transparent 25%, transparent 75%, var(--desk-b) 75%, var(--desk-b)),
      -webkit-linear-gradient(45deg, var(--desk-b) 25%, transparent 25%, transparent 75%, var(--desk-b) 75%, var(--desk-b));
    background-position: 0 0, 2px 2px;
    background-size: 4px 4px;
  }

  input, textarea {
    -webkit-user-select: text;
    user-select: text;
    font-family: inherit;
    color: var(--fg);
    background: var(--bg);
  }

  /* 1984 System 1.0 Top Menu Bar */
  .mac-menubar {
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 28px;
    background: var(--bg);
    border-bottom: 2px solid var(--fg);
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    padding: 0 12px;
    z-index: 1000;
    font-weight: 700;
  }

  .menu-left, .menu-right {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
  }

  .menu-item {
    padding: 3px 10px;
    cursor: pointer;
    border-radius: 2px;
    font-size: 13px;
  }
  .menu-item:hover, .menu-item.active-menu {
    background: var(--fg);
    color: var(--bg);
  }
  .menu-apple {
    font-size: 15px;
    padding: 2px 10px;
  }

  /* Desktop Workspace Grid */
  .mac-desktop {
    position: absolute;
    top: 28px; bottom: 0; left: 0; right: 0;
    padding: 16px;
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-flex-direction: column;
    flex-direction: column;
  }

  .desktop-row {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    margin-bottom: 16px;
    min-height: 0;
  }
  .desktop-row:last-child {
    margin-bottom: 0;
  }

  /* Classic System 1.0 Window Chrome */
  .mac-window {
    background: var(--bg);
    border: 2px solid var(--fg);
    box-shadow: 4px 4px 0px var(--win-shadow);
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-flex-direction: column;
    flex-direction: column;
    margin-right: 16px;
    position: relative;
    overflow: hidden;
  }
  .mac-window:last-child {
    margin-right: 0;
  }
  .win-flex-6 { -webkit-box-flex: 6; -webkit-flex: 6; flex: 6; }
  .win-flex-5 { -webkit-box-flex: 5; -webkit-flex: 5; flex: 5; }

  /* Classic 6-Line Pinstripe Title Bar */
  .mac-titlebar {
    height: 26px;
    min-height: 26px;
    border-bottom: 2px solid var(--fg);
    position: relative;
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    justify-content: center;
    background-image: -webkit-repeating-linear-gradient(
      to bottom,
      var(--bg) 0px,
      var(--bg) 2px,
      var(--fg) 2px,
      var(--fg) 3px
    );
    background-size: 100% 18px;
    background-repeat: no-repeat;
    background-position: center;
  }

  .mac-close-box {
    position: absolute;
    left: 8px;
    width: 13px;
    height: 13px;
    background: var(--bg);
    border: 1.5px solid var(--fg);
    box-shadow: 0 0 0 3px var(--bg);
    cursor: pointer;
  }
  .mac-close-box:active {
    background: var(--fg);
  }

  .mac-title-text {
    background: var(--bg);
    padding: 0 10px;
    font-weight: 800;
    font-size: 12.5px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }

  .mac-win-body {
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    padding: 14px 18px;
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-flex-direction: column;
    flex-direction: column;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    overflow-y: auto;
  }

  /* Classic 1984 Push Buttons */
  .mac-btn {
    background: var(--bg);
    color: var(--fg);
    border: 2px solid var(--fg);
    border-radius: 5px;
    padding: 5px 12px;
    font-family: inherit;
    font-size: 12px;
    font-weight: 800;
    cursor: pointer;
    box-shadow: 2px 2px 0px var(--fg);
    outline: none;
  }
  .mac-btn:hover {
    background: var(--fg);
    color: var(--bg);
  }
  .mac-btn:active, .mac-btn.active-btn {
    background: var(--accent);
    color: var(--bg);
    border-color: var(--accent);
    box-shadow: none;
    -webkit-transform: translate(1px, 1px);
    transform: translate(1px, 1px);
  }
  .mac-btn-default {
    box-shadow: 0 0 0 1px var(--bg), 0 0 0 4px var(--fg);
  }

  /* Window 1: Master Flip Clock & D-Day */
  .clock-hero {
    text-align: center;
    padding: 8px 0;
    border: 2px solid var(--fg);
    background: var(--bg);
    box-shadow: inset 2px 2px 0px rgba(0,0,0,0.12);
  }
  .clock-time {
    font-size: 56px;
    font-weight: 900;
    letter-spacing: 2px;
    line-height: 1.05;
    font-family: "Monaco", "Courier New", monospace;
  }
  .clock-ampm {
    font-size: 18px;
    vertical-align: super;
    margin-left: 4px;
    color: var(--accent);
  }
  .clock-date {
    font-size: 14px;
    font-weight: 700;
    margin-top: 4px;
    opacity: 0.85;
  }

  .dday-box {
    margin-top: 10px;
    border: 1.5px solid var(--fg);
    padding: 10px 12px;
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
  }
  .dday-badge {
    font-size: 24px;
    font-weight: 900;
    padding: 4px 12px;
    background: var(--accent);
    color: var(--bg);
    border-radius: 3px;
    min-width: 96px;
    text-align: center;
  }
  .dday-inputs {
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    margin-right: 12px;
  }
  .mac-input {
    width: 100%;
    border: none;
    border-bottom: 1.5px dashed var(--fg);
    padding: 2px 4px;
    font-size: 13px;
    font-weight: 700;
    outline: none;
    margin-bottom: 4px;
  }

  /* Window 2: Hardware Telemetry Gauges */
  .telemetry-row {
    margin-bottom: 8px;
  }
  .telemetry-row:last-child {
    margin-bottom: 0;
  }
  .telemetry-label-line {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    font-size: 12px;
    font-weight: 800;
    margin-bottom: 3px;
  }
  .mac-gauge-track {
    width: 100%;
    height: 15px;
    border: 1.5px solid var(--fg);
    padding: 2px;
    background: var(--bg);
  }
  .mac-gauge-fill {
    height: 100%;
    width: 20%;
    background-color: var(--accent);
    background-image: -webkit-repeating-linear-gradient(
      90deg,
      var(--accent) 0px,
      var(--accent) 4px,
      var(--bg) 4px,
      var(--bg) 6px
    );
    -webkit-transition: width 0.35s ease;
    transition: width 0.35s ease;
  }

  .hw-chip-grid {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    margin-top: 6px;
  }
  .hw-chip {
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    border: 1.5px solid var(--fg);
    padding: 6px 8px;
    margin-right: 8px;
    text-align: center;
  }
  .hw-chip:last-child { margin-right: 0; }
  .hw-chip-val { font-size: 16px; font-weight: 900; }
  .hw-chip-lbl { font-size: 10px; opacity: 0.8; margin-top: 1px; }

  /* Window 3: Pomodoro Focus Chronometer */
  .pomo-display-wrap {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    border: 2px solid var(--fg);
    padding: 10px 16px;
  }
  .pomo-digits {
    font-size: 44px;
    font-weight: 900;
    font-family: "Monaco", "Courier New", monospace;
    letter-spacing: 2px;
  }
  .pomo-status-tag {
    font-size: 12px;
    font-weight: 800;
    padding: 4px 8px;
    border: 1.5px solid var(--fg);
  }
  .pomo-btn-row {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    margin-top: 8px;
  }
  .pomo-btn-row .mac-btn {
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    margin-right: 6px;
    padding: 6px 4px;
  }
  .pomo-btn-row .mac-btn:last-child { margin-right: 0; }

  .pomo-stats-bar {
    margin-top: 8px;
    padding-top: 6px;
    border-top: 1.5px dotted var(--fg);
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    font-size: 11.5px;
    font-weight: 700;
  }

  /* Window 4: 1984 8-Page Dog-Ear Note Pad */
  .notepad-body {
    position: relative;
    padding-bottom: 34px !important;
  }
  .notepad-textarea {
    width: 100%;
    height: 100%;
    border: none;
    resize: none;
    outline: none;
    font-size: 13.5px;
    line-height: 1.65;
    background: transparent;
  }
  .notepad-footer {
    position: absolute;
    bottom: 0; left: 0; right: 0;
    height: 30px;
    border-top: 1.5px solid var(--fg);
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    padding: 0 12px 0 38px;
    font-size: 11.5px;
    font-weight: 800;
    background: var(--bg);
  }
  /* Iconic 1984 Dog-Ear Page Flipper */
  .dog-ear-btn {
    position: absolute;
    bottom: 0; left: 0;
    width: 28px; height: 28px;
    border-right: 2px solid var(--fg);
    border-top: 2px solid var(--fg);
    background: var(--bg);
    cursor: pointer;
    text-align: center;
    line-height: 24px;
    font-size: 14px;
    font-weight: 900;
  }
  .dog-ear-btn:hover {
    background: var(--fg);
    color: var(--bg);
  }

  /* Classic 1984 Alert Dialog */
  .mac-modal-backdrop {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.45);
    display: none;
    -webkit-box-align: center;
    -webkit-align-items: center;
    align-items: center;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
    justify-content: center;
    z-index: 2000;
  }
  .mac-modal-backdrop.show {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
  }
  .mac-alert-box {
    width: 380px;
    background: var(--bg);
    border: 3px double var(--fg);
    box-shadow: 6px 6px 0px var(--win-shadow);
    padding: 18px 20px;
  }
  .mac-alert-row {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    align-items: flex-start;
    margin-bottom: 16px;
  }
  .happy-mac-ascii {
    width: 48px;
    height: 54px;
    border: 2px solid var(--fg);
    border-radius: 4px;
    margin-right: 14px;
    text-align: center;
    padding-top: 6px;
    font-weight: 900;
    font-size: 14px;
    line-height: 1.2;
  }
</style>
</head>
<body class="theme-bw">

<!-- 1984 System 1.0 Menu Bar -->
<div class="mac-menubar">
  <div class="menu-left">
    <div class="menu-item menu-apple" id="menuAbout" title="About Macintosh 1984">&#63743;</div>
    <div class="menu-item" id="menuThemeBW" title="1984 오리지널 1-Bit 흑백 모드">1984 B&amp;W</div>
    <div class="menu-item" id="menuThemeAmber" title="1984 호박색 CRT 모니터">Amber CRT</div>
    <div class="menu-item" id="menuThemeGreen" title="Apple II 그린 모니터">Green CRT</div>
    <div class="menu-item" id="menuThemeBraun" title="디터 람스 브라운 탁상시계 테마">Braun Edition</div>
    <div class="menu-item" id="menuSoundToggle" title="1984 사각파 비프음 및 차임벨 켜기/끄기">🔊 Sound: ON</div>
    <div class="menu-item" id="menuFullScreen" title="전체 화면 오브제 모드 전환 (Cmd + F)">⛶ Fullscreen</div>
  </div>
  <div class="menu-right">
    <span id="menubarMiniStat" style="margin-right: 14px; font-size: 12px;">CPU 0%</span>
    <span id="menubarClock">00:00:00</span>
  </div>
</div>

<!-- System 1.0 Desktop Workspace -->
<div class="mac-desktop">
  <!-- Top Row: Desk Clock + Hardware Telemetry -->
  <div class="desktop-row">
    <!-- DA 1: 1984 Master Clock & D-Day -->
    <div class="mac-window win-flex-6">
      <div class="mac-titlebar">
        <div class="mac-close-box" id="btnChimeTest" title="클릭하면 1984 매킨토시 부팅 차임벨이 울립니다"></div>
        <span class="mac-title-text">Macintosh 1984 — Desk Clock &amp; D-Day</span>
      </div>
      <div class="mac-win-body">
        <div class="clock-hero">
          <div>
            <span class="clock-time" id="mainClockDigits">10:26:00</span>
            <span class="clock-ampm" id="mainClockAmPm">AM</span>
          </div>
          <div class="clock-date" id="mainClockDate">2026년 11월 15일 일요일</div>
        </div>

        <div class="dday-box">
          <div class="dday-inputs">
            <input type="text" id="ddayTitleInput" class="mac-input" placeholder="목표 일정을 입력하세요 (예: 목표 시험일)">
            <div style="display:-webkit-box; display:-webkit-flex; display:flex; -webkit-box-align:center; -webkit-align-items:center; align-items:center;">
              <span style="font-size:11.5px; font-weight:800; margin-right:8px;">목표 날짜 (YYYY-MM-DD):</span>
              <input type="text" id="ddayDateInput" class="mac-input" style="width:130px; margin-bottom:0;" placeholder="2026-12-31">
            </div>
          </div>
          <div class="dday-badge" id="ddayResultBadge">D-Day</div>
        </div>
      </div>
    </div>

    <!-- DA 2: Native IOKit & AppleSMC Hardware Telemetry -->
    <div class="mac-window win-flex-5">
      <div class="mac-titlebar">
        <div class="mac-close-box" id="btnRefreshHW" title="하드웨어 센서 즉시 갱신"></div>
        <span class="mac-title-text">System Telemetry (SMC / IOKit)</span>
      </div>
      <div class="mac-win-body">
        <div class="telemetry-row">
          <div class="telemetry-label-line">
            <span>CPU LOAD (Mach Kernel)</span>
            <span id="lblCpuLoad">0%</span>
          </div>
          <div class="mac-gauge-track"><div class="mac-gauge-fill" id="barCpuLoad" style="width:8%;"></div></div>
        </div>

        <div class="telemetry-row">
          <div class="telemetry-label-line">
            <span>MEMORY IN USE (RAM)</span>
            <span id="lblRamUsage">0 MB / 0 MB</span>
          </div>
          <div class="mac-gauge-track"><div class="mac-gauge-fill" id="barRamUsage" style="width:35%;"></div></div>
        </div>

        <div class="telemetry-row">
          <div class="telemetry-label-line">
            <span>BATTERY / POWER SOURCE</span>
            <span id="lblBattery">100% (AC Power)</span>
          </div>
          <div class="mac-gauge-track"><div class="mac-gauge-fill" id="barBattery" style="width:100%;"></div></div>
        </div>

        <div class="hw-chip-grid">
          <div class="hw-chip">
            <div class="hw-chip-val" id="valCpuTemp">-- °C</div>
            <div class="hw-chip-lbl">CPU TEMP (SMC)</div>
          </div>
          <div class="hw-chip">
            <div class="hw-chip-val" id="valFanRpm">-- RPM</div>
            <div class="hw-chip-lbl">COOLING FAN</div>
          </div>
          <div class="hw-chip">
            <div class="hw-chip-val" id="valDiskFree">-- GB</div>
            <div class="hw-chip-lbl">DISK FREE</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Bottom Row: Pomodoro Chronometer + 8-Page Dog-Ear Note Pad -->
  <div class="desktop-row">
    <!-- DA 3: Pomodoro Focus Timer -->
    <div class="mac-window win-flex-6">
      <div class="mac-titlebar">
        <div class="mac-close-box" id="btnResetPomoStats" title="오늘 누적 집중 기록 초기화"></div>
        <span class="mac-title-text">Focus Chronometer (Pomodoro)</span>
      </div>
      <div class="mac-win-body">
        <div class="pomo-display-wrap">
          <div class="pomo-digits" id="pomoDigits">50:00</div>
          <div>
            <div class="pomo-status-tag" id="pomoStatusTag">READY (50M FOCUS)</div>
          </div>
        </div>

        <div class="pomo-btn-row">
          <button class="mac-btn mac-btn-default" id="btnPomoStart">▶ START / PAUSE</button>
          <button class="mac-btn" id="btnPomoReset">↺ RESET</button>
          <button class="mac-btn" id="btnPreset50">50분 집중</button>
          <button class="mac-btn" id="btnPreset25">25분 집중</button>
          <button class="mac-btn" id="btnPreset10">10분 휴식</button>
        </div>

        <div class="pomo-stats-bar">
          <span id="lblPomoSessions">오늘 완료한 세션: 0회</span>
          <span id="lblPomoTotalMins">누적 집중 시간: 0분</span>
        </div>
      </div>
    </div>

    <!-- DA 4: Iconic 1984 8-Page Note Pad -->
    <div class="mac-window win-flex-5">
      <div class="mac-titlebar">
        <div class="mac-close-box"></div>
        <span class="mac-title-text">Note Pad (8-Page Scratchpad)</span>
      </div>
      <div class="mac-win-body notepad-body">
        <textarea id="notepadInput" class="notepad-textarea" placeholder="1984 매킨토시 Note Pad입니다.&#10;좌측 하단의 접힌 모서리(◢)를 클릭하면 1~8페이지가 넘어갑니다..."></textarea>
        <div class="notepad-footer">
          <div class="dog-ear-btn" id="btnNextPage" title="클릭하여 다음 페이지로 넘기기 (1~8페이지)">&#9698;</div>
          <span id="lblNotepadPage">Page 1 of 8</span>
          <span id="btnPrevPage" style="cursor:pointer; text-decoration:underline;" title="이전 페이지로">&laquo; Prev</span>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 1984 System 1.0 Alert Dialog -->
<div class="mac-modal-backdrop" id="aboutModal">
  <div class="mac-alert-box">
    <div class="mac-alert-row">
      <div class="happy-mac-ascii">^_^<br>&#9600;&#9600;</div>
      <div>
        <div style="font-weight:900; font-size:14px; margin-bottom:6px;">Macintosh 1984 Studio</div>
        <div style="font-size:12px; line-height:1.45;">
          1984년 오리지널 Macintosh (System 1.0) 데스크톱 액세서리 및 A1181 실시간 하드웨어 계기판입니다.<br><br>
          • <b>단축키:</b> Space (타이머 시작/정지), Cmd+F (전체 화면)
        </div>
      </div>
    </div>
    <div style="text-align:right;">
      <button class="mac-btn mac-btn-default" id="btnCloseAbout">OK</button>
    </div>
  </div>
</div>

<script>
(function () {
  var state = {
    theme: 'bw',
    soundEnabled: true,
    ddayTitle: '목표 D-Day',
    ddayDate: '2026-12-31',
    notepadPages: ['', '', '', '', '', '', '', ''],
    currentPage: 0,
    pomoTotalSecs: 50 * 60,
    pomoRemainSecs: 50 * 60,
    pomoModeLabel: '50M FOCUS',
    pomoRunning: false,
    pomoSessionsToday: 0,
    pomoTotalMinutes: 0
  };

  var pomoInterval = null;

  function hasNative() {
    return typeof window.NativeBridge !== 'undefined' && window.NativeBridge !== null;
  }

  function playSound(type) {
    if (!state.soundEnabled || !hasNative()) return;
    window.NativeBridge.playMacSound(type);
  }

  function saveStateToNative() {
    if (!hasNative()) return;
    try {
      window.NativeBridge.saveConfig(JSON.stringify(state));
    } catch (e) {}
  }

  function loadStateFromNative() {
    if (!hasNative()) return;
    try {
      var raw = window.NativeBridge.loadConfig();
      if (raw) {
        var parsed = JSON.parse(raw);
        if (parsed.theme) state.theme = parsed.theme;
        if (typeof parsed.soundEnabled === 'boolean') state.soundEnabled = parsed.soundEnabled;
        if (typeof parsed.ddayTitle === 'string') state.ddayTitle = parsed.ddayTitle;
        if (typeof parsed.ddayDate === 'string') state.ddayDate = parsed.ddayDate;
        if (parsed.notepadPages && parsed.notepadPages.length === 8) state.notepadPages = parsed.notepadPages;
        if (typeof parsed.currentPage === 'number') state.currentPage = parsed.currentPage;
        if (typeof parsed.pomoSessionsToday === 'number') state.pomoSessionsToday = parsed.pomoSessionsToday;
        if (typeof parsed.pomoTotalMinutes === 'number') state.pomoTotalMinutes = parsed.pomoTotalMinutes;
      }
    } catch (e) {}
  }

  /* 1. Theme & Sound Controls */
  function applyTheme(t) {
    state.theme = t;
    document.body.className = 'theme-' + t;
    document.getElementById('menuThemeBW').className = 'menu-item' + (t === 'bw' ? ' active-menu' : '');
    document.getElementById('menuThemeAmber').className = 'menu-item' + (t === 'amber' ? ' active-menu' : '');
    document.getElementById('menuThemeGreen').className = 'menu-item' + (t === 'green' ? ' active-menu' : '');
    document.getElementById('menuThemeBraun').className = 'menu-item' + (t === 'braun' ? ' active-menu' : '');
    saveStateToNative();
  }

  document.getElementById('menuThemeBW').onclick = function () { playSound('click'); applyTheme('bw'); };
  document.getElementById('menuThemeAmber').onclick = function () { playSound('click'); applyTheme('amber'); };
  document.getElementById('menuThemeGreen').onclick = function () { playSound('click'); applyTheme('green'); };
  document.getElementById('menuThemeBraun').onclick = function () { playSound('click'); applyTheme('braun'); };

  document.getElementById('menuSoundToggle').onclick = function () {
    state.soundEnabled = !state.soundEnabled;
    this.innerHTML = state.soundEnabled ? '🔊 Sound: ON' : '🔇 Sound: OFF';
    if (state.soundEnabled) playSound('beep');
    saveStateToNative();
  };

  document.getElementById('menuFullScreen').onclick = function () {
    playSound('click');
    if (hasNative()) window.NativeBridge.toggleFullscreen();
  };

  document.getElementById('menuAbout').onclick = function () {
    playSound('chime');
    document.getElementById('aboutModal').className = 'mac-modal-backdrop show';
  };
  document.getElementById('btnCloseAbout').onclick = function () {
    playSound('click');
    document.getElementById('aboutModal').className = 'mac-modal-backdrop';
  };
  document.getElementById('btnChimeTest').onclick = function () {
    playSound('chime');
  };

  /* 2. Master Clock & D-Day Engine */
  function updateClockAndDDay() {
    var now = new Date();
    var h24 = now.getHours();
    var ampm = h24 >= 12 ? 'PM' : 'AM';
    var h12 = h24 % 12;
    if (h12 === 0) h12 = 12;
    var hh = ('0' + h12).slice(-2);
    var mm = ('0' + now.getMinutes()).slice(-2);
    var ss = ('0' + now.getSeconds()).slice(-2);

    document.getElementById('mainClockDigits').innerHTML = hh + ':' + mm + ':' + ss;
    document.getElementById('mainClockAmPm').innerHTML = ampm;
    document.getElementById('menubarClock').innerHTML = ampm + ' ' + hh + ':' + mm + ':' + ss;

    var weekNames = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
    var dateStr = now.getFullYear() + '년 ' + (now.getMonth() + 1) + '월 ' + now.getDate() + '일 ' + weekNames[now.getDay()];
    document.getElementById('mainClockDate').innerHTML = dateStr;

    // D-Day Calculation
    var m = String(state.ddayDate || '').match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
    var badge = document.getElementById('ddayResultBadge');
    if (m) {
      var target = new Date(parseInt(m[1], 10), parseInt(m[2], 10) - 1, parseInt(m[3], 10), 0, 0, 0);
      var todayMid = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
      var diffDays = Math.round((target.getTime() - todayMid.getTime()) / 86400000);
      if (diffDays === 0) badge.innerHTML = 'D-DAY!';
      else if (diffDays > 0) badge.innerHTML = 'D-' + diffDays;
      else badge.innerHTML = 'D+' + Math.abs(diffDays);
    } else {
      badge.innerHTML = 'D-?';
    }
  }

  var elDdayTitle = document.getElementById('ddayTitleInput');
  var elDdayDate = document.getElementById('ddayDateInput');
  elDdayTitle.oninput = function () {
    state.ddayTitle = this.value;
    saveStateToNative();
  };
  elDdayDate.oninput = function () {
    state.ddayDate = this.value;
    updateClockAndDDay();
    saveStateToNative();
  };

  /* 3. Real-Time Hardware Telemetry (IOKit + AppleSMC + Mach) */
  function pollHardwareTelemetry() {
    if (!hasNative()) return;
    try {
      var raw = window.NativeBridge.getHardwareTelemetryJSON();
      var hw = JSON.parse(raw);

      var cpu = hw.cpuLoad || 0;
      document.getElementById('lblCpuLoad').innerHTML = cpu + '%';
      document.getElementById('barCpuLoad').style.width = Math.max(4, Math.min(100, cpu)) + '%';
      document.getElementById('menubarMiniStat').innerHTML =
        'CPU ' + cpu + '% · ' + (hw.cpuTemp > 0 ? (hw.cpuTemp + '°C') : 'RAM ' + hw.ramPct + '%');

      document.getElementById('lblRamUsage').innerHTML = hw.ramUsedMB + ' MB / ' + hw.ramTotalMB + ' MB (' + hw.ramPct + '%)';
      document.getElementById('barRamUsage').style.width = Math.max(4, Math.min(100, hw.ramPct)) + '%';

      document.getElementById('lblBattery').innerHTML = hw.batteryPct + '% (' + hw.powerSource + ')';
      document.getElementById('barBattery').style.width = Math.max(4, Math.min(100, hw.batteryPct)) + '%';

      document.getElementById('valCpuTemp').innerHTML = hw.cpuTemp > 0 ? (hw.cpuTemp + ' °C') : 'N/A';
      document.getElementById('valFanRpm').innerHTML = hw.fanRpm > 0 ? (hw.fanRpm + ' RPM') : ' Quiet ';
      document.getElementById('valDiskFree').innerHTML = hw.diskFreeGB + ' GB';
    } catch (e) {}
  }

  document.getElementById('btnRefreshHW').onclick = function () {
    playSound('click');
    pollHardwareTelemetry();
  };

  /* 4. Pomodoro Focus Chronometer */
  function renderPomodoro() {
    var mins = Math.floor(state.pomoRemainSecs / 60);
    var secs = state.pomoRemainSecs % 60;
    document.getElementById('pomoDigits').innerHTML =
      ('0' + mins).slice(-2) + ':' + ('0' + secs).slice(-2);

    var tag = document.getElementById('pomoStatusTag');
    tag.innerHTML = (state.pomoRunning ? '● RUNNING — ' : '⏸ PAUSED — ') + state.pomoModeLabel;
    document.getElementById('btnPomoStart').innerHTML = state.pomoRunning ? '⏸ PAUSE' : '▶ START';

    document.getElementById('lblPomoSessions').innerHTML = '오늘 완료한 세션: ' + state.pomoSessionsToday + '회';
    document.getElementById('lblPomoTotalMins').innerHTML = '누적 집중 시간: ' + state.pomoTotalMinutes + '분';
  }

  function setPomoPreset(minutes, label) {
    playSound('click');
    state.pomoRunning = false;
    state.pomoTotalSecs = minutes * 60;
    state.pomoRemainSecs = minutes * 60;
    state.pomoModeLabel = label;
    renderPomodoro();
  }

  function togglePomoRun() {
    playSound('beep');
    state.pomoRunning = !state.pomoRunning;
    renderPomodoro();
  }

  document.getElementById('btnPomoStart').onclick = togglePomoRun;
  document.getElementById('btnPomoReset').onclick = function () {
    playSound('click');
    state.pomoRunning = false;
    state.pomoRemainSecs = state.pomoTotalSecs;
    renderPomodoro();
  };
  document.getElementById('btnPreset50').onclick = function () { setPomoPreset(50, '50M FOCUS'); };
  document.getElementById('btnPreset25').onclick = function () { setPomoPreset(25, '25M POMODORO'); };
  document.getElementById('btnPreset10').onclick = function () { setPomoPreset(10, '10M BREAK'); };

  document.getElementById('btnResetPomoStats').onclick = function () {
    playSound('click');
    state.pomoSessionsToday = 0;
    state.pomoTotalMinutes = 0;
    saveStateToNative();
    renderPomodoro();
  };

  /* 5. Iconic 1984 8-Page Dog-Ear Note Pad */
  var elNotepad = document.getElementById('notepadInput');
  function renderNotepad() {
    elNotepad.value = state.notepadPages[state.currentPage] || '';
    document.getElementById('lblNotepadPage').innerHTML = 'Page ' + (state.currentPage + 1) + ' of 8';
  }

  elNotepad.oninput = function () {
    state.notepadPages[state.currentPage] = elNotepad.value;
    saveStateToNative();
  };

  document.getElementById('btnNextPage').onclick = function () {
    playSound('click');
    state.currentPage = (state.currentPage + 1) % 8;
    renderNotepad();
    saveStateToNative();
  };
  document.getElementById('btnPrevPage').onclick = function () {
    playSound('click');
    state.currentPage = (state.currentPage + 7) % 8;
    renderNotepad();
    saveStateToNative();
  };

  /* Keyboard Shortcuts */
  document.onkeydown = function (e) {
    var tag = (e.target || e.srcElement).tagName;
    var inInput = (tag === 'INPUT' || tag === 'TEXTAREA');
    var key = e.keyCode || e.which;

    if ((e.metaKey || e.ctrlKey) && key === 70) { // Cmd + F
      e.preventDefault();
      if (hasNative()) window.NativeBridge.toggleFullscreen();
      return;
    }
    if (!inInput && key === 32) { // Spacebar toggles Pomodoro
      e.preventDefault();
      togglePomoRun();
    }
  };

  window.onload = function () {
    loadStateFromNative();
    elDdayTitle.value = state.ddayTitle;
    elDdayDate.value = state.ddayDate;
    document.getElementById('menuSoundToggle').innerHTML = state.soundEnabled ? '🔊 Sound: ON' : '🔇 Sound: OFF';
    applyTheme(state.theme || 'bw');
    renderNotepad();
    renderPomodoro();
    updateClockAndDDay();
    pollHardwareTelemetry();

    setInterval(function () {
      updateClockAndDDay();
      if (state.pomoRunning) {
        if (state.pomoRemainSecs > 0) {
          state.pomoRemainSecs--;
          renderPomodoro();
        } else {
          state.pomoRunning = false;
          playSound('chime');
          if (state.pomoModeLabel.indexOf('FOCUS') !== -1 || state.pomoModeLabel.indexOf('POMODORO') !== -1) {
            state.pomoSessionsToday++;
            state.pomoTotalMinutes += Math.round(state.pomoTotalSecs / 60);
            saveStateToNative();
          }
          state.pomoRemainSecs = state.pomoTotalSecs;
          renderPomodoro();
        }
      }
    }, 1000);

    setInterval(pollHardwareTelemetry, 2000);
  };
})();
</script>
</body>
</html>
'''

html_file = os.path.join(res_dir, "mac1984.html")
with open(html_file, "w", encoding="utf-8") as f:
    f.write(html_content)

# 2. Objective-C Cocoa + IOKit (AppleSMC + IOPowerSources + Mach Kernel) 브릿지
objc_source = r'''
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>
#include <mach/mach.h>
#include <mach/processor_info.h>
#include <mach/mach_host.h>
#include <sys/sysctl.h>
#include <math.h>

#ifndef NSWindowStyleMaskTitled
#define NSWindowStyleMaskTitled (1 << 0)
#define NSWindowStyleMaskClosable (1 << 1)
#define NSWindowStyleMaskMiniaturizable (1 << 2)
#define NSWindowStyleMaskResizable (1 << 3)
#endif

// AppleSMC Structure Definitions for CPU Temp & Fan RPM on Intel Macs (A1181 ~ 2019 MBP)
typedef struct {
    char major;
    char minor;
    char build;
    char reserved[1];
    uint16_t release;
} SMCKeyData_vers_t;

typedef struct {
    uint16_t version;
    uint16_t length;
    uint32_t cpuPLimit;
    uint32_t gpuPLimit;
    uint32_t memPLimit;
} SMCKeyData_pLimitData_t;

typedef struct {
    uint32_t dataSize;
    uint32_t dataType;
    char dataAttributes;
} SMCKeyData_keyInfo_t;

typedef char SMCBytes_t[32];

typedef struct {
    uint32_t key;
    SMCKeyData_vers_t vers;
    SMCKeyData_pLimitData_t pLimitData;
    SMCKeyData_keyInfo_t keyInfo;
    char result;
    char status;
    char data8;
    uint32_t data32;
    SMCBytes_t bytes;
} SMCKeyData_t;

static uint32_t fourCharToUInt32(const char *str) {
    return ((uint32_t)str[0] << 24) | ((uint32_t)str[1] << 16) | ((uint32_t)str[2] << 8) | (uint32_t)str[3];
}

static BOOL readSMCKeyRaw(io_connect_t conn, const char *keyStr, SMCKeyData_t *outVal) {
    if (!conn) return NO;
    SMCKeyData_t inStruct;
    SMCKeyData_t outStruct;
    memset(&inStruct, 0, sizeof(SMCKeyData_t));
    memset(&outStruct, 0, sizeof(SMCKeyData_t));

    inStruct.key = fourCharToUInt32(keyStr);
    inStruct.data8 = 9; // kSMCGetKeyInfo
    size_t outSize = sizeof(SMCKeyData_t);
    kern_return_t kr = IOConnectCallStructMethod(conn, 2, &inStruct, sizeof(SMCKeyData_t), &outStruct, &outSize);
    if (kr != kIOReturnSuccess) return NO;

    inStruct.keyInfo.dataSize = outStruct.keyInfo.dataSize;
    inStruct.data8 = 5; // kSMCReadKey
    outSize = sizeof(SMCKeyData_t);
    kr = IOConnectCallStructMethod(conn, 2, &inStruct, sizeof(SMCKeyData_t), outVal, &outSize);
    return (kr == kIOReturnSuccess);
}

static int readSMCCpuTemperature(io_connect_t conn) {
    const char *tempKeys[] = { "TC0D", "TC0P", "TC0E", "TC0F", "TCXC", NULL };
    for (int i = 0; tempKeys[i] != NULL; i++) {
        SMCKeyData_t val;
        if (readSMCKeyRaw(conn, tempKeys[i], &val) && val.keyInfo.dataSize >= 2) {
            int temp = (int)((uint8_t)val.bytes[0]);
            if (temp >= 20 && temp <= 115) return temp;
        }
    }
    return 0;
}

static int readSMCFanRPM(io_connect_t conn) {
    SMCKeyData_t val;
    if (readSMCKeyRaw(conn, "F0Ac", &val) && val.keyInfo.dataSize >= 2) {
        uint16_t raw = ((uint8_t)val.bytes[0] << 8) | (uint8_t)val.bytes[1];
        // fpe2 (14.2 fixed point) or flt
        int rpm = (int)(raw >> 2);
        if (rpm >= 500 && rpm <= 8000) return rpm;
    }
    return 0;
}

// 1-Bit Macintosh 1984 Square-Wave Audio Synthesizer
static NSMutableData* createWAVData(const int16_t *samples, uint32_t numSamples, uint32_t sampleRate) {
    uint32_t dataSize = numSamples * sizeof(int16_t);
    uint32_t riffSize = 36 + dataSize;
    uint32_t byteRate = sampleRate * sizeof(int16_t);
    uint16_t blockAlign = sizeof(int16_t);
    uint16_t bitsPerSample = 16;
    uint16_t audioFormat = 1;
    uint16_t numChannels = 1;
    uint32_t fmtChunkSize = 16;

    NSMutableData *wav = [NSMutableData dataWithCapacity:(44 + dataSize)];
    [wav appendBytes:"RIFF" length:4];
    [wav appendBytes:&riffSize length:4];
    [wav appendBytes:"WAVE" length:4];
    [wav appendBytes:"fmt " length:4];
    [wav appendBytes:&fmtChunkSize length:4];
    [wav appendBytes:&audioFormat length:2];
    [wav appendBytes:&numChannels length:2];
    [wav appendBytes:&sampleRate length:4];
    [wav appendBytes:&byteRate length:4];
    [wav appendBytes:&blockAlign length:2];
    [wav appendBytes:&bitsPerSample length:2];
    [wav appendBytes:"data" length:4];
    [wav appendBytes:&dataSize length:4];
    [wav appendBytes:samples length:dataSize];
    return wav;
}

@interface Mac1984Controller : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSWindow *window;
    WebView *webView;
    io_connect_t smcConn;
    uint64_t prevTotalTicks;
    uint64_t prevIdleTicks;
    NSSound *soundClick;
    NSSound *soundBeep;
    NSSound *soundChime;
}
@end

@implementation Mac1984Controller

- (void)initRetroSounds {
    uint32_t sr = 44100;

    // 1. 1984 Mouse Click (12ms crisp 1-bit pulse)
    uint32_t cLen = (uint32_t)(sr * 0.012);
    int16_t *cBuf = (int16_t *)calloc(cLen, sizeof(int16_t));
    for (uint32_t i = 0; i < cLen; i++) {
        double t = (double)i / sr;
        cBuf[i] = (int16_t)((sin(2.0 * M_PI * 1400.0 * t) > 0 ? 1.0 : -1.0) * exp(-t * 250.0) * 9000.0);
    }
    soundClick = [[NSSound alloc] initWithData:createWAVData(cBuf, cLen, sr)];
    free(cBuf);

    // 2. Classic Mac 1984 System Beep (90ms square-wave 880Hz)
    uint32_t bLen = (uint32_t)(sr * 0.09);
    int16_t *bBuf = (int16_t *)calloc(bLen, sizeof(int16_t));
    for (uint32_t i = 0; i < bLen; i++) {
        double t = (double)i / sr;
        double sq = sin(2.0 * M_PI * 880.0 * t) >= 0 ? 1.0 : -1.0;
        bBuf[i] = (int16_t)(sq * exp(-t * 14.0) * 10000.0);
    }
    soundBeep = [[NSSound alloc] initWithData:createWAVData(bBuf, bLen, sr)];
    free(bBuf);

    // 3. 1984 Macintosh Startup / Pomodoro Complete Chime (550ms F# Major chord arpeggio)
    uint32_t mLen = (uint32_t)(sr * 0.55);
    int16_t *mBuf = (int16_t *)calloc(mLen, sizeof(int16_t));
    for (uint32_t i = 0; i < mLen; i++) {
        double t = (double)i / sr;
        double wave = (sin(2.0 * M_PI * 739.99 * t) >= 0 ? 0.35 : -0.35)
                    + (sin(2.0 * M_PI * 932.33 * t) >= 0 ? 0.35 : -0.35)
                    + (sin(2.0 * M_PI * 1108.73 * t) >= 0 ? 0.30 : -0.30);
        mBuf[i] = (int16_t)(wave * exp(-t * 4.8) * 12000.0);
    }
    soundChime = [[NSSound alloc] initWithData:createWAVData(mBuf, mLen, sr)];
    free(mBuf);
}

- (id)init {
    self = [super init];
    if (self) {
        prevTotalTicks = 0;
        prevIdleTicks = 0;
        smcConn = 0;

        io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleSMC"));
        if (service) {
            IOServiceOpen(service, mach_task_self(), 0, &smcConn);
            IOObjectRelease(service);
        }
        [self initRetroSounds];
    }
    return self;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    if (selector == @selector(getHardwareTelemetryJSON) ||
        selector == @selector(playMacSound:) ||
        selector == @selector(saveConfig:) ||
        selector == @selector(loadConfig) ||
        selector == @selector(toggleFullscreen)) {
        return NO;
    }
    return YES;
}

+ (NSString *)webScriptNameForSelector:(SEL)selector {
    if (selector == @selector(getHardwareTelemetryJSON)) return @"getHardwareTelemetryJSON";
    if (selector == @selector(playMacSound:)) return @"playMacSound";
    if (selector == @selector(saveConfig:)) return @"saveConfig";
    if (selector == @selector(loadConfig)) return @"loadConfig";
    if (selector == @selector(toggleFullscreen)) return @"toggleFullscreen";
    return nil;
}

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    [windowObject setValue:self forKey:@"NativeBridge"];
}

- (void)playMacSound:(NSString *)type {
    NSSound *s = soundClick;
    if ([type isEqualToString:@"beep"]) s = soundBeep;
    else if ([type isEqualToString:@"chime"]) s = soundChime;
    if (s) {
        NSSound *cp = [[s copy] autorelease];
        [cp play];
    }
}

- (void)saveConfig:(NSString *)jsonStr {
    if (!jsonStr) return;
    [[NSUserDefaults standardUserDefaults] setObject:jsonStr forKey:@"Macintosh1984StateV1"];
}

- (NSString *)loadConfig {
    NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:@"Macintosh1984StateV1"];
    return s ? s : @"";
}

- (void)toggleFullscreen {
    if ([window respondsToSelector:@selector(toggleFullScreen:)]) {
        [window toggleFullScreen:nil];
    }
}

- (NSString *)getHardwareTelemetryJSON {
    // 1. CPU Load via Mach host_processor_info
    int cpuLoadPct = 0;
    natural_t cpuCount = 0;
    processor_info_array_t infoArray = NULL;
    mach_msg_type_number_t infoCount = 0;

    if (host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &cpuCount, &infoArray, &infoCount) == KERN_SUCCESS) {
        uint64_t totalTicks = 0;
        uint64_t idleTicks = 0;
        for (natural_t i = 0; i < cpuCount; i++) {
            uint64_t u = infoArray[i * CPU_STATE_MAX + CPU_STATE_USER];
            uint64_t s = infoArray[i * CPU_STATE_MAX + CPU_STATE_SYSTEM];
            uint64_t n = infoArray[i * CPU_STATE_MAX + CPU_STATE_NICE];
            uint64_t idl = infoArray[i * CPU_STATE_MAX + CPU_STATE_IDLE];
            totalTicks += (u + s + n + idl);
            idleTicks += idl;
        }
        uint64_t dTotal = totalTicks - prevTotalTicks;
        uint64_t dIdle = idleTicks - prevIdleTicks;
        if (prevTotalTicks > 0 && dTotal > 0) {
            cpuLoadPct = (int)(((double)(dTotal - dIdle) / (double)dTotal) * 100.0 + 0.5);
        }
        prevTotalTicks = totalTicks;
        prevIdleTicks = idleTicks;
        vm_deallocate(mach_task_self(), (vm_address_t)infoArray, infoCount * sizeof(integer_t));
    }

    // 2. RAM Usage via sysctl & Mach VM statistics
    int64_t totalMemBytes = 0;
    size_t sz = sizeof(totalMemBytes);
    sysctlbyname("hw.memsize", &totalMemBytes, &sz, NULL, 0);
    int ramTotalMB = (int)(totalMemBytes / (1024 * 1024));

    vm_size_t pageSize = 4096;
    host_page_size(mach_host_self(), &pageSize);
    vm_statistics_data_t vmStat;
    mach_msg_type_number_t vmCount = sizeof(vmStat) / sizeof(natural_t);
    int ramUsedMB = 0;
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStat, &vmCount) == KERN_SUCCESS) {
        uint64_t usedBytes = (uint64_t)(vmStat.active_count + vmStat.wire_count) * (uint64_t)pageSize;
        ramUsedMB = (int)(usedBytes / (1024 * 1024));
    }
    int ramPct = ramTotalMB > 0 ? (int)((ramUsedMB * 100) / ramTotalMB) : 0;

    // 3. Battery & Power Source via IOPowerSources
    int batteryPct = 100;
    NSString *powerSrc = @"AC Power";
    CFTypeRef psInfo = IOPSCopyPowerSourcesInfo();
    if (psInfo) {
        CFArrayRef psList = IOPSCopyPowerSourcesList(psInfo);
        if (psList && CFArrayGetCount(psList) > 0) {
            CFDictionaryRef ps = IOPSGetPowerSourceDescription(psInfo, CFArrayGetValueAtIndex(psList, 0));
            if (ps) {
                NSNumber *curCap = (NSNumber *)CFDictionaryGetValue(ps, CFSTR(kIOPSCurrentCapacityKey));
                NSNumber *maxCap = (NSNumber *)CFDictionaryGetValue(ps, CFSTR(kIOPSMaxCapacityKey));
                NSString *pState = (NSString *)CFDictionaryGetValue(ps, CFSTR(kIOPSPowerSourceStateKey));
                if (curCap && maxCap && [maxCap intValue] > 0) {
                    batteryPct = ([curCap intValue] * 100) / [maxCap intValue];
                }
                if (pState) {
                    powerSrc = [pState isEqualToString:@kIOPSACPowerValue] ? @"AC Power" : @"Battery";
                }
            }
        }
        if (psList) CFRelease(psList);
        CFRelease(psInfo);
    }

    // 4. AppleSMC CPU Temp & Fan Speed
    int cpuTemp = readSMCCpuTemperature(smcConn);
    int fanRpm = readSMCFanRPM(smcConn);

    // 5. Disk Free Space
    NSDictionary *fsAttrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:nil];
    unsigned long long freeBytes = fsAttrs ? [[fsAttrs objectForKey:NSFileSystemFreeSize] unsignedLongLongValue] : 0;
    int diskFreeGB = (int)(freeBytes / (1024ULL * 1024ULL * 1024ULL));

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:cpuLoadPct], @"cpuLoad",
        [NSNumber numberWithInt:ramUsedMB], @"ramUsedMB",
        [NSNumber numberWithInt:ramTotalMB], @"ramTotalMB",
        [NSNumber numberWithInt:ramPct], @"ramPct",
        [NSNumber numberWithInt:batteryPct], @"batteryPct",
        powerSrc, @"powerSource",
        [NSNumber numberWithInt:cpuTemp], @"cpuTemp",
        [NSNumber numberWithInt:fanRpm], @"fanRpm",
        [NSNumber numberWithInt:diskFreeGB], @"diskFreeGB",
        nil];

    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    if (!json) return @"{}";
    return [[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] autorelease];
}

- (void)setupMenus {
    NSMenu *menubar = [[[NSMenu alloc] init] autorelease];
    NSMenuItem *appMenuItem = [[[NSMenuItem alloc] init] autorelease];
    [menubar addItem:appMenuItem];
    [NSApp setMainMenu:menubar];

    NSMenu *appMenu = [[[NSMenu alloc] init] autorelease];
    [appMenu addItemWithTitle:@"About Macintosh 1984" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [appMenu addItem:[NSMenuItem separatorItem]];
    [appMenu addItemWithTitle:@"전체 화면 전환 (Fullscreen)" action:@selector(toggleFullscreen) keyEquivalent:@"f"];
    [appMenu addItemWithTitle:@"종료 (Quit)" action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenuItem setSubmenu:appMenu];

    NSMenuItem *editMenuItem = [[[NSMenuItem alloc] init] autorelease];
    [menubar addItem:editMenuItem];
    NSMenu *editMenu = [[[NSMenu alloc] initWithTitle:@"편집"] autorelease];
    [editMenu addItemWithTitle:@"오려두기" action:@selector(cut:) keyEquivalent:@"x"];
    [editMenu addItemWithTitle:@"복사하기" action:@selector(copy:) keyEquivalent:@"c"];
    [editMenu addItemWithTitle:@"붙여넣기" action:@selector(paste:) keyEquivalent:@"v"];
    [editMenu addItemWithTitle:@"전체 선택" action:@selector(selectAll:) keyEquivalent:@"a"];
    [editMenuItem setSubmenu:editMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self setupMenus];
    [self playMacSound:@"chime"];

    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    window = [[NSWindow alloc] initWithContentRect:NSMakeRect(90, 90, 980, 620)
                                         styleMask:style
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [window setTitle:@"Macintosh 1984"];
    [window setMinSize:NSMakeSize(780, 500)];
    [window setCollectionBehavior:(1 << 7)]; // NSWindowCollectionBehaviorFullScreenPrimary
    [window setDelegate:self];

    NSView *content = [window contentView];
    webView = [[WebView alloc] initWithFrame:[content bounds] frameName:@"Mac1984Frame" groupName:@"Mac1984Group"];
    [webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [webView setFrameLoadDelegate:self];

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"mac1984" ofType:@"html"];
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];

    [content addSubview:webView];
    [window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end

int main(int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSApplication *app = [NSApplication sharedApplication];
    [app setActivationPolicy:0];
    Mac1984Controller *controller = [[[Mac1984Controller alloc] init] autorelease];
    [app setDelegate:controller];
    [app run];
    [pool drain];
    return 0;
}
'''

src_file = os.path.join(res_dir, "main.m")
with open(src_file, "w", encoding="utf-8") as f:
    f.write(objc_source)

bin_file = os.path.join(macos_dir, "Macintosh1984")

subprocess.run([
    "clang", "-arch", "x86_64", "-mmacosx-version-min=10.7",
    "-fno-objc-arc", "-Wno-deprecated-declarations", "-O2",
    src_file,
    "-framework", "Cocoa", "-framework", "WebKit", "-framework", "IOKit",
    "-o", bin_file
], check=True)
os.chmod(bin_file, 0o755)

# 3. 1984 Macintosh 128K ("Happy Mac") 전용 앱 아이콘 생성기
icon_objc = r'''
#import <Cocoa/Cocoa.h>

void fillRoundRect(NSRect r, CGFloat rad, NSColor *fill, NSColor *stroke, CGFloat lw) {
    NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:r xRadius:rad yRadius:rad];
    if (fill) { [fill setFill]; [p fill]; }
    if (stroke) { [stroke setStroke]; [p setLineWidth:lw]; [p stroke]; }
}

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *outPath = [NSString stringWithUTF8String:argv[1]];
    NSString *bundlePath = [NSString stringWithUTF8String:argv[2]];

    NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc]
        initWithBitmapDataPlanes:NULL pixelsWide:1024 pixelsHigh:1024
                   bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO
                  colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:0 bitsPerPixel:0] autorelease];
    [rep setSize:NSMakeSize(1024, 1024)];

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];

    // 1. 1984 Macintosh 128K Warm Beige Case
    fillRoundRect(NSMakeRect(152, 86, 720, 852), 72,
                  [NSColor colorWithCalibratedRed:0.91 green:0.88 blue:0.79 alpha:1.0],
                  [NSColor colorWithCalibratedRed:0.22 green:0.20 blue:0.18 alpha:1.0], 16.0);

    // Lower Chin Recess
    fillRoundRect(NSMakeRect(184, 118, 656, 210), 36,
                  [NSColor colorWithCalibratedRed:0.85 green:0.81 blue:0.72 alpha:1.0], nil, 0);

    // 2. 9-inch CRT Bezel & Screen
    fillRoundRect(NSMakeRect(228, 386, 568, 468), 48,
                  [NSColor colorWithCalibratedRed:0.14 green:0.15 blue:0.16 alpha:1.0],
                  [NSColor colorWithCalibratedRed:0.05 green:0.05 blue:0.05 alpha:1.0], 10.0);

    fillRoundRect(NSMakeRect(256, 414, 512, 412), 32,
                  [NSColor colorWithCalibratedRed:0.88 green:0.93 blue:0.95 alpha:1.0], nil, 0);

    // 3. Susan Kare Style "Happy Mac" Face on CRT
    NSColor *ink = [NSColor colorWithCalibratedRed:0.10 green:0.11 blue:0.12 alpha:1.0];
    [ink setFill];
    // Eyes
    NSRectFill(NSMakeRect(422, 668, 28, 44));
    NSRectFill(NSMakeRect(574, 668, 28, 44));
    // Nose (L-shape)
    NSRectFill(NSMakeRect(502, 588, 20, 68));
    NSRectFill(NSMakeRect(482, 588, 40, 20));
    // Smile
    NSRectFill(NSMakeRect(434, 518, 156, 20));
    NSRectFill(NSMakeRect(414, 538, 20, 20));
    NSRectFill(NSMakeRect(590, 538, 20, 20));

    // 4. 400K 3.5" Floppy Disk Drive Slot (Right Chin)
    fillRoundRect(NSMakeRect(516, 224, 248, 30), 6,
                  [NSColor colorWithCalibratedRed:0.12 green:0.12 blue:0.12 alpha:1.0], nil, 0);

    // 5. Classic 6-Color Rainbow Badge (Left Chin)
    CGFloat bx = 244, by = 166;
    NSArray *rainbow = [NSArray arrayWithObjects:
        [NSColor colorWithCalibratedRed:0.38 green:0.73 blue:0.27 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.99 green:0.72 blue:0.15 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.96 green:0.51 blue:0.12 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.88 green:0.23 blue:0.24 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.59 green:0.24 blue:0.59 alpha:1.0],
        [NSColor colorWithCalibratedRed:0.00 green:0.62 blue:0.86 alpha:1.0], nil];
    for (int i = 0; i < 6; i++) {
        [[rainbow objectAtIndex:i] setFill];
        NSRectFill(NSMakeRect(bx, by + (5 - i) * 8, 48, 8));
    }

    [NSGraphicsContext restoreGraphicsState];

    NSData *png = [rep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
    [png writeToFile:outPath atomically:YES];

    NSImage *img = [[[NSImage alloc] initWithData:png] autorelease];
    if (img && [bundlePath length] > 0) {
        [[NSWorkspace sharedWorkspace] setIcon:img forFile:bundlePath options:0];
    }
    [pool drain];
    return 0;
}
'''
with open("/tmp/gen_mac1984_icon.m", "w") as f:
    f.write(icon_objc)
subprocess.run(["clang", "-Wno-deprecated-declarations", "/tmp/gen_mac1984_icon.m", "-framework", "Cocoa", "-o", "/tmp/gen_mac1984_icon"], check=True)

# 4. Info.plist 생성
plist_dict = {
    "CFBundleExecutable": "Macintosh1984",
    "CFBundleIconFile": "Macintosh1984.icns",
    "CFBundleIconName": "Macintosh1984",
    "CFBundleIdentifier": "com.soohyun.macintosh1984",
    "CFBundleName": "Macintosh 1984",
    "CFBundleDisplayName": "Macintosh 1984",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "LSMinimumSystemVersion": "10.7",
    "NSHighResolutionCapable": True
}
with open(os.path.join(contents_dir, "Info.plist"), "wb") as fp:
    plistlib.dump(plist_dict, fp)

# 5. 아이콘 컴파일 및 각인
iconset_dir = "/tmp/Macintosh1984.iconset"
if os.path.exists(iconset_dir):
    shutil.rmtree(iconset_dir)
os.makedirs(iconset_dir, exist_ok=True)
master_png = "/tmp/mac1984_1024.png"

subprocess.run(["/tmp/gen_mac1984_icon", master_png, app_path], check=True)
for sz in [16, 32, 128, 256, 512]:
    subprocess.run(["sips", "-s", "format", "png", "-z", str(sz), str(sz), master_png, "--out", os.path.join(iconset_dir, f"icon_{sz}x{sz}.png")], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run(["sips", "-s", "format", "png", "-z", str(sz*2), str(sz*2), master_png, "--out", os.path.join(iconset_dir, f"icon_{sz}x{sz}@2x.png")], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

subprocess.run(["iconutil", "-c", "icns", iconset_dir, "-o", os.path.join(res_dir, "Macintosh1984.icns")], check=True)

subprocess.run(["xattr", "-cr", app_path], check=False)
subprocess.run(["codesign", "--force", "--deep", "--identifier", "com.soohyun.macintosh1984", "--sign", "-", app_path], check=False)
subprocess.run(["/tmp/gen_mac1984_icon", master_png, app_path], check=True)

if os.path.exists(installed_app):
    shutil.rmtree(installed_app)
subprocess.run(["ditto", app_path, installed_app], check=True)
subprocess.run(["/tmp/gen_mac1984_icon", master_png, installed_app], check=True)

lsregister_bin = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
if os.path.exists(lsregister_bin):
    subprocess.run([lsregister_bin, "-f", installed_app], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
subprocess.run(["touch", installed_app], check=False)

# 6. HFS+ DMG 생성
os.symlink("/Applications", os.path.join(stage_dir, "Applications"))
subprocess.run([
    "hdiutil", "create", "-volname", "Macintosh 1984",
    "-srcfolder", stage_dir, "-ov", "-format", "UDZO", "-fs", "HFS+", dmg_path
], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
subprocess.run(["/tmp/gen_mac1984_icon", master_png, dmg_path], check=False)

shutil.rmtree(stage_dir)
print("✅ Macintosh 1984 빌드 완료! 바탕화면의 [Macintosh1984.dmg] 및 실행된 앱을 확인하세요.")
subprocess.run(["open", installed_app])
PYEOF
python3 /tmp/build_macintosh1984.py