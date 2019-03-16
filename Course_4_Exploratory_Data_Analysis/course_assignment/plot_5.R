# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
if (!exists("nei")) nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
if (!exists("scc")) scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble() %>%
        filter(grepl("vehicle", tolower(EI.Sector)))

# Subsetting
motor_em <- nei %>% filter(SCC %in% scc$SCC & fips == "24510")

# Plotting
p <- ggplot(motor_em, aes(factor(year), Emissions)) + geom_boxplot(aes(group = year)) + scale_y_log10() +
       labs(x = "Year", y = expression("Emission, log"[10]* "(t)"), 
            title = expression("Emission of PM"[2.5]* " in the Baltimore City from motor vehicle sources"))

# Saving
png("plot_5.png", width = 1000)
print(p)
dev.off()

