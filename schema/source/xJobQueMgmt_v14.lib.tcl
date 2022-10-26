# @PROGDOC: Libray functions to facilitate xJob and xQue Management
# @Namespace/Class = xHash + xQue + xJob
# @Methods = (null)
# @Properties = (null)
# @Program = xJobQueMgmt_v14.lib.tcl
# @Version  = 14.0
# @Synopsis = implementation support library
# @Purpose = to iterate on queue folders seeking jobs
# @Implementation = source C:/root/RazorLeaf/ACGap/script/xJobQueueMgmt.tcl
# @Package = package require Hdr;
# @Object = (null)


###############################################################################
############################ Package Mgmt. ####################################
package provide xJobQueueMgmt

#~ Library Package loading
#~ Block commented as loaded by MAIN()
if 0 {
	set sTDOMDLL [::xLib::FindLib "tdom090.dll"]
	set sTDOMTCL [::xLib::FindLib "tdom.tcl"]

	if 0 {
		package ifneeded tdom 0.9.0 \
		"load [list [file join $LIBDIR tdom090.dll]];\
				 source [list [file join $LIBDIR tdom.tcl]]"
	} else {
		package ifneeded tdom 0.9.0 \
		"load [list $sTDOMDLL];\
				 source [list $sTDOMTCL]"
	}

	package require tdom
}
###############################################################################

# @~~~ QUEUE - is a loop that processes jobs
# @~~~	Each runtime of this program is a "queue"
# @~~~	to have 3 "queues", you would launch 3 seperate sessions of MQL on the same or different computers
# @~~~	QUEUEs are controlled by "semaphores" for START, PAUSE, and STOP
# @~~~		When this program runs, it creates a uniqu hash for a QUEUE ID, and the semaphore is named by the HASH
# @~~~		When a hash file is created as a PAUSE, processing will cease until the PAUSE is removed (the START remains)
# @~~~		When a hash file is created as a STOP, the START semaphore is removed, and the QUEUE processing LOOP exits, thus existing the program runtime
# @~~~	QUEUE processing of JOBs occurs when the QUEUE is started and getJob() is called.
# @~~~		getJob() scans the "IN" box (folder) for PLM Object Portfolio Containers (folder) that contains a RDY Semaphore.
# @~~~
# @~~~ JOB - is a folder that is queued for processing. The JOB contains the following elements:
# @~~~     "PLM Object Portfolio" folder - this is a folder based on the derivative transformed (from input src) TYPE_NAME_REVISION in a STAGING area where the folder is created and manipulated
# @~~~     Elements contained in a valid "PLM Object Portfolio" folder -
# @~~~              - RDY.sema, SNT.sema, or LOK.sema semaphore file, indicating the job is ready for processing or is being processed
# @~~~              - TYPE_NAME_REVISION.xml - the object definition XML file. This file may contain more than 1 object, where object pairs exist like: Master-->Version-->Dervide Output
# @~~~              - one or more files (CAD, DOC, etc) -  that are called out in the XML object metadata to be checked into the above objects once created

set MIGRATION_PREFIX "ACG"

#set sSTAGING "c:/root/tmp/staging"
#append sIN      "$sSTAGING" "/" "in"
#append sControl "$sSTAGING" "/" "control"
#append sArchive "$sSTAGING" "/" "archive"
#append sError   "$sSTAGING" "/" "error"
set sSTAGING [join [list "$::ACGMZ" "staging"] /]
set sControl "$::ACGMZ_CONTROL"
set sIN      "$::ACGMZ_IN"
set sArchive "$::ACGMZ_ARCHIVE"
set sError   "$::ACGMZ_ERROR"

# @~~~ QUEUE Management:
# @~~~	Queue mgmt impinges control on the job processing LOOP
# @~~~	IF no queue Semaphore exists, then the initial launch of the migration processor issues: xStartQueSemaphore
# @~~~	IF START queue Semaphore exists, then the loop will iterate another loop looking for a JOB, or sleep in no JOB is READY
# @~~~	to PAUSE processing, issue xPauseQueSemaphore, the loop will iterate on sleep until the xPauseQueSemaphore is replaced with xStartQueSemaphore
# @~~~	to STOP processing, issue xStopQueSemaphore, this will cause the loop to exit, and exit the program
set QUEISSTARTED	 1
set QUEISSTOPPED	 0
set QUEISPAUSED		-1
set QUEISNOTSTARTED -2

