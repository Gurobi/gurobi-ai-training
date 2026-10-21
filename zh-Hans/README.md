# Gurobi AI Training

[English](../README.md) | [한국어](../ko/README.md) | **简体中文** | [繁體中文](../zh-Hant/README.md)

**Gurobi Intelligence Hub**（[intelligence.gurobi.com](https://intelligence.gurobi.com)）的动手实践
培训材料。Intelligence Hub 是 Gurobi 用于构建和诊断优化模型的 AI 智能体平台。你用自然语言描述业务问题，
由 **Modeler** 将其转化为经过验证的 `gurobipy` 模型；当模型出现问题时，再用 **Explainer** 对其进行诊断、
修复和分析。

所有建模和诊断工作都在浏览器中完成。本仓库中的指南不含需要运行的代码，只提供问题描述、分步说明，
以及可用来核对结果的预期结果。跟随学习需要一个 Intelligence Hub 账号。

---

## 目录

| # | 主题 | 指南 |
|---|------|------|
| 1 | 使用 Modeler 构建模型 | [1_Modeler.md](1_Modeler.md) |
| 2 | 使用 Explainer 诊断模型 | [2_Explainer.md](2_Explainer.md) |

实验中需要上传的文件：

| 文件 | 使用位置 |
|---|---|
| [`data/production_planning.csv`](../data/production_planning.csv) | `1_Modeler` 第 0 部分（热身）——附加到你给 Modeler 的提示词中 |
| [`models/moodel.lp`](../models/moodel.lp) | `2_Explainer` 第 1–2 部分——不可行的乳品厂模型 |
| [`models/moodel_repaired.lp`](../models/moodel_repaired.lp) | `2_Explainer` 第 3 部分——如果第 2 部分没有从 Explainer 拿到修复后的模型，可用此文件代替 |

---

## 你将学到什么

### 1. 使用 Modeler 构建模型（`1_Modeler.md`）

体验 **Modeler**（Beta）如何将自然语言描述的问题一路转化为规格说明、`gurobipy` 代码和测试。
本指南分为三部分：

- **第 0 部分　热身**：把一个答案已知的生产计划问题交给 Modeler 并对比结果——养成验证 AI 生成模型的习惯。
- **第 1 部分　主实验**：为一家只生产一种高端饮料的简化乳品厂建模，在约 30 分钟内得到可行的最优解。
- **附录　完整工艺模型**：将同一家工厂扩展为两种生乳、五种产品。这里构建的模型将延续到 Explainer 实验中。

### 2. 使用 Explainer 诊断模型（`2_Explainer.md`）

使用 **Explainer**（Experimental）对不可行模型进行诊断、修复和分析。

- **不可行性诊断**：通过 IIS（相互冲突的最小约束集合）找出原因
- **可行性修复**：用 `feasRelax` 计算最小松弛量
- **灵敏度分析**：利用影子价格确定投资优先级

---

## 快速开始

1. 登录 [intelligence.gurobi.com](https://intelligence.gurobi.com)。
2. 打开 [1_Modeler.md](1_Modeler.md) 跟随操作，然后继续学习
   [2_Explainer.md](2_Explainer.md)。
3. 当实验要求上传文件时，下载上面列出的数据和模型文件（或克隆仓库，将所有文件保存在本地）：

   ```bash
   git clone https://github.com/Gurobi/gurobi-ai-training.git
   ```

   简体中文版指南位于仓库的 `zh-Hans/` 文件夹中。

---

## 总结

- 借助 **Modeler**，你可以从自然语言问题描述出发，得到经过验证的模型。
- 借助 **Explainer**，你可以对该模型进行诊断、修复和分析。

在实际工作中，你可以将这两个智能体组合成一个覆盖“建模 → 处理生产环境中的问题”的工作流。但正如两个实验
都强调的那样，不要盲目信任 AI 智能体生成的模型和解释——要养成亲自验证的习惯，例如使用验收测试。

---

## 参考资料

- [Gurobi 文档](https://docs.gurobi.com/)
- [gurobipy API 参考](https://docs.gurobi.com/projects/optimizer/en/current/reference/python/)
- [Gurobi 示例](https://docs.gurobi.com/projects/examples/en/current/)
- [Gurobi Intelligence Hub](https://intelligence.gurobi.com)
