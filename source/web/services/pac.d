module web.services.pac;

import std.algorithm.iteration : map;
import std.algorithm.mutation : SwapStrategy;
import std.algorithm.sorting : sort;
import std.array;

import model.model;
import model.entities.pac;

import web.api.pac;
import web.api.proxyrules;

import web.services.common.exceptions;
import web.services.common.todto;

class PACService : PACAPI
{
    this(Model model)
    {
        m_model = model;
    }

    @safe override PACList getAll()
    {
        PACList response =
        {
            m_model.getPACs()
                .map!(c => toDTO(c))
                .array
                .sort!((a, b) => a.id < b.id, SwapStrategy.stable)
                .array
        };

        return response;
    }

    @safe override PACDTO create(in PACInputDTO p)
    {
        const PACInput pi = {
            p.name.dup, p.description.dup, p.proxyRulesIds.dup,
            p.serve, p.servePath.dup, p.saveToFS, p.saveToFSPath.dup
        };

        const PAC created = m_model.createPAC(pi);
        return toDTO(created);
    }

    @safe override PACDTO update(in long id, in PACInputDTO p)
    {
        return remapExceptions!(delegate() {
            const PACInput pi = {
                p.name.dup, p.description.dup, p.proxyRulesIds.dup,
                p.serve, p.servePath.dup, p.saveToFS, p.saveToFSPath.dup
            };

            const PAC updated = m_model.updatePAC(id, pi);
            return toDTO(updated);
        }, PACDTO);
    }

    @safe override PACDTO getById(in long id)
    {
        return remapExceptions!(delegate() {
            const PAC got = m_model.pacById(id);
            return toDTO(got);
        }, PACDTO);
    }

    @safe override PACDTO remove(in long id)
    {
        return remapExceptions!(delegate() {
            const PAC removed = m_model.deletePAC(id);
            return toDTO(removed);
        }, PACDTO);
    }

    @safe override ProxyRulesList getProxyRules(in long id)
    {
        return remapExceptions!(delegate() {
            ProxyRulesList response = {
                array(m_model.pacById(id).proxyRules().map!(p => toDTO(p)))};
                return response;
            }, ProxyRulesList);
        }

        @safe override ProxyRulesList addProxyRules(in long id, in long prid)
        {
            return remapExceptions!(delegate() {
                const auto updated = m_model.pacAddProxyRules(id, prid);
                ProxyRulesList response = {array(updated.map!(c => toDTO(c)))};
                return response;
            }, ProxyRulesList);
        }

        @safe override ProxyRulesList removeProxyRules(in long id, in long prid)
        {
            return remapExceptions!(delegate() {
                const auto updated = m_model.pacRemoveProxyRules(id, prid);
                ProxyRulesList response = {array(updated.map!(c => toDTO(c)))};
                return response;
            }, ProxyRulesList);
        }

    private:
        Model m_model;
    }
