<%@ page language="java" contentType="text/javascript; charset=UTF-8" pageEncoding="UTF-8"%>

    <%@page import="com.neomind.fusion.common.NeoObject"%>
    <%@page import="com.neomind.fusion.entity.EntityRegister"%>
    <%@page import="com.neomind.fusion.entity.EntityWrapper"%>
    <%@page import="com.neomind.fusion.entity.InstantiableEntityInfo"%>
    <%@page import="com.neomind.fusion.persist.PersistEngine"%>
    <%@page import="com.neomind.fusion.portal.PortalUtil"%>
    <%@ page import="com.neomind.util.CustomFlags"%>
    <%@ page import="com.neomind.util.NeoUtils"%>
    <%@include file="/js/jquery/jquery.fileDownload.js" %>
    <%@ taglib uri="/WEB-INF/portal.tld" prefix="portal"%>
    <%@ taglib uri="/WEB-INF/i18n.tld" prefix="i18n"%>
    <%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>

    <%-- Cercadinho das customizações JS --%>

    <% String uid = null; %>

    <%-- Cercadinho das customizacoes JS --%>
    if (<%=CustomFlags.SESCDN.get()%>) {
        function downloadUrlMinuta(formDestId, formPrincId, tipoArquivo)
        {
            var minutaPrinc = $('#var_minutaPrinc__').val();//$(".ng-hide", $("#AdvancedTxtEditorFrame").contents()).text();

            var url;
            if (tipoArquivo === "Word") {
                url = "<%=PortalUtil.getBaseURL()%>services/geradorMinuta/gerarWord";
            } else {
                url = "<%=PortalUtil.getBaseURL()%>services/geradorMinuta/gerarPDF"
            }

            jQuery.fileDownload(url, {
                httpMethod: "POST",
                data: {
                    formDestId: formDestId,
                    formPrincId: formPrincId,
                    txtMinutaPrinc: minutaPrinc
                },
                successCallback: function (url) {btnReferencial.vm

                    console.log("Download concluído com sucesso!");
                },
                abortCallback: function (url) {
                    alert("Falha na comunicação, requisição abortada com o servidor!"
                        + " Caso o erro persista, favor contate o Administrador do Sistema.");
                },
                failCallback: function (responseHtml, url, error)
                {

                    if (responseHtml.includes("java.lang.Integer"))
                    {
                        alert("Usuário não está logado! Favor atualize a página e tente novamente.");
                    } else  if (responseHtml.includes("GregorianCalendar"))
                    {
                        alert("Selecione o modelo de minuta e salve o formulário.");
                    } else
                    {
                        alert("Ocorreu um erro ao gerar minuta.");
                    }
                }
            });
        }

        function downloadUrlExcel(formDestId, formPrincId, tipoArquivo)
        {
            var minutaPrinc = $('#var_minutaPrinc__').val();//$(".ng-hide", $("#AdvancedTxtEditorFrame").contents()).text();

            var url;
            if (tipoArquivo === "Word") {
                url = "<%=PortalUtil.getBaseURL()%>services/geradorMinuta/gerarWord";
            } else {
                url = "<%=PortalUtil.getBaseURL()%>services/geradorMinuta/gerarPDF"
            }

            jQuery.fileDownload(url, {
                httpMethod: "POST",
                data: {
                    formDestId: formDestId,
                    formPrincId: formPrincId,
                    txtMinutaPrinc: minutaPrinc
                },
                successCallback: function (url) {
                    console.log("Download concluído com sucesso!");
                },
                abortCallback: function (url) {
                    alert("Falha na comunicação, requisição abortada com o servidor!"
                        + " Caso o erro persista, favor contate o Administrador do Sistema.");
                },
                failCallback: function (responseHtml, url, error) {
                    //caso retorne java.lang.Integer: usuario nao esta logado
                    if (responseHtml.includes("java.lang.Integer")) {
                        alert("Usuário não está logado! Favor atualize a página e tente novamente.");
                    } else {
                        alert("Erro ao gerar Minuta! Favor contate o Administrador do Sistema.");
                    }
                }
            });
        }

        function updateTinyMCEData(data) {
            jQuery('#var_minutaPrinc__').val(data);
            var $iFrame = jQuery('#AdvancedTxtEditorFrame');
            $iFrame.get(0).contentWindow.updateTinyMCEData(data);
        }
    }








    <% if (CustomFlags.NEOMIND.get() || CustomFlags.LUMINI.get()){ %>
    function mailRetriever() {
        <%
            Long mr = null;
            Class o = Class.forName("com.neomind.fusion.custom.mail.ConfigMailRetriever");
            Object mailR = PersistEngine.getObject(o, null);


            if (mailR == null)
            {
                InstantiableEntityInfo infoChamado = (InstantiableEntityInfo) EntityRegister.getInstance().getCache().getByType("ConfigMailRetriever");

                NeoObject noMR = (NeoObject) infoChamado.createNewInstance();

                EntityWrapper ewMR = new EntityWrapper(noMR);

                ewMR.setValue("mailServer", "");
                ewMR.setValue("mailProvider", "");
                ewMR.setValue("userLogin", "");
                ewMR.setValue("userPass", "");
                ewMR.setValue("timer", 0);

                PersistEngine.persist(noMR);

                mr = noMR.getNeoId();
            }
            else { mr = ((NeoObject) mailR).getNeoId(); }
        %>

        var newModalId = static_popup.addModal(true, null, null, 550, 330, 'Configurações');
        var url = '<%= PortalUtil.getBaseURL() %>portal/render/Form/view/normal?' +
            'type=ConfigMailRetriever&id=<%= mr %>&showContainer=true&edit=true' +
            '&formCallback=NEO.neoUtils.returnParent().NEO.neoModalWindow.delModal(\'' + newModalId
            + '\')';
        static_popup.createModal(url);

    }
    <% } %>


    function customValidateForm(elem) {
        if (<%=CustomFlags.SALFER.get()%>) {
            <%-- Customização para Salfer
                 E-Form Lançamento
                 Campos: NumeroParcelas e NumeroParcelasAdiantamento
                 devem possuir valores a cima de 0
            --%>
            if (elem.id == "var_Lancamento__NumeroParcelasAdiantamento__"
                || elem.id == "var_Lancamento__NumeroParcelas__") {
                var elemNum = getMyId(elem.id).value;
                var value = parseInt(elemNum);

                if (value <= 0 || value > 5) {
                    return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidAutoCompletionValue" />';
                }
            }
            <%-- Customização para Salfer
                 E-Form Lançamento
                 Campos: após calculada as parcelas, o sistema deve verificar se a soma delas é a mesma que a digitada pelo usuário
                 e se o valor total das parcelas bate com o valor total calculado
            --%>
            if (elem.id == "var_Lancamento__NumeroParcelas__") {
                var stringNumParcelas = getMyId("var_Lancamento__NumeroParcelas__").value;
                var stringValorTotal = (getMyId("var_Lancamento__ValorDocumentoCalculado__")
                == null) ? "0" : getMyId("var_Lancamento__ValorDocumentoCalculado__").value;

                var numParcelas = NeoNumber(stringNumParcelas);
                var valorTotal = NeoNumber(stringValorTotal);

                var erroMsg = "";

                if ((ellist_Lancamento__Parcelas__.tBody.rows.length) != numParcelas) {
                    if ((ellist_Lancamento__Parcelas__.tBody.rows.length - 1) <= numParcelas) {
                        erroMsg += "Campo: Número de Parcelas é maior que a quantidade de parcelas inseridas!\n";
                    }
                    else {
                        erroMsg += "Campo: Número de Parcelas é menor que a quantidade de parcelas inseridas!\n";
                    }
                }

                var sumParcelas = 0;

                for (var i = 0; i < ellist_Lancamento__Parcelas__.tBody.rows.length; i++) {
                    var valueParcela = RemoveValueMoney(
                        ellist_Lancamento__Parcelas__.tBody.rows[i].cells[3].firstChild.innerHTML);
                    sumParcelas += valueParcela;
                }
                //arredondar
                sumParcelas = Math.round(sumParcelas * 100) / 100;

                if (isNaN(sumParcelas)) {
                    erroMsg += "Erro ao calcular o somatório do Valor das Parcelas inseridas!\n";
                    alert(erroMsg);
                    return ' ';
                }
                if (sumParcelas != valorTotal) {
                    if (sumParcelas < valorTotal) {
                        erroMsg += "Campo: Valor a Pagar (fornecedor) é maior que o somatório do Valor das Parcelas inseridas!\n";
                    }
                    else if (sumParcelas > valorTotal) {
                        erroMsg += "Campo: Valor a Pagar (fornecedor) é menor que o somatório do Valor das Parcelas inseridas!\n";
                    }
                }
                if (erroMsg == "") {
                    return null;
                }
                else {
                    alert(erroMsg);
                    return ' ';
                }
            }

            <%-- Customização para Salfer
                 E-Form Fornecedor
                  Campo: IdFornecedor (CPF/CGC)
            --%>
            <%--
            if(elem.id == "var_IdFornecedor__" || elem.id == "var_IdFornecedor__")
            {

                    cnpj
                     /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/

                    cpf
                     /^\d{3}\.\d{3}\.\d{3}\-\d{2}$/

                    cgc 00.038.166/0001-05
                     /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/

            }
            --%>

            <%-- Customização para Salfer
                 E-Form Lançamento
                 Campos: DataEmissao e DataDigitacao
                 DataEmissao deve ser menor que a DataDigitacao
            --%>
            if (elem.id == "var_Lancamento__DataEmissao__" ||
                elem.id == "var_Lancamento__Cotacoes__DataEmissao__") {
                var auxDataDigitacao = new Date();
                var strDataEmissao = null;

                if (elem.id == "var_Lancamento__DataEmissao__") {
                    strDataEmissao = getMyId("var_Lancamento__DataEmissao__").value;
                }
                else if (elem.id == "var_Lancamento__Cotacoes__DataEmissao__") {
                    strDataEmissao = getMyId("var_Lancamento__Cotacoes__DataEmissao__").value;
                }

                var arrayDataEmissao = strDataEmissao.split("/");
                if (arrayDataEmissao.length >= 3) {
                    var diaEm = NeoNumber(arrayDataEmissao[0]);
                    var mesEm = NeoNumber(arrayDataEmissao[1]);
                    var anoEm = NeoNumber(arrayDataEmissao[2]);

                    var diaDig = (auxDataDigitacao.getDate());
                    var mesDig = (auxDataDigitacao.getMonth() + 1 );
                    var anoDig = (auxDataDigitacao.getFullYear());

                    var dataEmissao = new Date(anoEm, mesEm, diaEm);
                    var dataDigitacao = new Date(anoDig, mesDig, diaDig);

                    var timeEm = dataEmissao.getTime();
                    var timeDig = dataDigitacao.getTime();

                    if (timeEm > timeDig) {
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidDate" />';
                    }
                }
                else {
                    return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidDate" />';
                }
            }

            <%-- Customização para Salfer
                 E-Form Lançamento
                 Campos: 'umento Serie Fornecedor tipoDocumento
                 Validação para evitar que documento seja lançado duas vezes
            --%>
            if (elem.id == "var_Lancamento__NumeroDocumento__") {
                if (getMyId("var_Lancamento__Serie__") != null &&
                    getMyId("id_Lancamento__Fornecedor__") != null &&
                    getMyId("id_Lancamento__TipoDocumento__") != null) {
                    var serie = getMyId("var_Lancamento__Serie__").value;
                    var fornecedor = getMyId("id_Lancamento__Fornecedor__").value;
                    var tipoDocumento = getMyId("id_Lancamento__TipoDocumento__").value;
                    var numeroDocumento = getMyId("var_Lancamento__NumeroDocumento__").value;

                    if (serie != "" && fornecedor != "" && tipoDocumento != "" && numeroDocumento
                        != "") {

                        var resp = customCallSync(
                            '<%=PortalUtil.getBaseURL()%>salferAjax?id=CheckDuplicatedDocument'
                            + '&serie=' + NeoEncode(serie)
                            + '&fornecedor=' + fornecedor
                            + '&tipoDocumento=' + tipoDocumento
                            + '&numeroDocumento=' + NeoEncode(numeroDocumento));
                        if (resp == 1) {
                            alert("Documento já lançado para esta série, tipo e fornecedor!");
                            return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidAutoCompletionValue" />';
                        }
                    }
                }
            }

            <%-- Customização para Salfer
                 E-Form Lançamento
                 Campos: PrimeiroLancamento e PrimeiroVencimento
                 Lancamento deve ser menor que primeiro vencimento --%>

            if (elem.id == "var_Lancamento__PrimeiroLancamento__") {
                var processLancNeoId = getMyId("hid_Lancamento__").value;

                var strDataLancamento = null;
                var srtDataVencimento = null;
                strDataLancamento = getMyId("var_Lancamento__PrimeiroLancamento__").value;
                strDataVencimento = customCallSync(
                    '<%=PortalUtil.getBaseURL()%>salferAjax?id=DueDate'
                    + '&lanNeoId=' + processLancNeoId);

                if (strDataLancamento != "" && strDataVencimento != "") {
                    var arrayDataLancamento = strDataLancamento.split("/");
                    var arrayDataVencimento = strDataVencimento.split("/");

                    if (arrayDataLancamento.length >= 3 && arrayDataVencimento.length >= 3) {

                        var diaLan = NeoNumber(arrayDataLancamento[0]);
                        var mesLan = NeoNumber(arrayDataLancamento[1]);
                        var anoLan = NeoNumber(arrayDataLancamento[2]);

                        var diaVen = NeoNumber(arrayDataVencimento[0]);
                        var mesVen = NeoNumber(arrayDataVencimento[1]);
                        var anoVen = NeoNumber(arrayDataVencimento[2]);

                        var dataLancamento = new Date(anoLan, mesLan, diaLan);
                        var dataVencimento = new Date(anoVen, mesVen, diaVen);

                        var timeLan = dataLancamento.getTime();
                        var timeVen = dataVencimento.getTime();

                        if (timeLan > timeVen) {
                            return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidDate" />';
                        }
                    }
                    else {
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidDate" />';
                    }
                }
            }

            <%-- Customização para Salfer
                 E-Form CancelamentoLancamento
                 Campos: FichaLancamento
                 Verifica se a Data atual é menor que a data de lançamento para poder efetivar o cancelamento


            if(elem.id == "id_txt_FichaLancamento__")
            {
                var stringFichaLancamento = getMyId("id_FichaLancamento__").value;
                var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=DateCancel'
                                                        +'&lanNeoId='+ stringFichaLancamento);
                var array = resp.split(";");
                if(array == null || array == "")
                {
                    return null;
                }
                if(array[0] == "0")
                {
                    return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle">' + ' Lançamento já Efetivado';
                }
            }--%>

            <%-- Customização para Salfer
                 E-Form Lancamento
                 Campos: AdiantamentoUtilizar
                 AdiantamentoUtilizar não pode ser maior que  TotalAdiantamentosCalculado e o valorDocumentoCalculado
            --%>

            if (elem.id == "var_Lancamento__AdiantamentoUtilizar__") {
                if (getMyId("var_Lancamento__TotalAdiantamentosCalculado__") != null &&
                    getMyId("var_Lancamento__ValorDocumentoCalculado__") != null) {
                    var totalAdiantamentosCalculado = RemoveValueMoney(
                        getMyId("var_Lancamento__TotalAdiantamentosCalculado__").value);
                    var valorDocumentoCalculado = RemoveValueMoney(
                        getMyId("var_Lancamento__ValorDocumentoCalculado__").value);
                    var adiantamentoUtilizar = RemoveValueMoney(
                        getMyId("var_Lancamento__AdiantamentoUtilizar__").value);

                    if (adiantamentoUtilizar > totalAdiantamentosCalculado || adiantamentoUtilizar
                        > valorDocumentoCalculado) {
                        var erroMsg = "";
                        if (adiantamentoUtilizar > totalAdiantamentosCalculado) {
                            erroMsg += "Valor a utilizar é maior que o Total dos Adiantamentos\n"
                        }
                        if (adiantamentoUtilizar > valorDocumentoCalculado) {
                            erroMsg += "Valor do adiantamento a utilizar é maior que o Valor a pagar \n";
                        }
                        alert(erroMsg);
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidAutoCompletionValue" />';
                    }
                }
            }

            <%-- Customização para Salfer
                 E-Form Lancamento
                 Campos: DiscriminacaoLancamento
                 Não pode haver mais que duas parcelas iguais
            --%>

            if (elem.id == "req_list_Lancamento__Cotacoes__DiscriminacaoLancamento__" ||
                elem.id == "req_list_Lancamento__DiscriminacaoLancamento__") {
                var listId = "";
                if (getMyId("req_list_Lancamento__DiscriminacaoLancamento__")) {
                    for (var i = 0;
                        i < ellist_Lancamento__DiscriminacaoLancamento__.tBody.rows.length; i++) {
                        if (i == 0) {
                            listId += ellist_Lancamento__DiscriminacaoLancamento__.tBody.rows[i].cells[0].firstChild.value;
                        }
                        else {
                            listId += ";"
                                + ellist_Lancamento__DiscriminacaoLancamento__.tBody.rows[i].cells[0].firstChild.value;
                        }
                    }
                }
                else if (getMyId("req_list_Lancamento__Cotacoes__DiscriminacaoLancamento__")) {
                    for (var i = 0; i
                    < ellist_Lancamento__Cotacoes__DiscriminacaoLancamento__.tBody.rows.length;
                        i++) {
                        if (i == 0) {
                            listId += ellist_Lancamento__Cotacoes__DiscriminacaoLancamento__.tBody.rows[i].cells[0].firstChild.value;
                        }
                        else {
                            listId += ";"
                                + ellist_Lancamento__Cotacoes__DiscriminacaoLancamento__.tBody.rows[i].cells[0].firstChild.value;
                        }
                    }
                }

                if (listId == "")
                    return;

                var resp = customCallSync(
                    '<%=PortalUtil.getBaseURL()%>salferAjax?id=CheckDuplicated'
                    + '&list=' + listId
                    + '&form=LD-DiscriminacaoLancamento');
                var array = resp.split(";");
                if (array == null || array.length == 0) {
                    return null;
                }

                if (array.length > 1 && array[0] == "0") {
                    if (array[1] == "131") {
                        //return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle">' + ' Discriminações de Lançamento Duplicadas';
                        alert('Discriminações de Lançamento Duplicadas');
                        return ' ';
                    }
                }
            }

            <%-- Customização para Salfer
                 E-Form Lancamento
                 Campos: Impostos
                 Não pode haver mais que dois impostos iguais
            --%>

            if (elem.id == "req_list_Lancamento__Impostos__") {
                var listId = "";

                for (var i = 0; i < ellist_Lancamento__Impostos__.tBody.rows.length; i++) {
                    if (i == 0) {
                        listId += ellist_Lancamento__Impostos__.tBody.rows[i].cells[0].firstChild.value;
                    }
                    else {
                        listId += ";"
                            + ellist_Lancamento__Impostos__.tBody.rows[i].cells[0].firstChild.value;
                    }
                }
                if (listId == "")
                    return;

                var resp = customCallSync(
                    '<%=PortalUtil.getBaseURL()%>salferAjax?id=CheckDuplicated'
                    + '&list=' + listId
                    + '&form=Impostos');
                var array = resp.split(";");
                if (array == null || array.length == 0) {
                    return null;
                }

                if (array.length > 1 && array[0] == "0") {
                    if (array[1] == "131") {
                        //return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle">' + ' Impostos Duplicados';
                        alert('Impostos Duplicados');
                        return ' ';
                    }
                }
            }

            <%-- Customizão para Salfer
                 E-Form Lançamento -> campo do tipo Lista de E-Form Discriminação do Lançamento)
                 Capturar uma valor para o campo OrcamentoDisponivel
                 Verificando quando os valores de Centro de Custo e Conta Contábil forem completados
            --%>

            if (elem.id == "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaContabil__"
                ||
                elem.id == "id_txt_Lancamento__DiscriminacaoLancamento__ContaContabil__") {
                var ccontab = null;
                var ccusto = null;

                if (getMyId("var_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    ccontab = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__ContaContabil__").value;
                    ccusto = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__CentroCusto__").value;
                }
                else if (getMyId(
                        "var_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    ccontab = getMyId(
                        "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaContabil__").value;
                    ccusto = getMyId(
                        "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__CentroCusto__").value;
                }

                if (ccontab == null && ccusto == null)
                    return null;

                <%-- Chama o Servlet capturar o OrcamentoDisponivel	--%>
                var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=ValueMoney'
                    + '&ccontab=' + NeoEncode(ccontab)
                    + '&ccusto=' + NeoEncode(ccusto));

                var array = resp.split(";");

                if (array.length > 1 && array[0] == "0" && array[1] == "122") {
                    var erroContabil = getMyId("errorSpan_ContaContabil_1");

                    if (erroContabil != null) {
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle">'
                            + ' Orçamento não Cadastrado';
                    }
                }
            }

            <%-- Customizão para Salfer
                 E-Form Impostos -> campo do tipo Lista de E-Form
                 validar campos "obrigatorios", sendo que um imposto não é obrigatorio
            --%>

            if (elem.id == "id_txt_Lancamento__Impostos__CredorImposto__"
                || elem.id == "id_txt_Lancamento__Impostos__CentroCusto__"
                || elem.id == "id_txt_Lancamento__Impostos__ContaDebito__"
                || elem.id == "var_Lancamento__Impostos__ValorImposto__"
                || elem.id == "var_Lancamento__Impostos__Vencimento__") {
                if (elem.id == "id_txt_Lancamento__Impostos__CredorImposto__") {
                    if (getMyId("id_txt_Lancamento__Impostos__CredorImposto__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="MandatoryField" />';
                    if (getMyId("id_Lancamento__Impostos__CredorImposto__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidFormat" />';
                }
                else if (elem.id == "id_txt_Lancamento__Impostos__CentroCusto__") {
                    if (getMyId("id_txt_Lancamento__Impostos__CentroCusto__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="MandatoryField" />';
                    if (getMyId("id_Lancamento__Impostos__CentroCusto__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidFormat" />';
                }
                else if (elem.id == "id_txt_Lancamento__Impostos__ContaDebito__") {
                    if (getMyId("id_txt_Lancamento__Impostos__ContaDebito__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="MandatoryField" />';
                    if (getMyId("id_Lancamento__Impostos__ContaDebito__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="InvalidFormat" />';
                }
                else if (elem.id == "var_Lancamento__Impostos__ValorImposto__") {
                    if (getMyId("var_Lancamento__Impostos__ValorImposto__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="MandatoryField" />';
                }
                else if (elem.id == "var_Lancamento__Impostos__Vencimento__") {
                    if (getMyId("var_Lancamento__Impostos__Vencimento__").value == "")
                        return '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle"> <i18n:string key="MandatoryField" />';
                }
            }

            <%-- Customização para Salfer
                 E-Form Lancamento
                 Campos: DiscriminacaoLancamento
                 Grid Editavel ... os campos devem ficar vazios
            --%>
            if (elem.id == "id_txt_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__" &&
                getMyId("id_txt_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__")
                != null &&
                getMyId("var_Lancamento__DiscriminacaoLancamento__custom__Quantidade__") != null &&
                getMyId("var_Lancamento__DiscriminacaoLancamento__custom__ValorUnitario__")
                != null) {
                var centroCusto = getMyId(
                    "id_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__").value;
                var contaContabil = getMyId(
                    "id_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__").value;
                var centroCustoTxt = getMyId(
                    "id_txt_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__").value;
                var contaContabilTxt = getMyId(
                    "id_txt_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__").value;
                var quantidade = getMyId(
                    "var_Lancamento__DiscriminacaoLancamento__custom__Quantidade__").value;
                var valorUnitario = getMyId(
                    "var_Lancamento__DiscriminacaoLancamento__custom__ValorUnitario__").value;

                if (centroCusto > 0
                    || contaContabil > 0
                    || centroCustoTxt > 0
                    || contaContabilTxt > 0
                    || quantidade != ""
                    || valorUnitario != "") {
                    alert("Existe dados que não foram inseridos \nna Discriminação do Lançamento.");
                    return ' ';
                }
            }
        }
        return null;
    }
    <%--
    function customAutoComplete(elem, thisone)
    {
        < %-- Customização para Salfer
             E-Form Fornecedor
             Campo: IdFornecedor (CPF/CGC)
        --% >
        if(<%=CustomFlags.SALFER.get()%>)
        {
            if(elem.id == "var_IdFornecedor__" || elem.id == "var_IdFornecedor__")
            {
                if((tempnum.length == 3) || (tempnum.length == 7))
                    thisone.value=tempnum+".";
                if((tempnum.length == 11) )
                    thisone.value=tempnum+"/";
                if((tempnum.length == 16) )
                    thisone.value=tempnum+"-";
            }
        }
    }
    --%>

    function customInsertValuePopUp() {
        <%-- Customizão para Salfer
             E-Form Lançamento
             Capturar o valor do Campo: Conta Credora que está preenchida no campo do tipo E-Form: Fornecedor
             para inserir este valor no campo Conta Credora (contido no E-Form Discriminação do Lançamento)
        --% >
        if(<%=CustomFlags.SALFER.get()%>)
        {
            if(getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__") != null
             || getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaCredora__") != null)
            {
                var windowParentOffer = '<%= (PortalUtil.getCurrentUser()==null) ? "" : SalferUtils.getOfferMap(PortalUtil.getCurrentUser().getCode())%>';
                if(windowParentOffer == null || windowParentOffer == "")
                {
                    return;
                }

                var p = parent.getMyId(windowParentOffer);
                if(p)
                {
                    var fornecedor = null;
                    var contaCredora = null;

                    // para firefox
                    if(p.contentDocument)
                    {
                        <%--
                            Se possui o campo Fornecedor no documento pai
                            E ser no E-Form Discriminação do Lançamento com o campo Conta Credora
                        --% >
                        if(p.contentDocument.getMyId("id_txt_Lancamento__Cotacoes__Fornecedor__") != null)
                        {
                            fornecedor = p.contentDocument.getMyId("id_txt_Lancamento__Cotacoes__Fornecedor__");
                            contaCredora = getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__").value;
                        }
                        else if(p.contentDocument.getMyId("id_txt_Lancamento__Fornecedor__") != null)
                        {
                            fornecedor = p.contentDocument.getMyId("id_txt_Lancamento__Fornecedor__").value;
                            contaCredora = getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaCredora__").value;
                        }
                    }
                    // para IE
                    else if(p.contentWindow)
                    {
                        <%--
                            Se possui o campo Fornecedor no documento pai
                            E ser no E-Form Discriminação do Lançamento com o campo Conta Credora
                        --% >
                        if(p.contentWindow.getMyId("id_txt_Lancamento__Cotacoes__Fornecedor__") != null)
                        {
                            fornecedor = p.contentWindow.getMyId("id_txt_Lancamento__Cotacoes__Fornecedor__").value;
                            contaCredora = getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__").value;
                        }
                        else if(p.contentWindow.getMyId("id_txt_Lancamento__Fornecedor__") != null)
                        {
                            fornecedor = p.contentWindow.getMyId("id_txt_Lancamento__Fornecedor__").value;
                            contaCredora = getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaCredora__").value;
                        }
                    }

                    if(fornecedor != null && contaCredora != null)
                    {
                        <%-- Chama o Servlet capturar a Conta Credora do Fornecedor
                             Usando Ajax para receber o retorno e inserir no campo Conta Credora do E-Form Discriminação do Lançamento
                        --% >
                        var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=AccCredit'
                                                                    +'&fAsString=' + NeoEncode(fornecedor));

                        var conta = null;
                        var contaId = null;
                        if(getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__") != null)
                        {
                            conta = getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__");
                            contaId = getMyId("id_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaCredora__");
                        }
                        else if(getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaCredora__") != null)
                        {
                            conta = getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaCredora__");
                            contaId = getMyId("id_Lancamento__DiscriminacaoLancamento__ContaCredora__");
                        }
                        var array = resp.split(";");
                        if(array.length>1 && conta != null)
                        {
                            conta.value = array[1];
                            contaId.value = array[2];
                        }
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
        --%>
        return;
    }

    <%--
        actv == true ... foco no campo
        actv == false ... perdeu o foco
        obj == campo
    --%>
    function customActiveObj(actv, obj) {
        if (<%=CustomFlags.SALFER.get()%>) {
            <%-- Customizão para Salfer
                 E-Form Lançamento -> campo do tipo Lista de E-Form Discriminação do Lançamento)
                 Capturar uma valor para o campo OrcamentoDisponivel
                 Verificando quando os valores de Centro de Custo e Conta Contábil forem completados
            --%>
            <%-- Se o campo receber o foco --%>
            if (actv &&
                (getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaContabil__")
                != null &&
                getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__CentroCusto__")
                != null &&
                getMyId("var_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__")
                != null &&
                (  (getMyId("id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaContabil__")
                    != obj)
                    && (getMyId(
                        "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__CentroCusto__")
                    != obj)
                ))
                ||
                (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaContabil__") != null &&
                getMyId("id_txt_Lancamento__DiscriminacaoLancamento__CentroCusto__") != null &&
                getMyId("var_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__") != null &&
                (  (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__ContaContabil__") != obj)
                    && (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__CentroCusto__") != obj)
                ))
            ) {
                var ccontab = null;
                var ccusto = null;

                if (getMyId("var_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    ccontab = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__ContaContabil__").value;
                    ccusto = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__CentroCusto__").value;
                }
                else if (getMyId(
                        "var_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    ccontab = getMyId(
                        "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__ContaContabil__").value;
                    ccusto = getMyId(
                        "id_txt_Lancamento__Cotacoes__DiscriminacaoLancamento__CentroCusto__").value;
                }

                <%-- Chama o Servlet capturar o OrcamentoDisponivel	--%>
                var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=ValueMoney'
                    + '&ccontab=' + NeoEncode(ccontab)
                    + '&ccusto=' + NeoEncode(ccusto));

                var orcamento = null;
                var orcamentotxt = null;
                if (getMyId("var_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    orcamento = getMyId(
                        "var_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__");
                    orcamentotxt = getMyId(
                        "txt_Lancamento__DiscriminacaoLancamento__OrcamentoDisponivel__");
                }
                else if (getMyId(
                        "var_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__")
                    != null) {
                    orcamento = getMyId(
                        "var_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__");
                    orcamentotxt = getMyId(
                        "txt_Lancamento__Cotacoes__DiscriminacaoLancamento__OrcamentoDisponivel__");
                }

                var array = resp.split(";");

                if (array.length > 1 && array[0] == "1") {
                    var v = RemoveValueMoney(array[1]);
                    var vMask = 'R$ ' + NeoNumber(array[1]);

                    if (vMask.indexOf(".") != -1)
                        vMask = vMask.replace(".", ",");

                    if (vMask.indexOf(",") == -1)
                        vMask = vMask + ',00';

                    orcamento.value = v;
                    orcamentotxt.innerHTML = vMask;
                }
                else if (array.length > 1 && array[0] == "0" && array[1] == "122") {
                    var erroContabil = getMyId("errorSpan_ContaContabil_1");

                    if (erroContabil != null)
                        erroContabil.innerHTML = '<img src="imagens/icones_final/sphere_yellow_att_16x16-trans.png" align="absmiddle">'
                            + ' Orçamento não Cadastrado';
                }

                if (array[0] == "0") {
                    orcamento.value = 0;
                    orcamentotxt.innerHTML = "R$ 0,00";
                }
                updateSaldoOrcamentoCalculado_1();
            }
                <%-- Customizão para Salfer
                     E-Form Lançamento
                     Adicionar os adiantamentos de acordo com o fornecedor escolhido
                --%>
            else if (!actv && (getMyId("id_txt_Lancamento__Fornecedor__") != null &&
                getMyId("req_list_Lancamento__AdiantamentosDisponiveis__") != null &&
                getMyId("id_txt_Lancamento__Fornecedor__") == obj)) {
                var fornecStr = getMyId("id_txt_Lancamento__Fornecedor__").value;

                if (fornecStr == "")
                    return;

                var fornecNeoId = getMyId("id_Lancamento__Fornecedor__").value;

                if (fornecNeoId == "")
                    return;

                var processLancNeoId = getMyId("hid_Lancamento__").value;

                carregaListaAdiantamentosSalfer(fornecNeoId, processLancNeoId);
            }
                <%-- Customizão para Salfer
                     E-Form Lançamento -> campo do tipo Lista de E-Form Discriminação do Lançamento)
                     Capturar uma valor para o campo OrcamentoDisponivel
                     Verificando quando os valores de Centro de Custo e Conta Contábil forem completados
                --%>
                <%-- Se o campo receber o foco --%>
            else if (actv &&
                (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__")
                != null &&
                getMyId("id_txt_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__") != null
                &&
                getMyId("var_Lancamento__DiscriminacaoLancamento__custom__OrcamentoDisponivel__")
                != null &&
                (  (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__")
                    != obj)
                    && (getMyId("id_txt_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__")
                    != obj)
                ))
            ) {
                var ccontab = null;
                var ccusto = null;

                if (getMyId(
                        "var_Lancamento__DiscriminacaoLancamento__custom__OrcamentoDisponivel__")
                    != null) {
                    ccontab = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__custom__ContaContabil__").value;
                    ccusto = getMyId(
                        "id_txt_Lancamento__DiscriminacaoLancamento__custom__CentroCusto__").value;
                }

                <%-- Chama o Servlet capturar o OrcamentoDisponivel	--%>
                var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=ValueMoney'
                    + '&ccontab=' + NeoEncode(ccontab)
                    + '&ccusto=' + NeoEncode(ccusto));

                var orcamento = null;
                var orcamentotxt = null;
                if (getMyId(
                        "var_Lancamento__DiscriminacaoLancamento__custom__OrcamentoDisponivel__")
                    != null) {
                    orcamento = getMyId(
                        "var_Lancamento__DiscriminacaoLancamento__custom__OrcamentoDisponivel__");
                    orcamentotxt = getMyId(
                        "txt_Lancamento__DiscriminacaoLancamento__custom__OrcamentoDisponivel__");
                }

                var array = resp.split(";");

                if (array.length > 1 && array[0] == "1") {
                    var v = RemoveValueMoney(array[1]);
                    var vMask = 'R$ ' + NeoNumber(array[1]);

                    if (vMask.indexOf(".") != -1)
                        vMask = vMask.replace(".", ",");

                    if (vMask.indexOf(",") == -1)
                        vMask = vMask + ',00';

                    orcamento.value = v;
                    orcamentotxt.innerHTML = vMask;
                }

                if (array[0] == "0") {
                    orcamento.value = 0;
                    orcamentotxt.innerHTML = "R$ 0,00";
                }
                customUpdateSaldoOrcamentoCalculado_1();
            }
        }
    }

    function customFindFilterData(isMenu) {
        <%-- Customizão para Salfer
             by edgar
             recebe true quando chamado do menu e false quando chamado do pesquisar
        --%>
        if (<%=CustomFlags.SALFER.get()%>) {
            var url = '<%= PortalUtil.getBaseURL() %>custom/jsp/salfer/filtroConsultaLancamento.jsp';

            if (isMenu) {
                var newModalId = static_popup.addModal(true, null, null, 430, 280, 'Filtro');
                static_popup.createModal(url);
            }
            else {
                var newModalId = NEO.neoUtils.returnParent().static_popup.addModal(true, null, null,
                    390, 280, 'Filtro');
                NEO.neoUtils.returnParent().static_popup.createModal(url);
            }
        }
            <%-- Customizão para Portal de Clientes
                 by marcelo
                 Objetivo: fazer a chamada de entrada de dados para o lado neomind
            --%>
        else if (<%=CustomFlags.NEOMIND.get()%>) {
            if (isMenu) {
                var url = '<%= PortalUtil.getBaseURL() %>portal_cliente/consultas/Interface.jsp';
                var newModalId = static_popup.addModal(true, null, null, 390, 280,
                    'Entrada de dados');
                static_popup.createModal(url);
            }
            else {
                var url = '<%= PortalUtil.getBaseURL() %>portal_cliente/consultas/Client.jsp';
                var newModalId = static_popup.addModal(true, null, null, 390, 280,
                    'Entrada de dados');
                static_popup.createModal(url);
            }
        }
    }

    function customSaveParentWindow(windowName, elem) {
        <%-- Customização para Salfer
            E-Form Lançamento
            Guardar referencia para a janela que contem o fornecedor selecionado
        --% >
        if(<%=CustomFlags.SALFER.get()%>)
        {
            if((getMyId("div_Lancamento__Cotacoes__DiscriminacaoLancamento__") != null
              && getMyId("id_txt_Lancamento__Cotacoes__Fornecedor__")!= null )
              ||
              (getMyId("div_Lancamento__DiscriminacaoLancamento__")!= null
              && getMyId("id_txt_Lancamento__Fornecedor__")!= null )
              )
            {
                if((elem.varName == 'ellist_Lancamento__Cotacoes__DiscriminacaoLancamento__')
                  || (elem.varName == 'ellist_Lancamento__DiscriminacaoLancamento__') )
                  {
                    var user = '<%= (PortalUtil.getCurrentUser()==null)? "" : new String(PortalUtil.getCurrentUser().getCode())%>';
                    if(user != null)
                    {
                        var offer = new String(windowName);
                        var resp = customCallSync('<%=PortalUtil.getBaseURL()%>salferAjax?id=SaveWindow'
                                                                    +'&user=' + user
                                                                    +'&offer=' + offer);
                    }
                }
            }
        }
        --%>
    }

    <%--
        Customização para eventos do teclado
    --%>
    function customKeyPress(id, keyCode) {
        var falsear = false;
        switch (keyCode) {
            case 9:
                break;
        }

        if (<%=NeoUtils.isIE(request)%>) {
            setFoco();
        }
        else {
            setTimeout(setFoco, 200);
        }

        if (falsear)
            return false;
    }

    var objGlobal;

    function setFoco() {
        if (objGlobal != null) {
            objGlobal.focus();
            objGlobal = null;
        }
    }

    <%--
        Acrescenta um valor randômico na servlet passada
    --%>
    function customCallSync(url) {
        //FIXME arrumar uma maneira melhor de corrigir o problema de cache + ajax
        var myDate = new Date();
        var numRand = Math.ceil(myDate.getTime());
        var varRand = Math.ceil(Math.random() * 100);
        numRand = numRand + varRand;

        var url_ = (url == null) ? "" : (url + '&randId=' + numRand);
        var resp = callSync(url_);
        return resp;
    }


    function openNewAdendo(link) {
        var response = callSync(link);

        try {
            eval(response);
        } catch (e) {
            alert("Erro de script: " + response + " (" + e.message + ")");
        }
    }

    /**
     * cvj - Emula click na aba Tramitação
     */
    function CVJclicaAbaTramitacao() {
        var element = document.querySelectorAll('.menu_bar_default_lv1_task');
        element[0].children[0].click();
        element[0].style.visibility = 'visible';
    }
