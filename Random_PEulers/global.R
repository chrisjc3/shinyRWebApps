
ProjEul1 <- function(x) {
  #threes = multiples of 3 under input$Ex1N
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
  #fives = multiples of 5 under input$Ex1N
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


