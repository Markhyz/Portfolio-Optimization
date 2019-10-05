from statistics import mean

def generatePortfolioDistribution(portfolio, assets_dir):
  assets_returns = []
  for asset, weight in portfolio:
    asset_returns = []
    with open(f'{assets_dir}/{asset}.inp') as asset_data:
      for line in asset_data:
        line_data = line.split()
        value = float(line_data[1])
        asset_returns.append(value)
    assets_returns.append(asset_returns)
  assets_mean = [mean(asset_returns) for asset_returns in assets_returns]
  portfolio_mean = sum([assets_mean[i] * portfolio[i][1] for i in range(len(portfolio))])
  portfolio_distribution = []
  for i in range(len(assets_returns[0])):
    ret = 0.0
    for j in range(len(assets_returns)):
      ret += portfolio[j][1] * assets_returns[j][i]
    portfolio_distribution.append(ret - portfolio_mean)
  return portfolio_distribution
