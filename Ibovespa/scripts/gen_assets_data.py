from datetime import date
import csv
import sys
import os
import math

assets_dir = sys.argv[1]
output_dir = sys.argv[2]
startDate = date.fromisoformat(sys.argv[3])
endDate = date.fromisoformat(sys.argv[4])

assets = {}
assetsDateRange = set()

for (root, dirs, files) in os.walk(assets_dir):
  for asset in files:
    with open(f'{assets_dir}/{asset}') as assetData:
      reader = csv.DictReader(assetData, delimiter=',')
      assets[asset] = {}
      for row in reader:
        priceDate, price = row['Date'], row['Adj Close']
        if price != 'null':
          priceDateObj = date.fromisoformat(priceDate)
          if priceDateObj >= startDate and priceDateObj <= endDate:
            assetsDateRange.add(priceDate)
          assets[asset][priceDate] = float(price)

assetsDateRange = sorted(assetsDateRange)
dateRangeLength = len(assetsDateRange)
assetsReturns = {}

for asset, assetDateRange in assets.items():
  assetRange = 0
  prices = [0.0]
  for priceDate, price in assetDateRange.items():
    priceDateObj = date.fromisoformat(priceDate)
    if priceDateObj < startDate:
      prices[0] = price
    else:
      break
  for priceDate in assetsDateRange:
    if priceDate in assetDateRange:
      assetRange += 1
      prices.append(assetDateRange[priceDate])
    else:
      prices.append(prices[-1])
  prices = prices[1:]
  if assetRange / dateRangeLength >= 0.95:
    diff_returns = []
    perc_returns = []
    for i in range(1, len(prices)):
      diff_returns.append(math.log(prices[i]) - math.log(prices[i - 1]))
      perc_returns.append((assetsDateRange[i], (prices[i] - prices[i - 1]) / prices[i - 1]))
    assert len(diff_returns) == dateRangeLength - 1
    assetsReturns[asset] = (diff_returns, perc_returns)

for asset, (diff_returns, perc_returns) in assetsReturns.items():
  assetOutput = asset.replace('.csv', '')
  with open(f'{output_dir}/{assetOutput}.in', 'w') as output:
    for r in diff_returns:
      ret = '{:.9f}\n'.format(r)
      output.write(ret)
  with open(f'{output_dir}/{assetOutput}.inp', 'w') as output:
    for r_date, r in perc_returns:
      ret = '{} {:.9f}\n'.format(r_date, r)
      output.write(ret)


          
