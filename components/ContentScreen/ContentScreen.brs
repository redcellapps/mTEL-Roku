' ********** Copyright Red Cell Apps 2022.  All Rights Reserved. **********

sub init()
    setURLs()
    m.BaseRegister = CreateObject("roRegistrySection","auth")
    m.LoginScreen = createObject("roSGNode","LoginScreen")
    m.HomeScreen =  createObject("roSGNode","HomeScreen")
    
    m.loadingIndicator = m.top.FindNode("loadingIndicator")    
'    m.loadingIndicator.control = "start"
'    m.loadingIndicator.visible = "true"

    m.token = m.BaseRegister.Read("token")
    m.lang = m.BaseRegister.Read("lang")
    m.ln = m.BaseRegister.Read("langCode")
    m.lng = m.ln.ToInt()
    
    m.landTo = m.BaseRegister.Read("landTo")
   
    m.overhang = m.top.findNode("overhang")
    
    m.typeBarContent = m.top.findNode("TypeContentNode")
         
    m.langBase = CreateObject("roSGNode", "Localization")
    m.langs = m.langBase.langs
        
    m.topMenu = m.top.findNode("TopMenu")
    m.topMenu.content = m.typeBarContent
    m.topMenu.observeField("itemSelected", "onTopMenuItemSelected")
    m.topMenu.observeField("itemFocused","onTopMenuItemFocused")
    
    m.top.ObserveField("visible", "OnVisibleChange")
    m.topMenu.setFocus(true)
    
    
    
    m.channelMarkupGrid = m.top.findNode("ChannelMarkupGrid")
    m.channelMarkupGrid.observeField("itemSelected","onChannelSelected")
    m.channelMarkupGrid.observeField("itemFocused","onChannelFocused")
    
    
    m.EpgMarkupGrid = m.top.findNode("EpgMarkupGrid")
    m.EpgMarkupGrid.observeField("itemSelected","onEpgSelected")
    m.EpgMarkupGrid.observeField("itemFocused","onEpgFocused")
    
'    m.LoginScreen.observeField("contents","StigoContent")
    m.HomeScreen.observeField("searchResult","onSearchReceived")
'    m.top.observeField("searchContent","onSearchReceived")
    m.player = m.top.findNode("videoBkg")
    
    m.showTitle = m.top.findNode("ShowTitle")  
    m.showDescription = m.top.findNode("ShowDesc")
    m.epgNow = 0  
    
   m.loadingIndicator.control = "stop"
   m.loadingIndicator.visible = "false"
'     showChannelGrid() 
End sub


sub onVisibleChange()
end sub
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
end sub 

sub StigoContent()
    m.allContent = m.LoginScreen.contents
    m.allChannels = createObject("roSGNode", "ContentNode")
    m.hdCh = createObject("roSGNode", "ContentNode")
    m.filmCh = createObject("roSGNode", "ContentNode")
    m.sportCh = createObject("roSGNode", "ContentNode")
    m.straniCh = createObject("roSGNode", "ContentNode")
    m.musicCh = createObject("roSGNode", "ContentNode")
    m.kidsCh = createObject("roSGNode", "ContentNode")
    m.mojaCh = createObject("roSGNode", "ContentNode")
          
   for each channel in m.allContent[0][1]
       itm = GetItemData(channel)
       itemcontent = m.allChannels.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[1][1]
       itm = GetItemData(channel)
       itemcontent = m.hdCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[2][1]
       itm = GetItemData(channel)
       itemcontent = m.kidsCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[3][1]
       itm = GetItemData(channel)
       itemcontent = m.sportCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[4][1]
       itm = GetItemData(channel)
       itemcontent = m.musicCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for

   for each channel in m.allContent[5][1]
       itm = GetItemData(channel)
       itemcontent = m.filmCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[6][1]
       itm = GetItemData(channel)
       itemcontent = m.straniCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
   for each channel in m.allContent[7][1]
       itm = GetItemData(channel)
       itemcontent = m.mojaCh.createChild("ContentNode")
       itemcontent.setFields(itm)
   end for
        m.loadingIndicator.control = "stop"
        m.loadingIndicator.visible = "false" 
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
        if channel[5] <> invalid and channel[5] <> ""
        item.hdPosterURL = channel[5]
        else
        item.hdPosterURL = "pkg:/images/splash_sd.jpg"
        end if
        if channel[4] <> invalid
        item.darkLogo = channel[4]
        end if
        if channel[6] <> invalid
        item.maxDelay = channel[6]
        end if

    return item
end function

