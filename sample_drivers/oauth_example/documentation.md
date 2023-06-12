[copyright]: # (Copyright 2023 Snap One, LLC. All rights reserved.)

# OAuth Example

## System requirements

C4 OS 2.7+

## Introduction

## Properties

### Debug Mode [ *Off* | On ]

When set to On, prints out on the Lua tab the URL being requested and the response from the remote server (or in case of an error, the error message)

### Authentication URL

The URL to visit in a browser to complete the OAuth flow

## Actions

### Setup OAuth

Creates the OAuth object to manage the example OAuth flow.

Parameters:

#### C4 OAuth API Key [STRING - required]

The API key provided by Control4 for using with this OAuth integration

#### C4 Link API Key [STRING - optional]

The API key provided by Control4 for generating a short link code for this OAuth integration

#### Authorization Endpoint [STRING - required]

The base URL for the authorization endpoint for this OAuth integration

#### Token Endpoint [STRING - required]

The base URL for the token endpoint for this OAuth integration

#### Client ID [STRING - required]

The client ID for this OAuth integration

#### Client Secret [STRING - required]

The client secret for this OAuth integration

#### Scope [STRING - optional]

Any scope(s) (comma separated, no spaces) required for this OAuth integration

#### Send Authorization In [*Payload* | Header]

Whether to send the client ID and secret as an HTTP Basic Authorization header or include in the payload of the POST request.

#### Use PKCE [*On* | Off]

Whether to include the PKCE code_challenge and code_verifier values when requesting a code and exchanging it for a token (always uses S256 if enabled).

#### Choose C4 OAuth Redirect Server [*Develop* | Production]

Which instance of the Control4 OAuth lambda to send the state request to.  Note that each lambda will have different API keys.

## Changelog

3

- Add PKCE setting support

2

- Update to use new features of the auth_code_grant.lua library to build in automatic persistent key storage and short linking with automatic callbacks.

1

- Initial release