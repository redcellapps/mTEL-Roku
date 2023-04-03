
' ********** Copyright Red Cell Apps 2022.  All Rights Reserved. **********

sub Init()
    setURLs()
    m.BaseRegister = CreateObject("roRegistrySection", "auth")
    m.LoginScreen = CreateObject("roSGNode", "LoginScreen")
    m.token = m.BaseRegister.Read("token")
    m.lang = m.BaseRegister.Read("lang")
    m.lng = m.BaseRegister.Read("langCode").ToInt()
    m.overhang = m.top.findNode("overhang")
    m.landTo = m.BaseRegister.Read("landto")
    m.typeBarContent = m.top.findNode("TypeContentNode")
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.background = m.top.findNode("ionPoster")

    m.langBase = CreateObject("roSGNode", "Localization")
    m.langs = m.langBase.langs

    m.topMenu = m.top.findNode("TopMenu")
    m.topMenu.content = m.typeBarContent
    m.topMenu.observeField("itemSelected", "onTopMenuItemSelected")
    m.topMenu.observeField("itemFocused", "onTopMenuItemFocused")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.topMenu.setFocus(true)

    m.channelMarkupGrid = m.top.findNode("ChannelMarkupGrid")
    m.channelMarkupGrid.observeField("itemSelected", "onChannelSelected")
    m.channelMarkupGrid.observeField("itemFocused", "onChannelFocused")

    m.EpgMarkupGrid = m.top.findNode("EpgMarkupGrid")
    m.EpgMarkupGrid.observeField("itemSelected", "onEpgSelected")
    m.EpgMarkupGrid.observeField("itemFocused", "onEpgFocused")

    m.EpgBackButton = m.top.findNode("EpgBackButton")
    m.EpgBackButton.observeField("buttonSelected", "onEpgBackButtonSelected")
    m.EpgFwdButton = m.top.findNode("EpgFwdButton")
    m.EpgFwdButton.observeField("buttonSelected", "onEpgFwdButtonSelected")
    m.EpgLiveButton = m.top.findNode("EpgLiveButton")
    m.EpgLiveButton.observeField("buttonSelected", "onEpgLiveButtonSelected")
    m.EpgDateLabel = m.top.findNode("EpgDateLabel")

    m.shiftDirection = m.top.findNode("shiftDirection")
    m.shiftLabel = m.top.findNode("shiftLabel")

    m.LoginScreen.observeField("contents", "StigoContent")
    m.player = m.top.findNode("videoBkg")
    m.player2 = m.top.findNode("video2")

    m.showTitle = m.top.findNode("ShowTitle")
    m.showDescription = m.top.findNode("ShowDesc")
    m.showTime = m.top.findNode("ShowTime")
    m.epgNow = 0
    m.epgLive = 0
    hideTimeshift()
    setScreenSize()
    m.fwdTime = 0
    m.rewTime = 0
    m.switch = false

     getRadio() 
end sub

sub onVisibleChange()
end sub

sub setScreenSize()
    m.device = CreateObject("roDeviceInfo")
    m.background = m.top.findNode("ionPoster")
    res = m.device.GetDisplaySize().h
    if res = 720
        m.background.uri = "pkg:/images/IonBkgHD.png"
    else if res = 1080
        m.background.uri = "pkg:/images/IonBkgFullHD.png"
    end if
end sub

sub onEpgBackButtonSelected()
    now = m.focusedEpgItem
    m.epgMarkupGrid.jumpToItem = now - 40
    m.focusedEpgItem = now - 40
    m.EpgMarkupGrid.setFocus(true)
    m.EpgBackButton.setFocus(true)
end sub

sub onEpgFwdButtonSelected()
    now = m.focusedEpgItem
    m.epgMarkupGrid.jumpToItem = now + 40
    m.focusedEpgItem = now + 40
    m.EpgMarkupGrid.setFocus(true)
    m.EpgFwdButton.setFocus(true)
end sub

