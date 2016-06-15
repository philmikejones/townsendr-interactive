# LADs ====
car <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_621_1.data.csv?",
              "date=latest&geography=1946157057...1946157404&rural_urban=0&",
              "cell=0,1&measures=20100")
ppr <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_541_1.data.csv?",
              "date=latest&geography=1946157057...1946157404&rural_urban=0&",
              "c_pproomhuk11=0,3,4&measures=20100")
ten <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_619_1.data.csv?",
              "date=latest&geography=1946157057...1946157404&rural_urban=0&",
              "cell=0,100&measures=20100")
eau <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_556_1.data.csv?",
              "date=latest&geography=1946157057...1946157404&rural_urban=0&",
              "cell=1,8&measures=20100")

downloader::download(car, destfile = "extdata/lad_car.csv")
downloader::download(ppr, destfile = "extdata/lad_ppr.csv")
downloader::download(ten, destfile = "extdata/lad_ten.csv")
downloader::download(eau, destfile = "extdata/lad_eau.csv")

car <- readr::read_csv("extdata/lad_car.csv")
ppr <- readr::read_csv("extdata/lad_ppr.csv")
ten <- readr::read_csv("extdata/lad_ten.csv")
eau <- readr::read_csv("extdata/lad_eau.csv")




# Z-scores ====
# Calculate z-score
td$zCar <- scale(td$car, center = TRUE, scale = TRUE)
td$zOvc <- scale(td$ovc, center = TRUE, scale = TRUE)
td$zTen <- scale(td$ten, center = TRUE, scale = TRUE)
td$zEau <- scale(td$eau, center = TRUE, scale = TRUE)
