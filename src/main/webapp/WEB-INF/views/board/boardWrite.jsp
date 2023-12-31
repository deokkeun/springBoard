<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardWrite</title>
<style>
#typeBox {
	width: 100%;
	display: flex;
	justify-content: space-between;
}
</style>
</head>
<script type="text/javascript">

	let classNum = 0;


	$j(document).ready(function(){
		
		const table = document.getElementById("table");
		
		$j("#submit").on("click",function(){
			
			const boardTitle = document.getElementsByClassName("boardTitle");
			for(let title of boardTitle) {
				if(title.value.length == 0) {
					alert("제목을 입력해주세요.");
					title.focus();
					return false;
				}
			}
			
			
			
		    // name이 같은 값들을 배열에 담는다.
		    let boardVoList = {};
		    
		    /* UPDATE */
	    	if(document.querySelector('input[name="boardVoList[0].boardType"]') != null) {
	    		boardVoList["boardVoList[0].boardType"] = document.querySelector('input[name="boardVoList[0].boardType"]').value;
	    		boardVoList["boardVoList[0].boardNum"] = document.querySelector('input[name="boardVoList[0].boardNum"]').value;
	    	}
	    	
		    /* INSERT */
		    for(let i = 0; i <= classNum; i++) {
		    	if(document.querySelector('input[name="boardVoList[' + i + '].creator"]') != null && document.querySelector('input[name="boardVoList[' + i + '].type"]') != null) {
		    		boardVoList["boardVoList[" + i + "].creator"] = document.querySelector('input[name="boardVoList[' + i + '].creator"]').value;
		    		boardVoList["boardVoList[" + i + "].type"] = document.querySelector('input[name="boardVoList[' + i + '].type"]').value;
		    		boardVoList["boardVoList[" + i + "].codeId"] = document.querySelector('select[name="boardVoList[' + i + '].codeId"]').value;
		    		boardVoList["boardVoList[" + i + "].boardTitle"] = document.querySelector('input[name="boardVoList[' + i + '].boardTitle"]').value;
		    		boardVoList["boardVoList[" + i + "].boardComment"] = document.querySelector('textarea[name="boardVoList[' + i + '].boardComment"]').value;
				}
		    }
		    
		/* 	var $frm = $j('.boardWrite :input');
			var param = $frm.serialize();
			console.log($frm);			
			console.log("param"+param); */
			
			$j.ajax({
			    url : "/board/boardWriteAction.do",
			    dataType: "json",
			    type: "POST",
			    data : boardVoList,
			    success: function(data, textStatus, jqXHR)
			    {
			    	if(data.update == 'Y') {
			    		/* console.log(param); */
			    		console.log(data);
						alert("수정완료");
						console.log(data);
						alert("update:"+data.success);
			    	}
			    	if(data.success == 'Y') {
			    		console.log(data);
						alert("작성완료");
						console.log(data);
						alert("Success:"+data.success);
			    	}
			    	
					location.href = "/board/boardList.do";
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	alert("Error");
			    }
			});
		});
	}); /* $j(document).ready(function() 끝 */

	
	function plus() {
		
	  	const cloneTable = document.getElementsByClassName("cloneTable0");
	  	const lastCloneTable = cloneTable[cloneTable.length - 1];
	  	
		classNum++;
		
		const creator = document.getElementById("creator");
		const type = document.getElementById("type");
		const cloneTable1 = document.getElementById("cloneTable1");
		const cloneTable2 = document.getElementById("cloneTable2");
		const cloneTable3 = document.getElementById("cloneTable3");
		  
		// 노드 복사하기 (deep copy)
		const newNode = creator.cloneNode(true);
		const newNode0 = type.cloneNode(true);
		const newNode1 = cloneTable1.cloneNode(true);
		const newNode2 = cloneTable2.cloneNode(true);
		const newNode3 = cloneTable3.cloneNode(true);
		
		// 복사된 노드 내부 입력되어있는 값 제거
		const inputElement1 = newNode1.querySelector('select[name="boardVoList[0].codeId"]');
		const inputElement2 = newNode2.querySelector('input[name="boardVoList[0].boardTitle"]');
		const inputElement3 = newNode3.querySelector('textarea[name="boardVoList[0].boardComment"]');
		const span = document.createElement("span");
		span.innerHTML += '<button type="button" onclick="minus(' + classNum + ');">삭제</button>';
		inputElement1.after(span);
		if (inputElement2) {
		    inputElement2.value = '';
		}
		if (inputElement3) {
		    inputElement3.value = '';
		}
		newNode.setAttribute("name", "boardVoList[" + classNum + "].creator");
		newNode0.setAttribute("name", "boardVoList[" + classNum + "].type");
		inputElement1.setAttribute("name", "boardVoList[" + classNum + "].codeId");
		inputElement2.setAttribute("name", "boardVoList[" + classNum + "].boardTitle");
		inputElement3.setAttribute("name", "boardVoList[" + classNum + "].boardComment");
		
		// 복사된 Node에 class 추가하기
		newNode1.classList.add('copyNode' + classNum);
		newNode2.classList.add('copyNode' + classNum);
		newNode3.classList.add('copyNode' + classNum);
		
		// 복사한 노드 붙여넣기
		creator.after(newNode);
		type.after(newNode0);
		lastCloneTable.after(newNode3);
		lastCloneTable.after(newNode2);
		lastCloneTable.after(newNode1);
	}
	
	
	function minus(classNum) {
		const creator = document.querySelector('input[name="boardVoList[' + classNum + '].creator"]');
		const type = document.querySelector('input[name="boardVoList[' + classNum + '].type"]');
		const removeElement = document.getElementsByClassName("copyNode" + classNum);
		for(let i = 0; i < removeElement.length; i++) {
			removeElement[i].remove();
		}
		creator.remove();
		type.remove();
		removeElement[0].remove();
	}
	
