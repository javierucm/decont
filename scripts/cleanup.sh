if [ "$#" -eq 0 ] 
then
	set data resources output logs
fi
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
   rm Log.out
  ;;
esac
done
