# PC Information Logger

Professional, portable Windows batch utility to collect PC name, BIOS serial number, and system model, then append results to a daily, human-readable log file.

## Features

- Collects PC name, serial number, and model via PowerShell CIM (Windows 10/11 supported).
- Creates a daily log file with aligned columns and a running total.
- Appends new entries without overwriting prior data.
- Designed for use from a USB drive or shared folder.

## Requirements

- Windows 10/11
- PowerShell available (default on Windows)

## Quick Start

1. Copy the project files to the USB root folder.
2. Double-click extract_pc_info.bat.
3. Review the console output and the generated log file.

## Output

A daily log file is created in the same folder:

- pc_info_log_DD-MM-YYYY.txt

The log contains:

- A professional header
- Total PCs counter
- Aligned table of results (Date, Time, PC Name, Serial Number, Model)

## Notes

- USB autorun is disabled by Windows for security; the script must be launched manually.
- Some devices may not expose serial/model values; in that case the fields may show N/A.

## Troubleshooting

- If serial/model is N/A, run the script as an administrator and try again.
- Some manufacturers do not populate BIOS serial or model fields.

## Project Files

- extract_pc_info.bat: main script
- autorun.inf: informational only (Windows ignores USB autorun)

## License

Internal use. Replace with your preferred license if distributing.