sub onEpgLiveButtonSelected()
    m.firstFocus = true
    m.epgMarkupGrid.jumpToItem = m.epgLive
    m.focusedEpgItem = m.epgLive
    m.EpgMarkupGrid.setFocus(true)
'    m.EpgFwdButton.setFocus(true)
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
    m.allChannels = CreateObject("roSGNode", "ContentNode")
    m.hdCh = CreateObject("roSGNode", "ContentNode")
    m.filmCh = CreateObject("roSGNode", "ContentNode")
    m.sportCh = CreateObject("roSGNode", "ContentNode")
    m.straniCh = CreateObject("roSGNode", "ContentNode")
    m.musicCh = CreateObject("roSGNode", "ContentNode")
    m.kidsCh = CreateObject("roSGNode", "ContentNode")
    m.mojaCh = CreateObject("roSGNode", "ContentNode")

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
'    showChannelGrid(0)
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
        item.hdPosterURL = "pkg:/images/iontvwhite.png"
    end if
    if channel[4] <> invalid
        item.darkLogo = channel[4]
    end if
    if channel[6] <> invalid
        item.maxDelay = channel[6]
    end if

    return item
end function

sub showChannelGrid(chType as Integer)
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    if chType = 0
        m.channelMarkupGrid.content = m.allChannels
    else if chType = 1
        m.channelMarkupGrid.content = m.mojaCh
    else if chType = 2
        m.channelMarkupGrid.content = m.sportCh
    else if chType = 3
        m.channelMarkupGrid.content = m.filmCh
    else if chType = 4
        m.channelMarkupGrid.content = m.musicCh
    end if

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

sub onTopMenuItemSelected()
    if m.topMenu.itemSelected = 1
        m.channelMarkupGrid.visible = false
        if m.EpgBackButton <> invalid
            m.EpgBackButton.visible = false
        end if
        getRadio()
    else
        if m.radioGrid <> invalid then m.radioGrid.visible = false
        showChannelGrid(m.topMenu.itemSelected)
    end if
end sub

sub onTopMenuItemFocused()
end sub

sub onChannelSelected()
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.chidx = m.channelMarkupGrid.itemSelected
    m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
    m.epgMarkupGrid.setFocus(true)
    m.epgMarkupGrid.jumpToItem = m.epgNow
    getEpg(m.chID)
end sub

sub switchChannelUp()
    m.loadingIndicator.text = "Loading..."
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.switch = true
    if m.player.hasFocus() = true
        m.player.control = "stop"
        m.channelMarkupGrid.setFocus(true)
        m.channelMarkupGrid.jumpToItem = (m.channelMarkupGrid.itemFocused + 1)
    end if
    m.chidx = m.channelMarkupGrid.itemFocused
    m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
    m.epgMarkupGrid.setFocus(true)
    m.epgMarkupGrid.jumpToItem = m.epgNow
    getEpg(m.chID)
end sub

sub keyTriggered()
end sub

sub switchChannelDown()
    m.loadingIndicator.text = "Loading..."
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.switch = true
    if m.player.hasFocus() = true
        m.player.control = "stop"
        m.channelMarkupGrid.setFocus(true)
        if m.channelMarkupGrid.itemFocused > 0
            m.channelMarkupGrid.jumpToItem = (m.channelMarkupGrid.itemFocused - 1)
        end if
    end if
    m.chidx = m.channelMarkupGrid.itemFocused
    m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
    m.epgMarkupGrid.setFocus(true)
    m.epgMarkupGrid.jumpToItem = m.epgNow
    getEpg(m.chID)
end sub

sub onChannelFocused()
    m.firstFocus = true
    m.chidx = m.channelMarkupGrid.itemFocused
    m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
    ' getEpg(m.chID)
    m.showTitle.visible = false
    m.showDescription.visible = false
    m.showTime.visible = false
end sub

function getEpg(chid as String)
    m.getEpgTask = CreateObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "GET"
    url = m.epgURL + chid + "/"
    requestData.urlString = url
    requestBody = {}
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.getEpgTask.setField("requestData", requestData)
    m.getEpgTask.observeField("result", "onEpgReceived")
    m.getEpgTask.control = "RUN"