# @~~~ Job/Import Validation:
# @~~~   Pre-Import Validation:
# @~~~     Level 1) RDY semaphore and XML file present in "PLM Object Portfolio" container folder in export/import staging area
# @~~~     Level 2) XML file has at least 1 valid minimum object specification: Type Name Rev Vault Policy
# @~~~     Level 3) XML file has all (1+) valid object definitions & all files specified in XML obj are present in "PLM Object Portfolio" container folder
# @~~~   Post-Import Validation:
# @~~~     Level 4) XML objects are imported in 3DX/Matrix and validated for TNR, Attributes, Relationships, File content - object specs written to log file in "PLM Object Portfolio" container folder
# @~~~  IF Validation == OK, then move "PLM Object Portfolio" container folder from IN staging folder to ARCHIVE staging folder
# @~~~  IF Validation == FAILED, then move "PLM Object Portfolio" container folder from IN to ERROR staging folder
set JOBSUCCESS 2
set JOBALREADYLOCKED 1
set JOBNOJOBRDY 0
set JOBFAILED -1
set JOBERROR  -2

set JOBNOJOB   0
set JOBGOTJOB  2

set JOBISREADY   1
set JOBNOTREADY  0

set JOBOVERLOCKED -1
set JOBISLOCKED   1
set JOBNOTLOCKED  0


# @~~~ SEMA (semaphoe) - is used for interprocess messaging at a basic level. One process will create a SEMA to indicate status of the job to all other processes
# @~~~ EXPORT process semaphores (CRT & RDY) - is created by the SQL export process. When the job folder is created and the export is in process, no other process should "read" the job",
# @~~~        so a CRT semaphore is posted. Once the SQL export process has completed populated the job folder, the CRT is changed to a RDY semaphore to indicate it is complete
# @~~~        and ready for import processing
# @~~~ IMPORT processs semaphores (LOK, DON, ERR) - are created to message between import process threads that the job is open to assign or has been assigned to an import process thread.
# @~~~        LOK indicates that a process thread has taken ownership of the job and is processing. DON indicates that the job has been processed successfully and is being moved to ARCHIVE queue.
# @~~~        ERR indicates that something errored in the import process, and the job is being moved to the ERROR queue
# @~~~ Semaphore format: %xSEMA%.sema (ex: CRT.sema, RDY.sema, LOK.sema, DON.sema, ERR.sema)
# @~~~ Semaphore content: dir listing of content of semaphore
set xSEMA(CREATE)  "CRT.sema"    ;   #~ this semaphore is created by the SQL export process to indicate the job exists but is not done exporting (sema to SQL exporter)
set xSEMA(READY)   "RDY.sema"    ;   #~ this semaphore is created by the SQL export process to indicate the job exists and is complete, ready for import
set xSEMA(SENT)    "SNT.sema"    ;   #~ this semaphore is created by the Import process to indicate that the job has been sent from the GMZ to Clover Processing Server
set xSEMA(LOCKED)  "LOK.sema"    ;   #~ this semaphore is created by the Import process to indicate that the job has been activated and is assigned to an import thread
set xSEMA(DONE)    "DON.sema"    ;   #~ this semaphore is created by the Import process to indicate that the job has completed successfully (and is ready to move to ARCHIVE)
set xSEMA(ERROR)   "ERR.sema"    ;   #~ this semaphore is created by the Import process to indicate that the job has errored out (and is ready to move to ERROR)

