set term qt size 1360,600
set autoscale xfixmax
set xzeroaxis
set xlabel 'Período'
set ylabel 'Retorno (%)'
set key outside
plot 'Ibovespa/2013_2015/plot_data/M_CVaR_Card/cdi.dat' title 'CDI' with lines lw 2 dt 1,\
     'Ibovespa/2013_2015/plot_data/M_CVaR_Card/bvsp.dat' title 'Ibovespa' with lines lw 2 dt 1,\
     'Ibovespa/2013_2015/plot_data/M_CVaR_Card/balanced_portfolio.dat' title 'M-CVaR-Card' with lines lw 2 dt 1,\
     'Ibovespa/2013_2015/plot_data/M_Variance_Card/balanced_portfolio.dat' title 'M-V-Card' with lines lw 2 dt 1,\
     'Ibovespa/2013_2015/plot_data/M_Variance/balanced_portfolio.dat' title 'M-V' with lines lw 2 dt 1,\
     'Ibovespa/2013_2015/plot_data/M_CVaR/balanced_portfolio.dat' title 'M-CVaR' with lines lw 2 dt 1