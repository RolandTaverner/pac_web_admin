module datalayer.pac;

import std.algorithm.iteration : map;
import std.array : array;
import std.json;

import datalayer.repository.repository;


class PACValue : ISerializable
{
    this()
    {
    }

    this(in PACValue v)
    {
        m_name = v.m_name.dup;
        m_description = v.m_description.dup;
    }

    this(in string name, in string description, in long[] proxyRuleIds)
    {
        m_name = name;
        m_description = description;
        m_proxyRuleIds = proxyRuleIds.dup;
    }

    const(string) name() const
    {
        return m_name;
    }

    const(string) description() const
    {
        return m_description;
    }

    const(long[]) proxyRuleIds() const
    {
        return m_proxyRuleIds;
    }

    JSONValue toJSON() const
    {
        return JSONValue([
                "name": JSONValue(name()),
                "description": JSONValue(description()),
                "proxyRuleIds": JSONValue(proxyRuleIds())
            ]);
    }

    unittest
    {
        PACValue value = new PACValue("name", "description", [1,2,3]);
        const JSONValue v = value.toJSON();
        
        assert( v.object["name"].str == "name" );
        assert( v.object["description"].str == "description" );
        assert( v.object["proxyRuleIds"].array.length == 3 );
    }

    void fromJSON(in JSONValue v)
    {
        m_name = v.object["name"].str;
        m_description = v.object["description"].str;
        m_proxyRuleIds = array(v.object["proxyRuleIds"].array.map!( jv => jv.integer));
    }

    unittest
    {
        JSONValue v = JSONValue.emptyObject;
        v.object["name"] = JSONValue("name");
        v.object["description"] = JSONValue("description");
        v.object["proxyRuleIds"] = JSONValue([1,2,3]);

        PACValue value = new PACValue();
        value.fromJSON(v);
        
        assert( value.name() == "name" );
        assert( value.description() == "description" );
        assert( value.proxyRuleIds().length == 3 );
    }

protected:
   string m_name;
   string m_description;
   long[] m_proxyRuleIds;
}


class PACRepository : RepositoryBase!(Key, PACValue)
{
}

unittest
{
    PACRepository r = new PACRepository();
    r.create(new PACValue());
}
