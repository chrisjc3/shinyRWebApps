#################PROBLEM 1####################
ProjEul1 <- function(x) {
  threes<-cbind(1,3)
  colnames(threes)<-c("it", "no")
  j<-3
  i<-2
  while(i*j<x){
    hld<-c(i,(i*j))
    threes<-rbind(threes,hld)
    i<-i+1
  }
  threes[2:length(threes[,1]), ]
  fives<-cbind(1,5)
  colnames(fives)<-c("it", "no")
  j<-5
  i<-2
  while(i*j<x){
    hld<-c(i,(i*j))
    fives<-rbind(fives,hld)
    i<-i+1
  }
  fives[2:length(fives[,1]), ]
  
  hld<-rbind(threes,fives)
  hld<-unique(hld[,2])
  return(sum(hld))
}
#################PROBLEM 2####################
ProjEul2<- function(x) {
  f<-cbind(1,1)
  s<-cbind(2,2)
  fibon<-rbind(f,s)
  colnames(fibon)<-c("it", "no")
  i<-2
  fib<-3
  while(fib<x){
    hld<- c(i, fib)
    fibon<-rbind(fibon,hld)
    i<-i+1
    fib<-as.numeric(as.character(fibon[i-1,2])) + as.numeric(as.character(fibon[i,2]))
  }
  i<-1
  fiblen<-length(fibon[,2])
  fibeven<-cbind("NA","NA")
  colnames(fibeven)<-c("it", "no")
  while(i<=fiblen){
    if(fibon[i,2]%%2==0){
      hld<-c(1,fibon[i,2])
      fibeven<-rbind(fibeven,hld)
    } 
    i<-i+1
  }
  return(sum(as.numeric(fibeven[2:length(fibeven[,2]),2])))
}
#################PROBLEM 3####################
#http://stackoverflow.com/questions/3476782/how-to-check-if-the-number-is-integer
check.integer <- function(N){
  !grepl("[^[:digit:]]", format(N,  digits = 20, scientific = FALSE))
}
ProjEul3 <- function(x) {
  primes <- cbind("NA","NA")
  colnames(primes) <- c("it", "no")
  i<-1
  potprime <- 2
  while (potprime <= x) {
    primetest <- x / potprime
    if (check.integer(primetest)) {
      x <- primetest
      hld <- c(i, potprime)
      primes <- rbind(primes,hld)
      i <- i + 1
    } else {
      potprime<-potprime+1
    }
  }
  return(primes[length(primes[,2]),2])
}


