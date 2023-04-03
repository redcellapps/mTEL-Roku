' ********** Copyright Red Cell Apps 2022.  All Rights Reserved. **********

sub init()
    setURLs()
    m.BaseRegister = CreateObject("roRegistrySection","auth")
    m.LoginScreen = CreateObject("roSGNode","LoginScreen")
    m.token = m.BaseRegister.Read("token")
    m.lang = m.BaseRegister.Read("lang")
    m.overhang = m.top.findNode("overhang")
    
    m.typeBarContent = m.top.findNode("TypeContentNode")
    
    m.loadingIndicator = m.top.FindNode("loadingIndicator") 
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
         
  
    
    m.channelMarkupGrid = m.top.findNode("ChannelMarkupGrid")
    m.channelMarkupGrid.observeField("itemSelected","onChannelSelected")
    m.channelMarkupGrid.observeField("itemFocused","onChannelFocused")

    m.VODPlayer = m.top.findNode("videoBkg")
    
    m.showTitle = m.top.findNode("ShowTitle")  
    m.showDescription = m.top.findNode("ShowDesc")
    getVOD()  
End sub

sub setURLs()
    m.baseURL = "https://api.gss-media.com/"
    m.countriesURL = m.baseURL + "signup/countries-tv"
    m.registerURL = m.baseURL + "signup/gss-new"
    m.activationURL = m.baseURL + "signup/gss-activate"
    m.loginURL = "https://api.gss-media.com/login"
    m.channelsURL = "https://api.gss-media.com/channels/get_list_double_singles/tv.json"
    m.channelURL = "https://api.gss-media.com/channels/get_url"
    m.epgURL = "https://api.gss-media.com:8443/channels/get_epg/"
    m.radioStationsURL = "https://api.gss-media.com/radios/get_list/radio.json"
    m.vodURL = "https://api.gss-media.com/vods/get_list/vod.json"
    m.getVodURL = "https://api.gss-media.com/vods/get_url"
end sub 

Function getVOD()
 m.getVODTask = createObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.vodURL
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
    requestBody["type"] = "smarttv"
    requestBody["lang"] = m.lang
    requestBody["sv"] = "1"
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
    m.getVODTask.setField("requestData", requestData)
    m.getVODTask.observeField("result","onVODReceived")
    m.getVODTask.control = "RUN"
end function

sub onVODReceived()
if m.getVODTask.result <> invalid and m.getVODTask.result.bodystring <> invalid and m.getVODTask.result.bodystring <> "[]"
        m.responseBody = parseJson(m.getVODTask.result.bodystring)
        if m.responseBody<> invalid
          vod = m.responseBody
          parsevod(vod)
        end if      
 end if
end sub

function parseVOD(vod)
m.allVOD =  createObject("roSGNode", "ContentNode")
m.domaceSerije = createObject("roSGNode", "ContentNode")
m.straneSerije = createObject("roSGNode", "ContentNode")
m.domaciFilmovi = createObject("roSGNode", "ContentNode")
m.straniFilmovi = createObject("roSGNode", "ContentNode")
m.domaceSerije.setField("title","Domaće Serije")
m.straneSerije.setField("title","Strane Serije")
m.domaciFilmovi.setField("title","Domaći Filmovi")
m.straniFilmovi.setField("title","Strani Filmovi")
     
       for each station in VOD[0][1]
       itm = GetVODData(station)
       vodcontent = m.domaceSerije.createChild("ContentNode")
       vodcontent.setFields(itm)    
       end for     
       for each station in VOD[1][1]
       itm = GetVODData(station)
       vodcontent = m.straneSerije.createChild("ContentNode")
       vodcontent.setFields(itm)    
       end for       
       for each station in VOD[2][1]
       itm = GetVODData(station)
       vodcontent = m.domaciFilmovi.createChild("ContentNode")
       vodcontent.setFields(itm)    
       end for       
       for each station in VOD[3][1]
       itm = GetVODData(station)
       vodcontent = m.straniFilmovi.createChild("ContentNode")
       vodcontent.setFields(itm)    
       end for       
       
'       m.allVOD.appendChild(m.domaceSerije)
'       m.allVOD.appendChild(m.straneSerije)
       m.allVOD.appendChild(m.domaciFilmovi)
'       m.allVOD.appendChild(m.straniFilmovi)
 
   showVODGrid()
end function

function GetVODData(vod as Object) as Object
        item = {}
        if vod[0] <> invalid
        item.Title = vod[0]
        end if
        if vod[1] <> invalid
        item.SecondaryTitle = vod[1]
        end if
        if vod[2] <> invalid
        item.url = vod[2]
        end if
'        if vod[3] <> invalid
'        item.id = vod[3]
'        end if
        if vod[4] <> invalid
        item.Description = vod[4]
        end if
        if vod[5] <> invalid
        item.Director = vod[5]
        end if
        if vod[6] <> invalid
        item.Actor = vod[6]
        end if
        if vod[7] <> invalid
        item.releaseDate = vod[7]
        end if
        if vod[11] <> invalid
        item.HDPosterUrl = vod[11]
        end if
        
    return item
end function

function showVODGrid()
m.VODGrid = m.top.findNode("VODRowList")
m.VODGrid.content = m.allVOD
m.VODGrid.visible = true
m.VODGrid.setFocus(true)
m.VODGrid.observeField("rowItemSelected","onVODSelected")
m.loadingIndicator.control = "stop"
m.loadingIndicator.visible = "false"
end function

sub onVODSelected()
rowid = m.VODGrid.rowItemSelected[0]
vodid = m.VODGrid.rowItemSelected[1]
vods = m.VODGrid.content
row =  vods.getChild(rowid)
selectedVOD = row.getChild(vodid)
m.VODURL = selectedVOD.URL
m.VODName = selectedVOD.title

getVodURL(m.VODURL)
'playVOD(m.VODURL)
end sub

function playVOD(rurl)
VODContent = createObject("RoSGNode", "ContentNode")
VODContent.Url = rurl
'VODContent.streamformat = "mp4"
m.VODPlayer.content = VODContent
'm.top.appendChild(m.VODPlayer)
m.VODPlayer.visible = true
m.VODPlayer.setFocus(true)
m.VODPlayer.control = "play"
end function

function getVodURL(vodURL as string)
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    m.getContentTask = createObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = vodURL
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
'    requestBody["vid"] = vodid
    requestBody["type"] = "smarttv"
    requestBody["request_type"] = "json" 
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
    m.getContentTask.setField("requestData", requestData)
    m.getContentTask.observeField("result","onVodURLReceived")
    m.getContentTask.control = "RUN"
end function

sub onVodURLReceived()
if m.getContentTask.result <> invalid and m.getContentTask.result.bodystring <> invalid and m.getContentTask.result.bodystring <> "[]"
        m.responseBody = parseJson(m.getContentTask.result.bodystring)
        if m.responseBody<> invalid
        streamURL = m.responseBody.stream_url
        playVOD(streamURL)
'        m.top.contents = m.responseBody
        else        
        end if      
 end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "right"
        ? "Right"
        return true
        else if key = "left"
        ? "Left"
        return true
        else if key = "up"
        ? "Up"
  
        return true
        else if key = "down"
        ? "Down"
        
        return true
        else if key = "back"   
'        getVod()
        if m.VODPlayer.hasFocus() = true
        m.VODPlayer.control = "stop"
        m.VODPlayer.visible = false
        showVodGrid()
        m.overhang.visible = true
'        m.VODPlayer = invalid
        ? "back"
        return true
        end if
        end if   
    end if
    return result 
    
end function