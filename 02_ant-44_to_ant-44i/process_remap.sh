
for i in tas tasmax tasmin pr vas uas psl
do
lst_data=`ls -al /media/seagate_exf/remap_polar_cart_ANT/TEST/mon/$i/*/ECMWF-ERAINT/r1i1p1/*mon_??????-??????.nc | awk '{print $9}'`
echo "------read data------"
for j in $lst_data
do
out_data="`echo $j | awk -F.nc '{print $1}'`"
cdo -f nc -s setgrid,grid_int.txt $j $out_data-v1.nc
cdo -f nc -s remapbil,grid_int.txt $out_data-v1.nc $out_data-remap-int.nc
done
rm /media/seagate_exf/remap_polar_cart_ANT/TEST/mon/$i/*/ECMWF-ERAINT/r1i1p1/*-v1.nc
done

