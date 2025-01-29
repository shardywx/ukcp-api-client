#!/bin/bash 

for file in /mnt/metdata/2024s1475/UKCP18_Processing_2024/precip_profiles/proj2/output_mem*/{Dry_days_counts*.csv,Total_rainfall*.csv,Rainfall_bin_counts_1h_*.csv,Rainfall_bin_counts_3h_*.csv,Rainfall_bin_counts_6h_*.csv}; do 
    if [[ -f "$file" ]]; then 
        new_file="${file%.csv}_v1.csv"; 
        cp "$file" "$new_file"; 
        echo "Renamed $file to $new_file"; 
    fi; 
done