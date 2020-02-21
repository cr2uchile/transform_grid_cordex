from math import pi, cos, sin, atan2, asin

"""
Transformation script: Regular lon/lat <-> Rotated pole lon/lat

This function transforms a coordinate tuple(lon,lat) in regular lon/lat
degrees to a coordinate in rotated lon/lat degrees, and vice versa.

Adapted from: http://ch.mathworks.com/matlabcentral/fileexchange/43435-rotated-grid-transform

INSER SA, David Reksten, dr@inser.ch
2017-05-03
"""

def rotated_grid_transform(lon_in, lat_in, direction, south_pole):
    """
    position:   tuple(lon, lat) = input coordinate
    direction:  1 = Regular -> Rotated, 2 = Rotated -> Regular
    south_pole: tuple(lon, lat) = position of rotated south pole
    returns:    tuple(lon, lat) = output coordinate
    """
    lon =[]
    lat =[]
    # Convert degrees to radians
    for i in range(0,len(lon_in)):
        lon.append((lon_in[i] * pi) / 180.0)
        
    for j in range(0,len(lat_in)):           
        lat.append((lat_in[j] * pi) / 180.0)
        
        
    SP_lon = south_pole[0]
    SP_lat = south_pole[1]

    theta = 90 + SP_lat # Rotation around y-axis
    phi = SP_lon        # Rotation around z-axis

    # Convert degrees to radians
    phi = (phi * pi) / 180.0
    theta = (theta * pi) / 180.0
    
    x=[]
    y=[]
    z=[]
    
    # Convert from spherical to cartesian coordinates
    for i in range(0,len(lon)):
        for j in range(0,len(lat)):
            x.append(cos(lon[i])*cos(lat[j]))
            y.append((lon[i])*cos(lat[j]))
            z.append(sin(lat[j]))
    
    print(len(x))
    print(len(y))
    
    x_new=[]
    y_new=[]
    z_new=[]
    
    if direction == 1: # Regular -> Rotated
        for i in range(0,len(x)):
            x_new.append(cos(theta) * cos(phi) * x[i] + cos(theta) * sin(phi) * y[i] + sin(theta) * z[i])
            y_new.append(-sin(phi) * x[i] + cos(phi) * y[i])
            z_new.append(-sin(theta) * cos(phi) * x[i] - sin(theta) * sin(phi) * y[i] + cos(theta) * z[i])
        
    elif direction == 2: # Rotated -> Regular
        
        phi = -phi
        theta = -theta
        for i in range(0,len(x)):
            x_new.append(cos(theta) * cos(phi) * x[i] + sin(phi) * y[i] + sin(theta) * cos(phi) * z[i])
            y_new.append(-cos(theta) * sin(phi) * x[i] + cos(phi) * y[i] - sin(theta) * sin(phi) * z[i])
            z_new.append(-sin(theta) * x[i] + cos(theta) * z[i])
        
    else:
        raise Exception('Invalid direction, value must be either 1 or 2.')
    
    print(x_new)
    longitude_processed=[]
    latitude_processed=[]
    # Convert cartesian back to spherical coordinates
    for i in range(0,len(x_new)):
   
        longitude_processed.append((atan2(y_new[i], x_new[i]))*180.0/pi)
        latitude_processed.append((asin(z_new[i]))*180.0/pi)

        # Convert radians back to degrees
        #lon_new = (lon_new * 180.0) / pi
        #lat_new = (lat_new * 180.0) / pi

    return (longitude_processed, latitude_processed)