#~~~ File Kind: file kind is a derivative of the file extension as mapped to a generic/normalized type of file, that can in lueu of explicite MXFORMAT be used
#~~~      The file EXT as returned by fileInfo() can be the associative array index to determine the KIND, also returned by fileInfo()
set xFILEKIND(DWG)      "CAD"
set xFILEKIND(DGN)      "CAD"
set xFILEKIND(SLDPART)  "CAD"
set xFILEKIND(SLDASSY)  "CAD"
set xFILEKIND(DOC)      "DOC"
set xFILEKIND(DOCX)     "DOC"
set xFILEKIND(XLS)      "DOC"
set xFILEKIND(XLSX)     "DOC"
set xFILEKIND(XML)      "XML"
set xFILEKIND(LOG)      "LOG"
set xFILEKIND(LOG)      "LOG"
set xFILEKIND(SEMA)     "SEMA"

#~~~ Generic Tri-Boolean Constants values
set TRUE 1
set FALSE 0
set ERROR -1

#~~~ HASH map
set CHARS   [list a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 { } ( ) . - _ = + "\\n"]
set KEYS    [list 0 1 2 3 4 5 6 7 8 9 A B C D E F]
set HASH(0) [list 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F]
set HASH(1) [list 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F]
set HASH(2) [list 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F]
set HASH(3) [list 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F]
set HASH(4) [list 40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F]
set HASH(5) [list 50 51 52 53 54 55 56 57 58 59 5A 5B 5C 5D 5E 5F]
set HASH(6) [list 60 61 62 63 64 65 66 67 68 69 6A 6B 6C 6D 6E 6F]
set HASH(7) [list 70 71 72 73 74 75 76 77 78 79 7A 7B 7C 7D 7E 7F]
set HASH(8) [list 80 81 82 83 84 85 86 87 88 89 8A 8B 8C 8D 8E 8F]
set HASH(9) [list 90 91 92 93 94 95 96 97 98 99 9A 9B 9C 9D 9E 9F]
set HASH(A) [list A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 AA AB AC AD AE AF]
set HASH(B) [list B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 BA BB BC BD BE BF]
set HASH(C) [list C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC CD CE CF]
set HASH(D) [list D0 D1 D2 D3 D4 D5 D6 D7 D8 D9 DA DB DC DD DE DF]
set HASH(E) [list E0 E1 E2 E3 E4 E5 E6 E7 E8 E9 EA EB EC ED EE EF]
set HASH(F) [list F0 F1 F2 F3 F4 F5 F6 F7 F8 F9 FA FB FC FD FE FF]
set xHASHMAP [list]
set yHASHMAP [list]


namespace eval xHash {

    proc xInit {} {
         set x [createHexHashTable]
    }

    # @Method(global): ::xHash::createUniqueThreadID(sPrefix iRandomize iPersonalize) - returns a unique hashed thread ID for a new queue process
    proc createUniqueThreadID {{sPrefix ""} {iRandomize $::TRUE} {iPersonalize $::FALSE} } {

           set oComputer [lindex [array get ::env COMPUTERNAME] 1]
           set oProcessID [pid]
           if {[catch {info level 2} sThreadName] != 0} {
              set sThreadName "THD001"
           }
           set sThreadName "THD001"
           set oTimeID [clock seconds]
           #set oTimeID [clock format [clock seconds] -format {%d%b%Y.%H%M%S}]

           if {[::xUtil::isNull "$sPrefix"] == $::FALSE}     { append oCreateUniqueThreadID "$sPrefix" "_"}
           if {[::xUtil::isNull "$oComputer"] == $::FALSE}   { append oCreateUniqueThreadID "$oComputer" }
           if {$iPersonalize == $::TRUE}                     { append oCreateUniqueThreadID "(" [lindex [array get ::env USERNAME] 1] ")"}
           if {[::xUtil::isNull "$sThreadName"] == $::FALSE} { append oCreateUniqueThreadID "." "$sThreadName" }
           if {[::xUtil::isNull "$oProcessID"] == $::FALSE}  { append oCreateUniqueThreadID "(" "$oProcessID" ")" }
           if {[::xUtil::isNull "$oTimeID"] == $::FALSE}     { append oCreateUniqueThreadID "$oTimeID" }
           if {$iRandomize == $::TRUE}                       { append oCreateUniqueThreadID "(" [expr {round(rand()*[pid])}] ")" }

            regsub -all -- " " "$oCreateUniqueThreadID" "" x
            regsub -all -- ":" "$x" "" oCreateUniqueThreadID

           return [encryptHexHash "$oCreateUniqueThreadID"]
      }

