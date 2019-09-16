from datetime import date
import csv
import sys
import os
import math

assets_dir = sys.argv[1]
in_sample_output_dir = sys.argv[2]
in_sample_start_date = date.fromisoformat(sys.argv[3])
in_sample_end_date = date.fromisoformat(sys.argv[4])
out_sample_output_dir = sys.argv[5]
out_sample_start_date = date.fromisoformat(sys.argv[6])
out_sample_end_date = date.fromisoformat(sys.argv[7])

assets = {}
in_sample_assets_date_range = set()
out_sample_assets_date_range = set()

def readAssetFile(asset_file):
  with open(f'{assets_dir}/{asset_file}') as asset_data:
    reader = csv.DictReader(asset_data, delimiter=',')
    assets[asset] = {}
    for row in reader:
      price_date, price = row['Date'], row['Adj Close']
      if price != 'null':
        price_date_obj = date.fromisoformat(price_date)
        if price_date_obj >= in_sample_start_date and price_date_obj <= in_sample_end_date:
          in_sample_assets_date_range.add(price_date)
        if price_date_obj >= out_sample_start_date and price_date_obj <= out_sample_end_date:
          out_sample_assets_date_range.add(price_date)
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

in_sample_assets_date_range = sorted(in_sample_assets_date_range)
out_sample_assets_date_range = sorted(out_sample_assets_date_range)

in_sample_assets_returns = getAssetsReturns(in_sample_assets_date_range, in_sample_start_date)
out_sample_assets_returns = getAssetsReturns(out_sample_assets_date_range, out_sample_start_date)

valid_assets = list(filter(lambda asset: asset in in_sample_assets_returns and asset in out_sample_assets_returns, assets.keys()))

def writeAssetsReturns(assets_returns, output_dir):
  for asset in valid_assets:
    if asset in assets_returns:
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

writeAssetsReturns(in_sample_assets_returns, in_sample_output_dir)
writeAssetsReturns(out_sample_assets_returns, out_sample_output_dir)