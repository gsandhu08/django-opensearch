# -*- coding: utf-8 -*-

# django-opensearch
# opensearch/templatetags/opensearch_tags.py


from django import template

from opensearch.conf import settings


__all__ = ["opensearch_meta"]  # type: list


register = template.Library()


@register.inclusion_tag(
    "opensearch/templatetags/opensearch_meta.html", takes_context=True
)
def opensearch_meta(context):
    """
    Return meta rel opensearch tag.
    """

    context.update({"DESCRIPTION": settings.OPENSEARCH_DESCRIPTION})

    return context
