# LADs ====
lad_car <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_621_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,1&measures=20100")
downloader::download(lad_car, destfile = "inst/extdata/lad_car.csv")

lad_ppr <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_541_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "c_pproomhuk11=0,3,4&measures=20100")
downloader::download(lad_ppr, destfile = "inst/extdata/lad_ppr.csv")

lad_ten <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_619_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,100&measures=20100")
downloader::download(lad_ten, destfile = "inst/extdata/lad_ten.csv")

lad_eau <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_556_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=1,8&measures=20100")
downloader::download(lad_eau, destfile = "inst/extdata/lad_eau.csv")


# Shapefiles ====
shp_lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                  "prebuilt/shape/England_lad_2011_gen.zip")
townsendr:::get_shape(shp_lad, destfile = "inst/extdata/shp_lad.zip",
          exdir = "inst/extdata/", method = "wget")
