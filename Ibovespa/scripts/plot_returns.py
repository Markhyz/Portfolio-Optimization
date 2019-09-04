import sys
import os

plot_dir = sys.argv[1] 

plots = []

for (root, dirs, files) in os.walk(plot_dir):
  idx = 1
  for plot_file in files:
    if '.dat' not in plot_file: continue
    with open(f'{plot_dir}/{plot_file}') as plot_data:
      line = plot_data.readline()
      plot_title = line.split()[1]
      plots.append('\'{}\' title \'{}\' with lines lw 2 dt {}'.format(plot_file, plot_title, 1))
    idx += 1

with open(f'{plot_dir}/returns.plot', 'w') as output_file:
  output_file.write('set term pngcairo size 800,600\n')
  output_file.write('set autoscale xfixmax\n')
  output_file.write('set xzeroaxis\n')
  output_file.write('set xlabel \'Período\'\n')
  output_file.write('set ylabel \'Retorno (%)\'\n')
  plot_lines = ', '.join(plots)
  output_file.write('plot {}\n'.format(plot_lines))