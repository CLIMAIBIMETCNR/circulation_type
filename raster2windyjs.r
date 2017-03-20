
raster2windyjs_ls=function(x,
                     date=Sys.Date(),
                     hour=0,
                     param="t"
                     ) 
            {
             disciplineName="Meteorological products"
             par=list()
             par$t=list(parameterCategory = 0,
             parameterNumber = 0,
             parameterUnits = "K",
             parameterName = "Temperature")
  
  par$uwnd=list(parameterCategory = 2,
                parameterNumber = 2,
                parameterUnits = "m s-1",
                parameterName = "u-component of wind")
  
  par$vwnd=list(parameterCategory = 2,
                parameterNumber = 3,
                parameterUnits = "m s-1",
                parameterName = "v-component of wind")
  
header=list()
header$disciplineName=disciplineName
header$parameterCategory=par[param][[1]][[1]]
header$parameterCategoryName=par[param][[1]][[4]]
header$parameterNumberName=par[param][[1]][[4]]
header$parameterNumber=par[param][[1]][[2]]
header$parameterUnits=par[param][[1]][[3]]
header$refTime=paste0(as.Date(date),"T",sprintf("%02d",hour),"00:00.000Z")
header$numberPoints=ncell(x)
header$nx=ncol(x)
header$ny=nrow(x)
header$lo1=as.numeric(xyFromCell(x,1)[1])
header$la1=as.numeric(xyFromCell(x,1)[2])
header$lo2=as.numeric(xyFromCell(x,ncell(x))[1])
header$la2=as.numeric(xyFromCell(x,ncell(x))[1])
header$dx=as.numeric(res(x)[1])
header$dy=as.numeric(res(x)[2])

data=as.list(getValues(x))

res=list()

res$header=header
res$data=data
return(res)
}


ls_json_file=function(x,name) {
  require(jsonlite)
  if (!is.list(x)) {stop("x argument must be a list!")}
  cat(toJSON(x),file =name)
}


create_windyjson=function(u,v,t=NULL,filename) {
  if (is.null(t)) { t=sqrt(u**2+v**2)}
  a=raster2windyjs_ls(t,param="t")
  b=raster2windyjs_ls(u,param="uwnd")
  c=raster2windyjs_ls(v,param="vwnd")
  res=list()
  res[[1]]=a
  res[[2]]=b
  res[[3]]=c
  ls_json_file(res,filename)
  return(res)
}

read.text.ascii = function(pathname)
{
  return (paste(readLines(pathname), collapse="\n"))
}

#################################################################################################


write_windy_html=function(filedatajson,suffix="",age=100,width=0.8,mink=-20,maxk=32) {
  keyword=c("%NAME%","%CAPTION%","%AGE%","%WIDTH%","%MINK%","%MAXK%")
  filejs=readRDS("out_js.rds")
  filehtml=readRDS("out_html.rds")
  filehtmlname=gsub(suffix,"",gsub(".json",".html",filedatajson))
  filejsname=gsub(suffix,"",gsub(".json",".js",filedatajson))
  titlehtml=gsub(suffix,"",gsub(".json","",filedatajson))
  
  filehtml=gsub("XXFILEXX",filejsname,filehtml)
  filehtml=gsub("XXTITLEXX",titlehtml,filehtml)
  
  filejs=gsub(keyword[1],filedatajson,filejs)
  filejs=gsub(keyword[2],titlehtml,filejs)
  filejs=gsub(keyword[3],age,filejs)
  filejs=gsub(keyword[4],width,filejs)
  filejs=gsub(keyword[5],mink,filejs)
  filejs=gsub(keyword[6],maxk,filejs)
  
  cat(filehtml,file=filehtmlname)
  cat(filejs,file=filejsname)
  
}
