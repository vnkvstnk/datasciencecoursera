# Importing data
if (!exists("nea")) nea <- readRDS("./summarySCC_PM25.rds")
if (!exists("scc")) scc <- readRDS("./Source_Classification_Code.rds")


# Subsetting
em_balt <- subset(nea, fips == "24510")
per_year <- tapply(em_balt$Emissions, em_balt$year, sum, na.rm = TRUE)

# Plotting
png("plot_2.png")
plot(as.integer(names(per_year)), per_year, pch = 19, cex = 2,
     xlab = "Year", ylab = expression("Emission, t"),
     main = expression("Total annual emission of PM"[2.5]* " in the Baltimore City"))
dev.off()