end function

sub onEpgReceived()
    if m.switch = false
        if m.getEpgTask.result <> invalid and m.getEpgTask.result.bodystring <> invalid and m.getEpgTask.result.bodystring <> "[]"
            m.responseBody = ParseJson(m.getEpgTask.result.bodystring)
            if m.responseBody <> invalid
                epg = m.responseBody[m.chID].programme

                if epg.count() = 0
                    epgMockup = [{
                        channelId: m.chID
                        contentId: 00000
                        desc: invalid
                        homegroup: invalid
                        homegroup_order: 0
                        id: 00000000
                        image: "pkg:/images/iontvwhite.png"
                        imageBig: "pkg:/images/iontvwhite.png"
                        start: invalid
                        STOP: invalid
                        title: "Live Program"
                    }]
                end if
                if epg.count() > 0
                    parseEpg(epg)
                else
                    parseEpg(epgMockup)
'        m.channelMarkupGrid.setFocus(true)
'        getChannelUrl(m.chID,0)
                end if
            end if
        end if
    else
        m.switch = false
        if m.getEpgTask.result <> invalid and m.getEpgTask.result.bodystring <> invalid and m.getEpgTask.result.bodystring <> "[]"
            m.responseBody = ParseJson(m.getEpgTask.result.bodystring)
            if m.responseBody <> invalid
                epg = m.responseBody[m.chID].programme
                if epg.count() = 0
                    epgMockup = [{
                        channelId: m.chID
                        contentId: 00000
                        desc: invalid
                        homegroup: invalid
                        homegroup_order: 0
                        id: 00000000
                        image: "pkg:/images/iontvwhite.png"
                        imageBig: "pkg:/images/iontvwhite.png"
                        start: invalid
                        STOP: invalid
                        title: "Live Program"
                    }]
                end if
                if epg.count() > 0
                    parseEpg(epg)
                    getChannelURL(m.chID, 0)
                else
                    parseEpg(epgMockup)
'        m.channelMarkupGrid.setFocus(true)
                    getChannelURL(m.chID, 0)
                end if
            end if
        end if
    end if
end sub

sub onEpgSelected()
    if m.epgMarkupGrid.itemSelected <> invalid
        if m.epgMarkupGrid.itemSelected > 0
            m.showidx = m.epgMarkupGrid.itemSelected
        end if
    end if
    strt = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine1
    stp = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine2
    now = getCurrentTimeSeconds()
    if (strt <> invalid and stp <> invalid) and (strt <> "" or stp <> "") = true
        m.showID = m.epgMarkupGrid.content.getChild(m.chidx).id
        showStart = timeFromIsoStrSeconds(strt)
        showEnd = timeFromIsoStrSeconds(stp)
        showDuration = (showEnd - showStart) / 60
        
        dateObj = CreateObject("roDateTime")
        tzo = dateObj.GetTimeZoneOffset()
        if tzo < ( - 60)
            tzo = tzo + 1560 '1500 when winter time
            else
            tzo = tzo + 120 '60 when winter time
            'TODO Automatically detect daylingt saving time and adjust
        end if
        m.offset = CInt(((now/60) + tzo) - (showStart / 60))
    else
        m.offset = 0
        showDuration = 0
        
    end if
    if m.offset <> invalid and m.offset > showDuration
        getChannelURL(m.chID, m.offset)
    else
        getChannelURL(m.chID, 0)
    end if
end sub

sub showTimeshift()
    m.EpgBackButton.visible = true
    m.EpgDateLabel.visible = true
    m.EpgFwdButton.visible = true
    m.EpgLiveButton.visible = true
end sub

sub hideTimeshift()
    m.EpgBackButton.visible = false
    m.EpgDateLabel.visible = false
    m.EpgFwdButton.visible = false
    m.EpgLiveButton.visible = false
end sub

