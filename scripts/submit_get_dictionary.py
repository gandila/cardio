#!/usr/bin/python2.4
# Example PBS cluster job submission in Python

from popen2 import popen2
import time
import random, string
import os, sys
import subprocess

# If you want to be emailed by the system, include these in job_string:
#PBS -M yourname@gmail.com
#PBS -m abe  # (a = abort, b = begin, e = end)

def randomword(length):
	return ''.join(random.choice(string.lowercase) for i in range(length))

dir=os.getcwd()
ref_dir="~/cardio/"

print "Test Script!"
print "Current working directory:"+dir
print "Reference file directory:"+ref_dir

# Loop over your jobs
for n in range(44, 45):
	# Open a pipe to the qsub command.
	stdoutput, stdinput = popen2('qsub -cwd ')
	# Customize your options here
	job_name = "count_c_%s" % str(n)
	job_output = "%soutput/count_c_%s" % (ref_dir, str(n))
	random_string=job_name+randomword(20)
	tmp_name="/state/partition1/tmp/%s"   % random_string
	file_in="vfp_cardio_ecg_mortara_cl_chunk_%s.txt" % str(n)
	file_out="freq_chunk_%s.txt" % str(n)
	#Commands
	command1="mkdir %s" % tmp_name
	command2="cd %s" % tmp_name
	command3="cp %sinput/%s ." % (ref_dir, file_in)
	command4="Rscript --vanilla %sscripts/get_dictionary.R %s %s" % (ref_dir, file_in, file_out)
	#command4="Rscript --vanilla %sscripts/Rtest.r %s %s" % (ref_dir, file_in, file_out)
	command5="cp %s %soutput/%s" % (file_out, ref_dir, file_out)
	command6="cd %s" % ref_dir
	command7="rm -r %s" % tmp_name
	job_string = """#!/bin/bash
#$ -S /bin/bash
#$ -N %s
#$ -e %s".err"
#$ -o %s".out"
%s #cmd1
%s #cmd2
%s #cmd3
%s #cmd4
%s #cmd5
%s #cmd6
%s """ % (job_name, job_name, job_name, command1, command2, command3, command4, command5, command6, command7)

	# Send job_string to qsub
	stdinput.write(job_string)
	stdinput.close()
	# Print your job and the response to the screen
	print job_string
	print stdoutput.read()
	time.sleep(0.1)








