# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
if (!exists("nei")) nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble() %>% filter(Emissions != max(Emissions))
if (!exists("scc")) scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble()

# Selecting scc-codes for coal combustion-related sources of emission
coal_idx <- grep("comb .* coal", as.character(scc$EI.Sector), ignore.case = TRUE)
coal_codes <- unique(as.character(scc$SCC[coal_idx]))

# Subsetting
coal_em <- nei %>% filter(SCC %in% coal_codes)# %>% mutate(Emissions = log10(Emissions))
by_year <- tapply(coal_em$Emissions, coal_em$year, mean, na.rm = TRUE)


# Plotting
# ggplot(coal_em, aes(year, Emissions)) + geom_point(alpha = .33)
# 
# ggplot(coal_em, aes(year, Emissions)) + geom_boxplot(aes(group = year))
    

plot(as.integer(names(by_year)), by_year)
boxplot(coal_em$Emissions ~ coal_em$year)
