from datetime import date
import csv
import sys
import os
import math

assets_dir = sys.argv[1]
output_dir = sys.argv[2]
start_date = date.fromisoformat(sys.argv[3])
end_date = date.fromisoformat(sys.argv[4])

assets = {}
assets_date_range = set()

def readAssetFile(asset_file):
  with open(f'{assets_dir}/{asset_file}') as asset_data:
    reader = csv.DictReader(asset_data, delimiter=',')
    assets[asset] = {}
    for row in reader:
      price_date, price = row['Date'], row['Adj Close']
      if price != 'null':
        price_date_obj = date.fromisoformat(price_date)
        if price_date_obj >= start_date and price_date_obj <= end_date:
          assets_date_range.add(price_date)
        assets[asset][price_date] = float(price)

for (root, dirs, files) in os.walk(assets_dir):
  for asset in files:
    readAssetFile(asset)

def getAssetsReturns(assets_date_range, start_date):
  assets_returns = {}
  date_range_len = len(assets_date_range)
  for asset, asset_date_range in assets.items():
    asset_range_len = 0
    prices = [0.0]
    for price_date, price in asset_date_range.items():
      price_date_obj = date.fromisoformat(price_date)
      if price_date_obj < start_date:
        prices[0] = price
      else:
        break
    for price_date in assets_date_range:
      if price_date in asset_date_range:
        asset_range_len += 1
        prices.append(asset_date_range[price_date])
      else:
        prices.append(prices[-1])
    prices = prices[1:]
    if asset_range_len / date_range_len >= 0.95:
      diff_returns = []
      perc_returns = []
      for i in range(1, len(prices)):
        diff_returns.append(math.log(prices[i]) - math.log(prices[i - 1]))
        perc_returns.append((assets_date_range[i], (prices[i] - prices[i - 1]) / prices[i - 1]))
      assert len(diff_returns) == date_range_len - 1
      assets_returns[asset] = (diff_returns, perc_returns)
  return assets_returns

assets_date_range = sorted(assets_date_range)
assets_returns = getAssetsReturns(assets_date_range, start_date)

def writeAssetsReturns(assets_returns, output_dir):
  for asset in assets_returns.keys():
    diff_returns, perc_returns = assets_returns[asset]
    asset_output = asset.replace('.csv', '')
    with open(f'{output_dir}/{asset_output}.in', 'w') as output:
      for r in diff_returns:
        ret = '{:.9f}\n'.format(r)
        output.write(ret)
    with open(f'{output_dir}/{asset_output}.inp', 'w') as output:
      for r_date, r in perc_returns:
        ret = '{} {:.9f}\n'.format(r_date, r)
        output.write(ret)

writeAssetsReturns(assets_returns, output_dir)