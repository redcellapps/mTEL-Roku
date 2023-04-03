' Copyright (c) 2020 Roku, Inc. All rights reserved.

sub OnContentSet() ' invoked when item metadata retrieved
    content = m.top.itemContent
    ' set poster uri if content is valid
    if content <> invalid 
        m.top.FindNode("poster").uri = content.HDPOSTERURL

        m.top.FindNode("itemText").text = content.title
    end if
end sub
