# Gurobi AI Training

Hands-on training material for **Gurobi Intelligence Hub**
([intelligence.gurobi.com](https://intelligence.gurobi.com)) — Gurobi's AI agents for building and
diagnosing optimization models. You describe a business problem in plain language and let
**Modeler** turn it into a verified `gurobipy` model, then use **Explainer** to diagnose, repair, and
analyze that model when things go wrong.

All modeling and diagnostic work happens in the browser. The guides in this repository contain no
code to run; they provide the problem descriptions, step-by-step instructions, and expected results
to check your work against. You need an Intelligence Hub account to follow along.

---

## Contents

| # | Topic | Guide |
|---|------|------|
| 1 | Building models with Modeler | [1_Modeler.md](1_Modeler.md) |
| 2 | Diagnosing models with Explainer | [2_Explainer.md](2_Explainer.md) |

Files you upload during the labs:

| File | Used in |
|---|---|
| [`data/production_planning.csv`](data/production_planning.csv) | `1_Modeler` Part 0 (warm-up) — attach it to your Modeler prompt |
| [`models/moodel.lp`](models/moodel.lp) | `2_Explainer` Parts 1–2 — the infeasible dairy plant model |
| [`models/moodel_repaired.lp`](models/moodel_repaired.lp) | `2_Explainer` Part 3 — fallback if you didn't get the repaired model from Explainer in Part 2 |

---

## What You Will Learn

### 1. Building Models with Modeler (`1_Modeler.md`)

Experience how **Modeler** (Beta) takes a problem described in natural language all the way to a
spec, `gurobipy` code, and tests. The guide has three parts:

- **Part 0. Warm-up**: Hand Modeler a production planning problem whose answer is already known and
  compare results — building the habit of verifying AI-generated models.
- **Part 1. Main lab**: Model a simplified dairy plant that produces a single premium drink, and
  reach a feasible optimal solution in about 30 minutes.
- **Appendix. Full process model**: The same plant extended to two raw milks and five products. The
  model built here carries over to the Explainer lab.

### 2. Diagnosing Models with Explainer (`2_Explainer.md`)

Use **Explainer** (Experimental) to diagnose, repair, and analyze an infeasible model.

- **Infeasibility Diagnosis**: Find the cause with an IIS (the minimal set of conflicting
  constraints)
- **Feasibility Restoration**: Compute the minimum relaxation with `feasRelax`
- **Sensitivity Analysis**: Use shadow prices to set investment priorities

---

## Getting Started

1. Sign in at [intelligence.gurobi.com](https://intelligence.gurobi.com).
2. Open [1_Modeler.md](1_Modeler.md) and follow along, then continue with
   [2_Explainer.md](2_Explainer.md).
3. Download the data and model files listed above when a lab asks you to upload them (or clone the
   repository to have them all locally):

   ```bash
   git clone https://github.com/Gurobi/gurobi-ai-training.git
   ```

---

## Wrap-up

- With **Modeler**, you go from a natural-language problem description to a verified model.
- With **Explainer**, you diagnose, repair, and analyze that model.

In practice, you can combine these two agents into a workflow that spans "modeling → handling issues
in production." But as both labs stress, don't trust the models and explanations AI agents produce
blindly — make a habit of verifying them yourself, for example with acceptance tests.

---

## References

- [Gurobi documentation](https://docs.gurobi.com/)
- [gurobipy API reference](https://docs.gurobi.com/projects/optimizer/en/current/reference/python/)
- [Gurobi examples](https://docs.gurobi.com/projects/examples/en/current/)
- [Gurobi Intelligence Hub](https://intelligence.gurobi.com)
