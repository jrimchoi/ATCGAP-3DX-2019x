

/*
  returns arg with all whitespace removed
*/
function removeSpecialChars(s)
{
    return s.replace(/[",]+/g, "");
}

/*
  returns nothing.  sets options in select menu defined by childMenuName
  arg, based on the option selected in parentMenu.
  (parentMenu --> childMenu form a set of context-sensitive lists)

  parentMenu is passed simply by using the 'this' keyword
  childMenuName should be the actual name of the list to populate
*/
function setDependentListChoices(callingMenu, csMenuArrayName)
{
    var menuNameArray = eval(csMenuArrayName + "MenuNameArray");

    // build up the associative key
    var choice = "";
    var childMenu;
    var addChoices = true;
    for (var i = 0; i < menuNameArray.length; i++) {
        var menu = document.forms[0].elements[menuNameArray[i]];

        if (addChoices) {
            var menuValue = menu.options[menu.selectedIndex].value;
            if (i > 0) choice += "~";
            choice += menuValue;

            if (callingMenu.name == menuNameArray[i]) {
                childMenu = document.forms[0].elements[menuNameArray[i + 1]];
                addChoices = false;
            }
        }
        else {
            menu.options.length = 0;
        }
    }

    choice = removeSpecialChars(choice);

    //var childMenu = document.forms[0].elements[childMenuName];
    // empty previous settings
    //childMenu.options.length = 0;
    //var dbName = removeSpecialChars(parentMenu.name);
    //var choice = parentMenu.options[parentMenu.selectedIndex].value;
    var dbObj = eval(csMenuArrayName + "[choice]");

    // insert default first item
    childMenu.options[0] = new Option("", "", false, false);
    if (choice != "") {
        // loop through object values, and populate options
        for (var i = 0; i < dbObj.length; i++) {
            childMenu.options[i + 1] = new Option(dbObj[i].text, dbObj[i].value);
        }
    }
}

function setDependentListChoicesForReassign(callingMenu, csMenuArrayName)
{
    var menuNameArray = eval(csMenuArrayName + "MenuNameArray");

    // build up the associative key
    var choice = "";
    var childMenu;
    var addChoices = true;
    for (var i = 0; i < menuNameArray.length; i++) {
        var menu = document.forms[0].elements[menuNameArray[i]];

        if (addChoices) {
            var menuValue = menu.options[menu.selectedIndex].value;
            if (i > 0) choice += "~";
            choice += menuValue;

            if (callingMenu.name == menuNameArray[i]) {
                childMenu = document.forms[0].elements[menuNameArray[i + 1]];
                addChoices = false;
            }
        }
        else {
            menu.options.length = 0;
        }
    }

    choice = removeSpecialChars(choice);

    //var childMenu = document.forms[0].elements[childMenuName];
    // empty previous settings
    //childMenu.options.length = 0;
    //var dbName = removeSpecialChars(parentMenu.name);
    //var choice = parentMenu.options[parentMenu.selectedIndex].value;
    var dbObj = eval(csMenuArrayName + "[choice]");

    // insert default first item
    //childMenu.options[0] = new Option("", "", false, false);
    if (choice != "") {
        // loop through object values, and populate options
        for (var i = 0; i < dbObj.length; i++) {
            if (i == 0)
                childMenu.options[i] = new Option(dbObj[i].text, dbObj[i].value, true);
            else
                childMenu.options[i] = new Option(dbObj[i].text, dbObj[i].value);
        }
    }
}
