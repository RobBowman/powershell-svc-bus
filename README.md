# powershell-svc-bus

## Overview
The Azure Portal include a service bus explorer tool. This can be used to publish a message to a queue or a topic. However, this is a little limmited. While testing I found it frustrating that I needed to paste in the message body each time, along with a couple of custom properties.

## Azure REST API
When automating Azure, my first port of call is Azure CLI. However it seems this does not yet support publishing of messages to service bus. So, I turned to the Azure REST API.

## Two Steps
There are two steps required:
1. obtain the auth header for the rest post
2. post the request

I have separated these into individual PowerShell scripts, which can be found at [this github repo](https://github.com/RobBowman/powershell-svc-bus). The entry point is "post-msg.ps1". You can see that this requires a sas token to be set. This can be found by navigating the Azure Portal to Service Bus Namespace/Shared access policies/RootManageSharedAccessKey (or create a new one)/Primary Key

The top level script calls the "generate-sas-token.ps1" script in order to generate the sas token that is used in the header of the post request to the azure api.
