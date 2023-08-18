<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@page import="com.neomind.fusion.common.NeoObject" %>

<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="/WEB-INF/workflow.tld" prefix="wf" %>
<%@ taglib uri="/WEB-INF/i18n.tld" prefix="i18n" %>
<%@ taglib uri="/WEB-INF/form.tld" prefix="form" %>
<%@ taglib uri="/WEB-INF/portal.tld" prefix="portal" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@page import="com.neomind.fusion.custom.casvig.mobile.entity.CasvigMobilePool" %>

<%@page import="com.neomind.fusion.entity.EntityRegister" %>
<%@page import="com.neomind.fusion.entity.EntityWrapper" %>
<%@page import="com.neomind.fusion.entity.InstantiableEntityInfo" %>
<%@page import="com.neomind.fusion.persist.PersistEngine" %>
<%@page import="com.neomind.fusion.portal.PortalUtil" %>
<%@page import="com.neomind.fusion.security.NeoUser" %>
<%@page import="com.neomind.fusion.workflow.Activity" %>
<%@page import="com.neomind.fusion.workflow.Task" %>
<%@page import="java.math.BigDecimal" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<portal:head title="">
    <%
        if(PortalUtil.getCurrentUser() == null)
        {
            return;
        }

        InstantiableEntityInfo entityInfo = (InstantiableEntityInfo) EntityRegister.getInstance()
            .getCache().getByType("IMReinspecao");
        List<NeoObject> list = (List<NeoObject>) PersistEngine
            .getObjects(entityInfo.getEntityClass());

        for(NeoObject obj : list)
        {
            EntityWrapper wrapper = new EntityWrapper(obj);

            CasvigMobilePool pool = new CasvigMobilePool();

            PersistEngine.persist(pool);

            BigDecimal bigAct = (BigDecimal) wrapper.getValue("neoIdActivity");
            BigDecimal bigTask = (BigDecimal) wrapper.getValue("neoIdTask");

            long neoIdActivity = bigAct.longValue();
            long neoIdTask = bigTask.longValue();
            Boolean isFinish = (Boolean) wrapper.getValue("isFinish");

            Task task = (Task) PersistEngine.getNeoObject(neoIdTask);
            Activity activity = (Activity) PersistEngine.getNeoObject(neoIdActivity);

            pool.setActivity(activity);
            pool.setTask(task);

            if(!isFinish)
            {
                pool.setIsReinspection(true);
            }
            else
            {
                pool.setIsEfficacy(true);
            }

            pool.setSendToMobile(true);

            List<NeoUser> user = new ArrayList<NeoUser>();

            user.add(activity.getProcess().getRequester());

            pool.setUsers(user);
        }
    %>
</portal:head>