[![Coverage Status](https://coveralls.io/repos/github/philmikejones/townsendr/badge.svg?branch=master)](https://coveralls.io/github/philmikejones/townsendr?branch=master)

License
=======

Calculate Townsend Material Deprivation Score from 2011 Census Data in the UK Copyright (C) 2014 Phil Mike Jones - orcid.org/0000-0001-5173-3245

This programme is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This programme is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this programme. If not, see <http://www.gnu.org/licenses/>.


Introduction
============

The Townsend Material Deprivation score was originally devised by Townsend et al
(1988). It is based on the following four Census variables:

1. Percent of households without access to a car.
2. Percent of households with more than one person per room.
3. Percent of households not owner-occupied.
4. Percent of individuals who are economically active unemployed.

The four domains above are then combined to produce the overall Townsend Score.
This score can be calculated for any geographical area that is available in the
Census tables, for example LSOA, MSOA, Ward, LAD, etc.

Because of the way the score is combined, only the relative rank of the scores
is meaningful. In practice, this means it is possible to say an area is more or
less deprived than another, but not what ‘amount’ of deprivation it experiences.
For this reason it is common to create a score based on a national dataset. This
script uses data from England and Wales (Scotland and Northern Ireland tables
were not available at the time of publication (February 2014)). Thus, the scores
reflect the relative deprivation of an area based on similar areas in England
and Wales.

Purpose
===============

This R script:

1. Loads in Census tables and converts them in to usable form (LAD by default)
2. Converts the four domains in to z-scores so they can be combined.
3. Combines the *z*-scores to form one overall index.
4. Rank the scores and produce deciles (quintiles by default).
5. Obtains shapefiles for plotting *z*-scores (LADs by default)

Using the Script
================

[Download the repository as a zip](https://github.com/philmikejones/townsend-depr-score-2011/archive/master.zip) or, if you know what you're doing, make a fork.

Load the project in RStudio using `townsend-depr-score-2011.Rproj` which is in the root. If you don't use RStudio set your working directory to the root of the folder with `setwd()`.

If you want scores for LADs just run the script `scripts/townsend.R`

If you want a geography other than LAD (for example LSOA, MSOA, region) you need
to modify the Nomis web API calls on lines:

1. 39 (car)
2. 47 (overcrowding)
3. 55 (tenure)
4. 64 (economically active unemployed)

Documentation for the API is available from: `https://www.nomisweb.co.uk/api/v01/help`

You also need to obtain the link to the relevant shapefiles from `http://census.edina.ac.uk/easy_download.html`. In general, right-click on the geography you require and copy the link to paste in to the script.

Once complete the script should produce one file - `data/townsendScore.csv` - which contains geography code, overall Townsend Score (*z*-score), and quintile of deprivation for each geography in England and Wales which can be used in further analyses. It will also save a map to `maps/ewTownDep.pdf` for quick inspection.

License
===============

The code is GPL v3 license. See LICENSE.txt.

Contact
===============
phil dot jones at sheffield dot ac dot uk (no spaces)

Thanks and acknowledgements
===========================

Thanks to Robin Lovelace - https://github.com/Robinlovelace - for having
a once-over of the script and his suggestions.

References
===============

Office for National Statistics, 2011 Census: Aggregate data (England and Wales) [computer file]. Downloaded from: http://www.nomisweb.co.uk/census/2011 [Accessed February 2014]. This information is licensed under the terms of the Open Government Licence [http://www.nationalarchives.gov.uk/doc/open-government-licence/version/2].

Office for National Statistics, 2011 Census: Digitised Boundary Data (England and Wales) [computer file]. UK Data Service Census Support. Downloaded from: http://edina.ac.uk/census

Townsend, Peter, Phillimore, Peter and Beattie, Alastair (1988) 'Health and Deprivation: Inequality and the North'. London: Croom Helm
