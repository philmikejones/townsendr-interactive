# Download census files for Townsend score and shapefiles for plotting
# Download files kept separate so when sourcing prep-<geo>.R files
# don't need to be downloaded again, saving bandwidth


# LADs ====

lad_car <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_621_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,1&measures=20100")
download.file(lad_car, destfile = "inst/extdata/lad_car.csv")

lad_ppr <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_541_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "c_pproomhuk11=0,3,4&measures=20100")
download.file(lad_ppr, destfile = "inst/extdata/lad_ppr.csv")

lad_ten <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_619_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=0,100&measures=20100")
download.file(lad_ten, destfile = "inst/extdata/lad_ten.csv")

lad_eau <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
                  "NM_556_1.data.csv?date=latest&",
                  "geography=1946157057...1946157404&rural_urban=0&",
                  "cell=1,8&measures=20100")
download.file(lad_eau, destfile = "inst/extdata/lad_eau.csv")

rm(lad_car, lad_eau, lad_ppr, lad_ten)


# method = "wget" necessary because edina.ac.uk doesn't return HEAD
# See https://github.com/wch/downloader/issues/8

if (!file.exists("inst/extdata/eng_lad.zip")) {

  eng_lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                    "prebuilt/shape/England_lad_2011_gen.zip")
  download.file(eng_lad, "inst/extdata/eng_lad.zip", method = "wget")

}

unzip("inst/extdata/eng_lad.zip", exdir = "inst/extdata",
      overwrite = TRUE)


if (!file.exists("inst/extdata/wal_lad.zip")) {

  wal_lad <- paste0("https://census.edina.ac.uk/ukborders/easy_download/",
                    "prebuilt/shape/Wales_lad_2011_gen.zip")
  download.file(wal_lad, "inst/extdata/wal_lad.zip", method = "wget")

}

unzip("inst/extdata/wal_lad.zip", exdir = "inst/extdata",
      overwrite = TRUE)
