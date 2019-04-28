# Targeted-demographics to increase turnout in the 2019 EU election

We came together at a hackathon to use data to improve voter engagement for the 2019 EU election. 

This scatterplot is a first result. It shows (for most of the 650 Constituencies) the proportion of 'voter engagement' (see below) vs women in a target demographic, each point is sized by the enrolled voter population in that Constituency:

![](plot_women_vs_turnout.png)

'Voter engagement' is calculated by taking the percentage of people who voted in the 2015 General Election (a 'normal' election, unlike the 2017 rushed GE) and the enrolled population size who are eligible to vote in that Constituency. Some Constituencies have a much lower turn-out than others (range circa 52-78%, most are in the range 60-75%).

_Note_ that this is a proxy for engagement and it is likely to be noisy. It was noted by colleagues (hat tip Sym) in the DemocracyClub slack that using 1 GE will be noisy and we'd do better to calculate engagement by averaging results over several elections, this could be a _future project_.

ADD NOTES ON WHAT THIS GIVES US AND WHAT ELSE WE MIGHT DO (using Ian's local non-committed text file)

* Project source: https://github.com/dxe4/demographics
* Slack: #targeted-demographics

## Data sources and key files (in `/data`)
**TODO** Can everyone please add some notes about the files they added (including - original location, a sentence or two about the data (e.g. year, intention, any issues or thoughts you have), whether this was an input file to a process or an output file from some of our code) please.

### EU-referendum-result-data.csv

### ages.csv

### ages2.csv

### areas_lat_lon.csv

### constituency_turnout.csv
Data showing the turnout and electorate size for all 650 UK constituencies at the 2015 general election (the same info for the 2017 general election was not available so this was considered a good proxy). The data was scraped from http://www.ukpolitical.info/Turnout15.htm. Note slight changes to names of two constituencies so that they can be joined to postcode_sector_lookup.csv.

### density.csv

### ethnic_groups.csv

### health.csv

### postcode_sector_lookup.csv
Original data set was the National Statistics Postcode Lookup (NSPL) table for the United Kingdom. For further details read postcode_sector_lookup_creation.ipynb in data folder.

### r21ukrttableks102ukladv1_tcm77-330434 - r21ukrttableks102ukladv1_tcm77-330479.xls

### sex.csv
Count of M/F and population size per Ward. 521 rows.

### ward-codes-w-30-45.csv

DUPLICATE of ward_pop_f30to45.csv (and used in Notebooks) - SHOULD BE DELETED?

### ward_pop_f30to45.csv

Per Ward counts of electorate (nbr people eligible to vote) and percentage of those who voted in 2015 General Election. 8297 rows.

### ward_to_local_district.csv

### GB_wards_2017

Geospatial and tabular data, as well as a lookup table to match wards to constituencies. Downloaded from the Office for National Statistics:
* http://geoportal.statistics.gov.uk/datasets/wards-december-2017-generalised-clipped-boundaries-in-great-britain
* http://geoportal.statistics.gov.uk/datasets/ward-to-westminster-parliamentary-constituency-to-local-authority-district-december-2017-lookup-in-the-united-kingdom

### tidy_data.feather

Master data frame with combined information from disparate sources. This was generated from individual csvs and shapefiles by running `01_etl.R`

## How to run the code

**TODO** can anyone who wrote code please note the high-level process. The goal would be to let one of us (or a likeminded soul) follow the flow of code and data in e.g. 6 months time - so add enough detail to assume that we've forgotten everything and need some nudges in the right direction please.


`spatial_data.R` reads `ward_pop_f30to45.csv` and later writes `tidy_data.feather`.

## Contributors

* AlexG
* Emiliano Cancellieri
* harry
* Ian Ozsvald, @ianozsvald, https://www.linkedin.com/in/ianozsvald
* jdleesmiller
* Laurens Geffert, @JanLauGe, https://www.linkedin.com/in/laurensgeffert/
* Pranay
* Nick Rhodes, https://www.linkedin.com/in/nickorhodes

### Thanks to

* jonathanf (DemocracyClub)
* sym (DemocracyClub)

## Future

* We could try averaging voter turnout by Constituency for several elections
* We could try getting the public electoral role for the Open Register, it should be a good proxy for voter enrollment despite people opting out (hatip chris48s in DemocracyClub)
* Sym noted that http://manchester.academia.edu/RobertFord might have open ward-level data
