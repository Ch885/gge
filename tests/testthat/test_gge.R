# test_gge.R
# Time-stamp: <24 May 2017 12:50:36 c:/x/rpack/gge/tests/testthat/test_gge.R>

context("test_gge.R")

require(gge)

# ----------------------------------------------------------------------------

# create data for tests

# matrix data
mat1 <- matrix(c(50, 55, 65, 50, 60, 65, 75,
                 67, 71, 76, 80, 82, 89, 95,
                 90, 93, 95, 102, 97, 106, 117,
                 98, 102, 105, 130, 135, 137, 133,
                 120, 129, 134, 138, 151, 153, 155),
               ncol=5, byrow=FALSE)
colnames(mat1) <- c("E1","E2","E3","E4","E5")
rownames(mat1) <- c("G1","G2","G3","G4","G5","G6","G7")

bar <- transform(lattice::barley, env=paste0(site,year))

# ----------------------------------------------------------------------------

test_that("errors with gge.formula", {
  expect_error(gge(yield~variety*site)) # no data
  expect_error(gge(yield~variety*loc, bar)) # no 'loc'
  expect_error(gge(yield~variety*site, bar, gen.group=loc)) # no 'loc'
  expect_error(gge(yield~variety*site, bar, gen.group=year)) # multiple gen.group
  expect_error(gge(yield~variety*site, bar, env.group=loc)) # no 'loc'
  bar$junk <- c('A','B','C','D')
  expect_error(gge(yield~variety*site, bar, env.group=junk)) # multiple env.group
})

test_that("errors with gge.matrix", {
  expect_error(gge(mat1,env.group=1:3)) # wrong length
  expect_error(gge(mat1,gen.group=1:3)) # wrong length
  expect_error(gge(mat1, method="NIP")) # unknown method
})

test_that("nipals",{
  mat2 <- mat1
  mat2[,1] <- 1
  expect_error(gge(mat2, method="nipals")) # constant column
  mat3 <- mat1
  mat3[1:5,1] <- NA
  expect_warning(gge(mat3, method="nipals")) # more than 10 percent missing
})

# ----------------------------------------------------------------------------

# One missing value in a matrix
mat2 <- mat1 ; mat2[1,1] <- NA

# Check 'plot' functions for complete/missing
m11 = gge(mat1)
plot(m11)
m21 = gge(mat2)
plot(m21)

# Checking arguments of 'biplot'
biplot(m11)
biplot(m11, title="Example biplot", subtitle="GGE biplot") # message
biplot(m11, main="Example biplot", subtitle="GGE biplot")

biplot(m11, subtitle=NULL) # suppress options subtitle
biplot(m11, xlab=NULL, ylab=NULL)
biplot(m11, xlab="Axis 1", ylab="Axis 2")
biplot(m11, main=NULL, subtitle=NULL) # suppress title & subtitle
biplot(m11, cex.gen=2)
biplot(m11, cex.env=2)
biplot(m11, col.gen="blue")
biplot(m11, col.gen=c("blue","red")) # With 1 group, only use first
biplot(m11, pch.gen=20) # Ignored with 1 group
biplot(m11, comps=2:3)
biplot(m11, lab.env=FALSE)

# flips
biplot(m11, flip="") # no flipping
biplot(m11, flip=FALSE)
biplot(m11, flip=TRUE)
biplot(m11, flip=c(TRUE,FALSE))
biplot(m11, flip=c(FALSE,TRUE))
biplot(m11, flip=c(FALSE,FALSE))
biplot(m11, flip=c(TRUE,TRUE))

# zooming
biplot(m11, zoom.gen=.8)
biplot(m11, zoom.env=.8)
biplot(m11, zoom.gen=.8, zoom.env=.8)

# princomp methods
m31 <- gge(mat1, method="svd")
biplot(m31)
m32 <- gge(mat1, method="nipals")
biplot(m32)
m33 <- gge(mat1, method="rnipals", maxiter=500)
biplot(m33)

