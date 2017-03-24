Function newEventHandler(jtrJr As Object) As Object

	EventHandler = {}

	EventHandler.jtrJr = jtrJr
	EventHandler.msgPort = jtrJr.msgPort

	EventHandler.engines = []

	EventHandler.AddEngine			= eventHandler_AddEngine
	EventHandler.EventLoop			= eventHandler_EventLoop

	return EventHandler

End Function


Sub eventHandler_AddEngine( engine As Object )

	m.engines.push(engine)

End Sub


' Roku Soundbridge remote codes
' 7311383       HOME
' 7311380       ENTER
' 7311385       PLAY
' 7311388       PAUSE
' 7311386       NEXT TRACK

Sub eventHandler_EventLoop()

    while true

        msg = wait(0, m.msgPort)

		print "msg received - type=" + type(msg)

		commandProcessed = false

		if not commandProcessed then

			if type(msg) = "roControlDown" and stri(msg.GetSourceIdentity()) = stri(m.jtrJr.controlPort.GetIdentity()) then
				if msg.GetInt()=12 then
					stop
				endif
			endif

			if type(msg) = "roIRRemotePress" then
				print "remote data = ";msg.getint()
			endif

			' if type(msg) = "roIRDownEvent" then
			'' 	print "roIRDownEvent data = ";msg
			' endif

			if type(msg) = "roIRRepeatEvent" then
				print "roIRRepeatEvent data = ";msg
			endif

            numEngines% = m.engines.Count()
            for i% = 0 to numEngines% - 1
                m.engines[i%].EventHandler(msg)
            next

		endif

	end while

End Sub


