from datetime import date
import csv
import sys
import os
import math

startDate = date.fromisoformat(sys.argv[1])
endDate = date.fromisoformat(sys.argv[2])

assets = {}
assetsDateRange = set()

for (root, dirs, files) in os.walk('assets'):
  for asset in files:
    with open(f'assets/{asset}') as assetData:
      reader = csv.DictReader(assetData, delimiter=',')
      assets[asset] = {}
      for row in reader:
        priceDate, price = row['Date'], row['Adj Close']
        if price != 'null':
          priceDateObj = date.fromisoformat(priceDate)
          if priceDateObj >= startDate and priceDateObj <= endDate:
            assetsDateRange.add(priceDate)
          assets[asset][priceDate] = float(price)

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
  for priceDate in sorted(assetsDateRange):
    if priceDate in assetDateRange:
      assetRange += 1
      prices.append(assetDateRange[priceDate])
    else:
      prices.append(prices[-1])
  prices = prices[1:]
  if assetRange / dateRangeLength >= 0.95:
    returns = []
    for i in range(1, len(prices)):
      returns.append(math.log(prices[i]) - math.log(prices[i - 1]))
    assert len(returns) == dateRangeLength - 1
    assetsReturns[asset] = returns

for asset, returns in assetsReturns.items():
  assetOutput = asset.replace('.csv', '') + '.in'
  with open(f'assets_input/{assetOutput}', 'w') as output:
    for r in returns:
      ret = '{:.9f}\n'.format(r)
      output.write(ret)
          