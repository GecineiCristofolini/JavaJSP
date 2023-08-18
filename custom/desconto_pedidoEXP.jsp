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
String descontoMax = request.getParameter("descontomaximo");
    

if(pedidoId != null && descontoStr !=null){
	out.write("Iniciando cálculo de desconto:\r\n");
	out.write("Pedido id: " + pedidoId + "\r\n");
	
	
	
	descontoStr = descontoStr.replace("%", "");
	descontoStr = descontoStr.replace(",", ".").trim();
	descontoMax = descontoMax.replace("%", "");
	descontoMax = descontoMax.replace(",", ".");
	
	System.out.println("DEsconto: " + descontoStr + "\r\n");
	System.out.println("DEsconto Maximo: " + descontoMax + "\r\n");
	
	BigDecimal maximodesconto = new BigDecimal(descontoMax);
	double desmax = maximodesconto.doubleValue();
	BigDecimal desconto = new BigDecimal(descontoStr);
	double des = desconto.doubleValue();
	
	
	BigDecimal totalValue = BigDecimal.ZERO;
	
	
	System.out.println("Iniciando cálculo de desconto :\r\n");
	System.out.println("Pedido id: " + pedidoId + "\r\n");
	System.out.println("DEsconto: " + desconto + "\r\n");
	System.out.println("DEscontoMaximo: " + descontoMax + "\r\n");
	
	
	Class clazz = AdapterUtils.getEntityClass("WorkPedHI");
	NeoBaseEntity pedido = PersistEngine.getNeoObject(clazz, new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));
	System.out.println(pedido);
	if(pedido == null){
		out.write("Pedido não existe");
		System.out.println("Pedido não existe");
		
		return;
	}
	
	EntityWrapper pedidoWrapper = new EntityWrapper(pedido);
	System.out.println(pedidoWrapper);
	
	
	List<NeoBaseEntity> projetos = pedidoWrapper.findGenericValue("ItensProH");
	List<NeoBaseEntity> itensAvulsos = pedidoWrapper.findGenericValue("IteAvProH");
	
	System.out.println(projetos);
	
	for(NeoBaseEntity projeto: projetos){
		BigDecimal totalProjeto = BigDecimal.ZERO;
		
		
		EntityWrapper projetoWrapper = new EntityWrapper(projeto);
		List<NeoBaseEntityImpl> itens = projetoWrapper.findGenericValue("ItensProHdp");
		System.out.println("Buscando Itens do projeto");
		System.out.println(itens.size());
		
		for(NeoBaseEntity item : itens){
			EntityWrapper itemWrapper = new EntityWrapper(item);
			
			if(descontoStr != null){ 
			
			//aplicando desconto Pedido Projeto EXP
			
			BigDecimal precobase = itemWrapper.findGenericValue("PreUniP");
			BigDecimal valorPermitido = itemWrapper.findGenericValue("ValorPermitido");
			   if(valorPermitido == null) { 
				    
					  itemWrapper.setValue("ValorPermitido", precobase);
					  
					} 
			BigDecimal valorUnitario = itemWrapper.findGenericValue("ValorPermitido");		
					
			    
			
			
			BigDecimal PrecoEspecial = itemWrapper.findGenericValue("PrecoEspecial");
			BigDecimal precominimo  = itemWrapper.findGenericValue("PrecoMinimo");
			
			System.out.println("*** Gerencial jsp Valor unitario inicial :"+valorUnitario);
			
			
						
			
            
          
                		
			        
				   
			       precominimo =   DescontoHelper.aplicarDesconto(valorUnitario, maximodesconto);
				   valorUnitario = DescontoHelper.aplicarDesconto(valorUnitario, desconto);
			       System.out.println("*** Gerencial jsp Desconto gerencial :"+valorUnitario);
			       System.out.println("*** Gerencial jsp Valor unitario inicial com desconto gerencial :"+valorUnitario);
			
			       Long quantidade = itemWrapper.findGenericValue("quantidade");
			       BigDecimal valorTotal = valorUnitario.multiply(new BigDecimal(quantidade));
			       
				   itemWrapper.setValue("PrecoMinimo",precominimo);
			       itemWrapper.setValue("ValorAjustado", valorUnitario);
			       itemWrapper.setValue("PreTotalP", valorTotal);
			       itemWrapper.setValue("PrecoTotalExp", valorTotal);
			       itemWrapper.setValue("DesPedEXP", desconto);
				   
				   if (valorUnitario.floatValue() <  precominimo.floatValue()){
				       	 
						 itemWrapper.setValue("ContadorPrEspecial", 1L);
                         itemWrapper.setValue("ObsItemProjetoEXP","O Valor Unitario EXP Abaixo do  Desconto Permitido "); 
						 
				  									  
					   }else{
					   itemWrapper.setValue("ContadorPrEspecial", 0L);
					   itemWrapper.setValue("ObsItemProjetoEXP",""); 
					   }
				   
                   
				  
				   
			       
				   totalProjeto = totalProjeto.add(valorTotal);
				   PersistEngine.persist(itemWrapper.getObject());
			}   
			
			
		}
		
		totalValue = totalValue.add(totalProjeto);
		projetoWrapper.setValue("vltotproj", totalProjeto);
		totalValue = totalValue.add(totalProjeto);
		
		if (desmax < des){
				       	 
						 projetoWrapper.setValue("ContPrEXPP", 1L);		           
				  									  
					   }else{
					   projetoWrapper.setValue("ContPrEXPP", 0L);
					   }
		
		PersistEngine.persist(projetoWrapper.getObject());
	}
	
	
	
	
	pedidoWrapper.setValue("TotalGeral", totalValue);
	PersistEngine.persist(pedidoWrapper.getObject());
}


%>