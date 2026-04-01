import os
import re

def main():
    target_dir = r"c:\Projects\Job-Genesis\frontend\lib"
    
    # We want to replace "const SizedBox(...AppSpacing...)" with "SizedBox(...)".
    # Because 'const' could be applied to a parent (e.g. const Column(children: [SizedBox(height: AppSpacing.md)])), 
    # it's tricky to catch everything with pure regex without removing valid consts.
    # However, just doing a blanket regex that looks for 'const ' and replacing it with '' 
    # anywhere on a line that contains 'AppSpacing' or 'AppTypography' is a good heuristic.
    # Then `dart fix --apply` will put `const` back where it actually belongs!
    
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith(".dart"):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # split into lines for safer replacement
                lines = content.split('\n')
                new_lines = []
                changed = False
                for line in lines:
                    if 'AppSpacing' in line or 'AppTypography' in line:
                        if 'const ' in line:
                            # Remove 'const ' but keep indentation
                            line = line.replace('const ', '')
                            changed = True
                    new_lines.append(line)
                
                # Also we need to handle multi-line cases where `const` is on a previous line.
                # A safer approach for Flutter is using regex on the whole file content.
                # Remove `const ` if it precedes common widgets that take AppSpacing/Typography.
                # But since Dart fix is so smart, we can just remove `const ` from the entire file 
                # wherever it appears, then let `dart fix` add it back.
                # Wait, `dart fix` adds `const` back to widgets that CAN be const. 
                # It does NOT add `const` back to everything. 
                # Let's just remove `const ` if `AppSpacing` or `AppTypography` is near it.
                
                # actually, replacing 'const ' with '' on lines with AppSpacing/AppTypography helps 90% of cases.
                
                if changed:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write('\n'.join(new_lines))
                    print(f"Fixed {filepath}")

if __name__ == "__main__":
    main()
