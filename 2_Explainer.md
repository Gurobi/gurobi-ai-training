# 2. Diagnosing Models with Gurobi Explainer

In the previous document (`1_Modeler` **appendix**), you built a production planning model for a
dairy plant and obtained a feasible optimal solution. In this document, something goes wrong with
that model, and you use **Explainer** to diagnose the cause, calculate how much needs to be relaxed,
and analyze where investment would improve profit the most.

> ⚠️ There is no code to run in this document either. All diagnostic work happens in **Explainer**
> at **[intelligence.gurobi.com](https://intelligence.gurobi.com)**.
> This document gives you the scenario, a step-by-step guide, and expected results you can check
> your work against.

## What is Explainer?

**Explainer** (Experimental) is an agent that takes an existing model instance you upload, runs
Gurobi's diagnostic tools on it, and explains the results in business language. Intelligence Hub
offers three workflows.

| Workflow | Example question | Diagnostic tool used |
|---|---|---|
| **Infeasibility Diagnosis** | Why is my model infeasible? | `computeIIS()` |
| **Feasibility Restoration** | Which constraints should I relax, and by how much? | `feasRelax()` |
| **Sensitivity Analysis** | Which constraints/capacities affect the objective the most? | Shadow prices (`Pi`), `SARHS` |

> 💡 Explainer doesn't treat the model and solver as a "black box" — it explains by actually
> connecting the input (the model file) to the output (the diagnostic results). Just as you
> verified results with acceptance tests in the previous lab (`1_Modeler`), check for yourself
> that Explainer's explanations line up with the actual numbers as you go.

## Scenario

![Late night at Friesland Ridge Dairy, 02:17 AM. The optimizer status reads INFEASIBLE. The team scrambles — "It worked fine yesterday!", "We can't miss our deliveries!" — until someone admits signing a new contract clause for a minimum amount of Premium Dairy Drink. The team decides to dig into the model and find the culprit.](assets/explainer_q1_scenario.jpg)

You are the OR (operations research) specialist at Friesland Ridge Dairy. At 02:17 AM, the plant's
"Milk Refinery Planning" optimizer fails to produce a plan. Trucks are due to arrive at dawn loaded
with raw milk and the supply contracts are already binding — and it turns out the marketing team
quietly slipped in a new requirement.

Your mission is to debug MOOdel (Milk Operations Optimization — the model built in `1_Modeler`) to:

1. find the cause of the infeasibility and propose a change to the plant manager,
2. quantify the minimum amount by which the model must be relaxed, and
3. propose future facility investments that would increase profit further.

## Files for This Lab

The marketing team quietly added the following requirement to the feasible model you built in the
previous lab (`1_Modeler`):

> **"Produce at least 20,000 barrels of Premium Dairy Drink per day."**

The model with this requirement (which is now infeasible) is
[`models/moodel.lp`](models/moodel.lp). Download it and use it throughout this lab.

- If you are viewing this on GitHub: use the link above, or download the raw file from
  `models/moodel.lp` in the repository.
- If you cloned the repository: the file is already at `models/moodel.lp`.

> 📌 You can also create the same file yourself by adding the constraint
> `Minimum_Premium: end_prod[Premium_drink] >= 20000` to the model you built in `1_Modeler`.
> (Save an LP file with `model.write("moodel.lp")`.)

## Part 1. Infeasibility Diagnosis — Why Is It Infeasible? (Q1)

### Steps

1. Launch Explainer and select the **Infeasibility Diagnosis** tab.
2. Upload `moodel.lp`.
3. Example question: *"Tell me why this model is infeasible."*
4. Review the **IIS** (Irreducible Inconsistent Subset — a minimal set of conflicting constraints and
   bounds that cannot be reduced any further) that Explainer reports.

### Task

Based on Explainer's answer, list the candidate constraints/bounds that could be causing the
infeasibility and explain why each one is a problem. As in the original challenge, the plant manager
(your instructor) will allow only **one** of those candidates to be adjusted — **the requirement that
was just added**. Can you guess which constraint that is?

### Expected Results

- Constraints in the IIS: **19**
- Bounds in the IIS: **9** (8 lower bounds, 1 upper bound)
- Root cause of the infeasibility:

  The newly added `Minimum_Premium` constraint (minimum premium output of 20,000 barrels) collides
  head-on with the premium drink's quality standard (quality index ≥ 94). Reaching 94 requires
  large amounts of the high-quality ingredients — protein concentrate (quality 115) and fermented
  concentrate (quality 105) — but each of those is capped by the capacity of the **protein
  concentration unit** (10,000 barrels/day) and the **secondary processing unit** (8,000
  barrels/day). Even running both units at full capacity can't make enough high-quality ingredients
  to bring all 20,000 barrels up to the quality standard, so the model becomes infeasible.

  → The physical capacities (separation, protein concentration, secondary processing) and the
  quality standards (84, 94) reflect the plant's actual equipment and contract terms and can't be
  changed. `Minimum_Premium`, however, is a target the marketing team just added, which makes it the
  most likely candidate the plant manager will allow you to adjust.

### Sample Explainer Response

If you can't picture what kind of response you'll get, expand the example below. (Try asking
Explainer and reading the IIS yourself first, and expand this only if you get stuck. Below is an
actual response obtained by uploading `moodel.lp` as-is through the API and asking the same
question.)

<details>
<summary>Show the sample response</summary>

> **You**: Tell me why this model is infeasible.

Explainer runs `computeIIS()` and groups the constraints and bounds in the IIS as follows.

| Group | Constraints/bounds included | Explanation |
|---|---|---|
| Minimum output requirement | `Minimum_Premium` | Requires at least 20,000 units of Premium_drink |
| Quality requirement | `Quality_tol_premium_drink` (and 1 other) | Requires Premium_drink quality index ≥ 94 → needs enough high-quality intermediates (protein concentrate, fermented concentrate) |
| Process capacity limits | `Protein_conc_cap` (≤ 10,000), `Secondary_proc_cap` (≤ 8,000) | Processing caps of the two units that make those high-quality intermediates |
| Raw material input cap + material flow balance | `milk_in[2]` (UB = 30,000) and the separation/blending balance equalities | The upstream raw milk supply itself sets the ceiling on intermediate production |

> In short: "Making 20,000 units of high-quality (94+) Premium_drink requires enough high-quality
> intermediates, but the unit capacity limits and the raw milk input cap prevent that."

Explainer then suggests relaxation options in order of priority.

1. **Increase process capacity limits** — raise the RHS of `Protein_conc_cap` and
   `Secondary_proc_cap` (expand the units)
2. **Increase the raw milk input cap** — raise the UB of `milk_in[2]`
3. **Relax the minimum output / quality standard** — adjust `Minimum_Premium` or
   `Quality_tol_premium_drink`

</details>

## Part 2. Feasibility Restoration — What Is the Minimum Relaxation? (Q2)

![The team agrees: "Now that we know WHAT we can relax, let's see how much we should relax it by…" The plant manager runs the feasibility relaxation calculations, and the team gathers around the laptop: "Okay, this is the best we can do…" — crunching the numbers of necessity.](assets/explainer_q2_restoration.jpg)

You've found the cause, but "let's just pretend that requirement never happened" isn't an answer.
Neither the marketing team nor the plant manager intends to give it up entirely. So the next
question is: "How much do we need to reduce it?"

### Steps

1. In Explainer, select the **Feasibility Restoration** tab and upload the same `moodel.lp`.
2. The plant manager has said: "Only the premium minimum output requirement we just added can be
   adjusted. The other physical capacities and quality standards are non-negotiable."
3. Example question: *"If we relax only the premium minimum output requirement, how much do we need
   to reduce it to make the model feasible?"*
4. Review Explainer's `feasRelax`-based answer. Explainer attaches the **relaxed model file** (e.g.,
   `moodel_repaired.lp`) to its answer — download it, since you'll use it again in Part 3.