sub onEpgFocused()
'    m.showidx = m.epgMarkupGrid.itemFocused
'    if m.EpgMarkupGrid.itemFocused > 0
'        if m.firstFocus = true
'            if m.epgMarkupGrid.itemFocused >= 0
'                m.showidx = m.epgMarkupGrid.itemFocused
'                strt = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine1
'                stp = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine2
'                m.showTitle.text = m.epgMarkupGrid.content.getChild(m.showidx).Title
'                showTimeshift()
'                if strt <> invalid and stp <> invalid and strt <> "" and stp <> ""
'                    showStartDate = dateFromIsoStr(strt)
'                    showStartTime = timeFromIsoStr(strt)
'                    showEndTime = timeFromIsoStr(stp)
'                    m.showTime.text = showStartDate + " [" + showStartTime + "-" + showEndTime + "]"
'                    m.EpgDateLabel.text = showStartDate

'                    if m.epgMarkupGrid.content.getChild(m.showidx).description <> invalid
'                        m.showDescription.text = m.epgMarkupGrid.content.getChild(m.showidx).description
'                        m.showDescription.visible = true
'                        m.showTime.visible = true
'                    end if
'                    m.focusedEpgItem = m.epgMarkupGrid.itemFocused
'                    m.showTitle.text = m.epgMarkupGrid.content.getChild(m.showidx).Title
'                    m.showTitle.visible = true
'                end if
'            end if
'            onEpgSelected()
'            m.firstFocus = false
'        end if
'    else
    if m.epgMarkupGrid.itemFocused > 0
        m.showidx = m.epgMarkupGrid.itemFocused
        strt = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine1
        stp = m.epgMarkupGrid.content.getChild(m.showidx).ShortDescriptionLine2
        m.showTitle.text = m.epgMarkupGrid.content.getChild(m.showidx).Title
        showTimeshift()
        if strt <> invalid and stp <> invalid and strt <> "" and stp <> ""
            showStartDate = dateFromIsoStr(strt)
            showStartTime = timeFromIsoStr(strt)
            showEndTime = timeFromIsoStr(stp)
            m.showTime.text = showStartDate + " [" + showStartTime + "-" + showEndTime + "]"
            m.EpgDateLabel.text = showStartDate

            if m.epgMarkupGrid.content.getChild(m.showidx).description <> invalid
                m.showDescription.text = m.epgMarkupGrid.content.getChild(m.showidx).description
                m.showDescription.visible = true
                m.showTime.visible = true
            end if
            m.focusedEpgItem = m.epgMarkupGrid.itemFocused
            m.showTitle.text = m.epgMarkupGrid.content.getChild(m.showidx).Title
            m.showTitle.visible = true
        end if
    else
        m.showidx = 0
        hideTimeshift()
        m.showDescription.visible = false
        m.showTitle.visible = false
        m.showTime.visible = false
    end if
'    end if
end sub

function getRadio()
    m.getRadioTask = CreateObject("roSGNode", "Task_CallAPI")
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
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.getRadioTask.setField("requestData", requestData)
    m.getRadioTask.observeField("result", "onRadioReceived")
    m.getRadioTask.control = "RUN"
end function

sub onRadioReceived()
    if m.getRadioTask.result <> invalid and m.getRadioTask.result.bodystring <> invalid and m.getRadioTask.result.bodystring <> "[]"
        m.responseBody = ParseJson(m.getRadioTask.result.bodystring)
        if m.responseBody <> invalid
            radio = m.responseBody
            parseRadio(radio)
        end if
    end if
end sub

function parseRadio(radio)
    m.allRadio =  CreateObject("roSGNode", "ContentNode")
    m.RadioBH = CreateObject("roSGNode", "ContentNode")
    m.RadioCG = CreateObject("roSGNode", "ContentNode")
    m.RadioHR = CreateObject("roSGNode", "ContentNode")
    m.RadioMK = CreateObject("roSGNode", "ContentNode")
    m.RadioOO = CreateObject("roSGNode", "ContentNode")
    m.RadioSLO = CreateObject("roSGNode", "ContentNode")
    m.RadioSRB = CreateObject("roSGNode", "ContentNode")
    m.radioBH.setField("title", m.langs[m.lng][35])
    m.radioHR.setField("title", m.langs[m.lng][34])
    m.radioCG.setField("title", m.langs[m.lng][38])
    m.radioMK.setField("title", m.langs[m.lng][36])
    m.radioSLO.setField("title", m.langs[m.lng][39])
    m.radioSRB.setField("title", m.langs[m.lng][37])
    m.radioOO.setField("title", m.langs[m.lng][39])

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
    m.radioGrid.observeField("rowItemSelected", "onRadioSelected")
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
    m.errDialog.buttons = [Tr(m.langs[m.lng][9])]
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
' m.top.setFocus(true)
' m.buttons.setFocus(true)
end sub

