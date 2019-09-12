set term qt size 1360,600
set autoscale xfixmax
set xzeroaxis
set xlabel 'Período'
set ylabel 'Retorno (%)'
set key outside
plot 'Ibovespa/2016_2018/plot_data/cdi.dat' title 'CDI' with linespoints lw 1.5 pi 50 ps 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/bvsp.dat' title 'Ibovespa' with linespoints lw 1.5 pi 50 ps 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_CVaR_Card/balanced_portfolio.dat' title 'M-CVaR-Card' with linespoints lw 1.5 pi 50 ps 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_Variance_Card/balanced_portfolio.dat' title 'M-V-Card' with linespoints lw 1.5 pi 50 ps 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_Variance/balanced_portfolio.dat' title 'M-V' with linespoints lw 1.5 pi 50 ps 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_CVaR/balanced_portfolio.dat' title 'M-CVaR' with linespoints lw 1.5 pi 50 ps 2 dt 1