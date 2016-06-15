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

lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/prebuilt/",
              "shape/England_lad_2011_gen.zip")
download.file(lad, destfile = "extdata/lad.zip", method = "wget")
