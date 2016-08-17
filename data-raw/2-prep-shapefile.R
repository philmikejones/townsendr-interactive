# Prepare raw downloaded shapefiles and simplify
# Shapefiles are obtained by source("data-raw/0-download-data.R")


# Mege England and Wales shapefiles ====







# Create a copy of england, call it lad
file_extensions <- list("dbf", "prj", "shp", "shx")
lapply(file_extensions, function(x) {
  file.copy(paste0("inst/extdata/england_lad_2011_gen.", x),
            paste0("inst/extdata/lad_2011_gen.", x),
            overwrite = TRUE)
})
rm(file_extensions)

# Merge Wales into lad_
system("./data-raw/combine-shapefiles.sh")
