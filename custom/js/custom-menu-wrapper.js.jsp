<%@ page import="com.neomind.framework.base.multitenancy.SchemaHolder"%>
<%@ page import="com.neomind.fusion.engine.FusionRuntime"%>
<%@ page import="java.nio.file.Files"%>
<%@ page import="java.nio.file.Paths"%>
<%@ page contentType="text/javascript;charset=UTF-8" %>
<%!
    private String getCustomMenuPath()
	{
		if (FusionRuntime.isStandAloneEnvironment())
		{
			return "/custom/js/custom-menu.js.jsp";
		}
		else
		{
			return "/custom/" + SchemaHolder.getCurrentSchema() + "/js/custom-menu.js.jsp";
		}
	}
	private boolean doesFileExists(String virtualPath, ServletContext context)
	{
		try
		{
			String realPath = context.getRealPath(virtualPath);
			return Files.isRegularFile(Paths.get(realPath));
		}
		catch (Exception e)
		{
			return false;
		}
	}
%>
<%
    String customMenuFilePath = getCustomMenuPath();
    if (!doesFileExists(customMenuFilePath, request.getServletContext()))
    {
    	return;
    }
%>
<jsp:include page="<%= customMenuFilePath %>" />