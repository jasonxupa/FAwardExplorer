#load libraries
#install.packages("tidyverse") #for those new to R, run the following line to install tidyverse
library(tidyverse) 

#download Table203, ie: https://report.nih.gov/catalog/DisplayRePORT.aspx?rid=550

#file to load - point to table 203
excel.file.to.load = "~/Box/Tan_Lab/F30/funding_data.xlsx"

#read in table 203, disregard headers and footers 
table203 = readxl::read_excel(excel.file.to.load, range = "A3:G703") 

#tidy column names by removing spaces
colnames(table203) = c("fiscal.year", "grant.type", "institute", "reviewed", "awarded", "success.rate", "total.funding")

#make fiscal year an integer rather than numeric value
table203$fiscal.year = as.integer(table203$fiscal.year)

#recalculate success rate to be rounded to 2 decimal places
table203 = table203 %>% mutate(success.rate = round(awarded / reviewed, 2))

#extract activity total / year into new data matrix
activity.total = table203 %>% filter(institute == "ACTIVITY TOTAL")

#tidy data by filtering for F30-33, only keep NIH institute data, not other or year totals
table203$grant.type %>% unique() #view all grant types in table 203
table203$institute %>% unique() #view all institutes in table 203
grant.type.keepers = c("F30", "F31", "F32", "F33") %>% print() #keep F30-F33
contains.n <- table203$institute %>% grep(pattern = "^N", value = T) %>% unique()%>% print() #keep all insitutes that start with N (gets rid of fiscal year total)
table203 = table203 %>% filter(grant.type %in% grant.type.keepers,
                               institute %in% contains.n)

#save final objects
save(activity.total, file = "~/Box/Tan_Lab/F30/shiny_app_with_inputs/activity_total.Rdata")
save(table203, file = "~/Box/Tan_Lab/F30/shiny_app_with_inputs/table203.Rdata")