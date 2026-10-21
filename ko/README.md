# Gurobi AI Training

[English](../README.md) | **한국어** | [简体中文](../zh-Hans/README.md) | [繁體中文](../zh-Hant/README.md)

**Gurobi Intelligence Hub**([intelligence.gurobi.com](https://intelligence.gurobi.com))를 위한 실습
교육 자료입니다. Intelligence Hub는 최적화 모델을 만들고 진단하는 Gurobi의 AI 에이전트 서비스입니다.
비즈니스 문제를 자연어로 설명하면 **Modeler**가 이를 검증된 `gurobipy` 모델로 만들어주고, 모델에
문제가 생기면 **Explainer**로 그 모델을 진단·수리·분석합니다.

모든 모델링과 진단 작업은 웹 브라우저에서 진행합니다. 이 저장소의 가이드에는 실행할 코드가 없으며,
문제 설명, 단계별 진행 방법, 그리고 결과를 확인할 수 있는 예상 결과를 제공합니다. 실습을 따라 하려면
Intelligence Hub 계정이 필요합니다.

---

## 목차

| # | 주제 | 가이드 |
|---|------|------|
| 1 | Modeler로 모델 만들기 | [1_Modeler.md](1_Modeler.md) |
| 2 | Explainer로 모델 진단하기 | [2_Explainer.md](2_Explainer.md) |

실습 중 업로드하는 파일:

| 파일 | 사용하는 곳 |
|---|---|
| [`data/production_planning.csv`](../data/production_planning.csv) | `1_Modeler` Part 0(워밍업) — Modeler 프롬프트에 첨부 |
| [`models/moodel.lp`](../models/moodel.lp) | `2_Explainer` Part 1–2 — 실행 불가능한 유가공 공장 모델 |
| [`models/moodel_repaired.lp`](../models/moodel_repaired.lp) | `2_Explainer` Part 3 — Part 2에서 Explainer로부터 수리된 모델을 받지 못했을 때 대신 사용 |

---

## 학습 내용

### 1. Modeler로 모델 만들기 (`1_Modeler.md`)

**Modeler**(Beta)가 자연어로 설명한 문제를 스펙, `gurobipy` 코드, 테스트까지 이어가는 과정을
경험합니다. 가이드는 세 부분으로 구성됩니다.

- **Part 0. 워밍업**: 이미 정답이 알려진 생산 계획 문제를 Modeler에게 맡기고 결과를 비교하며, AI가
  만든 모델을 검증하는 습관을 들입니다.
- **Part 1. 본 실습**: 프리미엄 음료 하나만 생산하는 단순화된 유가공 공장을 모델링하고, 약 30분 안에
  feasible한 최적해를 얻습니다.
- **부록. 전체 공정 모델**: 같은 공장을 원유 두 종류, 제품 다섯 가지로 확장한 버전입니다. 여기서
  만든 모델이 Explainer 실습으로 이어집니다.

### 2. Explainer로 모델 진단하기 (`2_Explainer.md`)

**Explainer**(Experimental)로 실행 불가능한 모델을 진단·수리·분석합니다.

- **Infeasibility Diagnosis**: IIS(서로 충돌하는 최소 제약 집합)로 원인 찾기
- **Feasibility Restoration**: `feasRelax`로 최소 완화량 계산하기
- **Sensitivity Analysis**: 섀도우 프라이스로 투자 우선순위 정하기

---

## 시작하기

1. [intelligence.gurobi.com](https://intelligence.gurobi.com)에 로그인합니다.
2. [1_Modeler.md](1_Modeler.md)를 따라 진행한 뒤, [2_Explainer.md](2_Explainer.md)로 이어갑니다.
3. 실습에서 업로드하라고 할 때 위에 정리한 데이터·모델 파일을 내려받습니다(또는 저장소를 clone해
   모든 파일을 로컬에 받아둘 수 있습니다). 한국어 가이드는 저장소의 `ko/` 폴더에 있습니다.

   ```bash
   git clone https://github.com/Gurobi/gurobi-ai-training.git
   ```

---

## 마무리

- **Modeler**로 자연어 문제 설명에서 검증된 모델까지 만들 수 있습니다.
- **Explainer**로 그 모델을 진단·수리·분석할 수 있습니다.

실무에서는 이 두 에이전트를 묶어 "모델링 → 운영 중 문제 대응"으로 이어지는 워크플로를 만들 수
있습니다. 다만 두 실습에서 강조했듯, AI 에이전트가 만든 모델과 설명을 무조건 신뢰하지 말고
acceptance test 등으로 직접 검증하는 습관을 들이세요.

---

## 참고 자료

- [Gurobi 문서](https://docs.gurobi.com/)
- [gurobipy API 레퍼런스](https://docs.gurobi.com/projects/optimizer/en/current/reference/python/)
- [Gurobi 예제](https://docs.gurobi.com/projects/examples/en/current/)
- [Gurobi Intelligence Hub](https://intelligence.gurobi.com)
