<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@page import="com.neomind.fusion.portal.PortalUtil" %>

<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="/WEB-INF/workflow.tld" prefix="wf" %>
<%@ taglib uri="/WEB-INF/i18n.tld" prefix="i18n" %>
<%@ taglib uri="/WEB-INF/form.tld" prefix="form" %>
<%@ taglib uri="/WEB-INF/portal.tld" prefix="portal" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@page import="com.neomind.fusion.security.NeoUser" %>
<jsp:useBean id="servlet" class="com.neomind.fusion.custom.aguas.esfinge.ServletEsfinge"
             scope="session"/>

<portal:head title="Gerador de Arquivos para e-Sfinge">
    <%
        NeoUser user = PortalUtil.getCurrentUser();
        if(user == null)
        {
    %>
    <p class="alert_geral" style="color:#666666;">Faça antes o login no Fusion para ter acesso a
        está área.</p>
    <%
        return;
    }
    else if(!user.isAdm() && user.getNeoId() != 747935 && user.getNeoId() != 747937)
    {
    %>
    <p class="alert_geral" style="color:#666666;">Usuário sem permissão!
        <br> Contate o Administrador para maiores informações.</p>
    <%
            return;
        }
    %>
    
    
    <fieldset>
        <legend class="titulo">
            e-Sfinge&nbsp;&nbsp;
        </legend>
        <table width='100%' cellpadding="0" cellspacing="0" class="tab_geral">
            <tr align="left" valign="middle">
                <td height='30' align="right" width="25%" valign="middle">
                    <label class="formFieldLabel tab_geral_titulo">Data de início</label>
                </td>
                <td height='30' align="left" valign="middle">
                    <table>
                        <tr>
                            <td height='30' align="left" valign="middle" style="padding-left:10px">
                                <input name='var_activity.process.startDate_ini'
                                       errorSpan='err_var_activity.process.startDate_ini'
                                       id='var_activity.process.startDate_ini' mandatory='false'
                                       class='text_field'
                                       onchange='validate("var_activity.process.startDate_ini","err_var_activity.process.startDate_ini", this.value, "/^((0?[1-9]|[12]\\d)\\/(0?[1-9]|1[0-2])|30\\/(0?[13-9]|1[0-2])|31\\/(0?[13578]|1[02]))\\/(19|20)?\\d{2}$/", "Valor Inválido")'/><span
                                id='err_var_activity.process.startDate_ini'
                                style='margin-left:0px;'></span>&nbsp<img
                                src='imagens/icones/ico_calen2.png' width='27' height='26'
                                align='absmiddle' id='btCalvar_activity.process.startDate_ini'
                                onclick="return showNeoCalendar('var_activity.process.startDate_ini', '%d/%m/%Y','btCalvar_activity.process.startDate_ini',event);">
                                <div id='err_var_activity.process.startDate_ini' class='att'></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height='30' align="right" width="25%" valign="middle">
                    <label class="formFieldLabel tab_geral_titulo">Data de término</label>
                </td>
                <td height='30' align="left" valign="middle">
                    <table>
                        <tr>
                            <td height='30' align="left" valign="middle" style="padding-left:10px">
                                <input name='var_activity.process.finishDate_ini'
                                       errorSpan='err_var_activity.process.finishDate_ini'
                                       id='var_activity.process.finishDate_ini' mandatory='false'
                                       class='text_field'
                                       onchange='validate("var_activity.process.finishDate_ini","err_var_activity.process.finishDate_ini", this.value, "/^((0?[1-9]|[12]\\d)\\/(0?[1-9]|1[0-2])|30\\/(0?[13-9]|1[0-2])|31\\/(0?[13578]|1[02]))\\/(19|20)?\\d{2}$/", "Valor Inválido")'/><span
                                id='err_var_activity.process.finishDate_ini'
                                style='margin-left:0px;'></span>&nbsp;<img
                                src='imagens/icones/ico_calen2.png' width='27' height='26'
                                align='absmiddle' id='btCalvar_activity.process.finishDate_ini'
                                onclick="return showNeoCalendar('var_activity.process.finishDate_ini', '%d/%m/%Y','btCalvar_activity.process.finishDate_ini',event);">
                                <div id='err_var_activity.process.finishDate_ini' class='att'></div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
            
            <tr align="left" valign="middle">
                <td height='30' width='25%' align="right" valign="middle">
                    <label class="formFieldLabel tab_geral_titulo"></label>
                </td>
                <td height='30' align="left" valign="middle" style="padding-left:10px">
                    &nbsp;&nbsp;<input type="button" id="btAdvancedFilter" name="btAdvancedFilter"
                                       class="btn_fundo" value="Gerar Arquivos"
                                       onclick="filtraDados()"/>
                </td>
            </tr>
            <%
                String status = request.getParameter("status");
                if(status != null && status.startsWith("error1"))
                {
            %>
            <tr>
                <td height='30' align="right" width="25%" valign="middle">
                    <label class="formFieldLabel tab_geral_titulo2">Datas Inválidas</label>
                </td>
            </tr>
            <%
            }
            else if(status != null && status.startsWith("error2"))
            {
            %>
            <tr>
                <td height='30' align="right" width="25%" valign="middle">
                    <label class="formFieldLabel tab_geral_titulo2">Nenhuma Licitação
                        Encontrada</label>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </fieldset>
    
    <hr/>
    
    
    <script type="text/javascript">
        
        function filtraDados() {
            var url = "<%=PortalUtil.getBaseURL()%>eSfinge?";
            
            url += "start=" + document.getElementById("var_activity.process.startDate_ini").value
                + "&finish=" + document.getElementById("var_activity.process.finishDate_ini").value;
            
            document.location = url;
            
        }
    
    </script>
</portal:head>