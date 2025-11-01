module web.api.category;

import vibe.web.rest;
import vibe.http.server;


interface CategoriesAPI
{
@safe:
    Categories getAll();

    @path(":id")
    CategoryDTO getById(in long _id);

    @bodyParam("c") 
    CategoryDTO postCreate(in NewCategoryDTO c);

    @bodyParam("c") 
    CategoryDTO putUpdate(in CategoryDTO c);

    @path(":id")
    CategoryDTO deleteRemove(in long _id);
}

struct Categories
{
    CategoryDTO[] categories;
}

struct NewCategoryDTO
{
    @safe this(in string name) pure {
        this.name = name.dup;
    }

    string name;
}

struct CategoryDTO
{
    @safe this(in long id, in string name) pure {
        this.id = id;
        this.name = name.dup;
    }

    long id;
    string name;
}
