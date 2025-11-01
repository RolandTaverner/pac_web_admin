# PAC web admin (work in progress)
Web admin to manage proxy autoconfiguration (PAC) file


 curl -v -X PUT http://127.0.0.1:8080/api/categories/update -H "Content-Type: application/json" -d '{"id": 0, "name": "upfated"}'
 curl http://127.0.0.1:8080/api/categories/all | jq
 curl -v -X DELETE http://127.0.0.1:8080/api/categories/0
 curl -X POST http://127.0.0.1:8080/api/categories/create -H "Content-Type: application/json" -d '{"id": 1, "name": "qwerty"}'