# LV_Colors - ListView Color Control Class (AHK v2)

A powerful AutoHotkey v2 class for setting individual colors for rows and cells in ListView controls.

[![AHK Version](https://img.shields.io/badge/AHK-v2.0+-blue.svg)](https://www.autohotkey.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- 🎨 **Row Coloring** - Set background and text colors for specific rows
- 📊 **Cell Coloring** - Set custom colors for individual cells
- 🔄 **Alternate Row/Column Colors** - Automatically create zebra-striped patterns
- ✅ **Selection Colors** - Customize colors for selected items
- 🚫 **Prevent Sorting** - Optionally disable column sorting
- 📏 **Prevent Resizing** - Optionally disable column resizing
- 🎯 **Static Mode** - Colors follow content instead of row numbers

## 📦 Installation

1. Download `LV_Colors.ahk`
2. Place the file in your project directory or AutoHotkey Lib folder
3. Include it in your script:
```ahk
#Include LV_Colors.ahk
```

## 🚀 Quick Start

### Basic Example
```ahk
#Requires AutoHotkey v2.0

#Include LV_Colors.ahk

; Create GUI and ListView
myGui := Gui()
LV := myGui.Add("ListView", "w600 h400", ["Name", "Age", "City"])

; Add data
LV.Add(, "John", "25", "New York")
LV.Add(, "Jane", "30", "Los Angeles")
LV.Add(, "Bob", "28", "Chicago")
LV.Add(, "Alice", "35", "Houston")

; Create LV_Colors instance
CLV := LV_Colors(LV.Hwnd)

; Set alternate row colors (zebra stripes)
CLV.AlternateRows(0xF0F0F0)

; Set specific row color
CLV.Row(2, 0xFFE6E6)  ; Row 2 with light red background

; Set specific cell color
CLV.Cell(3, 2, 0xE6FFE6, 0x008000)  ; Row 3, Col 2: light green bg, dark green text

; Set selection colors
CLV.SelectionColors(0x0000FF, 0xFFFFFF)  ; Blue background, white text

myGui.Show()
```

## 📖 Documentation

### Constructor
```ahk
CLV := LV_Colors(HWND, StaticMode := false, NoSort := false, NoSizing := false)
```

**Parameters:**
- `HWND` - Handle to the ListView control
- `StaticMode` - Enable static mode (colors follow content)
- `NoSort` - Disable column sorting
- `NoSizing` - Disable column resizing

### Main Methods

#### AlternateRows(BkColor, TxColor)
Set background and text colors for even-numbered rows
```ahk
; Even rows with light gray background
CLV.AlternateRows(0xF0F0F0)

; Even rows with light yellow background and dark blue text
CLV.AlternateRows(0xFFFFE0, 0x000080)
```

#### AlternateCols(BkColor, TxColor)
Set background and text colors for even-numbered columns
```ahk
; Even columns with light blue background
CLV.AlternateCols(0xFFF0E0)
```

#### Row(Row, BkColor, TxColor)
Set colors for a specific row
```ahk
; Row 1 with red background
CLV.Row(1, 0xFF0000)

; Row 2 with green background and white text
CLV.Row(2, 0x00FF00, 0xFFFFFF)

; Row 3 with blue text only
CLV.Row(3, , 0x0000FF)
```

#### Cell(Row, Col, BkColor, TxColor)
Set colors for a specific cell
```ahk
; Row 1, Col 2: yellow background
CLV.Cell(1, 2, 0xFFFF00)

; Row 3, Col 1: red background, white text
CLV.Cell(3, 1, 0xFF0000, 0xFFFFFF)
```

#### SelectionColors(BkColor, TxColor)
Set colors for selected rows
```ahk
; Selected items show blue background with white text
CLV.SelectionColors(0x0000FF, 0xFFFFFF)
```

#### Clear(AltRows, AltCols)
Clear all color settings
```ahk
; Clear all colors
CLV.Clear()

; Clear all colors including alternate row/column settings
CLV.Clear(true, true)
```

#### NoSort(Apply)
Enable/disable column sorting
```ahk
CLV.NoSort(true)   ; Disable sorting
CLV.NoSort(false)  ; Enable sorting
```

#### NoSizing(Apply)
Enable/disable column resizing
```ahk
CLV.NoSizing(true)   ; Disable resizing
CLV.NoSizing(false)  ; Enable resizing
```

## 🎨 Color Formats

Colors can be specified in the following formats:

### RGB Integer Format
```ahk
0xFF0000  ; Red
0x00FF00  ; Green
0x0000FF  ; Blue
```

### HTML Color Names
```ahk
"RED"      ; Red
"GREEN"    ; Green
"BLUE"     ; Blue
"AQUA"     ; Aqua
"YELLOW"   ; Yellow
"LIME"     ; Lime
```

Supported HTML color names:
`AQUA`, `BLACK`, `BLUE`, `FUCHSIA`, `GRAY`, `GREEN`, `LIME`, `MAROON`, `NAVY`, `OLIVE`, `PURPLE`, `RED`, `SILVER`, `TEAL`, `WHITE`, `YELLOW`

## 💡 Practical Examples

### Example 1: Financial Report Coloring
```ahk
; Color based on values
Loop LV.GetCount() {
    value := LV.GetText(A_Index, 3)
    if (value < 0)
        CLV.Cell(A_Index, 3, 0xFFE6E6, 0xFF0000)  ; Negative in red
    else if (value > 1000)
        CLV.Cell(A_Index, 3, 0xE6FFE6, 0x008000)  ; Large amounts in green
}
```

### Example 2: Status Indicators
```ahk
; Color based on status
Loop LV.GetCount() {
    status := LV.GetText(A_Index, 2)
    switch status {
        case "Complete":
            CLV.Row(A_Index, 0xE6FFE6)  ; Green
        case "In Progress":
            CLV.Row(A_Index, 0xFFFFE6)  ; Yellow
        case "Failed":
            CLV.Row(A_Index, 0xFFE6E6)  ; Red
    }
}
```

### Example 3: Alternating Colors with Highlights
```ahk
; Zebra stripes + specific row highlight
CLV.AlternateRows(0xF8F8F8)
CLV.Row(5, 0xFFFF00)  ; Row 5 in yellow highlight
CLV.SelectionColors(0x0066CC, 0xFFFFFF)  ; Selected rows in blue/white
```

### Example 4: Cell-Level Formatting
```ahk
; Add color coding to table
CLV.AlternateCols(0xF0F0FF)  ; Even columns in light blue
CLV.Cell(1, 1, 0xFFD700)     ; Header cells in gold
CLV.Cell(1, 2, 0xFFD700)
CLV.Cell(1, 3, 0xFFD700)
```

## 🔧 Advanced Features

### Static Mode

In static mode, colors are bound to row content rather than row numbers, so colors move with content when sorted:
```ahk
CLV := LV_Colors(LV.Hwnd, true)  ; Enable static mode
```

### Dynamic Color Updates
```ahk
; Colors can be updated at any time
CLV.Row(1, 0xFF0000)  ; Set to red
Sleep(1000)
CLV.Row(1, 0x00FF00)  ; Change to green
```

### Clear Specific Colors
```ahk
; Clear row 2 color settings (restore defaults)
CLV.Row(2, "", "")

; Clear row 3, column 1 color settings
CLV.Cell(3, 1, "", "")
```

## ⚠️ Important Notes

1. Color values use BGR format (consistent with GDI), but the class automatically converts RGB input
2. Double buffering is enabled to avoid flickering
3. Cell colors take precedence over row colors
4. Selection colors take precedence over all other color settings
5. Remember to call `CLV.OnMessage(false)` before destroying the instance

## 🐛 Troubleshooting

### Colors Not Showing
```ahk
; Ensure ListView has Report view
LV := myGui.Add("ListView", "w600 h400 Report", ["Col1", "Col2"])
```

### Colors Disappear After Sorting
```ahk
; Use static mode
CLV := LV_Colors(LV.Hwnd, true)
```

### Performance Issues
```ahk
; Temporarily disable message handling before bulk updates
CLV.OnMessage(false)
; ... perform bulk updates ...
CLV.OnMessage(true)
```

## 📝 Version History

### v2.0.0 (2024)
- ✨ Complete port to AutoHotkey v2
- 🔄 Updated to v2 syntax and API
- 🐛 Fixed various compatibility issues

### v1.1.05.00 (2024-03-16)
- 🔧 Adjusted for AHK 1.1.37.02
- 🐛 Prevented control and GUI freezing

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Issues and pull requests are welcome!

## 🙏 Credits

- Original v1 version by: AHK-just-me
- [https://github.com/AHK-just-me/Class_LV_Colors](https://github.com/AHK-just-me/Class_LV_Colors)
- v2 port assisted by: Claude AI
