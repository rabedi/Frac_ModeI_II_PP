{\rtf1\ansi\ansicpg1252\cocoartf1187\cocoasubrtf400
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural

\f0\fs24 \cf0 - Change Matlab active folder to this directory\
- copy and modify ConfigSample.txt to a config file for your use (e.g. CONFIG.txt)\
- Run\
MAINFILE_operatorSpaceMesh('CONFIG.txt")\
\
Things to change in CONFIG.txt\
\
#change the last file serial number \
#change if want to start later in simulation change start serial number\
#change step as multiply of 50000 if need faster progress between images\
serialNum	start	50000 step	50000	end_s1	19100000\
\
## path where output folder are located. If working with a code checked out from svn do not change the following\
dir_PreName_s2			../\
dir_RunName				physics\
runNameAppendix			all\
\
\
outputDir				runFolder\
#change run name\
runName				SF\
\
\
Change visualization space domain bound\
xlim			1\
xmin			2.0	\
xmax			4.00\
ylim			1\
ymin			-1.50\
ymax			1.40	\
\
\
Change number of colors used for damaging surfaces (don't forget to change the number of inputs first)\
numberDistDPts				3\
NumberOfDistinctLevelsDicreadingD\
minDamage	lineType	lineClr	lineWidth\
0.99		sym	k		-		2.5\
0.5		sym	r		-		2.5\
-1		sym	b		-		2.5\
pltDmgdUnDmaged		0\
\
\
\
### red boxes in the mesh. Change the number from zero to n > 0 with n rows of xmin max, ymin, ymax\
box\
number	0\
Xmin 		Ymin		Xmax		Ymax\
lineWidth		2\
lineColor		num		0.2 	1 	0.8}