# check that maxiter is passed through from gge to rnipals
# m33 <- gge(mat1, method="rnipals", maxiter=500) # error

m34 <- gge(mat2) # should switch to 'nipals'
biplot(m34)
m35 <- gge(mat2, method="svd") # should switch to 'nipals'
biplot(m35)
m36 <- gge(mat2, method="nipals")
biplot(m36)
m37 <- gge(mat2, method="rnipals")
biplot(m37)

# verbose
m38 <- gge(mat2, method="rnipals", verbose=FALSE)
m38 <- gge(mat2, method="rnipals", verbose=1)

# matrix data with env.group, gen.group
m24 <- gge(mat2, env.group=c(1,1,1,2,2))
biplot(m24)
m25 <- gge(mat2, gen.group=c(1,1,1,1,2,2,2))
biplot(m25, col.gen=c('blue','red'), pch.gen=1:2) # group colors, symbols

# Environment groups. Use the lattice::barley data
require(lattice)
m32 <- gge(yield~variety*env, bar)
biplot(m32)
m33 <- gge(yield~variety*env, bar, env.group=year) # env.group
plot(m33)
biplot(m33)
biplot(m33, lab.env=FALSE) # label locs
biplot(m33, lab.env=TRUE) # default is to label locs
# Option to disable residual vectors
biplot(m33, res.vec=TRUE) # default is to label locs
biplot(m33, res.vec=FALSE) # default is to label locs

# Average environment coordinate
bar$aec="AEC"
m34 <- gge(yield~variety*env, bar, env.group=aec)
biplot(m34)

# Custom colors for gen/env. Example matrix data from Laffont
mat6 <- structure(c(120, 140, 131, 144, 120, 129, 131, 135, 107, 132, 123,
                    106, 157, 149, 141, 140, 159, 182, 135, 148, 153, 167,
                    148, 144, 143, 158, 125, 172, 140, 153, 150, 168, 168,
                    151, 148, 152, 171, 139, 157, 178, 157, 134, 169, 178,
                    157, 146, 149, 169, 191, 182, 132, 163, 156, 110, 147,
                    158, 151, 178, 193, 181, 138, 190, 177, 157, 159, 139,
                    154, 157, 145, 151, 185, 151, 197, 187, 195, 173, 166,
                    185, 187, 170, 159, 153, 145, 142, 171, 175, 176, 193,
                    192, 183, 178, 176, 170, 191, 138, 148, 145, 175, 163,
                    136, 178, 131, 179, 171, 161, 148, 196, 182, 159, 114,
                    134, 154, 169, 158, 144, 169, 150, 186, 185, 184, 156,
                    185, 204, 184, 146, 154, 156, 160, 160, 174, 185, 162,
                    160, 179, 210, 168, 193, 179, 167, 181, 167, 172, 187,
                    152, 160, 171, 139, 196, 176, 204, 176, 181, 188, 174,
                    155, 134, 170, 161, 158, 152, 172, 147, 190, 175, 176,
                    189, 186, 193, 204, 173, 178, 175, 165, 188, 191, 169,
                    160, 204, 221, 196, 157, 193, 203, 193, 177, 179, 204,
                    166, 167, 161, 182, 161, 191, 198, 208, 168, 182, 207,
                    148, 173, 195, 192, 206, 202, 193, 207, 167, 195, 186,
                    187, 181, 193, 192, 172, 152, 199, 221, 215, 206, 186,
                    195, 166, 216, 208, 213, 171, 213, 213, 174, 198, 185,
                    207, 219, 181, 195, 202, 169, 207, 190, 199, 168, 199,
                    212, 194, 190, 219, 202, 248, 185, 199, 205, 166, 207,
                    252, 172, 169, 210, 212, 233, 215, 229, 246, 250, 232,
                    242, 242, 192, 231, 222, 226, 189, 224, 249, 209, 205,
                    225, 267, 247, 240, 235, 256, 209, 215, 248, 220, 208,
                    214, 210, 247, 235, 242, 252, 253, 232, 251, 245, 232,
                    260, 237, 242),
                  .Dim = c(15L, 20L),
                  .Dimnames = list(c("G01", "G02", "G03", "G04", "G05",
                                     "G06", "G07", "G08", "G09", "G10",
                                     "G11", "G12", "G13", "G14", "G15"),
                                   c("E01", "E02", "E03", "E04", "E05",
                                     "E06", "E07", "E08", "E09", "E10",
                                     "E11", "E12", "E13", "E14", "E15",
                                     "E16", "E17", "E18", "E19", "E20")))

