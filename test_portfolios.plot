set term qt size 1360,600
plot 'test_portfolios.dat' with points ps 2 pt 7,\
 'Ibovespa/2015/portfolio_data/M_CVaR_Card/port.fit' with points pt 7 ps 0.5,\
 'Ibovespa/2015/portfolio_data/M_CVaR_Skew_Kurt_Card/port.fit' using 1:2 with points pt 7 ps 0.5