def rotated_grid_transform_2(lon_in, lat_in, direction, south_pole):
    """
    position:   tuple(lon, lat) = input coordinate
    direction:  1 = Regular -> Rotated, 2 = Rotated -> Regular
    south_pole: tuple(lon, lat) = position of rotated south pole
    returns:    tuple(lon, lat) = output coordinate
    """
    lon =[]
    lat =[]
    # Convert degrees to radians
    for i in range(0,len(lon_in)):
        lon.append((lon_in[i] * pi) / 180.0)    
        lat.append((lat_in[i] * pi) / 180.0)
        
        
    SP_lon = south_pole[0]
    SP_lat = south_pole[1]

    theta = 90 + SP_lat # Rotation around y-axis
    phi = SP_lon        # Rotation around z-axis

    # Convert degrees to radians
    phi = (phi * pi) / 180.0
    theta = (theta * pi) / 180.0
    
    x=[]
    y=[]
    z=[]
    
    # Convert from spherical to cartesian coordinates
    for i in range(0,len(lon)):
        x.append(cos(lon[i])*cos(lat[i]))
        y.append((lon[i])*cos(lat[i]))
        z.append(sin(lat[i]))
    
    print(len(x))
    print(len(y))
    
    x_new=[]
    y_new=[]
    z_new=[]
    
    if direction == 1: # Regular -> Rotated
        for i in range(0,len(x)):
            x_new.append(cos(theta) * cos(phi) * x[i] + cos(theta) * sin(phi) * y[i] + sin(theta) * z[i])
            y_new.append(-sin(phi) * x[i] + cos(phi) * y[i])
            z_new.append(-sin(theta) * cos(phi) * x[i] - sin(theta) * sin(phi) * y[i] + cos(theta) * z[i])
        
    elif direction == 2: # Rotated -> Regular
        
        phi = -phi
        theta = -theta
        for i in range(0,len(x)):
            x_new.append(cos(theta) * cos(phi) * x[i] + sin(phi) * y[i] + sin(theta) * cos(phi) * z[i])
            y_new.append(-cos(theta) * sin(phi) * x[i] + cos(phi) * y[i] - sin(theta) * sin(phi) * z[i])
            z_new.append(-sin(theta) * x[i] + cos(theta) * z[i])
        
    else:
        raise Exception('Invalid direction, value must be either 1 or 2.')
    
    print(x_new)
    longitude_processed=[]
    latitude_processed=[]
    # Convert cartesian back to spherical coordinates
    for i in range(0,len(x_new)):
   
        longitude_processed.append((atan2(y_new[i], x_new[i]))*180.0/pi)
        latitude_processed.append((asin(z_new[i]))*180.0/pi)

        # Convert radians back to degrees
        #lon_new = (lon_new * 180.0) / pi
        #lat_new = (lat_new * 180.0) / pi

    return (longitude_processed, latitude_processed)
#NP_lon =-56.06 #cordex sam 44i
#NP_lat = 70.60 #cordex sam 44i
#SP_lon = NP_lon - 180
#SP_lat = -NP_lat
#SP_coor = [SP_lon, SP_lat]
SP_coor = [123.94,-70.6]

longitude =[-106.25, -105.75]
latitude =[-58.25, -57.75]

#SP_coor = [18.0, -39.3]
#longitude =[12,12,12]
#latitude = [55,54,53]


grid_out = rotated_grid_transform(longitude, latitude, 1, SP_coor) #rotated
grid_out_2= rotated_grid_transform_2(grid_out[0],grid_out[1],2,SP_coor) #regular
grid_out_3= rotated_grid_transform_2(grid_out_2[0], grid_out_2[1],1,SP_coor) #rotated
grid_out_4= rotated_grid_transform_2(grid_out_3[0], grid_out_3[1],2,SP_coor) #regular
grid_out_5= rotated_grid_transform_2(grid_out_4[0], grid_out_4[1],1,SP_coor) #rotated
grid_out_6= rotated_grid_transform_2(grid_out_5[0], grid_out_5[1],2,SP_coor) #regular


f= open("results.txt","w+")
f.write(str('(')+str(longitude)+str(',')+str(latitude)+str(')')+str('\n'))
f.write(str(grid_out)+str('\n'))
f.write(str(grid_out_2)+str('\n'))
f.write(str(grid_out_3)+str('\n'))
f.write(str(grid_out_4)+str('\n'))
f.write(str(grid_out_5)+str('\n'))
f.write(str(grid_out_6)+str('\n'))
f.close()
