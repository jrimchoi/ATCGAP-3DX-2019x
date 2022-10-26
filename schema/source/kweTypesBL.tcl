proc kweTypesBL_policy {sTypeName} {
        set mqlret        1
        set outstr        ""

	set mqlret [ catch {eval mql execute program emxKweTypesBL -method getPolicyForTypeMQL "$sTypeName"} outstr ]
	return [list $mqlret "$outstr"]
}

proc kweTypesBL_vault {sTypeName} {
        set mqlret        1
        set outstr        ""

        set mqlret [ catch {eval mql execute program emxKweTypesBL -method getVaultForTypeMQL "$sTypeName"} outstr ]
        return [list $mqlret "$outstr"]
}

proc kweTypesBL_search_vaults {sTypeName} {
        set mqlret        1
        set outstr        ""

        set mqlret [ catch {eval mql execute program emxKweTypesBL -method getSearchVaultsForTypeMQL "$sTypeName"} outstr ]
        return [list $mqlret "$outstr"]
}

proc kweTypesBL_customer_interfaces {sTypeName} {
        set mqlret        1
        set outstr        ""

        set mqlret [ catch {eval mql execute program emxKweTypesBL -method getCustomerInterfacesForTypeMQL "$sTypeName"} outstr ]
        return [list $mqlret "$outstr"]
}

