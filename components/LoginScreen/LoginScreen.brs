' ********** Copyright Red Cell Apps 2022.  All Rights Reserved. **********

sub Init()
    setURLs()
    m.BaseRegister = CreateObject("roRegistrySection", "auth")
    m.top.observeField("momo", "dummyFunc")
    m.top.ObserveField("visible", "OnVisibleChange")
    m.username = ""
    m.password = ""
    m.myPhoneNum = ""
    m.token = ""
    m.keyType = ""
    m.welcomeLabel = m.top.findNode("welcome")
    m.guideText = m.top.findNode("welcomeText")
    m.guideText1 = m.top.findNode("welcomeText1")
    m.guideText2 = m.top.findNode("welcomeText2")
    m.guideText.text = ""
    setWelcomeText()
    setScreenSize()

    m.kbdDialog = m.top.findNode("dialog")
    m.kbdDialog.buttons = ["OK", "Cancel"]
    m.kbdDialog.observeField("buttonSelected", "keyboardDialogAction")
    m.kbdDialog.visible = false
    setColors()
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    m.buttons = m.top.findNode("btnGrp")
    m.buttons.observeField("buttonSelected", "onButtonSelected")
    m.buttons.observeField("buttonFocused", "onButtonFocused")

    m.flagButtons = m.top.findNode("flagBtnGrp")
    m.flagButtons.focusButton = 2
    m.flagButtons.observeField("buttonSelected", "onFlagButtonSelected")
    m.flagButtons.observeField("buttonFocused", "onFlagButtonFocused")
    fixButtons()
    m.lng = 0
    m.blockKey = false
    checkToken()
    m.langBase = CreateObject("roSGNode", "Localization")
    m.langs = m.langBase.langs
    m.welcomeLabel.Text = "Welcome"
end sub

sub setWelcomeText()
    m.welcomeLabel.Text = "Dobro došli"
    m.guideText.text = "Dobro došli  na iON.tv – da bi bili u toku sa svime iz Hrvatske"
    m.guideText1.text = "Uživajte u omiljenim programima iz 'Lijepe Naše' domovine!"
    m.guideText2.text = "Sretno uz kvlitetnu sliku i glas od nas!"
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

sub checkToken()
    m.blockKey = true
    m.flagButtons.visible = false
    m.flagButtons.setFocus(false)
    m.welcomeLabel.setFocus(true)
    if m.BaseRegister.Exists("token")
        if m.BaseRegister.Exists("lang")
            m.lang = m.BaseRegister.Read("lang")
        else
            m.flagButtons.visible = true
            m.flagButtons.setFocus(true)
            m.flagButtons.focusButton = 2
        end if
        m.token = m.BaseRegister.Read("token")
        if m.token <> invalid
            if m.token <> ""
                m.loadingIndicator.control = "start"
                m.loadingIndicator.visible = "true"
                GetContent()
            else
                m.blockKey = false
                m.flagButtons.visible = true
                m.flagButtons.setFocus(true)
                m.flagButtons.focusButton = 2
            end if
        end if
    else
        m.blockKey = true
        m.flagButtons.visible = true
        m.flagButtons.setFocus(true)
        m.flagButtons.focusButton = 2
    end if
end sub

sub setURLs()
    m.baseURL = "https://api.go4yucalling.com/api/"
    m.countriesURL = m.baseURL + "signup/countries-tv"
    m.registerURL = m.baseURL + "signup/gss-new"
    m.activationURL = m.baseURL + "signup/gss-activate"
    m.loginURL = "https://api.gss-media.com/login"
    m.channelsURL = "https://api.gss-media.com/channels/get_list_double_singles/tv.json"
    m.baseURL = "https://api.gss-media.com/login"
end sub

sub onVisibleChange()
    if m.top.visible = true
        m.buttons.visible = false
        m.flagButtons.visible = true
        m.flagButtons.SetFocus(true)
        m.flagButtons.focusButton = 2
    end if
end sub