### Expected Results (profit unit: hundreds of dollars)

- Minimum relaxation (barrels): **≈ 990.76**
- Premium minimum output after relaxation (barrels): **≈ 19,009.24** (20,000 → 19,009.24)
- Total Profit: **185,746.56**

| Product | Produced Amount | Total Profit |
|---|---|---|
| Premium Dairy Drink | 19,009.24 | 133,064.69 |
| Standard Dairy Drink | 0.00 | 0.00 |
| Cooking Cream | 12,982.97 | 51,931.86 |
| Dairy Base Mix | 0.00 | 0.00 |
| Butter Solids | 500.00 | 750.00 |

> ※ The number of decimal places or the wording Explainer shows may differ, but the key figures
> (relaxation ≈ 990.8 barrels, total profit ≈ 185,746.6) must match the above. Profit is lower than
> in `1_Modeler` (211,365.13) because ingredients that would otherwise go into other high-margin
> products (such as the Standard Drink) are pulled away to meet the premium drink requirement.

### Sample Explainer Response

If you can't picture what kind of response you'll get, expand the example below. (Try asking
Explainer yourself first, and expand this only if you get stuck. Below is an actual response
obtained by continuing the same API session as Part 1.)

<details>
<summary>Show the sample response</summary>

> **You**: Only the premium minimum output requirement we just added (`Minimum_Premium`) can be
> adjusted; the other physical capacities and quality standards are non-negotiable. If we relax
> only the premium minimum output requirement, how much do we need to reduce it to make the model
> feasible?

