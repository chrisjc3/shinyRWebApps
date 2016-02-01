
GenRand<-function(x){
  return(sample(1:x, 1))
}

CCipher<-function(x, ent, c_key, n_key){
  #SETUP CIPHER 
  keyTable<-NULL
  out<-NULL
  alphabet <- letters[1:26]
  alphabet <- c(alphabet, alphabet)
  numbers <- seq(1:9)
  numbers <- c(numbers, numbers)
  change_c <- FALSE
  change_n <- FALSE
  for(col in x ){
    colnm <- names(ent[col])
    out<-c("NA")
    names(out) <- colnm
    for(i in seq(along=ent[,1])) {
      curVal<- ent[i,c(colnm)]
      entarr <- unlist(strsplit(tolower(as.character(curVal)), ""))
      outline <- entarr
      for(w in seq(along=entarr)){
        if (is.character(entarr[w]) == TRUE) {
          for(k in seq(along=alphabet)) {
            if (k > 26 & as.character(entarr[w]) == as.character(alphabet[k])) {
              arrpos <- k
              change_c <- TRUE
            }
          }
        } 
        
        if (suppressWarnings(is.na(as.numeric(entarr[w]))) == FALSE) {
          for(j in seq(along=numbers)) {
            if (j > 9 & as.numeric(entarr[w]) == as.numeric(numbers[j])) {
              arrpos <- j
              change_n <- TRUE
            }
          }
        }
        if (change_n == TRUE){ 
          outline[w] <- numbers[arrpos-n_key]
        } else if (change_c == TRUE){ 
          outline[w] <- alphabet[arrpos-c_key]
        } else {
          outline[w] <- entarr[w]
        }
        change_c <- FALSE
        change_n <- FALSE
      }
      out <- rbind(out, toupper(paste(outline, collapse="")))
    }
    ent[,col] <- out[-1]
  }
  ent
}

addSerial.atCol<-function(xcol, fl){
  fl<-as.data.frame(fl)
  fl<-fl[order(fl[,xcol]),]
  fHld<-fl[,xcol]
  fHldLen<-length(fHld)
  i<-1
  j<-0
  hld<-cbind("NA","NA")
  tgt<-"NA"
  while(i<=fHldLen){
    if(tgt!=fHld[i]){
      tgt<-fHld[i]
      j<-j+1
    } 
    hrow<-cbind(j, tgt)
    hld<-rbind(hld, hrow)
    i<-i+1
  }
  LeftSerial<-hld[2:length(hld[,1])]
  out<-cbind(fl[,1:xcol], LeftSerial, fl[,(xcol+1):length(colnames(fl))])
  return(out)
}







