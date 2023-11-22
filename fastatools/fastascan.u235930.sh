#!/bin/bash


##################### 0.0 : STARTING... #####################################

## 0.1 : Header of the report

echo "#####################################"
echo "#   MSc in Bioinformatics @ UPF     #"
echo "# Midterm assignment - FASTASCAN.SH #"
echo "#####################################"
echo ""


## 0.2 : Default values

if [[ -n "$1" ]]; then
    dir="$1"
else
    dir="."
fi


if [[ -n "$2" ]]; then
    n="$2"
else
    n="0"
fi


##################### 1.0 : INIT FASTASCAN - DEFINING VALUES #################

echo "#####################################"
echo "#       STARTING THE ANALYSIS       #"
echo "#####################################"

## 1.1 : Searching the files
fafiles=$(find "$dir" -type f -name "*.fa" -or -name "*.fasta");

## 1.2 : Counting the number of files found
numfiles=$(echo "$fafiles" | wc -l);

## 1.3 : Counting the number of sequences found (unique FASTA ID) and sequence length
numseqs=$(egrep "^>" $fafiles | sort -u | wc -l)

## 1.4 : Counting how many symbolic links there are

symlcount=0
for file in $fafiles; do
    if [[ -L $file ]]; then
	((symlcount++))
    fi;
done; 

## 1.5 : Printing first results
echo "A total of $numfiles files have been found."
echo "In all $numfiles files, a total of $numseqs unique sequences have been found."
echo "From all $numfiles files, $symlcount of them are symbolic links"


##################### 2.0: Analyzing in-depth the files #####################

echo "#####################################"
echo "#      FILE BY FILE  ANALYSIS       #"
echo "#####################################"


## 2.1 : For loop to analyse all sequences

nfile=0
for file in $fafiles;
do
   ((nfile++));

   echo "###################################################################################################"
   echo "#      File nº $nfile : $file #"
   echo "###################################################################################################"

## 2.1.1 : Checking if the file is DNA/RNA or AA

   
   if egrep -qi '^>[ACGTN]+$' "$file"; then
       content="DNA-RNA"
   else
       content="AA"
   fi;
   

## 2.1.2 : Number of sequences in each file 

   numseqs_file=$(egrep -c '>' "$file")

## 2.1.3 : Sequence length

   seqlen=$(gawk '/>/ {next} {gsub(/-|[[:space:]]/,"");
                    len+=length($0)} END{print len}' "$file");   


###seqlen= $ (gawk                               using gawk 
#	    '/>/ {next}                          if line starts with >, skip to the next one
#                 {gsub(/-|[[:space:]]/,"");     general substitution, when find a dash | whitespace, convert it to "" = nothing 
#                  len+=length($0)}              define len valuem which will calculate the length of $0 = sequence after first row
#                  END{print len}' "$file")'     store value by printing + $file to process with gawk

## 2.1.4 : Is file a symbolic link or not (each file)

   if [[ -L $file ]]; then
       file_symlink="Yes"
   else
       file_symlink="No"
   fi;


## 2.2    : Printing results

   # File content
   echo "## Content of the sequence : $content"

   # Num of seqs
   echo "## Number of sequences : $numseqs_file"

   # Seq length
   echo "## Length of the sequence : $seqlen"

   # Symbolic link
   echo "## Symbolic link : $file_symlink "
  

##################### 3.0   : Display the content #####################
   
   echo ""
   echo "####### Printing file content... #######"
   echo ""

   
## 3.1   : Checking the lines

   lines_file=$(wc -l < "$file")

## 3.2   : Making the printing

  if [[ "$lines_file" -le $((2*n)) ]]; then
      cat "$file"
  elif [[ "$lines_file" -eq 0 ]]; then
      echo "The file nº $nfile is empty"
  else
      echo "!! Warning: the output of this file will be only printing the $n first lines and the $n last lines "
      head -n "$n" "$file"
      echo "..."
      tail -n "$n" "$file"
  fi;
    
##################### 4.0    : ENDING  #####################

   echo "#####################################"
   echo "#  Report of file nº $nfile done... #"
   echo "#####################################"
   echo ""
   echo ""
  
done;

echo "#####################################"
echo "#              THE END              #"
echo "#     All fasta files found have    #"
echo "#     been analysed ... thanks!     #"
echo "#####################################"

