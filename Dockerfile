# This Dockerfile will build an image that, when run, will execute
# the exemplar test harness with data provided by the data files.
#
# The base docker image is pre-built during the competition to 
# support the pseudo-offline competition environment, as well 
# as reducing time spent on dependency installations.
#
# The location of the base docker image can be found in the CP's
# project.yaml, as well as the run script.
#
# Competitors are free to modify the docker image as desired;
# additions appended to this file can be manually built by running
#
#       docker build . -t cp-sandbox
#
# Additionally, the run.sh 'build' command will use the modified 
# Dockerfile for building, running, and testing.

###########################################
FROM ubuntu:22.04 as exemplar-cp-linux-base

# Set environment variables
ENV BINS=/usr/local/sbin/
ENV SRC=/src/
ENV OUT=/out/
ENV WORK=/work/

# Install necessary dependencies for the image
COPY exemplar_only/patches/setup.sh $BINS/setup.sh

# Debugging step: Verify that setup.sh has been copied correctly and has the right permissions
RUN ls -l $BINS/setup.sh

# Ensure setup.sh has execute permissions
RUN chmod +x $BINS/setup.sh

# Run setup.sh script
RUN $BINS/setup.sh

# Create directories
RUN mkdir -p $OUT $WORK $SRC

# Copy other internal files that will be used inside the image
COPY build.sh $BINS/build.sh
COPY exemplar_only/run_internal.sh $BINS/run_internal.sh
COPY exemplar_only/test_blob.py $BINS/test_blob.py

################################################
# Use the image built in the first stage as the base for the second stage
FROM exemplar-cp-linux-base as exemplar-cp-linux

# Competitors can add changes to default docker image here
