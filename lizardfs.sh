#!/bin/bash

LIZARDHOSTS="192.0.0.1 10.10.12.4"
LFSADMIN=/opt/lizardfs/3.10.4/bin/lizardfs-admin
for host in $LIZARDHOSTS
do

	$LFSADMIN info $host 9421 --porcelain | awk '{print "lizard_info,lizardmaster='$host' Memory_usage="$2",Total_space="$3",Available_space="$4",Trash_space="$5",Trash_files="$6",Reserved_space="$7",Reserved_files="$8",FS_objects="$9",Directories="$10",Files="$11",Chunks="$12",Chunk_copies="$13",Regular_copies_deprecated="$14}'
       $LFSADMIN ready-chunkservers-count $host 9421 | awk '{print "lizard_ready-chunkservers-count,lizardmaster='$host' chunkservers-count="$1}'
       $LFSADMIN chunks-health $host 9421 --porcelain | grep AVA | awk '{print "lizard_chunks-health,lizardmaster='$host',state="$1",goal="$2" safe="$3",unsafe="$4",lost="$5}'
       $LFSADMIN chunks-health $host 9421 --porcelain | egrep '(REP|DEL)' | awk '{print "lizard_chunks-health,lizardmaster='$host',state="$1",goal="$2" 0="$3",1="$4",2="$5",3="$6",4="$7",5="$8",6="$9",7="$10",8="$11",9="$12",10+="$13}'
       $LFSADMIN list-chunkservers $host 9421 --porcelain | awk '{print "lizard_chunkservers,lizardmaster='$host',server="$1" version=\""$2"\",chunks="$3",used_space="$4",total_space="$5",chunks_marked_removal="$6",usedspace_marked_removal="$7",usedspace_marked_removal_total="$8",errors="$9}'
       $LFSADMIN list-metadataservers $host 9421 --porcelain | awk '{print "lizard_metadataservers,lizardmaster='$host',hostname="$3" ip=\""$1"\",port="$2",personality=\""$4"\",status=\""$5"\",metadata_version="$6",version=\""$7"\""}'
	$LFSADMIN list-disks $host 9421 --porcelain --verbose | awk '{print "lizard_disks,lizardmaster='$host',chunkserver="$1",path="$2" to_delete=\""$3"\",damaged=\""$4"\",scanning=\""$5"\",last_error=\""$6"\",total_space="$8",used_space="$9",chunks="$10",read_bytes="$11",written_bytes="$12",max_read_time="$13",max_write_time="$14",max_fsync_time="$15",read_ops="$16",write_ops="$17",fsync_ops="$18}'

done

