library(dplyr)
library(stringr)
library(DT)
library(janitor)
library(readxl)
library(lubridate)

# Get most recent file
most_recent_file <- list.files("data") %>% sort() %>% last()

# Parse date from file
db_version <- ymd(most_recent_file)

# Read table
taxtable <- read_xlsx(str_c("data/", most_recent_file)) %>% 
  remove_empty("cols") 

# Parse table
taxtable_intern <- taxtable %>% 
  mutate(subspecies = str_replace_na(subspecies, ""),
         Species = if_else(subspecies != "", 
                           str_c(Species, "subsp.", subspecies, sep = " "),
                           Species)) %>% 
  mutate(basonym = str_c(Genus, Species, sep = " ")) %>%
  mutate(`proposed new species name` = if_else(str_detect(`proposed new species name`, " "),
                                               str_replace(`proposed new species name`, " "," subsp. "),
                                               `proposed new species name`
                                               )
         ) %>% 
  mutate(new_name = str_c(`proposed new genus name`, `proposed new species name`, sep = " ")) %>% 
  mutate_at(c("Type strain", "16S rRNA accession no", "Genome Accession Number Type Strain"), str_replace_na)

obsolete_names <- taxtable_intern$`obsolete names`[!is.na(taxtable_intern$`obsolete names`)] %>% 
  str_split(";") %>% 
  unlist() %>% 
  str_squish()

# Set welcome text
welcome_text <-
  "<p><b>Taxonomy and nomenclature are important aspects of biological science. </b> They allow unambiguous communication about all living species. This is indispensable for many reasons, being medical, nutritional, environmental, or purely academic.</p>
  <p>The <b>genus <i>Lactobacillus</i></b>, described for the first time already in 1901, has been expanding very fast over the last decades. Until recently the genus comprised more than 250 species. In 2019, whole genome sequence analysis on this large number of species has shown that members of the genus are phylogenetically interwoven with other genera such as <i>Pediococcus, Fructobacillus, Paralactobacillus</i> and <i>Leuconostoc</i> and that the <b>heterogeneity of the genus was almost unseen in bacterial taxonomy.</b> </p>
  <p>In the past, several species of the genus <i>Lactobacillus</i> had already been placed in new genera, such as <i>Carnobacterium, Convivia, Oenococcus</i> or <i>Weissella</i>. However, the newly used whole genome-based comparisons suggested the need for a much more profound taxonomic reorganisation, resulting in the ion of 23 new genera and reduction the original genus of <i>Lactobacillus</i> to only 38 species around the type species, <i>Lactobacillus delbrueckii</i>. Further details can be found here (IJSEM) and here (UNIBO). </p>
  <p>As species of the genus have important economic, medical and environmental importance, <b>we have created a search tool below where you can find the new names of 250 species</b>, previously assigned to the genus <i>Lactobacillus</i> but now referred to with a new genus name. <b>It is important to stress that the species assignment did not change, so a search on the 'old' species name should lead you to the new, correct, taxonomic naming of the species or subspecies concerned. The website is also providing access to the published description of the species, genome accession numbers, where available, and accession numbers of the 16S rRNA genes.</b> </p>
<p>We hope this tool will be useful for you and anyone that for medical, legal or nutritional reason has an interest or requirement for correct taxonomic naming. </p>"

# Write easy to use tsv table
taxtable_intern %>% 
  select(basonym, new_name) %>% 
  filter(!is.na(basonym)) %>% 
  write.table(str_c("data/", str_replace(most_recent_file, ".xlsx", ".tsv")),
              sep = "\t",
              row.names = F)

            