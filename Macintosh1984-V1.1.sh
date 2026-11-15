setopt NO_BANG_HIST
cat << 'PYEOF' > /tmp/build_macintosh_1984_v13.py
import os, shutil, subprocess, plistlib

desktop = os.path.expanduser("~/Desktop")
stage_dir = os.path.join(desktop, "Macintosh_1984_Stage")
app_name = "Macintosh 1984.app"
app_path = os.path.join(stage_dir, app_name)
dmg_path = os.path.join(desktop, "Macintosh 1984.dmg")
installed_app = os.path.join("/Applications", app_name)

# 1. 기존 실행 프로세스 종료 및 이전 파일 정리
subprocess.run(["pkill", "-9", "-f", "Macintosh1984"], check=False)
subprocess.run(["pkill", "-9", "-f", "Macintosh 1984"], check=False)

for old_p in [
    stage_dir,
    dmg_path,
    installed_app,
    "/Applications/Macintosh1984.app",
    os.path.join(desktop, "Macintosh1984.dmg")
]:
    if os.path.exists(old_p):
        if os.path.isdir(old_p) and not os.path.islink(old_p):
            shutil.rmtree(old_p)
        else:
            os.remove(old_p)

contents_dir = os.path.join(app_path, "Contents")
macos_dir = os.path.join(contents_dir, "MacOS")
res_dir = os.path.join(contents_dir, "Resources")
os.makedirs(macos_dir, exist_ok=True)
os.makedirs(res_dir, exist_ok=True)

