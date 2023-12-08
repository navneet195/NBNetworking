# NBNetworking

Networking/Service Layer

A librabry to maintain common network call for all application platform iOS app.

I had to make more customizable and reusable Networking layer for each project.
Networking/Service layer consists of all the objects that do external communication in your ios app. you have an HTTP client and service objects that inject that client and use it to communicate with your’s backend API. Services also compose new request objects (create HTTP headers, params, sign and encrypt them, etc.), receive JSON/XML responses, and parse and map the responses to domain model objects.
