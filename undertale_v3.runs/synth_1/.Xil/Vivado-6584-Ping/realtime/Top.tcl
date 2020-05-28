# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.runs/synth_1/.Xil/Vivado-6584-Ping/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    set rt::partid xc7a35tcpg236-1
    source $::env(HRT_TCL_PATH)/rtSynthParallelPrep.tcl
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog -include C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new {
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/GroupnameRom.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/GroupnameSprite.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/MembersRom.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/MembersSprite.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/Seven_segment_LED_Display_Controller.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/StartRom.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/StartSprite.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/character.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/key2ascii.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/keyboard.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/ps2_rx.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/vga640x480.v
      C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.srcs/sources_1/new/Top.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top Top
    rt::set_parameter enableIncremental true
    set rt::reportTiming false
    rt::set_parameter elaborateOnly true
    rt::set_parameter elaborateRtl true
    rt::set_parameter eliminateRedundantBitOperator false
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter merge_flipflops true
    rt::set_parameter srlDepthThreshold 3
    rt::set_parameter rstSrlDepthThreshold 4
# MODE: 
    rt::set_parameter webTalkPath {}
    rt::set_parameter enableSplitFlowPath "C:/Users/Waragon/Downloads/HW_SynLab/HW-Syn-Lab/undertale_v3/undertale_v3.runs/synth_1/.Xil/Vivado-6584-Ping/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_rtlelab -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    if { $rt::flowresult == 1 } { return -code error }


    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}
