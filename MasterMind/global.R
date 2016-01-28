
#GAME AND GENERAL FUNCTION
GenRand<-function(x){
  return(sample(1:x, 1))
}

GenAnswer<-function(){
  i <- 1
  ans <- cbind("NA", "NA")
  colnames(ans) <- c("COLOR", "COLOR NUMBER")
  while(i<=4){
    gcol <- GenRand(4)
    hld <- cbind(colarr[gcol], gcol)
    ans <- rbind(ans, hld)
    i <- i+1
  }
  return(ans[2:5,])
}

FindColNo<-function(col){
  i <- 1
  while(i<=7){
    if(colarr[i] == col){
      return(i)
    }
    i <- i+1
  }
}

MakeGuess<-function(col1,col2,col3,col4){
  i <- 1
  ges <- cbind("NA", "NA")
  colnames(ges) <- c("COLOR", "COLOR NUMBER")

    hld <- cbind(col1, FindColNo(col1))
    ges <- rbind(ges, hld)
    hld <- cbind(col2, FindColNo(col2))
    ges <- rbind(ges, hld)
    hld <- cbind(col3, FindColNo(col3))
    ges <- rbind(ges, hld)
    hld <- cbind(col4, FindColNo(col4))
    ges <- rbind(ges, hld)
  
  return(ges[2:5,])
}



evaluateGuess<-function(guess, answer){
  feedback<-cbind(guess, "NA")
  i<-1
  while(i<=4){
    if(guess[i,1] == answer[i,1]){
      feedback[i,3] <- "CORRECT"
    } else {
      j<-1
      while(j<=4){
        if(guess[i,1] == answer[j,1]){
          feedback[i,3] <- "PRESENT"
        } 
        j<-j+1
      }
      
    }
    i<-i+1
  }
  return(feedback)
}

turnCtr<-function(x){
  if(is.na(x)){
    return(0)
  } else {
    return(x+1)
  }
}


#GAME VARIABLES
TurnMax<-6
colarr<-c("black", "red", "green", "blue", "purple", "grey", "orange")

