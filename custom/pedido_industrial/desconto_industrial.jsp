<%@page import="com.neomind.fusion.custom.tecnoperfil.DescontoHelper"%>
<%@page
	import="com.neomind.framework.base.entity.impl.NeoBaseEntityImpl"%>
<%@page import="com.neomind.fusion.portal.PortalUtil"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.util.Comparator"%>
<%@page import="com.neomind.fusion.entity.FieldWrapper"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.neomind.util.NeoCalendarUtils"%>
<%@page import="java.util.GregorianCalendar"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="com.neomind.fusion.common.NeoObject"%>
<%@page import="com.neomind.fusion.entity.EntityWrapper"%>
<%@page import="com.neomind.framework.base.entity.NeoBaseEntity"%>
<%@page import="com.neomind.fusion.persist.QLEqualsFilter"%>
<%@page import="com.neomind.fusion.persist.PersistEngine"%>
<%@page import="com.neomind.fusion.workflow.adapter.AdapterUtils"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.Set"%>
<%@page import="com.neomind.fusion.entity.FieldInfo"%>
<%@page import="com.neomind.fusion.entity.EntityInfo"%>
<%@page import="com.neomind.fusion.entity.EntityRegister"%>
<%@page import="com.neomind.util.NeoUtils"%>


<%
	String pedidoId = request.getParameter("pedidoId");
	String descontoStr = request.getParameter("desconto");
	String descontoEspecialStr = request.getParameter("descontoGerencial");
	String descontoAntecipadoStr = request.getParameter("descontoAntecipado");

	System.out.println("Pedido industrial: " + pedidoId);
	System.out.println("Pedido desconto industrial: " + descontoStr);
	if (pedidoId != null) {
		System.out.println("Iniciando calculo de desconto industrial");

		BigDecimal totalValue = BigDecimal.ZERO;

		Class clazz = AdapterUtils.getEntityClass("WorPedI");
		NeoBaseEntity wPedidoEntity = PersistEngine.getNeoObject(clazz,
				new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));

		if (wPedidoEntity != null) {
			EntityWrapper wpedidoWrapper = new EntityWrapper(wPedidoEntity);

			NeoBaseEntity pedidoEntity = wpedidoWrapper.findGenericValue("WPedInd");

			EntityWrapper pedidoWrapper = new EntityWrapper(pedidoEntity);

			List<NeoBaseEntity> itens = pedidoWrapper.findGenericValue("ItePIND");

			for (NeoBaseEntity item : itens) {
				EntityWrapper itemWrapper = new EntityWrapper(item);

				BigDecimal valorUnitario = itemWrapper.findGenericValue("VlUNIND");
				BigDecimal descontoPermitido = itemWrapper.findGenericValue("ApDesPer");

				if (descontoStr != null) {
					try {
						descontoStr = descontoStr.replace("%", "");
						descontoStr = descontoStr.replace(",", ".").trim();
						BigDecimal desconto = new BigDecimal(descontoStr);
						valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
						itemWrapper.setValue("InDePer", desconto);
					} catch (Exception e) {
						System.out.println(
								"desconto_industrial.jsp ***** erro ao parsear desconto. valor recebido: '"
										+ descontoStr+"'");
						System.out.println(e.getMessage());
						out.write(e.getMessage());
					}
				} else if (descontoPermitido != null && descontoPermitido.floatValue() > 0) {
					valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoPermitido);
				}

				BigDecimal descontoEspecial = itemWrapper.findGenericValue("DesMaA");

				if (descontoEspecialStr != null) {
					try {
						descontoEspecialStr = descontoEspecialStr.replace("%", "");
						descontoEspecialStr = descontoEspecialStr.replace(",", ".").trim();
						BigDecimal desconto = new BigDecimal(descontoEspecialStr);
						valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
						itemWrapper.setValue("InfDesE", desconto);
						if (desconto.floatValue() > 0) {
							itemWrapper.setValue("ConDesEs", 1L);
						} else {
							itemWrapper.setValue("ConDesEs", 0L);
						}
					} catch (Exception e) {
						System.out.println(
								"desconto_industrial.jsp ***** erro ao parsear desconto especial. valor recebido: "
										+ descontoEspecialStr);
						System.out.println(e.getMessage());
						out.write(e.getMessage());
					}
				} else if (descontoEspecial != null && descontoEspecial.floatValue() > 0) {
					valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoEspecial);
				} else if (descontoEspecial != null && descontoEspecial.floatValue() == 0) {
					itemWrapper.setValue("ConDesEs", 0L);
				}

				BigDecimal descontoAntecipado = itemWrapper.findGenericValue("ApDesCP");

				if (descontoAntecipadoStr != null) {
					try {
						descontoAntecipadoStr = descontoAntecipadoStr.replace("%", "");
						descontoAntecipadoStr = descontoAntecipadoStr.replace(",", ".").trim();
						BigDecimal desconto = new BigDecimal(descontoAntecipadoStr);
						valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
						itemWrapper.setValue("infCAn", desconto);
					} catch (Exception e) {
						System.out.println(
								"desconto_industrial.jsp ***** erro ao parsear desconto antecipado. valor recebido: "
										+ descontoAntecipadoStr);
						System.out.println(e.getMessage());
						out.write(e.getMessage());
					}
				} else if (descontoAntecipado != null && descontoAntecipado.floatValue() > 0) {
					valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoAntecipado);
				}

				BigDecimal qtd = itemWrapper.findGenericValue("QtdIND");
				BigDecimal ipi = itemWrapper.findGenericValue("AliqIPi");
				BigDecimal valorTotal = qtd.multiply(valorUnitario);

				itemWrapper.setValue("ValUniI", valorUnitario);
				itemWrapper.setValue("PreDesA", valorUnitario);
				itemWrapper.setValue("ValMSI", valorTotal);

				float ipiFloatval = (ipi.floatValue()) / 100;

				BigDecimal ipiVal = valorUnitario.multiply(new BigDecimal(ipiFloatval));

				BigDecimal valorFinal = valorUnitario.add(ipiVal).multiply(qtd);

				itemWrapper.setValue("ValorDoIPI", ipiVal.multiply(qtd));//Valor do ipi unitário
				itemWrapper.setValue("VlmerCI", valorFinal);//Valor final com ipi e multiplicado pela qtd

				totalValue = totalValue.add(valorFinal);

				PersistEngine.persist(itemWrapper.getObject());
			}

			//pedidoWrapper.setValue("", value);
			PersistEngine.persist(pedidoWrapper.getObject());
		}
	}
%>