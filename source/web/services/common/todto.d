module web.services.common.todto;

import std.algorithm.iteration : map;
import std.algorithm.mutation : SwapStrategy;
import std.algorithm.sorting : sort;
import std.array;

import model.entities.category;
import model.entities.proxy;
import model.entities.hostrule;
import model.entities.proxyrules;
import model.entities.pac;

import web.api.category;
import web.api.proxy;
import web.api.hostrule;
import web.api.proxyrules;
import web.api.pac;

@safe CategoryDTO toDTO(in Category c) pure
{
    return CategoryDTO(c.id(), c.name());
}

@safe ProxyDTO toDTO(in Proxy p) pure
{
    return ProxyDTO(p.id(), p.hostAddress(), p.description(), p.builtIn());
}

@safe HostRuleDTO toDTO(in HostRule hr) pure
{
    return HostRuleDTO(hr.id(), hr.hostTemplate, hr.strict, toDTO(
            hr.category()));
}

@safe ProxyRulesDTO toDTO(in ProxyRules prs) pure
{
    const auto hostRules = prs.hostRules()
        .map!(hr => toDTO(hr))
        .array
        .sort!((a, b) => a.id < b.id, SwapStrategy.stable)
        .array;

    return ProxyRulesDTO(prs.id(), toDTO(prs.proxy()), prs.enabled(), prs.name(), hostRules);
}

@safe PACDTO toDTO(in PAC p) pure
{
    const auto proxyRules = p.proxyRules()
        .map!(pr => toDTO(pr))
        .array
        .sort!((a, b) => a.id < b.id, SwapStrategy.stable)
        .array;

    return PACDTO(p.id(), p.name(), p.description(), proxyRules,
        p.serve(), p.servePath(), p.saveToFS(), p.saveToFSPath());
}
