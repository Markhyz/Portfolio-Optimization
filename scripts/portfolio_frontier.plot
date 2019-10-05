set term qt size 1360,600
port_selection = sprintf("%s/port.selection", port_dir)
port_mv = sprintf("%s/port.mv", port_dir)
plot port_selection using 1:2 with points ps 2 pt 7, port_mv using 1:2 with points pt 7 ps 0.5
