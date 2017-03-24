Function newDisplayEngine(jtrJr As Object) As Object

	DisplayEngine = {}

' setup methods
	DisplayEngine.Initialize					= de_Initialize

	DisplayEngine.jtrJr = jtrJr
	DisplayEngine.msgPort = jtrJr.msgPort

    DisplayEngine.EventHandler					= de_EventHandler
	DisplayEngine.StartPlayback					= de_StartPlayback
	DisplayEngine.PausePlayback					= de_PausePlayback
	DisplayEngine.ResumePlayFromPaused			= de_ResumePlayFromPaused

	return DisplayEngine

End Function


Sub de_Initialize()

	m.videoPlayer = CreateObject("roVideoPlayer")
	m.videoPlayer.SetPort(m.msgPort)
    m.videoPlayer.SetLoopMode(0)

End Sub


Sub de_EventHandler(event As Object)

    MEDIA_END = 8

    if type(event) = "roControlDown" then
        print "roControlDown event received: ";event

        if event.GetInt() = 2 then
            m.StartPlayback()
        else if event.GetInt() = 3 then
            m.PausePlayback()
        else if event.GetInt() = 4 then
            m.ResumePlayFromPaused()
        endif

    else if type(event) = "roIRDownEvent" then

        print "roIRDownEvent data = ";event
        if event = 7311385 then       ' PLAY'
            m.StartPlayback()
        else if event = 7311388 then  ' PAUSE'
            m.PausePlayback()
        else if event = 7311386 then ' NEXT TRACK'
            m.ResumePlayFromPaused()
        endif

    endif


End Sub


Sub de_StartPlayback()

	' pause current video
	m.PausePlayback()

	print "LaunchVideo from StartPlayback"

	ok = m.videoPlayer.PlayFile("content/recording.ts")
	if not ok stop
	ok = m.videoPlayer.SetPlaybackSpeed(1.0)
	if not ok stop

End Sub


Sub de_PausePlayback()

print "de_PausePlayback() invoked"

	ok = m.videoPlayer.SetPlaybackSpeed(0)
	ok = m.videoPlayer.Pause()
	' if not ok stop

End Sub


Sub de_ResumePlayFromPaused()

	ok = m.videoPlayer.Resume()
	' if not ok stop
	ok = m.videoPlayer.SetPlaybackSpeed(1.0)

End Sub

