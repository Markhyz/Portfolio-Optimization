set autoscale xfixmax
set xzeroaxis
set xlabel 'Período'
set ylabel 'Retorno (%)'
plot 'Ibovespa/2016_2018/plot_data/cdi.dat' title 'CDI' with lines lw 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/bvsp.dat' title 'Ibovespa' with lines lw 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_CVaR/balanced_portfolio.dat' title 'M-CVaR' with lines lw 2 dt 1,\
     'Ibovespa/2016_2018/plot_data/M_Variance/balanced_portfolio.dat' title 'M-V' with lines lw 2 dt 1