      # @Method(internal): ::xHash::incrHex(x) - takes a char HEX value, returns hex incrementaiton (0-->1 ... F-->0)
      proc incrHex {x} {
           set HEXIDX  [list 0 1 2 3 4 5 6 7 8 9 A B C D E F]
           set iHexMax [llength $HEXIDX]
           set idx [lsearch $HEXIDX [string toupper $x]]
           if {$idx > -1} {
               if {[incr idx] >= $iHexMax} {
                  set idx 0
               }
               return [lindex $HEXIDX $idx]
           } else {
               return $::ERROR
           }
      }

      # @Method(internal): ::xHash::createHexHashTable(xOffset xKey) - at initialization of the class, creates an in-memory forward and reverse hash tables, builds hash tables in global namespace
      #~ Function: createHash - to create a hash from the plain-text data sent, and return the hash
      #~ sData is the data to be hashed
      #~ iOffset is the HASH() array index
      #~ iKey is the coordinate within a HASH() list to lindex as the starter character in the map
      proc createHexHashTable {{xOffset 0} {xKey A}} {
           #~ variable initialization
           if {[llength $::xHASHMAP] > 0 } { set ::xHASHMAP [list] }
           if {[llength $::yHASHMAP] > 0 } { set ::yHASHMAP [list] }
           if {[info vars xHashedData] == "xHashedData"} { unset xHashedData }
           if {[info vars yHashedData] == "yHashedData"} { unset yHashedData }
           variable lHash {}
           #~ create hash table in memory
           set iMaxHashTableSize [expr [llength $::KEYS] * [array size ::HASH]]
           set lMasterIDX $::KEYS
           if {[lsearch $lMasterIDX $xOffset] == -1} {
              puts "ERROR:: Offset out of range, must be within: $lMasterIDX"
              return $::ERROR
           }
           set iSetLen  [llength $::CHARS]
           set iKey     [lsearch $lMasterIDX $xKey]
           set lHash    [lrange $::HASH($xOffset) $iKey end ]
           set xxOffset [incrHex $xOffset]
           while {[llength $lHash] < $iSetLen} {
               foreach i $::HASH($xxOffset) {
                   lappend  lHash $i
                   if {[llength $lHash] >= $iSetLen } {
                      break;
                   }
               }
               set xxOffset [incrHex $xxOffset]
           }
           #~ Create Forward Hash map here
           for {set j 0} {$j < $iSetLen} {incr j} {
               lappend ::xHASHMAP [lindex $::CHARS $j] [lindex $lHash $j]
           }
           #puts "Encrypt Hashmap: $::xHASHMAP"
           #~ Create Reverse Hash map here
           for {set j 0} {$j < $iSetLen} {incr j} {
               lappend ::yHASHMAP [lindex $lHash $j] [lindex $::CHARS $j]
           }
           #puts "Decrypt Hashmap: $::yHASHMAP"
      }

      # @Method(internal): ::xHash::encryptHexHash(sData) - takes sData (unhashed text) and encrypts the string based on the in-memory hash table forward hash, returns string
      proc encryptHexHash {sData} {
           if {[llength $::xHASHMAP] <= 0 } { set ::xHASHMAP [list] }
           #~ encrypt the sData to xHashMap
           set iData    [string length $sData]
           for {set i 0} {$i < $iData} {incr i} {
               set sChar [string index $sData $i]
               set iChar [lsearch $::xHASHMAP $sChar]
               append xHashedData [lindex $::xHASHMAP [incr iChar]]
           }
           #puts "Encrypted  string: $xHashedData"
           return "$xHashedData"
      }

