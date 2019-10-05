from datetime import date, timedelta
from statistics import mean
from portfolio_distribution import generatePortfolioDistribution  
import sys

portfolio_assets_dir = sys.argv[1]
portfolio_result_dir = sys.argv[2]
portfolio_ind = sys.argv[3]
portfolio_fit = sys.argv[4]
assets_dir = sys.argv[5]
output_dir = sys.argv[6]
start_date = date.fromisoformat(sys.argv[7])
end_date = date.fromisoformat(sys.argv[8])

portfolio_assets = []

with open(portfolio_ind) as ind_data:
  line = ind_data.readline()
  while line != "":
    assets = line.split()
    line = ind_data.readline()
    weights = list(map(float, line.split()))
    portfolio_assets.append(list(zip(assets, weights)))
    line = ind_data.readline()

portfolio_obj = []

with open(portfolio_fit) as fit_data:
  for line in fit_data:
    obj = [float(value) for value in line.split()]
    portfolio_obj.append(obj)

portfolio = list(zip(portfolio_assets, portfolio_obj))

def generatePortfolioStats(assets):
  assets_returns = {}
  for asset, weight in assets:
    asset_returns = []
    with open(f'{portfolio_assets_dir}/{asset}.inp') as asset_data:
      for line in asset_data:
        line_data = line.split()
        value = float(line_data[1])
        asset_returns.append(value)
    assets_returns[asset] = asset_returns
  assets_mean = [mean(asset_returns) for asset_returns in assets_returns.values()]
  assets_covariance = []
  for index, asset in enumerate(assets_returns.keys()):
    asset_covariance = []
    for index2, asset2 in enumerate(assets_returns.keys()):
      covariance = 0.0
      for value, value2 in zip(assets_returns[asset], assets_returns[asset2]):
        covariance += (assets_mean[index] - value) * (assets_mean[index2] - value2)
      asset_covariance.append(covariance / (len(assets_returns[asset]) - 1))
    assets_covariance.append(asset_covariance)
  assets_skewness = []
  assets_kurtosis = []
  for index, asset in enumerate(assets_returns.keys()):
    asset_skewness = []
    asset_kurtosis = []
    for index2, asset2 in enumerate(assets_returns.keys()):
      skewnewss = 0.0
      kurtosis = 0.0
      middle_kurtosis = 0.0
      for value, value2 in zip(assets_returns[asset], assets_returns[asset2]):
        x = assets_mean[index] - value
        x2 = assets_mean[index2] - value2
        skewnewss += x * x * x2
        kurtosis += x * x * x * x2
        middle_kurtosis += x * x * x2 * x2
      t = len(assets_returns[asset])
      asset_skewness.append(skewnewss / (t - 1))
      asset_kurtosis.append((kurtosis / (t - 1), middle_kurtosis / (t - 1)))
    assets_skewness.append(asset_skewness)
    assets_kurtosis.append(asset_kurtosis)
  portfolio_mean = sum([assets_mean[i] * assets[i][1] for i in range(len(assets))])
  portfolio_variance = 0.0
  for i in range(len(assets)):
    for j in range(len(assets)):
      portfolio_variance += assets_covariance[i][j] * assets[i][1] * assets[j][1]
  portfolio_skewness = 0.0
  for i in range(len(assets)):
    portfolio_skewness += (assets[i][1] ** 3) * (assets_skewness[i][i] ** 3)
    x = assets[i][1] 
    s1 = 0.0
    for j in range(len(assets)):
      if (i == j): continue
      y = assets[j][1]
      s1 += x * x * y * assets_skewness[i][j] + x * y * y * assets_skewness[j][i]
    portfolio_skewness += 3 * s1
  portfolio_kurtosis = 0.0
  for i in range(len(assets)):
    portfolio_kurtosis += (assets[i][1] ** 4) * (assets_kurtosis[i][i][0] ** 4)
    x = assets[i][1]
    s1 = 0.0
    s2 = 0.0
    for j in range(len(assets)):
      if (i == j): continue
      y = assets[j][1]
      s1 += x * x * x * y * assets_kurtosis[i][j][0] + x * y * y * y * assets_kurtosis[j][i][0]
      s2 += x * x * y * y * assets_kurtosis[i][j][1]
    portfolio_kurtosis += 4 * s1 + 6 * s2
  return (portfolio_mean, portfolio_variance, portfolio_skewness, portfolio_kurtosis)

