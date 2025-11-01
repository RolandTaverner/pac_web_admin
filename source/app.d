import vibe.vibe;

import model.model;
import web.service;
import datalayer.storage;


void main()
{
	Storage storage = new Storage();
	Model m = new Model(storage);
	Service svc = new Service(m);

	auto router = new URLRouter;
 	registerRestInterface(router, svc);

    auto settings = new HTTPServerSettings;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.port = 8080;
    // settings.sessionStore = new MemorySessionStore;
	// settings.errorHandler = (HTTPServerRequest req, HTTPServerResponse res, RestErrorInformation error) @safe {
	// 		res.writeJsonBody([
	// 			"error": serializeToJson([
	// 				"status": Json(cast(int)error.statusCode),
	// 				"message": Json(error.exception.msg),
	// 			])
	// 		]);
	// 	};

    auto listener = listenHTTP(settings, router);
	scope (exit)
	{
		listener.stopListening();
	}

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World!");
}