      # @Method(internal): ::xHash::decryptHexHash(sData) - takes sData (hashed text) and decrypts the string based on the in-memory hash table reverse hash, returns string
      proc decryptHexHash {sData} {
           set iData    [string length $sData]
           for {set i 0} {$i < $iData} {incr i} {
               set sChar [string index $sData $i]
               append sChar  [string index $sData [incr i]]
               set iChar [lsearch $::yHASHMAP $sChar]
               append xUnHashedData [lindex $::yHASHMAP [incr iChar]]
           }
           #puts "Plain-Text string: $xUnHashedData"
           return "$xUnHashedData"
      }

      # @Method(global): ::xHash::getUniqueThreadInfo(sThreadID) - takes sThreadID (hashed text), decrypts the string, and resolves the class information, returns an array
      proc getUniqueThreadInfo {sThreadID} {
           #~ ACG_RL170701(JohnLopez).THD001(19312)203944750(1919)    - randomization & personalization
           #~ ACG_RL170701.THD001(19312)203944750(1919)               - randomization only
           #~ ACG_RL170701.THD001(19312)203944750                     - no randomization or personalization
           #~ ACG_RL170701(JohnLopez).THD001(19312)203944750          - personalization only

           set xUnEncryptedThreadID [decryptHexHash $sThreadID]

           set agetUniqueThreadInfo(Class)            [lindex [split $xUnEncryptedThreadID _.] 0]
           set agetUniqueThreadInfo(Platform)         [lindex [split $xUnEncryptedThreadID _.] 1]

           set xProcessThread    [lindex [split $xUnEncryptedThreadID _.] 2]
             set agetUniqueThreadInfo(xThreadClass)          [lindex [split $xProcessThread ()] 0]
             set agetUniqueThreadInfo(xThreadPID)            [lindex [split $xProcessThread ()] 1]
             set agetUniqueThreadInfo(xThreadTime)           [clock format [lindex [split $xProcessThread ()] 2] -format {%d%b%Y.%H%M%S}]
             set agetUniqueThreadInfo(xThreadRandomization)  [lindex [split $xProcessThread ()] 3]

           return [array get agetUniqueThreadInfo]
      }

      set x [xInit]

      namespace export createUniqueThreadID;
      namespace export getUniqueThreadInfo;

} ; #~endNamespace(xHash)



namespace eval xQue {

    variable ::xQue::xJob
    variable ::xQue::xCtrlID
    variable ::xQue::xStart
    variable ::xQue::xStop
    variable ::xQue::xPause


    proc xInit {} {
         set x [::xQue::generateQueControl $::MIGRATION_PREFIX]
    }

    # @Method(global): ::xQue::xStartQueSemaphore() - issues a QUEUE STARTED semaphore, returns boolean TRUE if successful, ERROR if failed or perminently stopped
    proc xStartQueSemaphore {} {
         set bxStartQueSemaphore $::FALSE
         if {[file exist "$::xQue::xStart"] == $::TRUE } {
            puts "WARNING:: Queue already started: $::xQue::xCtrlID"
            set bxStartQueSemaphore $::ERROR
         } elseif {[file exist "$::xQue::xPause"] == $::TRUE } {
            #set x [::xUtil::writeFile "$::xQue::xCtrlID"  "$::xQue::xStart" ]
            set x [file delete -force -- "$::xQue::xPause"]
            set bxStartQueSemaphore $::TRUE
         } elseif {[file exist "$::xQue::xStop"] == $::TRUE } {
            puts "WARNING:: Queue has been stopped"
            set bxStartQueSemaphore $::ERROR
         } else {
            set x [::xUtil::writeFile "[::xHash::getUniqueThreadInfo $::xQue::xCtrlID]"  "$::xQue::xStart" ]
            set bxStartQueSemaphore $::TRUE
         }
         return $bxStartQueSemaphore
    }

