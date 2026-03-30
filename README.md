# VS Code for Dart In-Class Tests

A portable VS Code with Dart SDK bundled for in-class programming tests.
Windows 11 only.

## Quick Setup

1. Open the start menu, search for "PowerShell"
1. Open PowerShell, copy the command below (Ctrl+C), paste it in there (Ctrl+V) and press enter:

   ```plaintext
   irm https://raw.githubusercontent.com/manighahrmani/dart_inclass_test_vscode/main/install.ps1 | iex
   ```

1. Wait for the script to download, extract and launch VS Code.
   This is done automatically but it might take a few minutes.
1. Once VS Code launches, click "Trust" if prompted about trusting the folder.
1. Read the instructions in the comments of `main.dart` to get started.
   Wait a few seconds for the start button to appear.

## Minimal Package (Faster)

A smaller download (~237 MB vs ~295 MB) with faster extraction.
Same functionality, just stripped of unused components.

```plaintext
irm https://raw.githubusercontent.com/manighahrmani/dart_inclass_test_vscode/main/install_minimal.ps1 | iex
```

## Manual Setup

1. Download `dart_inclass_test.zip` (or `dart_inclass_test_minimal.zip`)
   from [Releases](https://github.com/manighahrmani/dart_inclass_test_vscode/releases/latest)
1. Extract the zip to your Desktop
1. Double-click `DOUBLE_CLICK_ME_TO_START_TEST.bat`
