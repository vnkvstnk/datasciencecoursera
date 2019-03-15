# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
if (!exists("nei")) nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble() %>% mutate(type = factor(type))
if (!exists("scc")) scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble()

# Plotting
by_type <- nei %>% group_by(type, year) %>% summarize(emission = mean(Emissions, na.rm = TRUE))


ggplot(by_type, aes(year, emission)) + geom_point(size = 5) + geom_smooth(method = "lm", se = FALSE) +
    facet_wrap(. ~ type, scales = "free")

# https://stackoverflow.com/questions/18046051/setting-individual-axis-limits-with-facet-wrap-and-scales-free-in-ggplot2