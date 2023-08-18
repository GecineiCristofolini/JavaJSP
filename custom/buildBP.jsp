<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="/WEB-INF/workflow.tld" prefix="wf" %>
<%@ taglib uri="/WEB-INF/i18n.tld" prefix="i18n" %>
<%@ taglib uri="/WEB-INF/form.tld" prefix="form" %>
<%@ taglib uri="/WEB-INF/portal.tld" prefix="portal" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/content_window.tld" prefix="cw" %>

<%@page import="com.neomind.fusion.bpa.bp.BPField" %>
<%@page import="com.neomind.fusion.bpa.bp.BPQuery" %>

<%@page import="com.neomind.fusion.persist.PersistEngine" %>
<%@page import="com.neomind.fusion.persist.QLEqualsFilter" %>
<%@page import="com.neomind.fusion.workflow.model.ActivityModel" %>
<%@page import="com.neomind.fusion.workflow.model.ProcessModel" %>
<%@page import="com.neomind.fusion.workflow.xpdl.XPDLProcessModel" %>
<%@page import="com.neomind.util.NeoUtils" %>
<portal:head title="">
    <cw:main>
        <cw:header title="Exportador de BI"/>
        <cw:body id="area_scroll">

            <%
                ProcessModel pm = (ProcessModel) PersistEngine.getNeoObject(XPDLProcessModel.class,
                    new QLEqualsFilter("name", "Analisar Pedido de Internação Eletiva"));
                BPQuery bp = new BPQuery();
                bp.setProcessModel(pm);
                bp.setName(pm.getName());

                {
                    BPField f = new BPField();
                    f.setGroupTitle(null);
                    f.setTitle("Processo");
                    f.setValue("$process.performance ($process.timeSpent / $process.baselineTime)");
                    f.setColumnOrder(2000l);
                    bp.addField(f);
                }
                for(ActivityModel am : pm.getTaskModelSet())
                {
                    if(NeoUtils.safeIsNull(am.getTaskAssigner()) || !NeoUtils
                        .safeIsNull(am.getTaskExecuter()))
                    {
                        continue;
                    }

                    BPField f = new BPField();
                    f.setGroupTitle(am.getTaskAssigner().getName());
                    f.setTitle(am.getName());
                    f.setValue(
                        "$task{" + am.getCode() + "}.performance $task{" + am.getCode() + "}.user");
                    f.setColumnOrder((100000 * am.getTaskAssigner().getNeoId()) + am.getNeoId());
                    bp.addField(f);
                }
                PersistEngine.persist(bp);
            %>
            OK!
        </cw:body>
    </cw:main>
</portal:head>