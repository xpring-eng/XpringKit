swagger: "2.0"
info:
  description: "This is a sample PayID Server"
  version: "0.0.1"
  title: "PayID"
  termsOfService: "https://xpring.io/terms/"
  contact:
    email: "xpring@ripple.com"
  license:
    name: "Apache 2.0"
    url: "http://www.apache.org/licenses/LICENSE-2.0.html"
host: "stage.xpring.money"
basePath: "/"
schemes:
- "https"
paths:
  /{payID}:
    get:
      summary: "Resolve a PayID"
      description: "Returns an XRP address"
      operationId: "resolvePayIDToXRP"
      consumes:
      - "application/json+xrp"
      produces:
      - "application/json+xrp"
      parameters:
      - name: "payID"
        in: "path"
        description: "PayID to resolve"
        required: true
        type: "string"
      responses:
        200:
          description: "successful operation"
          schema:
            $ref: "#/definitions//Destination"
        404:
          description: "PayID not found"
definitions:
  Destination:
    type: "object"
    properties:
      classicAddress:
        type: "string"
      xAddress:
        type: "string"
externalDocs:
  description: "Find out more about PayID"
  url: "https://xpring.io"
