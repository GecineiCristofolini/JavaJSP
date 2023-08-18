<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.neomind.fusion.common.NeoObject" %>
<%@ page import="com.neomind.fusion.entity.EntityRegister" %>
<%@ page import="com.neomind.fusion.entity.EntityWrapper" %>
<%@ page import="com.neomind.fusion.entity.InstantiableEntityInfo" %>
<%@ page import="com.neomind.fusion.persist.PersistEngine" %>
<%@ page import="com.neomind.fusion.persist.QLEqualsFilter" %>
<%@ page import="com.neomind.util.NeoUtils" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="/WEB-INF/workflow.tld" prefix="wf" %>
<%@ taglib uri="/WEB-INF/i18n.tld" prefix="i18n" %>
<%@ taglib uri="/WEB-INF/form.tld" prefix="form" %>
<%@ taglib uri="/WEB-INF/portal.tld" prefix="portal" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<portlet:defineObjects/>
<%
    InstantiableEntityInfo info = (InstantiableEntityInfo) EntityRegister.getInstance().getCache()
        .getByString(request.getParameter("type"));
//InstantiableEntityInfo info = (InstantiableEntityInfo)EntityRegister.getEntityInfo(request.getParameter("type"));
    String field = request.getParameter("field") + ".neoId";
    Long value = NeoUtils.safeLong(request.getParameter("value"));
    
    List result;
    String orderBy = info.getTitleField() != null ? info.getTitleField().getName() : null;
    if(orderBy == null)
    {
        result = PersistEngine
            .getObjects(info.getEntityClass(), new QLEqualsFilter(field, value));
    }
    else
    {
        result = PersistEngine
            .getObjects(info.getEntityClass(), new QLEqualsFilter(field, value), -1, -1,
                orderBy);
    }
%>
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <c:forEach items="<%= result %>" var="oItem">
        <% NeoObject item = (NeoObject) oItem; %>
        <option value="<%= item.getNeoId() %>"><%= new EntityWrapper(item).getAsString() %></option>
    </c:forEach>
</root>