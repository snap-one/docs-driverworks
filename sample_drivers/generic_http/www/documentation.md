[copyright]: # (Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.)

# Generic HTTP Sender

## System requirements

C4 OS 2.7+

## Introduction

The Generic HTTP sender driver is designed to send a GET or POST HTTP command to one of five pre-defined URLs (set in Properties) or a manually defined URL (set in the Command parameters). If a POST call is being made, the POST data is set in the parameters of the command.

Variable and events are provided for basic handling of any response.

This updated version uses the new *C4:url ()* function from Driverworks if the C4 OS is at least OS3. All components of the driver are unencrypted. Reuse is allowed, please retain the copyright notice in each C4 provided file.

For more information on HTTP methods, see [Wikipedia](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)

Some sample servers for checking your http calls:

[Postman](https://docs.postman-echo.com/?version=latest)
[HTTPBin](http://httpbin.org/)

Server for checking whether SSL is working as expected:

[BadSSL](https://badssl.com/)

## Properties

### Debug Mode [ *Off* | On ]

When set to On, prints out on the Lua tab the URL being requested and the response from the remote server (or in case of an error, the error message)

### URL Timeout

The time (in seconds) that the URL engine will wait for a response before timing out and returning an error.

### Preset URL [1-5]

Enter a URL here (including the leading http:// or https://) for later access in programming

### SSL Verify Peer [ *True* | False ]

Verify the presented SSL cert against the CA chain.  See [Curl Options](https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYPEER.html) for more details.  For a self signed certificate, this should be false.

### SSL Verify Host [ *True* | False ]

Verify the presented SSL cert hostname matches the connected host.  See [Curl Options](https://curl.se/libcurl/c/CURLOPT_SSL_VERIFYHOST.html) for more details.  For a certificate that presents the hostname of the device but you are connecting by IP address, this should be false.

## Commands

### GET Preset [PRESET]

Send an HTTP GET command to the URL predefined on the Properties page in Preset [PRESET]

### GET Manual [URL]

Send an HTTP GET command to the URL specified in [URL]

### POST Preset [PRESET, DATA]

Send an HTTP POST command to the URL predefined on the Properties page in Preset [PRESET] with attached data as specified in [DATA]

### POST Manual [URL, DATA]

Send an HTTP POST command to the URL specified in [URL] with attached data as specified in [DATA]

## Variables

### HTTP_ERROR (string)

The error string returned from the URL engine, or an empty string if there was no error.

### HTTP_RESPONSE_CODE (number)

The HTTP response code returned from the HTTP server, or 0 if there was an error.

### HTTP_RESPONSE_DATA (string)

The data returned from the HTTP server, or an empty string if there was an error.

## Events

### Success

Fires when the HTTP GET or POST command was successfully sent to the server and an HTTP response code was returned. The HTTP_RESPONSE_DATA and HTTP_RESPONSE_CODE variables will be populated with the data from the URL call.

Note that an HTTP 400 or 500 response will still result in the Success event but indicates either a client or server error.

For more information on HTTP response codes, see [Wikipedia](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

### Error

Fires when the URL engine returns an error. The HTTP_ERROR variable will be populated with the error code from the URL engine.