    # @Method(global): ::xQue::xStopQueSemaphore() - issues a QUEUE STOP semaphore, returns boolean TRUE if successful, ERROR if failed
    proc xStopQueSemaphore {} {
         set bxStopQueSemaphore $::FALSE
         if {[file exist "$::xQue::xStart"] == $::TRUE } {
            set x [::xUtil::writeFile "[::xHash::getUniqueThreadInfo $::xQue::xCtrlID]"  "$::xQue::xStop" ]
            set x [file delete -force -- "$::xQue::xStart"]
            set bxStopQueSemaphore $::TRUE
         } elseif {[file exist "$::xQue::xPause"] == $::TRUE } {
            set x [::xUtil::writeFile "[::xHash::getUniqueThreadInfo $::xQue::xCtrlID]"  "$::xQue::xStop" ]
            set x [file delete -force -- "$::xQue::xPause"]
            set bxStopQueSemaphore $::TRUE
         } elseif {[file exist "$::xQue::xStop"] == $::TRUE } {
            puts "WARNING:: Queue has already been stopped"
            set bxStopQueSemaphore $::ERROR
         } else {
            puts "WARNING:: Queue has never been started"
            set bxStopQueSemaphore $::ERROR
         }
         return $bxStopQueSemaphore
    }


    # @Method(global): ::xQue::xPauseQueSemaphore() - issues a QUEUE PAUSE semaphore, returns boolean TRUE if successful, ERROR if failed
    proc xPauseQueSemaphore {} {
         set bxPauseQueSemaphore $::FALSE
         if {[file exist "$::xQue::xStart"] == $::TRUE } {
            set x [::xUtil::writeFile "[::xHash::getUniqueThreadInfo $::xQue::xCtrlID]"  "$::xQue::xPause" ]
            #set x [file delete -force -- "$::xQue::xStart"]
            set bxPauseQueSemaphore $::TRUE
         } elseif {[file exist "$::xQue::xPause"] == $::TRUE } {
            puts "WARNING:: Queue has already been paused"
            set bxPauseQueSemaphore $::ERROR
         } elseif {[file exist "$::xQue::xStop"] == $::TRUE } {
            puts "WARNING:: can not pause, Queue has already been stopped"
            set bxPauseQueSemaphore $::ERROR
         } else {
            puts "WARNING:: Queue has never been started"
            set bxPauseQueSemaphore $::ERROR
         }
         return $bxStopQueSemaphore
    }

	proc isQueueStarted {} {
		 set bisQueueStarted $::FALSE
         if {[file exist "$::xQue::xPause"] == $::TRUE } {
            set bisQueueStarted $::QUEISPAUSED
         } elseif {[file exist "$::xQue::xStop"] == $::TRUE } {
            set bisQueueStarted $::QUEISSTOPPED
         } elseif {[file exist "$::xQue::xStart"] == $::TRUE } {
            set bisQueueStarted $::QUEISSTARTED
		 } else {
            set bisQueueStarted $::QUEISNOTSTARTED
         }
         return $bisQueueStarted

	}

    # @Method(internal): ::xQue::generateQueControl(sProcessPrefix) - builds the names of the process thread semaphores
    proc generateQueControl {sProcessPrefix} {
         set ::xQue::xCtrlID [::xHash::createUniqueThreadID "$sProcessPrefix" 1 0]
         append ::xQue::xStart [file join "$::sControl" "$::xQue::xCtrlID"] ".start"
         append ::xQue::xStop  [file join "$::sControl" "$::xQue::xCtrlID"] ".stop"
         append ::xQue::xPause [file join "$::sControl" "$::xQue::xCtrlID"] ".pause"
         return $::xQue::xCtrlID
    }

    namespace export xStartQueSemaphore;
    namespace export xStopQueSemaphore;
    namespace export xPauseQueSemaphore;
	namespace export isQueueStarted;

} ; #~endNamespace(xQue)


namespace eval xJob {

