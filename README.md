# dynamic-dns-dockerised

Still very much a work in progress

<div>
    <!-- Stability -->
    <img src="https://img.shields.io/badge/stability-unstable-yellow.svg?style=flat-square">
</div>

## Description
The project aims to provide an easily deployable dynamic DNS (DDNS) service via docker. 

The docker deployment consists of the following containers:
* BIND - DNS server
* API - API build on Python3/Flask
* MARIA - Storage of user credentials and accout info
* NGINX - uWSGI proxy for API service

## Installation
1. Execute config.sh and follow the prompts to generate the necessary configuration files
1. docker-compose up

## Usage
**Update/Add Endpoint**  
curl -d '{"token":"xxx","ip":"x.x.x.x","zone":"xyx.domain.com"}' -H "Content-Type: application/json" -X POST -i http://xxxxxx/dyn/api/update

## Tasks/Todo
- [ ] WebUI - create accout, login, display records, update records
- [ ] API - response/error messages for requests sent to server
- [ ] API - Implement user tokens for API. (currently needed for endpoint but not checked)

