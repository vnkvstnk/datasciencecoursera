# Loading packages
library(dplyr)

# Importing data
nei <- readRDS("summarySCC_PM25.rds") %>% as_tibble()
scc <- readRDS("Source_Classification_Code.rds") %>% as_tibble()

# Selecting scc-codes for coal combustion-related sources of emission
coal_idx <- grep("comb .* coal", as.character(scc$EI.Sector), ignore.case = TRUE)
coal_codes <- unique(as.character(scc$SCC[coal_idx]))

# Subsetting
coal_em <- nei %>% filter(SCC %in% coal_codes) %>% group_by(year) %>%
    summarise(sums = sum(Emissions), means = mean(Emissions),
              medians = median(Emissions))


# Plotting
png("plot_4.png", width = 1400, height = 470)
par(mfrow = c(1, 3), cex.lab = 1.7, cex.axis = 1.7, oma = c(0, 0, 2.2, 0))
with(coal_em, { plot(year, sums, pch = 19, cex = 3, ylab = "Total emission, t")
              plot(year, means, pch = 19, cex = 3, ylab = "Average emission, t")
              plot(year, medians, pch = 19, cex = 3, ylab = "Median emission, t")
              })
mtext(expression("Emission of PM"[2.5]* " in the US from coal combustion-related sources"), outer = TRUE, cex = 1.5)
dev.off()