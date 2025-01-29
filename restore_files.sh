#!/bin/bash 

for file in /mnt/metdata/2024s1475/UKCP18_Processing_2024/precip_profiles/proj2/output_mem*/*_v1.csv; do 
    if [[ -f "$file" ]]; then 
        original_file="${file%_v1.csv}.csv"; 
        cp "$file" "$original_file"; 
        echo "Restored original file as $original_file from $file"; 
    else 
        echo "No matching files found for $file"; 
    fi; 
done