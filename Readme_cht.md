# LV_Colors - ListView 顏色控制類別 (AHK v2)

一個功能強大的 AutoHotkey v2 類別，用於為 ListView 控制項的行和儲存格設置個別顏色。

[![AHK Version](https://img.shields.io/badge/AHK-v2.0+-blue.svg)](https://www.autohotkey.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ 功能特色

- 🎨 **行顏色設置** - 為特定行設置背景和文字顏色
- 📊 **儲存格顏色設置** - 為個別儲存格設置自訂顏色
- 🔄 **交替行/列顏色** - 自動設置斑馬紋樣式
- ✅ **選中行顏色** - 自訂選中狀態的顏色
- 🚫 **防止排序** - 可選擇性地禁用欄位排序
- 📏 **防止調整欄寬** - 可選擇性地禁用欄寬調整
- 🎯 **靜態模式** - 顏色跟隨內容而非行號

## 📦 安裝

1. 下載 `LV_Colors.ahk`
2. 將文件放入您的專案目錄或 AutoHotkey Lib 資料夾
3. 在您的腳本中引用：
```ahk
#Include LV_Colors.ahk
```

## 🚀 快速開始

### 基本範例
```ahk
#Requires AutoHotkey v2.0

#Include LV_Colors.ahk

; 建立 GUI 和 ListView
myGui := Gui()
LV := myGui.Add("ListView", "w600 h400", ["姓名", "年齡", "城市"])

; 添加資料
LV.Add(, "張三", "25", "台北")
LV.Add(, "李四", "30", "台中")
LV.Add(, "王五", "28", "高雄")
LV.Add(, "趙六", "35", "台南")

; 建立 LV_Colors 實例
CLV := LV_Colors(LV.Hwnd)

; 設置交替行顏色（斑馬紋效果）
CLV.AlternateRows(0xF0F0F0)

; 設置特定行的顏色
CLV.Row(2, 0xFFE6E6)  ; 第2行淺紅色背景

; 設置特定儲存格的顏色
CLV.Cell(3, 2, 0xE6FFE6, 0x008000)  ; 第3行第2列：淺綠背景，深綠文字

; 設置選中行的顏色
CLV.SelectionColors(0x0000FF, 0xFFFFFF)  ; 藍底白字

myGui.Show()
```

## 📖 詳細文檔

### 建構函數
```ahk
CLV := LV_Colors(HWND, StaticMode := false, NoSort := false, NoSizing := false)
```

**參數：**
- `HWND` - ListView 控制項的視窗控制碼
- `StaticMode` - 啟用靜態模式（顏色跟隨內容）
- `NoSort` - 禁用欄位排序
- `NoSizing` - 禁用欄寬調整

### 主要方法

#### AlternateRows(BkColor, TxColor)
設置偶數行的背景和文字顏色
```ahk
; 偶數行使用淺灰色背景
CLV.AlternateRows(0xF0F0F0)

; 偶數行使用淺黃背景和深藍文字
CLV.AlternateRows(0xFFFFE0, 0x000080)
```

#### AlternateCols(BkColor, TxColor)
設置偶數列的背景和文字顏色
```ahk
; 偶數列使用淺藍色背景
CLV.AlternateCols(0xFFF0E0)
```

#### Row(Row, BkColor, TxColor)
設置特定行的顏色
```ahk
; 第1行紅色背景
CLV.Row(1, 0xFF0000)

; 第2行綠色背景，白色文字
CLV.Row(2, 0x00FF00, 0xFFFFFF)

; 第3行只設置文字為藍色
CLV.Row(3, , 0x0000FF)
```

#### Cell(Row, Col, BkColor, TxColor)
設置特定儲存格的顏色
```ahk
; 第1行第2列：黃色背景
CLV.Cell(1, 2, 0xFFFF00)

; 第3行第1列：紅底白字
CLV.Cell(3, 1, 0xFF0000, 0xFFFFFF)
```

#### SelectionColors(BkColor, TxColor)
設置選中行的顏色
```ahk
; 選中時顯示藍底白字
CLV.SelectionColors(0x0000FF, 0xFFFFFF)
```

#### Clear(AltRows, AltCols)
清除所有顏色設定
```ahk
; 清除所有顏色
CLV.Clear()

; 清除所有顏色，包括交替行和交替列設定
CLV.Clear(true, true)
```

#### NoSort(Apply)
啟用/禁用欄位排序
```ahk
CLV.NoSort(true)   ; 禁用排序
CLV.NoSort(false)  ; 允許排序
```

#### NoSizing(Apply)
啟用/禁用欄寬調整
```ahk
CLV.NoSizing(true)   ; 禁用調整欄寬
CLV.NoSizing(false)  ; 允許調整欄寬
```

## 🎨 顏色格式

顏色可以使用以下格式：

### RGB 整數格式
```ahk
0xFF0000  ; 紅色
0x00FF00  ; 綠色
0x0000FF  ; 藍色
```

### HTML 顏色名稱
```ahk
"RED"      ; 紅色
"GREEN"    ; 綠色
"BLUE"     ; 藍色
"AQUA"     ; 青色
"YELLOW"   ; 黃色
"LIME"     ; 萊姆綠
```

支援的 HTML 顏色名稱：
`AQUA`, `BLACK`, `BLUE`, `FUCHSIA`, `GRAY`, `GREEN`, `LIME`, `MAROON`, `NAVY`, `OLIVE`, `PURPLE`, `RED`, `SILVER`, `TEAL`, `WHITE`, `YELLOW`

## 💡 實用範例

### 範例 1：財務報表著色
```ahk
; 根據數值著色
Loop LV.GetCount() {
    value := LV.GetText(A_Index, 3)
    if (value < 0)
        CLV.Cell(A_Index, 3, 0xFFE6E6, 0xFF0000)  ; 負數紅色
    else if (value > 1000)
        CLV.Cell(A_Index, 3, 0xE6FFE6, 0x008000)  ; 大額綠色
}
```

### 範例 2：狀態指示
```ahk
; 根據狀態著色
Loop LV.GetCount() {
    status := LV.GetText(A_Index, 2)
    switch status {
        case "完成":
            CLV.Row(A_Index, 0xE6FFE6)  ; 綠色
        case "進行中":
            CLV.Row(A_Index, 0xFFFFE6)  ; 黃色
        case "失敗":
            CLV.Row(A_Index, 0xFFE6E6)  ; 紅色
    }
}
```

### 範例 3：交替顏色與高亮
```ahk
; 斑馬紋 + 特定行高亮
CLV.AlternateRows(0xF8F8F8)
CLV.Row(5, 0xFFFF00)  ; 第5行黃色高亮
CLV.SelectionColors(0x0066CC, 0xFFFFFF)  ; 選中行藍底白字
```

### 範例 4：儲存格級別格式化
```ahk
; 為表格添加顏色編碼
CLV.AlternateCols(0xF0F0FF)  ; 偶數列淺藍
CLV.Cell(1, 1, 0xFFD700)     ; 標題儲存格金色
CLV.Cell(1, 2, 0xFFD700)
CLV.Cell(1, 3, 0xFFD700)
```

## 🔧 進階功能

### 靜態模式

在靜態模式下，顏色會綁定到行內容而非行號，即使排序後顏色也會跟隨內容移動：
```ahk
CLV := LV_Colors(LV.Hwnd, true)  ; 啟用靜態模式
```

### 動態更新顏色
```ahk
; 可以隨時更新顏色
CLV.Row(1, 0xFF0000)  ; 設置紅色
Sleep(1000)
CLV.Row(1, 0x00FF00)  ; 改為綠色
```

### 清除特定顏色
```ahk
; 清除第2行的顏色設定（恢復預設）
CLV.Row(2, "", "")

; 清除第3行第1列的顏色設定
CLV.Cell(3, 1, "", "")
```

## ⚠️ 注意事項

1. 顏色值使用 BGR 格式（與 GDI 一致），但類別會自動轉換 RGB 輸入
2. 啟用雙緩衝以避免閃爍
3. 儲存格顏色優先於行顏色
4. 選中行顏色優先於所有其他顏色設定
5. 在銷毀實例前記得呼叫 `CLV.OnMessage(false)`

## 🐛 故障排除

### 顏色沒有顯示
```ahk
; 確保 ListView 有 Report 視圖
LV := myGui.Add("ListView", "w600 h400 Report", ["Col1", "Col2"])
```

### 顏色在排序後消失
```ahk
; 使用靜態模式
CLV := LV_Colors(LV.Hwnd, true)
```

### 效能問題
```ahk
; 大量更新前暫時禁用訊息處理
CLV.OnMessage(false)
; ... 進行大量更新 ...
CLV.OnMessage(true)
```

## 📝 版本歷史

### v2.0.0 (2024)
- ✨ 完整移植到 AutoHotkey v2
- 🔄 更新為 v2 語法和 API
- 🐛 修復各種相容性問題

### v1.1.05.00 (2024-03-16)
- 🔧 調整以適應 AHK 1.1.37.02
- 🐛 防止控制項和 GUI 凍結

## 📄 授權

MIT License - 詳見 LICENSE 文件


## 🙏 致謝

- 原始 v1 版本作者：AHK-just-me
- [https://github.com/AHK-just-me/Class_LV_Colors](https://github.com/AHK-just-me/Class_LV_Colors)
- v2 移植：Claude AI 協助
