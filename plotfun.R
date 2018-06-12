############# this is the basic plot, all the other plots have this structure, with the one additional feature
basicPlot <- function(nBB, nWB, nIt, nRun) {
  # matrix that will contain the proportion of WBs per each iteration (=rows) and run (=cols)
  M <- matrix(ncol=nRun, nrow=nIt) 
  # loop through number of runs/trials
  for (r in 1:nRun) { 
    # put together the urn based on previous input of BB and WB
    urn <- c(rep("BB", nBB), rep("WB", nWB)) 
    # same as the initial BB and WB number but it will change as we draw balls from the urn
    nBlack <- nBB # this is important so that for each run, the previous run's results won't mess with the proportions 
    nWhite <- nWB 
    # iterate thgourh the runs and iterations, fill up the matrix with the proportion of white balls
    frac <- nWhite/(nBlack+nWhite) # this variable shows the proportion of white balls in the urn overall
    # contains the proportion of WBs in a vector thorughout the iterations
    frac_list <- c() 
    # loop thourgh number of internvals (so for each run R calculates the whole interval one after the other)
    for (i in 1:nIt){  
      # sample one ball randomly from the urn
      s <- sample(urn, 1) 
      # update the number of WB if sampled ball is white
      if (s == "WB"){  
        nWhite <- nWhite + 1 
      }else {
        # update the number of BB 
        nBlack <- nBlack + 1 
      }
      # put the last sampled ball into the urn (NOTE: since the sample s doesn't actually 'take out' the ball from the urn, there is no need to add an additional ball)
      urn <- append(urn, s, after = length(urn)) 
      # update frac to get the proportion of white balls in this run
      frac <- nWhite/(nWhite+nBlack) 
      # update frac_ist
      frac_list <- append(frac_list, frac)
    }
    M[,r] <- frac_list
  }
  return(M) # M is the matrix from which the data will be plotted (after some more data wrangling)
}

#############