function playRadio(rurl)
    radioContent = CreateObject("RoSGNode", "ContentNode")
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

function getChannelURL(chid as String, delay as Integer)
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.overhang.visible = false
    m.getContentTask = CreateObject("roSGNode", "Task_CallAPI")
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
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.getContentTask.setField("requestData", requestData)
    m.getContentTask.observeField("result", "onChannelURLReceived")
    m.getContentTask.control = "RUN"
end function

sub onChannelURLReceived()
'    m.loadingIndicator.control = "stop"
'    m.loadingIndicator.visible = "false"
    if m.getContentTask.result <> invalid and m.getContentTask.result.bodystring <> invalid and m.getContentTask.result.bodystring <> "[]"
        m.responseBody = ParseJson(m.getContentTask.result.bodystring)
        if m.responseBody <> invalid
        m.chURL = m.responseBody.channel_url
            if m.responseBody.max <> invalid
            if m.dly > m.responseBody.max
            delay = "&delay=" + m.dly.ToStr()
            goLive = "&delay=1"
            liveUrl = m.chURL.Replace(delay, goLive)
            playChannel(liveUrl)
            else
            playChannel(m.chURL)
            end if
            else
            playChannel(m.chURL)
            end if
'        m.top.contents = m.responseBody
        else
        end if
    end if
end sub

function seekBack()
    m.loadingIndicator.text = ""
    m.loadingIndicator.clockwise = ""
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.shiftDirection.visible = true
    m.shiftLabel.visible = true
    m.rewTime = m.rewTime + 1
    m.shiftDirection.uri = "pkg:/images/rew.png"
    m.shiftLabel.text = "REW " + m.rewTime.ToStr() + " min."
    m.shiftLabel.textColor = "0xEEEEEE"
    playerContent = CreateObject("RoSGNode", "ContentNode")
    oldPosition = m.dly
    newPosition = m.dly + 1
    seekFrom = "&delay=" + oldPosition.ToStr()
    seekTo = "&delay=" + newPosition.ToStr()
    playerContent = CreateObject("RoSGNode", "ContentNode")
    changedUrl = m.chUrl.Replace(seekFrom, seekTo)
    playerContent.Url = changedUrl
    m.player.content = playerContent
    m.player.observeField("state", "onPlayerStateChanged")
    m.player.control = "play"
    m.dly = newPosition
    m.chUrl = changedUrl
end function

function onPlayerStateChanged()
    if m.player.state = "error"
    end if
    if m.player.state = "playing"
        m.fwdTime = 0
        m.rewTime = 0
        m.loadingIndicator.control = "false"
        m.loadingIndicator.visible = "false"
        m.shiftDirection.visible = false
        m.shiftLabel.visible = false
        m.player.visible = true
        m.player.setFocus(true)
    end if
end function

function seekForward()
    m.fwdTime = m.fwdTime + 1
    m.shiftDirection.uri = "pkg:/images/ff.png"
    m.shiftLabel.text = "FWD " + m.fwdTime.ToStr() + " min."
    m.shiftLabel.textColor = "0xEEEEEE"
    m.loadingIndicator.text = ""
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.shiftDirection.visible = true
    m.shiftLabel.visible = true
    oldPosition = m.dly
    newPosition = m.dly - 1
    seekFrom = "&delay=" + oldPosition.ToStr()
    seekTo = "&delay=" + newPosition.ToStr()
    playerContent = CreateObject("RoSGNode", "ContentNode")
    changedUrl = m.chUrl.Replace(seekFrom, seekTo)
