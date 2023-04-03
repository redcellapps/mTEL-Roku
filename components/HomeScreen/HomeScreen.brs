' ********** Copyright Red Cell Apps 2022.  All Rights Reserved. **********

sub Init()
    setURLs()
    m.BaseRegister = CreateObject("roRegistrySection", "auth")
    m.langBase = CreateObject("roSGNode", "Localization")
    m.LoginScreen = CreateObject("roSGNode", "LoginScreen")
    m.langs = m.langBase.langs
    m.top.ObserveField("visible", "OnVisibleChange")
    m.myPhoneNum = ""
    m.token = m.BaseRegister.Read("token")
    m.lng = m.BaseRegister.Read("langCode").ToInt()
    m.goToScreen = m.top.findNode("goToScreen")
    m.searchContent = m.top.findNode("searchContent")
    m.welcomeLabel = m.top.findNode("welcome")
    m.welcomeLabel.Text = m.langs[m.lng][53]
    m.guideText = m.top.findNode("welcomeText")
    setScreenSize()
    m.keyType = ""
    m.kbdDialog = m.top.findNode("dialog")
    m.kbdDialog.buttons = ["OK", "Cancel"]
    m.kbdDialog.observeField("buttonSelected", "keyboardDialogAction")
    m.kbdDialog.visible = false
    setColors()
    m.buttons = m.top.findNode("homeBtnGrp")
    m.buttons.focusButton = 1
    m.buttons.visible = true
    m.buttons.observeField("buttonSelected", "onButtonSelected")
    m.buttons.observeField("buttonFocused", "onButtonFocused")
    m.guideText.text = m.langs[m.lng][24]
    m.backCount = 0
    setButtonLang()
    m.appex = m.LoginScreen.findNode("appExit")
end sub

sub logout()
    showLogoutConfirm()
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

sub showLogoutConfirm()
    m.logoutDialog = m.top.findNode("searchmessagedialog")
    setErrColors()
    m.logoutDialog.palette = m.errPalette
    m.logoutDialog.title = "Logout"
    m.logoutDialog.message = ["Do you really want to logout?"]
    m.logoutDialog.buttons = [Tr("Yes"), Tr("No")]
    m.logoutDialog.setFocus(true)
    m.logoutDialog.visible = true
    m.logoutDialog.observeFieldScoped("buttonSelected", "onLogoutDialog")
    m.logoutDialog.observeFieldScoped("wasClosed", "logoutDialogClosedChanged")
end sub
sub showExitConfirm()
    m.exitDialog = m.top.findNode("searchmessagedialog")
    setErrColors()
    m.exitDialog.palette = m.errPalette
    m.exitDialog.title = "Exit iON App"
    m.exitDialog.message = ["Do you really want to Exit?"]
    m.exitDialog.buttons = [Tr("Exit"), Tr("No")]
    m.exitDialog.setFocus(true)
    m.exitDialog.visible = true
    m.exitDialog.observeFieldScoped("buttonSelected", "onExitDialog")
    m.exitDialog.observeFieldScoped("wasClosed", "logoutDialogClosedChanged")
end sub

sub onExitDialog()
    if m.exitDialog.buttonSelected = 0
        m.top.appExit = true
        m.appex = true
    else if m.exitDialog.buttonSelected = 1
        m.exitDialog.visible = false
        m.buttons.setFocus(true)
    end if
end sub

sub onLogoutDialog()
    if m.logoutDialog.buttonSelected = 0
        m.top.appExit = true
        m.appex = true
        m.baseRegister.Delete("token")
        m.BaseRegister.Delete("lang")
        m.BaseRegister.Delete("langCode")
        m.BaseRegister.Delete("landTo")
        m.BaseRegister.Flush()
    else if m.logoutDialog.buttonSelected = 1
        m.logoutDialog.visible = false
        m.buttons.setFocus(true)
    end if
end sub

sub logoutDialogClosedChanged()
end sub

sub showSearchErr()
    m.searchErr = m.top.findNode("searchmessagedialog")
    setErrColors()
    m.searchErr.palette = m.errPalette
    m.searchErr.title = "Nema razultata..."
    m.searchErr.message = "Pokusajte ponovo..."
    m.searchErr.buttons = [Tr("ok")]
    m.searchErr.setFocus(true)
    m.searchErr.visible = true
    m.searchErr.observeFieldScoped("buttonSelected", "dismissSearchDialog")
    m.searchErr.observeFieldScoped("wasClosed", "searchDialogClosedChanged")
