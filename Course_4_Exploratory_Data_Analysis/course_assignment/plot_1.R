# Importing data
if (!exists("nea")) nea <- readRDS("./summarySCC_PM25.rds")
if (!exists("scc")) scc <- readRDS("./Source_Classification_Code.rds")

# Extracting data for plotting
per_year <- tapply(nea$Emissions, nea$year, sum, na.rm = TRUE)

# Plotting
# png("plot_1.png")
plot(as.integer(names(per_year)), per_year, pch = 19, cex = 2,
     xlab = "Year", ylab = expression("Emission, t"),
     main = expression("Total annual emission of PM"[2.5]* " in the US"))
# dev.off()

# As can be seen, emission level of PM2.5 decreased from 1999 to 2008.

     