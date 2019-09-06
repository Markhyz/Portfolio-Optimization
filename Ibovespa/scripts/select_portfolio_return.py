from datetime import date, timedelta
import sys

portfolio_ind = sys.argv[1]
portfolio_fit = sys.argv[2]
selection = int(sys.argv[3]) - 1
assets_dir = sys.argv[4]
output_dir = sys.argv[5]
start_date = date.fromisoformat(sys.argv[6])
end_date = date.fromisoformat(sys.argv[7])

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
    f1, f2 = [float(value) for value in line.split()]
    portfolio_obj.append((f1, f2))

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

portfolio = sorted(list(enumerate(portfolio)), key=lambda x: x[1][1][0])
selected_portfolio = portfolio[selection][1][0]

print("Selected portfolio {}\n".format(portfolio[selection][0] + 1))

selected_returns = generatePortfolioReturns(selected_portfolio)


with open(f'{output_dir}/selected_portfolio.ret', 'w') as output_file:
  for r in selected_returns:
    ret = '{:.9f}\n'.format(r)
    output_file.write(ret)