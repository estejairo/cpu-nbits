# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# PrimeTime STA run script for top
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

########################
# Setup

set module_name top
set n-bits 8
set library saed32

#source ./common_setup.tcl
#source ./pt_setup.tcl

# Allow source to use search_path
#set sh_source_uses_search_path true

# Do not allow black boxes for unresolved references
set link_create_black_boxes false


########################
# READ and LINK
set search_path "$search_path . ./rtl/ ./libs/DBs"
set target_library [glob ./libs/DBs/*.db]
set link_path "* $target_library"

# The lab1.v is the netlist generated by DC. The command used "write_file -format verilog -hierarchy -out outputs/lab1.v"
read_verilog ./my_run/mapped_${module_name}${n-bits}bits_${library}.v
link_design ${module_name}_WIDTH${n-bits}

# The parasitics.spef was generated by DC using the command "write_parasitics -output ./outputs/parasitics.spef"
read_parasitics ./my_run/parasitics_${module_name}${n-bits}bits_${library}.spef

########################
# Apply constraints

# The lab1.sdc was generated by DC using the command "write_sdc ./outputs/lab1.sdc"
# lab1.sdc contained all constraints defined at synthesis stage.
read_sdc -echo ./my_run/mapped_${module_name}${n-bits}bits_${library}.sdc

report_analysis_coverage

########################
# Generate report por tweaker

report_constraint -all > constraint.rpt

########################
# Save session

file delete -force ./my_run/pm_session_${module_name}${n-bits}bits_${library}
save_session ./my_run/pm_session_${module_name}${n-bits}bits_${library}

quit
