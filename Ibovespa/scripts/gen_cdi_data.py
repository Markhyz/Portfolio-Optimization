from datetime import date, timedelta
import sys

def toIsoDate(dirty_date):
  return '-'.join(reversed(dirty_date.split('/')))

def toRealNumber(dirty_num):
  return dirty_num.replace(',', '.')

cdi_file = sys.argv[1]
output_file = sys.argv[2]
start_date = date.fromisoformat(sys.argv[3])
end_date = date.fromisoformat(sys.argv[4])

first_date = None
last_date = None
cdi = {}

with open(cdi_file) as cdi_data:
  file_lines = cdi_data.readlines()
  for line in file_lines:
    line_data = line.split()
    value_date = date.fromisoformat(toIsoDate(line_data[0]))
    value = float(toRealNumber(line_data[3]))
    cdi[value_date] = value
    if first_date is None: first_date = value_date
    last_date = value_date

cdi_returns = {}

cur_date = start_date
while cur_date <= end_date:
  if cur_date in cdi:
    cdi_return = (1 + cdi[cur_date] / 100) ** (1 / 252)
    cdi_returns[cur_date] = cdi_return - 1
  cur_date += timedelta(days=1)

with open(f'{output_file}', 'w') as output:
  for return_date, r in cdi_returns.items():
    ret = '{} {:.9f}\n'.format(return_date, r)
    output.write(ret)
