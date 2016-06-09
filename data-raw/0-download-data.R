# Base URL
url_1 <- "https://www.nomisweb.co.uk/api/v01/dataset/"
url_2 <- ".data.csv?date=latest&geography="
url_3 <- "&rural_urban=0&cell=1...5&measures=20100&signature=NPK-0c73734c0f725c979cee3a:0xaabfb6be3b4d4f4a1253f7b9aaca60e457728be7"

# Variable
car   <- "NM_621_1"
ppr   <- "NM_541_1"
ten   <- "NM_537_1"
une   <- "NM_556_1"

# Geography
msoa  <- "1245708289...1245715489"
lad   <- "TYPE464"



download.file(paste0(url_1, car, url_2, lad, url_3),
              destfile = "extdata/car-msoa.csv")
readr::read_csv("extdata/car-msoa.csv")

# Z-scores ====
# Calculate z-score
td$zCar <- scale(td$car, center = TRUE, scale = TRUE)
td$zOvc <- scale(td$ovc, center = TRUE, scale = TRUE)
td$zTen <- scale(td$ten, center = TRUE, scale = TRUE)
td$zEau <- scale(td$eau, center = TRUE, scale = TRUE)