'    m.chUrl = m.chUrl+"&seconds=-50"
    playerContent.Url = changedUrl
    m.player.content = playerContent
    m.player.observeField("state", "onPlayerStateChanged")
    m.player.control = "play"
    m.player.visible = "true"
    m.player.setFocus(true)
    m.dly = newPosition
    m.chUrl = changedUrl
end function

function parseEpg(epg)
    m.channelEpg = CreateObject("roSGNode", "ContentNode")
    sh = 0
    for each show in epg
        if show["stop"] <> invalid and show["start"] <> invalid
            if (getCurrentTimeSeconds()) < timeFromIsoStrSeconds(show.STOP) and (getCurrentTimeSeconds()) > timeFromIsoStrSeconds(show.start)
                m.epgNow = sh
            end if
            if (getLiveTimeSeconds()) < timeFromIsoStrSeconds(show.STOP) and (getLiveTimeSeconds()) > timeFromIsoStrSeconds(show.start)
                m.epgLive = sh
            end if
        end if
        sh = sh + 1
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
    if show.STOP <> invalid
        item.ShortDescriptionLine2 = show["stop"]
    end if
'    if show.STOP <> invalid
'        item.length = 3000
'    end if
    return item
end function

function playChannel(chUrl)
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.loadingIndicator.text = "Loading..."
    m.playerContent = CreateObject("RoSGNode", "ContentNode")
    m.content = {
        url:  chUrl
        live: true
    }
    m.playerContent.setFields(m.content)
    m.player.content = m.playerContent
    m.player.EnableTrickPlay = false
    m.player.enableThumbnailTilesDuringLive = false

    m.player.retrievingBarVisibilityAuto = false
    m.player.bufferingBarVisibilityAuto = false
    m.player.retrievingBar.opacity = 1
    m.player.observeField("state", "onPlayerStateChanged")
    m.player.control = "play"
    m.player.setFocus(true)
    m.player.visible = true
end function

function ParseStringToXml(str as String) as Dynamic
    if str = invalid return invalid
    xml = CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
end function

function getCurrentTimeSeconds()
    dateObj = CreateObject("roDateTime")
    localTime = CreateObject("roDateTime")
    tzo = dateObj.GetTimeZoneOffset()
    if tzo < ( - 60)
        tzo = (tzo + 1440)
    end if
    localTime.FromSeconds(dateObj.AsSeconds() - (tzo * 60))
    locTime = localTime.AsSeconds()
    return locTime
end function

function getLiveTimeSeconds()
    dateObj = CreateObject("roDateTime")
    liveTime = dateObj.AsSeconds() + 3600
    return liveTime
end function

function timeFromIsoStrSeconds(timeStr as String)
    isoTmp = ""
    isoTmp = Left(timeStr, 4) + "-" + Mid(timeStr, 5, 2) + "-" + Mid(timeStr, 7, 2) + " " + Mid(timeStr, 9, 2) + ":" + Mid(timeStr, 11, 2) + ":" + Right(timeStr, 2) + ".000"
    tmpDt = CreateObject("roDateTime")
    tmpDt.FromISO8601String(isoTmp)
    return tmpDt.AsSeconds()
end function
function dateFromIsoStr(timeStr as String)
    isoTmp = ""
    isoTmp = Left(timeStr, 4) + "-" + Mid(timeStr, 5, 2) + "-" + Mid(timeStr, 7, 2) + " " + Mid(timeStr, 9, 2) + ":" + Mid(timeStr, 11, 2) + ":" + Right(timeStr, 2) + ".000"
    tmpDt = CreateObject("roDateTime")
    tmpDt.FromISO8601String(isoTmp)
    return tmpDt.AsDateString("short-month-short-weekday")
end function
function timeFromIsoStr(timeStr as String)
    isoTmp = ""
    isoTmp = Mid(timeStr, 9, 2) + ":" + Mid(timeStr, 11, 2)
    return isoTmp
