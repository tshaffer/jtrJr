Library "recordingEngine.brs"
Library "eventHandler.brs"


Sub Main()
	RunJtrJr()
End Sub


Sub RunJtrJr()

    msgPort = CreateObject("roMessagePort")

	CreateDirectory("brightsign-dumps")
	CreateDirectory("content")

    JtrJr = newJtrJr(msgPort)

	EnableZoneSupport(true)

	JtrJr.eventHandler = newEventHandler(JtrJr)
	JtrJr.recordingEngine = newRecordingEngine(JtrJr)

	JtrJr.eventHandler.AddEngine(JtrJr.recordingEngine)

	JtrJr.controlPort = CreateObject("roControlPort", "BrightSign")
    JtrJr.controlPort.SetPort(msgPort)
	JtrJr.controlPortIdentity = stri(JtrJr.controlPort.GetIdentity())

	JtrJr.SetRecordLED(false)

	JtrJr.recordingEngine.Initialize()

	JtrJr.eventHandler.EventLoop()

End Sub


Function newJtrJr(msgPort As Object) As Object

    JtrJr = {}
    JtrJr.msgPort = msgPort

	JtrJr.SetRecordLED					= SetRecordLED

	return JtrJr

End Function


Sub SetRecordLED(ledOn As Boolean)

	m.controlPort.SetOutputState(9, ledOn)

End Sub