# 2. OS X 10.7/10.8 WebKit(Safari 5/6) 100% 호환 CSS (CSS 변수 완전 제거 + 명시적 Hex 컬러 + 깨짐 없는 기호)
html_content = r'''<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Macintosh 1984</title>
<style>
  * {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    -webkit-user-select: none;
    user-select: none;
  }

  html, body {
    width: 100%;
    height: 100%;
    overflow: hidden;
    font-family: "Chicago", "Geneva", "Monaco", "Courier New", "Apple SD Gothic Neo", monospace;
    font-size: 13px;
  }

  input, textarea {
    -webkit-user-select: text;
    user-select: text;
    font-family: inherit;
  }

  /* ==========================================================================
     Theme 1: 1984 Classic 1-Bit B&W (OS X 10.7/10.8 Safari 6 Explicit Hex CSS)
     ========================================================================== */
  body.theme-bw {
    color: #111111;
    background-color: #777777;
    background-image:
      -webkit-linear-gradient(45deg, #e5e5e0 25%, transparent 25%, transparent 75%, #e5e5e0 75%, #e5e5e0),
      -webkit-linear-gradient(45deg, #e5e5e0 25%, transparent 25%, transparent 75%, #e5e5e0 75%, #e5e5e0);
    background-position: 0 0, 2px 2px;
    background-size: 4px 4px;
  }
  body.theme-bw .mac-menubar { background-color: #fbfbf9; border-bottom: 2px solid #111111; color: #111111; }
  body.theme-bw .menu-item:hover, body.theme-bw .menu-item.active-menu { background-color: #111111; color: #fbfbf9; }
  body.theme-bw .mac-window { background-color: #fbfbf9; border: 2px solid #111111; -webkit-box-shadow: 4px 4px 0px #000000; box-shadow: 4px 4px 0px #000000; }
  body.theme-bw .mac-titlebar {
    background-color: #fbfbf9;
    border-bottom: 2px solid #111111;
    background-image: -webkit-repeating-linear-gradient(top, #fbfbf9 0px, #fbfbf9 2px, #111111 2px, #111111 3px);
  }
  body.theme-bw .mac-close-box { background-color: #fbfbf9; border: 1.5px solid #111111; -webkit-box-shadow: 0 0 0 3px #fbfbf9; box-shadow: 0 0 0 3px #fbfbf9; }
  body.theme-bw .mac-title-text, body.theme-bw input, body.theme-bw textarea, body.theme-bw .notepad-footer, body.theme-bw .dog-ear-btn, body.theme-bw .mac-alert-box {
    background-color: #fbfbf9; color: #111111;
  }
  body.theme-bw .clock-hero, body.theme-bw .dday-box, body.theme-bw .spec-summary-box, body.theme-bw .mac-gauge-track, body.theme-bw .hw-chip, body.theme-bw .pomo-display-wrap, body.theme-bw .pomo-status-tag {
    background-color: #fbfbf9; border-color: #111111; color: #111111;
  }
  body.theme-bw .mac-input { border-bottom-color: #111111; color: #111111; background-color: transparent; }
  body.theme-bw .dday-badge { background-color: #111111; color: #fbfbf9; }
  body.theme-bw .mac-gauge-fill {
    background-color: #111111;
    background-image: -webkit-repeating-linear-gradient(left, #111111 0px, #111111 4px, #fbfbf9 4px, #fbfbf9 6px);
  }
  body.theme-bw .mac-btn {
    background-color: #fbfbf9; color: #111111; border: 2px solid #111111;
    -webkit-box-shadow: 2px 2px 0px #111111; box-shadow: 2px 2px 0px #111111;
  }
  body.theme-bw .mac-btn:hover, body.theme-bw .dog-ear-btn:hover { background-color: #111111; color: #fbfbf9; }
  body.theme-bw .mac-btn-default { -webkit-box-shadow: 0 0 0 1px #fbfbf9, 0 0 0 4px #111111; box-shadow: 0 0 0 1px #fbfbf9, 0 0 0 4px #111111; }

  /* ==========================================================================
     Theme 2: 1984 Amber Phosphor CRT
     ========================================================================== */
  body.theme-amber {
    color: #ffb000;
    background-color: #382400;
    background-image:
      -webkit-linear-gradient(45deg, #120b00 25%, transparent 25%, transparent 75%, #120b00 75%, #120b00),
      -webkit-linear-gradient(45deg, #120b00 25%, transparent 25%, transparent 75%, #120b00 75%, #120b00);
    background-position: 0 0, 2px 2px;
    background-size: 4px 4px;
  }
  body.theme-amber .mac-menubar { background-color: #181000; border-bottom: 2px solid #ffb000; color: #ffb000; }
  body.theme-amber .menu-item:hover, body.theme-amber .menu-item.active-menu { background-color: #ffb000; color: #181000; }
  body.theme-amber .mac-window { background-color: #181000; border: 2px solid #ffb000; -webkit-box-shadow: 4px 4px 0px #000000; box-shadow: 4px 4px 0px #000000; }
  body.theme-amber .mac-titlebar {
    background-color: #181000;
    border-bottom: 2px solid #ffb000;
    background-image: -webkit-repeating-linear-gradient(top, #181000 0px, #181000 2px, #ffb000 2px, #ffb000 3px);
  }
  body.theme-amber .mac-close-box { background-color: #181000; border: 1.5px solid #ffb000; -webkit-box-shadow: 0 0 0 3px #181000; box-shadow: 0 0 0 3px #181000; }
  body.theme-amber .mac-title-text, body.theme-amber input, body.theme-amber textarea, body.theme-amber .notepad-footer, body.theme-amber .dog-ear-btn, body.theme-amber .mac-alert-box {
    background-color: #181000; color: #ffb000;
  }
  body.theme-amber .clock-hero, body.theme-amber .dday-box, body.theme-amber .spec-summary-box, body.theme-amber .mac-gauge-track, body.theme-amber .hw-chip, body.theme-amber .pomo-display-wrap, body.theme-amber .pomo-status-tag {
    background-color: #181000; border-color: #ffb000; color: #ffb000;
  }
  body.theme-amber .mac-input { border-bottom-color: #ffb000; color: #ffb000; background-color: transparent; }
  body.theme-amber .dday-badge { background-color: #ffcc33; color: #181000; }
  body.theme-amber .mac-gauge-fill {
    background-color: #ffcc33;
    background-image: -webkit-repeating-linear-gradient(left, #ffcc33 0px, #ffcc33 4px, #181000 4px, #181000 6px);
  }
  body.theme-amber .mac-btn {
    background-color: #181000; color: #ffb000; border: 2px solid #ffb000;
    -webkit-box-shadow: 2px 2px 0px #ffb000; box-shadow: 2px 2px 0px #ffb000;
  }
  body.theme-amber .mac-btn:hover, body.theme-amber .dog-ear-btn:hover { background-color: #ffb000; color: #181000; }
  body.theme-amber .mac-btn-default { -webkit-box-shadow: 0 0 0 1px #181000, 0 0 0 4px #ffb000; box-shadow: 0 0 0 1px #181000, 0 0 0 4px #ffb000; }

  /* ==========================================================================
     Theme 3: Apple II Green Phosphor CRT
     ========================================================================== */
  body.theme-green {
    color: #33ff66;
    background-color: #0f3818;
    background-image:
      -webkit-linear-gradient(45deg, #041006 25%, transparent 25%, transparent 75%, #041006 75%, #041006),
      -webkit-linear-gradient(45deg, #041006 25%, transparent 25%, transparent 75%, #041006 75%, #041006);
    background-position: 0 0, 2px 2px;
    background-size: 4px 4px;
  }
  body.theme-green .mac-menubar { background-color: #051608; border-bottom: 2px solid #33ff66; color: #33ff66; }
  body.theme-green .menu-item:hover, body.theme-green .menu-item.active-menu { background-color: #33ff66; color: #051608; }
  body.theme-green .mac-window { background-color: #051608; border: 2px solid #33ff66; -webkit-box-shadow: 4px 4px 0px #000000; box-shadow: 4px 4px 0px #000000; }
  body.theme-green .mac-titlebar {
    background-color: #051608;
    border-bottom: 2px solid #33ff66;
    background-image: -webkit-repeating-linear-gradient(top, #051608 0px, #051608 2px, #33ff66 2px, #33ff66 3px);
  }
  body.theme-green .mac-close-box { background-color: #051608; border: 1.5px solid #33ff66; -webkit-box-shadow: 0 0 0 3px #051608; box-shadow: 0 0 0 3px #051608; }
  body.theme-green .mac-title-text, body.theme-green input, body.theme-green textarea, body.theme-green .notepad-footer, body.theme-green .dog-ear-btn, body.theme-green .mac-alert-box {
    background-color: #051608; color: #33ff66;
  }
  body.theme-green .clock-hero, body.theme-green .dday-box, body.theme-green .spec-summary-box, body.theme-green .mac-gauge-track, body.theme-green .hw-chip, body.theme-green .pomo-display-wrap, body.theme-green .pomo-status-tag {
    background-color: #051608; border-color: #33ff66; color: #33ff66;
  }
  body.theme-green .mac-input { border-bottom-color: #33ff66; color: #33ff66; background-color: transparent; }
  body.theme-green .dday-badge { background-color: #66ff99; color: #051608; }
  body.theme-green .mac-gauge-fill {
    background-color: #66ff99;
    background-image: -webkit-repeating-linear-gradient(left, #66ff99 0px, #66ff99 4px, #051608 4px, #051608 6px);
  }
  body.theme-green .mac-btn {
    background-color: #051608; color: #33ff66; border: 2px solid #33ff66;
    -webkit-box-shadow: 2px 2px 0px #33ff66; box-shadow: 2px 2px 0px #33ff66;
  }
  body.theme-green .mac-btn:hover, body.theme-green .dog-ear-btn:hover { background-color: #33ff66; color: #051608; }
  body.theme-green .mac-btn-default { -webkit-box-shadow: 0 0 0 1px #051608, 0 0 0 4px #33ff66; box-shadow: 0 0 0 1px #051608, 0 0 0 4px #33ff66; }

  /* ==========================================================================
     Theme 4: Dieter Rams Braun Industrial
     ========================================================================== */
  body.theme-braun {
    color: #222220;
    background-color: #d4d0c5;
    background-image:
      -webkit-linear-gradient(45deg, #dfdcd2 25%, transparent 25%, transparent 75%, #dfdcd2 75%, #dfdcd2),
      -webkit-linear-gradient(45deg, #dfdcd2 25%, transparent 25%, transparent 75%, #dfdcd2 75%, #dfdcd2);
    background-position: 0 0, 2px 2px;
    background-size: 4px 4px;
  }
  body.theme-braun .mac-menubar { background-color: #f4f2ec; border-bottom: 2px solid #222220; color: #222220; }
  body.theme-braun .menu-item:hover, body.theme-braun .menu-item.active-menu { background-color: #ea4c1d; color: #f4f2ec; }
  body.theme-braun .mac-window { background-color: #f4f2ec; border: 2px solid #222220; -webkit-box-shadow: 4px 4px 0px #88847a; box-shadow: 4px 4px 0px #88847a; }
  body.theme-braun .mac-titlebar {
    background-color: #f4f2ec;
    border-bottom: 2px solid #222220;
    background-image: -webkit-repeating-linear-gradient(top, #f4f2ec 0px, #f4f2ec 2px, #222220 2px, #222220 3px);
  }
  body.theme-braun .mac-close-box { background-color: #f4f2ec; border: 1.5px solid #222220; -webkit-box-shadow: 0 0 0 3px #f4f2ec; box-shadow: 0 0 0 3px #f4f2ec; }
  body.theme-braun .mac-title-text, body.theme-braun input, body.theme-braun textarea, body.theme-braun .notepad-footer, body.theme-braun .dog-ear-btn, body.theme-braun .mac-alert-box {
    background-color: #f4f2ec; color: #222220;
  }
  body.theme-braun .clock-hero, body.theme-braun .dday-box, body.theme-braun .spec-summary-box, body.theme-braun .mac-gauge-track, body.theme-braun .hw-chip, body.theme-braun .pomo-display-wrap, body.theme-braun .pomo-status-tag {
    background-color: #f4f2ec; border-color: #222220; color: #222220;
  }
  body.theme-braun .mac-input { border-bottom-color: #222220; color: #222220; background-color: transparent; }
  body.theme-braun .dday-badge { background-color: #ea4c1d; color: #f4f2ec; }
  body.theme-braun .clock-ampm { color: #ea4c1d; }
  body.theme-braun .mac-gauge-fill {
    background-color: #ea4c1d;
    background-image: -webkit-repeating-linear-gradient(left, #ea4c1d 0px, #ea4c1d 4px, #f4f2ec 4px, #f4f2ec 6px);
  }
  body.theme-braun .mac-btn {
    background-color: #f4f2ec; color: #222220; border: 2px solid #222220;
    -webkit-box-shadow: 2px 2px 0px #222220; box-shadow: 2px 2px 0px #222220;
  }
  body.theme-braun .mac-btn:hover, body.theme-braun .dog-ear-btn:hover { background-color: #ea4c1d; color: #f4f2ec; border-color: #ea4c1d; }
  body.theme-braun .mac-btn-default { -webkit-box-shadow: 0 0 0 1px #f4f2ec, 0 0 0 4px #ea4c1d; box-shadow: 0 0 0 1px #f4f2ec, 0 0 0 4px #ea4c1d; }

  /* ==========================================================================
     Structural Layout (100% OS X 10.7/10.8 WebKit Compatible)
     ========================================================================== */
  .mac-menubar {
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 28px;
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
  .menu-apple {
    font-size: 15px;
    padding: 2px 10px;
  }

  .mac-desktop {
    position: absolute;
    top: 28px; bottom: 0; left: 0; right: 0;
    padding: 14px;
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
    margin-bottom: 14px;
    min-height: 0;
  }
  .desktop-row:last-child {
    margin-bottom: 0;
  }

  .mac-window {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-flex-direction: column;
    flex-direction: column;
    margin-right: 14px;
    position: relative;
    overflow: hidden;
  }
  .mac-window:last-child {
    margin-right: 0;
  }
  .win-flex-5 { -webkit-box-flex: 5; -webkit-flex: 5; flex: 5; }
  .win-flex-6 { -webkit-box-flex: 6; -webkit-flex: 6; flex: 6; }

  .mac-titlebar {
    height: 26px;
    min-height: 26px;
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
    -webkit-background-size: 100% 18px;
    background-size: 100% 18px;
    background-repeat: no-repeat;
    background-position: center;
  }

  .mac-close-box {
    position: absolute;
    left: 8px;
    width: 13px;
    height: 13px;
    cursor: pointer;
  }

  .mac-title-text {
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
    padding: 12px 16px;
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

  .mac-btn {
    border-radius: 5px;
    padding: 5px 10px;
    font-family: inherit;
    font-size: 11.5px;
    font-weight: 800;
    cursor: pointer;
    outline: none;
  }
  .mac-btn:active {
    -webkit-transform: translate(1px, 1px);
    transform: translate(1px, 1px);
  }

  .clock-hero {
    text-align: center;
    padding: 8px 0;
    border-width: 2px;
    border-style: solid;
  }
  .clock-time {
    font-size: 52px;
    font-weight: 900;
    letter-spacing: 2px;
    line-height: 1.05;
    font-family: "Monaco", "Courier New", monospace;
  }
  .clock-ampm {
    font-size: 17px;
    vertical-align: super;
    margin-left: 4px;
  }
  .clock-date {
    font-size: 13.5px;
    font-weight: 700;
    margin-top: 4px;
    opacity: 0.85;
  }

  .dday-box {
    margin-top: 8px;
    border-width: 1.5px;
    border-style: solid;
    padding: 8px 12px;
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
    font-size: 22px;
    font-weight: 900;
    padding: 4px 12px;
    border-radius: 3px;
    min-width: 92px;
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
    border-bottom-width: 1.5px;
    border-bottom-style: dashed;
    padding: 2px 4px;
    font-size: 12.5px;
    font-weight: 700;
    outline: none;
    margin-bottom: 4px;
  }

  .spec-summary-box {
    border-width: 1.5px;
    border-style: solid;
    padding: 7px 10px;
    margin-bottom: 8px;
    font-size: 11.5px;
    line-height: 1.48;
  }
  .spec-line {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    border-bottom: 1px dotted rgba(128,128,128,0.45);
    padding: 1.5px 0;
  }
  .spec-line:last-child {
    border-bottom: none;
  }
  .spec-key {
    font-weight: 900;
    margin-right: 8px;
    white-space: nowrap;
  }
  .spec-val {
    font-weight: 700;
    text-align: right;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .telemetry-row {
    margin-bottom: 6px;
  }
  .telemetry-label-line {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    font-size: 11px;
    font-weight: 800;
    margin-bottom: 2px;
  }
  .mac-gauge-track {
    width: 100%;
    height: 12px;
    border-width: 1.5px;
    border-style: solid;
    padding: 1.5px;
  }
  .mac-gauge-fill {
    height: 100%;
    width: 20%;
    -webkit-transition: width 0.35s ease;
    transition: width 0.35s ease;
  }

  .hw-chip-grid {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    margin-top: 4px;
  }
  .hw-chip {
    -webkit-box-flex: 1;
    -webkit-flex: 1;
    flex: 1;
    border-width: 1.5px;
    border-style: solid;
    padding: 4px 6px;
    margin-right: 6px;
    text-align: center;
  }
  .hw-chip:last-child { margin-right: 0; }
  .hw-chip-val { font-size: 14px; font-weight: 900; }
  .hw-chip-lbl { font-size: 9.5px; opacity: 0.8; }

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
    border-width: 2px;
    border-style: solid;
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
    border-width: 1.5px;
    border-style: solid;
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
    border-top: 1.5px dotted rgba(128,128,128,0.6);
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
    justify-content: space-between;
    font-size: 11.5px;
    font-weight: 700;
  }

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
    border-top-width: 1.5px;
    border-top-style: solid;
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
  }
  .dog-ear-btn {
    position: absolute;
    bottom: 0; left: 0;
    width: 28px; height: 28px;
    border-right-width: 2px;
    border-right-style: solid;
    border-top-width: 2px;
    border-top-style: solid;
    cursor: pointer;
    text-align: center;
    line-height: 24px;
    font-size: 14px;
    font-weight: 900;
  }

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
    width: 460px;
    border-width: 3px;
    border-style: double;
    -webkit-box-shadow: 6px 6px 0px #000000;
    box-shadow: 6px 6px 0px #000000;
    padding: 18px 22px;
  }
  .mac-alert-row {
    display: -webkit-box;
    display: -webkit-flex;
    display: flex;
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
    align-items: flex-start;
    margin-bottom: 14px;
  }
  .happy-mac-ascii {
    width: 52px;
    height: 58px;
    border-width: 2px;
    border-style: solid;
    border-radius: 4px;
    margin-right: 16px;
    text-align: center;
    padding-top: 8px;
    font-weight: 900;
    font-size: 14px;
    line-height: 1.2;
  }
</style>
</head>
<body class="theme-bw">

<!-- 1984 System 1.0 Menu Bar (OS X 10.8.5 폰트 깨짐 없는 순정 기호 적용) -->
<div class="mac-menubar">
  <div class="menu-left">
    <div class="menu-item menu-apple" id="menuAbout" title="About This Macintosh">&#63743;</div>
    <div class="menu-item active-menu" id="menuThemeBW" title="1984 오리지널 1-Bit 흑백 모드">1984 B&amp;W</div>
    <div class="menu-item" id="menuThemeAmber" title="1984 호박색 CRT 모니터">Amber CRT</div>
    <div class="menu-item" id="menuThemeGreen" title="Apple II 그린 모니터">Green CRT</div>
    <div class="menu-item" id="menuThemeBraun" title="디터 람스 브라운 탁상시계 테마">Braun Edition</div>
    <div class="menu-item" id="menuSoundToggle" title="1984 사각파 비프음 및 차임벨 켜기/끄기">&#9835; Sound: ON</div>
    <div class="menu-item" id="menuFullScreen" title="전체 화면 오브제 모드 전환 (Cmd + F)">[ ] Fullscreen</div>
  </div>
  <div class="menu-right">
    <span id="menubarModelBadge" style="margin-right: 14px; font-size: 12px;">Macintosh</span>
    <span id="menubarMiniStat" style="margin-right: 14px; font-size: 12px;">CPU 0%</span>
    <span id="menubarClock">00:00:00</span>
  </div>
</div>

<!-- System 1.0 Desktop Workspace -->
<div class="mac-desktop">
  <div class="desktop-row">
    <!-- DA 1: 1984 Master Clock & D-Day -->
    <div class="mac-window win-flex-5">
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

    <!-- DA 2: Machine Specs & Real-Time Telemetry -->
    <div class="mac-window win-flex-6">
      <div class="mac-titlebar">
        <div class="mac-close-box" id="btnRefreshHW" title="하드웨어 센서 및 디스크 정보 즉시 갱신"></div>
        <span class="mac-title-text">About This Mac &amp; System Telemetry</span>
      </div>
      <div class="mac-win-body">
        <div class="spec-summary-box">
          <div class="spec-line">
            <span class="spec-key">&#9632; MODEL</span>
            <span class="spec-val" id="specModelName">Detecting Mac Model...</span>
          </div>
          <div class="spec-line">
            <span class="spec-key">&#9670; CPU</span>
            <span class="spec-val" id="specCpuName">Detecting Processor...</span>
          </div>
          <div class="spec-line">
            <span class="spec-key">&#63743; SYSTEM OS</span>
            <span class="spec-val" id="specOsVersion">Detecting macOS...</span>
          </div>
          <div class="spec-line">
            <span class="spec-key">&#9635; STARTUP DISK</span>
            <span class="spec-val" id="specDiskName">Macintosh HD</span>
          </div>
        </div>

        <div class="telemetry-row">
          <div class="telemetry-label-line">
            <span>CPU LOAD &amp; MEMORY (RAM)</span>
            <span id="lblCpuAndRam">CPU 0% · RAM 0 / 0 MB</span>
          </div>
          <div class="mac-gauge-track"><div class="mac-gauge-fill" id="barCpuLoad" style="width:8%;"></div></div>
        </div>

        <div class="telemetry-row">
          <div class="telemetry-label-line">
            <span id="lblBatteryTitle">BATTERY / POWER SOURCE</span>
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
            <div class="hw-chip-val" id="valRamPct">-- %</div>
            <div class="hw-chip-lbl">RAM IN USE</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="desktop-row">
    <!-- DA 3: Pomodoro Focus Timer -->
    <div class="mac-window win-flex-5">
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
          <button class="mac-btn mac-btn-default" id="btnPomoStart">&#9654; START</button>
          <button class="mac-btn" id="btnPomoReset">&#8634; RESET</button>
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
    <div class="mac-window win-flex-6">
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

<div class="mac-modal-backdrop" id="aboutModal">
  <div class="mac-alert-box">
    <div class="mac-alert-row">
      <div class="happy-mac-ascii">^_^<br>&#9600;&#9600;</div>
      <div style="width:100%;">
        <div style="font-weight:900; font-size:15px; margin-bottom:8px;">About This Macintosh (Macintosh 1984)</div>
        <div style="font-size:12px; line-height:1.65; border-top:1px solid #888888; padding-top:6px;">
          • <b>모델명:</b> <span id="modalModelName">-</span><br>
          • <b>프로세서:</b> <span id="modalCpuName">-</span><br>
          • <b>운영체제:</b> <span id="modalOsVersion">-</span><br>
          • <b>시동 디스크:</b> <span id="modalDiskName">-</span><br>
          • <b>설치된 메모리:</b> <span id="modalRamTotal">-</span>
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
    this.innerHTML = state.soundEnabled ? '&#9835; Sound: ON' : '&#9835; Sound: OFF';
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

  function pollHardwareTelemetry() {
    if (!hasNative()) return;
    try {
      var raw = window.NativeBridge.getHardwareTelemetryJSON();
      var hw = JSON.parse(raw);

      var modelDisplay = hw.modelDisplay || 'Macintosh';
      var cpuDisplay = hw.cpuBrand || 'Intel Processor';
      var osDisplay = hw.osDisplay || 'Mac OS X';
      var diskDisplay = (hw.diskName || 'Macintosh HD') + ' (여유 ' + hw.diskFreeGB + 'GB / 전체 ' + hw.diskTotalGB + 'GB)';

      document.getElementById('specModelName').innerHTML = modelDisplay;
      document.getElementById('specCpuName').innerHTML = cpuDisplay;
      document.getElementById('specOsVersion').innerHTML = osDisplay;
      document.getElementById('specDiskName').innerHTML = diskDisplay;

      document.getElementById('menubarModelBadge').innerHTML = hw.shortModel || 'Macintosh';

      document.getElementById('modalModelName').innerHTML = modelDisplay;
      document.getElementById('modalCpuName').innerHTML = cpuDisplay;
      document.getElementById('modalOsVersion').innerHTML = osDisplay;
      document.getElementById('modalDiskName').innerHTML = diskDisplay;
      document.getElementById('modalRamTotal').innerHTML = hw.ramTotalMB + ' MB (' + Math.round(hw.ramTotalMB / 1024) + ' GB)';

      var cpu = hw.cpuLoad || 0;
      document.getElementById('lblCpuAndRam').innerHTML =
        'CPU ' + cpu + '%  |  RAM ' + hw.ramUsedMB + ' / ' + hw.ramTotalMB + ' MB';
      document.getElementById('barCpuLoad').style.width = Math.max(4, Math.min(100, cpu)) + '%';

      document.getElementById('menubarMiniStat').innerHTML =
        'CPU ' + cpu + '% · ' + (hw.cpuTemp > 0 ? (hw.cpuTemp + '°C') : ('RAM ' + hw.ramPct + '%'));

      document.getElementById('lblBattery').innerHTML = hw.batteryPct + '% (' + hw.powerSource + ')';
      document.getElementById('barBattery').style.width = Math.max(4, Math.min(100, hw.batteryPct)) + '%';

      document.getElementById('valCpuTemp').innerHTML = hw.cpuTemp > 0 ? (hw.cpuTemp + ' °C') : 'N/A';
      document.getElementById('valFanRpm').innerHTML = hw.fanRpm > 0 ? (hw.fanRpm + ' RPM') : 'Quiet';
      document.getElementById('valRamPct').innerHTML = hw.ramPct + ' %';
    } catch (e) {}
  }

  document.getElementById('btnRefreshHW').onclick = function () {
    playSound('click');
    pollHardwareTelemetry();
  };

  function renderPomodoro() {
    var mins = Math.floor(state.pomoRemainSecs / 60);
    var secs = state.pomoRemainSecs % 60;
    document.getElementById('pomoDigits').innerHTML =
      ('0' + mins).slice(-2) + ':' + ('0' + secs).slice(-2);

    var tag = document.getElementById('pomoStatusTag');
    tag.innerHTML = (state.pomoRunning ? '&#9679; RUNNING — ' : '|| PAUSED — ') + state.pomoModeLabel;
    document.getElementById('btnPomoStart').innerHTML = state.pomoRunning ? '|| PAUSE' : '&#9654; START';

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

  document.onkeydown = function (e) {
    var tag = (e.target || e.srcElement).tagName;
    var inInput = (tag === 'INPUT' || tag === 'TEXTAREA');
    var key = e.keyCode || e.which;

    if ((e.metaKey || e.ctrlKey) && key === 70) {
      e.preventDefault();
      if (hasNative()) window.NativeBridge.toggleFullscreen();
      return;
    }
    if (!inInput && key === 32) {
      e.preventDefault();
      togglePomoRun();
    }
  };

  window.onload = function () {
    loadStateFromNative();
    elDdayTitle.value = state.ddayTitle;
    elDdayDate.value = state.ddayDate;
    document.getElementById('menuSoundToggle').innerHTML = state.soundEnabled ? '&#9835; Sound: ON' : '&#9835; Sound: OFF';
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

# 3. Objective-C Cocoa + IOKit 브릿지 (SMC keyInfo.dataSize 보존 버그 수정 + MacBookAir7,2 등 모델 매핑 추가)
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
#include <stdlib.h>

#ifndef NSWindowStyleMaskTitled
#define NSWindowStyleMaskTitled (1 << 0)
#define NSWindowStyleMaskClosable (1 << 1)
#define NSWindowStyleMaskMiniaturizable (1 << 2)
#define NSWindowStyleMaskResizable (1 << 3)
#endif

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

// 핵심 수정: kSMCReadKey 호출 후 드라이버가 outVal->keyInfo를 0으로 초기화하는 문제를 막기 위해
// kSMCGetKeyInfo에서 얻은 dataSize와 dataType을 outVal에 다시 복원!
static BOOL readSMCKeyRaw(io_connect_t conn, const char *keyStr, SMCKeyData_t *outVal) {
    if (!conn) return NO;
    SMCKeyData_t inStruct;
    SMCKeyData_t infoStruct;
    memset(&inStruct, 0, sizeof(SMCKeyData_t));
    memset(&infoStruct, 0, sizeof(SMCKeyData_t));
    memset(outVal, 0, sizeof(SMCKeyData_t));

    inStruct.key = fourCharToUInt32(keyStr);
    inStruct.data8 = 9; // kSMCGetKeyInfo
    size_t outSize = sizeof(SMCKeyData_t);
    kern_return_t kr = IOConnectCallStructMethod(conn, 2, &inStruct, sizeof(SMCKeyData_t), &infoStruct, &outSize);
    if (kr != kIOReturnSuccess || infoStruct.keyInfo.dataSize == 0) return NO;

    inStruct.keyInfo.dataSize = infoStruct.keyInfo.dataSize;
    inStruct.data8 = 5; // kSMCReadKey
    outSize = sizeof(SMCKeyData_t);
    kr = IOConnectCallStructMethod(conn, 2, &inStruct, sizeof(SMCKeyData_t), outVal, &outSize);
    if (kr != kIOReturnSuccess) return NO;

    outVal->keyInfo.dataSize = infoStruct.keyInfo.dataSize;
    outVal->keyInfo.dataType = infoStruct.keyInfo.dataType;
    return YES;
}

static int readSMCCpuTemperature(io_connect_t conn) {
    const char *tempKeys[] = { "TC0D", "TC0P", "TC0E", "TC0F", "TC0H", "TCXC", "Tp0P", "TW0P", NULL };
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
        if (val.keyInfo.dataSize == 4 && val.keyInfo.dataType == fourCharToUInt32("flt ")) {
            float fval = 0.0f;
            memcpy(&fval, val.bytes, 4);
            int rpm = (int)(fval + 0.5f);
            if (rpm >= 400 && rpm <= 8000) return rpm;
        } else {
            uint16_t raw = ((uint8_t)val.bytes[0] << 8) | (uint8_t)val.bytes[1];
            int rpm = (int)(raw >> 2);
            if (rpm >= 400 && rpm <= 8000) return rpm;
        }
    }
    return 0;
}

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

    NSString *cachedCpuBrand;
    NSString *cachedModelDisplay;
    NSString *cachedShortModel;
    NSString *cachedOsDisplay;
}
@end

@implementation Mac1984Controller

- (void)initStaticSystemSpecs {
    char cpuBuf[256] = {0};
    size_t cpuLen = sizeof(cpuBuf) - 1;
    NSString *rawCpu = @"Intel Processor";
    if (sysctlbyname("machdep.cpu.brand_string", cpuBuf, &cpuLen, NULL, 0) == 0 && strlen(cpuBuf) > 0) {
        rawCpu = [NSString stringWithUTF8String:cpuBuf];
    }
    rawCpu = [rawCpu stringByReplacingOccurrencesOfString:@"(R)" withString:@""];
    rawCpu = [rawCpu stringByReplacingOccurrencesOfString:@"(TM)" withString:@""];
    rawCpu = [rawCpu stringByReplacingOccurrencesOfString:@"CPU " withString:@""];
    while ([rawCpu rangeOfString:@"  "].location != NSNotFound) {
        rawCpu = [rawCpu stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    rawCpu = [rawCpu stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    int cores = 0;
    size_t coreLen = sizeof(cores);
    sysctlbyname("hw.physicalcpu", &cores, &coreLen, NULL, 0);
    if (cores > 0) {
        cachedCpuBrand = [[NSString stringWithFormat:@"%@ (%dC)", rawCpu, cores] retain];
    } else {
        cachedCpuBrand = [rawCpu retain];
    }

    char modBuf[128] = {0};
    size_t modLen = sizeof(modBuf) - 1;
    NSString *hwModel = @"Macintosh";
    if (sysctlbyname("hw.model", modBuf, &modLen, NULL, 0) == 0 && strlen(modBuf) > 0) {
        hwModel = [NSString stringWithUTF8String:modBuf];
    }

    NSDictionary *modelMap = [NSDictionary dictionaryWithObjectsAndKeys:
        @"A1181 · MacBook (13-inch, 2006)", @"MacBook1,1",
        @"A1181 · MacBook (13-inch, Late 2006 / Mid 2007)", @"MacBook2,1",
        @"A1181 · MacBook (13-inch, Late 2007)", @"MacBook3,1",
        @"A1181 · MacBook (13-inch, Early/Late 2008)", @"MacBook4,1",
        @"A1181 · MacBook (13-inch, Early/Mid 2009)", @"MacBook5,2",
        @"A1342 · MacBook (13-inch, Late 2009)", @"MacBook6,1",
        @"A1342 · MacBook (13-inch, Mid 2010)", @"MacBook7,1",
        @"A1466 · MacBook Air (13-inch, Early 2015 / 2017)", @"MacBookAir7,2",
        @"A1398 · MacBook Pro (15-inch, Late 2013 / Mid 2014)", @"MacBookPro11,2",
        @"A1398 · MacBook Pro (15-inch, Late 2013 / Mid 2014)", @"MacBookPro11,3",
        @"A1398 · MacBook Pro (Retina, 15-inch, Mid 2015)", @"MacBookPro11,4",
        @"A1398 · MacBook Pro (Retina, 15-inch, Mid 2015)", @"MacBookPro11,5",
        @"A1502 · MacBook Pro (Retina, 13-inch, Early 2015)", @"MacBookPro12,1",
        @"A2141 · MacBook Pro (16-inch, 2019)", @"MacBookPro16,1",
        @"A2141 · MacBook Pro (16-inch, 2019)", @"MacBookPro16,4",
        nil];

    NSString *mapped = [modelMap objectForKey:hwModel];
    if (mapped) {
        cachedModelDisplay = [[NSString stringWithFormat:@"%@ [%@]", mapped, hwModel] retain];
        cachedShortModel = [[[mapped componentsSeparatedByString:@" · "] objectAtIndex:0] retain];
    } else if ([hwModel hasPrefix:@"MacBook1,"] || [hwModel hasPrefix:@"MacBook2,"] ||
               [hwModel hasPrefix:@"MacBook3,"] || [hwModel hasPrefix:@"MacBook4,"] || [hwModel isEqualToString:@"MacBook5,2"]) {
        cachedModelDisplay = [[NSString stringWithFormat:@"A1181 · MacBook [%@]", hwModel] retain];
        cachedShortModel = [@"A1181" retain];
    } else {
        cachedModelDisplay = [hwModel retain];
        cachedShortModel = [hwModel retain];
    }

    NSDictionary *sysVer = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    NSString *prodName = sysVer ? [sysVer objectForKey:@"ProductName"] : @"Mac OS X";
    NSString *verStr = sysVer ? [sysVer objectForKey:@"ProductUserVisibleVersion"] : @"10.8";
    NSString *buildStr = sysVer ? [sysVer objectForKey:@"ProductBuildVersion"] : @"";
    if (!prodName) prodName = @"Mac OS X";
    if (!verStr) verStr = @"10.8";

    NSString *codeName = @"";
    if ([verStr hasPrefix:@"10.6"]) codeName = @"Snow Leopard";
    else if ([verStr hasPrefix:@"10.7"]) codeName = @"Lion";
    else if ([verStr hasPrefix:@"10.8"]) codeName = @"Mountain Lion";
    else if ([verStr hasPrefix:@"10.9"]) codeName = @"Mavericks";
    else if ([verStr hasPrefix:@"10.10"]) codeName = @"Yosemite";
    else if ([verStr hasPrefix:@"10.11"]) codeName = @"El Capitan";
    else if ([verStr hasPrefix:@"10.12"]) codeName = @"Sierra";
    else if ([verStr hasPrefix:@"10.13"]) codeName = @"High Sierra";
    else if ([verStr hasPrefix:@"10.14"]) codeName = @"Mojave";
    else if ([verStr hasPrefix:@"10.15"]) codeName = @"Catalina";
    else if ([verStr hasPrefix:@"11."]) codeName = @"Big Sur";
    else if ([verStr hasPrefix:@"12."]) codeName = @"Monterey";
    else if ([verStr hasPrefix:@"13."]) codeName = @"Ventura";
    else if ([verStr hasPrefix:@"14."]) codeName = @"Sonoma";
    else if ([verStr hasPrefix:@"15."]) codeName = @"Sequoia";

    if ([codeName length] > 0 && [buildStr length] > 0) {
        cachedOsDisplay = [[NSString stringWithFormat:@"%@ %@ (%@ · %@)", prodName, verStr, codeName, buildStr] retain];
    } else if ([codeName length] > 0) {
        cachedOsDisplay = [[NSString stringWithFormat:@"%@ %@ (%@)", prodName, verStr, codeName] retain];
    } else {
        cachedOsDisplay = [[NSString stringWithFormat:@"%@ %@", prodName, verStr] retain];
    }
}

- (void)initRetroSounds {
    uint32_t sr = 44100;

    uint32_t cLen = (uint32_t)(sr * 0.012);
    int16_t *cBuf = (int16_t *)calloc(cLen, sizeof(int16_t));
    for (uint32_t i = 0; i < cLen; i++) {
        double t = (double)i / sr;
        cBuf[i] = (int16_t)((sin(2.0 * M_PI * 1400.0 * t) > 0 ? 1.0 : -1.0) * exp(-t * 250.0) * 9000.0);
    }
    soundClick = [[NSSound alloc] initWithData:createWAVData(cBuf, cLen, sr)];
    free(cBuf);

    uint32_t bLen = (uint32_t)(sr * 0.09);
    int16_t *bBuf = (int16_t *)calloc(bLen, sizeof(int16_t));
    for (uint32_t i = 0; i < bLen; i++) {
        double t = (double)i / sr;
        double sq = sin(2.0 * M_PI * 880.0 * t) >= 0 ? 1.0 : -1.0;
        bBuf[i] = (int16_t)(sq * exp(-t * 14.0) * 10000.0);
    }
    soundBeep = [[NSSound alloc] initWithData:createWAVData(bBuf, bLen, sr)];
    free(bBuf);

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
        [self initStaticSystemSpecs];
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

    int cpuTemp = readSMCCpuTemperature(smcConn);
    int fanRpm = readSMCFanRPM(smcConn);

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *diskName = [fm displayNameAtPath:@"/"];
    if (!diskName || [diskName length] == 0) diskName = @"Macintosh HD";

    NSDictionary *fsAttrs = [fm attributesOfFileSystemForPath:@"/" error:nil];
    unsigned long long freeBytes = fsAttrs ? [[fsAttrs objectForKey:NSFileSystemFreeSize] unsignedLongLongValue] : 0;
    unsigned long long totalBytes = fsAttrs ? [[fsAttrs objectForKey:NSFileSystemSize] unsignedLongLongValue] : 0;
    int diskFreeGB = (int)(freeBytes / (1024ULL * 1024ULL * 1024ULL));
    int diskTotalGB = (int)(totalBytes / (1024ULL * 1024ULL * 1024ULL));

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
        cachedModelDisplay ? cachedModelDisplay : @"Macintosh", @"modelDisplay",
        cachedShortModel ? cachedShortModel : @"Macintosh", @"shortModel",
        cachedCpuBrand ? cachedCpuBrand : @"Intel Processor", @"cpuBrand",
        cachedOsDisplay ? cachedOsDisplay : @"Mac OS X", @"osDisplay",
        [diskName precomposedStringWithCanonicalMapping], @"diskName",
        [NSNumber numberWithInt:cpuLoadPct], @"cpuLoad",
        [NSNumber numberWithInt:ramUsedMB], @"ramUsedMB",
        [NSNumber numberWithInt:ramTotalMB], @"ramTotalMB",
        [NSNumber numberWithInt:ramPct], @"ramPct",
        [NSNumber numberWithInt:batteryPct], @"batteryPct",
        powerSrc, @"powerSource",
        [NSNumber numberWithInt:cpuTemp], @"cpuTemp",
        [NSNumber numberWithInt:fanRpm], @"fanRpm",
        [NSNumber numberWithInt:diskFreeGB], @"diskFreeGB",
        [NSNumber numberWithInt:diskTotalGB], @"diskTotalGB",
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
    window = [[NSWindow alloc] initWithContentRect:NSMakeRect(80, 80, 1020, 650)
                                         styleMask:style
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [window setTitle:@"Macintosh 1984"];
    [window setMinSize:NSMakeSize(800, 520)];
    [window setCollectionBehavior:(1 << 7)];
    [window setDelegate:self];

    NSView *content = [window contentView];
    webView = [[WebView alloc] initWithFrame:[content bounds] frameName:@"Mac1984Frame" groupName:@"Mac1984Group"];
    [webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [webView setFrameLoadDelegate:self];

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"mac1984" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:[htmlPath stringByDeletingLastPathComponent]];
    [[webView mainFrame] loadHTMLString:(htmlStr ? htmlStr : @"") baseURL:baseURL];

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

bin_file = os.path.join(macos_dir, "Macintosh 1984")

subprocess.run([
    "clang", "-arch", "x86_64", "-mmacosx-version-min=10.7",
    "-fno-objc-arc", "-Wno-deprecated-declarations", "-O2",
    "-Wl,-flat_namespace", "-Wl,-w",
    src_file,
    "-framework", "Cocoa", "-framework", "WebKit", "-framework", "IOKit",
    "-o", bin_file
], check=True)
os.chmod(bin_file, 0o755)

# 4. Info.plist 생성
plist_dict = {
    "CFBundleExecutable": "Macintosh 1984",
    "CFBundleIconFile": "Macintosh1984.icns",
    "CFBundleIconName": "Macintosh1984",
    "CFBundleIdentifier": "com.soohyun.macintosh1984",
    "CFBundleName": "Macintosh 1984",
    "CFBundleDisplayName": "Macintosh 1984",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": "1.3",
    "CFBundleVersion": "4",
    "LSMinimumSystemVersion": "10.7",
    "NSHighResolutionCapable": True
}
with open(os.path.join(contents_dir, "Info.plist"), "wb") as fp:
    plistlib.dump(plist_dict, fp)

# 5. 아이콘 컴파일 및 각인
iconset_dir = "/tmp/Macintosh1984.iconset"
master_png = "/tmp/mac1984_1024.png"
if os.path.exists("/tmp/gen_mac1984_icon") and os.path.exists(master_png):
    subprocess.run(["/tmp/gen_mac1984_icon", master_png, app_path], check=True)
    subprocess.run(["iconutil", "-c", "icns", iconset_dir, "-o", os.path.join(res_dir, "Macintosh1984.icns")], check=True)

subprocess.run(["xattr", "-cr", app_path], check=False)
subprocess.run(["codesign", "--force", "--deep", "--identifier", "com.soohyun.macintosh1984", "--sign", "-", app_path], check=False)
if os.path.exists("/tmp/gen_mac1984_icon"):
    subprocess.run(["/tmp/gen_mac1984_icon", master_png, app_path], check=True)

subprocess.run(["ditto", app_path, installed_app], check=True)
if os.path.exists("/tmp/gen_mac1984_icon"):
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
if os.path.exists("/tmp/gen_mac1984_icon"):
    subprocess.run(["/tmp/gen_mac1984_icon", master_png, dmg_path], check=False)

shutil.rmtree(stage_dir)
print("✅ [Macintosh 1984] v1.3 (OS X 10.8.5 음영/테두리 복구 + SMC 센서 패치) 완료!")
subprocess.run(["open", installed_app])
PYEOF
python3 /tmp/build_macintosh_1984_v13.py
