getE=function(LPYM,D,ageStart,ageEnd,yearEnd,firstS,secondS) {
  EI=split(D,D$cancer) # expected incidences per 100,000 py, broken down by second cancers (in secondS)
  EI=lapply(EI,function(x) acast(x, age~year, value.var="Eincid")) # convert 3 cols of df to matrices
#    EI=lapply(EI,function(x) x[,-1])
  if (ageStart>=1) LPYM=lapply(LPYM,function(x) x[-c(1:ageStart,(ageEnd+1):126),]) else
  LPYM=lapply(LPYM,function(x) x[-c((ageEnd+1):126),])
#   LPYM=lapply(LPYM,function(x) x[-c(1:15,86:126),-dim(x)[2]])
  LPYM[["CMML"]]=LPYM[["CMML"]][,-c(1:13)] # shave off early years when wasn't included in SEER
  LPYM[["MDS"]]=LPYM[["MDS"]][,-c(1:28)]  # starts in 2001
  LPYM[["MPN"]]=LPYM[["MPN"]][,-c(1:28)]
  LPYM[["RARS"]]=LPYM[["RARS"]][,-c(1:28)]
  LPYM[["AMLti"]]=LPYM[["AMLti"]][,-c(1:28)]
  LPYM[["unknown"]]=LPYM[["unknown"]][,-c(1:28)]
  LPYM[["LGL"]]=LPYM[["LGL"]][,-c(1:37)] #LGL starts in 2010
#    secondS=names(EI)
  strt01=c("MDS","MPN","RARS","AMLti","unknown")
  strt10=c("LGL")
  (E=matrix(0,nrow=length(firstS),ncol=length(secondS),dimnames=list(firstCanc=firstS,secondCanc=secondS)))
  for (i in firstS) {   #i loop on first cancers
    PY=LPYM[[i]]
    for (j in secondS) # j loop on second cancers
    { 
      # if (i=="CMML" & !j%in%c("CMML",strt01))  E[i,j]=sum(PY*EI[[j]][,as.character(1986:yearEnd)])
      if (i=="CMML" & !j%in%c("CMML",strt01,strt10))  E[i,j]=sum(PY*EI[[j]][,as.character(1986:yearEnd)])
      if (i=="CMML" & j=="CMML")  E[i,j]=sum(PY*EI[[j]])
      if (i=="CMML" & j%in%strt01)  E[i,j]=sum(PY[,as.character(2001:yearEnd)]*EI[[j]])
      if (i=="CMML" & j%in%strt10)  E[i,j]=sum(PY[,as.character(2010:yearEnd)]*EI[[j]])
      
      # if (i%in%strt01 & !j%in%c("CMML",strt01))  E[i,j]=sum(PY*EI[[j]][,as.character(2001:yearEnd)])
      if (i%in%strt01 & !j%in%c("CMML",strt01,strt10))  E[i,j]=sum(PY*EI[[j]][,as.character(2001:yearEnd)])
      if (i%in%strt01 & j=="CMML")  E[i,j]=sum(PY*EI[[j]][,as.character(2001:yearEnd)])
      if (i%in%strt01 & j%in%strt01 )  E[i,j]=sum(PY*EI[[j]])
      if (i%in%strt01 & j%in%strt10)  E[i,j]=sum(PY[,as.character(2010:yearEnd)]*EI[[j]])
      
      if (i%in%strt10 & !j%in%c("CMML",strt01,strt10))  E[i,j]=sum(PY*EI[[j]][,as.character(2010:yearEnd)])
      if (i%in%strt10 & j=="CMML")  E[i,j]=sum(PY*EI[[j]][,as.character(2010:yearEnd)])
      if (i%in%strt10 & j%in%strt01 )  E[i,j]=sum(PY*EI[[j]][,as.character(2010:yearEnd)])
      if (i%in%strt10 & j%in%strt10)  E[i,j]=sum(PY*EI[[j]])
      
      if (!i%in%c("CMML",strt01,strt10) & j%in%strt10 )  E[i,j]=sum(PY[,as.character(2010:yearEnd)]*EI[[j]])
      if (!i%in%c("CMML",strt01,strt10) & j%in%strt01 )  E[i,j]=sum(PY[,as.character(2001:yearEnd)]*EI[[j]])
      if (!i%in%c("CMML",strt01,strt10) & j=="CMML" )  E[i,j]=sum(PY[,as.character(1986:yearEnd)]*EI[[j]])
      if (!i%in%c("CMML",strt01,strt10) & !j%in%c("CMML",strt01,strt10) )  E[i,j]=sum(PY*EI[[j]])
    }
  }   
  E/1e5
}

