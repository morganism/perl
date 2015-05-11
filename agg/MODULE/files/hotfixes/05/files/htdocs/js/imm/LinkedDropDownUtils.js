function initLinkDDL(_ar_init)
{
    // ----------
    // Initialisation has to be done for all linked items even if the parent is set as all
    // This is the only way to ensure the list has a set of distinct values
    // ----------
    for(var i=0; i<_ar_init.length; i++)
    {
        var ddlPattern = getDdlPattern(); 
        var parentName = ddlPattern.replace(/\?/, _ar_init[i].getId());
        var parentDdl = document.forms[0][ parentName ];

        var idx = parentDdl.selectedIndex;
        var parentItem = parentDdl[idx];
        if(parentItem != undefined)
        {
	        var parentValue = parentItem.value;
	        var childId = _ar[ parentName ];
	        _ar_init[i].update(parentDdl, childId);
        }
    }
}

// Object declaration
function ddLinkObj(attribId, type)
{
    // Setup object vars
    var http_request;
    var updating = false; 
    var that = this;
    var id = attribId;
    
    
    // Set Child Array
    this.setChildArray = function(ar)
    {
        _ar = ar;    
    }
    
    // Set Initial values Array
    this.setInitialValues = function(ar)
    {
        _ar_initial_values = ar;
    }
    
    // Get ID
    this.getId = function()
    {
        return id;
    }    
    
    // Main - call from onchange event of DDL
    this.update = function(parentDdl, childId)
    {
        if(childId!=0) 
        {
            if(updating==true) {return false; }
            updating = true;
            
            var idx = parentDdl.selectedIndex;
            var parentValue = parentDdl[idx].value;
            
            var ddlPattern = getDdlPattern(); 
            var childName = ddlPattern.replace(/\?/, childId);

            var childDdl = document.forms[0][ childName ];
            var idx = childDdl.selectedIndex;
            var childValue = '';
            if(idx >= 0)
            {
                childValue = childDdl[idx].value;
            }
             
            var url = getServletUrl() + "&value=" + parentValue + "&attribId=" + childId + "&childValue=" + childValue + "&type=" + type;
            //alert("url="+url);

            $.ajax({
    			url: url,
    			cache: false,
    			success: function(data, textStatus, XMLHttpRequest) {
                	updating = false;
            		that.updateDDL(data, childId);
    			},
    			error: function(XMLHttpRequest, textStatus, errorThrown) {
                    updating = false;
                    alert("There was a problem with the request '" + url + "'\nMessage = " +textStatus);
    			}
    		});

            return true;
        }
    }

    
    this.updateDDL = function(optionsText, childId)
    {
        var ddlPattern = getDdlPattern(); 
        var elementName = ddlPattern.replace(/\?/, childId);
        //alert('IN updateDDL: elementName: ' + elementName);
        //alert('updateDDL: optionsText: ' + optionsText);

        var selectElement = document.getElementById(elementName);

        var isMSIE = /*@cc_on!@*/false; // any IE
        if (isMSIE)
        {
            //selectElement.innerHTML = optionsText;
            // Replacing just the <option>...</option> list using innerHTML causes all sorts of problems with IE
            // leading to slow rendering of pages that contain large drop-downs (10000+ elements).
            // Performance is better when we replace the whole select

            // extract the select part of the html
            var selectEl = selectElement.outerHTML;
            myregexp = /<select[^>]*>/i;
            var selectPart = myregexp.exec(selectEl);
            //alert ('selectPart: '+ selectPart);

            // construct replacement select html
            var selectText = selectPart + optionsText + "</select>";

            // replace the select within its parent
            // IMPORTANT: this assumes that the <select> has no siblings!!
            selectElement.parentNode.innerHTML = selectText;
        }
        else
        {
            // any other browser
            // just replace inner text
            selectElement.innerHTML = optionsText;
        }
    }
}

///////////
// UTILS //
///////////

// Need to override /js/web/ShowHideUtils.js as it is using "block" - we need "inline"
function show(id)
{
    var uiComponent = document.getElementById(id);
    if(uiComponent != null) uiComponent.style.display = "inline";
}