</script>
<body>
<form class="boardWrite">

	<c:if test="${type == 'update'}"> 
		<input name="boardVoList[0].boardType" type="hidden" value="${boardType}" />
		<input name="boardVoList[0].boardNum" type="hidden" value="${boardNum}" />
	</c:if>
	
	<input name="boardVoList[0].creator" id="creator" type="hidden" value="${loginMember.userName}" />
	<input name="boardVoList[0].type" id="type" type="hidden" value="${type}" />

	<table align="center">
		<tr>
			<td align="right">
				<c:if test="${type == 'write'}"> 
					<button	type="button" onclick="plus();">추가</button>
					<input id="submit" type="button" value="작성 완료">
				</c:if>
				<c:if test="${type == 'update'}"> 
					<input id="submit" type="button" value="수정 완료 ">
				</c:if>
			</td>
		</tr>
		<tr>
			<td>
				<table border ="1" id="table"> 
					<tr id="cloneTable1" class="cloneTable0 copyNode0">
						<td width="120" align="center">
						Type
						</td>
						<td width="400" id="typeBox">
							<select id="codeId" name="boardVoList[0].codeId">
								<c:forEach var="typeList" items="${boardTypeList}" varStatus="status">
									<c:choose>
										<c:when test="${!empty board.boardType}">
											<c:if test="${board.boardType.equals(typeList.codeId)}">
												<option name="codeId" value="${board.boardType}" selected>${board.codeName}</option>
											</c:if>
											<c:if test="${!board.boardType.equals(typeList.codeId)}">
												<option name="codeId" value="${typeList.codeId}">${typeList.codeName}</option>
											</c:if>
										</c:when>
										<c:otherwise>
											<option name="codeId" value="${typeList.codeId}">${typeList.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr id="cloneTable2" class="cloneTable0 copyNode0">
						<td width="120" align="center">
						Title
						</td>
						<td width="400">
						<input name="boardVoList[0].boardTitle" class="boardTitle" type="text" size="50" maxlength="16" value="${board.boardTitle}"> 
						</td>
					</tr>
					<tr id="cloneTable3" class="cloneTable0 copyNode0">
						<td height="300" align="center">
						Comment
						</td>
						<td valign="top">
						<textarea name="boardVoList[0].boardComment" class="boardComment" rows="20" cols="55" maxlength="333">${board.boardComment}</textarea>
						</td>
					</tr>
					<tr>
						<td align="center">
						Writer
						</td>
						<td>
							<c:choose>
								<c:when test="${board.creator == null}">
									<c:if test="${loginMember.userName != null}">
										${loginMember.userName}
										</c:if>
										<c:if test="${loginMember.userName == null}">
										SYSTEM
									</c:if>
								</c:when>
								<c:otherwise>
									<c:if test="${loginMember.userName != null}">
									${loginMember.userName}
									</c:if>
									<c:if test="${loginMember.userName == null}">
									SYSTEM
									</c:if>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
	</table>
</form>	
</body>
</html>