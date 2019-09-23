from datetime import date, timedelta
import sys

portfolio_ind = sys.argv[1]
portfolio_fit = sys.argv[2]
assets_dir = sys.argv[3]
output_dir = sys.argv[4]
start_date = date.fromisoformat(sys.argv[5])
end_date = date.fromisoformat(sys.argv[6])

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

risky_portfolio, r, r_idx = [], -1e9, 0
safe_portfolio, s, s_idx = [], -1e9, 0
balanced_portfolio, b, b_idx = [], -1e9, 0

for i in range(len(portfolio)):
  assets, obj = portfolio[i]
  ret, risk = obj[0], obj[1]
  performance = ret * risk
  if risk >= s:
    s = risk
    s_idx = i + 1
    safe_portfolio = assets
  if ret >= r:
    r = ret
    r_idx = i + 1
    risky_portfolio = assets
  # if performance >= b:
  #   b = performance
  #   b_idx = i + 1
  #   balanced_portfolio = assets

portfolio = sorted(list(enumerate(portfolio)), key=lambda x: x[1][1][0])
b_idx = portfolio[len(portfolio) // 2][0] + 1
balanced_portfolio = portfolio[b_idx][1][0]
print(balanced_portfolio)

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