#!/bin/bash
#
# Date created: Mon Jan 06 2025
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
# Author: Sam Hardy (original code by Christine McKenna)
# Property: JBA Consulting
# ----------------------------------------------------------


# User changeable parameters
date_i=$1 #YYYYMM
date_N=$2 #YYYYMM
var_id=pr

error_months=$(cat $1)

# extract `proj_id` and `ens_id` from the input txt file 
input_file=$1
proj_id="${input_file#proj}"
proj_id="${proj_id%%_*}"
echo $proj_id

ens_id="${input_file#*_}"
ens_id="${ens_id%%_*}"
echo $ens_id

# Define set parameters
url0=https://dap.ceda.ac.uk/badc/ukcp18/data/land-cpm
url1=uk/2.2km/rcp85/${ens_id}/${var_id}/1hr/v20210615
url2=${var_id}_rcp85_land-cpm_uk_2.2km_${ens_id}_1hr
base_url=${url0}/${url1}/${url2}
config_path=/mnt/metdata/2024s1475/InputData/config.json
outdir=/mnt/metdata/2024s1475/UKCP18_Processing_2024/precip_profiles_test/proj${proj_id}/output_mem${ens_id}

# # Loop over monthly files, extracting and processing data
# while [ $date_i != $date_N ]; do

#   echo ""
#   echo "---------------------------------------------------------"

#   # Get date range for current month
#   echo ""
#   echo "Month: $date_i"
#   date1=${date_i}01
#   date2=${date_i}30

#   # Get input and output file details
#   url=${base_url}_${date1}-${date2}.nc

#   # Run python script to extract and process data
#   echo ""
#   echo "Extracting and processing data for: $url"
#   echo ""
#   python ./ukcp18_download_and_processing.py --ukcp_url $url --out_file_path $outdir --projection_id $proj_id --ensemble_member_id $ens_id --variable_id $var_id --config_file_path $config_path

#   # Move the current date forward by 1 month
#   date_i=$(date -d "${date_i}01 +1 month" +"%Y%m") 

# done