# specify 'gen.group' and 'env.group' as a vector with matrix data
m61 <- gge(mat6, scale=FALSE,
           env.group=c(rep("Blk1",3), rep("Blk2",5),rep("Blk3", 5), rep("Blk4", 7)),
           gen.group=rep(letters[1:3], each=5))
biplot(m61, flip=c(1,1))

# Crossa example
require("reshape2")
require("agridat")
# CRAN check doesn't like data() loading into global envt, so keep
# this commented out.
# data(crossa.wheat, package="agridat")
dat1 <- crossa.wheat
mat1 <- reshape2::acast(dat1, gen~loc, value.var='yield')
mat1 <- mat1[, c("SR","SG","CA","AK","TB","SE","ES","EB","EG",
                 "KN","NB","PA","BJ","IL","TC","JM","PI","AS","ID",
                 "SC","SS","SJ","MS","MG","MM")]
tit1 <- "CYMMIT wheat"
m7 <- gge(mat1, env.group=c(rep("Grp2",9), rep("Grp1", 16)), lab="Y",
          scale=FALSE)
biplot(m7, main=tit1)
plot(m7)

# Specify env.group as column in data frame
dat2 <- crossa.wheat
dat2$eg <- ifelse(dat2$loc %in% c("KN","NB","PA","BJ","IL","TC","JM","PI","AS","ID",
                                  "SC","SS","SJ","MS","MG","MM"), "Grp1", "Grp2")
m8 <- gge(yield~gen*loc, dat2, env.group=eg, scale=FALSE)
biplot(m8)

# No env.group
m9 <- gge(yield~gen*loc, dat2, scale=FALSE)
biplot(m9)

# Polygon.  Yan 2006 fig 12.  Check hull, origin arguments.
require(agridat)
dat <- yan.winterwheat
m1 <- gge(yield ~ gen*env, data=dat, scale=FALSE)
biplot(m1, main="yan.winterwheat - GGE biplot",
       flip=c(1,0), hull=TRUE)

biplot(m1, main="yan.winterwheat - GGE biplot",
       flip=c(1,0), origin=0,  hull=TRUE)


# 3d

test_that("3d",{
  biplot3d(m7)
  biplot3d(m7, cex.gen=1)
  expect_error(biplot3d(m7, comps=1:2))
})

if(FALSE) {
  # Tests for 3D
  biplot3d(m2)
  biplot3d(m2, cex.gen=1)
  biplot3d(m2, cex.env=1)
  biplot3d(m2, col.gen="red")
  biplot3d(m2, col.env=c("pink","purple"))
  biplot3d(m2, comps=c(1,2,4))
  biplot3d(m2, lab.env=FALSE)
  biplot3d(m2, res.vec=FALSE)
  biplot3d(m2, zoom.gen=2)
}


# check par() settings are restored
if(FALSE) {
  par()$pty
  # [1] "m"
  B <- matrix(c(50, 67, 90, 98, 120,
                55, 71, 93, 102, 129,
                65, 76, 95, 105, 134,
                50, 80, 102, 130, 138,
                60, 82, 97, 135, 151,
                65, 89, 106, 137, 153,
                75, 95, 117, 133, 155), ncol=5, byrow=TRUE)
  rownames(B) <- c("G1","G2","G3","G4","G5","G6","G7")
  colnames(B) <- c("E1","E2","E3","E4","E5")
      
  m1 = gge(B)
  plot(m1)
  par()$pty
  # "m"
  biplot(m1, main="Example biplot")
  par()$pty
  # "m"
}
