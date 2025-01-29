#!/bin/bash
#
# Date last modified: Mon 27 Jan 2025
#
# Purpose: Runs the ukcp18_download_and_processing.py script for 
#          each monthly file of hourly data in the UKCP Local 
#          CEDA archive from date_i to date_N (not inclusive). 
#          The python script extracts the UKCP data from CEDA
#          via OpenDAP, calculates several diagnostics and
#          saves the result to the MetData drive as a csv file.
#
#          This bash script is run for one variable (var_id) and 
#          ensemble member (ens_id) at a time. These are to be 
#          specified by the user before running.
#
# Usage: ./ukcp18_wrapper_script.sh proj3_test.txt 01
#         'proj3_test.txt' contains a list of year-month values (e.g. 202503,203207) to run our processing code for 
#         'proj3' = projection ID (2,3) representing the 20-year period we are analysing (e.g. 2000-2020) 
#         '01' = ensemble member ID (01,04,05,06,07,08,09,10,11,12,13,15)
#
# OLD INSTRUCTIONS BELOW --> IGNORE 
# # #
# # # Usage: ./ukcp18_wrapper_script.sh proj3_01_error_months.txt v2
# # #       'proj3_01_error_months.txt' contains a list of year-month values (e.g. 202503, 203207)
# # #       to run our UKCP18 processing code for. 
# # #       'proj3' = projection ID (2,3) representing the 20-year period we are analysing (e.g. 2000-2020) 
# # #       '01' = ensemble member ID (01,04,05,06,07,08,09,10,11,12,13,15)
# # #       'v2' = iteration number, e.g. v1, v2, v3 (number of times we have re-run this script)
# # #        
#
#
# Author: Sam Hardy (original code by Christine McKenna)
# Property: JBA Consulting
# ----------------------------------------------------------

# check if the input text file exists 
input_file=$1
if [[ ! -f $input_file ]]; then
  echo "Error: file $input_file does not exist."
  exit 1
fi 

# only continue processing if the input file contains a list of dates 
if [[ -s $input_file ]]; then
  echo "The file $input_file contains data to process..."

  # read in txt file containing a list of year-month values to process
  error_months=$(cat $input_file)

  # extract `proj_id` and `ens_id` from the input txt file 
  proj_id="${input_file#proj}"
  proj_id="${proj_id%%_*}"

  # ens_id="${input_file#*_}"
  # ens_id="${ens_id%%_*}"

  # User changeable parameters
  var_id=pr
  ens_id=$2

  # Define set parameters
  url0=https://dap.ceda.ac.uk/badc/ukcp18/data/land-cpm
  url1=uk/2.2km/rcp85/${ens_id}/${var_id}/1hr/v20210615
  url2=${var_id}_rcp85_land-cpm_uk_2.2km_${ens_id}_1hr
  base_url=${url0}/${url1}/${url2}
  config_path=/mnt/metdata/2024s1475/InputData/config.json
  # reformat the line below to add 'v2' as an input argument 
  outdir=/mnt/metdata/2024s1475/UKCP18_Processing_2024/precip_profiles/proj${proj_id}/output_mem${ens_id}/v2

  # Loop over monthly files, extracting and processing data
  for month in $error_months; do

    echo ""
    echo "---------------------------------------------------------"

    # Get date range for current month
    echo ""
    echo "Month: $month"

    date1=${month}01
    date2=${month}30

    # Get input and output file details
    url=${base_url}_${date1}-${date2}.nc

    # Run python script to extract and process data
    echo ""
    echo "Extracting and processing data for: $url"
    echo ""
    python ./ukcp18_download_and_processing.py --ukcp_url $url --out_file_path $outdir --projection_id $proj_id --ensemble_member_id $ens_id --variable_id $var_id --config_file_path $config_path

  done
fi