module web.services.hostrule;

import std.algorithm.iteration : map;
import std.algorithm.mutation : SwapStrategy;
import std.algorithm.sorting : sort;
import std.array;

import model.model;
import model.entities.hostrule;

import web.api.hostrule;

import web.services.common.exceptions;
import web.services.common.todto;

class HostRuleService : HostRuleAPI
{
    this(Model model)
    {
        m_model = model;
    }

    @safe override HostRuleList getAll()
    {
        HostRuleList response = {
            m_model.getHostRules()
                .map!(c => toDTO(c))
                .array
                .sort!((a, b) => a.id < b.id, SwapStrategy.stable)
                .array
        };

        return response;
    }

    @safe override HostRuleDTO create(in HostRuleInputDTO p)
    {
        const HostRuleInput hri = {
            hostTemplate: p.hostTemplate, strict: p.strict, categoryId: p.categoryId
        };
        const HostRule created = m_model.createHostRule(hri);
        return toDTO(created);
    }

    @safe override HostRuleDTO update(in long id, in HostRuleInputDTO p)
    {
        return remapExceptions!(delegate() {
            const HostRuleInput hri = {
                hostTemplate: p.hostTemplate, strict: p.strict, categoryId: p.categoryId
            };
            const HostRule updated = m_model.updateHostRule(id, hri);
            return toDTO(updated);
        }, HostRuleDTO);
    }

    @safe override HostRuleDTO getById(in long id)
    {
        return remapExceptions!(delegate() {
            const HostRule got = m_model.hostRuleById(id);
            return toDTO(got);
        }, HostRuleDTO);
    }

    @safe override HostRuleDTO remove(in long id)
    {
        return remapExceptions!(delegate() {
            const HostRule removed = m_model.deleteHostRule(id);
            return toDTO(removed);
        }, HostRuleDTO);
    }

private:
    Model m_model;
}
