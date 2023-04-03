' ********** Copyright 2022 RedCellApps.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
'    m.GridScreen.ObserveField("rowItemFocused, "OnGridScreenItemFocused")
    ShowScreen(m.GridScreen) ' show GridScreen
end sub

sub ShowLoginScreen()
    m.LoginScreen = CreateObject("roSGNode", "LoginScreen")
    ShowScreen(m.LoginScreen)
end sub

sub ShowContentScreen()
    if m.homeScreen.goToScreen = 1 or m.homeScreen.goToScreen = 111

        showTVScreen()
        
    else if m.homeScreen.goToScreen = 2 or m.homeScreen.goToScreen = 222

        showRadioScreen()
    
    else if m.homeScreen.goToScreen = 3 or m.homeScreen.goToScreen = 333
    m.ContentScreen = CreateObject("roSGNode", "ContentScreen")
    ShowVODScreen()
    
    else if m.homeScreen.goToScreen = 4 or m.homeScreen.goToScreen = 444
    
    else if m.homeScreen.goToScreen = 5 or m.homeScreen.goToScreen = 555
    showSearchScreen()
    
    end if
end sub

sub ShowHomeScreen()
    m.HomeScreen = CreateObject("roSGNode", "HomeScreen")
    m.HomeScreen.observeField("goToScreen","ShowContentScreen")
    m.HomeScreen.observeField("searchContent","ShowContentScreen")
    ShowScreen(m.HomeScreen) 
end sub

sub ShowRadioScreen()
    m.radioScreen = CreateObject("roSGNode", "RadioScreen")
    ShowScreen(m.radioScreen) 
end sub
sub ShowTVScreen()
    m.TVScreen = CreateObject("roSGNode", "TVScreen")
    ShowScreen(m.TVScreen) 
end sub
sub ShowSearchScreen()
    m.SearchScreen = CreateObject("roSGNode", "SearchScreen")
    ShowScreen(m.SearchScreen) 
end sub
sub ShowVODScreen()
    m.VODScreen = CreateObject("roSGNode", "VODScreen")
    ShowScreen(m.VODScreen) 
end sub

sub ShowGalleryScreen()
    m.GalleryScreen = CreateObject("roSGNode", "MarkupGridExample")
    ShowScreen(m.GalleryScreen) 
end sub

sub ShowChaptersScreen()
    m.ChaptersScreen = CreateObject("roSGNode", "MarkupGridExample")
    ShowScreen(m.ChaptersScreen) 
end sub

sub OnGridScreenItemSelected(event as Object) 
    grid = event.GetRoSGNode() 
    m.selectedIndex = event.GetData()
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    itemIndex = m.selectedIndex[1]
    if rowContent.GetChild(itemIndex).scenes <> invalid  and rowContent.GetChild(itemIndex).scenes.count() <> 0
    m.sideBar = m.GridScreen.findNode("sideMenu")
    m.sideBar.visible = true
    else if rowContent.GetChild(itemIndex).media.count() > 1

    ShowChaptersScreen()
    else
    ShowVideoScreen(rowContent, itemIndex)
    end if
end sub