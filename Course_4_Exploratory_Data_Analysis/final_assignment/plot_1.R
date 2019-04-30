# Importing data
nea <- readRDS("./summarySCC_PM25.rds")
scc <- readRDS("./Source_Classification_Code.rds")

# Extracting data to plot
per_year <- tapply(nea$Emissions, nea$year, sum)

# Plotting
png("plot_1.png")
plot(as.integer(names(per_year)), per_year, pch = 19, cex = 2,
     xlab = "Year", ylab = expression("Emission, t"),
     main = expression("Total annual emission of PM"[2.5]* " in the US"))
dev.off()