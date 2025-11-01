module web.api.root;

import vibe.web.rest;
import vibe.http.server;

import  web.api.category : CategoriesAPI;


@path("/api/")
interface APIRoot
{
    @path("categories/") 
    @property CategoriesAPI categories();
}