sub onButtonSelected()
    if m.buttons.buttonSelected = 0 then
        if m.token <> invalid and m.token <> ""
            GetContent()
        else
            showLoginDialog()
        end if
    else if m.buttons.buttonSelected = 1 then
'        signUp()
        showSignUpInstructions()
    end if
end sub

sub onButtonFocused()
    if m.buttons.buttonFocused = 0 then
        m.welcomeLabel.text = m.langs[m.lng][1]
        m.guideText.text = m.langs[m.lng][10]' "Logujte se u postojeći nalog tako što će te uneti svoje korisničko ime (broj) i lozinku"
    else if m.buttons.buttonFocused = 1 then
        m.welcomeLabel.text = m.langs[m.lng][2]
        m.guideText.text = m.langs[m.lng][44]' "Da se pretplatite ili aktivirate vasu pretplatu pozovite nas na sledece brojeve telefona Amerika: 1.888.768.3862, Australia: 1300.138.390 ili posetite www.ion.tv "
    end if
end sub

sub onFlagButtonSelected()
    m.guideText1.text = ""
    m.guideText2.text = ""
    if m.flagButtons.buttonSelected = 0 then
        m.lang = "HR"
        m.lng = 1
    else if m.flagButtons.buttonSelected = 1 then
        m.lang = "BS"
        m.lng = 0
    else if m.flagButtons.buttonSelected = 2 then
        m.lang = "HR"
        m.lng = 2
    else if m.flagButtons.buttonSelected = 3 then
        m.lang = "MK"
        m.lng = 3
    else if m.flagButtons.buttonSelected = 4 then
        m.lang = "SR"
        m.lng = 0
    end if

    m.welcomeLabel.Text = m.langs[m.lng][1]
    m.guideText.text = m.langs[m.lng][10]
    m.BaseRegister.Write("lang", m.lang)
    m.BaseRegister.Write("langCode", m.lng.ToStr())
    m.flagButtons.visible = false
    setLoginButtons()
    m.buttons.visible = true
    m.buttons.setFocus(true)
end sub
sub fixButtons()
    butt = m.flagButtons.findNode("croButton")
    butt.getChild(4).blendColor = - 1
    butt = m.flagButtons.findNode("engButton")
    butt.getChild(4).blendColor = - 1
    butt = m.flagButtons.findNode("mkButton")
    butt.getChild(4).blendColor = - 1
    butt = m.flagButtons.findNode("srButton")
    butt.getChild(4).blendColor = - 1
    butt = m.flagButtons.findNode("baButton")
    butt.getChild(4).blendColor = - 1
end sub

sub setLoginButtons()
    butt = m.buttons.findNode("LoginButton")
    butt.text = m.langs[m.lng][1]
    butt = m.buttons.findNode("ContactButton")
    butt.text = m.langs[m.lng][2]
end sub

sub onFlagButtonFocused()
    if m.flagButtons.buttonFocused = 0 then
        m.welcomeLabel.Text = "Welcome"
        m.guideText.text = "Welcome to iON.tv, your eye on Croatia"
        m.guideText1.text = "Enjoy your favorite programming from your homeland."
        m.guideText2.text = "Happy Streaming!"
    else if m.flagButtons.buttonFocused = 1 then
        m.welcomeLabel.Text = "Dobro došli"
        m.guideText.text = "Dobro došli u iON.tv, vaš prozor u Bosnu i Hercegovinu"
        m.guideText1.text = "Uživajte u vašem omiljenom TV progamu iz domovine!"
        m.guideText2.text = "U zdravlju gledali!"
    else if m.flagButtons.buttonFocused = 2 then
        m.welcomeLabel.Text = "Dobro došli"
        m.guideText.text = "Dobro došli  na iON.tv – da bi bili u toku sa svime iz Hrvatske"
        m.guideText1.text = "Uživajte u omiljenim programima iz 'Lijepe Naše' domovine!"
        m.guideText2.text = "Sretno uz kvalitetnu sliku i glas od nas!"
    else if m.flagButtons.buttonFocused = 3 then
        m.welcomeLabel.Text = "Добредојдовте"
        m.guideText.text = "Добредојдовте во iON.tv, вашето око на Македонија"
        m.guideText1.text = "Уживај во омиленото програмирање од твојата татковина."
        m.guideText2.text = "Среќен стрим!"
    else if m.flagButtons.buttonFocused = 4 then
        m.welcomeLabel.Text = "Dobro došli"
        m.guideText.text = "Dobro došli u iON.tv, vaš prozor u Srbiju"
        m.guideText1.text = "Uživajte u vašim omiljenim TV kanalima iz zavičaja!"
        m.guideText2.text = "U zdravlju gledali!"
    end if