	# @Method(global): ::xQue::getJob() - searches the Staging IN box to locate PLM Object Portfolio folders, validates job structure, returns JOBGOTJOB + sets xJob if job, or JOBNOJOB in no job to process
    proc getJob {} {
         set bgetJob $::JOBNOJOBRDY
         if {[info vars ::xQue::xJob] == "::xQue::xJob"} {
            #unset ::xQue::xJob
         }
         set ::xQue::xJob(STATUS) $::JOBNOJOB
         foreach pJob [::xUtil::listDir  "$::sIN"] {
                 ::xUtil::dbgMsg "$pJob"
                 if  {[::xJob::isJobReady "$pJob"] == $::JOBISREADY } {

                     if {[::xJob::isJobLocked "$pJob"] == $::JOBNOTLOCKED} {

                         if  {[::xJob::getJobParts "$pJob"] ==  $::JOBGOTJOB } {
                               ::xUtil::dbgMsg "Job:\n[array get ::xQue::xJob]"
                               #~ Allocate the job to the queue, break the loop, and return
                               if {[::xJob::lockJob "$pJob"] == $::JOBISLOCKED} {

                                     set bgetJob $::JOBSUCCESS
                                     break;
                               } else {
                                   ::xUtil::dbgMsg "Job $pJob: unable to LOCK job"
                                   set bgetJob $::JOBFAILED
                               }
                         } else {
                             ::xUtil::dbgMsg "Job $pJob: No JOB in queue"
                             set bgetJob $::JOBNOJOBRDY
                         }
                   } else {
                      ::xUtil::dbgMsg "is already locked by another process: $pJob"
                      set bgetJob $::JOBALREADYLOCKED
                   }
              } else {
                 ::xUtil::dbgMsg "is not ready: $pJob"
                 set bgetJob $::JOBFAILED
              }
         }
         return $bgetJob
    }

	# @Method(internal): ::xJob::moveJobToArchive(sJob) - if the job sucessfully completed, now move it from IN folder to ARCHIVE folder, return JOBSUCCESS/JOBERROR
    proc moveJobToArchive {sJob} {
         set bmoveJobToArchive $::FALSE
         set tgtFile $::sArchive
         if {[::xUtil::moveFile $sJob $tgtFile] == $::TRUE} {
             set bmoveJobToArchive $::TRUE
         } else {
             set bmoveJobToArchive $::ERROR
         }
         return $bmoveJobToArchive
    }

	# @Method(internal): ::xJob::moveJobToError(sJob) - if the job failed validation at levels 1/2/3, now move it from IN folder to ERROR folder, return JOBFAILED/JOBERROR
    proc moveJobToError {sJob} {
         set bmoveJobToError $::FALSE
         set tgtFile $::sError
         if {[::xUtil::moveFile $sJob $tgtFile] == $::TRUE} {
             set bmoveJobToError $::TRUE
         } else {
             set bmoveJobToError $::ERROR
         }
         return $bmoveJobToError
    }

	# @Method(internal): ::xJob::getJobParts(sJob) - iterate on all files in IN/sJob, parse sJob file info, verify that at least one is a FILE and is XML
    proc getJobParts {sJob} {
         set ::xQue::xJob(STATUS) $::JOBNOJOB
         foreach iJobParts [::xUtil::listDir "$sJob"] {
                 array set xJobPartInfo [::xUtil::fileInfo "$iJobParts"]
                 set ::xQue::xJob([lindex [array get xJobPartInfo KIND] 1])  [array get xJobPartInfo]
                 if {[lindex [array get xJobPartInfo TYPE] 1] == "FILE" &&  [lindex [array get xJobPartInfo KIND] 1] == "XML"} {
                    set ::xQue::xJob(STATUS) $::JOBGOTJOB
					break;
                 }
         }
         return [lindex [array get ::xQue::xJob STATUS] 1]
    }

    proc lockJob {sJob} {
         set blockJob $::JOBNOTLOCKED
         set sJobSema [file join "$sJob" $::xSEMA(LOCKED)]
         if {[file exists "$sJobSema"] == 1} {
             set blockJob $::JOBOVERLOCKED
         } else {
             append msg "$::xQue::xCtrlID" "\n" [::xHash::getUniqueThreadInfo $::xQue::xCtrlID]
			 set x [::xUtil::writeFile "$::xQue::xCtrlID"  $sJobSema ]
             set blockJob $::JOBISLOCKED
         }
         return $blockJob
    }

