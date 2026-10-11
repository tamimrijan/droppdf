# OpenDataLoader PDF Easy Tools

Two small Windows `.bat` files that make [OpenDataLoader PDF](https://opendataloader.org/docs/quick-start-python) super easy to use. No typing long commands. Just double click, drag in a PDF, pick a format, done.

![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-blue)
![Python](https://img.shields.io/badge/python-3.10%2B-yellow)
![Java](https://img.shields.io/badge/java-11%2B-orange)
![Made by](https://img.shields.io/badge/made%20by-Tamim-ff69b4)

---

## What is this?

OpenDataLoader PDF is a PDF parser that turns PDFs into clean, AI-ready data (Markdown, JSON, text, HTML). It's great, but the normal way to use it means opening a terminal and typing commands every time.

These two files fix that:

| File | What it does | How often |
| --- | --- | --- |
| `install_opendataloader.bat` | Checks your system, then installs `opendataloader-pdf` | **One time only** |
| `pdf_convert.bat` | Converts your PDFs with a colorful, menu-based CLI | Every time you need it |

---

## Features

- Drag and drop a PDF (or paste the path) and pick a format from a menu
- Output formats: **Markdown, JSON, Text, HTML**, Markdown + JSON, or everything at once
- Shows the exact command it runs, like a CLI agent
- Colored terminal UI with clear `[+]`, `[*]`, `[x]` status lines
- Shows how long the conversion took and lists the output files
- After converting you can: open the output folder, convert again, go back to the main menu, or close
- The installer checks **Python 3.10+** and **Java 11+** first, and explains how to install them if they are missing
- Supports dropping multiple PDFs at once (they convert in one run, which is faster)

---

## Requirements

- Windows 10 or 11 (colors need a terminal that supports ANSI, Windows Terminal is best)
- Python 3.10 or later
- Java 11 or later, available on your system `PATH`

Don't have them? No worries. The installer tells you exactly what's missing and how to get it.

---

## Quick start

### 1. First time only: run the installer

Double click `install_opendataloader.bat`.

It will:

1. Check that Python 3.10+ is installed
2. Check that Java 11+ is on your PATH
3. Run `python -m pip install -U opendataloader-pdf`
4. Tell you when it's ready

> This only needs to run **once**. From the next time, just use `pdf_convert.bat`.

### 2. Convert PDFs

You can use `pdf_convert.bat` in two ways:

**Option A: drag and drop onto the file**
Drag your PDF onto `pdf_convert.bat` in File Explorer. It skips straight to the format menu.

**Option B: double click**
Double click `pdf_convert.bat`, then drag your PDF into the terminal window (or paste the full path) and press Enter.

Then pick a format:

```
1  Markdown         clean text, best for reading
2  JSON             full structure, headings, tables
3  Text             plain text only
4  HTML             web page version
5  Markdown + JSON  both in one go
6  Everything       json, html, pdf, markdown
```

Your files are saved in an `output` folder **next to your PDF**.

### 3. What next?

After a conversion you get a small menu:

```
1  Open output folder
2  Convert again       same PDF, pick another format
3  Main menu           start over with a new PDF
*  Any other key       close the terminal
```

---

## Preview

```
  +----------------------------------------------------------+
  |   OpenDataLoader PDF  //  converter agent                |
  |   pdf in, clean data out                                 |
  +----------------------------------------------------------+

 [*] Checking environment...
 [+] Java found
 [+] opendataloader-pdf found

 [?] Which PDF? drag it into this window or paste the path, then Enter

 >
```
<img width="1290" height="541" alt="image" src="https://github.com/user-attachments/assets/bd055bbb-538e-4551-a2a7-bcbd41b3c8a6" />

> Tip: add a real screenshot here later with `![screenshot](screenshot.png)`.

---

## How it works

The converter is just a friendly wrapper around the official command:

```
opendataloader-pdf mypaper.pdf -o output/ -f markdown
```

The installer is a friendly wrapper around:

```
python -m pip install -U opendataloader-pdf
```

Nothing is hidden. The commands are printed on screen every time.

---
## "Publisher could not be verified" warning

When you open the `.bat` files, Windows may show a security warning like this:

> **Open File - Security Warning**
> The publisher could not be verified. Are you sure you want to run this software?

**Don't worry, this is normal.** Windows shows it for every file that is not digitally signed, and signing costs money, so most small open-source tools don't have it. It doesn't mean the file is a virus.

**Why it happens**
- The `.bat` files are plain script files, not signed by a company
- They were downloaded from the internet, so Windows asks before running them

**What you can do**
1. **Read the code first.** A `.bat` file is just text. Right click it, choose **Edit** (or open it in Notepad), and check what it does. Nothing is hidden.
2. Only download the files from this official repo: https://github.com/tamimrijan/droppdf
3. Click **Run** to continue.
4. Don't want to see this warning every time? Untick **Always ask before opening this file** before clicking Run.

**If you see a blue "Windows protected your PC" screen instead**
Click **More info**, then **Run anyway**.

> What these files do: `install_opendataloader.bat` checks Python and Java and runs `python -m pip install -U opendataloader-pdf`. `pdf_convert.bat` runs `opendataloader-pdf` on the PDF you choose. That's it.

---

## Troubleshooting

**"Java not found"**
Install a JDK 11 or newer from [Adoptium](https://adoptium.net/). The installer adds Java to PATH automatically. Close and reopen the terminal, then check with `java -version`.
If it still fails, add this folder to your system PATH manually:
`C:\Program Files\Eclipse Adoptium\jdk-<version>\bin`

**"Python not found"**
Get Python 3.10+ from [python.org](https://www.python.org/downloads/) and tick **Add python.exe to PATH** in the installer.

**"opendataloader-pdf command not found" after installing**
Close the terminal and open a new one. If it still fails, add your Python `Scripts` folder to PATH.

**Drag and drop onto the .bat does nothing**
Windows blocks drag and drop between admin and normal apps. Don't run as admin, or just use Option B (double click, then drag the PDF into the terminal window).
Also check: right click the .bat, open Properties, and tick **Unblock** if you see it.

**Weird symbols like `←[96m` on screen**
Your terminal doesn't support colors. Open the .bat in Windows Terminal.

**Scanned PDFs (images only) give bad text**
The normal mode reads real text, not images. For scanned PDFs you need the hybrid mode with OCR, see the [official docs](https://opendataloader.org/docs/quick-start-python).

---

## Project structure

```
.
├── install_opendataloader.bat   # run once
├── pdf_convert.bat              # use every time
└── README.md
```

---

## Credits

- Created and maintained by **Tamim** (me) 😜
- Built on top of [OpenDataLoader PDF](https://github.com/opendataloader-project/opendataloader-pdf) (Apache-2.0). This project is not affiliated with the OpenDataLoader team, it's just a small helper to make it easier to use.
- Official docs: https://opendataloader.org/docs/quick-start-python

---

## Contributing

Found a bug or have an idea? Open an issue or send a pull request. Ideas welcome: page range option, image on/off toggle, batch folder mode.
