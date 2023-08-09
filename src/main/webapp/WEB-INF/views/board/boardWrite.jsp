<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardWrite</title>
</head>
<script type="text/javascript">

	let selectTypeStr = "";

	function changeFn() {
		selectTypeStr = "";
		let selectTypeBox = document.getElementsByName("selectTypeBox");
		var codeIdArr = document.getElementById("codeIdArr");
		
		console.log(selectTypeBox[0].value);
		for(let i = 0; i < selectTypeBox.length; i++) {
			/* alert("selectType[" + i + "]:"+ selectTypeBox[i].value); */
			selectTypeStr += selectTypeBox[i].value + ",";
		}
		codeIdArr.value = selectTypeStr;
		
		
		var codeId = document.getElementById("codeId");
		var codeIdType = document.getElementById("codeIdType");
		var selectCodeIdType = (codeIdType.options[codeIdType.selectedIndex].value);
		/* alert("selectCodeIdType = "+selectCodeIdType); */
		codeId.value = selectCodeIdType;
	}
	
	$j(document).ready(function(){
		const table = document.getElementById("table");
		const plusBtn = document.getElementById("plusBtn");
		const minusBtn = document.getElementById("minusBtn");
		
		
		
		const boardTitle = document.getElementById("boardTitle");
		const boardComment = document.getElementById("boardComment");
		$j("#submit").on("click",function(){
			boardTitle.value += ",,";
			boardComment.value += ",,";
			
			var $frm = $j('.boardWrite :input');
			var param = $frm.serialize();
			console.log($frm);			
			console.log(param);
			
			$j.ajax({
			    url : "/board/boardWriteAction.do",
			    dataType: "json",
			    type: "POST",
			    data : param, selectTypeStr,
			    success: function(data, textStatus, jqXHR)
			    {
			    	if(data.update == 'Y') {
			    		console.log(param);
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

	
	let classNum = 0;
	
	
	function plus() {
		const cloneTable1 = document.getElementById("cloneTable1");
		const cloneTable2 = document.getElementById("cloneTable2");
		const cloneTable3 = document.getElementById("cloneTable3");
	  	// 'test' node 선택
		const tr3 = table.children[0].children[2];
	  
	  // 노드 복사하기 (deep copy)
	  const newNode1 = cloneTable1.cloneNode(true);
	  const newNode2 = cloneTable2.cloneNode(true);
	  const newNode3 = cloneTable3.cloneNode(true);
	  
	  // 복사된 Node에 class 추가하기
	  classNum++;
	  newNode1.classList.add('copyNode' + classNum);
	  newNode2.classList.add('copyNode' + classNum);
	  newNode3.classList.add('copyNode' + classNum);
	  
	  // 복사한 노드 붙여넣기
	  tr3.after(newNode3);
	  tr3.after(newNode2);
	  tr3.after(newNode1);
		
	  copyNodeCount();
	  
		/* type 기본값 배열 생성 */
		changeFn();
	}
	
	function minus() {
		const removeNumber = $j("#selectBox").val();
		console.log("선택자"+$j("#selectBox").val());

		if(removeNumber == "기본값") {
			alert("기본값은 제거할 수 없습니다.");
		}
		
		/* 테이블 제거 */
		const removeElement = document.getElementsByClassName("copyNode" + removeNumber);
		for(let i = 0; i < removeElement.length; i++) {
			removeElement[i].remove();
		}
			removeElement[0].remove();
			
			$j("#selectBox option[value=" + removeNumber + "]").remove();
			
	}
	
	
	function copyNodeCount() {
		/* 복제된 노드 개수 */
		const cloneTable0 = (document.getElementsByClassName("cloneTable0").length / 3) - 1;
		const selectBox = document.getElementById("selectBox");
		const option = document.createElement("option");
		option.setAttribute("value", selectBox.length);
		option.innerText = selectBox.length;
		selectBox.append(option);
	}
	
	

</script>
<body>
<form class="boardWrite">

	<c:if test="${type == 'update'}"> 
		<input name="boardType" type="hidden" value="${boardType}" />
		<input name="boardNum" type="hidden" value="${boardNum}" />
	</c:if>

	<input name="codeId" id="codeId" type="hidden" value="${boardType}" />
	<input name="codeIdArr" id="codeIdArr" type="hidden" value="${boardType}" />
	<input name="creator" id="creator" type="hidden" value="${loginMember.userName}" />
	<input name="type" id="type" type="hidden" value="${type}" />

	<table align="center">
		<tr>
			<td align="right">
				
				<!-- 게시글 추가 -->
				<button	type="button" id="plusBtn" onclick="plus();">+</button>
				
				<select id="selectBox">
					<option value="기본값">기본값</option>
				</select>
				<!-- 게시글 제거 -->
				<button	type="button" id="minusBtn" onclick="minus();">-</button>
				
				
				<c:if test="${type == 'write'}"> 
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
					<tr id="cloneTable1" class="cloneTable0">
						<td width="120" align="center">
						Type
						</td>
						<td width="400">
							<select id="codeIdType" name="selectTypeBox" onchange="changeFn()">
								<c:forEach var="typeList" items="${boardTypeList}" varStatus="status">
									<c:choose>
										<c:when test="${!empty board.boardType}">
											<c:if test="${board.boardType.equals(typeList.codeId)}">
												<option name="codeIdType" value="${board.boardType}" selected>${board.codeName}</option>
											</c:if>
											<c:if test="${!board.boardType.equals(typeList.codeId)}">
												<option name="codeIdType" value="${typeList.codeId}">${typeList.codeName}</option>
											</c:if>
										</c:when>
										<c:otherwise>
											<option name="codeIdType" value="${typeList.codeId}">${typeList.codeName}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr id="cloneTable2" class="cloneTable0">
						<td width="120" align="center">
						Title
						</td>
						<td width="400">
						<input name="boardTitle" id="boardTitle" type="text" size="50" value="${board.boardTitle}"> 
						</td>
					</tr>
					<tr id="cloneTable3" class="cloneTable0">
						<td height="300" align="center">
						Comment
						</td>
						<td valign="top">
						<textarea name="boardComment" id="boardComment" rows="20" cols="55">${board.boardComment}</textarea>
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