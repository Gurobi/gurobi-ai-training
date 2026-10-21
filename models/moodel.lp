\ Model Dairy_Processing_Optimization
\ LP format - for model browsing. Use MPS format to capture full model detail.
Maximize
  7 end_prod[Premium_drink] + 6 end_prod[Standard_drink]
   + 4 end_prod[Cooking_cream] + 3.5 end_prod[Dairy_base_mix]
   + 1.5 end_prod[Butter_solids]
Subject To
 Separation_cap: milk_in[1] + milk_in[2] <= 45000
 Protein_conc_cap: creams_to_protein_concentrate[Light_cream]
   + creams_to_protein_concentrate[Medium_cream]
   + creams_to_protein_concentrate[Heavy_cream] <= 10000
 Secondary_proc_cap: milk_bases_to_secondary_processing[Skim_milk]
   + milk_bases_to_secondary_processing[Concentrated_skim] <= 8000
 Splitting_separation[Light_cream]: 0.1 milk_in[1] + 0.15 milk_in[2]
   - sep_prod[Light_cream] = 0
 Splitting_separation[Medium_cream]: 0.2 milk_in[1] + 0.25 milk_in[2]
   - sep_prod[Medium_cream] = 0
 Splitting_separation[Heavy_cream]: 0.2 milk_in[1] + 0.18 milk_in[2]
   - sep_prod[Heavy_cream] = 0
 Splitting_separation[Skim_milk]: 0.12 milk_in[1] + 0.08 milk_in[2]
   - sep_prod[Skim_milk] = 0
 Splitting_separation[Concentrated_skim]: 0.2 milk_in[1] + 0.19 milk_in[2]
   - sep_prod[Concentrated_skim] = 0
 Splitting_separation[Residual_solids]: 0.13 milk_in[1] + 0.12 milk_in[2]
   - sep_prod[Residual_solids] = 0
 Splitting_protein_concentration:
   0.6 creams_to_protein_concentrate[Light_cream]
   + 0.52 creams_to_protein_concentrate[Medium_cream]
   + 0.45 creams_to_protein_concentrate[Heavy_cream] - protein_concentrate
   = 0
 Splitting_secondary_processing[Fermented_concentrate]:
   0.28 milk_bases_to_secondary_processing[Skim_milk]
   + 0.2 milk_bases_to_secondary_processing[Concentrated_skim]
   - secondary_prods[Fermented_concentrate] = 0
 Splitting_secondary_processing[Processed_base]:
   0.68 milk_bases_to_secondary_processing[Skim_milk]
   + 0.75 milk_bases_to_secondary_processing[Concentrated_skim]
   - secondary_prods[Processed_base] = 0
 Splitting_butter_solids: - end_prod[Butter_solids]
   + 0.5 residual_used_for_butter = 0
 Blending_premium_drink: - end_prod[Premium_drink]
   + to_premium_drink[Light_cream] + to_premium_drink[Medium_cream]
   + to_premium_drink[Heavy_cream] + to_premium_drink[Protein_concentrate]
   + to_premium_drink[Fermented_concentrate] = 0
 Blending_standard_drink: - end_prod[Standard_drink]
   + to_standard_drink[Light_cream] + to_standard_drink[Medium_cream]
   + to_standard_drink[Heavy_cream]
   + to_standard_drink[Protein_concentrate]
   + to_standard_drink[Fermented_concentrate] = 0
 Continuity_cooking_cream: - end_prod[Cooking_cream]
   + to_cooking_cream[Skim_milk] + to_cooking_cream[Concentrated_skim]
   + to_cooking_cream[Residual_solids] + to_cooking_cream[Processed_base]
   = 0
 Continuity_creams[Light_cream]: - sep_prod[Light_cream]
   + creams_to_protein_concentrate[Light_cream]
   + to_standard_drink[Light_cream] + to_premium_drink[Light_cream] = 0
 Continuity_creams[Medium_cream]: - sep_prod[Medium_cream]
   + creams_to_protein_concentrate[Medium_cream]
   + to_standard_drink[Medium_cream] + to_premium_drink[Medium_cream] = 0
 Continuity_creams[Heavy_cream]: - sep_prod[Heavy_cream]
   + creams_to_protein_concentrate[Heavy_cream]
   + to_standard_drink[Heavy_cream] + to_premium_drink[Heavy_cream] = 0
 Fixed_proportion_skim_for_base_mix: 0.55 end_prod[Dairy_base_mix]
   - sep_prod[Skim_milk] + milk_bases_to_secondary_processing[Skim_milk]
   + to_cooking_cream[Skim_milk] = 0
 Fixed_proportion_conc_skim_for_base_mix: 0.17 end_prod[Dairy_base_mix]
   - sep_prod[Concentrated_skim]
   + milk_bases_to_secondary_processing[Concentrated_skim]
   + to_cooking_cream[Concentrated_skim] = 0
Minimum_Premium: end_prod[Premium_drink] >= 20000.0
 Fixed_proportion_processed_base_for_base_mix:
   0.22 end_prod[Dairy_base_mix] - secondary_prods[Processed_base]
   + to_cooking_cream[Processed_base] = 0
 Fixed_proportion_residual_for_base_mix: 0.055 end_prod[Dairy_base_mix]
   - sep_prod[Residual_solids] + to_cooking_cream[Residual_solids]
   + residual_used_for_butter = 0
 Continuity_fermented_concentrate: - secondary_prods[Fermented_concentrate]
   + to_standard_drink[Fermented_concentrate]
   + to_premium_drink[Fermented_concentrate] = 0
 Continuity_protein_concentrate: - protein_concentrate
   + to_standard_drink[Protein_concentrate]
   + to_premium_drink[Protein_concentrate] = 0
 Prem2std_prop: end_prod[Premium_drink] - 0.4 end_prod[Standard_drink]
   >= 0
 Quality_tol_standard_drink: - 84 end_prod[Standard_drink]
   + 90 to_standard_drink[Light_cream] + 80 to_standard_drink[Medium_cream]
   + 70 to_standard_drink[Heavy_cream]
   + 115 to_standard_drink[Protein_concentrate]
   + 105 to_standard_drink[Fermented_concentrate] >= 0
 Quality_tol_premium_drink: - 94 end_prod[Premium_drink]
   + 90 to_premium_drink[Light_cream] + 80 to_premium_drink[Medium_cream]
   + 70 to_premium_drink[Heavy_cream]
   + 115 to_premium_drink[Protein_concentrate]
   + 105 to_premium_drink[Fermented_concentrate] >= 0
 Volatility_tol_cooking_cream: - end_prod[Cooking_cream]
   + to_cooking_cream[Skim_milk] + 0.6 to_cooking_cream[Concentrated_skim]
   + 0.05 to_cooking_cream[Residual_solids]
   + 1.5 to_cooking_cream[Processed_base] <= 0
Bounds
 milk_in[1] <= 20000
 milk_in[2] <= 30000
 500 <= end_prod[Butter_solids] <= 1000
End