end sub

sub dismissSearchDialog()
    m.searchErr.visible = false
    m.searchDialog.setFocus(true)
end sub
sub searchErrClosedChanged()
end sub

' =========
sub setURLs()
    m.baseURL = "https://api.go4yucalling.com/api/"
    m.countriesURL = m.baseURL + "signup/countries-tv"
    m.registerURL = m.baseURL + "signup/gss-new"
    m.activationURL = m.baseURL + "signup/gss-activate"
    m.loginURL = "https://arenacloud.ott.solutions/login"
    m.channelsURL = "https://arenacloud.ott.solutions/channels/get_list_double_singles/tv.json"
end sub

sub setColors()
    m.kbdPalette = CreateObject("roSGNode", "RSGPalette")
    m.kbdPalette.colors = {
        DialogBackgroundColor: "#364452",
        DialogItemColor: "0x#E4E4E4",
        DialogTextColor: "#0E2B47",
        DialogFocusColor: "#E12F2D",
        DialogFocusItemColor: "#E4E4E4",
        DialogSecondaryTextColor: "#FFFFFF",
        DialogSecondaryItemColor: "#FFFFFF",
        DialogInputFieldColor: "#FFFFFFFF",
        DialogKeyboardColor: "#E4E4E4",
        DialogFootprintColor: "#EFEFEFEF"
    }
    m.kbdDialog.palette = m.kbdPalette
end sub

sub onVisibleChange() ' invoked when GridScreen change visibility
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.buttons.focusButton = 1
        m.welcomeLabel.text = m.langs[m.lng][0]
    end if
end sub

