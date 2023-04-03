' ********** Copyright 2022 RedCellApps.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

function RunContentTask(idx)
    m.token =  m.LoginScreen.token
    m.galleryTask = createObject("roSGNode", "Task_CallGallery")
    m.galID = m.loginScreen.contents[idx].id
    requestData = {}
    requestData.httpMethodString = "GET"
    url = "https://wedflow.co/api/galleries/"+m.galID+"?expand=sets"
    requestData.urlString = url
    requestBody = {}
    requestBody["tvCode"] = m.tvCodeString
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json", "x-access-token" : m.token}
    m.galleryTask.setField("requestData", requestData)
    m.galleryTask.observeField("content","OnMainContentLoaded")
    m.galleryTask.control = "RUN"
    m.loadingIndicator.visible = false

end function

sub OnMainContentLoaded() 
    m.GridScreen.SetFocus(true)
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = false 
    m.GridScreen.content = m.galleryTask.content 
end sub

function RunChaptersTask(idx)
    m.token =  m.LoginScreen.token
    m.ChaptersTask = createObject("roSGNode", "Task_CallChapters")
    m.galID = m.loginScreen.contents[idx].id
    requestData = {}
    requestData.httpMethodString = "GET"
    url = "https://wedflow.co/api/galleries/"+m.galID+"?expand=sets"
    requestData.urlString = url
    requestBody = {}
    requestBody["tvCode"] = m.tvCodeString
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json", "x-access-token" : m.token}
    m.ChaptersTask.setField("requestData", requestData)
    m.ChaptersTask.observeField("content","OnChaptersContentLoaded")
    m.m.ChaptersTask.control = "RUN"
    m.loadingIndicator.visible = false
end function

sub OnChaptersContentLoaded()
    m.ChaptrsScreen.SetFocus(true) 
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = false 
    m.ChaptersScreen.content = m.ChaptersTask.content 
end sub