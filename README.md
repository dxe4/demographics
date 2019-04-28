# Targeted-demographics to increase turnout in the 2019 EU election
We came together at a hackathon to use data to improve voter engagement for the 2019 EU election. We gathered data from a number of disparate sources and aggregated it to allow for better prioritisation of efforts for voter mobilisation. Data came at different spatial resolutions, from postcode sectors over wards to constituencies. The map below shows some of the variables we obtained at the constituency level:

![](out/maps.png)

The scatterplot below shows (for most of the 650 Constituencies) the proportion of 'voter engagement' vs women in a target demographic, each point is sized by the enrolled voter population in that Constituency. 'Voter engagement' is calculated by taking the percentage of people who voted in the 2015 General Election (a 'normal' election, unlike the 2017 rushed GE) and the enrolled population size who are eligible to vote in that Constituency. Some Constituencies have a much lower turn-out than others (range circa 52-78%, most are in the range 60-75%).

![](out/plot_women_vs_turnout.png)

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
Data showing the turnout and electorate size for all 650 UK constituencies at the 2015 general election (the same info for the 2017 general election was not available so this was considered a good proxy). The data was scraped from http://www.ukpolitical.info/Turnout15.htm. Note slight changes to names of two constituencies so that they can be joined to `postcode_sector_lookup.csv`.

### density.csv

### ethnic_groups.csv

### health.csv

### postcode_sector_lookup.csv
List of all postcode sectors in the UK (based on the National Statistics Postcode Lookup (NSPL) table for the UK). Further details are in `postcode_sector_lookup_creation.ipynb`.

### r21ukrttableks102ukladv1_tcm77-330434 - r21ukrttableks102ukladv1_tcm77-330479.xls

### sectors_by_constituency.csv
For each constituency a list of all postcode sectors in that constituency.

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

`01_etl.R` reads data from different sources and produces a dataset at constituency level in `feather` format (`data/constituency_data.feather`). This data is then used in `02_plots.R` to generate visualisations and `03_experiment_selection.R` to choose a number of postcodes that we conducted geo-experients for. If you are interested in postcode-level data you can also use `data/postcode_sector_data.feather`. However, be aware that some data that wasn't available at postcode sector level was assumed constant for all postcode sectors in a single constituency.

## Contributors
* AlexG
* Emiliano Cancellieri, https://www.linkedin.com/in/emilianocancellieri/
* harry
* Ian Ozsvald, @ianozsvald, https://www.linkedin.com/in/ianozsvald
* jdleesmiller
* Laurens Geffert, @JanLauGe, https://www.linkedin.com/in/laurensgeffert/
* Pranay
* Nafiz Huq / Nick

## Thanks to
* jonathanf (DemocracyClub)
* sym (DemocracyClub)

## Future
* We could try averaging voter turnout by Constituency for several elections
* We could try getting the public electoral role for the Open Register, it should be a good proxy for voter enrollment despite people opting out (hatip chris48s in DemocracyClub)
* Sym noted that http://manchester.academia.edu/RobertFord might have open ward-level data