end function
sub setErrColors()
    m.errPalette = CreateObject("roSGNode", "RSGPalette")
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

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "right"
            ? "Right"
            if m.EpgBackButton <> invalid
                if m.EpgBackButton.hasFocus()
                    m.EpgFwdButton.setFocus(true)
                    return true
                end if
            end if
            if m.EpgFwdButton <> invalid
                if m.EpgFwdButton.hasFocus()
                    m.EpgLiveButton.setFocus(true)
                    return true
                end if
            end if
            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    seekForward()
                    return true
                end if
            end if

            return true
        else if key = "left"
            if m.EpgFwdButton <> invalid
                if m.EpgFwdButton.hasFocus()
                    m.EpgBackButton.setFocus(true)
                end if
            end if
            if m.EpgLiveButton <> invalid
                if m.EpgLiveButton.hasFocus()
                    m.EpgFwdButton.setFocus(true)
                end if
            end if

            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    seekBack()
                    return true
                end if
            end if

            ? "Left"
            return true
        else if key = "up"
            ? "Up"
            if m.epgMarkupGrid.hasFocus() = true
                m.channelMarkupGrid.setFocus(true)
                hideTimeshift()
                m.epgMarkupGrid.visible = false
            else if m.channelMarkupGrid.hasFocus() = true
                m.topMenu.setFocus(true)
            else if m.radioGrid <> invalid
                if m.radioGrid.hasFocus() = true then m.topMenu.setFocus(true)
            end if
            if m.EpgBackButton <> invalid and m.EpgBackButton.visible = true
                if m.EpgBackButton.hasFocus()
                    m.EpgMarkupGrid.setFocus(true)
                end if
            end if
            if m.EpgFwdButton <> invalid and m.EpgFwdButton.visible = true
                if m.EpgFwdButton.hasFocus()
                    m.EpgMarkupGrid.setFocus(true)
                end if
            end if
            if m.EpgLiveButton <> invalid and m.EpgLiveButton.visible = true
                if m.EpgLiveButton.hasFocus()
                    m.EpgMarkupGrid.setFocus(true)
                end if
            end if
            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    switchChannelUp()
                    return true
                end if
            end if
            return true
        else if key = "down"
            if m.topMenu.hasFocus() = true
                if m.topMenu.itemFocused = 1
                    hideTimeshift()
                    if m.channelMarkupGrid <> invalid then m.channelMarkupGrid.visible = false
                    getRadio()
                else
                    if m.radioGrid <> invalid then m.radioGrid.visible = false
                    showChannelGrid(m.topMenu.itemFocused)
                end if
            end if

            if m.channelMarkupGrid.hasFocus() = true
                m.chidx = m.channelMarkupGrid.itemFocused
                m.chID = m.channelMarkupGrid.content.getChild(m.chidx).id
'               m.channelMarkupGrid.setFocus(true)
                getEpg(m.chID)
            end if
            if m.EpgMarkupGrid.hasFocus() = true
                m.EpgBackButton.setFocus(true)
                return true
            end if
            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    switchChannelDown()
                    return true
                end if
            end if

            ? "Down"

            return true
        else if key = "back"
            if m.EpgMarkupGrid.hasFocus() = true
                m.EpgMarkupGrid.visible = false
                hideTimeshift()
                m.channelMarkupGrid.setFocus(true)
                return true
            else if m.channelMarkupGrid.hasFocus() = true
                m.topMenu.setFocus(true)
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
        else if key = "rewind"
            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    seekBack()
                    return true
                end if
            end if

            return true
        else if key = "fastforward"
            if m.player <> invalid
                if m.player.hasFocus() = true
                    m.player.control = "pause"
                    seekForward()
                    return true
                end if
            end if

            return true
        else if key = "play"
            if m.player <> invalid
                if m.player.hasFocus() = true
                    if m.player.state = "playing"
                        m.player.control = "pause"
                    else if m.player.state = "paused" or m.player.state = "stopped"
                        m.player.control = "play"

                        return true
                    end if
                end if
            end if

            return true
        end if
    end if
    return result
end function