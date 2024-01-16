###################################################################

# Created by write_sdc on Sat Feb 18 01:10:41 2023

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports CK]  -name MY_CLK  -period 4.4  -waveform {0 2.2}
set_clock_uncertainty 0.07  [get_clocks MY_CLK]
set_input_delay -clock MY_CLK  -max 0.5  [get_ports RST_n]
