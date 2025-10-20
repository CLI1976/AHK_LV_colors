#Requires AutoHotkey v2.0
#SingleInstance Force  ; 強制關閉舊實例


; ======================================================================================================================
; Class:          LV_Colors (AHK v2 版本)
; Function:       Individual row and cell coloring for AHK v2 ListView controls.
; ======================================================================================================================

class LV_Colors {
   ; ===================================================================================================================
   ; 靜態屬性
   ; ===================================================================================================================
   static Attached := Map()
   
   ; ===================================================================================================================
   ; __New()         為指定的 ListView 創建新的 LV_Colors 實例
   ; Parameters:     HWND        -  ListView 的 HWND
   ;                 StaticMode  -  靜態顏色分配 (預設: false)
   ;                 NoSort      -  防止排序 (預設: false)
   ;                 NoSizing    -  防止調整欄寬 (預設: false)
   ; ===================================================================================================================
   __New(HWND, StaticMode := false, NoSort := false, NoSizing := false) {
      ; 驗證 HWND
      if !DllCall("IsWindow", "Ptr", HWND)
         return false
      
      ; 驗證是否為 ListView
      Class := Buffer(512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Ptr", Class, "Int", 256)
      if StrGet(Class) != "SysListView32"
         return false
      
      ; 檢查是否已附加
      if LV_Colors.Attached.Has(HWND)
         return false
      
      ; 設置雙緩衝樣式
      SendMessage(0x1036, 0x010000, 0x010000, , HWND) ; LVM_SETEXTENDEDLISTVIEWSTYLE
      
      ; 獲取預設顏色
      this.BkClr := SendMessage(0x1025, 0, 0, , HWND) ; LVM_GETTEXTBKCOLOR
      this.TxClr := SendMessage(0x1023, 0, 0, , HWND) ; LVM_GETTEXTCOLOR
      
      ; 獲取標題控制項
      this.Header := SendMessage(0x101F, 0, 0, , HWND) ; LVM_GETHEADER
      
      ; 設置屬性
      this.HWND := HWND
      this.IsStatic := !!StaticMode
      this.AltCols := false
      this.AltRows := false
      this.SelColors := false
      this.Rows := Map()
      this.Cells := Map()
      
      this.NoSort(!!NoSort)
      this.NoSizing(!!NoSizing)
      this.OnMessage()
      
      LV_Colors.Attached[HWND] := this
   }
   
   ; ===================================================================================================================
   ; __Delete()      清理資源
   ; ===================================================================================================================
   __Delete() {
      LV_Colors.Attached.Delete(this.HWND)
      this.OnMessage(false)
   }
   
   ; ===================================================================================================================
   ; Clear()         清除所有顏色設定
   ; ===================================================================================================================
   Clear(AltRows := false, AltCols := false) {
      if AltCols
         this.AltCols := false
      if AltRows
         this.AltRows := false
      this.Rows := Map()
      this.Cells := Map()
      return true
   }
   
   ; ===================================================================================================================
   ; AlternateRows() 設置交替行的顏色
   ; ===================================================================================================================
   AlternateRows(BkColor := "", TxColor := "") {
      if !this.HWND
         return false
      
      this.AltRows := false
      if (BkColor = "") && (TxColor = "")
         return true
      
      BkBGR := this.BGR(BkColor)
      TxBGR := this.BGR(TxColor)
      
      if (BkBGR = "") && (TxBGR = "")
         return false
      
      this.ARB := (BkBGR != "") ? BkBGR : this.BkClr
      this.ART := (TxBGR != "") ? TxBGR : this.TxClr
      this.AltRows := true
      return true
   }
   
   ; ===================================================================================================================
   ; AlternateCols() 設置交替列的顏色
   ; ===================================================================================================================
   AlternateCols(BkColor := "", TxColor := "") {
      if !this.HWND
         return false
      
      this.AltCols := false
      if (BkColor = "") && (TxColor = "")
         return true
      
      BkBGR := this.BGR(BkColor)
      TxBGR := this.BGR(TxColor)
      
      if (BkBGR = "") && (TxBGR = "")
         return false
      
      this.ACB := (BkBGR != "") ? BkBGR : this.BkClr
      this.ACT := (TxBGR != "") ? TxBGR : this.TxClr
      this.AltCols := true
      return true
   }
   
   ; ===================================================================================================================
   ; SelectionColors() 設置選中行的顏色
   ; ===================================================================================================================
   SelectionColors(BkColor := "", TxColor := "") {
      if !this.HWND
         return false
      
      this.SelColors := false
      if (BkColor = "") && (TxColor = "")
         return true
      
      BkBGR := this.BGR(BkColor)
      TxBGR := this.BGR(TxColor)
      
      if (BkBGR = "") && (TxBGR = "")
         return false
      
      this.SELB := BkBGR
      this.SELT := TxBGR
      this.SelColors := true
      return true
   }
   
   ; ===================================================================================================================
   ; Row()           設置指定行的顏色
   ; ===================================================================================================================
   Row(Row, BkColor := "", TxColor := "") {
      if !this.HWND
         return false
      
      if this.IsStatic
         Row := this.MapIndexToID(Row)
      
      if this.Rows.Has(Row)
         this.Rows.Delete(Row)
      
      if (BkColor = "") && (TxColor = "")
         return true
      
      BkBGR := this.BGR(BkColor)
      TxBGR := this.BGR(TxColor)
      
      if (BkBGR = "") && (TxBGR = "")
         return false
      
      this.Rows[Row] := {
         B: (BkBGR != "") ? BkBGR : this.BkClr,
         T: (TxBGR != "") ? TxBGR : this.TxClr
      }
      return true
   }
   
   ; ===================================================================================================================
   ; Cell()          設置指定儲存格的顏色
   ; ===================================================================================================================
   Cell(Row, Col, BkColor := "", TxColor := "") {
      if !this.HWND
         return false
      
      if this.IsStatic
         Row := this.MapIndexToID(Row)
      
      if !this.Cells.Has(Row)
         this.Cells[Row] := Map()
      
      if this.Cells[Row].Has(Col)
         this.Cells[Row].Delete(Col)
      
      if (BkColor = "") && (TxColor = "")
         return true
      
      BkBGR := this.BGR(BkColor)
      TxBGR := this.BGR(TxColor)
      
      if (BkBGR = "") && (TxBGR = "")
         return false
      
      this.Cells[Row][Col] := {}
      if (BkBGR != "")
         this.Cells[Row][Col].B := BkBGR
      if (TxBGR != "")
         this.Cells[Row][Col].T := TxBGR
      
      return true
   }
   
   ; ===================================================================================================================
   ; NoSort()        防止/允許排序
   ; ===================================================================================================================
   NoSort(Apply := true) {
      if !this.HWND
         return false
      this.SortColumns := !Apply
      return true
   }
   
   ; ===================================================================================================================
   ; NoSizing()      防止/允許調整欄寬
   ; ===================================================================================================================
   NoSizing(Apply := true) {
      static OSVersion := DllCall("GetVersion", "UChar")
      
      if !this.Header
         return false
      
      if Apply {
         if (OSVersion > 5) {
            ; 添加 HDS_NOSIZING 樣式
            style := DllCall("GetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", this.Header, "Int", -16)
            DllCall("SetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", this.Header, "Int", -16, "Ptr", style | 0x0800)
         }
         this.ResizeColumns := false
      } else {
         if (OSVersion > 5) {
            ; 移除 HDS_NOSIZING 樣式
            style := DllCall("GetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", this.Header, "Int", -16)
            DllCall("SetWindowLong" (A_PtrSize = 8 ? "Ptr" : ""), "Ptr", this.Header, "Int", -16, "Ptr", style & ~0x0800)
         }
         this.ResizeColumns := true
      }
      return true
   }
   
   ; ===================================================================================================================
   ; OnMessage()     添加/移除訊息處理器
   ; ===================================================================================================================
   OnMessage(Apply := true) {
      if Apply && !this.HasOwnProp("OnMessageFunc") {
         this.OnMessageFunc := ObjBindMethod(this, "On_WM_Notify")
         OnMessage(0x004E, this.OnMessageFunc)
      } else if !Apply && this.HasOwnProp("OnMessageFunc") {
         OnMessage(0x004E, this.OnMessageFunc, 0)
         this.DeleteProp("OnMessageFunc")
      }
      return true
   }
   
   ; ===================================================================================================================
   ; PRIVATE METHODS
   ; ===================================================================================================================
   
   On_WM_Notify(wParam, lParam, msg, hwnd) {
      static NM_CUSTOMDRAW := -12
      static LVN_COLUMNCLICK := -108
      static HDN_BEGINTRACKA := -306
      static HDN_BEGINTRACKW := -326
      
      HCTL := NumGet(lParam, 0, "Ptr")
      Code := NumGet(lParam, A_PtrSize * 2, "Int")
      
      if (HCTL = this.HWND) {
         if (Code = NM_CUSTOMDRAW)
            return this.NM_CUSTOMDRAW(lParam)
         if !this.SortColumns && (Code = LVN_COLUMNCLICK)
            return 0
      } else if (HCTL = this.Header) {
         if !this.ResizeColumns && ((Code = HDN_BEGINTRACKA) || (Code = HDN_BEGINTRACKW))
            return true
      }
   }
   
   NM_CUSTOMDRAW(lParam) {
      static SizeNMHDR := A_PtrSize * 3
      static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5)
      static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2)
      static OffItemState := OffItem + A_PtrSize
      static OffCT := SizeNCD
      static OffCB := OffCT + 4
      static OffSubItem := OffCB + 4
      
