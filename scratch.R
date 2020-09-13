
dat <- get("economics", "package:ggplot2")
plot(dat)



# generating simulated data files

x <- data.frame("Value" = rnorm(200, mean = 1.35, sd = .25))
x <- cbind(x, Study = "ABCD")

y <- data.frame("Value" = rnorm(200, mean = 1.20, sd = .35))
y <- cbind(y, Study = "BCDE")

z <- data.frame("Value" = rnorm(200, mean = 1.15, sd = .30))
z <- cbind(z, Study = "CDEF")

all <- data.frame(rbind(x,y,z))
all$Study <- "All_ISCP"


dat <- rbind(x, y, z, all)
summary(dat)
write.csv(dat, "study_all.csv")
