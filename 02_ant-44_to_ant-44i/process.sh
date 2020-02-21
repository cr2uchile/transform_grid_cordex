var=()
mod=''
sy=
ey=
exp=evaluation
mod1=MOHC-HadRM3P
mod2=ECMWF-ERAINT
ens=r1i1p1
if [ $exp == 'evaluation' ]
then
	var+=(clt evspsbl huss hurs mrros pr prc ps psl rlus rlds rsds rsus rlut sund sic snd snc snm snw tas tasmax tasmin uas vas)
	mod+=ECMWF-ERAINT
	sy+=1979
	ey+=2012
fi
if [ $exp == 'historical' ]
then
	var+=(mrros prc ps psl rlus rlds rsds rsus rlut)
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
	lst_data=`ls -al /mnt/cirrus/simulations/RCM_simulations/cordex/ANT-44/$exp/mon/$i/$mod1/$mod2/$ens/*.nc  | awk '{print $9}'`
	echo $lst_data
	echo "------read data------"
	
	input=/mnt/cirrus/simulations/RCM_simulations/cordex/ANT-44/$exp/mon/$i/$mod1/$mod2/$ens/
	mkdir -p results/$exp/$i/$mod1/$mod2
	output=/mnt/stratus/srv/users/webdev/cr2mma_dev/process/ant-44-others/results/$exp/$i/$mod1/$mod2/

	for k in $(echo $lst_data | tr "/" "\n" )
	do 
		if [[ $k == *"_ANT"* ]] && [[ $k == *"_$ens"* ]];then
			cdo -f nc -s setgrid,grid_int.txt  $input$k $output$(echo $k | sed 's/44/44itest/g' )
			cdo -f nc -s remapbil,grid_int.txt $output$(echo $k | sed 's/44/44itest/g' ) $output$(echo $k | sed 's/44/44i/g' )
			ncatted -O -a comment,global,o,c,"CORDEX ANT-44 to ANT-44i by Climate and Resilience Research (CR2), Departamento de Geofisica, Universidad de Chile 2019. Interpolated to regular 0.5 x 0.5 degree grid for ANT-44 by cr2sysadmin@dgf.uchile.cl. Due to coarse resolution used in bilinear interpolation (0.5 x 0.5 degree), it is possible to lose data over some grids of the Antarctic Peninsula, particularly for surface runoff." $output$(echo $k | sed 's/44/44i/g' ) $output$(echo $k | sed 's/44/44i/g' )
			rm $output$(echo $k | sed 's/44/44itest/g' )
			
	  	fi
	done
done
