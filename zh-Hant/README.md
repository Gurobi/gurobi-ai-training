# Gurobi AI Training

[English](../README.md) | [한국어](../ko/README.md) | [简体中文](../zh-Hans/README.md) | **繁體中文**

**Gurobi Intelligence Hub**（[intelligence.gurobi.com](https://intelligence.gurobi.com)）的實作訓練教材
——Intelligence Hub 是 Gurobi 用於建立與診斷最佳化模型的 AI 代理程式。您以白話描述商業問題，讓
**Modeler** 將其轉換為經過驗證的 `gurobipy` 模型；當模型出問題時，再使用 **Explainer** 對該模型進行診斷、
修復與分析。

所有建模與診斷工作都在瀏覽器中進行。本儲存庫中的指南不包含需要執行的程式碼；它們提供問題描述、逐步
指引，以及可用來核對成果的預期結果。您需要一個 Intelligence Hub 帳號才能跟著操作。

---

## 目錄

| # | 主題 | 指南 |
|---|------|------|
| 1 | 使用 Modeler 建立模型 | [1_Modeler.md](1_Modeler.md) |
| 2 | 使用 Explainer 診斷模型 | [2_Explainer.md](2_Explainer.md) |

實作過程中需要上傳的檔案：

| 檔案 | 使用時機 |
|---|---|
| [`data/production_planning.csv`](../data/production_planning.csv) | `1_Modeler` Part 0（暖身）——附加到您給 Modeler 的提示中 |
| [`models/moodel.lp`](../models/moodel.lp) | `2_Explainer` Part 1–2——不可行的乳品廠模型 |
| [`models/moodel_repaired.lp`](../models/moodel_repaired.lp) | `2_Explainer` Part 3——若您在 Part 2 沒有從 Explainer 取得修復後的模型，可改用此檔案 |

---

## 您將學到什麼

### 1. 使用 Modeler 建立模型（`1_Modeler.md`）

體驗 **Modeler**（Beta）如何將以自然語言描述的問題，一路轉換為規格說明、`gurobipy` 程式碼與測試。本指南
分為三個部分：

- **Part 0. 暖身**：交給 Modeler 一個答案已知的生產規劃問題並比對結果——養成驗證 AI 產生之模型的習慣。
- **Part 1. 主要實作**：為只生產單一高級飲品的簡化乳品廠建模，並在約 30 分鐘內得到可行的最佳解。
- **附錄. 完整製程模型**：將同一座工廠擴充為兩種生乳與五種產品。在此建立的模型會延續到 Explainer 實作。

### 2. 使用 Explainer 診斷模型（`2_Explainer.md`）

使用 **Explainer**（Experimental）對不可行的模型進行診斷、修復與分析。

- **不可行性診斷**：透過 IIS（彼此衝突的最小限制式集合）找出原因
- **可行性修復**：使用 `feasRelax` 計算最小鬆弛量
- **敏感度分析**：利用影子價格決定投資優先順序

---

## 開始使用

1. 登入 [intelligence.gurobi.com](https://intelligence.gurobi.com)。
2. 開啟 [1_Modeler.md](1_Modeler.md) 並跟著操作，接著繼續進行
   [2_Explainer.md](2_Explainer.md)。
3. 當實作要求上傳時，下載上方列出的資料與模型檔案（或 clone 儲存庫，將所有檔案都放在本機）：

   ```bash
   git clone https://github.com/Gurobi/gurobi-ai-training.git
   ```

   繁體中文版指南位於 `zh-Hant/` 資料夾中。

---

## 總結

- 透過 **Modeler**，您可以從自然語言的問題描述得到經過驗證的模型。
- 透過 **Explainer**，您可以對該模型進行診斷、修復與分析。

在實務上，您可以將這兩個代理程式結合成一套涵蓋「建模 → 處理上線後問題」的工作流程。但正如兩個實作所強調
的，不要盲目相信 AI 代理程式產生的模型與解釋——請養成自行驗證的習慣，例如使用驗收測試。

---

## 參考資料

- [Gurobi 文件](https://docs.gurobi.com/)
- [gurobipy API 參考文件](https://docs.gurobi.com/projects/optimizer/en/current/reference/python/)
- [Gurobi 範例](https://docs.gurobi.com/projects/examples/en/current/)
- [Gurobi Intelligence Hub](https://intelligence.gurobi.com)