      DrawStage := NumGet(lParam, SizeNMHDR, "UInt")
      Row := NumGet(lParam, OffItem, "UPtr") + 1
      Col := NumGet(lParam, OffSubItem, "Int") + 1
      Item := Row - 1
      
      if this.IsStatic
         Row := this.MapIndexToID(Row)
      
      ; CDDS_SUBITEMPREPAINT
      if (DrawStage = 0x030001) {
         UseAltCol := !(Col & 1) && this.AltCols
         
         ColB := this.BkClr
         ColT := this.TxClr
         
         if this.Cells.Has(Row) && this.Cells[Row].Has(Col) {
            ColColors := this.Cells[Row][Col]
            ColB := ColColors.HasOwnProp("B") ? ColColors.B : (UseAltCol ? this.ACB : this.RowB)
            ColT := ColColors.HasOwnProp("T") ? ColColors.T : (UseAltCol ? this.ACT : this.RowT)
         } else if UseAltCol {
            ColB := this.ACB
            ColT := this.ACT
         } else {
            ColB := this.RowB
            ColT := this.RowT
         }
         
         NumPut("UInt", ColT, lParam, OffCT)
         NumPut("UInt", ColB, lParam, OffCB)
         return 0x20
      }
      
      ; CDDS_ITEMPREPAINT
      if (DrawStage = 0x010001) {
         ; 檢查是否選中
         if this.SelColors {
            isSelected := SendMessage(0x102C, Item, 0x0002, , this.HWND) ; LVM_GETITEMSTATE
            if isSelected {
               NumPut("UInt", NumGet(lParam, OffItemState, "UInt") & ~0x0011, lParam, OffItemState)
               if this.HasOwnProp("SELB")
                  NumPut("UInt", this.SELB, lParam, OffCB)
               if this.HasOwnProp("SELT")
                  NumPut("UInt", this.SELT, lParam, OffCT)
               return 0x02
            }
         }
         
         UseAltRow := (Item & 1) && this.AltRows
         
         if this.Rows.Has(Row) {
            RowColors := this.Rows[Row]
            this.RowB := RowColors.B
            this.RowT := RowColors.T
         } else if UseAltRow {
            this.RowB := this.ARB
            this.RowT := this.ART
         } else {
            this.RowB := this.BkClr
            this.RowT := this.TxClr
         }
         
         if this.AltCols || this.Cells.Has(Row)
            return 0x20
         
         NumPut("UInt", this.RowT, lParam, OffCT)
         NumPut("UInt", this.RowB, lParam, OffCB)
         return 0x00
      }
      
