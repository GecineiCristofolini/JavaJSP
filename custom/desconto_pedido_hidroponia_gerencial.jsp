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
if(pedidoId != null && descontoStr !=null){
	out.write("Iniciando cálculo de desconto:\r\n");
	out.write("Pedido id: " + pedidoId + "\r\n");
	
	descontoStr = descontoStr.replace("%", "");
	descontoStr = descontoStr.replace(",", ".");
	BigDecimal desconto = new BigDecimal(descontoStr);
	BigDecimal totalValue = BigDecimal.ZERO;
	
	System.out.println("Iniciando cálculo de desconto Gerencial:\r\n");
	System.out.println("Pedido id: " + pedidoId + "\r\n");
	System.out.println("DEsconto: " + desconto + "\r\n");
	
	Class clazz = AdapterUtils.getEntityClass("WorkPedHI");
	NeoBaseEntity pedido = PersistEngine.getNeoObject(clazz, new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));
	
	if(pedido == null){
		out.write("Pedido não existe");
		System.out.println("Pedido não existe");
		
		return;
	}
	
	EntityWrapper pedidoWrapper = new EntityWrapper(pedido);
	List<NeoBaseEntity> projetos = pedidoWrapper.findGenericValue("ItensProH");
	List<NeoBaseEntity> itensAvulsos = pedidoWrapper.findGenericValue("IteAvProH");
	
	for(NeoBaseEntity projeto: projetos){
		BigDecimal totalProjeto = BigDecimal.ZERO;
		EntityWrapper projetoWrapper = new EntityWrapper(projeto);
		List<NeoBaseEntityImpl> itens = projetoWrapper.findGenericValue("ItensProHdp");
		System.out.println("Buscando Itens do projeto");
		System.out.println(itens.size());
		
		for(NeoBaseEntity item : itens){
			EntityWrapper itemWrapper = new EntityWrapper(item);
			
			BigDecimal valorUnitario = itemWrapper.findGenericValue("PreUniP");
			System.out.println("*** Gerencial jsp Valor unitario inicial :"+valorUnitario);
			
			//aplicando desconto do item
			BigDecimal descontoItem = itemWrapper.findGenericValue("DesPeItPr");
			System.out.println("*** Gerencial jsp Valor deconto item :"+descontoItem);
			if(descontoItem != null && descontoItem.floatValue() > 0){
				valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoItem);
				
				System.out.println("*** Gerencial jsp Valor unitario inicial com desconto item :"+valorUnitario);
				itemWrapper.setValue("PrDesPerIPr", valorUnitario);
			}
			
			//aplicando desconto do projeto
			BigDecimal descontoProjeto = itemWrapper.findGenericValue("DesPerPro");			
			System.out.println("*** Gerencial jsp Valor unitario Desconto do projeto :"+descontoProjeto);
			if(descontoProjeto != null && descontoProjeto.floatValue() > 0){
				valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoProjeto);
				System.out.println("*** Gerencial jsp Valor unitario inicial com desconto do projeto: :"+valorUnitario);
			}
			
			//aplicando desconto gerencial
			valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
			System.out.println("*** Gerencial jsp Desconto gerencial :"+valorUnitario);
			System.out.println("*** Gerencial jsp Valor unitario inicial com desconto gerencial :"+valorUnitario);
			
			Long quantidade = itemWrapper.findGenericValue("quantidade");
			BigDecimal valorTotal = valorUnitario.multiply(new BigDecimal(quantidade));
			
			itemWrapper.setValue("PrCDesPr", valorUnitario);
			itemWrapper.setValue("PreTotalP", valorTotal);
			itemWrapper.setValue("DesGerePr", desconto);
			
			totalProjeto = totalProjeto.add(valorTotal);
			PersistEngine.persist(itemWrapper.getObject());
		}
		
		totalValue = totalValue.add(totalProjeto);
		projetoWrapper.setValue("vltotproj", totalProjeto);
		totalValue = totalValue.add(totalProjeto);
		
		PersistEngine.persist(projetoWrapper.getObject());
	}
	
	for(NeoBaseEntity item :itensAvulsos){
		EntityWrapper itemWrapper = new EntityWrapper(item);
		
		BigDecimal valorUnitario = itemWrapper.findGenericValue("PreUniH");
		
		//aplicando desconto do item
		BigDecimal descontoItem = itemWrapper.findGenericValue("DesPerIt");			
		if(descontoItem != null && descontoItem.floatValue() > 0){
			valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontoItem);
		}
		
		//aplicando desconto geral
		BigDecimal descontogeral = itemWrapper.findGenericValue("DesGeral");			
		if(descontogeral != null && descontogeral.floatValue() > 0){
			valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, descontogeral);
		}
		
		//valor com desconto gerencial
		valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
		
		
		String quantidade = itemWrapper.findGenericValue("Qtd");
		BigDecimal valorTotal = valorUnitario.multiply(new BigDecimal(quantidade));
		
		itemWrapper.setValue("PreComDes", valorUnitario);
		itemWrapper.setValue("PrecToTal", valorTotal);
		itemWrapper.setValue("DesGere", desconto);
	}
	
	
	pedidoWrapper.setValue("TotalGeral", totalValue);
	PersistEngine.persist(pedidoWrapper.getObject());
}


%>