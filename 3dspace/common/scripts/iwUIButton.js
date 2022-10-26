/*
 * iwUIButton.js
 *
 * Copyright (c) 2007 Integware, Inc.  All Rights Reserved.
 * This program contains proprietary and trade secret information of
 * Integware, Inc.
 * Copyright notice is precautionary only and does not evidence any
 * actual or intended publication of such program.
 *
 * $Rev: 658 $
 * $Date: 2011-02-27 16:46:51 -0700 (Sun, 27 Feb 2011) $
 */

function Button(id, text, image, imageDisabled, action)
{
    return Button(id, text, image, imageDisabled, action, false);
}

function Button(id, text, image, imageDisabled, action, disabled)
{
    this.id = id;
    this.text = text;
    this.image = image;
    this.imageDisabled = imageDisabled;
    this.action = action;
    this.disabled = disabled;
    document.write("<table id=\""+this.id+"\" border='0' cellspacing='0' cellpadding='0'><tr><td>a</td></tr></table>");

    paintButton(this.id, this.text, this.image, this.action, true);

    this.disable = function()
    {
        this.disabled = true;
        paintButton(this.id, this.text, this.imageDisabled, "", false);
    }

    this.enable = function()
    {
        this.disabled = false;
        paintButton(this.id, this.text, this.image, this.action, true);
    }

    this.setAction = function(newAction)
    {
        this.action = newAction;
        if (this.disabled)
            this.disable();
        else
            this.enable();
    }
}

function paintButton(id, text, image, action, enabled)
{
    var table = document.getElementById(id);

    while(table.rows.length > 0)
        table.deleteRow(0);

    var img = document.createElement("img");
    img.src = image;
    img.border = 0;
    img.alt=text;

    var row = table.insertRow(0);
    var c1 = row.insertCell(0);
    if (enabled)
    {
        var a1 = document.createElement("a");
        c1.appendChild(a1);
        a1.href="javascript:" + action;

        a1.appendChild(img);
    }
    else
        c1.appendChild(img);

    var c2 = row.insertCell(1);
    if (enabled)
    {
        var a2 = document.createElement("a");
        c2.appendChild(a2);
        a2.href="javascript:" + action;
        a2.innerHTML = text;
    }
    else
    {
        c2.style.color="#777777"
        c2.style.fontSize="11px"
        c2.innerHTML = text;
    }
}