end sub

sub signUp()
end sub

' sub showSignUpInstructions()
' m.aboutUS = m.top.findNode("aboutUs")
' setErrColors()
' m.aboutUS.getChild(2).getChild(1).text = m.langs[m.lng][4]
' m.aboutUS.getChild(2).getChild(2).text = m.langs[m.lng][5]
' m.aboutUS.getChild(2).getChild(3).text = m.langs[m.lng][6]
' m.aboutUS.getChild(2).getChild(4).text = m.langs[m.lng][7]
' m.aboutUS.getChild(2).getChild(5).text = m.langs[m.lng][8]
' m.aboutUS.title = m.langs[m.lng][3]
' m.aboutUS.setFocus(true)
' m.aboutUS.visible = true
' m.aboutUS.setFocus(true)
' m.buttonArea = m.aboutUS.findNode("buttonArea")
' m.buttonArea.setFocus(true)
' m.aboutUS.observeFieldScoped("buttonFocused", "onAboutButtonFocused")
' m.aboutUS.observeFieldScoped("buttonSelected", "onAboutButtonSelected")
' m.aboutUS.observeFieldScoped("wasClosed", "wasClosedChanged")
' end sub

' sub onAboutButtonFocused()
' ? 
' end sub

' Sub onAboutButtonSelected()
' m.aboutUS.visible = false
' m.buttons.setFocus(true)
' end sub

sub showSignUpInstructions()
    m.aboutUS = m.top.findNode("aboutUs")
    setErrColors()
    m.aboutUS.palette = m.errPalette
    m.aboutUS.setFocus(true)
    m.aboutUS.visible = true
    m.buttonArea = m.aboutUS.findNode("buttonArea")
    m.aboutUS.observeFieldScoped("buttonFocused", "onAboutButtonFocused")
    m.aboutUS.observeFieldScoped("buttonSelected", "onAboutButtonSelected")
    m.aboutUS.observeFieldScoped("wasClosed", "wasClosedChanged")
end sub
sub onAboutButtonFocused()
end sub

sub onAboutButtonSelected()
    m.aboutUS.visible = false
    m.buttons.setFocus(true)
end sub

sub wasClosedChanged()
end sub

sub enterUsername()
    m.keyType = "username"
    m.kbdDialog.text = ""
    m.kbdDialog.title = m.langs[m.lng][16]' "Molimo vas unesite vase korisničko ime"
    m.kbdDialog.message = [m.langs[m.lng][17]]' ["Unesite broj (10 cifara) koji ste dobili prilikom registracije u formatu XXXXXXXXXX"]
    m.kbdDialog.visible = true
    m.kbdDialog.setFocus(true)
end sub
sub enterPassword()
    m.keyType = "password"
    m.kbdDialog.text = ""
    m.kbdDialog.title = m.langs[m.lng][21]' "Molimo vas unesite sifru naloga"
    m.kbdDialog.message = [m.langs[m.lng][22]]' ["Unesite broj (8 cifara) koji ste dobili prilikom registracije u formatu XXXXXXXX"]
    m.kbdDialog.visible = true
    m.kbdDialog.setFocus(true)
end sub

sub showLoginDialog()
    enterUsername()
