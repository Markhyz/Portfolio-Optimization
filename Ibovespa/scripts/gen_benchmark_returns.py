from datetime import date, timedelta
import sys
import os

benchmark_dir = sys.argv[1]
output_dir = sys.argv[2]
start_date = date.fromisoformat(sys.argv[3])
end_date = date.fromisoformat(sys.argv[4])

benchmarks = {}

for (root, dirs, files) in os.walk(benchmark_dir):
  for benchmark_file in files:
    if '.inp' not in benchmark_file: continue
    with open(f'{benchmark_dir}/{benchmark_file}') as benchmark_data:
      file_lines = benchmark_data.readlines()
      benchmark_dates = {}
      for line in file_lines:
        line_data = line.split()
        value_date = date.fromisoformat(line_data[0])
        value = float(line_data[1])
        benchmark_dates[value_date] = value
      benchmarks[benchmark_file] = benchmark_dates

benchmarks_returns = {}

for benchmark, benchmark_dates in benchmarks.items():
  value = 1.0
  cur_date = start_date
  returns = []
  while cur_date <= end_date:
    if cur_date in benchmark_dates:
      value += value * benchmark_dates[cur_date]
    returns.append(value - 1)
    cur_date += timedelta(days=1)
  benchmarks_returns[benchmark] = returns

for benchmark, returns in benchmarks_returns.items():
  benchmark_output = benchmark.replace('.inp', '')
  with open(f'{output_dir}/{benchmark_output}.ret', 'w') as output_file:
    for r in returns:
      ret = '{:.9f}\n'.format(r)
      output_file.write(ret)