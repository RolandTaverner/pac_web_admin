module web.services.proxyrules;

import std.algorithm.iteration : map;
import std.algorithm.mutation : SwapStrategy;
import std.algorithm.sorting : sort;
import std.array;

import model.model;
import model.entities.proxyrules;

import web.api.hostrule;
import web.api.proxyrules;

import web.services.common.exceptions;
import web.services.common.todto;

class ProxyRulesService : ProxyRulesAPI
{
    this(Model model)
    {
        m_model = model;
    }

    @safe override ProxyRulesList getAll()
    {
        ProxyRulesList response =
        {
            m_model.getProxyRules()
                .map!(c => toDTO(c))
                .array
                .sort!((a, b) => a.id < b.id, SwapStrategy.stable)
                .array
        };

        return response;
    }

    @safe override ProxyRulesDTO create(in ProxyRulesInputDTO prs)
    {
        const ProxyRulesInput prsi = {
            proxyId: prs.proxyId, enabled: prs.enabled, name: prs.name.dup, hostRuleIds: prs
                .hostRuleIds.dup
        };
        const ProxyRules created = m_model.createProxyRules(prsi);
        return toDTO(created);
    }

    @safe override ProxyRulesDTO update(in long id, in ProxyRulesInputDTO prs)
    {
        return remapExceptions!(delegate() {
            const ProxyRulesInput prsi = {
                proxyId: prs.proxyId, enabled: prs.enabled, name: prs.name.dup, hostRuleIds: prs
                    .hostRuleIds.dup
            };
            const ProxyRules updated = m_model.updateProxyRules(id, prsi);
            return toDTO(updated);
        }, ProxyRulesDTO);
    }

    @safe override ProxyRulesDTO getById(in long id)
    {
        return remapExceptions!(delegate() {
            const ProxyRules got = m_model.proxyRulesById(id);
            return toDTO(got);
        }, ProxyRulesDTO);
    }

    @safe override ProxyRulesDTO remove(in long id)
    {
        return remapExceptions!(delegate() {
            const ProxyRules removed = m_model.deleteProxyRules(id);
            return toDTO(removed);
        }, ProxyRulesDTO);
    }

    @safe override HostRuleList getHostRules(in long id)
    {
        return remapExceptions!(delegate() {
            HostRuleList response = {
                array(m_model.proxyRulesById(id)
                    .hostRules().map!(c => toDTO(c)))};
                return response;
            }, HostRuleList);
        }

        @safe override HostRuleList addHostRule(in long id, in long hrid)
        {
            return remapExceptions!(delegate() {
                const auto updated = m_model.proxyRulesAddHostRule(id, hrid);
                HostRuleList response = {array(updated.map!(c => toDTO(c)))};
                return response;
            }, HostRuleList);
        }

        @safe override HostRuleList removeHostRule(in long id, in long hrid)
        {
            return remapExceptions!(delegate() {
                const auto updated = m_model.proxyRulesRemoveHostRule(id, hrid);
                HostRuleList response = {array(updated.map!(c => toDTO(c)))};
                return response;
            }, HostRuleList);
        }

    private:
        Model m_model;
    }
