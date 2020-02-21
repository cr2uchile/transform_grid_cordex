var=()
mod=''
sy=
ey=
exp=historical
ens=r1i1p1
if [ $exp == 'evaluation' ]
then
	var+=(mrros pr ps sund sic snd snc snm snw)
	mod+=ECMWF-ERAINT
	sy+=1979
	ey+=2012
fi
if [ $exp == 'historical' ]
then
	var+=(pr)
	mod+=ICHEC-EC-EARTH
	sy+=1950
	ey+=2005
fi
if [ $exp == 'rcp26' ]
then
	var+=(clt evspsbl huss hurs mrros pr prc ps psl rlus rlds rsds rsus rlut sund sic snd snc snm snw tas tasmax tasmin uas vas)
	mod+=ICHEC-EC-EARTH
	sy+=2006
	ey+=2100
fi
if [ $exp == 'rcp85' ]
then
	var+=(mrros prc ps psl rlus rlds rsds rsus rlut)
	mod+=ICHEC-EC-EARTH
	sy+=2006
	ey+=2100
fi

echo ${var[@]}
echo $mod
year=()
for j in  `seq $sy $ey`
	do
	year+=$j
done

for i in ${var[@]}
do
	echo $i
	lst_data=`ls -al /home/nvaldebenito/Documentos/11_test_metadata/07_sam-44i_to_sam-44/*.nc  | awk '{print $9}'`
	echo $lst_data
	echo "------read data------"
	
	input=/home/nvaldebenito/Documentos/11_test_metadata/07_sam-44i_to_sam-44/
	output=/home/nvaldebenito/Documentos/11_test_metadata/07_sam-44i_to_sam-44/results/
	
	for k in $(echo $lst_data | tr "/" "\n" )
	do 
		if [[ $k == *"44i_"* ]] && [[ $k == *"_$ens"* ]];then
			cdo -f nc -s setgrid,grid_int.txt  $input$k $output$(echo $k | sed 's/44i/44test/g' )
			cdo -f nc -s remapbil,grid_int.txt $output$(echo $k | sed 's/44i/44test/g' ) $output$(echo $k | sed 's/44i/44/g' )
			#ncatted -O -a comment,global,o,c,"CORDEX ANT-44 to ANT-44i by Climate and Resilience Research (CR2), Departamento de Geofisica, Universidad de Chile 2019. Interpolated to regular 0.25x0.25o grid for ANT-44 by cr2sysadmin@dgf.uchile.cl." $output$(echo $k | sed 's/44/44i/g' ) $output$(echo $k | sed 's/44/44i/g' )
			rm $output$(echo $k | sed 's/44i/44test/g' )
			
	  	fi
	done
done
