import os

for root, dirs, files in os.walk(sys.argv[1]):
    for file_name in files:
        with open("ativos/" + file_name, 'r') as in_f:
            with open("input/" + file_name + ".in", 'w') as out_f:
                first_line = True
                for line in in_f:
                    if first_line:
                        first_line = False
                        continue
                    values = line.split(",")
                    if len(values) < 6: continue
                    out_f.write("%s %f\n" % (values[0], float(values[5])))
