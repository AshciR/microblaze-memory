
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Project_2_5_2_2 -dir "M:/ECE_574/Verilog_Projects/Project_2_5_2_2/planAhead_run_2" -part xc6slx16csg324-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "M:/ECE_574/Verilog_Projects/Project_2_5_2_2/fgpa_sram.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {M:/ECE_574/Verilog_Projects/Project_2_5_2_2} {ipcore_dir} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "fgpa_sram.ucf" [current_fileset -constrset]
add_files [list {fgpa_sram.ucf}] -fileset [get_property constrset [current_run]]
link_design
