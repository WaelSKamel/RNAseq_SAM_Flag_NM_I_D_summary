#!/usr/bin/perl -w
use warnings;
$samfile = $ARGV[0];
open FILEONE, $samfile ;
while (<FILEONE>)

{
chomp;
@array = split(/\t/, $_);

unless ($array[0] =~ m/@/) #ignore header
{

#extract flag information 

$samflag=$array[1];

#extract chromosome information 

$chr=$array[2];

#start counting flags/chr information 

$chr_samflag = "$chr\t$samflag";
$Flag_counts{$chr_samflag}++;

#start counting mismatch information as well, if using star aligner , we are aiming for :
# NM:i:count Number of differences (mismatches plus inserted and deleted bases) between the sequence and reference.
# be sure that col.number is matching with what mentioned here

$NM = $array[-2];
@Number_of_differences = split(/\:/, $NM);

$differences_counts{$chr_samflag} += $Number_of_differences[2];

#Start counting Insertion, deletion, splciing events from CIGAR values

if (  $array[5] =~ m/N/) { $spliced_counts{$chr_samflag}++   }
if (  $array[5] =~ m/I/) { $Insertion_counts{$chr_samflag}++ }
if (  $array[5] =~ m/D/) { $deletion_counts{$chr_samflag}++ }

}

}

#printing extracted information
	print" chromosome\tFlag/strand\tTotalreads\tTotaldifferences\tTotalsplicing\tTotalInsertion\tTotaldeletion\n" ;

foreach $key (sort keys %Flag_counts)
{

	print"$key\t$Flag_counts{$key}\t$differences_counts{$key}\t$spliced_counts{$key}\t$Insertion_counts{$key}\t$deletion_counts{$key}\n" 
}