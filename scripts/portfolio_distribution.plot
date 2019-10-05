set term qt size 1360,600
set yzeroaxis
set xrange [-0.2:0.2]
set yrange [0:20]
set boxwidth 0.0005 absolute
set style fill solid 1.0 noborder
bin_width = 0.001
bin_number(x) = floor(x / bin_width)
rounded(x) = bin_width * (bin_number(x) + 0.5)

plot portfolio using (rounded($1)):(1) smooth frequency with boxes