    proc isJobLocked {sJob} {
         set bisJobLocked $::JOBNOTLOCKED
         set sJobSema [file join "$sJob" $::xSEMA(LOCKED)]
         if {[file exists "$sJobSema"] == 1} {
             set bisJobLocked $::JOBISLOCKED
         }
         return $bisJobLocked
    }

    proc isJobReady {sJob} {
         set bIsJobReady $::JOBNOTREADY
         set sJobSema [file join "$sJob" $::xSEMA(READY) ]
         if {[file exists "$sJobSema"] == 1} {
             set bIsJobReady $::JOBISREADY
         }
         return $bIsJobReady
    }

    #~ Job/Import Validation:
    #~   Pre-Import Validation:
    #~     This is Level 1 - RDY semaphore and XML file present in "PLM Object Portfolio" container folder in export/import staging area
    proc isJobValid {sJob} {
         set bisJobValid $::FALSE
         set sJobSema [file join "$sJob" "RDY.sema"]
		 set sJobSent [file join "$sJob" "SNT.sema"]
         if {[file exists "$sJobSema"] == 1 || [file exists "$sJobSent"] == 1 } {
             array set xJobParts [getJobParts "$sJob"]
             if {$xJobParts(STATUS) == $::JOBGOTJOB} {
                set bisJobValid $::TRUE
             }
         }
         return $bisJobValid
    }

    set x [::xQue::xInit]

    namespace export getJob;
    namespace export isJobReady;
    namespace export isJobValid;

} ; #~endNamespace(xJob)

namespace eval xJobQueueMgmt {

	proc callXmlObjProcessing {sXML} {
		 #~ this is a stub
		 ::xUtil::dbgMsg "XML Job: $sXML"

			cd [file dirname $sXML]

			append  ::XMLOBJLOG [file join [file dirname $sXML] [file rootname [file tail $sXML]]] ".log"
			append  ::XMLOBJDON [file join [file dirname $sXML] "DON.sema"]
			append  ::XMLOBJERR [file join [file dirname $sXML] "ERR.sema"]

			::xUtil::dbgMsg "calling xImportXMLObject $sXML"

		  if {[::xmlBusinessObject::xImportXMLObject "$sXML"] == $::TRUE} {
		  	  return $::TRUE
		  } else {
		  	  return $::ERROR
		  }

	}

	proc xJobQueueMgmt {} {
		
		if {[::xQue::isQueueStarted] == $::QUEISNOTSTARTED} {
			if {[::xQue::xStartQueSemaphore] == $::TRUE} { 
				::xUtil::dbgMsg "NOTIFICATION:: Queue started:\n\tQueue Hash=$::xQue::xCtrlID \n\tQueue Statistics: [::xHash::getUniqueThreadInfo $::xQue::xCtrlID] "
					while {[::xQue::isQueueStarted] == $::QUEISSTARTED} {
						if {[::xQue::isQueueStarted] != $::QUEISPAUSED} {
							::xJob::getJob
								if {$::xQue::xJob(STATUS) == $::JOBGOTJOB} {
								   ::xUtil::dbgMsg "Processing Job: [array get ::xQue::xJob]"

								   #~ call XML tree processing with the XML object
								   array set XML [lindex [array get ::xQue::xJob XML] 1]
								   ::xUtil::dbgMsg "Job = [array get XML]"

								   ::xJobQueueMgmt::callXmlObjProcessing [lindex [array get XML NAME] 1]

								} else {
								   after 30000
								   puts "... fetching jobs ..."
								}
						} else {
							after 30000
							puts "WARNING:: Queue Paused:\n\tQueue Hash=$::xQue::xCtrlID \n\tQueue Statistics: [::xHash::getUniqueThreadInfo $::xQue::xCtrlID] "
						}
					}
			} else {
				puts "ERROR:: Queue could not be started: [::xHash::getUniqueThreadInfo $::xQue::xCtrlID] "
				exit $::ERROR
			}
		}
	}


} ; #~endNamespace(xJobQueueMgmt)

