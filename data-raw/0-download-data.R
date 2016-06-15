# LADs ====
car <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_621_1.data.csv?",
              "date=latest&geography=TYPE464&rural_urban=0&cell=1...5&",
              "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
              "0xaabfb6be3b4d4f4a1253f7b9aaca60e457728be7")
ppr <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_541_1.data.csv?",
              "date=latest&geography=TYPE464&rural_urban=0&cell=1...5&",
              "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
              "0xaabfb6be3b4d4f4a1253f7b9aaca60e457728be7")
ten <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_537_1.data.csv?",
              "date=latest&geography=TYPE464&rural_urban=0&cell=1...5&",
              "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
              "0xaabfb6be3b4d4f4a1253f7b9aaca60e457728be7")
eau <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/NM_556_1.data.csv?",
              "date=latest&geography=TYPE464&rural_urban=0&cell=1...5&",
              "measures=20100&signature=NPK-0c73734c0f725c979cee3a:",
              "0xaabfb6be3b4d4f4a1253f7b9aaca60e457728be7")

downloader::download(car, destfile = "extdata/lad_car.csv")


# Z-scores ====
# Calculate z-score
td$zCar <- scale(td$car, center = TRUE, scale = TRUE)
td$zOvc <- scale(td$ovc, center = TRUE, scale = TRUE)
td$zTen <- scale(td$ten, center = TRUE, scale = TRUE)
td$zEau <- scale(td$eau, center = TRUE, scale = TRUE)
