# Loading packages
library(ggplot2)
library(dplyr)

# Importing data
nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble() %>% filter(grepl("vehicle", tolower(EI.Sector)))

# Subsetting
motor_em <- nei %>% filter(SCC %in% scc$SCC & fips %in% c("24510", "06037"))

# Plotting
p <- ggplot(motor_em, aes(x = as.factor(year), y = Emissions, fill = fips)) + geom_boxplot(alpha = .5) + scale_y_log10() + 
         labs(x = "Year", y = expression("Emission, log"[10]* "(t)"),
              title = expression("Emission of PM"[2.5]* " from motor vehicle sources")) + 
         scale_fill_manual(name = "County", labels = c("Los Angeles ", "Baltimore City"), values=c("brown1","blue"))

# Saving
png("plot_6.png", heigh = 400, width = 800)
print(p)
dev.off()