function dummyFunc()
end function
sub setButtonLang()
    butt = m.buttons.findNode("tvButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][53]
    butt = m.buttons.findNode("searchButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][30]
' butt= m.buttons.findNode("HomeButton")
' butt.getChild(4).blendColor = -1
' butt.text = m.langs[m.lng][31]
    butt = m.buttons.findNode("radioButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][32]
    butt = m.buttons.findNode("videoButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][33]
    butt = m.buttons.findNode("languageButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][41]
    butt = m.buttons.findNode("logoutButton")
    butt.getChild(4).blendColor = - 1
    butt.text = m.langs[m.lng][40]
end sub

sub onButtonSelected()
    if m.buttons.buttonSelected = 0 then
        if m.top.gotoScreen = 5 then m.top.goToScreen = 555 else m.top.goToScreen = 5
'        searchScreen()
'      if m.top.gotoScreen = 99 then m.top.goToScreen = 999 else m.top.goToScreen = 99
    else if m.buttons.buttonSelected = 1 then
        if m.top.gotoScreen = 1 then m.top.goToScreen = 111 else m.top.goToScreen = 1
    else if m.buttons.buttonSelected = 2 then
        m.BaseRegister.Write("landTo", "tv")
        if m.top.gotoScreen = 2 then m.top.goToScreen = 222 else m.top.goToScreen = 2
    else if m.buttons.buttonSelected = 3 then
        m.BaseRegister.Write("landTo", "radio")
        if m.top.gotoScreen = 3 then m.top.goToScreen = 333 else m.top.goToScreen = 3
    else if m.buttons.buttonSelected = 4 then
        showLanguageSelector()
'      if m.top.gotoScreen = 4 then m.top.goToScreen = 444 else m.top.goToScreen = 4
    else if m.buttons.buttonSelected = 5 then
        logout()
      
    else if m.buttons.buttonSelected = 6 then
'        logout()
'      if m.top.gotoScreen = 6 then m.top.goToScreen = 666 else m.top.goToScreen = 6
    end if
end sub

sub showLanguageSelector()
    m.welcomeLabel.visible = false
    m.guideText.visible = false
    m.languageSelector =  m.top.findNode("selectLanguageList")
    m.languageSelector.focusBitmapUri = "pkg:/images/BlankButton.png"
    m.languageSelector.visible = true
    m.languageSelector.setFocus(true)
    m.languageSelector.observeField("itemSelected", "onLanguageSelected")

    langList = [
        {
            title: "English",
            HDLISTITEMICONSELECTEDURL: "pkg:/images/CountryIcons/uk2.png"
        }
        {
            title: "Croatian",
            HDLISTITEMICONSELECTEDURL: "pkg:/images/CountryIcons/cro2.png"
        }
        {
            title: "Bosnian",
            HDLISTITEMICONSELECTEDURL: "pkg:/images/CountryIcons/bih2.png"
        }
        { title: "Macedonian",
            HDLISTITEMICONSELECTEDURL: "pkg:/images/CountryIcons/mcd2.png"
        }
        { title: "Serbian",
            HDLISTITEMICONSELECTEDURL: "pkg:/images/CountryIcons/srb2.png"
    }]

    langNode = CreateObject("roSGNode", "ContentNode")
    for each item in langList:
        nod = CreateObject("roSGNode", "ContentNode")
        nod.setFields(item)
        langNode.appendChild(nod)
    next
    m.languageSelector.content = langNode
end sub

sub onLanguageSelected()
    langIdx =  m.languageSelector.itemSelected
    if langIdx = 0
        m.lang = "HR"
        m.lng = 1
    else if langIdx = 1
        m.lang = "HR"
        m.lng = 2
    else if langIdx = 2
        m.lang = "BS"
        m.lng = 0
    else if langIdx = 3
        m.lang = "MK"
        m.lng = 3
    else if langIdx = 4
        m.lang = "SR"
        m.lng = 0
    end if
    m.languageSelector.visible = false
    m.buttons.setFocus(true)
    m.welcomeLabel.visible = true
    m.guideText.visible = true
    onButtonFocused()
    m.welcomeLabel.text = m.langs[m.lng][0]
    setButtonLang()
    m.BaseRegister.Write("lang", m.lang)
    m.BaseRegister.Write("langCode", m.lng.ToStr())
end sub

sub onButtonFocused()
    if m.buttons.buttonFocused = 0 then
        m.welcomeLabel.text = m.langs[m.lng][30]
        m.guideText.text = m.langs[m.lng][25]
    else if m.buttons.buttonFocused = 1 then
        m.welcomeLabel.text = m.langs[m.lng][53]
        m.guideText.text = m.langs[m.lng][24]
    else if m.buttons.buttonFocused = 2 then
        m.welcomeLabel.text = m.langs[m.lng][32]
        m.guideText.text = m.langs[m.lng][27]
    else if m.buttons.buttonFocused = 3 then
        m.welcomeLabel.text = m.langs[m.lng][33]
        m.guideText.text = m.langs[m.lng][28]
    else if m.buttons.buttonFocused = 4 then
        m.welcomeLabel.text = m.langs[m.lng][41]
        m.guideText.text = m.langs[m.lng][51]
    else if m.buttons.buttonFocused = 5 then
        m.welcomeLabel.text = m.langs[m.lng][40]
        m.guideText.text = m.langs[m.lng][52]
    end if
end sub

function GetContent()
    m.getContentTask = CreateObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.channelsURL
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.getContentTask.setField("requestData", requestData)
    m.getContentTask.observeField("result", "onContentReceived")
    m.getContentTask.control = "RUN"
end function

sub onContentReceived()
    if m.getContentTask.result <> invalid and m.getContentTask.result.bodystring <> invalid
        m.responseBody = ParseJson(m.getContentTask.result.bodystring)
        if m.responseBody <> invalid
            m.top.contents = m.responseBody
        end if
    end if
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

function ParseStringToXml(str as String) as Dynamic
    if str = invalid return invalid
    xml = CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
end function

function getCurrentTimestampInMillis()
    dateObj = CreateObject("roDateTime")
    currentSeconds = dateObj.AsSeconds()
    m& = 1000
    currentMilliseconds = currentSeconds * m&
    ms = currentMilliseconds + dateObj.GetMilliseconds()
    return ms
end function

function OnkeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "back"
            m.backCount += 1
            if m.backCount = 2
                showExitConfirm()
                m.backCount = 0
            end if
            return true
        else
            return false
        end if
    end if
end function