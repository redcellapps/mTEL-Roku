' ********** Copyright 2022 RedCellApps.  All Rights Reserved. **********
sub Init()
    m.top.backgroundColor = "#0E2B47"
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = false
    InitScreenStack()
    ShowLoginScreen()
    m.LoginScreen.observeField("contents", "showMainScreen")
    m.LoginScreen.observeField("token", "loggedIn")
end sub

sub loggedIn()
    m.loadingIndicator.control = "stop"
    m.loadingIndicator.visible = false
end sub

sub showMainScreen()
    ShowHomeScreen()
    m.top.signalBeacon("appLaunchComplete")
    m.HomeScreen.observeField("appExit", "exitApp")
end sub

sub onItemFocused()
end sub

sub exitApp()
    m.top.appExit = true
end sub

function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            else
                Init()
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function