sub onSearchReceived()
'   for i = 0 to m.top.searchContent.getChildCount()-1
'    chn = m.top.searchContent.getChild(i)
'   end for
   m.loadingIndicator.control = "stop"
   m.loadingIndicator.visible = "false" 
   m.topMenu.setFocus(true) 
end sub    

sub showChannelGrid()
   m.loadingIndicator.control = "stop"
   m.loadingIndicator.visible = "false"
   m.channelMarkupGrid.content = m.top.searchContent
   m.channelMarkupGrid.visible = true
   m.channelMarkupGrid.setFocus(true)
end sub



sub showEpgGrid()
   m.loadingIndicator.control = "stop"
   m.loadingIndicator.visible = "false"
   m.epgMarkupGrid.content = m.channelEpg
   m.epgMarkupGrid.setFocus(true)
   m.epgMarkupGrid.jumpToItem = m.epgNow
   m.epgMarkupGrid.visible = true   
end sub

Sub onTopMenuItemSelected()
if m.topMenu.itemSelected = 1
m.channelMarkupGrid.visible = false
getRadio()
else
showChannelGrid()
end if
End sub

Sub onTopMenuItemFocused()

End sub

Sub onTypeItemSelected()

if m.typePosterGrid.itemSelected = 1
m.channelMarkupGrid.visible = false
getRadio()
else
showChannelGrid(m.typePosterGrid.itemSelected)
end if
End sub

Sub onTypeItemFocused()
If m.typePosterGrid.itemFocused = 1

end if
End sub

Sub onChannelSelected()
m.loadingIndicator.control = "start"
m.loadingIndicator.visible = "true"
m.chidx = m.channelMarkupGrid.itemSelected
m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
   m.epgMarkupGrid.setFocus(true)
   m.epgMarkupGrid.jumpToItem = m.epgNow
getEpg(m.chID)

End sub

Sub onChannelFocused()
m.chidx = m.channelMarkupGrid.itemFocused
'm.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
'getEpg(m.chID)
m.showTitle.visible = false
m.showDescription.visible = false
End sub

function getEpg(chid as string)
    m.getEpgTask = createObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "GET"
    url = m.epgURL+chid+"/"
    requestData.urlString = url
    requestBody = {}
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
    m.getEpgTask.setField("requestData", requestData)
    m.getEpgTask.observeField("result","onEpgReceived")
    m.getEpgTask.control = "RUN"
end function

sub onEpgReceived()
if m.getEpgTask.result <> invalid and m.getEpgTask.result.bodystring <> invalid and m.getEpgTask.result.bodystring <> "[]"
        m.responseBody = parseJson(m.getEpgTask.result.bodystring)
        if m.responseBody<> invalid
        epg = m.responseBody[m.chID].programme
        if epg.count() > 0
        parseEpg(epg)
        else 
        getChannelUrl(m.chID,0)
        end if
        end if      
 end if
end sub

Sub onEpgSelected()
m.showidx = m.epgMarkupGrid.itemSelected
m.showID = m.epgMarkupGrid.content.getChild(m.chidx).id
strt = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine1
'stp = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine2
now =(getCurrentTimeSeconds()/60) + 60
showStart = timeFromIsoStrSeconds(strt)/60
'showEnd = timeFromIsoStrSeconds(stp)/60
offset = (now - showStart)
if offset > 0 
getChannelUrl(m.chID, offset)
else
getChannelUrl(m.chID, 0)
end if
End sub

Sub onEpgFocused()
if m.epgMarkupGrid.itemFocused >= 0
m.showidx = m.epgMarkupGrid.itemFocused
m.showTitle.text = m.epgMarkupGrid.content.getChild(m.showidx).Title
m.showTitle.visible = true
if m.epgMarkupGrid.content.getChild(m.showidx).description <> invalid
m.showDescription.text = m.epgMarkupGrid.content.getChild(m.showidx).description
m.showDescription.visible = true
end if
end if
End sub



Function getRadio()
 m.getRadioTask = createObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.radioStationsURL
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
    requestBody["type"] = "smarttv"
    requestBody["lang"] = m.lang
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
    m.getRadioTask.setField("requestData", requestData)
    m.getRadioTask.observeField("result","onRadioReceived")
    m.getRadioTask.control = "RUN"
end function

sub onRadioReceived()
if m.getRadioTask.result <> invalid and m.getRadioTask.result.bodystring <> invalid and m.getRadioTask.result.bodystring <> "[]"
        m.responseBody = parseJson(m.getRadioTask.result.bodystring)
        if m.responseBody<> invalid
          radio = m.responseBody
          parseRadio(radio)
        end if      
 end if
end sub

