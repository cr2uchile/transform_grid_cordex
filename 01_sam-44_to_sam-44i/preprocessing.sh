#!/bin/bash
var=() 
while IFS= read -r line; do
	#echo $line
    arr=(${line//_/ })
    data=(${arr[@]})
    len=(${#arr[@]})
    date=(${arr[8]//-/ })
    sy=(${date[0]})
    ey=(${date[1]//-/})
    var+=(${data[0]})
    #echo $ey
    #echo $sy
    #echo $len
    #echo $date
    #echo ${var[@]} 
    
done < /mnt/cirrus/downloads/nancy/cordex_sam/SAM_44/files.txt
echo ${#var[@]}
unset dupes # ensure it's empty
declare -A dupes

for i in "${var[@]}"; do
    if [[ -z ${dupes[$i]} ]]; then
        NEWARRAY+=("$i")
    fi
    dupes["$i"]=1
done
unset dupes # optional

echo ${#NEWARRAY[@]}
for i in ${NEWARRAY[@]}
	do
	echo $i
	lst_data=`ls -al /mnt/cirrus/downloads/nancy/cordex_sam/SAM_44/*.nc  | awk '{print $9}'`
	echo $lst_data
	echo "------read data------"
	
	input=/mnt/cirrus/downloads/nancy/cordex_sam/SAM_44/
	output=/mnt/cirrus/downloads/nancy/cordex_sam/SAM_44/results/

	for k in $(echo $lst_data | tr "/" "\n" )
	do 
		if [[ $k == *"_SAM"* ]] && [[ $k == *"_$ens"* ]];then
			echo $k
			cdo -f nc -s setgrid,grid_int.txt  $input$k $output$(echo $k | sed 's/44/44itest/g' )
			cdo -f nc -s remapbil,grid_int.txt $output$(echo $k | sed 's/44/44itest/g' ) $output$(echo $k | sed 's/44/44i/g' )
			ncatted -hO -a comment,global,o,c,"CORDEX SAM-44 to SAM-44i by Climate and Resilience Research (CR2), Departamento de Geofisica, Universidad de Chile 2019. Interpolated to regular 0.5 x 0.5 degree grid for SAM-44 by cr2sysadmin@dgf.uchile.cl." $output$(echo $k | sed 's/44/44i/g' ) $output$(echo $k | sed 's/44/44i/g' )
			rm $output$(echo $k | sed 's/44/44itest/g' )
			
	  	fi
	done
done