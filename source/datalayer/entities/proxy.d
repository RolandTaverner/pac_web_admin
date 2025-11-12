module datalayer.entities.proxy;

import std.json;

import datalayer.repository.repository;

class ProxyValue : ISerializable
{
    @safe this() pure
    {
    }

    @safe this(in ProxyValue v) pure
    {
        m_type = v.m_type;
        m_address = v.m_address;
        m_description = v.m_description;
    }

    @safe this(in string type, in string address, in string description) pure
    {
        m_type = type;
        m_address = address;
        m_description = description;
    }

    @safe const(string) type() const pure
    {
        return m_type;
    }

    @safe const(string) address() const pure
    {
        return m_address;
    }

    @safe const(string) description() const pure
    {
        return m_description;
    }

    @safe JSONValue toJSON() const
    {
        return JSONValue([
            "type": JSONValue(type()),
            "address": JSONValue(address()),
            "description": JSONValue(description()),
        ]);
    }

    unittest
    {
        ProxyValue value = new ProxyValue("PROXY", "example.com:8080", "test");
        const JSONValue v = value.toJSON();

        assert(v.object["address"].str == "example.com:8080");
        assert(v.object["description"].str == "test");
        assert(v.object["type"].str == "PROXY");
    }

    override void fromJSON(in JSONValue v)
    {
        m_type = v.object["type"].str;
        m_address = v.object["address"].str;
        m_description = v.object["description"].str;
    }

    unittest
    {
        JSONValue v = JSONValue.emptyObject;
        v.object["type"] = JSONValue("PROXY");
        v.object["address"] = JSONValue("example.com:8080");
        v.object["description"] = JSONValue("test");

        ProxyValue value = new ProxyValue();
        value.fromJSON(v);

        assert(value.type() == "PROXY");
        assert(value.address() == "example.com:8080");
        assert(value.description() == "test");
    }

protected:
    string m_type;
    string m_address;
    string m_description;
}

alias Proxy = DataObject!(Key, ProxyValue);

alias IProxyListener = IListener!(Proxy);

class ProxyRepository : RepositoryBase!(Key, ProxyValue)
{
    this(IProxyListener listener)
    {
        super(listener);
    }    
}
