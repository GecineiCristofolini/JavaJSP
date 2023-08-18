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
	
	
	
	

	System.out.println("Pedido EXP: " + pedidoId);
	System.out.println("Pedido desconto Item: " + descontoStr);
	if (pedidoId != null) {
		System.out.println("Iniciando calculo de desconto Item Geral");

		BigDecimal totalValue = BigDecimal.ZERO;

		Class clazz = AdapterUtils.getEntityClass("WorkPedEXP");
		NeoBaseEntity wPedidoEntity = PersistEngine.getNeoObject(clazz,
				new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));
				
				System.out.println(wPedidoEntity);

		if (wPedidoEntity != null) {
			EntityWrapper wpedidoWrapper = new EntityWrapper(wPedidoEntity);

			NeoBaseEntity pedidoEntity = wpedidoWrapper.findGenericValue("PedidoEXP");

			EntityWrapper pedidoWrapper = new EntityWrapper(pedidoEntity);

			List<NeoBaseEntity> itens = pedidoWrapper.findGenericValue("ItenPedExp");
			

			for (NeoBaseEntity item : itens) {
				EntityWrapper itemWrapper = new EntityWrapper(item);
                
				
				BigDecimal descontopermitido = itemWrapper.findGenericValue("DescontoPermitidoEXP");
				BigDecimal precoMinimo = itemWrapper.findGenericValue("PrecoMinimo");
				BigDecimal valorUnitario = itemWrapper.findGenericValue("ValorMaximo");
				
				
				System.out.println("Valor Ajustado: " + valorUnitario);
				System.out.println("Preço Minimo: " + precoMinimo);
				
				
				
				if (descontoStr != null) {
					try {
					descontoStr = descontoStr.replace("%", "");
	                descontoStr = descontoStr.replace(",", ".").trim();
	                BigDecimal desconto = new BigDecimal(descontoStr);
					valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
					itemWrapper.setValue("DescontoGeral",desconto);
								
						if (valorUnitario.floatValue() < precoMinimo.floatValue() ){
							 itemWrapper.setValue("ContadorDescontoEspecial", 1L);
							 itemWrapper.setValue("ObservacaoDoItem","O Valor Unitario Abaixo do  Desconto Permitido " + descontopermitido + "%");
							 } else {
							    itemWrapper.setValue("ContadorDescontoEspecial", 0L);
							    itemWrapper.setValue("ObservacaoDoItem"," ");     
							 
							        } 
					}
                    catch (Exception e) {
						System.out.println( "desconto_geral.jsp ***** erro ao parsear desconto . valor recebido: " + descontoStr);
						System.out.println(e.getMessage());
						out.write(e.getMessage());
					}
					
					Long contadorsempreco = itemWrapper.findGenericValue("ContadorDeItemSemPreco");
					
					   if (contadorsempreco > 0) {
					   
					      itemWrapper.setValue("ObservacaoDoItem","Item Sem Politica de Preço" );
					   
					   }
					
				} 
					

				
 
				BigDecimal qtd = itemWrapper.findGenericValue("Qtd");
				BigDecimal valorTotal = qtd.multiply(valorUnitario);

				itemWrapper.setValue("ValorUnitario",valorUnitario);
				
				itemWrapper.setValue("VlmeEXP",valorTotal);

				PersistEngine.persist(itemWrapper.getObject());
		    }

			
			   PersistEngine.persist(pedidoWrapper.getObject());
	    }
	}
%>