Explainer runs `feasRelax`, re-solves the repaired model with Gurobi to verify feasibility, and then
reports:

| Item | Current value | Maximum after relaxation | Required reduction |
|---|---|---|---|
| `Minimum_Premium` RHS | 20,000 units | **19,009.24 units** | ≈ 990.76 units |

> With all current physical constraints (process capacities, quality standards, raw milk input caps)
> kept in place, the maximum achievable Premium_drink output is 19,009 units. The original target of
> 20,000 units cannot be achieved with the existing equipment and raw material conditions, so we
> recommend adjusting the requirement to 19,009 units or less.

The repaired model (`moodel_repaired.lp`) has an objective value of **185,746.56**, and at the end
Explainer asks whether you'd like to run a sensitivity analysis on the repaired model next.

</details>

## Part 3. Sensitivity Analysis — Where Should We Invest? (Q3)

![The team celebrates: "We did it! The model is feasible!" The Friesland Ridge Dairy CFO bursts in — "HA! My heroes!" — praises them for keeping the milk trucks rolling, then leans back on a pile of money bags: "But now, tell me: where should we invest to make even more profit?" "Seriously?"](assets/explainer_q3_investment.jpg)

The problem doesn't end there. The plant is running again, but the CFO immediately follows up —
*"But now, tell me: where should we invest to make even more profit?"*

### Steps

1. In Explainer, select the **Sensitivity Analysis** tab and upload the repaired (relaxed) model
   from Part 2. (If you didn't get a file in Part 2, use
   [`models/moodel_repaired.lp`](models/moodel_repaired.lp) instead.)
2. Example question: *"Which unit capacity should we expand to improve profit the most? By how much
   would it improve, and how far can we expand it?"*
3. Check the **shadow price** and **valid range** for these three capacity constraints:
   - Maximum separation capacity: 45,000 barrels/day
   - Protein concentration capacity: 10,000 barrels/day
   - Secondary processing capacity: 8,000 barrels/day

### Expected Results

| Unit | Shadow price (hundreds of dollars / barrel·day) | Valid range (upper) |
|---|---|---|
| Separation capacity | 0.00 (not binding) | N/A |
| Protein concentration capacity | **74.50** | Up to ≈ 10,301 barrels/day (+301 barrels) |
| Secondary processing capacity | **16.35** | Up to ≈ 9,444 barrels/day (+1,444 barrels) |

**Investment priority**: Expand the **protein concentration unit** first. Its marginal profit per
barrel (74.50) is about **4.6×** that of the secondary processing unit (16.35), giving the best
return on investment. Note, however, that this shadow price only holds while the current optimal
basis remains unchanged (up to +301 barrels/day); expanding beyond that requires a new sensitivity
analysis. Separation capacity already has slack (shadow price 0), so it is not an investment
priority.

### Sample Explainer Response

If you can't picture what kind of response you'll get, expand the example below. (Try asking
Explainer yourself first, and expand this only if you get stuck. Below is an actual response
obtained in the same session as Parts 1 and 2, uploading the repaired model from Part 2
(`moodel_repaired.lp`) as-is and continuing the conversation.)

<details>
<summary>Show the sample response</summary>

> **You**: Now run a sensitivity analysis on the model we just repaired (`moodel_repaired.lp`).
> Which unit capacity should we expand to improve profit the most? Give me the shadow prices and
> valid ranges (how far each can be expanded) for the three capacity constraints: separation
> capacity (45,000), protein concentration capacity (10,000), and secondary processing capacity
> (8,000).

Explainer leads with its conclusion, summarized as an investment priority table.

| Rank | Unit | Shadow price | Max expansion within current basis | Status |
|---|---|---|---|---|
| **1st** | Protein concentration (`Protein_conc_cap`, 10,000) | **+74.50 / unit** | +301 units (→ 10,301) | Binding |
| **2nd** | Secondary processing (`Secondary_proc_cap`, 8,000) | **+16.35 / unit** | +1,444 units (→ 9,444) | Binding |
| **No investment needed** | Separation (Separation, 45,000) | **0** | — | Non-binding |

> Shadow prices and valid ranges hold only while the current optimal basis is maintained. For
> example, expanding the protein concentration unit beyond 10,301 or the secondary processing unit
> beyond 9,444 changes the basis, and the effect beyond that point needs a separate analysis.

</details>
