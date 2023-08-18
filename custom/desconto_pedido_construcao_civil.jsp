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

	System.out.println(pedidoId + " : TestePdido");
if (pedidoId != null) {
	out.write("Iniciando cálculo de desconto:\r\n");
	out.write("Pedido id: " + pedidoId + "\r\n");

	String descontoStr = request.getParameter("desconto");
	descontoStr = descontoStr.replace(",", ".");
	BigDecimal desconto = new BigDecimal(descontoStr);
	BigDecimal totalValue = BigDecimal.ZERO;

	Class clazz = AdapterUtils.getEntityClass("Pedido");//Pedido
	NeoBaseEntity pedido = PersistEngine.getNeoObject(clazz, new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));

	if(pedido == null){
		out.write("Pedido não existe");
		System.out.println("Pedido não existe");
		
		return;
	}
	
	EntityWrapper pedidoWrapper = new EntityWrapper(pedido);

	List<NeoBaseEntity> itens = pedidoWrapper.findGenericValue("PItenPed");
	out.write("Quantidade de itens no pedido: " + itens.size() + "\r\n");

	for (NeoBaseEntity item : itens) {
		EntityWrapper ew = new EntityWrapper(item);

		float descontoF = (100 - desconto.floatValue()) / 100;

		String quantidadeStr = ew.findGenericValue("Qtd");
		BigDecimal aliquotaIpi = ew.findGenericValue("AliIPI");
		BigDecimal valorSemDesconto = ew.findGenericValue("vlSdsc");
		BigDecimal valorUniSemDescEspl = ew.findGenericValue("vlUniSDE");
		
		quantidadeStr = quantidadeStr.replace(",", ".");
		
		aliquotaIpi = new BigDecimal(aliquotaIpi.floatValue() / 100);
		

		BigDecimal valorTotal = new BigDecimal(valorUniSemDescEspl.floatValue() * descontoF);
		valorTotal = valorTotal.setScale(2, BigDecimal.ROUND_HALF_EVEN);

		BigDecimal valorMercadoria = new BigDecimal(quantidadeStr).multiply(valorTotal);
		valorMercadoria = valorMercadoria.setScale(2, BigDecimal.ROUND_HALF_EVEN);
		totalValue = totalValue.add(valorMercadoria);
		
		BigDecimal valorIpi = valorMercadoria.multiply(aliquotaIpi).setScale(2, BigDecimal.ROUND_HALF_EVEN);

		ew.setValue("ValIpi", valorIpi);//Valor IPI 
		ew.setValue("ValPIL", valorIpi);//Valor IPI ($)
		ew.setValue("ValUni", valorTotal);//Valor Unitario
		ew.setValue("VlUNiL", valorTotal);//Valor Unitário ($)
		ew.setValue("ConTEsp", 1L);//Existe desconto especial
		ew.setValue("DesEspL",desconto);//pct desconto % - Desconto Especial (%)
		ew.setValue("DesEsp",desconto);//pct desconto % - %Desconto Especial
		ew.setValue("vlmerc", valorMercadoria);//Valor da Mercadoria
		ew.setValue("VlMercL", valorMercadoria);//Valor da Mercadoria$
		
		out.write("-*-*-*-*-*-*-*-*-*-*-\r\n");
		out.write("__Valor Item Sem desconto: " + valorSemDesconto.toString()+ "\r\n");
		out.write("__Aliquota IPI Item: " + aliquotaIpi.setScale(2, BigDecimal.ROUND_HALF_EVEN).toString()+ "\r\n");
		out.write("__VAlor IPI Item: " + valorIpi.toString()+ "\r\n");
		out.write("__Valor Item com desconto: " + valorTotal.toString()+ "\r\n");
		out.write("__Valor Total_mercadoria: " + valorTotal.toString()+ "\r\n");
		out.write("__Valor Pedido parcial: " + totalValue.toString()+ "\r\n");
		
		out.write("-*-*-*-*-*-*-*-*-*-*-");

		PersistEngine.persist(ew.getObject());
	}

	out.write("Valor total Pedido: " + totalValue.toString()+ "\r\n");
	/* pedidoWrapper.setValue("ValMer", totalValue);
	PersistEngine.persist(pedidoWrapper.getObject()); */

} else{
	out.write("pedido nulo");
}
%>