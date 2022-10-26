# @PROGDOC: xmlBusinessObject Object Implementations
# @Namespace/Class = xmlBusinessObject
# @Methods =
# @Properties =
# @Program = xmlBusinessObject_v17.lib.tcl
# @Version  = 17.0
# @Synopsis = implementation support library
# @Purpose = to provide methods/properties for reading and parsing an XML object from a foreign PLM, verifying the parameters, structuring BusinessObject properties and importing the data into 3DX
# @Implementation = source xmlBusinessObject.lib.tcl
# @Package = package require xmlBusinessObject;
# @Object = ::xmlBusinessObject - XML DB related functions

###############################################################################
package provide xmlBusinessObject

#set LOGPATH  "C:/root/tmp/staging/in/Drawings_101A11_BL/Drawings_101A11_BL.log"


#if 0 {
#~ Library Package loading
#set LIBDIR "C:/root/lib/tdom-0.9-windows-x86/tdom0.9.0"
#
#package ifneeded tdom 0.9.0 \
#"load [list [file join $LIBDIR tdom090.dll]];\
#         source [list [file join $LIBDIR tdom.tcl]]"
#
#package require tdom
#}

###############################################################################

###############################################################################
#~~~ PACKAGE LEVEL GLOBAL Constants
#~ 3DX XML object definition valid TAGs for DOM Tree, Mandatory required for object creation, (1/N/X) enumeration of instance data
set 3DXKEYWD(0)  "TYPE"					; #~ Mandatory(1):  TYPE=Type
set 3DXKEYWD(1)  "NAME"					; #~ Mandatory(1):  NAME=Name
set 3DXKEYWD(2)  "REVISION"				; #~ Mandatory(1):  REVISION=Rev
set 3DXKEYWD(3)  "OWNER"				; #~ Mandatory(1):  OWNER=Owner
set 3DXKEYWD(4)  "ORIGINATED"			; #~ Optional(1):   ORIGINATED=Origin Date
set 3DXKEYWD(5)  "MODIFIED"				; #~ Optional(1):   MODIFIED=Modified date
set 3DXKEYWD(6)  "VAULT"				; #~ Mandatory(1):  VAULT=Object Vault
set 3DXKEYWD(7)  "DESCRIPTION"			; #~ Optional(1):   DESCRIPTION=Object Description
set 3DXKEYWD(8)  "POLICY"				; #~ Mandatory(1):  POLICY=Object policy
set 3DXKEYWD(9)  "CURRENT"				; #~ Optional(1):   CURRENT_STATE=Object Current State
set 3DXKEYWD(10) "RELATIONSHIPS"		; #~ Optional(N):   RELATIONSHIP=(Type|Name|Revision|Direction|RelationshipName)
set 3DXKEYWD(11) "CLASSIFICATION"		; #~ Optional(1):   CLASSIFICATION=(ClassificationAttribute=AttributeRangeValue)|(INTERFACE=InterfaceName)
set 3DXKEYWD(12) "ATTRIBUTE"			; #~ Optional(X):   ATTRIBUTE=(AttributeName=AttributeValue)|(AttributeName=AttributeValue)|(...)
set 3DXKEYWD(13) "FILE"					; #~ Optional(N):   FILE=FormatName@FilePath
set 3DXKEYWD(14) "HISTORY"				; #~ Optional(N):   HISTORY=EventType|Prose
set 3DXKEYWD(15) "ORGANIZATION"			; #~ Optional(1):   ORG=Organization|Project
set 3DXKEYWD(16) "PROJECT"				; #~ Optional(1):   ORG=Organization|Project
set 3DXKEYWD(17) "DOV"					; #~ Optional(1):   DOV=Direct Ownership Vector Username
set 3DXKEYWD(18) "IOV"					; #~ Optional(1):   IOV=Type|Name|Rev of Object to inherit permissions from
set 3DXKEYWD(19) "WORKSPACE"			; #~ Optional(1):   WORKSPACE=Workspace object name
set 3DXKEYWD(20) "COLLABORATIVESPACE"	; #~ Optional(1):   COLLABORATIVESPACE=PnOProject object name
set 3DXKEYWD(21) "CONNECTION"			;
set 3DXKEYWD(22) "FOLDER"				;
set 3DXKEYWD(23) "INTERFACE"			;
set 3DXKEYWD(24) "ORIGINATOR"			;
set 3DXKEYWD(25) "LATESTVERSION"		;
set 3DXKEYWD(26) "NEXTREV"				;
set 3DXKEYWD(27) "PREVREV"				;
set 3DXKEYWD(28) "VERSIONPREFIX"		;

#~ Minimum Schema required to validate an object definition at LEVEL 2
set MINSCHEMA [list TYPE NAME REVISION OWNER VAULT POLICY]

#~ 3DX MQL command headers
set 3DXCMD(CREATE)  "add     businessobject "
set 3DXCMD(MODIFY)  "modify  businessobject "
set 3DXCMD(CHECKIN) "checkin businessobject "
set 3DXCMD(PROMOTE) "promote businessobject "
set 3DXCMD(CONNECT) "connect businessobject "

#~ Log event headers
set HISTEVENT(0)  "MIGRATION.CREATE"
set HISTEVENT(1)  "MIGRATION.UPDATE"
set HISTEVENT(2)  "MIGRATION.CHECKIN"
set HISTEVENT(3)  "MIGRATION.CONNECT"
set HISTEVENT(99) "MIGRATION.ERROR"
###############################################################################


# @NAMESPACE::xmlBusinessObject - implements methods for parsing an XML DOM tree, extracting 3DX Business properties, and calling BO create/modify/checkin/connect functions
namespace eval xmlBusinessObject {

			# @Method(internal): ::xmlBusinessObject::xCreateBusinessObject(xID) - takes in-memory object xID, references standard properties, constructs params to create 3DX Businessobject, optional update to object INTERFACE based on CLASSIFICATION tag
			proc xCreateBusinessObject {xID} {
				set CMD "CREATE"
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]
				set sVault   [lindex [array get ::xmlBusinessObject::${xID} VAULT] 1]
				set sPolicy  [lindex [array get ::xmlBusinessObject::${xID} POLICY] 1]
				set sOwner   [lindex [array get ::xmlBusinessObject::${xID} OWNER] 1]
				set sCurrent   [lindex [array get ::xmlBusinessObject::${xID} CURRENT] 1]
				if {[::xUtil::isNull "$sOwner"] == $::TRUE} {
					set sOwner "$::DEFAULTOWNER"
				}
				puts "==================== USING OBJECT NATIVENAME - xCreateBusinessObject() ===================="
				lappend ::NAMEMAPREGISTRY "$sName=$sName"
				array set xObjStatus [::xBO::createBusinessObject  "$sType" "$sName" "$sRev" "$sPolicy" "$sVault" "$sOwner" "$sCurrent"]
				set iObjStatus $xObjStatus(0)
				set oID        $xObjStatus(OID)
				#~now update gapLegacyPDMIdentifier with legacy name from XML for next search
				set bLegacyPLMIDStatus [::xBO::setBOAttributeValue $oID "gapLegacyPDMIdentifier" "$sName"]

