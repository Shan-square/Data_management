install.packages("tidyverse")
library(tidyverse)

#merge year1 all data
#All files share a column "Link_ID". Link_ID is the sample list.
#Each of the file is a different set of measurements for the sample list.
#Function "full_join" keeps all mismatches of samples among files.
#Function "left_join" aligns the samples from the second file to the first file by "Link_ID" and drop the rest.
#There are other join types, google dplyr
merge1 <- full_join(Y1_field,Y1_soil,by="Link_ID")
merge2 <- full_join(merge1,Y1_qpcr,by="Link_ID")
merge3 <- full_join(merge2,Y1_yield,by="Link_ID")
merge4 <- full_join(merge3,Y1_disease,by="Link_ID")
merge5 <- full_join(merge4,Y1_nutrient,by="Link_ID")
write_csv(merge5,"PotatoSCMP_WI_Y1.csv")

#merge WI year2 all data
merge6 <- full_join(Y2_field_soil,Y2_qpcr,by="Link_ID")
merge7 <- full_join(merge6,Y2_yield,by="Link_ID")
merge8 <- full_join(merge7,Y2_disease,by="Link_ID")
merge9 <- full_join(merge8,Y2_nutrient,by="Link_ID")
write_csv(merge9,"PotatoSCMP_WI_Y2.csv")

#merge WI year3 all data
merge10 <- full_join(Y3_field,Y3_qpcr,by="Link_ID")
merge11 <- full_join(merge10,Y3_yield,by="Link_ID")
merge12 <- full_join(merge11,Y3_disease,by="Link_ID")
merge13 <- full_join(merge12,Y3_nutrient,by="Link_ID")
write_csv(merge13,"PotatoSCMP_WI_Y3.csv")

#merge WI all three years data
#Stitch merge5, merge9, and merge13 together by row
merge14 <- dplyr::bind_rows(merge5,merge9,merge13)
write_csv(merge14,"PotatoSCMP_WI.csv")

#select three columns"Year","Farm","qPCR16S"
select(merge14,Year,Farm,qPCR16S)
#filter data based on a condition
filter(merge14,Year=="Y1",qPCR16S>0)

#add new column "Log16S"
merge14 %>% 
  mutate(Log16S=log10(qPCR16S))

#summarize qpcr data by year
merge14 %>% 
  group_by(Year) %>% 
  summarize(mean_qPCR=mean(qPCR16S))
