
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

#http://r.789695.n4.nabble.com/Count-unique-rows-columns-in-a-matrix-td844731.html
count.rows <- function(x) { 
    order.x <- do.call(order,as.data.frame(x)) 
    equal.to.previous <- 
      rowSums(x[tail(order.x,-1),] != x[head(order.x,-1),])==0 
    tf.runs <- rle(equal.to.previous) 
    counts <- c(1, 
                unlist(mapply( function(x,y) if (y) x+1 else (rep(1,x)), 
                               tf.runs$length, tf.runs$value ))) 
    counts <- counts[ c(diff(counts) <= 0, TRUE ) ] 
    unique.rows <- which( c(TRUE, !equal.to.previous ) ) 
    cbind( counts, x[order.x[ unique.rows ], ,drop=F] ) 
} 


evaluateGuess<-function(guess, answer){
  feedback<-cbind(guess, "ZILCH", "ZILCH")
  tblCt<-cbind(answer)
  i<-1
  tblCt<-count.rows(answer[,1:2])
  #[,1] = count...[,2] = color....[,3] = color number...
  i<-1
  while(i<=length(tblCt[,1])){
    ct<-0
    j<-1
    while(j<=4){
      if(tblCt[i,2] == answer[j,1]){
        cmax<-as.numeric(tblCt[i,1])
      } 
      j<-j+1
    }
    k<-1
    while(k<=4){
      if(answer[k,1] == guess[k,1]){
        feedback[k,3] <- "CORRECT"
        ct<-ct + 1
      } else if(tblCt[i,2] == guess[k,1] & ct<cmax-1) {
        feedback[k,3] <- "PRESENT"
        ct<-ct + 1
      }
      k<-k+1
    }
    i<-i+1
  }
  win_state<-count.rows(feedback[,3:4])
  if(win_state[1,1]==4 & win_state[1,2]=="CORRECT"){
    return("PLAYER WINS! (YOU SHOULD PRESS 'REFRESH GAME')")
  }else {
    return(sort(feedback[,3]))
  }

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

