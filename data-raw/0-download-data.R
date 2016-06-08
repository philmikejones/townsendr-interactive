# Car or van access
# persons per room
# tenure
# unemployment


# Percentage of households with access to a light vehicle
"http://www.nomisweb.co.uk/api/v01/dataset/NM_548_1.data.csv?geography=TYPE464&RURAL_URBAN=0&CELL=2,3,4,5&MEASURES=20301&select=GEOGRAPHY_NAME,GEOGRAPHY_CODE,CELL_NAME,OBS_VALUE"
"http://www.nomisweb.co.uk/api/v01/dataset/NM_541_1.data.csv?GEOGRAPHY=TYPE464&RURAL_URBAN=0&C_PPROOMHUK11=3,4&MEASURES=20301&select=GEOGRAPHY_NAME,GEOGRAPHY_CODE,C_PPROOMHUK11_NAME,OBS_VALUE"
"http://www.nomisweb.co.uk/api/v01/dataset/NM_537_1/GEOGRAPHY/2092957703TYPE464/RURAL_URBAN/0/C_TENHUK11/4,5,8,13/MEASURES/20301/data.csv?select=GEOGRAPHY_NAME,GEOGRAPHY_CODE,C_TENHUK11_NAME,OBS_VALUE"

"http://www.nomisweb.co.uk/api/v01/dataset/NM_556_1/GEOGRAPHY/2092957703TYPE464/RURAL_URBAN/0/CELL/1,8/MEASURES/20100/data.csv?select=GEOGRAPHY_NAME,GEOGRAPHY_CODE,CELL_NAME,OBS_VALUE"



# Z-scores ====
# Calculate z-score
td$zCar <- scale(td$car, center = TRUE, scale = TRUE)
td$zOvc <- scale(td$ovc, center = TRUE, scale = TRUE)
td$zTen <- scale(td$ten, center = TRUE, scale = TRUE)
td$zEau <- scale(td$eau, center = TRUE, scale = TRUE)
