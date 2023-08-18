<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.neomind.fusion.search.lucene.FileUtils"%>
<%@page import="com.neomind.fusion.persist.QLGroupFilter"%>
<%@page import="com.neomind.fusion.persist.QLOpFilter"%>
<%@page import="com.neomind.fusion.workflow.WFProcess"%>
<%@page import="com.neomind.fusion.doc.NeoStorage"%>
<%@page import="com.neomind.util.NeoFileUtils"%>
<%@page import="com.neomind.util.NeoFileUtils"%>
<%@page import="com.neomind.fusion.doc.NeoFile"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.File"%>
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
	System.out.println("Iniciando importação");
	try {
		request.setCharacterEncoding("UTF-8");
		String filePath = "/neomind/bancoimagem";

		File tempFolder = new File(filePath);
		if (!tempFolder.exists()) {
			tempFolder.mkdir();
		}
		
		System.out.println("Upload de arquivos - 1 Criando a pasta");

		String path = request.getParameter("caminho");
		if(path == null || path.length() < 0){
			System.out.println("Upload de arquivos - Caminho vazio");
			System.out.println(path);
			return;
		}
		
		System.out.println("Upload de arquivos - 2 Validação dos parametros");
		

		Class folderClass = AdapterUtils.getEntityClass("Folder");
		File originFile = new File(filePath.concat(File.separator).concat(path));
		if(!originFile.exists()){
			
			System.out.println("Upload de arquivos - Arquivo não existe");
			System.out.println(originFile.getAbsolutePath());
			return;
		}
		NeoFile tempFile = NeoStorage.getDefault().copy(originFile);
		System.out.println("Upload de arquivos - 4 Criando neoFile");

		NeoBaseEntity entity = AdapterUtils.createNewEntityInstance("MainLiberacaoDeDocumentos");
		NeoBaseEntity dadosEntity = AdapterUtils.createNewEntityInstance("DadosDoDocumento");
		EntityWrapper wrapper = new EntityWrapper(entity);
		EntityWrapper dadosWrapper = new EntityWrapper(dadosEntity);

		NeoBaseEntity bancoDeImagensFolder = PersistEngine.getNeoObject(folderClass,
				new QLEqualsFilter("name", "[MKT] Banco de imagens"));
		if (bancoDeImagensFolder != null) {
			

			dadosWrapper.setValue("Arquivo", tempFile);

			String[] pathList = path.split("/");
			EntityWrapper folderWrapper = new EntityWrapper(bancoDeImagensFolder);
			Long pathId = folderWrapper.findGenericValue("neoId");
			for (int i = 0; i < pathList.length; i++) {
				String currentItem = pathList[i];

				System.out.println("Buscando pasta epecífica " + currentItem);
				if (!currentItem.contains(".")) {
					System.out.println("Upload de arquivos - 5 Buscando pasta pai do banco de imagens");
					QLGroupFilter filter = new QLGroupFilter("AND");
					filter.addFilter(new QLEqualsFilter("parentId", pathId));
					filter.addFilter(new QLEqualsFilter("name", currentItem));
					bancoDeImagensFolder = PersistEngine.getNeoObject(folderClass, filter);
					if (bancoDeImagensFolder != null) {
						folderWrapper = new EntityWrapper(bancoDeImagensFolder);
						pathId = folderWrapper.findGenericValue("neoId");
					} else {
						System.out.println("Upload de arquivos - 6 Pasta não encontrada: "+path);
						System.out.println("Pasta não encontrada : "+currentItem);
					}

				} else {
					break;
				}
			}

			dadosWrapper.setValue("PastaDoDocumentoo", bancoDeImagensFolder);
			dadosWrapper.setValue("caminho", path);

			PersistEngine.persist(dadosWrapper.getObject());
			System.out.println("Upload de arquivos - 6 Atribuindo dados do docuento");
			wrapper.setValue("DadosDoDocumento", dadosWrapper.getObject());
			
			
			PersistEngine.persist(wrapper.getObject());
			System.out.println("Upload de arquivos - 7 Armazenando");


			WFProcess wf = AdapterUtils.startWFProcess("Liberação de Documento",
					(NeoObject) wrapper.getObject(), null);
			System.out.println("Upload de arquivos - 8 Instanciando processo");
			
			wf.start();
			System.out.println("Upload de arquivos - 9 iniciando");
			
		} else {
			System.out.println("problemas ao verificar pastas");
		}

	} catch (Exception e) {
		response.setStatus(500);
		e.printStackTrace();
	}
%>



