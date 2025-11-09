module web.services.common.exceptions;

import std.conv;

import vibe.http.common;

import model.entities.category;
import model.entities.proxy;
import model.entities.hostrule;
import model.entities.proxyrules;
import model.entities.pac;

import model.errors.base : ConstraintError;

T remapExceptions(alias fun, T)() @trusted
{
    try
    {
        return fun();
    }
    catch (CategoryNotFound e)
    {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(
                e.getEntityId()) ~ " not found");
    }
    catch (ProxyNotFound e)
    {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(
                e.getEntityId()) ~ " not found");
    }
    catch (HostRuleNotFound e)
    {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(
                e.getEntityId()) ~ " not found");
    }
    catch (ProxyRulesNotFound e)
    {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(
                e.getEntityId()) ~ " not found");
    }
    catch (PACNotFound e)
    {
        throw new HTTPStatusException(404, e.getEntityType() ~ " id=" ~ to!string(
                e.getEntityId()) ~ " not found");
    }
    catch (ConstraintError e)
    {
        throw new HTTPStatusException(400, e.toString());
    }
}
