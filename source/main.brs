' ********** Copyright 2021 Roku Corp.  All Rights Reserved. ********** 

sub Main(args as Dynamic) as Void
    ident = "> main > RunUserInterface | "
    if (args.mediaType <> invalid) and (args.contentId <> invalid)
        ? ident; "Handling mediaType="; args.mediaType; ", contentId="; args.contentId
    end if
    showiONApp()
    m.deepLink = getDeepLinks(args)
end sub

function getDeepLinks(args) as Object
    deeplink = invalid
    if args.contentid <> invalid and args.mediaType <> invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if
    ? "DEBUG - DEEP LINK = "; deeplink
    if deepLink <> invalid
        playChannel(deepLink.id)
    end if
    return deeplink
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
    m.player.control = "play"
    m.player.setFocus(true)
    m.player.visible = true
end function

sub showiONApp()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainScene")
    screen.show()
    scene.observeField("appExit", m.port)
    scene.setFocus(true)

    while (true)
        msg = Wait(0, m.port)
        msgType = Type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed()
                return
            end if
        else if msgType = "roSGNodeEvent" then
            field = msg.getField()
            if field = "appExit" then
                ? "DEBUG - APP EXIT"
                return
            end if
        else if msgType = "roInputEvent"
            if msg.IsInput()
                info = msg.getInfo()
                ? ident; "Handling deeplink mediaType="; info.mediaType; ", contentId="; info.contentId
            end if
        end if
    end while
end sub
