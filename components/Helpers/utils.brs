Function utils_getLocalJSON(filePath as String, toParse = false as Boolean) as Dynamic
    returnObject = invalid
    fileSystem = CreateObject("roFileSystem")
    
    print filesystem
    print filesystem.Exists(filePath)
    'Load the file.
    if (fileSystem.exists(filePath) = true)
        JSONstring = ReadAsciiFile(filePath)
        if(toParse)
            'Parse the configuration file.
            parsedJSONObject = ParseJSON(JSONstring)
            if (parsedJSONObject <> invalid)
                returnObject = parsedJSONObject
            else
'                print("utils_getLocalJSON() - Parsing " + filePath + " returned invalid result.")
            end if
        else
            returnObject = JSONstring
        end if
    else
'        print("utils_getLocalJSON() - No file found at: " + filePath)
    end if
    return returnObject
End Function

Function utils_HTTPRequest(httpMethodString as String, urlString as String, postBodyString as Dynamic, headersAssociativeArray as Dynamic)
    'Before doing a request, check the availability of the internet connection.
    deviceInfo = CreateObject("roDeviceInfo")
    if (deviceInfo.GetLinkStatus() = false)
'        print"utils_checkNetworkConnection - deviceInfo.GetLinkStatus(): " + deviceInfo.GetLinkStatus()
    end if
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetMessagePort(CreateObject("roMessagePort"))
    urlTransfer.SetUrl(urlString)                                   'Set the url.
    urlTransfer.EnableEncodings(true)                               'Enable gzip compression.
    urlTransfer.RetainBodyOnError(true)                             'Also return the response body in case of errors.
    urlTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")  'Enable https.
    urlTransfer.InitClientCertificates()                            'Enable https.
    urlTransfer.EnableCookies()
    'Add any required HTTP headers.
    if (headersAssociativeArray <> invalid)
        urlTransfer.SetHeaders(headersAssociativeArray)
    end if

    if (httpMethodString = "POST" or httpMethodString = "PUT")
        if (httpMethodString = "PUT")
            urlTransfer.SetRequest("PUT")
        end if

        if (postBodyString <> invalid and postBodyString.Len() > 0)
'            print("utils_HTTPRequest() - postBodyString: " + postBodyString)
        end if

        urlTransfer.AsyncPostFromString(postBodyString)
    else
        if (httpMethodString = "DELETE")
            urlTransfer.SetRequest("DELETE")
        end if

        urlTransfer.AsyncGetToString()
    end if

    'Prepare the object that is to be returned.
    resultObject = CreateObject("roAssociativeArray")

    while true
        message = wait(0, urlTransfer.GetMessagePort())

        if (type(message) = "roUrlEvent")

            resultObject.responseCode = message.GetResponseCode()
            resultObject.failureReason = message.GetFailureReason()
            resultObject.bodyString = message.GetString()

            if (message.GetResponseCode() >= 200 and message.GetResponseCode() < 600)
                resultObject.responseHeaders = message.GetResponseHeaders()
            else
'                print("utils_HTTPRequest() - GetResponseCode(): " + message.GetResponseCode().ToStr())
'                print("utils_HTTPRequest() - GetFailureReason(): " + message.GetFailureReason().ToStr())
'                print("utils_HTTPRequest() - GetString(): " + message.GetString())
            end if

            exit while
        end if
    end while

    return resultObject
End Function
