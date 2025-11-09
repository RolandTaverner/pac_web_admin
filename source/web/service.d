module web.service;

import vibe.vibe;
import vibe.http.common;

import model.model;

import web.api.root;
import web.api.category;
import web.api.proxy;
import web.api.hostrule;
import web.api.proxyrules;
import web.api.pac;

import web.services.category;
import web.services.proxy;
import web.services.hostrule;
import web.services.proxyrules;
import web.services.pac;

import web.services.common.exceptions;
import web.services.common.todto;

class Service : APIRoot
{
    this(Model model)
    {
        m_model = model;

        m_categorySvc = new CategoryService(m_model);
        m_proxySvc = new ProxyService(m_model);
        m_hostRuleSvc = new HostRuleService(m_model);
        m_proxyRulesSvc = new ProxyRulesService(m_model);
        m_pacSvc = new PACService(m_model);
    }

    override @property CategoryAPI categories()
    {
        return m_categorySvc;
    }

    override @property ProxyAPI proxies()
    {
        return m_proxySvc;
    }

    override @property HostRuleAPI hostRules()
    {
        return m_hostRuleSvc;
    }

    override @property ProxyRulesAPI proxyRules()
    {
        return m_proxyRulesSvc;
    }

    override @property PACAPI pacs()
    {
        return m_pacSvc;
    }

private:
    Model m_model;
    CategoryService m_categorySvc;
    ProxyService m_proxySvc;
    HostRuleService m_hostRuleSvc;
    ProxyRulesService m_proxyRulesSvc;
    PACService m_pacSvc;
}

// class WebService {
//     private SessionVar!(string, "username") username_;

//     void index(HTTPServerResponse res)
//     {
//         auto contents = q{<html><head>
//             <title>Tell me!</title>
//         </head><body>
//         <form action="/username" method="POST">
//         Your name:
//         <input type="text" name="username">
//         <input type="submit" value="Submit">
//         </form>
//         </body>
//         </html>};

//         res.writeBody(contents, "text/html; charset=UTF-8");
//     }

//     @method(HTTPMethod.GET) @path("/api/categories")
//     void getCategories( ) {

//     }

//     @path("/name")
//     void getName(HTTPServerRequest req, HTTPServerResponse res)
//     {
//         import std.string : format;

//         // Инспектируется свойство запроса
//         // headers и генерируются
//         // теги <li>.
//         string[] headers;
//         foreach (key, value; req.headers.byKeyValue()) {
//             headers ~= "<li>%s: %s</li>".format(key, value);
//         }
//         auto contents = q{<html><head>
//             <title>Tell me!</title>
//         </head><body>
//         <h1>Your name: %s</h1>
//         <h2>Headers</h2>
//         <ul>
//         %s
//         </ul>
//         </body>
//         </html>}.format(username_.value, headers.join("\n"));

//         res.writeBody(contents, "text/html; charset=UTF-8");
//     }

//     void postUsername(string username, HTTPServerResponse res)
//     {
//         username_ = username;
//         auto contents = q{<html><head>
//             <title>Tell me!</title>
//         </head><body>
//         <h1>Your name: %s</h1>
//         </body>
//         </html>}.format(username_.value);

//         res.writeBody(contents, "text/html; charset=UTF-8");
//     }

// }
