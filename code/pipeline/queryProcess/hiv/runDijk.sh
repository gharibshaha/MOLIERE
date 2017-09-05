#!/bin/bash
#PBS -N runDijk
#PBS -l select=1:ncpus=24:mem=500gb,walltime=72:00:00
#PBS -q bigmem
#PBS -o /home/jsybran/jobLogs/runDijk.out
#PBS -e /home/jsybran/jobLogs/runDijk.err
#PBS -M jsybran@clemson.edu
#PBS -m ea
# the above is a default PBS header

module load gcc openmpi

# Place us in the working directory
if [ -z "$PBS_O_WORKDIR" ]; then
  echo "Must be submitted through PBS from home directory"
  exit 1
fi
cd $PBS_O_WORKDIR

# Identify the project home dir
if [ -z "$PROJ_HOME" ]; then
  echo "searching for moliere home directory"
  PROJ_HOME=$(pwd | grep -o .*moliere)
  if [ "$PROJ_HOME" = "" ]; then
    echo "Failed to find project home"
    exit 1
  else
    echo "Found $PROJ_HOME"
  fi
fi


# add project tools to path
PATH=$PATH:$PROJ_HOME/code/components/links

# data expected to be here
DATA=$PROJ_HOME/data
# network info expected to be here
NETWORK=$DATA/network

GRAPH=$NETWORK/final.edges
LABELS=$NETWORK/final.labels

SOURCE_WORD=hiv_associate_dementia

SOURCE_IDX=$( grep -n $SOURCE_WORD $LABELS | awk 'BEGIN{FS=":"}{print $1-1}')

TARGET_PATH=$DATA/geneData/geneList.indices

OUT_DIR=$PROJ_HOME/results/hiv-assc-dijk
mkdir -p $OUT_DIR

OUT=$OUT_DIR/hiv_associate_dementia.dijkstra

runDijkstra -g $GRAPH -s $SOURCE_IDX -T $TARGET_PATH -o $OUT -l $LABELS
