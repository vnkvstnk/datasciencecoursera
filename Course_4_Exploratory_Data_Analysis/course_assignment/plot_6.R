# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
if (!exists("nei")) nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
if (!exists("scc")) scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble() %>%
        filter(grepl("vehicle", tolower(EI.Sector)))

# Subsetting
motor_em <- nei %>% filter(SCC %in% scc$SCC & fips %in% c("24510", "06037"))

ggplot(motor_em, aes(x = as.factor(year), y = Emissions, fill = fips)) + geom_boxplot(alpha = .5) + scale_y_log10()