end sub

sub loginUser()
    m.loginUserTask = CreateObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.loginUrl
    requestData.urlString = url
    requestBody = {}
    requestBody["login"] = m.username' "0038163431591""8887683862"
    requestBody["password"] = m.password' "test2022""11112022"
    requestBody["type"] = "smarttv"
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.loginUserTask.setField("requestData", requestData)
    m.loginUserTask.observeField("result", "onUserLoggedIn")
    m.loginUserTask.control = "RUN"
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
'    end if
end sub

sub onUserLoggedIn()
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    if m.loginUserTask.result <> invalid and m.loginUserTask.result.bodystring <> invalid
        m.responseBody = ParseStringToXml(m.loginUserTask.result.bodystring)
        if m.responseBody.error.message.getText() <> "Pogrešan broj telefona i/ili lozinka." or m.responseBody.error.message.getText() <> "Drugi uređaj je izlogovan"
            if m.responseBody.sid.GetText() <> invalid
                if m.responseBody.sid.GetText() <> ""
                    m.token = m.responseBody.sid.GetText()
                    m.top.token = m.token
                    m.BaseRegister.Write("token", m.token)
                    m.BaseRegister.Flush()
                    GetContent()
                else
                    m.loginErrorMessage = m.responseBody.error.message.getText()
                    showError(m.langs[m.lng][42])' "Pogresno korisnicko ime i/ili sifra naloga", "Molimo vas pokusajte ponvo.")   
                end if
            end if
        else
            m.loginErrorMessage = m.responseBody.error.message.getText()
            showError(m.langs[m.lng][42])' "Pogresno korisnicko ime i/ili sifra naloga", "Molimo vas pokusajte ponvo.")        
        end if
    end if
end sub

sub showError(titl = invalid, message = invalid)
    m.errDialog = m.top.findNode("messagedialog")
    setErrColors()
    m.errDialog.palette = m.errPalette
    m.errDialog.title = titl
    m.errDialog.message = [message]
    m.errDialog.buttons = [Tr("Ok")]
    m.errDialog.setFocus(true)
    m.errDialog.visible = true
    m.errDialog.observeFieldScoped("buttonSelected", "dismissErrDialog")
    m.errDialog.observeFieldScoped("wasClosed", "errClosedChanged")
end sub
sub dismissErrDialog()
    m.errDialog.visible = false
    m.kbdDialog.visible = true
    m.kbdDialog.setFocus(true)
end sub
sub errClosedChanged()
' m.top.setFocus(true)
' m.buttons.setFocus(true)
end sub

function GetContent()
    m.blockKey = true
    m.flagButtons.visible = false
    m.flagButtons.setFocus(false)
    m.welcomeLabel.setFocus(true)
    m.getContentTask = CreateObject("roSGNode", "Task_CallAPI")
    requestData = {}
    requestData.httpMethodString = "POST"
    url = m.channelsURL
    requestData.urlString = url
    requestBody = {}
    requestBody["sid"] = m.token
    requestBody["sid_name"] = "token"
    requestBody["lang"] = m.lang
    requestData.postBodyString = FormatJson(requestBody)
    requestData.headersAssociativeArray = { "Content-Type": "application/json" }
    m.getContentTask.setField("requestData", requestData)
    m.getContentTask.observeField("result", "onContentReceived")
    m.getContentTask.control = "RUN"
    m.loadingIndicator.control = "start"
    m.loadingIndicator.visible = "true"
    m.loadingIndicator.setFocus(true)
end function

