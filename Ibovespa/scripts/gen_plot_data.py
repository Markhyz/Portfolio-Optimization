import sys

data_file = sys.argv[1]
output_file = sys.argv[2]
plot_title = sys.argv[3]

with open(f'{output_file}', 'w') as output:
  output.write(f'# {plot_title}\n')
  with open(f'{data_file}') as data:
    file_lines = data.readlines()
    idx = 1
    for line in file_lines:
      value = float(line) * 100
      output.write('{} {:.9f}\n'.format(idx, value))
      idx += 1