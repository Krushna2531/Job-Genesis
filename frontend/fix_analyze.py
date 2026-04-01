import re
import os

with open(r"c:\Projects\Job-Genesis\frontend\analyze_out.txt", 'r', encoding='utf-16') as f:
    lines = f.readlines()

for line in lines:
    line = line.strip()
    if ' - ' in line and ('.dart:' in line or '.dart ' in line):
        parts = line.split(' - ')
        path_loc = ""
        for p in reversed(parts):
            if '.dart:' in p:
                path_loc = p
                break
        
        if not path_loc:
            continue
            
        match = re.search(r'(.*?\.dart):(\d+):(\d+)', path_loc)
        if match:
            filepath, line_num, col_num = match.groups()
            filepath = os.path.join(r"c:\Projects\Job-Genesis\frontend", filepath.strip())
            line_idx = int(line_num) - 1
            
            if os.path.exists(filepath):
                with open(filepath, 'r', encoding='utf-8') as f_in:
                    file_lines = f_in.readlines()
                
                if line_idx < len(file_lines):
                    target_line = file_lines[line_idx]
                    if 'const ' in target_line:
                        file_lines[line_idx] = target_line.replace('const ', '', 1)
                        with open(filepath, 'w', encoding='utf-8') as f_out:
                            f_out.writelines(file_lines)
                        print(f"Fixed const in {filepath}:{line_num}")
                    else:
                        for i in range(line_idx, max(-1, line_idx - 15), -1):
                            if 'const ' in file_lines[i] and 'AppSpacing' not in file_lines[i] and 'AppTypography' not in file_lines[i]:
                                file_lines[i] = file_lines[i].replace('const ', '', 1)
                                with open(filepath, 'w', encoding='utf-8') as f_out:
                                    f_out.writelines(file_lines)
                                print(f"Fixed const in {filepath}:{i+1} (searched up)")
                                break
                            elif 'const ' in file_lines[i]:
                                file_lines[i] = file_lines[i].replace('const ', '', 1)
                                with open(filepath, 'w', encoding='utf-8') as f_out:
                                    f_out.writelines(file_lines)
                                print(f"Fixed const in {filepath}:{i+1} (searched up)")
                                break