sub onContentReceived()
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = "false"
    if m.getContentTask.result <> invalid and m.getContentTask.result.bodystring <> invalid and m.getContentTask.result.bodystring <> "[]"
        m.responseBody = ParseJson(m.getContentTask.result.bodystring)
        if m.responseBody <> invalid and m.responseBody.count() > 0
            m.top.contents = m.responseBody
        else
            m.blockKey = false
            m.flagButtons.visible = true
            m.flagButtons.setFocus(true)
            m.flagButtons.focusButton = 2
            m.buttons.visible = false
            m.token = invalid
            m.baseRegister.Delete("token")
            m.BaseRegister.Delete("lang")
            m.BaseRegister.Delete("langCode")
            m.BaseRegister.Delete("landTo")
            m.BaseRegister.Flush()
        end if
    else
        m.blockKey = false
        m.flagButtons.visible = true
        m.flagButtons.setFocus(true)
        m.flagButtons.focusButton = 2
        m.buttons.visible = false
        m.token = ""
        m.baseRegister.Delete("token")
        m.BaseRegister.Delete("lang")
        m.BaseRegister.Delete("langCode")
        m.BaseRegister.Delete("landTo")
        m.BaseRegister.Flush()
    end if
end sub

sub keyboardDialogAction()
'    if m.keyType = "phone"
'    if m.kbdDialog.buttonSelected = 0 then
'        m.regex1 = CreateObject("roRegex", "[0-9]+")
'            if (not m.regex1.IsMatch(m.kbdDialog.text)) then
'                m.kbdDialog.title = "Please input at least 8 characters with at least one capital, one special sign and one number."
'            else
'        m.myPhoneNum = m.kbdDialog.text
'        m.kbdDialog.visible = false
'        registerUser()
'        addOtp()

'    end if
'    else if m.kbdDialog.buttonSelected = 1 then
'        m.kbdDialog.visible = false
'        m.buttons.setFocus(true)
'    end if
'    else if m.keyType = "otp"
'    if m.kbdDialog.buttonSelected = 0 then
'        m.regex1 = CreateObject("roRegex", "[0-9]+", "i")
'            if (not m.regex1.IsMatch(m.kbdDialog.text)) then
'                m.kbdDialog.title = "Please input at least 8 characters with at least one capital, one special sign and one number."
'            else
'        m.myOtp = m.kbdDialog.text
'        m.kbdDialog.visible = false
'        m.buttons.setFocus(true)
'        activateUser()

'    end if
'    else if m.kbdDialog.buttonSelected = 1 then
'        m.kbdDialog.visible = false
'        m.buttons.setFocus(true)
'    end if
    if m.keyType = "username"
        if m.kbdDialog.buttonSelected = 0 then
            m.regex1 = CreateObject("roRegex", "(?<!\d)\d{10}(?!\d)", "{g}")
            if ( not m.regex1.IsMatch(m.kbdDialog.text)) then
                showError(m.langs[m.lng][20], m.langs[m.lng][17])
            else
                m.username = m.kbdDialog.text
                m.kbdDialog.visible = false
                m.buttons.setFocus(true)
                enterPassword()
            end if
        else if m.kbdDialog.buttonSelected = 1 then
            m.kbdDialog.visible = false
            m.buttons.setFocus(true)
        end if
    else if m.keyType = "password"
        if m.kbdDialog.buttonSelected = 0 then
            m.regex1 = CreateObject("roRegex", "(?<!\d)\d{8}(?!\d)", "{g}")
            if ( not m.regex1.IsMatch(m.kbdDialog.text)) then
                showError(m.langs[m.lng][23], m.langs[m.lng][22])
            else
                m.password = m.kbdDialog.text
                m.kbdDialog.visible = false
                m.buttons.setFocus(true)
                loginUser()
            end if
        else if m.kbdDialog.buttonSelected = 1 then
            m.kbdDialog.visible = false
            m.buttons.setFocus(true)
        end if
    end if
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

sub setColors()
    m.kbdPalette = CreateObject("roSGNode", "RSGPalette")
    m.kbdPalette.colors = {
        DialogBackgroundColor: "#364452",
        DialogItemColor: "0xE4E4E4",
        DialogTextColor: "0xEEEEEE",
        DialogFocusColor: "0xE12F2D",
        DialogFocusItemColor: "0xEEEEEE",
        DialogSecondaryTextColor: "0xFFFFFF",
        DialogSecondaryItemColor: "0xFFFFFF",
        DialogInputFieldColor: "0xFFFFFFFF",
        DialogKeyboardColor: "0xaaaaaa",
        DialogFootprintColor: "0xEFEFEFEF"
    }
    m.kbdDialog.palette = m.kbdPalette