function parseRadio(radio)
m.allRadio =  createObject("roSGNode", "ContentNode")
m.RadioBH = createObject("roSGNode", "ContentNode")
m.RadioCG = createObject("roSGNode", "ContentNode")
m.RadioHR = createObject("roSGNode", "ContentNode")
m.RadioMK = createObject("roSGNode", "ContentNode")
m.RadioOO = createObject("roSGNode", "ContentNode")
m.RadioSLO = createObject("roSGNode", "ContentNode")
m.RadioSRB = createObject("roSGNode", "ContentNode")
m.radioBH.setField("title",m.langs[m.lng][35])
m.radioHR.setField("title",m.langs[m.lng][34])
m.radioCG.setField("title",m.langs[m.lng][38])
m.radioMK.setField("title",m.langs[m.lng][36])
m.radioSLO.setField("title",m.langs[m.lng][39])
m.radioSRB.setField("title",m.langs[m.lng][37])
m.radioOO.setField("title",m.langs[m.lng][39])
     
       for each station in radio[0][1]
       itm = GetRadioData(station)
       epgcontent = m.radioBH.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for     
       for each station in radio[1][1]
       itm = GetRadioData(station)
       epgcontent = m.radioCG.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for       
       for each station in radio[2][1]
       itm = GetRadioData(station)
       epgcontent = m.radioHR.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for       
       for each station in radio[3][1]
       itm = GetRadioData(station)
       epgcontent = m.radioMK.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for       
       for each station in radio[4][1]
       itm = GetRadioData(station)
       epgcontent = m.radioOO.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for
       for each station in radio[5][1]
       itm = GetRadioData(station)
       epgcontent = m.radioSLO.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for
       for each station in radio[6][1]
       itm = GetRadioData(station)
       epgcontent = m.radioSRB.createChild("ContentNode")
       epgcontent.setFields(itm)    
       end for
       m.allRadio.appendChild(m.RadioHR)
       m.allRadio.appendChild(m.RadioBH)
       m.allRadio.appendChild(m.RadioMK)
       m.allRadio.appendChild(m.RadioSRB)
       m.allRadio.appendChild(m.RadioCG)
       m.allRadio.appendChild(m.RadioOO)   
   showRadioGrid()
end function

function showRadioGrid()
m.radioGrid = m.top.findNode("radioRowList")
m.radioGrid.content = m.allRadio
m.radioGrid.visible = true
m.radioGrid.setFocus(true)
m.radioGrid.observeField("rowItemSelected","onRadioSelected")
end function

sub onRadioSelected()
rowid = m.radioGrid.rowItemSelected[0]
stationid = m.radioGrid.rowItemSelected[1]
stations = m.radioGrid.content
row =  stations.getChild(rowid)
selectedRadio = row.getChild(stationid)
m.radioURL = selectedRadio.URL
m.radioName = selectedRadio.title
playRadio(m.radioURL)
end sub

sub showRadioDialog()
m.errDialog = m.top.findNode("radiomessagedialog")
        setErrColors()
        m.errDialog.palette = m.errPalette
        m.errDialog.title = m.langs[m.lng][43]
        m.errDialog.message = [m.radioName]
        m.errDialog.buttons = [tr(m.langs[m.lng][9])]
        m.errDialog.setFocus(true)
        m.errDialog.visible = true
        m.errDialog.observeFieldScoped("buttonSelected", "dismissErrDialog")
        m.errDialog.observeFieldScoped("wasClosed", "errClosedChanged")
end sub

sub dismissErrDialog()
m.errDialog.visible = false
m.radioPlayer.control = "stop"
showRadioGrid()
end sub
sub errClosedChanged()
'm.top.setFocus(true)
'm.buttons.setFocus(true)
end sub

function playRadio(rurl)
radioContent = createObject("RoSGNode", "ContentNode")
radioContent.Url = rurl
m.radioPlayer = CreateObject("roSGNode", "Audio")
m.radioPlayer.content = radioContent
showRadioDialog()
m.radioPlayer.control = "play"
end function

function GetRadioData(station as Object) as Object
        item = {}
        if station[2] <> invalid
        item.id = station[2]
        end if
        if station[0] <> invalid
        item.Title = station[0]
        end if
        if station[1] <> invalid
        item.url = station[1]
        end if
    return item
end function


function getChannelURL(chid as string, delay as Integer)
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    m.overhang.visible = false
    m.getContentTask = createObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.channelURL
    m.dly = delay
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
    requestBody["cid"] = chid
    requestBody["delay"] = delay
    requestBody["type"] = "smarttv"
    requestBody["request_type"] = "json" 
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
    m.getContentTask.setField("requestData", requestData)
    m.getContentTask.observeField("result","onChannelURLReceived")
    m.getContentTask.control = "RUN"
