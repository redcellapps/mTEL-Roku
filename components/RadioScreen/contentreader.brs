 sub init()
      m.top.functionName = "getcontent"
      m.LoginScreen = CreateObject("roSGNode", "LoginScreen")
      m.LoginScreen.observeField("contents","StigoContent")
    end sub
    
   sub StigoContent()
    content = createObject("roSGNode", "ContentNode")
        for each channel in m.LoginScreen.contents[0][1]
            itm = GetItemData(channel)
            itemcontent = content.createChild("ContentNode")
            itemcontent.setFields(itm)
        end for
            m.top.content = content
    end sub
    
function GetItemData(channel as Object) as Object
        item = {}

        if channel[0] <> invalid
        item.title = channel[0]
        end if
        if channel[1] <> invalid
        item.channelURL = channel[1]
        end if
        if channel[2] <> invalid
        item.id = channel[2]
        end if
        if channel[3] <> invalid
        item.xmlTV = channel[3]
        end if
        if channel[4] <> invalid
        item.hdPosterURL = channel[4]
        else
        item.hdPosterURL = "pkg:/images/placeholder-image.jpg"
        end if
        if channel[5] <> invalid
        item.darkLogo = channel[5]
        end if
        if channel[6] <> invalid
        item.maxDelay = channel[6]
        end if
    return item
end function
