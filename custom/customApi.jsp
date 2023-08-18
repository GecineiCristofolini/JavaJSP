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

<%!private JSONObject objectToJson(Set<FieldInfo> fields, NeoBaseEntity controleObject) {
		if (controleObject == null) {
			return null;
		}

		JSONObject json = new JSONObject();

		EntityWrapper wrapper = new EntityWrapper(controleObject);

		for (FieldInfo field : fields) {

			try {
				if (field.isArray()) {
					FieldWrapper wField = wrapper.findField(field.getName());
					if (wField.getValue() instanceof List) {
						JSONArray values = new JSONArray();
						List<NeoBaseEntity> objects = wrapper.findGenericValue(field.getName());
						EntityInfo info = EntityRegister.getInstance().getCache().getByString(field.getTypeName());

						for (NeoBaseEntity object : objects) {
							values.add(objectToJson(info.getFieldSet(), object));
						}

						json.put(field.getName(), values);
					}

					continue;
				} else if (field.getType().equals(GregorianCalendar.class)) {
					GregorianCalendar value = wrapper.findGenericValue(field.getName());

					json.put(field.getName(), NeoCalendarUtils.dateToString(value));

				} else if (NeoObject.class.isAssignableFrom(field.getType())) {
					NeoBaseEntity value = wrapper.findGenericValue(field.getName());
					if (NeoUtils.safeIsNotNull(value)) {
						EntityInfo info = EntityRegister.getInstance().getCache().getByString(field.getTypeName());
						json.put(field.getName(), objectToJson(info.getFieldSet(), value));
					} else {
						json.put(field.getName(), null);
					}

				} else if (BigDecimal.class.isAssignableFrom(field.getType())) {
					BigDecimal value = wrapper.findGenericValue(field.getName());

					json.put(field.getName(), value);
				} else {
					Object value = wrapper.findGenericValue(field.getName());
					json.put(field.getName(),
							NeoUtils.safeIsNull((Object) wrapper.findGenericValue(field.getName())) ? ""
									: wrapper.findGenericValue(field.getName()).toString());
				}
			} catch (Exception e) {
				json.put("error_field", field.getName());
				json.put("error_parent_object", controleObject.id());
			}

		}

		json.put("neoId", wrapper.findGenericValue("neoId"));

		return json;
	}%>
<%
	if (!request.getMethod().toUpperCase().equals("GET")) {
	return;
}
response.setContentType("application/json");
response.setHeader("Access-Control-Allow-Origin", "*");

String entityName = request.getParameter("entity");
String id = request.getParameter("id");

if (NeoUtils.safeIsNotNull(entityName)) {
	EntityInfo info = EntityRegister.getInstance().getCache().getByString(entityName);
	Set<FieldInfo> fields = info.getFieldSet();

	Class clazz = AdapterUtils.getEntityClass(entityName);
	QLEqualsFilter filter;
	if (id != null) {
		filter = new QLEqualsFilter("neoId", Long.parseLong(id));
		NeoBaseEntity controleObjec = PersistEngine.getNeoObject(clazz,
		new QLEqualsFilter("neoId", Long.parseLong(id)));
		if(controleObjec != null){
			EntityWrapper wrapper = new EntityWrapper((NeoObject) controleObjec);
			out.write(objectToJson(fields, controleObjec).toString());			
		}

	} else {
		List<NeoBaseEntity> results = PersistEngine.getObjects(clazz);

		JSONArray jsons = new JSONArray();
		for (NeoBaseEntity entity : results) {
			jsons.add(objectToJson(fields, entity));
		}

		out.write(jsons.toString());
	}
}
%>