def generatePortfolioReturns(assets):
  asset_dates = {}
  asset_values = []
  for asset, weight in assets:
    with open(f'{assets_dir}/{asset}.inp') as asset_data:
      for line in asset_data:
        line_data = line.split()
        value_date = date.fromisoformat(line_data[0])
        value = float(line_data[1])
        if value_date not in asset_dates:
          asset_dates[value_date] = []
        asset_dates[value_date].append(value)
    asset_values.append(weight)
  returns = []
  cur_date = start_date
  while cur_date <= end_date:
    if cur_date in asset_dates:
      changes = asset_dates[cur_date]
      for i in range(len(changes)):
        asset_values[i] += asset_values[i] * changes[i]
    returns.append(sum(asset_values) - 1)
    cur_date += timedelta(days=1)
  return returns

portfolio_mvsk = []
for assets, _ in portfolio:
  returns_mean, returns_variance, returns_skew, returns_kurt = generatePortfolioStats(assets)
  portfolio_mvsk.append((returns_mean, returns_variance, returns_skew, returns_kurt))

risky_portfolio, r, r_idx = [], -1e9, 0
safe_portfolio, s, s_idx = [], -1e9, 0
balanced_portfolio, b, b_idx = [], -1e9, 0

for i in range(len(portfolio)):
  assets, obj = portfolio[i]
  ret, risk = obj[0], obj[1]
  performance = (portfolio_mvsk[i][0]) / (portfolio_mvsk[i][1] ** 0.5)
  adjusted_perfomance = performance * (1 + (portfolio_mvsk[i][2] / 6) * performance - ((portfolio_mvsk[i][3] - 3) / 24) * performance * performance)
  if risk >= s:
    s = risk
    s_idx = i + 1
    safe_portfolio = assets
  if ret >= r:
    r = ret
    r_idx = i + 1
    risky_portfolio = assets
  if adjusted_perfomance >= b:
    b = adjusted_perfomance
    b_idx = i + 1
    balanced_portfolio = assets

print("Returns generated for these portfolios (risk, bal, safe): {} {} {}".format(r_idx, b_idx, s_idx))

risky_returns = generatePortfolioReturns(risky_portfolio)
safe_returns = generatePortfolioReturns(safe_portfolio)
balanced_returns = generatePortfolioReturns(balanced_portfolio)

with open(f'{output_dir}/risky_portfolio.ret', 'w') as output_file:
  for r in risky_returns:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

with open(f'{output_dir}/safe_portfolio.ret', 'w') as output_file:
  for r in safe_returns:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

with open(f'{output_dir}/balanced_portfolio.ret', 'w') as output_file:
  for r in balanced_returns:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

risky_distribution = generatePortfolioDistribution(risky_portfolio, portfolio_assets_dir)
safe_distribution = generatePortfolioDistribution(safe_portfolio, portfolio_assets_dir)
balanced_distribution = generatePortfolioDistribution(balanced_portfolio, portfolio_assets_dir)

with open(f'{output_dir}/risky_portfolio.dist', 'w') as output_file:
  for r in risky_distribution:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

with open(f'{output_dir}/safe_portfolio.dist', 'w') as output_file:
  for r in safe_distribution:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

with open(f'{output_dir}/balanced_portfolio.dist', 'w') as output_file:
  for r in balanced_distribution:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)

with open(f'{portfolio_result_dir}/port.mv', 'w') as output_file:
  for portfolio_mean, portfolio_variance, _, _ in portfolio_mvsk:
    mv = '{:.9f} {:.9f}\n'.format(portfolio_mean, portfolio_variance)
    output_file.write(mv)

with open(f'{portfolio_result_dir}/port.selection', 'w') as output_file:
  p_mean, p_variance, _, _ = portfolio_mvsk[s_idx - 1]
  safe = '{:.9f} {:.9f}\n'.format(p_mean, p_variance)
  output_file.write(safe)
  p_mean, p_variance, _, _ = portfolio_mvsk[r_idx - 1]
  risky = '{:.9f} {:.9f}\n'.format(p_mean, p_variance)
  output_file.write(risky)
  p_mean, p_variance, _, _ = portfolio_mvsk[b_idx - 1]
  balanced = '{:.9f} {:.9f}\n'.format(p_mean, p_variance)
  output_file.write(balanced)