				::xUtil::log  $::HISTEVENT(0) "createBusinessObject $sType $sName $sRev $sPolicy $sVault $sOwner "
				#~ set OID array element from creating the Business Object for later use
				set ::xmlBusinessObject::${xID}(OID) [lindex [array get xObjStatus OID] 1]

				return [lindex [array get xObjStatus 0] 1]
			}

			proc xCreateBusinessObject2 {xID} {
				set bxCreateBusinessObject2 $::FALSE
				puts "xCreateBusinessObject2 $xID"
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]
				set sVault   [lindex [array get ::xmlBusinessObject::${xID} VAULT] 1]
				set sPolicy  [lindex [array get ::xmlBusinessObject::${xID} POLICY] 1]
				set sOwner   [lindex [array get ::xmlBusinessObject::${xID} OWNER] 1]
				set sCurrent   [lindex [array get ::xmlBusinessObject::${xID} CURRENT] 1]
				if {[::xUtil::isNull "$sOwner"] == $::TRUE} {
					set sOwner "$::DEFAULTOWNER"
				}
				set sInclusionType   "$sType"
				set sInclusionPolicy "$sPolicy"
				set i1 [lsearch $::AUTONAMERTYPEINCLUSIONLIST "$sInclusionType"]
				set e1 [lsearch $::AUTONAMERTYPEEXCLUSIONLIST "$sInclusionType"]
				set i2 [lsearch $::AUTONAMERPOLICYINCLUSIONLIST "$sInclusionPolicy"]
				set e2 [lsearch $::AUTONAMERPOLICYEXCLUSIONLIST "$sInclusionPolicy"]

				puts "xCreateBusinessObject2 from XML Obj: $sType $sName $sRev"

				#~ findOtherObjectsByLegacyName retuns list of TYPE NAME REV OID in array
				array set xOtherBusinessObjects [::xBO::findOtherObjectsByLegacyName "$sType" "$sName" "$sPolicy"]
				puts "xOtherBusinessObjects = [array get xOtherBusinessObjects]"
				
				set bOtherBusinessObjectsStatus [lindex [array get xOtherBusinessObjects 0] 1]

				if {$bOtherBusinessObjectsStatus == $::ERROR} {
					set bxCreateBusinessObject2 $::ERROR
				} elseif {$bOtherBusinessObjectsStatus == $::FALSE} {
						#~ No object exists, therefore create a NEW OBJECT
						if {[expr $i1 & $i2] >= 0 && [expr $e1 & $e2] < 0} {
							#~ use autonamer
							puts "==================== USING AUTONAMERTYPEINCLUSIONLIST OBJECT ===================="
							if {$::OOTB == 0} {
								#~ RZ Custom Autonamer
								array set xNewObj [::xAutonamer::autoNameGenerator "$sType" "$sName" "$sRev"]
								if {$xNewObj(0) == $::TRUE} {
									set sNewName $xNewObj(NAME)
									array set xObjStatus [::xBO::createBusinessObject  "$sType" "$sNewName" "$sRev" "$sPolicy" "$sVault" "$sOwner" "$sCurrent"]
									set iObjStatus $xObjStatus(0)
									if {$iObjStatus == $::TRUE} {
										puts "createBusinessObject() - $sType $sNewName $sRev"
										set bxCreateBusinessObject2 $::TRUE
										set oID        $xObjStatus(OID)
										set ::xmlBusinessObject::${xID}(OID) $xObjStatus(OID)
										set ::xmlBusinessObject::${xID}(NAME) "$sNewName" 
										#~now update gapLegacyPDMIdentifier with legacy name from XML for next search
										lappend ::NAMEMAPREGISTRY "$sName=$sNewName"
										set bLegacyPLMIDStatus [::xBO::setBOAttributeValue $oID "gapLegacyPDMIdentifier" "$sName"]
									} else {
										#~ error creating object
										set xCreateBusinessObject(0) [::xUtil::errMsg 16 "could not create AUTONAMED: $sType $sNewName ($sName) $sRev $sPolicy $sVault $sOwner"]
										return $::ERROR
									}
								} else {
									#~ error returned by autonamer
									set xCreateBusinessObject(0) [::xUtil::errMsg 16 "AUTONAMER ERROR: $sType $sNewName ($sName) $sRev $sPolicy $sVault $sOwner"]
									return $::ERROR
								}
							} else {
								#~ Dassault OOTB Autonamer
								set lNewObj [::xOOTB::eServiceNameGeneratorProc  "$sType" "$sRev" "$sPolicy" "$sVault" "$sType" "FALSE" "$sVault" "FALSE" "FALSE" ]
								lappend ::NAMEMAPREGISTRY "$sName=[lindex $lNewObj 2]"
								set ::xmlBusinessObject::${xID}(OID)		[lindex $lNewObj 0]
								set ::xmlBusinessObject::${xID}(TYPE)		[lindex $lNewObj 1]
								set ::xmlBusinessObject::${xID}(NAME)		[lindex $lNewObj 2]
								set ::xmlBusinessObject::${xID}(REVISION)	[lindex $lNewObj 3]
								set ::xmlBusinessObject::${xID}(VAULT)		[lindex $lNewObj 4]
								::xUtil::dbgMsg "No XML file, Autonamer created a NEW Object: $lNewObj"
								#~now update gapLegacyPDMIdentifier with legacy name from XML for next search
								lappend ::NAMEMAPREGISTRY "$sName=[lindex $lNewObj 2]"
								set oID [lindex $lNewObj 0]
								set bLegacyPLMIDStatus [::xBO::setBOAttributeValue $oID "gapLegacyPDMIdentifier" "$sName"]
							}
						
						} else {
							#~ use XML object definition NAME
							puts "==================== USING OBJECT NATIVENAME ===================="
							#if {[lsearch -nocase $::AUTONAMERPOLICYEXCLUSIONLIST "$sPolicy"] == -1} {
							#	set xFile [lindex [array get ::xmlBusinessObject::${xID} FILE] 1]
							#	set sNewFileName [file tail "$sNewFilepath"] 
							#	set sName [join [list "$sName" "$sNewFileName"] _]
							#	set ::xmlBusinessObject::${xID}(NAME) "$sName"
							#}
							array set xObjStatus [::xBO::createBusinessObject  "$sType" "$sName" "$sRev" "$sPolicy" "$sVault" "$sOwner" "$sCurrent"]
							set bxCreateBusinessObject2 $::TRUE

							set iObjStatus $xObjStatus(0)
							if {$iObjStatus == $::TRUE} {
								set oID        $xObjStatus(OID)
								set ::xmlBusinessObject::${xID}(OID) $xObjStatus(OID)
								#~now update gapLegacyPDMIdentifier with legacy name from XML for next search
								lappend ::NAMEMAPREGISTRY "$sName=$sName"
								set bLegacyPLMIDStatus [::xBO::setBOAttributeValue $oID "gapLegacyPDMIdentifier" "$sName"]
							} else {
								set xCreateBusinessObject(0) [::xUtil::errMsg 16 "OBJECT NATIVENAME ERROR: $sType $sName $sRev $sPolicy $sVault $sOwner"]
								return $::ERROR
							}
						}
				} else {
						#
						#~ the OBJECT of some rev exists, therefore REVISE BusinessObject/Create update REV CHAIN
						#

						#~ get object name and use to create Businessobject then fix revision chain
						#~ more than one object may be returned so evaluate each
						#~ if the same REV shows up, then the autoname+rev has been used, this should ERROR and EXIT
						set lTYPE [lindex [array get xOtherBusinessObjects TYPE] 1]
						set lNAME [lindex [array get xOtherBusinessObjects NAME] 1]
						set lREV  [lindex [array get xOtherBusinessObjects REV ] 1]
						set lOID  [lindex [array get xOtherBusinessObjects OID ] 1]

						set iNumObjs [llength [lindex [array get xOtherBusinessObjects TYPE] 1]]

						#~ sType will be the same, as one search param is Type, so other Types of same name excluded
						set s1Type [lindex $lTYPE 0]
						
						#~ sName and s1Name will not be the same
						#~ sName = legacy name of Object
						#~ s1Name = possible autoname found or could be legacy name - either way cannot assume same
						set s1Name [lindex $lNAME 0]
						#~ get last REV in list of Obj revs of all found Objs returned by findOtherObjectsByLegacyName()
						#~ not alpah sort order, must be sorted where so that last rev is highest rev
						#set s1Rev [lindex $lREV end]
							
						if {[string compare -nocase "$sType" "$s1Type"] == 0} {
							#~ Types should be the same
								#~ search list of all know REV and see if sRev (new one) is in iT
								#~ if it IS then the Proposed Obj Exists, do no recreate
								if {[lsearch $lREV "$sRev"] != -1} {
										
									#~ this is an error to create the obj because it already exists
									#~ this could be changed to a WARNING, to allow for object updates
									#~ where iterative object metadata or files come across
									#~ business decision

									set bxCreateBusinessObject2 [::xUtil::errMsg 16 "BusinessObject already exists: Type $sType = $s1Type - Name $sName = $s1Name - Rev $sRev is in list of existing objects: $lREV"]
									::xUtil::dbgMsg "DBGERR::iOtherBusinessObjects - BusinessObject already exists: Type $sType = $s1Type - Name $sName = $s1Name - Rev $sRev is in list of existing objects: $lREV"
									return $::ERROR

								} else {
										
									#~ the TYPE and Obj Name are the same, but REV is different, so create obj

									set sPrevRev [lindex [array get ::xmlBusinessObject::${xID} PREVREV] 1]
									set sNextRev [lindex [array get ::xmlBusinessObject::${xID} NEXTREV] 1]
											
									::xUtil::dbgMsg "iOtherBusinessObjects - calculated sPrevRev/sNextRev = $sPrevRev / $sNextRev"

									#~ use XML object definition NAME
									puts "==================== USING OBJECT NATIVENAME ===================="
									array set xObjStatus [::xBO::createBusinessObject  "$sType" "$s1Name" "$sRev" "$sPolicy" "$sVault" "$sOwner" "$sCurrent"]
									set iObjStatus $xObjStatus(0)
									if {$iObjStatus == $::TRUE} {
										set oID        $xObjStatus(OID)
										set ::xmlBusinessObject::${xID}(OID) $xObjStatus(OID)

										set bxCreateBusinessObject2 $::TRUE
										#~ update the Name Registry so taht when Versions are created they are attached to correct obj
										lappend ::NAMEMAPREGISTRY "$sName=$s1Name"

										#~now update gapLegacyPDMIdentifier with legacy name from XML for next search
										set bLegacyPLMIDStatus [::xBO::setBOAttributeValue $oID "gapLegacyPDMIdentifier" "$sName"]

										::xUtil::dbgMsg "iOtherBusinessObjects - Create New Rev of Object: $sType $s1Name $sRev $sPolicy $sVault $sOwner : [array get xObjStatus]"
										::xUtil::log  $::HISTEVENT(0) "createBusinessObject $sType $sName $sRev $sPolicy $sVault $sOwner "

										set x [::xBO::updateObjectRevisionSequence2 "$sType" "$s1Name" "$sRev" "$sPrevRev" "$sNextRev"]
									} else {
										set bxCreateBusinessObject2 [::xUtil::errMsg 16 "xCreateBusinessObject2() returned errors - ::xBO::createBusinessObject()   $sType $s1Name $sRev $sPolicy $sVault $sOwner $sCurrent"]
										return $::ERROR 
									}
								}

						} else {
							#~ TYPEs are different, this is a bogus error and should not occure
							::xUtil::dbgMsg "The types are different: $sType .neq. $s1Type"
							return $::ERROR 
						}
				}; #~ endIF
				return $bxCreateBusinessObject2
				#return $::TRUE
			}; #~endProc

			proc xClassifyBusinessObject2 {xID} {
				set bClassifyBusinessObject $::FALSE
				set CMD "MODIFY"
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sClassification [lindex [array get ::xmlBusinessObject::${xID} CLASSIFICATION] 1]
				if {[::xUtil::isNull "$sClassification"] != $::TRUE} {
					set bClassifyBusinessObject  [::xBO::classifyBusinessObject $oID "$sClassification"]
					if {$bClassifyBusinessObject == $::ERROR } {
						set bClassifyBusinessObject [::xUtil::errMsg 41 "Failed to Classify object: $sType $sName $sRev $sClassification"]
					}
					::xUtil::log  $::HISTEVENT(1) "xClassifyBusinessObject $sType $sName $sRev $sClassification "
				} else {
					#~ Object has no classification, not an error
					set bClassifyBusinessObject $::TRUE
				}
				return $bClassifyBusinessObject
			}

			proc xClassifyBusinessObject {xID} {
				set bClassifyBusinessObject $::FALSE
				set CMD "MODIFY"
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sClassification [lindex [array get ::xmlBusinessObject::${xID} CLASSIFICATION] 1]
				if {[::xUtil::isNull "$sClassification"] != $::TRUE} {
					foreach iClassification [split "$sClassification" |] {
						set bClassifyBusinessObject  [::xBO::classifyBusinessObject $oID "$iClassification"]
						if {$bClassifyBusinessObject == $::ERROR } {
							set bClassifyBusinessObject [::xUtil::errMsg 41 "Failed to Classify object: $sType $sName $sRev $iClassification"]
						}
						::xUtil::log  $::HISTEVENT(1) "xClassifyBusinessObject $sType $sName $sRev $iClassification "
					}
				} else {
					#~ Object has no classification, not an error
					set bClassifyBusinessObject $::TRUE
				}
				return $bClassifyBusinessObject
			}

			proc xAddInterfaceBusinessObject {xID} {
				set xxAddInterfaceBusinessObject $::FALSE
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sInterface [lindex [array get ::xmlBusinessObject::${xID} INTERFACE] 1]
				::xUtil::dbgMsg "xAddInterfaceBusinessObject() - Interface = $sInterface"
				if {[::xUtil::isNull "$sInterface"] == $::FALSE} {
					array set xObjStatus [::xBO::addInterfaceBusinessObject $oID "$sInterface"]
					set xxAddInterfaceBusinessObject [lindex [array get xObjStatus 0] 1]
					::xUtil::log  $::HISTEVENT(1) "xAddInterfaceBusinessObject $sType $sName $sRev $sInterface "
				} else {
					#~ Object has no Interface, not an error
					set xxAddInterfaceBusinessObject $::TRUE
				}
				return $xxAddInterfaceBusinessObject
			}

          
			proc xUpdateBusinessObjectDescription {xID} {
				set bxUpdateBusinessObjectDescription $::FALSE
               
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sDesc    [lindex [array get ::xmlBusinessObject::${xID} DESCRIPTION] 1]
				puts "xUpdateBusinessObjectDescription()- $sDesc"
				if {[::xUtil::isNull "$sDesc"] == $::FALSE } {
					set x [::xBO::updateBusinessObjectDescription $oID $sDesc]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectDescription $sType $sName $sRev $sDesc -- results = $bxUpdateBusinessObjectDescription"
					set bxUpdateBusinessObjectDescription $::TRUE
				} else {
					#~ obj has not attributes, not an error
					set bxUpdateBusinessObjectDescription $::TRUE
				}
				return $bxUpdateBusinessObjectDescription
			}

			proc xUpdateBusinessObjectOriginator {xID} {
				set bxUpdateBusinessObjectOriginator $::FALSE
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				#~ add additional properties below
				set sOriginator [lindex [array get ::xmlBusinessObject::${xID} ORIGINATOR] 1]
				if {[::xUtil::isNull "$sOriginator"] == $::FALSE } {
					set x [::xBO::updateBusinessObjectOriginator $oID "$sOriginator"]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectOriginator() $sType $sName $sRev $sOriginator -- results = $bxUpdateBusinessObjectOriginator"
					set bxUpdateBusinessObjectOriginator $::TRUE
				} else {
					#~ obj has not attributes, not an error
					set bxUpdateBusinessObjectOriginator $::TRUE
				}
				return $bxUpdateBusinessObjectOriginator
			}

			proc xUpdateBusinessObjectOriginatedDate {xID} {
				set bxUpdateBusinessObjectOriginatedDate $::FALSE
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				#~ add additional properties below
				set sOriginated [lindex [array get ::xmlBusinessObject::${xID} ORIGINATED] 1]
				if {[::xUtil::isNull "$sOriginated"] == $::FALSE } {
					set x [::xBO::updateBusinessObjectOriginatedDate $oID "$sOriginated"]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectOriginatedDate() $sType $sName $sRev $sOriginated -- results = $bxUpdateBusinessObjectOriginatedDate"
					set bxUpdateBusinessObjectOriginatedDate $::TRUE
				} else {
					#~ obj has not attributes, not an error
					set bxUpdateBusinessObjectOriginatedDate $::TRUE
				}
				return $bxUpdateBusinessObjectOriginatedDate
			}

			proc xUpdateBusinessObjectModifiedDate {xID} {
				set bxUpdateBusinessObjectModifiedDate $::FALSE
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				#~ add additional properties below
				set sModified [lindex [array get ::xmlBusinessObject::${xID} MODIFIED] 1]
				if {[::xUtil::isNull "$sModified"] == $::FALSE } {
					set x [::xBO::updateBusinessObjectModifiedDate $oID "$sModified"]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectOriginatedDate() $sType $sName $sRev $sModified -- results = $bxUpdateBusinessObjectModifiedDate"
					set bxUpdateBusinessObjectModifiedDate $::TRUE
				} else {
					#~ obj has not attributes, not an error
					set bxUpdateBusinessObjectModifiedDate $::TRUE
				}
				return $bxUpdateBusinessObjectModifiedDate
			}


		  
			proc xUpdateBusinessObjectProperties {xID} {
				set bxUpdateBusinessObjectProperties $::FALSE
               
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}

				#~ add additional properties below
				set sOriginated [lindex [array get ::xmlBusinessObject::${xID} ORIGINATED] 1]
				set sModified   [lindex [array get ::xmlBusinessObject::${xID} MODIFIED]   1]
				set sOriginator [lindex [array get ::xmlBusinessObject::${xID} ORIGINATOR] 1]

				if {[::xUtil::isNull "$sOriginated"] == $::FALSE } {
					puts "xUpdateBusinessObjectProperties()- originated= $sOriginated"
					set x [::xBO::updateBusinessObjectProperty $oID originated "$sOriginated"]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectProperties $sType $sName $sRev -- results = $x"
				} else {
					#~ obj has not attributes, not an error
					set x $::TRUE
				}

				if {[::xUtil::isNull "$sModified"] == $::FALSE } {
					puts "xUpdateBusinessObjectProperties()- modified= $sModified"
					set y [::xBO::updateBusinessObjectProperty $oID modified   "$sModified"  ]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectProperties $sType $sName $sRev -- results = $y"
				} else {
					#~ obj has not attributes, not an error
					set y $::TRUE
				}

				if {[::xUtil::isNull "$sOriginator"] == $::FALSE } {
					puts "xUpdateBusinessObjectProperties()- Originator= $sOriginator"
					set z [::xBO::updateBusinessObjectProperty $oID Originator "$sOriginator"]
					::xUtil::log  $::HISTEVENT(1) "xUpdateBusinessObjectProperties $sType $sName $sRev -- results = $y"
				} else {
					#~ obj has not attributes, not an error
					set z $::TRUE
				}
				set bxUpdateBusinessObjectProperties [expr $x & $y & $z]

				return $bxUpdateBusinessObjectProperties
			}

		  
			# @Method(internal): ::xmlBusinessObject::xUpdateBusinessObjectAttributes(xID) - takes in-memory object xID, references standard properties, constructs params to update object attributes
			# @  format: attribute:F_TYPE=tiff_5_0|attribute:VLT_SPACE=MTC_vault|attribute:VLT_OBJID=...
			proc xUpdateBusinessObjectAttributes {xID} {
				set bxUpdateBusinessObjectAttributes $::FALSE
               
				set oID		 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set xAttr    [lindex [array get ::xmlBusinessObject::${xID} ATTRIBUTE] 1]
				#puts "xAttr- $xAttr"
				if {[::xUtil::isNull "$xAttr"] == $::FALSE } {
					set lAttributeNameValuePairs [split "$xAttr" $::cFLDDELIM]
					array set xObjStatus [::xBO::updateBusinessObjectAttributes $oID $lAttributeNameValuePairs]
					set bxUpdateBusinessObjectAttributes [lindex [array get xObjStatus 0] 1]
					::xUtil::log  $::HISTEVENT(1) "updateBusinessObjectAttributes $sType $sName $sRev $lAttributeNameValuePairs -- results = [array get bxUpdateBusinessObjectAttributes]"
				} else {
					#~ obj has not attributes, not an error
					set bxUpdateBusinessObjectAttributes $::TRUE
				}
				return $bxUpdateBusinessObjectAttributes
			}

			proc xSetCollaborativeSpace {xID} {
				set bxSetCollaborativeSpace $::FALSE
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sCollaborativeSpace [lindex [array get ::xmlBusinessObject::${xID} COLLABORATIVESPACE] 1]
				puts "sCollaborativeSpace: $sCollaborativeSpace"
				if {[::xUtil::isNull "$sCollaborativeSpace"] == $::FALSE } {
					array set xObjStatus [::xBO::updateCollaborativeSpace $oID $sCollaborativeSpace]
					::xUtil::log  $::HISTEVENT(1) "bxSetCollaborativeSpace() $sType $sName $sRev $sCollaborativeSpace -- results = [array get xObjStatus]"
					set bxSetCollaborativeSpace [lindex [array get xObjStatus 0] 1]
					::xUtil::dbgMsg "xSetCollaborativeSpace() $sType $sName $sRev $sCollaborativeSpace -- results = [array get xObjStatus]"
				} else {
					#~ obj has not COLLABORATIVESPACE, not an error
					set bxSetCollaborativeSpace $::TRUE
				}
				return $bxSetCollaborativeSpace
			}

			proc xSetOrganization {xID} {
				set bxSetOrganization $::FALSE
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType   [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName   [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev    [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sOrganization [lindex [array get ::xmlBusinessObject::${xID} ORGANIZATION] 1]
				puts "sOrganization: $sOrganization"
				if {[::xUtil::isNull "$sOrganization"] == $::FALSE } {
					set bxSetOrganization [::xBO::updateOrganization $oID $sOrganization]
					::xUtil::log  $::HISTEVENT(1) "xSetOrganization() $sType $sName $sRev $sOrganization"
				} else {
					#~ obj has not COLLABORATIVESPACE, not an error
					set bxSetOrganization $::TRUE
				}
				return $bxSetOrganization
			}

			proc xAttachWorkspaceFolders {xID} {		  
				#~ connect bus $oID rel "Data Vaults" $Workspace
				set bxAttachWorkspace $::FALSE
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set sWorkspace [lindex [array get ::xmlBusinessObject::${xID} WORKSPACE] 1]
				puts "sWorkspace: $sWorkspace"
				set sWorkspaceFolderPath [lindex [array get ::xmlBusinessObject::${xID} FOLDER] 1]
				puts "sWorkspaceFolderPath: $sWorkspaceFolderPath"
				
				if {[::xUtil::isNull "$sWorkspace"] == $::FALSE } {
					set bxAttachWorkspace [::xBO::attachWorkspaceFolders2 $oID $sWorkspace $sWorkspaceFolderPath]
					::xUtil::log  $::HISTEVENT(1) "xAttachWorkspace() $sType $sName $sRev Workspace $sWorkspace FolderPath $sWorkspaceFolderPath -- results = [array get bxSetCollaborativeSpace]"
				} else {
					#~ obj has not workspace or folder path, not an error
					set bxAttachWorkspace $::TRUE
				}
				return $bxAttachWorkspace
			}

			# @Method(internal): ::xmlBusinessObject::xCheckinBusinessObjectFiles(xID) - takes in-memory object xID, references standard properties, constructs params to checkin format@files to object
			# @  format: file:format=CAD@/root/tmp/Staging/101A11_RL1.DWG
			proc xCheckinBusinessObjectFiles {xID} {
				set bxCheckinBusinessObjectFiles $::FALSE
				set oID		[lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$oID"] == $::TRUE} {
					set oID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $oID
				}
				set xFile [lindex [array get ::xmlBusinessObject::${xID} FILE] 1]

				# Node(domNode000000ADC254B5D0).name(object).ObjParam(domNode000000ADC254B4B0).name(LatestVersion) = -%3A19
				set sLatestVersion  [lindex [array get ::xmlBusinessObject::${xID} LATESTVERSION] 1]
					set sAttrValue4 "$sLatestVersion"
					regsub -all -- "\%7C"  "$sAttrValue4" "|"  sAttrValue3
					regsub -all -- "\%20"  "$sAttrValue3" " "  sAttrValue2
					regsub -all -- "\%0A"  "$sAttrValue2" "\n" sAttrValue1
					regsub -all -- "\%3A"  "$sAttrValue1" ":"  sAttrValue
					set sLatestVersion [ lindex [split "$sAttrValue" :] 1]
				
				# Node(domNode000000ADC254B5D0).name(object).ObjParam(domNode000000ADC254AEB0).name(VersionPrefix) = 1373_907078
				set sVersionPrefix  [lindex [array get ::xmlBusinessObject::${xID} VERSIONPREFIX] 1]
				::xUtil::dbgMsg "xCheckinBusinessObjectFiles() files to checkin: $sType $sName $sRev $xFile - sLatestVersion = $sLatestVersion and Version Prefix = $sVersionPrefix "
				
				if {[::xUtil::isNull "$xFile"] == $::FALSE } {
					foreach iFile [split $xFile |] {
						set sFormat  [lindex [split [lindex [split "$iFile" =] 1] @] 0]
						set sFile    [lindex [split [lindex [split "$iFile" =] 1] @] 1]
						puts "\n\n... checkinBusinessObject() $oID $sFormat $sFile"
						set bxCheckinBusinessObjectFiles  [::xBO::checkinBusinessObject2 "$oID" "$sFormat" "$sFile" A "$sLatestVersion" "$sVersionPrefix"]
						#set bxCheckinBusinessObjectFiles  [::xBO::checkinBusinessObject "$oID" "$sFormat" "$sFile"]
						if {$bxCheckinBusinessObjectFiles == $::ERROR} {
							set bxCheckinBusinessObjectFiles [::xUtil::errMsg 8 "xCheckinBusinessObjectFiles()  $sType $sName $sRev $sFormat $xFile"]
							#break;
						}
					}
					::xUtil::log  $::HISTEVENT(2) "xCheckinBusinessObjectFiles() $sType $sName $sRev $xFile"
				} else {
					#~ obj has not files, not an error
					set bxCheckinBusinessObjectFiles $::TRUE
				}
				return $bxCheckinBusinessObjectFiles
			}

			#~ CONNECTION etype=Hardware/ename=Desktop/erevision=A.1/relationship=VersionOf/myend=to/
			proc xConnectBusinessObjectStructure {xID} {
				set xxConnectBusinessObjectStructure $::FALSE
				set xOID	 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$xOID"] == $::TRUE} {
					set xOID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $xOID
				}
				puts "xID object: [array get ::xmlBusinessObject::${xID}]"
				::xUtil::hitAnyKey
				if {[::xUtil::isNull "[array get ::xmlBusinessObject::${xID} RELATIONSHIPS]"] == $::FALSE } {
					set xConn [lindex [array get ::xmlBusinessObject::${xID} RELATIONSHIPS] 1]
				} elseif {[::xUtil::isNull "[array get ::xmlBusinessObject::${xID} CONNECTION]"] == $::FALSE } {
					set xConn [lindex [array get ::xmlBusinessObject::${xID} CONNECTION] 1]
				} else {
					puts "obj has no connections, not an error"
					set xxConnectBusinessObjectStructure $::TRUE
					return $xxConnectBusinessObjectStructure
				}
				
				puts "xConn- $xConn"
				::xUtil::hitAnyKey

				if {[::xUtil::isNull "$xConn"] == $::FALSE } {
					set lConnectNameValuePairs [split "$xConn" $::cFLDDELIM]
					::xUtil::dbgMsg "lConnectNameValuePairs = $lConnectNameValuePairs"
					set xxConnectBusinessObjectStructure [::xBO::connectBusinessObjectStructure $xOID $lConnectNameValuePairs]
					if {$xxConnectBusinessObjectStructure == $::TRUE} {
						puts "SUCCEEDED: [mql print bus $xOID select type name revision dump |] --> $lConnectNameValuePairs"
					} else {
						#~ returned non-TRUE
						puts "FAILED: [mql print bus $xOID select type name revision dump |] --> $lConnectNameValuePairs"
					}
				} else {
					puts "obj has not connections, not an error"
					set xxConnectBusinessObjectStructure $::TRUE
				}
				return $xxConnectBusinessObjectStructure
			}
		  
			proc xConnectBusinessObjectStructure2 {xID} {
				set xxConnectBusinessObjectStructure $::FALSE
				set xOID	 [lindex [array get ::xmlBusinessObject::${xID} OID] 1]
				set sType    [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
				set sName    [lindex [array get ::xmlBusinessObject::${xID} NAME] 1]
				set sRev     [lindex [array get ::xmlBusinessObject::${xID} REVISION] 1]			   
				if {[::xUtil::isNull "$xOID"] == $::TRUE} {
					set xOID      [::xBO::getBOID "$sType" "$sName" "$sRev"]
					set ::xmlBusinessObject::${xID}(OID) $xOID
				}
				set xConn [lindex [array get ::xmlBusinessObject::${xID} RELATIONSHIPS] 1]
				::xUtil::dbgMsg "xConn- $xConn"

				if {[::xUtil::isNull "$xConn"] == $::FALSE } {
					set lConnectNameValuePairs [split "$xConn" $::cFLDDELIM]
					array set bxConnectBusinessObjectStructure [::xBO::connectBusinessObjectStructure $oID $lConnectNameValuePairs]
				   
					foreach iConnection [split [lindex [array get ::xmlBusinessObject::${xID} RELATIONSHIPS] 1] |] {
						# {connection=Document/18273498712390847901283749/1/Active}
						foreach {iT iN iR iC iE} [split [lindex [split [lindex $iConnection 0] =] 1] /]  { break; }
						set yOID     [::xBO::getBOID "$iT" "$iN" "$iR"]
						if {$yOID != $::ERR} {
							#~ the TO object does exist, connect
							if {[string toupper "$iE"] == "FROM"} {
								array set iConnStatus [::xBO::createConnection "$yOID" "$xOID" "$iC"]
								if {$iConnStatus(0) == $::TRUE} {
									#~ array index = oID of connected obj, array value = RelID of relationship returned
									array set xxConnectBusinessObjectStructure [list $yOID [array get iConnStatus oRelID]]
								}
							} elseif {[string toupper "$iE"] == "TO"} {
								array set iConnStatus [::xBO::createConnection "$xOID" "$yOID" "$iRel"]
							} else {
								set xxConnectBusinessObjectStructure(0) $::ERROR
							}
						} else {
							#~ the TO object does not yet exist - it may come later, pass with warning
							set x [::xUtil::warnMsg 100 "Parent($sType $sName $sRev) <- $iRel ($iEnd) -> Child($iType $iName $iRev)"]
						}
					}
				} else {
					set xxConnectBusinessObjectStructure(0) $::ERROR 
				}
				#~ return is status at idx(0), and 1-N (oID)RelID
				return $xxConnectBusinessObjectStructure(0)
			}

			proc xValidateXML3DXSchema {xID} {
				#~3DXKEYWD(0)
				puts "xValidateXML3DXSchema() -validating object properties:"
				if 0 {
					foreach {iTag iValue} [array get ::xmlBusinessObject::${xID}] {
						puts "...property: $iTag = $iValue"
						switch $iTag {
							"TYPE"					{ if {[string compare [mql list type  $iValue]  "$iValue"] == 0} { set xStatus(TYPE)  TRUE  } else { set xStatus(TYPE)  FALSE } }
							"OWNER"					{ if {[string compare [mql list user  $iValue]  "$iValue"] == 0} { set xStatus(OWNER) TRUE  } else { set xStatus(OWNER) FALSE } }
							"VAULT"					{ if {[string compare [mql list vault  $iValue] "$iValue"] == 0} { set xStatus(VAULT) TRUE  } else { set xStatus(VAULT) FALSE } }
							"POLICY"				{ if {[string compare [mql list policy $iValue] "$iValue"] == 0} { set xStatus(POLICY) TRUE } else { set xStatus(POLICY) FALSE} }
							"CURRENT_STATE"			{ set sPolicy [lindex [array get ::xmlBusinessObject::${xID} POLICY] 1]; if {[lsearch [split [mql print policy "$sPolicy" select state dump |] |] "$iValue"] >= 0} {set xStatus(CURRENT_STATE) TRUE} else {set xStatus(CURRENT_STATE) FALSE} }
							"CLASSIFICATION"		{ set xType [lindex [split $iValue /] 0]; set xName [lindex [split $iValue /] 1];
														foreach {yType yName yRev yoID} [split [lindex [split [mql temp query bus "$xType" "$xName" * select id dump |] \n] 0] |] { break; }
														puts "yVARS:: $yType $yName $yRev $yoID"
														if {[::xUtil::isNull "$yType"] != $::TRUE} {
															if {[string compare "$xType" "$yType"] == 0 && [string compare "$xName" "$yName"] == 0 } {set xStatus(CLASSIFICATION) TRUE} else {set xStatus(CLASSIFICATION) FALSE} 
														} else {
															set xStatus(CLASSIFICATION) FALSE
														}
													}
							"ATTRIBUTE"				{	foreach iAttr [split [lindex [array get ::xmlBusinessObject::${xID} ATTRIBUTE] 1] |] {
															if {[string compare [mql list attribute [lindex [split $iAttr =] 0]] [lindex [split $iAttr =] 0]] == 0} { set xStatus(ATTRIBUTE) TRUE } else { set xStatus(ATTRIBUTE) FALSE; break; }
														}
													}
							"FILE"					{	foreach iFileFormat [split [lindex [array get ::xmlBusinessObject::${xID} FILE] 1] |] {
															set iFormat [lindex [split [lindex [split $iFileFormat =] 1] @] 0]
															set iFile   [lindex [split [lindex [split $iFileFormat =] 1] @] 1]
															if {[string compare [mql list format "$iFormat"] "$iFormat"] == 0 && [file exists "$iFile"] ==1} {set xStatus(FILE) TRUE} else {set xStatus(FILE) FALSE; break; } 
														}
													}
							"ORGANIZATION"			{ set xStatus(ORGANIZATION)	[lindex [split [mql temp query bus Organization "$iValue" - select id dump |] |] 1] }
							"PROJECT"				{ set xStatus(PROJECT)		[lindex [split [mql temp query bus PnOProject "$iValue" - select id dump |] |] 1] }
							"WORKSPACE"				{ if {[string compare [lindex [split [mql temp query bus Workspace "$iValue" * select id dump |] |] 1] "$iValue"] == 0} { set xStatus(WORKSPACE) TRUE } else { set xStatus(WORKSPACE) FALSE } }
							"COLLABORATIVESPACE"	{ set xStatus(COLLABORATIVESPACE) [mql print bus PnOProject "$iValue" - select exists dump] }
							"RELATIONSHIPS"			{	foreach iRel [split [lindex [array get ::xmlBusinessObject::${xID} RELATIONSHIPS] 1] |] {
															if {[string compare [mql list relationship [lindex [split $iRel /] 3]] [lindex [split $iRel /] 3]] == 0} { set xStatus(RELATIONSHIPS) TRUE } else { set xStatus(RELATIONSHIPS) FALSE; break; }
														}
													}
							"FOLDER"				{	regsub -all -- "/" "$iValue" "," sNames
															set y ""
															foreach i [split [mql temp query bus "Workspace Vault" "$sNames" * select id dump |] \n] { 
																foreach {t n r id} [split $i |] { break; }
																append y "/" "$n" 
															}
															set z [string trimleft "$y" '/']
															unset y
															if {[string compare -nocase "$iValue" "$z"] == 0} {
																set xStatus(FOLDER) TRUE
															} else {
																set xStatus(FOLDER) FALSE
															}
													}
							"INTERFACE"				{ if {[string compare [mql list interface $iValue] "$iValue"] == 0} { set xStatus(INTERFACE) TRUE } else { set xStatus(INTERFACE) FALSE } }	
						}
					}
				}
				#puts "Object Validation Status: [array get xStatus]"
				#return [lsearch -exact [array get xStatus] FALSE]
				return -1
			}


			# @Method(internal): ::xmlBusinessObject::xStructureBO(xID uriObj) - takes xID (DOM object node ID) as the ID for the in memory object structure, uriObj is the URI encoded object specification. The uriObj is parsed against the global ::3DXKEYWD array for keywords, to create/update/checkin/connect the businessobject structure in 3DX
			# @  format:  type:Drawings
			# @  format:  name:101A11.TIF
			# @  format:  revision:BL
			# @  format:  owner:Batch Load
			# @  format:  created:2001-08-15
			# @  format:  modified:2006-11-28
			# @  format:  vault:eService Production
			# @  format:  description:BATCH LOADED - VERIFY INFORMATION WITH HARDCOPY OR DRAWING NUMBERS SHEET
			# @  format:  policy:xMigration
			# @  format:  state:Released
			# @  format:  classification:INTERFACE=xInterAccess
			# @  format:  attribute:checksum=226952685
			# @  format:  attribute:FILE_TITLE=NOZZLE LOADS
			# @  format:  attribute:LAST_USER=CMS DBA
			# @  format:  attribute:FILE_SIZE=153756
			# @  format:  attribute:FILE_STAT=1
			# @  format:  attribute:BASELINED=0
			# @  format:  attribute:F_TYPE=tiff_5_0
			# @  format:  attribute:VLT_SPACE=MTC_vault
			# @  format:  attribute:VLT_OBJID=181230
			# @  format:  attribute:VLT_VERID=181230
			# @  format:  attribute:UPPER_FILE_ID=101A11.TIF
			# @  format:  file:format=CAD@/root/tmp/Staging/101A11.DWG 
		  
			proc xStructureBO {xID uriObj} {
				#puts "URI Object = ::xmlBusinessObject::$xID \n$uriObj\n"
				set bxStructureBO $::TRUE

				regsub -all -- "\%20" "$uriObj" " " xObj
				foreach {idx iKeyWd} [array get ::3DXKEYWD] {
					#puts "$idx = $iKeyWd"
					# string match -nocase "$iKeyWd" Type
					foreach {xAttr} [split $xObj $::cFLDDELIM] {
							#puts "$xAttr"
							set iKey [lindex [split $xAttr "$::cKEYDELIM"] 0]
							if {[string match -nocase "$iKeyWd" "$iKey"] == 1} {
								if {[string match "" [array get ::xmlBusinessObject::${xID} ${iKeyWd}]] == 1} {
									set ::xmlBusinessObject::${xID}(${iKeyWd}) [lindex [split $xAttr "$::cKEYDELIM"] 1]
								} else {
									append ::xmlBusinessObject::${xID}(${iKeyWd}) "|" [lindex [split $xAttr "$::cKEYDELIM"] 1]
								}
							}
					}
				}
				#puts "Object: ::xmlBusinessObject::$xID has the following properties:"
				#foreach {i j} [array get ::xmlBusinessObject::$xID] { puts "$i = $j"}

				if {[::xmlBusinessObject::xValidateXML3DXSchema $xID] == -1} {
						#~ Initial validation of object schema PASS
						set sInclusionType   [lindex [array get ::xmlBusinessObject::${xID} TYPE] 1]
						set sInclusionPolicy [lindex [array get ::xmlBusinessObject::${xID} POLICY] 1]
						set i1 [lsearch $::AUTONAMERTYPEINCLUSIONLIST $sInclusionType]
						set e1 [lsearch $::AUTONAMERTYPEEXCLUSIONLIST $sInclusionType]
						set i2 [lsearch $::AUTONAMERPOLICYINCLUSIONLIST $sInclusionPolicy]
						set e2 [lsearch $::AUTONAMERPOLICYEXCLUSIONLIST $sInclusionPolicy]

						if {[expr $i1 & $i2] >= 0 && [expr $e1 & $e2] < 0} {
							#~ use autonamer
							#puts "==================== USING AUTONAMERTYPEINCLUSIONLIST OBJECT ===================="
							::xUtil::hitAnyKey
							set iObjStatus [::xmlBusinessObject::xCreateBusinessObject2 $xID]
						} else {
							#~ use XML object definition NAME
							#puts "==================== USING OBJECT NATIVENAME ===================="
							set iObjStatus [::xmlBusinessObject::xCreateBusinessObject2 $xID]
							::xUtil::hitAnyKey
						}
						#~ array set xObjStatus [::xmlBusinessObject::xCreateBusinessObject $xID]
						if {$iObjStatus == $::TRUE} {
								set bObjStatus [::xmlBusinessObject::xClassifyBusinessObject $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 41 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}
								set bObjStatus  [::xmlBusinessObject::xAddInterfaceBusinessObject $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 40 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}
								set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectDescription $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 43 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}


								#set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectProperties $xID]
								#if {$bObjStatus != $::TRUE} {
								#	return [::xUtil::errMsg 49 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								#}

								set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectOriginator $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 49 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}
								set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectOriginatedDate $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 49 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}
								set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectModifiedDate $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 49 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}

								
								set bObjStatus  [::xmlBusinessObject::xUpdateBusinessObjectAttributes $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 42 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}

								set bObjStatus [::xmlBusinessObject::xSetCollaborativeSpace $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 36 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}

								set bObjStatus [::xmlBusinessObject::xSetOrganization $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 36 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}

								set bObjStatus [::xmlBusinessObject::xCheckinBusinessObjectFiles $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 8 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								}
								set bObjStatus [::xmlBusinessObject::xConnectBusinessObjectStructure $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 10 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								} else {
									puts "Success:: xConnectBusinessObjectStructure $xID"
								}
								set bObjStatus [::xmlBusinessObject::xAttachWorkspaceFolders $xID]
								if {$bObjStatus != $::TRUE} {
									return [::xUtil::errMsg 44 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
								} else {
									puts "Success:: xAttachWorkspaceFolders $xID"
								}
						} else {
			   				#~ error creating Businessobject
							return [::xUtil::errMsg 16 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
						}
				} else {
					#~ Initial validation of object schema FAILED
					return [::xUtil::errMsg 104 "URI Object = ::xmlBusinessObject::$xID :$uriObj"]
				}
				puts "xStructureBO(): completed processing DOM: $xID"
				::xUtil::hitAnyKey
				return $bxStructureBO
			}


			# @Method(global): ::xmlBusinessObject::xImportXMLObject(xmlObjFile) - takes an XML file, parses the DOM tree, constructs an in-memory object, and passes the xID for processing
			proc xImportXMLObject {xmlObjFile} {

				set sLocalLogFile [file join [file dirname "$xmlObjFile"] [file rootname [file tail "$xmlObjFile"]]]
				append sLocalLogFile ".log"
				
				set sDir "C:/root/RazorLeaf/ACGap/script"

				::tDOM::baseURL $sDir

				#set xml [tDOM::xmlReadFile C:/root/RazorLeaf/ACGap/script/test02.xml]
				#set xml [tDOM::xmlReadFile C:/root/tmp/staging/in/Drawings_101A11_BL/Drawings_101A11_BL.xml]
				set xml [::tDOM::xmlReadFile "$xmlObjFile"]

				set dom [dom parse $xml]

				set doc [$dom documentElement]

				set nodeList [$doc selectNodes object]


				foreach node $nodeList {
					#::xUtil::dbgMsg "XML Decomposition: node = $node"
					if {[::xUtil::isNull "$node"] == $::FALSE } {
						puts "\n\n~~~~~~~~~~~~~~~~~~~~ Object Specifications ~~~~~~~~~~~~~~~~~~~~~~~~~~"
						#~null node or xChild causes error
						set nodename [$node nodeName]
						#::xUtil::dbgMsg "XML Decomposition: nodename = $nodename"
						if {[::xUtil::isNull "$nodename"] == $::FALSE } {
							foreach xChild [$node childNodes] {
								#::xUtil::dbgMsg "XML Decomposition: xChild = $xChild"
								if {[::xUtil::isNull "$xChild"] == $::FALSE } {
									set xChildName [$xChild nodeName]

									#::xUtil::dbgMsg "XML Decomposition: xChildName = $xChildName"
									if {[::xUtil::isNull "$xChildName"] == $::FALSE } {

										if {"$xChildName" == "attribute"} {
												foreach xAttrNode [$xChild childNodes] {
													#set sAttrName [$xAttrNode nodeName]
													#set sAttrValue [[$xAttrNode selectNodes text()] nodeValue]
													set sAttrName  [lindex [split [$xAttrNode nodeValue] '='] 0]
													set sAttrValue [lindex [split [$xAttrNode nodeValue] '='] 1]
													append xObj "attribute" "$::cKEYDELIM" "$sAttrName" "$::cPAIRDELIM" "$sAttrValue" "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).Attribute($xAttrNode).name($sAttrName) = $sAttrValue"
												}
										} elseif {"$xChildName" == "file"} {
												foreach xAttrNode [$xChild childNodes] {
													set sAttrName [$xAttrNode nodeName]
													set sAttrValue [[$xAttrNode selectNodes text()] nodeValue]
													append xObj "file" "$::cKEYDELIM" "$sAttrName" "$::cPAIRDELIM" "$sAttrValue" "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).Attribute($xAttrNode).name($sAttrName) = $sAttrValue"
												}
										} elseif {"$xChildName" == "relationships"} {
												foreach xRel [$xChild childNodes] {
													append xObj "connection" "$::cKEYDELIM" 
													set i 0
													foreach xConnection [$xRel childNodes] {
															if {$i > 0} { append xObj "$::cSUBDELIM" }
															set sAttrName [$xConnection nodeName]
															set sAttrValue [[$xConnection selectNodes text()] nodeValue]
															append xObj "$sAttrName" "$::cPAIRDELIM" "$sAttrValue"
															incr i
													}
													append xObj "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).Attribute($xAttrNode).name($sAttrName) = $sAttrValue"
												}
										} elseif {"$xChildName" == "classification"} {
												set sAttrName [$xChild nodeName]
												set sNodeValue [$xChild selectNodes text()]
												if {[::xUtil::isNull "$sNodeValue"] == $::FALSE } {
													set sAttrValue [string trim [[$xChild selectNodes text()] nodeValue]]
													append xObj "$sAttrName" "$::cKEYDELIM" "$sAttrValue" "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).ObjParam($xChild).name($sAttrName) = $sAttrValue"
												}
										} elseif {[string tolower "$xChildName"] == "description"} {
												set sAttrName [$xChild nodeName]
												set sNodeValue [$xChild selectNodes text()]
												if {[::xUtil::isNull "$sNodeValue"] == $::FALSE } {
													set sAttrValue6 [string trim [[$xChild selectNodes text()] nodeValue]]
													regsub -all -- "\\|" "$sAttrValue6" "\%7C" sAttrValue5
													regsub -all -- " "   "$sAttrValue5" "\%20" sAttrValue4
													regsub -all -- "\n"  "$sAttrValue4" "\%0A" sAttrValue3
													regsub -all -- ":"   "$sAttrValue3" "\%3A" sAttrValue2
													regsub -all -- "\\\["   "$sAttrValue2" "\%91" sAttrValue1
													regsub -all -- "\\\]"   "$sAttrValue1" "\%93" sAttrValue

													append xObj "$sAttrName" "$::cKEYDELIM" "$sAttrValue" "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).ObjParam($xChild).name($sAttrName) = $sAttrValue"
												}
										} else {
												set sAttrName [$xChild nodeName]
												set sNodeValue [$xChild selectNodes text()]
												#::xUtil::dbgMsg "XML Decomposition: xChildName = $xChildName"
												if {[::xUtil::isNull "$sNodeValue"] == $::FALSE } {
													set sAttrValue4 [string trim [[$xChild selectNodes text()] nodeValue]]
													regsub -all -- "\\|" "$sAttrValue4" "\%7C" sAttrValue3
													regsub -all -- " "   "$sAttrValue3" "\%20" sAttrValue2
													regsub -all -- "\n"  "$sAttrValue2" "\%0A" sAttrValue1
													regsub -all -- ":"   "$sAttrValue1" "\%3A" sAttrValue
													append xObj "$sAttrName" "$::cKEYDELIM" "$sAttrValue" "$::cFLDDELIM"
													#puts "$xObj"
													puts "Node($node).name($nodename).ObjParam($xChild).name($sAttrName) = $sAttrValue"
												}; #~endIf-TheNodeHasEmptytext
										}; #~endIf-xChildName.eq.Tag
									}; #~endIf-xChildNameNull
								}; #~endIf-xChildNull
							}; #~endForeach
						}; #~endIf-nodenameNull

						puts "$xObj"
						regsub -all -- " "  "$xObj"  "\%20" uriObj

						set x [::xUtil::log "$::HISTEVENT(0)" "$xObj"   "$sLocalLogFile"]
						set x [::xUtil::log "$::HISTEVENT(0)" "$uriObj" "$sLocalLogFile"]

						set x [::xmlBusinessObject::xStructureBO $node $uriObj]
						#set xmlBusinessObject($node) "$xObj"
						unset xObj

					}; #~endIF-NodeNull
				}; #~endForeach

				puts "xImportXMLObject(): completed processing XML Object Definition: $xmlObjFile"
				::xUtil::hitAnyKey
				
				return $::TRUE
			}


} ; #~endNamespace(xmlBusinessObject)

