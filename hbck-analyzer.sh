#!/bin/bash

TMP_FILE="/tmp/"$1".ERROR"

alias ag="ag --no-numbers --max-count 2147483647"
ag "ERROR: " "$1" | grep -v "ERROR: Found" > /tmp/"$1".ERROR

vfilenotexist=`ag "Version file does not exist in root dir " $TMP_FILE | wc -l`
rootregionnull=`ag "Root Region or some of its attributes are null" $TMP_FILE | wc -l`
unabletocloseregion=`ag "Unable to close region" $TMP_FILE | wc -l`
nohdfsnometadeployed=`ag "not on HDFS or in META but" $TMP_FILE | wc -l`
onhdfsnometa=`ag "on HDFS, but not listed in META or deployed on any region server" $TMP_FILE | wc -l`
notmetadeployed=`ag "not in META, but deployed on" $TMP_FILE | wc -l`
splitparentinmeta=`ag "is a split parent in META, in HDFS, and not deployed on any region server. This could be transient." $TMP_FILE | wc -l`
inmetanohdfsor=`ag "found in META, but not in HDFS or deployed on any region server" $TMP_FILE | wc -l`
inmetanothdfsand=`ag "found in META, but not in HDFS, and deployed on" $TMP_FILE | wc -l`
notdeployed=`ag "not deployed on any region server" $TMP_FILE | grep -v "This could be transient" | wc -l`
shouldnotbedeployed=`ag "should not be deployed according to META, but is deployed on" $TMP_FILE | wc -l`
multiplyassigned=`ag "is listed in META on region server but is multiply assigned to region servers" $TMP_FILE | wc -l`
differnetassignment=`ag "listed in META on region server " $TMP_FILE | wc -l`
unforeseenstate=`ag "is in an unforeseen state" $TMP_FILE | wc -l`
endkeybeforestartkey=`ag "The endkey for this region comes before the startkey" $TMP_FILE | wc -l`
needtocreateregioninfo=`ag "First region should start with an empty key.  You need to" $TMP_FILE | wc -l`
needtocreateregioninfo2=`ag "Last region should end with an empty key. You need to" $TMP_FILE | wc -l`
samestartendkey=`ag "Region has the same start and end key" $TMP_FILE | wc -l`
samestartkey=`ag "Multiple regions have the same startkey" $TMP_FILE | wc -l`
overlappedregions=`ag "There is an overlap in the region chain" $TMP_FILE | wc -l`
hole=`ag "You need to create a new .regioninfo and region" $TMP_FILE | wc -l`
needtocreateregioninfo3=`ag "First region should start with an empty key.  Creating a new" $TMP_FILE | wc -l`
needtocreateregioninfo4=`ag "Last region should end with an empty key. Creating a new" $TMP_FILE | wc -l`
hole2=`ag "Creating a new regioninfo and region dir in hdfs to plug the hole." $TMP_FILE | wc -l`
failedfetchregion=`ag "Unable to fetch region information" $TMP_FILE | wc -l`
orphan=`ag "Orphan region in HDFS: Unable to load .regioninfo from table" $TMP_FILE | wc -l`

# After 0.94-CDH4.2
unabletoreadtableinfo=`ag "Unable to read .tableinfo from" $TMP_FILE | wc -l`
lingeringfile=`ag "Found lingering reference file" $TMP_FILE | wc -l`

