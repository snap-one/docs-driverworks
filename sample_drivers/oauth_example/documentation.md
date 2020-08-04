# OAuth Example

## System requirements

C4 OS 2.7+

## Introduction

First, you'll need to create an "Authorization Code" flow sample on https://www.oauth.com/playground/

## Properties

### Debug Mode [ *Off* | On ]

When set to On, prints out on the Lua tab the URL being requested and the response from the remote server (or in case of an error, the error message)

### URL Timeout

The time (in seconds) that the URL engine will wait for a response before timing out and returning an error.

### Preset URL [1-5]

Enter a URL here (including the leading http:// or https://) for later access in programming

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
