<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@page import="com.neomind.fusion.chart.NeoChartLevelModel" %>
<%@page import="com.neomind.fusion.chart.NeoChartModel" %>
<%@page import="com.neomind.fusion.entity.EntityRegister" %>
<%@page import="com.neomind.fusion.entity.InstantiableEntityInfo" %>
<%@page import="com.neomind.fusion.persist.PersistEngine" %>
<%@page import="com.neomind.fusion.persist.QLRawFilter" %>
<html>
<body>
<%
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XVolume de trabalho");
        model.setDescription("Volume de trabalho por célula");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Celula");
            level.setCategoryName("Celula");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("NeoDashBoard"));
            level.setIdField("neoId");
            level.setLabelField("name");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XSolicitacoes Liberadas por Solicitante");
        model.setDescription(
            "Relatório do nó de solicitações cadastradas por solicitante, calculando o total de naturezas e a média de naturezas por solicitação para cada solicitante");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Solicitante");
            level.setCategoryName("Solicitante");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("neoId");
            level.setLabelField("neoId");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XSolicitacoes por Hospital");
        model.setDescription(
            "A partir do nó de cadastro do associado e referenciado, identificar o nó de solicitacões recebidas por Hospital e o prazo médio para liberação das solicitações daquele Hospital");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Hospital");
            level.setCategoryName("Hospital");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("neoId");
            level.setLabelField("neoId");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("OPME");
        model.setDescription("OPME");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("OPME");
            level.setCategoryName("OPME");
            level.setHqlFilter(new QLRawFilter(
                "neoId in (select _vo.neoId from WFProcess w where w.entity.neoId = _vo.neoId and (w.startDate >= :[De,date]) and (w.startDate <= :[Até,date]) and (_vo.indicOPME is not null))"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("IndicOPME");
            level.setLabelField("IndicOPME");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Solicitacoes Autorizadas");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Autorizadas");
            level.setCategoryName("Autorizadas");
            level.setHqlFilter(new QLRawFilter(
                "neoId in (select _vo.neoId from WFProcess w where w.entity.neoId = _vo.neoId and (w.startDate >= :[De,date]) and (w.startDate <= :[Até,date]) and (_vo.solicAutorizada is not null))"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("SolicAutorizada");
            level.setLabelField("SolicAutorizada");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Coluna/Obesidade");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Coluna/Obesidade");
            level.setCategoryName("Coluna/Obesidade");
            level.setHqlFilter(new QLRawFilter(
                "neoId in (select _vo.neoId from WFProcess w where w.entity.neoId = _vo.neoId and (w.startDate >= :[De,date]) and (w.startDate <= :[Até,date]) and (_vo.colunaObesidade is not null))"
                    +
                    "" +
                    "" +
                    "" +
                    ""));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("ColunaObesidade");
            level.setLabelField("ColunaObesidade");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Solicitacoes Negadas");
        model.setDescription("Solicitacoes Negadas");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Solicitacoes Negadas");
            level.setCategoryName("Negadas");
            level.setHqlFilter(new QLRawFilter(
                "neoId in (select _vo.neoId from WFProcess w where w.entity.neoId = _vo.neoId and (w.startDate >= :[De,date]) and (w.startDate <= :[Até,date]) and (_vo.solicNegada is not null))"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("SolicNegada");
            level.setLabelField("SolicNegada");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Solicitações Liberadas por Natureza");
        model.setDescription("Solicitações liberadas por código de Natureza");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Natureza");
            level.setCategoryName("Natureza");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("SolicitacaoInt.FichaMedicaComp.NaturezasConc.nro_nat_serv");
            level.setLabelField("SolicitacaoInt.FichaMedicaComp.NaturezasConc.nro_nat_serv");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XStatus por Filial");
        model.setDescription("Status de solicitação por Filial");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Filial");
            level.setCategoryName("Filial");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("neoId");
            level.setLabelField("neoId");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XNúmero de Naturezas Expressas");
        model.setDescription("Número de Naturezas Expressas");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Natureza");
            level.setCategoryName("Natureza");
            level.setSql("select neoId, neoType from NeoObject");
            level.setIdField("neoType");
            level.setLabelField("neoType");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazos Internação Eletiva - Média - SQL");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Atividade");
            level.setSql(
                "select u.fullName as Name, am.Name as Atividade, u.neoId as userNeoId, ((extract(day from (t.finishDate - t.startDate)) * 24) + (extract(hour from (t.finishDate - t.startDate))) + (extract(minute from (t.finishDate - t.startDate)) / 60)) as Prazo from Task t, Activity a, ActivityModel am, NeoUser u, WFProcess p, ProcessModel pm where t.activity_neoId = a.neoId and a.model_neoId = am.neoId and u.neoId = t.user_neoId and a.process_neoId = p.neoId and p.model_neoId = pm.neoId and t.finishDate is not null and ( pm.name = 'Analisar Pedido de Internação Eletiva' or pm.name = 'Analisar Solicitação OPME')");
            level.setIdField("Atividade");
            level.setLabelField("Atividade");
            level.setShowOrder(0);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(2);
            level.setValueFunction("avg(Prazo)");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Usuario");
            level.setIdField("userNeoId");
            level.setLabelField("Name");
            level.setShowOrder(1);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(2);
            level.setValueFunction("avg(Prazo)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazo de Resposta - Global");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Prazo Máximo;Prazo Médio;Prazo Mínimo");
            level.setHqlFilter(new QLRawFilter(
                "_vo.wfprocess.saved = 1 and (_vo.wfprocess.model.name = 'Analisar Pedido de Internação Eletiva' or _vo.wfprocess.model.name = 'Analisar Solicitação OPME') and (_vo_wfprocess_taskSet.neoType = 'Fworkflow.UserActivity') and (_vo_wfprocess_taskSet.startDate is not null) and (_vo_wfprocess_taskSet.finishDate is not null) and "
                    +
                    "(_vo_wfprocess_taskSet.startDate >= :[De,date])  and (_vo_wfprocess_taskSet.finishDate <= :[De,date])"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("wfprocess.taskSet.model.name");
            level.setLabelField("wfprocess.taskSet.model.name");
            level.setShowOrder(10);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "max(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720);"
                    +
                    "avg(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720);"
                    +
                    "min(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)"
                    +
                    "");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Prazo Máximo;Prazo Médio;Prazo Mínimo");
            level.setIdField("wfprocess.taskSet.taskList.user.neoId");
            level.setLabelField("wfprocess.taskSet.taskList.user.name");
            level.setShowOrder(20);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "max(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720);"
                    +
                    "avg(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720);"
                    +
                    "min(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)"
                    +
                    "");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazo Internação Eletiva - OLD");
        model.setDescription("Prazo Internação Eletiva");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Atividade");
            level.setSql("select u.fullName as Name, am.Name as Atividade, u.neoId as UId, " +
                "cast(t.finishDate -  t.startDate as numeric(19,2)) * 24 as Prazo " +
                "from Task t, Activity a, ActivityModel am, NeoUser u, ProcessModel p" +
                "where t.activity_neoId = a.neoId and a.model_neoId = am.neoId  and u.neoId = t.user_neoId and"
                +
                "      am.processModel_neoId = p.neoId and (p.name = 'Analisar Pedido de Internação Eletiva' or p.name = 'Analisar Solicitação OPME')"
                +
                "");
            level.setIdField("Atividade");
            level.setLabelField("Atividade");
            level.setShowOrder(0);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(1);
            level.setValueFunction("Sum");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Volume de Trabalho por Célula");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Raia");
            level.setCategoryName("Volume");
            level.setHqlFilter(new QLRawFilter(
                "_vo.wfprocess.saved = 1 and (_vo.wfprocess.model.name = 'Analisar Pedido de Internação Eletiva' or _vo.wfprocess.model.name = 'Analisar Solicitação OPME') and (_vo_wfprocess_taskSet.startDate is not null and _vo_wfprocess_taskSet.finishDate is not null) and (_vo_wfprocess_taskSet.neoType = 'Fworkflow.UserActivity')"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("wfprocess.taskSet.model.taskAssigner.name");
            level.setLabelField("wfprocess.taskSet.model.taskAssigner.name");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Volume");
            level.setIdField("wfprocess.taskSet.model.name");
            level.setLabelField("wfprocess.taskSet.model.name");
            level.setShowOrder(15);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Volume");
            level.setIdField("wfprocess.taskSet.taskList.user.fullName");
            level.setLabelField("wfprocess.taskSet.taskList.user.fullName");
            level.setShowOrder(20);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazo de Resposta - Máximo");
        model.setDescription("Prazo de resposta máximo para internação eletiva e OPME");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Prazo Máximo");
            level.setHqlFilter(new QLRawFilter(
                "_vo.wfprocess.saved = 1 and (_vo.wfprocess.model.name = 'Analisar Pedido de Internação Eletiva' or _vo.wfprocess.model.name = 'Analisar Solicitação OPME') and (_vo_wfprocess_taskSet.neoType = 'Fworkflow.UserActivity') and (_vo_wfprocess_taskSet.startDate is not null and _vo_wfprocess_taskSet.finishDate is not null) and "
                    +
                    "(_vo_wfprocess_taskSet.startDate >= :[De,date])  and (_vo_wfprocess_taskSet.finishDate <= :[De,date])"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("wfprocess.taskSet.model.name");
            level.setLabelField("wfprocess.taskSet.model.name");
            level.setShowOrder(0);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(2);
            level.setValueFunction(
                "max(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)"
                    +
                    "");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Prazo Máximo");
            level.setIdField("wfprocess.taskSet.taskList.user.neoId");
            level.setLabelField("wfprocess.taskSet.taskList.user.name");
            level.setShowOrder(1);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "max(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazo de Resposta - Médio");
        model.setDescription("Prazo de resposta médio dos workflows de internação eletiva e OPME");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Prazo Médio");
            level.setHqlFilter(new QLRawFilter(
                "_vo.wfprocess.saved = 1 and (_vo.wfprocess.model.name = 'Analisar Pedido de Internação Eletiva' or _vo.wfprocess.model.name = 'Analisar Solicitação OPME') and (_vo_wfprocess_taskSet.neoType = 'Fworkflow.UserActivity') and (_vo_wfprocess_taskSet.startDate is not null and _vo_wfprocess_taskSet.finishDate is not null) and "
                    +
                    "(_vo_wfprocess_taskSet.startDate >= :[De,date])  and (_vo_wfprocess_taskSet.finishDate <= :[De,date])"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("wfprocess.taskSet.model.name");
            level.setLabelField("wfprocess.taskSet.model.name");
            level.setShowOrder(0);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "avg(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)"
                    +
                    "");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Prazo Médio");
            level.setIdField("wfprocess.taskSet.taskList.user.neoId");
            level.setLabelField("wfprocess.taskSet.taskList.user.name");
            level.setShowOrder(1);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "avg(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazo de Resposta - Mínimo");
        model.setDescription(
            "Prazo de resposta mínimo para os Workflow de internação eletiva e OPME");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Prazo Mínimo");
            level.setHqlFilter(new QLRawFilter(
                "_vo.wfprocess.saved = 1 and (_vo.wfprocess.model.name = 'Analisar Pedido de Internação Eletiva' or _vo.wfprocess.model.name = 'Analisar Solicitação OPME') and (_vo_wfprocess_taskSet.neoType = 'Fworkflow.UserActivity') and (_vo_wfprocess_taskSet.startDate is not null and _vo_wfprocess_taskSet.finishDate is not null) and "
                    +
                    "(_vo_wfprocess_taskSet.startDate >= :[De,date])  and (_vo_wfprocess_taskSet.finishDate <= :[De,date])"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("wfprocess.taskSet.model.name");
            level.setLabelField("wfprocess.taskSet.model.name");
            level.setShowOrder(0);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "min(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)"
                    +
                    "");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuário");
            level.setCategoryName("Prazo Mínimo");
            level.setIdField("wfprocess.taskSet.taskList.user.neoId");
            level.setLabelField("wfprocess.taskSet.taskList.user.name");
            level.setShowOrder(2);
            level.setToolTip("<b>$serie / $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction(
                "min(months_between(_vo_wfprocess_taskSet.finishDate, _vo_wfprocess_taskSet.startDate) * 720)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Prazos Internação Eletiva - DESATIVADO");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Atividade");
            level.setCategoryName("Soma, Média");
            level.setSql(
                "select u.fullName as Name, am.Name as Atividade, u.neoId as userNeoId, (months_between(t.startDate, t.finishDate) * 720)"
                    +
                    " as Prazo from Task t, Activity a, ActivityModel am, NeoUser u, WFProcess p, ProcessModel pm where t.activity_neoId = a.neoId and a.model_neoId = am.neoId and u.neoId = t.user_neoId and a.process_neoId = p.neoId and p.model_neoId = pm.neoId and t.finishDate is not null and ( pm.name = 'Analisar Pedido de Internação Eletiva' or pm.name = 'Analisar Solicitação OPME')");
            level.setIdField("Atividade");
            level.setLabelField("Atividade");
            level.setShowOrder(10);
            level.setToolTip("<b>$serie - $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(2);
            level.setValueFunction("sum(Prazo),avg(Prazo)");
            PersistEngine.persist(level);
        }
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Usuario");
            level.setCategoryName("Soma, Média");
            level.setIdField("userNeoId");
            level.setLabelField("Name");
            level.setShowOrder(20);
            level.setToolTip("<b>$serie - $label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(2);
            level.setValueFunction("sum(Prazo), avg(Prazo)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("Documentacao Incompleta");
        model.setDescription("null");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Documentacao Incompleta");
            level.setCategoryName("Incompleta");
            level.setHqlFilter(new QLRawFilter(
                "neoId in (select _vo.neoId from WFProcess w where w.entity.neoId = _vo.neoId and (w.startDate >= :[De,date]) and (w.startDate <= :[Até,date]) and (_vo.docIncompleta is not null))"));
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("DocIncompleta");
            level.setLabelField("DocIncompleta");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XSolicitacoes por Filial");
        model.setDescription(
            "A partir do nó de cadastro do associado e referenciado, identificar o nó de solicitacões recebidas por filial e o prazo médio para liberação das solicitações daquela filial");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Filial");
            level.setCategoryName("Filial");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("neoId");
            level.setLabelField("neoId");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
    {
        NeoChartModel model = new NeoChartModel();
        model.setName("XSolicitacoes para Parceiro");
        model.setDescription(
            "Relatório do nó de solicitações cadastradas para Parceiro Golden, calculando o total de naturezas e a média de naturezas por solicitação para Parceiros Golden");
        PersistEngine.persist(model);
        {
            NeoChartLevelModel level = new NeoChartLevelModel();
            level.setChart(model);
            level.setName("Parceiro");
            level.setCategoryName("Parceiro");
            level.setHqlTargetInfo(
                (InstantiableEntityInfo) EntityRegister.getEntityInfo("WkfAnlPedIntElet"));
            level.setIdField("neoId");
            level.setLabelField("neoId");
            level.setShowOrder(10);
            level.setToolTip("<b>$label</b> - $val ($percent%)");
            level.setValueDecimalPlaces(0);
            level.setValueFunction("count(*)");
            PersistEngine.persist(level);
        }
    }
%>
OK!
</body>
</html>