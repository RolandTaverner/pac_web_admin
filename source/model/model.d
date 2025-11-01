module model.model;

import std.algorithm.iteration : map;
import std.array;

import datalayer.storage;
import re = datalayer.repository.errors;

import dlcategory = datalayer.category;
import dlhostrule = datalayer.hostrule;
import dlpac = datalayer.pac;
import dlproxy = datalayer.proxy;
import dlproxyrules = datalayer.proxyrules;

import model.category;
import model.hostrule;
import model.proxy;


class Model {
    @safe this(Storage storage)
    {
        m_storage = storage;
    }

    @trusted const(Category[]) categories() const {
        return array(m_storage.categories().getAll().map!(c => makeCategory(c)));
    }

    @trusted const(Category) categoryById(in long id) const {
        try
        {
            return makeCategory(m_storage.categories().getByKey(id));
        } 
        catch (re.NotFoundError e) 
        {
            throw new CategoryNotFound(id);
        }
    }

    @trusted const(Category) createCategory(in Category category) {
        const auto created = m_storage.categories().create(new dlcategory.CategoryValue(category.name()));
        return makeCategory(created);
    }

    @trusted const(Category) updateCategory(Category category) {
        try
        {
            const auto updated = m_storage.categories().update(category.id(), new dlcategory.CategoryValue(category.name()));
            return makeCategory(updated);
        } 
        catch (re.NotFoundError e) 
        {
            throw new CategoryNotFound(category.id());
        }
    }

    @trusted const(Category) deleteCategory(long id) {
        try
        {
            const auto deleted = m_storage.categories().remove(id);
            return makeCategory(deleted);
        } 
        catch (re.NotFoundError e) 
        {
            throw new CategoryNotFound(id);
        }
    }

    const(HostRule[]) hostRules() const {
        return array(m_storage.hostRules().getAll().map!(c => makeHostRule(c)));
    }

    const(HostRule) hostRuleById(in long id) const {
        return makeHostRule(m_storage.hostRules().getByKey(id));
    }

    const(Proxy[]) proxies() const {
        return array(m_storage.proxies().getAll().map!(c => makeProxy(c)));
    }

    const(Proxy) proxyById(in long id) const {
        return makeProxy(m_storage.proxies().getByKey(id));
    }

    const(Proxy) updateProxy(Proxy proxy) {
        return makeProxy(m_storage.proxies().update(proxy.id(),
            new dlproxy.ProxyValue(proxy.hostAddress(), proxy.description(), proxy.builtIn())));
    }

protected:
    Category makeCategory(in dlcategory.CategoryRepository.DataObjectType dto) const {
        return new Category(dto.key(), dto.value().name());
    }

    HostRule makeHostRule(in dlhostrule.HostRuleRepository.DataObjectType dto) const {
        auto id = dto.key();
        auto hostTemplate = dto.value().hostTemplate();
        auto strict = dto.value().strict();
        auto category = makeCategory(m_storage.categories.getByKey(dto.value().categoryId()));

        return new HostRule(id, hostTemplate, strict, category);
    }

    Proxy makeProxy(in dlproxy.ProxyRepository.DataObjectType dto) const {
        return new Proxy(dto.key(), dto.value().hostAddress(), dto.value().description(), dto.value().builtIn());
    }

private:
    Storage m_storage;
}
