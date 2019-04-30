# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble()

# Subsetting
em_balt <- nei %>% filter(fips == "24510") %>% group_by(year, type) %>% summarize(Emissions = sum(Emissions))

# Plotting
p <- ggplot(em_balt, aes(as.factor(year), Emissions)) + 
    geom_point(size = 4) +
    facet_wrap(.~type, scales = "free_y") +
    labs(x = "Year", y = "Emission, t", title = expression("Total annual emission of PM"[2.5]* " in the US by source"))

# Saving
png("plot_3.png", width = 700, height = 500)
print(p)
dev.off()
