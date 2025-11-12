module web.service;

import vibe.vibe;
import vibe.http.common;

import model.model;

import web.api.root;
import web.api.category;
import web.api.proxy;
import web.api.condition;
import web.api.proxyrule;
import web.api.pac;

import web.services.category;
import web.services.proxy;
import web.services.condition;
import web.services.proxyrule;
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
        m_conditionSvc = new ConditionService(m_model);
        m_proxyRuleSvc = new ProxyRuleService(m_model);
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

    override @property ConditionAPI conditions()
    {
        return m_conditionSvc;
    }

    override @property ProxyRuleAPI proxyRules()
    {
        return m_proxyRuleSvc;
    }

    override @property PACAPI pacs()
    {
        return m_pacSvc;
    }

private:
    Model m_model;
    CategoryService m_categorySvc;
    ProxyService m_proxySvc;
    ConditionService m_conditionSvc;
    ProxyRuleService m_proxyRuleSvc;
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
