# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
if (!exists("nei")) nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
if (!exists("scc")) scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble() %>%
        filter(grepl("vehicle", tolower(EI.Sector)))

# Subsetting
motor_em <- nei %>% filter(SCC %in% scc$SCC & fips == "24510")

ggplot(motor_em, aes(as.factor(year), log10(Emissions))) + geom_boxplot(aes(group = year))

t <- tapply(motor_em$Emissions, motor_em$year, median)
