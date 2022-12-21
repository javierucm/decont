
#Cleanup : Full cleanup if no parameters.
[ "$#" -eq 0 ] && set data resources output logs 

for arg; do
   case $arg in
  data)
   #find data -type f -not -name "urls" -delete
  rm -rf data/*.fastq*
;;
  resources)
    rm -rf res/*
  ;;
  output)
    rm -rf out/*
  ;;
  logs)
   rm -rf log/*
   rm -f Log.out
  ;;
esac
done
