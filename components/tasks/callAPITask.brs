Sub init()
    m.top.functionName = "getContent"
End Sub

Sub getContent()
    requestData = m.top.requestData
    resultObject = utils_HTTPRequest(requestData.httpMethodString, requestData.urlString, requestData.postBodyString, requestData.headersAssociativeArray)
    m.top.result = resultObject
End Sub
