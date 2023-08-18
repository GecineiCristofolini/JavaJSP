<%@page import="com.neomind.fusion.custom.tecnoperfil.industrial.IndustrialSnapShotPedido"%>
<%@page import="com.neomind.fusion.custom.tecnoperfil.hidroponia.HidroponiaSnapshotpedido"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.nio.file.Paths"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="com.neomind.fusion.doc.NeoStorage"%>
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
<!DOCTYPE html>
<html lang="en">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="../../../css/grid.css?v=3.9.4-921ea1" rel="stylesheet">

<%
	String pedidoId = request.getParameter("pedidoId");
	String resumoId = request.getParameter("resumoId");
	String tipoPedido = request.getParameter("tipo");

if (resumoId != null) {
	Class clazz = AdapterUtils.getEntityClass("SnapshotPedido");
	NeoBaseEntity pedido = PersistEngine.getNeoObject(clazz, new QLEqualsFilter("identificador", resumoId));
	EntityWrapper pedidoWrapper = new EntityWrapper(pedido);

	String content = pedidoWrapper.findGenericValue("content");
	out.write(content);
} else if (pedidoId != null) {

	try{
		Class clazz = AdapterUtils.getEntityClass("WorPedI");
		NeoBaseEntity processoPedido = PersistEngine.getNeoObject(clazz,
		new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));
		
		if(processoPedido != null){
			IndustrialSnapShotPedido hsp = new IndustrialSnapShotPedido();
			out.write(hsp.buildContent(processoPedido));
		} else {
			clazz = AdapterUtils.getEntityClass("FicInfCad");
			NeoBaseEntity processoPaiPedido = PersistEngine.getNeoObject(clazz,
			new QLEqualsFilter("neoId", Long.parseLong(pedidoId)));
			EntityWrapper processoPaiWrapper = new EntityWrapper(processoPaiPedido);
			processoPedido = processoPaiWrapper.findGenericValue("WFIND");
			if(processoPedido != null){
				IndustrialSnapShotPedido hsp = new IndustrialSnapShotPedido();
				out.write(hsp.buildContent(processoPedido));
			}else{
				out.write("Pedido não encontrado");
			}
		}
		
	} catch(Exception e){
		
		
	}

} else {
	String modeloCaminho = NeoStorage.getDefault().getPath() + File.separator + "relatorios" + File.separator
			+ "modelo_industrial.html";

		byte[] encoded = Files.readAllBytes(Paths.get(modeloCaminho));
		Map<String, String> parameters = new HashMap();
		String output = new String(encoded,"UTF-8");

		String url = PortalUtil.getBaseURL();
		url = url.concat("custom/hidroponia/resumo_hidroponia.jsp");


		out.write(output);
}

/*  */
%>
<style>
	.neo-title{
		font-weight: bold;
		/*text-align: center;*/
		font-size: medium;
	}
</style>
<script>

</script>
</html>