      ; CDDS_PREPAINT
      return (DrawStage = 0x000001) ? 0x20 : 0x00
   }
   
   MapIndexToID(Row) {
      return SendMessage(0x10B4, Row - 1, 0, , this.HWND) ; LVM_MAPINDEXTOID
   }
   
   BGR(Color, Default := "") {
      static HTML := Map(
         "AQUA", 0xFFFF00, "BLACK", 0x000000, "BLUE", 0xFF0000, "FUCHSIA", 0xFF00FF,
         "GRAY", 0x808080, "GREEN", 0x008000, "LIME", 0x00FF00, "MAROON", 0x000080,
         "NAVY", 0x800000, "OLIVE", 0x008080, "PURPLE", 0x800080, "RED", 0x0000FF,
         "SILVER", 0xC0C0C0, "TEAL", 0x808000, "WHITE", 0xFFFFFF, "YELLOW", 0x00FFFF
      )
      
      if IsInteger(Color)
         return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
      
      return HTML.Has(Color) ? HTML[Color] : Default
   }
}

; ======================================================================================================================
; 測試範例
; ======================================================================================================================
/*
yGui := Gui()
LV := myGui.Add("ListView", "w500 h300", ["Column1", "Column2", "Column3"])

; 添加一些資料
Loop 20
   LV.Add(, "Row " A_Index, "Data " A_Index, "Info " A_Index)

; 創建 LV_Colors 實例
CLV := LV_Colors(LV.Hwnd)

; 設置交替行顏色
CLV.AlternateRows(0xF0F0F0)

; 設置特定行顏色
CLV.Row(3, 0xFFE6E6)  ; 淺紅色
CLV.Row(5, 0xE6FFE6)  ; 淺綠色
CLV.Row(7, 0xE6E6FF)  ; 淺藍色

; 設置特定儲存格顏色
CLV.Cell(10, 2, 0xFFFF00, 0xFF0000)  ; 黃底紅字

; 設置選中行顏色
CLV.SelectionColors(0x0000FF, 0xFFFFFF)  ; 藍底白字

myGui.Show()
*/