end function

sub onChannelURLReceived()
if m.getContentTask.result <> invalid and m.getContentTask.result.bodystring <> invalid and m.getContentTask.result.bodystring <> "[]"
        m.responseBody = parseJson(m.getContentTask.result.bodystring)
        if m.responseBody<> invalid
        chURL = m.responseBody.channel_url
        playChannel(chURL)
'        m.top.contents = m.responseBody
        else        
        end if      
 end if
end sub

function parseEpg(epg)
m.channelEpg = createObject("roSGNode", "ContentNode")
sh = 0
for each show in epg
       if  getCurrentTimeSeconds() < timeFromIsoStrSeconds(show.stop) and getCurrentTimeSeconds() > timeFromIsoStrSeconds(show.start)
       m.epgNow = sh
       end if
       sh=sh+1
       itm = GetEpgData(show)
       epgcontent = m.channelEpg.createChild("ContentNode")
       epgcontent.setFields(itm)    
   end for
    showEpgGrid()
end function

function GetEpgData(show as Object) as Object
        item = {}
        if show.channelId <> invalid
        item.channelId = show.channelId
        end if
        if show.contentId <> invalid
        item.contentID = show.contentID
        end if
        if show.id <> invalid
        item.id = show.id
        end if
        if show.image <> invalid and show.image <> ""
        item.hdPosterURL = show.image
        else 
        item.hdPosterURL = "pkg:/images/iontvwhite.png"
        end if
        if show.title <> invalid
        item.title = show.title
        end if
        if show.desc <> invalid
        item.description = show.desc
        end if
        if show.start <> invalid
        item.ShortDescriptionLine1 = show["start"]
        end if
        if show.stop <> invalid
        item.ShortDescriptionLine2 = show["stop"]
        end if  
    return item
end function

Function playChannel(chUrl)
playerContent = createObject("RoSGNode", "ContentNode")
playerContent.Url = chURL
'playerContent.streamFormat = "HLS"
m.player.content = playerContent
m.player.control = "play"
m.player.setFocus(true)
m.player.visible = true
end function

Function ParseStringToXml(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function

Function getCurrentTimeSeconds()
    dateObj = createObject("roDateTime")
    currentTime = dateObj.AsSeconds()
    return currentTime
End Function

function timeFromIsoStrSeconds(timeStr as String)
isoTmp = ""
isoTmp = Left(timeStr, 4)+"-"+Mid(timeStr,5,2)+"-"+Mid(timeStr,7,2)+" "+Mid(timeStr,9,2)+":"+Mid(timeStr,11,2)+":"+Right(timeStr,2)+".000"
tmpDt = CreateObject("roDateTime")
tmpDt.FromISO8601String(isoTmp)
return tmpDt.AsSeconds()
endfunction

sub setErrColors()
m.errPalette = createObject("roSGNode", "RSGPalette")
m.errPalette.colors = {
                         DialogBackgroundColor: "#364452",
                         DialogItemColor: "0xE4E4E4",
                         DialogTextColor: "0xEEEEEE",
                         DialogFocusColor: "0xE12F2D",
                         DialogFocusItemColor: "0xEEEEEE",
                         DialogSecondaryTextColor: "0xFFFFFF",
                         DialogSecondaryItemColor: "0xFFFFFF",
                        }
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
        if m.epgMarkupGrid.hasFocus() = true
        m.channelMarkupGrid.setFocus(true)
        m.epgMarkupGrid.visible = false
        else if m.channelMarkupGrid.hasFocus() = true
'        m.typePosterGrid.setFocus(true) 
        m.topMenu.setFocus(true)  
        end if
        return true
        else if key = "down"
        ? "Down"
        
        return true
        else if key = "back"
        if m.epgMarkupGrid.hasFocus() = true
        m.epgMarkupGrid.visible = false
        m.channelMarkupGrid.setFocus(true)
        return true
        else if m.channelMarkupGrid.hasFocus() = true
        m.topMenu.setFocus(true)
'        m.typePosterGrid.setFocus(true)
        return true
        end if
        if m.player.hasFocus() = true
        m.player.control = "stop"
        m.player.visible = false
        m.epgMarkupGrid.setFocus(true)
        m.overhang.visible = true
        return true
        end if
        if m.radioGrid <> invalid
            if m.radioGrid.hasFocus()
'        m.typePosterGrid.setFocus(true)
        m.topMenu.setFocus(true)
        m.radioGrid.visible = false
        return true
        end if
        end if
        ? "back"
        return false
        end if   
    end if
    return result 
    
end function