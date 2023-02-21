#De-Kayne 2023
#script to correct bed files and make sure start < end
#run the following in a folder with access to the bed.list file and the files themselves
#bed.list should have one .bed file per line
#example command
# Rscript --vanilla fix_bed.R

list_file="bed.list"

bed_list <- read.csv(list_file, header = F)

for (j in 1:length(bed_list$V1)){
  file_to_extract <- bed_list$V1[j]
  bed_file <- read.csv(file_to_extract, sep = "\t", header = F)
  chr <- c()
  start <- c()
  end <- c()
  region <- c()
  
  for (i in 1:length(bed_file$V1)){
    if(bed_file$V2[i] < bed_file$V3[i]){
      chr[i] <- bed_file$V1[i]
      start[i] <- bed_file$V2[i]
      end[i] <- bed_file$V3[i]
      region[i] <- bed_file$V4[i]
    }
    if(bed_file$V2[i] > bed_file$V3[i]){
      chr[i] <- bed_file$V1[i]
      start[i] <- bed_file$V3[i]
      end[i] <- bed_file$V2[i]
      region[i] <- bed_file$V4[i]    
    }
  }
  
  new_bed_file <- as.data.frame(cbind(chr, start, end, region))
  new_bed_file$start <- as.numeric(new_bed_file$start)
  new_bed_file$end <- as.numeric(new_bed_file$end)
  
  write.table(new_bed_file, file = paste("new_", file_to_extract, sep = ""), col.names = F, row.names = F, quote = F, sep = "\t")
}
