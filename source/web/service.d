module web.service;

import std.algorithm.iteration : map;
import std.array;
import std.conv;

import vibe.vibe;
import vibe.http.common;

import model.model;
import model.category;

import web.api.root;
import web.api.category;


class Service : APIRoot 
{
    this(Model model)
    {
        m_model = model;
        m_categoriesSvc = new CategoriesService(m_model);
    }

    override @property CategoriesAPI categories()
    {
        return m_categoriesSvc;
    }

private:    
    Model m_model;
    CategoriesService m_categoriesSvc;
}

class CategoriesService : CategoriesAPI
{
    this(Model model)
    {
        m_model = model;
    }

    @safe override Categories getAll()
    {
        Categories response = { array(m_model.categories().map!(c => toDTO(c))) };
        return response;
    }

    @safe override CategoryDTO postCreate(in NewCategoryDTO c)
    {
        const Category created = m_model.createCategory(new Category(0, c.name));
        return toDTO(created);
    }

    @safe override CategoryDTO putUpdate(in CategoryDTO c)
    {
        return remapExceptions!(delegate() 
        { 
            const Category updated = m_model.updateCategory(new Category(c.id, c.name));
            return toDTO(updated);
        }, CategoryDTO);
    }

    @safe override CategoryDTO getById(in long id)
    {
        return remapExceptions!(delegate() 
        { 
            const Category got = m_model.categoryById(id);
            return toDTO(got);
        }, CategoryDTO);        
    }

    @safe override CategoryDTO deleteRemove(in long id)
    {
        return remapExceptions!(delegate() 
        { 
            const Category removed = m_model.deleteCategory(id);
            return toDTO(removed);
        }, CategoryDTO);
    }

private:    
    Model m_model;
}

T remapExceptions(alias fun, T)() @safe {
    try {
        return fun();
    } catch (CategoryNotFound e) {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(e.getEntityId()) ~ " not found");
    }
}

@safe CategoryDTO toDTO(in Category c) {
    return CategoryDTO(c.id(), c.name());
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

