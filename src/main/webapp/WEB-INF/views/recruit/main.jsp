<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>recruit</title>
<style>
.outLineTable > thead > tr > td,
.outLineTable > tbody > tr > td {
	border: none;
}
.outLineTable {
	border-style: double;
}
.outLineTable table:not(#headTable) {
	width: 80%;
}
#headTable {
	margin-top: 20px;
}
.center {
	text-align: center;
	margin: 20px;
}
#name,
#phone {
	pointer-events: none;
}
</style>
</head>
<script type="text/javascript">

	/* 유효성 검사 객체 */
	const checkObj = {
		"email"					: false,
		"birth" 				: false,
		"addr"					: false,
		"educationStartPeriod"	: false,
		"educationEndPeriod"	: false,
		"educationSchoolName"	: false,
		"major"					: false,
		"grade"					: false
	}
	
	/* 한개라도 입력 되어있으면 모두 입력, 하나도 입력 안되어있으면 그냥 넘어감 */
	const checkCareer = {
		"careerStartPeriod"		: false,
		"careerEndPeriod"		: false,
		"careerCompName"		: false,
		"careerTask"			: false,
		"careerLocation"		: false
	}
	
	/* 한개라도 입력 되어있으면 모두 입력, 하나도 입력 안되어있으면 그냥 넘어감 */
	const checkCertificate = {
		"certificateQualifiName"	: false,
		"certificateAcquDate"		: false,
		"certificateOrganizeName"	: false
	}
	
	/* saveAndSubmitValidate(checkObj) 함수 내부에서 호출 */
	/* 저장 or 제출 전(기간 확인 함수) */
	function checkPeriod(length, key, i, str) {
		console.log("length = " + length);
		console.log("key = " + key);
		console.log("i = " + i);
		console.log("str = " + str);
		
		if(length == 0) {
			alert(str + "기간을 입력해주세요.");
			document.getElementsByClassName(key)[i].focus();
			saveResult = false;
			return '1';
		} else if(length != 7) {
			alert(str + "기간이 (YYYY.MM)형식에 맞게 입력 되었는지 다시 확인해주세요.");
			document.getElementsByClassName(key)[i].focus();
			saveResult = false;
			return '1';
		} else {
			const regExp = /^[\d]{4}[\.]{1}[\d]{2}$/;
	   		if(regExp.test(document.getElementsByClassName(key)[i].value)) {
	   		} else {
	   			alert(str + "기간을 (YYYY.MM)형식에 맞게 입력해주세요.");
	   			document.getElementsByClassName(key)[i].focus();
				saveResult = false;
				return '1';
	   		}
		}
	}


	var saveResult = false; /* 저장 or 제출 할지 말지 결정 */
	/* saveAndSubmit */
	/* 저장 or 제출 전 확인 함수 */
	function saveAndSubmitValidate(checkObj) {
		
		var keyEl;
		for(let key in checkObj) {
			if(!checkObj[key]) {
				
				switch(key) {
				case"email": case"birth": case"addr": 
					if(key == "email") {
						if(document.getElementById(key).value.length == 0) {
							alert("이메일을 입력해주세요.");
						} else {
							alert("이메일을 test@gmail.com 형식에 맞게 입력해주세요.");
						}
					} else if(key == "birth") {
						if(document.getElementById(key).value.length == 0) {
							alert("생년월일을 입력해주세요.");
						} else {
							alert("생년월일을 YYMMDD 형식에 맞게 입력해주세요.\n 20년 01월 01일 \n ex) 200101");
						}
					} else if(key == "addr") {
						alert("주소를 입력해주세요.");
					}
					document.getElementById(key).focus();
					saveResult = false;
					return true;
					break;					
				case"educationStartPeriod": case"educationEndPeriod": case"educationSchoolName": case"major": case"grade":
					keyEl = document.getElementsByClassName(key);
					for(let i = 0; i < keyEl.length; i++) {
						
						/* 함수 실행 */
						if(key == 'educationStartPeriod' || key == 'educationEndPeriod') {
							
							/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 테스트 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
							const str = keyEl[i].getAttribute("name"); /* 재학기간 시작 or 종료 name값  */
	    					
		    				if(keyEl[i].className == "dateType educationStartPeriod") {
		    					const endStr = str.replace("start", "end"); /* 재학기간 종료 name값  */
		    					const endCheck = document.getElementsByName(endStr)[0]; /* 재학기간 종료 요소 */
		    					inputDateCheck(keyEl[i], endCheck, "start");
		    				
		    				} else if(keyEl[i].className == "dateType educationEndPeriod") { /* 재학기간 종료이면 시작 과 비교 검증 */
		    					const startStr = str.replace("end", "start"); /* 재학기간 시작 name값  */
		    					const startCheck = document.getElementsByName(startStr)[0]; /* 재학기간 시작 요소 */
		    					inputDateCheck(keyEl[i], startCheck, "end");
		    				}/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 테스트 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
		    				
							
							
							let length = 0;
							length = keyEl[i].value.length;
							
							var result = checkPeriod(length, key, i, "재학");
							console.log(result);
							if(result > 0) {
								return true;
							}
						}
						
						if(keyEl[i].value.length == 0) { /* 입력 안되어 있으면 */
							if(key == "educationSchoolName") {
								alert("학교명을 입력해주세요.");
							} else if(key == "major") {
								alert("전공을 입력해주세요.");
							} else if(key == "grade") {
								alert("학점을 입력해주세요.");
							}
						
							document.getElementsByClassName(key)[i].focus();
							saveResult = false;
							return true;
						} 
					}; break;
				}; /* switch */
			}; /* if(!checkObj[key]) */
		} /* for(let key in checkObj) */
		
		
		/* 경력테이블 */
		/* 한개라도 입력 되어있으면 모두 입력, 하나도 입력 안되어있으면 그냥 넘어감 */
		let count = 0;
		const careerStartPeriod = document.getElementsByClassName("careerStartPeriod");
		for(let i = 0; i < careerStartPeriod.length; i++) {
			
			count = 0;
			for(let key in checkCareer) { /* 입력된게 1개라도 있는지 확인 */
				count += document.getElementsByClassName(key)[i].value.length;
			}
			
			if(count > 0) {
				console.log("career 입력된 내용이 있음");
				
				for(let key in checkCareer) {
					let length = 0;
					length = document.getElementsByClassName(key)[i].value.length;

					if(key == 'careerStartPeriod' || key == 'careerEndPeriod') {
						var result = checkPeriod(length, key, i, "근무");
						console.log(result);
						if(result > 0) {
							return true;
						}
					}
					
					if(length == 0) {
						if(key == "careerCompName") {
							alert("회사명을 입력해주세요.");
						} else if(key == "careerTask") {
							alert("부서/직급/직책을 입력해주세요.");
						} else if(key == "careerLocation") {
							alert("지역을 입력해주세요.");
						}
						
						document.getElementsByClassName(key)[i].focus();
						saveResult = false;
						return true;
					}
				}
			} else {
				console.log("career 입력된 내용이 없음");
			}
		}/* 경력테이블 끝 */
		
		
		
		/* 자격증테이블 */
		/* 한개라도 입력 되어있으면 모두 입력, 하나도 입력 안되어있으면 그냥 넘어감 */
		let count1 = 0;
		const certificateQualifiName = document.getElementsByClassName("certificateQualifiName");
		for(let i = 0; i < certificateQualifiName.length; i++) {
			
			count1 = 0;
			for(let key in checkCertificate) { /* 입력된게 1개라도 있는지 확인 */
				count1 += document.getElementsByClassName(key)[i].value.length;
			}
			
			if(count1 > 0) {
				console.log("certificate 입력된 내용이 있음");
				
				for(let key in checkCertificate) {
					let length = 0;
					length = document.getElementsByClassName(key)[i].value.length;
					
					if(key == 'certificateAcquDate') {
						var result = checkPeriod(length, key, i, "취득");
						console.log(result);
						if(result > 0) {
							return true;
						}
					}
					
					if(length == 0) {
						if(key == "certificateQualifiName") {
							alert("자격증명을 입력해주세요.");
						} else if(key == "certificateOrganizeName") {
							alert("발행처를 입력해주세요.");
						}
						
						document.getElementsByClassName(key)[i].focus();
						saveResult = false;
						return true;
					}
				}
			} else {
				console.log("certificate 입력된 내용이 없음");
			}
		}/* 자격증테이블 끝 */
		
		saveResult = true;
	}


	/* 제출전 확인 */
	function recruitValidate() {
		if(confirm("제출하시면 수정이 되지 않습니다.")) {
			saveAndSubmitValidate(checkObj);
			if (saveResult == true) {
				return true;
			}
		}
			return false;
	}
		
	let tr1Num = 0; /* 학력 테이블 총 개수 (추가 / 삭제) */
	let tr2Num = 0; /* 경력 테이블 총 개수 (추가 / 삭제) */
	let tr3Num = 0; /* 자격증 테이블 총 개수 (추가 / 삭제) */

	/* 삭제 리스트 */
 	var removeStr1 = "";
	var removeStr2 = "";
	var removeStr3 = "";
	
	
	/* 숫자만 입력 */
	function checkNumberCode(event) {
		  const regExp = /[^0-9]/g;
		  const ele = event.target;
		  if (regExp.test(ele.value)) {
		    ele.value = ele.value.replace(regExp, '');
		  }
	};
	/* 숫자, "."만 입력 */
	function checkNumberDotCode(event) {
		  const regExp = /[^0-9\.]/g;
		  const ele = event.target;
		  if (regExp.test(ele.value)) {
		    ele.value = ele.value.replace(regExp, '');
		  }
	};
	/* 주소용(한글, 숫자)만 입력 */
	function checkKoreaAddrCode(event) {
		  const regExp = /[^\u3131-\u318E\uAC00-\uD7A30-9\s]/g;
		  const ele = event.target;
		  if (regExp.test(ele.value)) {
		    ele.value = ele.value.replace(regExp, '');
		  }
	};
	/* 한글만 입력 */
	function checkKoreaCode(event) {
		  const regExp = /[^\u3131-\u318E\uAC00-\uD7A3\s]/g;
		  const ele = event.target;
		  if (regExp.test(ele.value)) {
		    ele.value = ele.value.replace(regExp, '');
		  }
	};
	/* 영어, 숫자, (@, .) 만 입력 */
	function checkEnglishCode(event) {
		  const regExp = /[^0-9a-zA-Z\@\.]/g;
		  const ele = event.target;
		  if (regExp.test(ele.value)) {
		    ele.value = ele.value.replace(regExp, '');
		  }
	};

	
	var keyCode;
	/* keydownHandler */
	function keydownHandler(event) {
		keyCode = event.keyCode || event.which;
		console.log('keydown:' + keyCode);
	}
	
	/* ************************** 기간 입력 유효성 검사 check ************************** */
	function inputDateCheck(obj, objCheck, str) {
		if(str == 'start') {
			/* 시작연도 > 종료연도 */
			if(obj.value.substr(0, 4) > objCheck.value.substr(0, 4)) {
				alert("시작일이 종료일보다 이 후 일수는 없습니다.\n다시 입력하여 주시기 바랍니다.");
				obj.value = "";
			} else if(obj.value.substr(0, 4) == objCheck.value.substr(0, 4)) {
				/* 시작 달 > 종료 달 */
				if(obj.value.substr(5, 2) > objCheck.value.substr(5, 2)) {
					alert("시작일이 종료일보다 이 후 일수는 없습니다.");
					obj.value = obj.value.substr(0, 4);
				/* 시작 달 == 종료 달 */
				} else if(obj.value.substr(5, 2) == objCheck.value.substr(5, 2)) {
					alert("시작일과 종료일이 같을 수 없습니다.");
					obj.value = obj.value.substr(0, 4);
				}
			}
		} else if(str == 'end') {
			/* 종료연도 < 시작연도 */
			if(obj.value.substr(0, 4) < objCheck.value.substr(0, 4)) {
				alert("종료일이 시작일보다 이 전 일수는 없습니다.\n다시 입력하여 주시기 바랍니다.");
				obj.value = "";
			} else if(obj.value.substr(0, 4) == objCheck.value.substr(0, 4)) {
				/* 종료 달 < 시작 달 */
				if(obj.value.substr(5, 2) < objCheck.value.substr(5, 2)) {
					alert("종료일이 시작일보다 이 전 일수는 없습니다.");
					obj.value = obj.value.substr(0, 4);
				/* 종료 달 == 시작 달 */
				} else if(obj.value.substr(5, 2) == objCheck.value.substr(5, 2)) {
					alert("시작일과 종료일이 같을 수 없습니다.");
					obj.value = obj.value.substr(0, 4);
				}
			}
		}
		
		
	}
	 
	/* ************************** 기간 입력 유효성 검사 ************************** */
	function inputDate(obj) {
		console.log("inputDate 실행");
		keydownHandler(event);
		
		/* 숫자, '.'만 입력 */
		const regExp = /[^0-9\.]/g;
		if (regExp.test(obj.value)) {
			obj.value = obj.value.replace(regExp, '');
			alert("숫자만 입력해주세요.");
		}
			
    	if(obj.value.length == 4) {
    		  const regExp = /^[\d]{4}$/;
    		  if (regExp.test(obj.value)) {
    				const today = new Date();
    				console.log(today.getFullYear());
    				console.log(obj.value.substr(0,4));
    				if(obj.value.substr(0,4) > today.getFullYear()) {
    					alert("현재(" + today.getFullYear() + ")보다 미래의 날짜를 입력할 수 없습니다.");
    					obj.value = "";
    				    
    				} else if(obj.value.substr(0,4) < 1950) {
    					alert("1950년 이후로 입력 가능합니다.");
    					obj.value = "";
    				} else {
    					/* 4자리 숫자 입력하면 5번째 . 자동입력 */
    					obj.value = obj.value.substr(0,4) + '.';
    				
    					/* 지울때 5번째 . 제거 */
   			            if(keyCode === 8){  
   			            	if(obj.value.substr(4,1) == ".") {
   			            		obj.value = obj.value.substr(0,4);
   			            	}
   			            }
    				}
    		  }
    	}
    	
    	/* 5번째가 . 이 아니면 변경 */
    	if(obj.value.length == 5) {
    		if(obj.value.substr(4, 1) != '.') {
    			obj.value = obj.value.substr(0, 4) + '.';
    		}
    	}
    	
    	/* 작성 완료 확인 */
	   	if(obj.value.length == 7) {
		const regExp = /^[\d]{4}[\.]{1}[\d]{2}$/;
	   		if(regExp.test(obj.value)) {
		    		console.log(obj.value.substr(5,2));
		    		if(01 > obj.value.substr(5,2) || obj.value.substr(5,2) > 12) {
		    			obj.value = obj.value.substr(0,5);
		    			alert("01월 ~ 12월 사이로 입력해주세요.");
		    		} else {
		    			
		    			/* 재학기간, 근무기간 겹치는지 확인 */
		    			const checkDate = obj.value.substr(0, 4) + obj.value.substr(5, 2);
		    			
		    			if(obj.className == "dateType educationStartPeriod" || obj.className == "dateType educationEndPeriod") {
	    				
		    				
		    				/* 재학기간 겹치는지 확인 */
		    				const educationStartPeriod = document.getElementsByClassName("educationStartPeriod"); /* 재학기간 시작 */
		    				const educationEndPeriod = document.getElementsByClassName("educationEndPeriod"); /* 재학기간 종료 */
			    			for(let x = 0; x < educationStartPeriod.length; x++) {
								for(let y = 0; y < educationStartPeriod.length; y++) {
									if(y != x) {
										const startDateCheck = educationStartPeriod[y].value.substr(0, 4) + educationStartPeriod[y].value.substr(5, 2);
										const endDateCheck = educationEndPeriod[y].value.substr(0, 4) + educationEndPeriod[y].value.substr(5, 2);
										if(startDateCheck < checkDate && checkDate < endDateCheck) {
											alert("재학기간이 겹쳐요. 다시 입력해주세요.");
											obj.value = "";
											obj.focus();
											return true;
										}
									}
								}
			    			}/* 재학기간 겹치는지 확인 종료 */
			    			
			    			
		    			} else if(obj.className == "dateType careerStartPeriod" || obj.className == "dateType careerEndPeriod") {
		    				const str = obj.getAttribute("name"); /* 근무기간 시작 or 종료 name값  */
		    				
		    				if(obj.className == "dateType careerStartPeriod") {
		    					const endStr = str.replace("start", "end"); /* 근무기간 종료 name값  */
		    					const endCheck = document.getElementsByName(endStr)[0]; /* 근무기간 종료 요소 */
		    					inputDateCheck(obj, endCheck, "start");
		    					
		    				} else if(obj.className == "dateType careerEndPeriod") { /* 근무기간 종료이면 시작 과 비교 검증 */
		    					const startStr = str.replace("end", "start"); /* 근무기간 시작 name값  */
		    					const startCheck = document.getElementsByName(startStr)[0]; /* 근무기간 시작 요소 */
		    					inputDateCheck(obj, startCheck, "end");
		    				}
		    				
		    				 /* 근무기간 겹치는지 확인 */
		    				const careerStartPeriod = document.getElementsByClassName("careerStartPeriod");
		    				const careerEndPeriod = document.getElementsByClassName("careerEndPeriod");
		    				for(let x = 0; x < careerStartPeriod.length; x++) {
								for(let y = 0; y < careerStartPeriod.length; y++) {
									if(y != x) {
										const startDateCheck = careerStartPeriod[y].value.substr(0, 4) + careerStartPeriod[y].value.substr(5, 2);
										const endDateCheck = careerEndPeriod[y].value.substr(0, 4) + careerStartPeriod[y].value.substr(5, 2);
										if(startDateCheck < checkDate && checkDate < endDateCheck) {
											alert("근무기간이 겹쳐요. 다시 입력해주세요.");
											obj.value = "";
											obj.focus();
											return true;
										}
									}
								}
			    			}/* 근무기간 겹치는지 확인 종료 */
		    			}
		    		}
	   		} else {
	   			alert("YYYY.MM 형식으로 입력해주세요.");
			}
	   	}
	}; 
	/* ************************** 기간 입력 유효성 검사 종료 ************************** */
	
	
	
	
	
	$j(document).ready(function(){
		/* ----------------------------------------- 유효성 검사 ----------------------------------------- */
		/* 이메일 유효성 검사(처음 화면 입력 전 상태) */
		const email = document.getElementById("email");
		const emailRegExp = /^[\w\-\_]{4,}@[\w\-\_]+(\.\w+){1,3}$/;
		if(emailRegExp.test(email.value)) {
			checkObj.email = true;
			console.log("이메일" + checkObj.email);
		} else {
			checkObj.email = false;
			console.log("이메일" + checkObj.email);
		}
		
		/* 이메일 유효성 검사 (입력 시) */
		$j("#email").on("input", e => {
			checkEnglishCode(e);
			
			const regExp = /^[\w\-\_]{4,}@[\w\-\_]+(\.\w+){1,3}$/;
			if(regExp.test(e.target.value)) {
				checkObj.email = true;
				console.log("input"+checkObj.email);
			} else {
				checkObj.email = false;
				console.log("input"+checkObj.email);
			}
		});
		
		/* 생년월일 유효성 검사(처음 화면 입력 전 상태) */
		const birth = document.getElementById("birth");
		const birthRegExp = /^([0-9][0-9])(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$/;
		if(birthRegExp.test(birth.value)) {
			checkObj.birth = true;
			console.log("생년월일" + checkObj.birth);
		} else {
			checkObj.birth = false;
			console.log("생년월일" + checkObj.birth);
		}
		
		/* 생년월일 유효성 검사 (입력 시) */
		$j("#birth").on("input", e => {
			checkNumberCode(e);
 			const regExp = /^([0-9][0-9])(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$/;
			if(regExp.test(e.target.value)) {
				checkObj.birth = true;
				console.log(checkObj.birth);
			} else {
				checkObj.birth = false;
				console.log(checkObj.birth);
			}
		});
		
		/* 주소 유효성 검사(처음 화면 입력 전 상태) */
		const addr = document.getElementById("addr");
		if(addr.value.length != 0) {
			checkObj.addr = true;
			console.log("주소" + checkObj.addr);
		} else {
			checkObj.addr = false;
			console.log("주소" + checkObj.addr);
		}
		
		/* 주소 (입력 시) */
		$j("#addr").on("input", e => {
			checkKoreaAddrCode(e);
			if(e.target.value.length != 0) {
				checkObj.addr = true;
				console.log(checkObj.addr);
			} else {
				checkObj.addr = false;
				console.log(checkObj.addr);
			}
		});

		/* 숫자, "."만 입력 */
		$j(".checkNumberDot").on("input", e => {
			checkNumberDotCode(e);
		});
		/* ----------------------------------------- 유효성 검사 끝 ----------------------------------------- */
		
		
		
		/* ----------------------------------------- Select(성별, 희망근무지, 근무형태) ----------------------------------------- */
		const gender = document.getElementsByClassName("gender")[0].value;
		if(gender != "") {
			$j("#gender").val(gender).prop("selected", true);	
		}
		const location = document.getElementsByClassName("location")[0].value;
		if(location != "") {
			$j("#location").val(location).prop("selected", true);
		}
		const workType = document.getElementsByClassName("workType")[0].value;
		if(workType != "") {
			$j("#workType").val(workType).prop("selected", true);
		}
		/* ----------------------------------------- Select(성별, 희망근무지, 근무형태) 끝 ----------------------------------------- */
		

		
		/* ----------------------------------------- 학력사항, 경력사항, 희망근무지/근무형태-----------------------------------------  */
		const educationalHistory = document.getElementById("educationalHistory");
		const totalCareer = document.getElementById("totalCareer");
		const locationAndWorkType = document.getElementById("locationAndWorkType");
		
		/* 학력사항 */
		let educationSchoolName = document.getElementsByClassName("educationSchoolName");
		let educationStartPeriod = document.getElementsByClassName("educationStartPeriod");
		let educationEndPeriod = document.getElementsByClassName("educationEndPeriod");
		let educationDivisionText = document.getElementsByClassName("educationDivisionText");
		
		if(educationalHistory.innerHTML == "empty") {
			educationalHistory.innerHTML = "";
			
		} else {
			for(let i = 0; i < educationStartPeriod.length; i++) {
				const eduStartYear = educationStartPeriod[i].value.substr(0, 4);
				const eduEndYear = educationEndPeriod[i].value.substr(0, 4);
				const eduStartMonth = educationStartPeriod[i].value.substr(5, 2);
				const eduEndMonth = educationEndPeriod[i].value.substr(5, 2);
				const eduYear = educationEndPeriod[i].value.substr(0, 4) - educationStartPeriod[i].value.substr(0, 4);
				const eduMonth = educationEndPeriod[i].value.substr(5, 2) - educationStartPeriod[i].value.substr(5, 2);
				
				if(eduStartYear < eduEndYear) { /* 시작연도 < 종료연도 */
					if(eduStartMonth < eduEndMonth) { /* 년도, 개월수 종료일이 더 클때 */
						educationalHistory.innerHTML += educationSchoolName[i].value+"("+eduYear+"년 " + eduMonth +"개월) "+educationDivisionText[i].value + "<br/>";
					} else if(eduStartMonth > eduEndMonth) {
						if((eduEndYear - eduStartYear) == 1) { /* 1년 이내 개월 수 (시작 달 > 종료 달)  */
							educationalHistory.innerHTML += educationSchoolName[i].value+"("+ (Number(12-eduStartMonth) + Number(eduEndMonth)) +"개월) "+educationDivisionText[i].value + "<br/>";
						} else { /* 1년 이상 개월 수 (시작 달 > 종료 달) */
							educationalHistory.innerHTML += educationSchoolName[i].value+"("+ Number(eduYear - 1) +"년 "+ (Number(12-eduStartMonth) + Number(eduEndMonth)) +"개월) "+educationDivisionText[i].value + "<br/>";
						}
					} else if(eduStartMonth == eduEndMonth) { /* 1년 이상  (시작 달 == 종료 달)  */
						educationalHistory.innerHTML += educationSchoolName[i].value+"("+eduYear+"년) "+educationDivisionText[i].value + "<br/>";
					}
					
				} else if(eduStartYear == eduEndYear) { /* 년도 동일 */
					if(eduStartMonth < eduEndMonth) {
						educationalHistory.innerHTML += educationSchoolName[i].value+"("+ eduMonth +"개월) "+educationDivisionText[i].value + "<br/>";
					}
				}
			}
		}
		/* 경력사항 */
		let careerStartPeriod = document.getElementsByClassName("careerStartPeriod");
		let careerEndPeriod = document.getElementsByClassName("careerEndPeriod");
		if(totalCareer.innerHTML == "empty") {
			totalCareer.innerHTML = "";
		} else {
			for(let i = 0; i < careerStartPeriod.length; i++) {
				
				const carStartYear = careerStartPeriod[i].value.substr(0, 4);
				const carEndYear = careerEndPeriod[i].value.substr(0, 4);
				const carStartMonth = careerStartPeriod[i].value.substr(5, 2);
				const carEndMonth = careerEndPeriod[i].value.substr(5, 2);
				const carYear = careerEndPeriod[i].value.substr(0, 4) - careerStartPeriod[i].value.substr(0, 4);
				const carMonth = careerEndPeriod[i].value.substr(5, 2) - careerStartPeriod[i].value.substr(5, 2);
				
				if(carStartYear < carEndYear) { /* 시작연도 < 종료연도 */
					if(carStartMonth < carEndMonth) { /* 년도, 개월수 종료일이 더 클때 */
						totalCareer.innerHTML += "경력 " + carYear + "년 " + carMonth + "개월<br/>";
					} else if(carStartMonth > carEndMonth) {
						if((carEndYear - carStartYear) == 1) { /* 1년 이내 개월 수 (시작 달 > 종료 달)  */
							totalCareer.innerHTML += "경력 " + (Number(12-carStartMonth) + Number(carEndMonth)) + "개월<br/>";
						} else { /* 1년 이상 개월 수 (시작 달 > 종료 달) */
							totalCareer.innerHTML += "경력 " + Number(carYear - 1) + "년 " + (Number(12-carStartMonth) + Number(carEndMonth)) + "개월<br/>";
						}
					} else if(carStartMonth == carEndMonth) { /* 1년 이상  (시작 달 == 종료 달)  */
						totalCareer.innerHTML += "경력 " + carYear + "년<br/>";
					}
					
				} else if(carStartYear == carEndYear) { /* 년도 동일 */
					if(carStartMonth < carEndMonth) {
						totalCareer.innerHTML += "경력 " + carMonth + "개월<br/>";
					}
				}
				
			}
		}
		/* 희망연봉 */
		if(locationAndWorkType.innerHTML == "empty") {
			locationAndWorkType.innerHTML = "";
		} else {
			locationAndWorkType.innerHTML = $j("#location").val() + "전체 <br/>" + $j("#workType").val();
		}
		/* ----------------------------------------- 학력사항, 경력사항, 희망근무지/근무형태 끝 -----------------------------------------  */
		
		
		/* 저장한 한적이 있으면 */
		const eduSeq = document.getElementById("eduSeq");
		if(eduSeq.value != "") {
			/* 학력 - 구분 선택 */
			let educationLocation = document.getElementsByClassName("educationLocation");
			let length = educationLocation[0].options.length;
			let educationLocationText = document.getElementsByClassName("educationLocationText");
			for(let x = 0; x < educationLocation.length; x++) {
				for(let y = 0; y < length; y++) {
					if(educationLocation[x] != null) {
						if(educationLocation[x].options[y].value == educationLocationText[x].value) {
							educationLocation[x].options[y].selected = true;
						}
					}
				}
			}
			/* 학력 - 학교명(소재지) 선택 */
			let educationDivision = document.getElementsByClassName("educationDivision");
			let length1 = educationDivision[0].options.length;
			let educationDivisionText = document.getElementsByClassName("educationDivisionText");
			for(let x = 0; x < educationDivision.length; x++) {
				for(let y = 0; y < length1; y++) {
					if(educationDivision[x] != null) {
						if(educationDivision[x].options[y].value == educationDivisionText[x].value) {
							educationDivision[x].options[y].selected = true;
						}
					}
				}
			}
		}
		
		/* 저장한 데이터 불러올 경우 */
		if($j(".tr1CheckBox").last().val() > 0) {			
			tr1Num = $j(".tr1CheckBox").last().val();
		}
		if($j(".tr2CheckBox").last().val() > 0) {			
			tr2Num = $j(".tr2CheckBox").last().val();
		}
		if($j(".tr3CheckBox").last().val() > 0) {			
			tr3Num = $j(".tr3CheckBox").last().val();
		}
		
		/* ************** 제출 했을 경우 비활성화 ************** */
		const submit = document.getElementById("submit");
		if(submit.value == 'TRUE') {
			/* input, select, button 비활성화 */
			const input = document.getElementsByTagName("input");
			const select = document.getElementsByTagName("select");
			const button = document.getElementsByTagName("button");
			for(let i = 0; i < input.length; i++) {
				input[i].setAttribute("disabled", true);
				input[i].style.border = "none";
				input[i].style.backgroundColor = "transparent";
			}
			for(let i = 0; i < select.length; i++) {
				select[i].setAttribute("disabled", true);
			}
			for(let i = 0; i < button.length; i++) {
				button[i].setAttribute("disabled", true);
			}
		}/* ************** 제출 했을 경우 비활성화 ************** */
		
		const tr1 = document.getElementsByClassName("tr1"); /* 학력 */
		const tr2 = document.getElementsByClassName("tr2"); /* 경력 */
		const tr3 = document.getElementsByClassName("tr3"); /* 자격증 */

		/* 테이블 추가 */
		$j(".plusBtn").on("click", function() {
			if($j(this).val() == "tr1PlusBtn") {
				if(tr1[0] == null) {
					table1.innerHTML = "<thead><tr><th></th><th>재학기간</th><th>구분</th><th>학교명(소재지)</th><th>전공</th><th>학점</th></tr></thead><tbody><tr class='tr1 tr1Clone0'><td><input type='hidden'id='eduSeq'value=''/><input type='checkBox'name='tr1CheckBox'class='tr1CheckBox'value='0'/></td><td><input type='text'name='educationVoList[0].startPeriod'class='dateType educationStartPeriod'onkeyup='inputDate(this)'maxlength='7'placeholder='YYYY.MM'/><br/>~<br/><input type='text'name='educationVoList[0].endPeriod'class='dateType educationEndPeriod'onkeyup='inputDate(this)'maxlength='7'placeholder='YYYY.MM'/></td><td><input type='hidden'/><select name='educationVoList[0].division'class='educationDivision'><option value='재학'>재학</option><option value='중퇴'>중퇴</option><option value='졸업'>졸업</option></select></td><td><input type='text'name='educationVoList[0].schoolName'class='educationSchoolName'/><br/><input type='hidden'/><select name='educationVoList[0].location'><option value='서울'>서울</option><option value='부산'>부산</option><option value='대구'>대구</option><option value='인천'>인천</option><option value='광주'>광주</option><option value='대전'>대전</option><option value='울산'>울산</option><option value='강원'>강원</option><option value='경기'>경기</option><option value='경남'>경남</option><option value='경북'>경북</option><option value='전남'>전남</option><option value='전북'>전북</option><option value='제주'>제주</option><option value='충남'>충남</option><option value='충북'>충북</option></select></td><td><input type='text'name='educationVoList[0].major'class='major'/></td><td><input type='text'name='educationVoList[0].grade'class='grade checkNumberDot'maxlength='3'/></td></tr></tbody>";
					table1.style.border = "1px solid black";
					return true;
				}
				
				alert("btn1");
				const tr1Clone = tr1[tr1.length - 1].cloneNode(true);
				
				/* input, select 초기화, name값 변경 */
				const input = tr1Clone.getElementsByTagName("input");
				const select = tr1Clone.getElementsByTagName("select");
				for(let i = 0; i < input.length; i++) {
					input[i].value = "";
				}
				
				++tr1Num;
				input[2].setAttribute("name", "educationVoList[" + tr1Num + "].startPeriod");
				input[3].setAttribute("name", "educationVoList[" + tr1Num + "].endPeriod");
				input[5].setAttribute("name", "educationVoList[" + tr1Num + "].schoolName");
				input[7].setAttribute("name", "educationVoList[" + tr1Num + "].major");
				input[8].setAttribute("name", "educationVoList[" + tr1Num + "].grade");
				select[0].setAttribute("name", "educationVoList[" + tr1Num + "].division");
				select[1].setAttribute("name", "educationVoList[" + tr1Num + "].location");
			
				tr1Clone.classList.add("tr1Clone" + tr1Num);
				tr1Clone.querySelector(".tr1CheckBox").value = tr1Num;
				tr1[tr1.length - 1].after(tr1Clone);
			} else if($j(this).val() == "tr2PlusBtn") {
				if(tr2[0] == null) {
					table2.innerHTML = "<thead><tr><th></th><th>근무기간</th><th>회사명</th><th>부서/직급/직책</th><th>지역</th></tr></thead><tbody><tr class='tr2 tr2Clone0'><td><!--체크박스--><input type='hidden'id='carSeq'value=''/><input type='checkBox'name='tr2CheckBox'class='tr2CheckBox'value='0'/></td><td><!--근무기간--><input type='text'name='careerVoList[0].startPeriod'class='dateType careerStartPeriod'onkeyup='inputDate(this)'maxlength='7'placeholder='YYYY.MM'/>~<br/><input type='text'name='careerVoList[0].endPeriod'class='dateType careerEndPeriod'onkeyup='inputDate(this)'maxlength='7'placeholder='YYYY.MM'/></td><td><!--회사명--><input type='text'name='careerVoList[0].compName'class='careerCompName'/></td><td><!--부서/직급/직책--><input type='text'name='careerVoList[0].task'class='careerTask'/><input type='hidden'name='careerVoList[0].salary'class='careerSalary'/></td><td><!--지역--><input type='text'name='careerVoList[0].location'class='careerLocation'/></td></tr></tbody>";
					table2.style.border = "1px solid black";
					return true;
				}
				
				alert("btn2");
				const tr2Clone = tr2[tr2.length - 1].cloneNode(true);
				
				
				/* input 초기화 */
				const input = tr2Clone.getElementsByTagName("input");
				for(let i = 0; i < input.length; i++) {
					input[i].value = "";
				}
				
				++tr2Num;
				input[2].setAttribute("name", "careerVoList[" + tr2Num + "].startPeriod");
				input[3].setAttribute("name", "careerVoList[" + tr2Num + "].endPeriod");
				input[4].setAttribute("name", "careerVoList[" + tr2Num + "].compName");
				input[5].setAttribute("name", "careerVoList[" + tr2Num + "].task");
				input[6].setAttribute("name", "careerVoList[" + tr2Num + "].salary");
				
				tr2Clone.classList.add("tr2Clone" + tr2Num);
				tr2Clone.querySelector(".tr2CheckBox").value = tr2Num;
				tr2[tr2.length - 1].after(tr2Clone);
				
			} else if($j(this).val() == "tr3PlusBtn") {
				if(tr3[0] == null) {
					table3.innerHTML = "<thead><tr><th></th><th>자격증명</th><th>취득일</th><th>발행처</th></tr></thead><tbody><tr class='tr3 tr3Clone0'><td><!--체크박스--><input type='hidden'id='certSeq'value=''/><input type='checkBox'name='tr3CheckBox'class='tr3CheckBox'value='0'/></td><td><!--자격증명--><input type='text'name='certificateVoList[0].qualifiName'class='certificateQualifiName'/></td><td><!--취득일--><input type='text'name='certificateVoList[0].acquDate'class='certificateAcquDate'maxlength='7'onkeyup='inputDate(this)'placeholder='YYYY.MM'/></td><td><!--발행처--><input type='text'name='certificateVoList[0].organizeName'class='certificateOrganizeName'/><br/></td></tr></tbody>";
					table3.style.border = "1px solid black";
					return true;
				}
				
				alert("btn3");
				const tr3Clone = tr3[tr3.length - 1].cloneNode(true);
				
				/* input 초기화 */
				const input = tr3Clone.getElementsByTagName("input");
				for(let i = 0; i < input.length; i++) {
					input[i].value = "";
				}
				
				++tr3Num;
				input[2].setAttribute("name", "certificateVoList[" + tr3Num + "].qualifiName");
				input[3].setAttribute("name", "certificateVoList[" + tr3Num + "].acquDate");
				input[4].setAttribute("name", "certificateVoList[" + tr3Num + "].organizeName");
				
				tr3Clone.classList.add("tr3Clone" + tr3Num);
				tr3Clone.querySelector(".tr3CheckBox").value = tr3Num;
				tr3[tr3.length - 1].after(tr3Clone);
			}
		});
		
		
		/* 테이블 삭제 */
		$j(".minusBtn").on("click", function() {
			let check1 = false;
			let check2 = false;
			let check3 = false;
			
			if($j(this).val() == "tr1MinusBtn") {
				$j(".tr1CheckBox:checked").each(function() {
					const tr1El = document.getElementsByClassName("tr1Clone" + $j(this).val());
					
					/* eduSeq */
					console.log($j(this).prev().val());
					removeStr1 += $j(this).prev().val() + ",";
					
					tr1El[0].remove();
					alert($j(this).val());
					check1 = true;
				});
				
				/* 한개라도 체크 안되어있을 경우 알람 */
				if(!check1) {
					alert("삭제할 학력 항목을 체크해주세요.");
					check1 = false;
				}
				
			} else if($j(this).val() == "tr2MinusBtn") {
				$j(".tr2CheckBox:checked").each(function() {
					const tr2El = document.getElementsByClassName("tr2Clone" + $j(this).val());
					
					/* carSeq */
					console.log($j(this).prev().val());
					removeStr2 += $j(this).prev().val() + ",";
					
					tr2El[0].remove();
					alert($j(this).val());
					check2 = true;
				});
				
				/* 한개라도 체크 안되어있을 경우 알람 */
				if(!check2) {
					alert("삭제할 경력 항목을 체크해주세요.");
					check2 = false;
				}
				
			} else if($j(this).val() == "tr3MinusBtn") {
				$j(".tr3CheckBox:checked").each(function() {
					const tr3El = document.getElementsByClassName("tr3Clone" + $j(this).val());
					
					/* certSeq */
					console.log($j(this).prev().val());
					removeStr3 += $j(this).prev().val() + ",";
					
					tr3El[0].remove();
					alert($j(this).val());
					check3 = true;
				});
				
				/* 한개라도 체크 안되어있을 경우 알람 */
				if(!check3) {
					alert("삭제할 자격증 항목을 체크해주세요.");
					check3 = false;
				}
				
			}
			
			const table1 = document.getElementById("table1");
			const table2 = document.getElementById("table2");
			const table3 = document.getElementById("table3");
			if(tr1[0] == null) {
				table1.innerHTML = "";
				table1.style.border = "none";
			} else if(tr2[0] == null) {
				table2.innerHTML = "";
				table2.style.border = "none";
			} else if(tr3[0] == null) {
				table3.innerHTML = "";
				table3.style.border = "none";
			}
			
		});
		
		
		/* 저장 */
		$j("#save").on("click",function(){
			
			saveAndSubmitValidate(checkObj);
			
			if (saveResult == true) {
				const deleteNo1 = document.getElementById("deleteNo1");
				const deleteNo2 = document.getElementById("deleteNo2");
				const deleteNo3 = document.getElementById("deleteNo3");
				deleteNo1.value = removeStr1;
				deleteNo2.value = removeStr2;
				deleteNo3.value = removeStr3;
				
				var $frm = $j('form :input');
				var param = $frm.serialize();
				console.log($frm);			
				console.log("param"+param);
			
				$j.ajax({
				    url : "/recruit/save.do",
				    dataType: "json",
				    type: "POST",
				    data : param,
				    success: function(data, textStatus, jqXHR)
				    {
						alert("저장 완료");
						window.location.reload();
						/* window.location.href = "/recruit/main.do"; */
				    },
				    error: function (jqXHR, textStatus, errorThrown)
				    {
				    	
				    }
				});
			}
		}); /* 저장 */
		
	}); /* $j(document).ready(function() */

	
</script>
<body>
	<form action="/recruit/submit.do" method="POST" onsubmit="return recruitValidate()"><!-- 제출 -->
		<input type="hidden" name="seq" value="${recruit.seq}"/>
		<input type="hidden" name="submit" id="submit" value="${recruit.submit}"/>
		<input type="hidden" class="gender" value="${recruit.gender}"/>
		<input type="hidden" class="location" value="${recruit.location}"/>
		<input type="hidden" class="workType" value="${recruit.workType}"/>
		<input type="hidden" name="deleteNo1" id="deleteNo1"/>
		<input type="hidden" name="deleteNo2" id="deleteNo2"/>
		<input type="hidden" name="deleteNo3" id="deleteNo3"/>
		
		<h1 class="center">입사지원서</h1>
		<table width="100%" class="outLineTable">
			<thead>
				<tr>
					<td>
						<table align="center" border = "1" id="headTable">
							<tr>
								<td width="100" align="center">
									이름
								</td>
								<td width="150" align="left">
									<input type="text" maxlength="15" name="name" id="name" value="${recruit.name}"/>
								</td>
								<td width="100" align="center">
									생년월일
								</td>
								<td width="150" align="left">
									<input type="text" maxlength="6" name="birth" id="birth" value="${recruit.birth}" placeholder="YYMMDD"/>
								</td>
							</tr>
							<tr>
								<td width="100" align="center">
									성별
								</td>
								<td width="150" align="left">
									<select name="gender" id="gender">
										<option value="남자">남자</option>
										<option value="여자">여자</option>
									</select>
								</td>
								<td width="100" align="center">
									연락처
								</td>
								<td width="150" align="left">
									<input type="text"name="phone" id="phone" maxlength="11" value="${recruit.phone}"/>
								</td>
							</tr>
							<tr>
								<td width="100" align="center">
									email
								</td>
								<td width="150" align="left">
									<input type="text" maxlength="30" name="email" id="email" value="${recruit.email}"/>
								</td>
								<td width="100" align="center">
									주소
								</td>
								<td width="150" align="left">
									<input type="text" maxlength="12" name="addr" id="addr" value="${recruit.addr}"/>
								</td>
							</tr>
							<tr>
								<td width="100" align="center">
									희망근무지
								</td>
								<td width="150" align="left">
									 <select name="location" id="location" >
							            <option value='서울'>서울</option>
							            <option value='부산'>부산</option>
							            <option value='대구'>대구</option>
							            <option value='인천'>인천</option>
							            <option value='광주'>광주</option>
							            <option value='대전'>대전</option>
							            <option value='울산'>울산</option>
							            <option value='강원'>강원</option>
							            <option value='경기'>경기</option>
							            <option value='경남'>경남</option>
							            <option value='경북'>경북</option>
							            <option value='전남'>전남</option>
							            <option value='전북'>전북</option>
							            <option value='제주'>제주</option>
							            <option value='충남'>충남</option>
							            <option value='충북'>충북</option>
							        </select>
								</td>
								<td width="100" align="center">
									근무형태
								</td>
								<td width="150" align="left">
									<select name="workType" id="workType">
										<option value="정규직">정규직</option>
										<option value="계약직">계약직</option>
									</select>
								</td>
							</tr>
						</table> 
						<c:choose>
							<c:when test="${empty educationVoList}">
								<div id="educationalHistory">empty</div>
								<div id="totalCareer">empty</div>
								<div id="locationAndWorkType">empty</div>
							</c:when>
							<c:otherwise>
								<table align="center" border = "1" >
									<thead>
										<tr>
											<th>학력사항</th>
											<th>경력사항</th>
											<th>희망연봉</th>
											<th>희망근무지/근무형태</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td id="educationalHistory"></td>
											<td id="totalCareer"></td>
											<td>회사내규에 따름</td>
											<td id="locationAndWorkType"></td>
										</tr>
									</tbody>
								</table>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</thead>
			
			<tbody><!-- 학력, 경력, 자격증 -->
				<tr>
					<td>
						<h1>학력</h1>
					</td>
				</tr>
				<tr align="right">
					<td>
						<button type="button" class="plusBtn" value="tr1PlusBtn">추가</button>
						<button type="button" class="minusBtn" value="tr1MinusBtn">삭제</button>
					</td>
				</tr>
				<tr>
					<td>
						<table border="1" align="center" id="table1">
							<c:choose>
								<c:when test='${empty educationVoList}'>
									<thead>
										<tr>
											<th></th>
											<th>재학기간</th>
											<th>구분</th>
											<th>학교명(소재지)</th>
											<th>전공</th>
											<th>학점</th>
										</tr>
									</thead>
									<tbody>
										<tr class='tr1 tr1Clone0'>
											<td>
												<input type='hidden' id='eduSeq' value=''/>
												<input type='checkBox' name='tr1CheckBox' class='tr1CheckBox' value='0'/>
											</td>
											<td>
												<input type='text' name='educationVoList[0].startPeriod' class='dateType educationStartPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM'/><br/>
												~<br/>
												<input type='text' name='educationVoList[0].endPeriod' class='dateType educationEndPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM'/>
											</td>
											<td>
												<input type='hidden'/>
												<select name='educationVoList[0].division' class='educationDivision'>
													<option value='재학'>재학</option>
													<option value='중퇴'>중퇴</option>
													<option value='졸업'>졸업</option>
												</select>
											</td>
											<td>
												<input type='text' name='educationVoList[0].schoolName' class='educationSchoolName'/><br/>
												<input type='hidden'/>
												  <select name='educationVoList[0].location'>
									             	<option value='서울'>서울</option>
										            <option value='부산'>부산</option>
										            <option value='대구'>대구</option>
										            <option value='인천'>인천</option>
										            <option value='광주'>광주</option>
										            <option value='대전'>대전</option>
										            <option value='울산'>울산</option>
										            <option value='강원'>강원</option>
										            <option value='경기'>경기</option>
										            <option value='경남'>경남</option>
										            <option value='경북'>경북</option>
										            <option value='전남'>전남</option>
										            <option value='전북'>전북</option>
										            <option value='제주'>제주</option>
										            <option value='충남'>충남</option>
										            <option value='충북'>충북</option>
										        </select>
											</td>
											<td>
												<input type='text' name='educationVoList[0].major' class='major'/>
											</td>
											<td>
												<input type='text' name='educationVoList[0].grade' class='grade checkNumberDot' maxlength='3'/>
											</td>
										</tr>
									</tbody>
								</c:when>
								<c:otherwise>
									<thead>
										<tr>
											<th></th>
											<th>재학기간</th>
											<th>구분</th>
											<th>학교명(소재지)</th>
											<th>전공</th>
											<th>학점</th>
										</tr>
									</thead>
										<tbody>
										<c:forEach var="educationList" items="${educationVoList}" varStatus="status">
											<tr class='tr1 tr1Clone${status.index}'>
												<td>
													<input type='hidden' name='educationVoList[${status.index}].eduSeq' id='eduSeq' value='${educationList.eduSeq}'/>
													<input type='checkBox' name='tr1CheckBox' class='tr1CheckBox' value='${status.index}'/>
												</td>
												<td>
													<input type='text' name='educationVoList[${status.index}].startPeriod' class='dateType educationStartPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' value='${educationList.startPeriod}'/><br/>
													~<br/>
													<input type='text' name='educationVoList[${status.index}].endPeriod' class='dateType educationEndPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' value='${educationList.endPeriod}'/>
												</td>
												<td>
													<input type='hidden' value='${educationList.division}' class='educationDivisionText'/>
													<select name='educationVoList[${status.index}].division' class='educationDivision'>
														<option value='재학'>재학</option>
														<option value='중퇴'>중퇴</option>
														<option value='졸업'>졸업</option>
													</select>
												</td>
												<td>
													<input type='text' name='educationVoList[${status.index}].schoolName' class='educationSchoolName' value='${educationList.schoolName}'>
													<br/>
													<input type='hidden' value='${educationList.location}' class='educationLocationText'>
													  <select name='educationVoList[${status.index}].location' class='educationLocation'>
										             	<option value='서울'>서울</option>
											            <option value='부산'>부산</option>
											            <option value='대구'>대구</option>
											            <option value='인천'>인천</option>
											            <option value='광주'>광주</option>
											            <option value='대전'>대전</option>
											            <option value='울산'>울산</option>
											            <option value='강원'>강원</option>
											            <option value='경기'>경기</option>
											            <option value='경남'>경남</option>
											            <option value='경북'>경북</option>
											            <option value='전남'>전남</option>
											            <option value='전북'>전북</option>
											            <option value='제주'>제주</option>
											            <option value='충남'>충남</option>
											            <option value='충북'>충북</option>
											        </select>
												</td>
												<td>
													<input type='text' name='educationVoList[${status.index}].major' class='major' value='${educationList.major}'/>
												</td>
												<td>
													<input type='text' name='educationVoList[${status.index}].grade' class='grade checkNumberDot' maxlength='3' value='${educationList.grade}'/>
												</td>
											</tr>
										</c:forEach>
										</tbody>
								</c:otherwise>
							</c:choose>
						</table>
					</td>
				</tr> <!-- 학력 끝 -->
				
				<tr>
					<td>
						<h1>경력</h1>
					</td>
				</tr>
				<tr align="right">
					<td>
						<button type="button" class="plusBtn" value="tr2PlusBtn">추가</button>
						<button type="button" class="minusBtn" value="tr2MinusBtn">삭제</button>
					</td>
				</tr>
				<tr>
					<td>
						<table border="1" align="center" id="table2">
							<c:choose>
								<c:when test='${empty careerVoList}'>
									<thead>
										<tr>
											<th></th>
											<th>근무기간</th>
											<th>회사명</th>
											<th>부서/직급/직책</th>
											<th>지역</th>
										</tr>
									</thead>
									<tbody>
										<tr class='tr2 tr2Clone0'>
											<td><!-- 체크박스 -->
												<input type='hidden' id='carSeq' value=''/>
												<input type='checkBox' name='tr2CheckBox' class='tr2CheckBox' value='0'/>
											</td>
											<td><!-- 근무기간 -->
												<input type='text' name='careerVoList[0].startPeriod' class='dateType careerStartPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' />~<br/>
												<input type='text' name='careerVoList[0].endPeriod' class='dateType careerEndPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' />
											</td>
											<td><!-- 회사명 -->
												<input type='text'  name='careerVoList[0].compName' class='careerCompName'/>
											</td>
											<td><!-- 부서/직급/직책 -->
												<input type='text' name='careerVoList[0].task' class='careerTask'/>
												<input type='hidden' name='careerVoList[0].salary' class='careerSalary'/>
											</td>
											<td><!-- 지역 -->
												<input type='text' name='careerVoList[0].location' class='careerLocation'/>
											</td>
										</tr>
									</tbody>
								</c:when>
								<c:otherwise>
									<thead>
										<tr>
											<th></th>
											<th>근무기간</th>
											<th>회사명</th>
											<th>부서/직급/직책</th>
											<th>지역</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="careerList" items="${careerVoList}" varStatus="status">
											<tr class="tr2 tr2Clone${status.index}">
												<td><!-- 체크박스 -->
													<input type="hidden" name="careerVoList[${status.index}].carSeq" value="${careerList.carSeq}"/>
													<input type="checkBox" name="tr2CheckBox" class="tr2CheckBox" value="${status.index}"/>
												</td>
												<td><!-- 근무기간 -->
													<input type="text" name="careerVoList[${status.index}].startPeriod" class='dateType careerStartPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' value="${careerList.startPeriod}"/>~<br/>
													<input type="text" name="careerVoList[${status.index}].endPeriod" class='dateType careerEndPeriod' onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' value="${careerList.endPeriod}"/>
												</td>
												<td><!-- 회사명 -->
													<input type="text"  name="careerVoList[${status.index}].compName" class='careerCompName' value="${careerList.compName}"/>
												</td>
												<td><!-- 부서/직급/직책 -->
													<input type="text" name="careerVoList[${status.index}].task" class='careerTask' value="${careerList.task}"/>
													<input type="hidden" name="careerVoList[${status.index}].salary"  class='careerSalary' value="${careerList.salary}"/>
												</td>
												<td><!-- 지역 -->
													<input type="text" name="careerVoList[${status.index}].location" class='careerLocation' value="${careerList.location}"/>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</c:otherwise>
							</c:choose>
						
						</table>
					</td>
				</tr> <!-- 경력 끝 -->
				
				<tr>
					<td>
						<h1>자격증</h1>
					</td>
				</tr>
				<tr align="right">
					<td>
						<button type="button" class="plusBtn" value="tr3PlusBtn">추가</button>
						<button type="button" class="minusBtn" value="tr3MinusBtn">삭제</button>
					</td>
				</tr>
				<tr>
					<td>
						<table border="1" align="center" id="table3">
							<c:choose>
								<c:when test='${empty certificateVoList}'>
									<thead>
										<tr>
											<th></th>
											<th>자격증명</th>
											<th>취득일</th>
											<th>발행처</th>
										</tr>
									</thead>
									<tbody>
										<tr class='tr3 tr3Clone0'>
											<td><!-- 체크박스 -->
												<input type='hidden' id='certSeq' value=''/>
												<input type='checkBox' name='tr3CheckBox' class='tr3CheckBox' value='0'/>
											</td>
											<td><!-- 자격증명 -->
												<input type='text' name='certificateVoList[0].qualifiName' class='certificateQualifiName'/>
											</td>
											<td><!-- 취득일 -->
												<input type='text' name='certificateVoList[0].acquDate' class='certificateAcquDate' maxlength='7' onkeyup='inputDate(this)' placeholder='YYYY.MM'/>
											</td>
											<td><!-- 발행처 -->
												<input type='text' name='certificateVoList[0].organizeName' class='certificateOrganizeName'/><br/>
											</td>
										</tr>
									</tbody>
								</c:when>
								<c:otherwise>
									<thead>
										<tr>
											<th></th>
											<th>자격증명</th>
											<th>취득일</th>
											<th>발행처</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="certificateList" items="${certificateVoList}" varStatus="status">
											<tr class="tr3 tr3Clone${status.index}">
												<td><!-- 체크박스 -->
													<input type="hidden" name="certificateVoList[${status.index}].certSeq" value="${certificateList.certSeq}"/>
													<input type="checkBox" name="tr3CheckBox" class="tr3CheckBox" value="${status.index}"/>
												</td>
												<td><!-- 자격증명 -->
													<input type="text" name="certificateVoList[${status.index}].qualifiName" class='certificateQualifiName' value="${certificateList.qualifiName}"/>
												</td>
												<td><!-- 취득일 -->
													<input type="text" name="certificateVoList[${status.index}].acquDate" class="dateType certificateAcquDate" onkeyup='inputDate(this)' maxlength='7' placeholder='YYYY.MM' value="${certificateList.acquDate}"/>
												</td>
												<td><!-- 발행처 -->
													<input type="text" name="certificateVoList[${status.index}].organizeName" class='certificateOrganizeName' value="${certificateList.organizeName}"/><br/>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</c:otherwise>
							</c:choose>
						</table>
					</td>
				</tr> <!-- 자격증 끝 -->
				
			</tbody>
		</table>
		<div class="center">
			<button type="button" id="save">저장</button>
			<button type="submit">제출</button>
		</div>
	</form>	
</body>
</html>