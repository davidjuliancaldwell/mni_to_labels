#
# based on https://github.com/yunshiuan/label4MRI
#
# David.J.Caldwell 3.15.2019
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  for (filename in args) {
    # convert xlsx first to csv, then the following
    # R skips blank lines
    m <- read.csv(file = filename, header = FALSE,fileEncoding="UTF-8-BOM")

    # file must be named "sid_*MNIcoords.csv" , where * can be something else
    
    # get rid of commas if present
     clean <- function(ttt){
       as.numeric( gsub('[,]', '', ttt))}
 
      m[] <- sapply(m, clean)
    
    fileName = unlist(strsplit(filename,"/"))
    sid = unlist(strsplit(fileName[3],"_"))[1]
    colnames(m) <- c('x','y','z')
    tic(paste0("Subject ",sid), quiet = FALSE, func.tic = my.msg.tic)
    Result <- t(mapply(FUN = mni_to_region_name, x = m$x, y = m$y, z = m$z))
    write.csv(Result,paste0("./outputData/",paste0(sid,"_MNIcoords_labelled.csv")))
    toc(quiet = FALSE, func.toc = my.msg.toc)
  }
}

my.msg.tic <- function(tic, msg)
{
  if (is.null(msg) || is.na(msg) || length(msg) == 0)
  {
    outmsg <- paste(round(toc - tic, 3), " seconds elapsed", sep="")
  }
  else
  {
    outmsg <- paste("Starting ", msg, "...", sep="")
  }
}

my.msg.toc <- function(tic, toc, msg)
{
  if (is.null(msg) || is.na(msg) || length(msg) == 0)
  {
    outmsg <- paste(round(toc - tic, 3), " seconds elapsed", sep="")
  }
  else
  {
    outmsg <- paste(msg, ": ",
                    round(toc - tic, 3), " seconds elapsed", sep="")
  }
}

# load library
library(label4MRI)
library(tictoc)
# call main which will operate on each file provided from the command line
main()