end sub

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

function dummyFunc()
end function

function OnkeyEvent(key as String, press as Boolean) as Boolean
    if m.blockKey = true
        return true
    else
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
                ? "Back"
                return true
            end if
        end if
        return result
    end if
end function

' ============= UNUSED METHODS (FOR FUTURE USE)=================

' Function activateUser()
'   m.activateUserTask = createObject("roSGNode", "Task_CallAPI")
'    requestData = {}
'    requestData.httpMethodString = "POST"
'    url = m.activationURL
'    requestData.urlString = url
'    requestBody = {}
'    requestBody["MSISDN"] = m.myphoneNum
'    requestBody["platform"] = "arena"
'    requestBody["code"] = m.myOtp
'    requestData.postBodyString = FormatJson(requestBody)
'    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
'    m.activateUserTask.setField("requestData", requestData)
'    m.activateUserTask.observeField("result","onUserActivated")
'    m.activateUserTask.control = "RUN"
'    m.loadingIndicator.control = "start"
'    m.loadingIndicator.visible = "true"
'    end if
' end function

' sub onUserActivated()
'    m.loadingIndicator.control = "stop"
'    m.loadingIndicator.visible = false
' if m.activateUserTask.result <> invalid and m.activateUserTask.result.bodystring <> invalid
'        m.responseBody = parseJson(m.activateUserTask.result.bodystring)
'        if m.responseBody<> invalid
'        loginUser()
'        end if      
' end if
' end sub

' Function registerUser()
'    m.registerTask = createObject("roSGNode", "Task_CallAPI")
'    requestData = {}
'    requestData.httpMethodString = "POST"
'    url = m.registerURL
'    requestData.urlString = url
'    requestBody = {}
'    requestBody["MSISDN"] = m.myphoneNum
'    requestBody["platform"] = "arena"
'    requestData.postBodyString = FormatJson(requestBody)
'    requestData.headersAssociativeArray = {"Content-Type" : "application/json"}
'    m.registerTask.setField("requestData", requestData)
'    m.registerTask.observeField("result","onRegResponseReceived")
'    m.registerTask.control = "RUN"
'    m.loadingIndicator.control = "start"
'    m.loadingIndicator.visible = "true"
'    end if
' End Function

' sub onRegResponseReceived()
' m.loadingIndicator.control = "stop"
' m.loadingIndicator.visible = "false"
' if m.registerTask.result <> invalid and m.registerTask.result.bodystring <> invalid
'        m.responseBody = parseJson(m.registerTask.result.bodystring)
'        if m.responseBody<> invalid
'        if m.responseBody["msg"]["en"] = "Password sent, pls check SMS"
'        activateUserScreen()
'        end if
'        end if      
' end if
' end sub

' sub addPhoneNum()
'    m.keyType = "phone"
'    m.kbdDialog.text = ""
'    m.kbdDialog.title = "Molimo vas unesite vaš broj mobilnog telefona"
'    m.kbdDialog.message = ["Broj telefona treba biti u formatu 00381641234567"]
'    m.kbdDialog.keyboardDomain = "numeric"
'    m.kbdDialog.visible = true
'    m.kbdDialog.setFocus(true)   
' end sub

' sub addOtp()
'    m.keyType = "otp"
'    m.kbdDialog.text = ""
'    m.kbdDialog.title = "Molimo vas unesite kod koji ste primili SMS-om"
'    m.kbdDialog.message = ["Kod vam je poslat na broj telefona koji ste prethodno uneli i sastoji se od 6 cifara"]
'    m.kbdDialog.visible = true
'    m.kbdDialog.setFocus(true)   
' end sub

