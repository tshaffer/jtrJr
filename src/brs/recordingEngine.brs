Function newRecordingEngine(jtrJr As Object) As Object

	RecordingEngine = {}

' setup methods
	RecordingEngine.Initialize					= re_Initialize

	RecordingEngine.jtrJr = jtrJr
	RecordingEngine.msgPort = jtrJr.msgPort

' setup methods
    RecordingEngine.EventHandler				= re_EventHandler

	RecordingEngine.StartManualRecord			= re_StartManualRecord
	RecordingEngine.EndManualRecord				= re_EndManualRecord

	return RecordingEngine

End Function


Sub re_Initialize()

	m.contentFolder = "content/"

	m.encodingMediaStreamer = CreateObject("roMediaStreamer")

End Sub


Sub re_EventHandler(event As Object)

    if type(event) = "roControlDown" then
        print "roControlDown event received: ";event

        if event.GetInt() = 0 then
            m.StartManualRecord("recording", 10)
        else if event.GetInt() = 1 then
            m.EndManualRecord()
        endif

    else if type(event) = "roIRDownEvent" then

        print "roIRDownEvent data = ";event
        if event = 7311383 then       ' HOME '
            m.StartManualRecord("recording", 10)
        else if event = 7311380 then  ' ENTER '
            m.EndManualRecord()
        endif

    endif

End Sub


Sub re_StartManualRecord(fileName$ As String, recordingBitRate% As Integer)

    print "Start recording: ";fileName$

	path$ = m.contentFolder + fileName$ + ".ts"

	if type(m.encodingMediaStreamer) = "roMediaStreamer" then

		vbitrate% = recordingBitRate% * 1000
		vbitrate$ = StripLeadingSpaces(stri(vbitrate%))

		ok = m.encodingMediaStreamer.SetPipeline("hdmi:,encoder:vbitrate=" + vbitrate$ + ",file:///" + path$)
		if not ok then stop

		ok = m.encodingMediaStreamer.Start()
		if not ok then stop

		' turn on record LED
		m.jtrJr.SetRecordLED(true)

	endif

End Sub


Sub re_EndManualRecord()

	ok = m.encodingMediaStreamer.Stop()
	if not ok then stop

	' turn off record LED
	m.jtrJr.SetRecordLED(false)

End Sub
