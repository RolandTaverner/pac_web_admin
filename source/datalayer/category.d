module datalayer.category;

import std.json;

import datalayer.repository;

class CategoryValue : ISerializable {
public:
    this() {
    }

    this(in CategoryValue v) {
        m_name = v.m_name.dup;
    }

    this(in string name) {
        m_name = name;
    }

    const(string) name() const {
        return m_name;
    }

    JSONValue toJSON() const {
        return JSONValue(["name": JSONValue(name())]);
    }

    unittest
    {
        CategoryValue value = new CategoryValue("name");
        const JSONValue v = value.toJSON();
        
        assert( v.object["name"].str == "name" );
    }

    void fromJSON(in JSONValue v) {
        m_name = v.object["name"].str;
    }

    unittest
    {
        JSONValue v = JSONValue.emptyObject;
        v.object["name"] = JSONValue("name");

        CategoryValue value = new CategoryValue();
        value.fromJSON(v);
        
        assert( value.name() == "name" );
    }

protected:
   string m_name;
}


class CategoryRepository : RepositoryBase!(Key, CategoryValue) {
public:

}

unittest
{
    CategoryRepository r = new CategoryRepository();
    r.create(new CategoryValue());
}
