# function needed in mybootFUN to clean names of level of time variable after re-shaping into long format

myClean.timevar <- function(fac, i) sapply( strsplit(as.character(fac), "\\."), "[", i)