echo `tail -2 $1 | head -1 | awk '{print $1}'`": Total inconsistencies detected"
if test ${rootregionnull} -ne 0; then echo $rootregionnull": Root Region or some of its attributes are null."; fi
if test ${unabletocloseregion} -ne 0; then echo $unabletocloseregion": Unable to close region because meta does not have handle to reach it."; fi
if test ${nohdfsnometadeployed} -ne 0; then echo $nohdfsnometadeployed": Region X, key=Y, not on HDFS or in META but deployed on Z --> Should FixAssignments."; fi
if test ${onhdfsnometa} -ne 0; then echo $onhdfsnometa": Region X on HDFS, but not listed in META or deployed on any region server --> Should FixMeta."; fi
if test ${notmetadeployed} -ne 0; then echo $notmetadeployed": Region X not in META, but deployed on Z --> Should FixMeta."; fi
if test ${splitparentinmeta} -ne 0; then echo $splitparentinmeta": Region X is a split parent in META, in HDFS, and not deployed on any region server. This could be transient. --> FixSplitParents?"; fi
if test ${inmetanohdfsor} -ne 0; then echo $inmetanohdfsor": Region X found in META, but not in HDFS or deployed on any region server. --> Should FixMeta"; fi
if test ${inmetanothdfsand} -ne 0; then echo $inmetanothdfsand": Region X found in META, but not in HDFS, and deployed on Z. --> Shuld FixAssignments and FixMeta."; fi
if test ${notdeployed} -ne 0; then echo $notdeployed": Region X not deployed on any region server."; fi
if test ${shouldnotbedeployed} -ne 0; then echo $shouldnotbedeployed": Region X should not be deployed according to META, but is deployed on Z. --> Should FixAssignments."; fi
if test ${multiplyassigned} -ne 0; then echo $multiplyassigned": Region X is listed in META on region server but is multiply assigned to region servers Z. --> Should FixAssignments."; fi
if test ${differnetassignment} -ne 0; then echo $differnetassignment": Region X listed in META on region server Z but found on region server ZZ. --> Should FixAssignments."; fi
if test ${endkeybeforestartkey} -ne 0; then echo $endkeybeforestartkey": The endkey for this region comes before the startkey, ..."; fi
if test ${needtocreateregioninfo} -ne 0; then echo $needtocreateregioninfo": First region should start with an empty key.  You need to create a new region and regioninfo in HDFS to plug the hole."; fi
if test ${needtocreateregioninfo2} -ne 0; then echo $needtocreateregioninfo2": Last region should end with an empty key. You need to create a new region and regioninfo in HDFS to plug the hole."; fi
if test ${samestartendkey} -ne 0; then echo $samestartendkey": Region has the same start and end key"; fi
if test ${samestartkey} -ne 0; then echo $samestartkey": Multiple regions have the same startkey"; fi
if test ${overlappedregions} -ne 0; then echo $overlappedregions": There is an overlap in the region chain"; fi
if test ${hole} -ne 0; then echo $hole": There is a hole in the region chain between X and Y.  You need to create a new .regioninfo and region dir in hdfs to plug the hole."; fi
if test ${needtocreateregioninfo3} -ne 0; then echo $needtocreateregioninfo3": First region should start with an empty key.  Creating a new region and regioninfo in HDFS to plug the hole."; fi
if test ${needtocreateregioninfo4} -ne 0; then echo $needtocreateregioninfo4": Last region should end with an empty key. Creating a new region and regioninfo in HDFS to plug the hole."; fi
if test ${hole2} -ne 0; then echo $hole2": There is a hole in the region chain between X and Y.  Creating a new regioninfo and region dir in hdfs to plug the hole."; fi
if test ${orphan} -ne 0; then echo $orphan": Orphan region in HDFS: Unable to load .regioninfo from table X in hdfs dir Y !  It may be an invalid format or version file.  Treating as an orphaned regiondir."; fi
if test ${failedfetchregion} -ne 0; then echo $failedfetchregion": Unable to fetch region information"; fi
if test ${unforeseenstate} -ne 0; then echo $unforeseenstate": Region X is in an unforeseen state ..."; fi

# After 0.94-CDH4.2
if test ${unabletoreadtableinfo} -ne 0; then echo $unabletoreadtableinfo": Unable to read .tableinfo from ..."; fi
if test ${lingeringfile} -ne 0; then echo $lingeringfile": Found lingering reference file X"; fi
