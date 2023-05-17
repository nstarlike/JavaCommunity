<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>

<h3>View Post</h3>

<table class="table">
	<tbody>
	<tr>
		<th>Title</th>
		<td><c:out value="${ post.title }" /></td>
	</tr>
	<tr>
		<th>Content</th>
		<td><c:out value="${ post.content }" /></td>
	</tr>
	</tbody>
</table>

<table class="table">
	<tbody>
		<c:forEach var="comment" items="${ commentList }">
		<tr>
			<td>${ comment.content }</td>
			<td>${ comment.written }</td>
			<td><button type="button" class="delete-comment-btn btn btn-danger" data-id="${ comment.id }">Delete</button></td>
		</tr>
		</c:forEach>
	</tbody>
</table>

<c:if test="${ pagination != null && pagination.totalPage > 0 }">
<nav>
	<ul class="pagination justify-content-center">
		<c:if test="${ pagination.startPage > 1 }">
		<li class="page-item"><a class="page-link" href="./view${ queryString }&cPageNo=1">&laquo;</a></li>
		<li class="page-item"><a class="page-link" href="./view${ queryString }&cPageNo=${ pagination.prevPage }">Prev</a></li>
		</c:if>
		
		<c:forEach var="pageNo" begin="${ pagination.startPage }" end="${ pagination.endPage }">
		<li class="page-item"><a class="page-link" href="./view${ queryString }&cPageNo=${ pageNo }">${ pageNo }</a></li>
		</c:forEach>
		
		<c:if test="${ pagination.endPage < pagination.lastPage }">
		<li class="page-item"><a class="page-link" href="./view${ queryString }&cPageNo=${ pagination.nextPage }">Next</a></li>
		<li class="page-item"><a class="page-link" href="./view${ queryString }&cPageNo=${ pagination.lastPage }">&raquo;</a></li>
		</c:if>
	</ul>
</nav>
</c:if>

<form id="write-comment-form" method="POST" action="./writeCommentProc">
	<input type="hidden" name="queryString" value="<c:out value="${ queryString }" />" />
	<input type="hidden" name="id" value="<c:out value="${ post.id }" />" />
	<div class="form-group">
		<textarea id="write-comment-content" class="form-control" name="content"></textarea>
	</div>
	<div class="form-group mt-3">
		<button type="submit" class="btn btn-primary">Comment</button>
	</div>
</form>

<form id="delete-comment-form" class="none" method="POST" action="./deleteCommentProc">
	<input type="hidden" name="queryString" value="<c:out value="${ queryString }" />" />
	<input type="hidden" name="id" value="<c:out value="${ post.id }" />" />
	<input type="hidden" id="delete-comment-id" name="commentId" />
</form>

<div>
	<a href="./update<c:out value="${ queryString }" />" class="btn">Update</a>
	<a href="./list<c:out value="${ listQueryString }" />" class="btn">List</a>
</div>

<script>
$(document).ready(function(){
	$(".delete-comment-btn").click(function(){
		$("#delete-comment-id").val($(this).data("id"));
		$("#delete-comment-form").submit();
	});
	
	$("#write-comment-form").submit(function(){
		if($("#write-comment-content").val() == ""){
			alert("Enter a content.");
			$("#write-comment-content").focus();
			return false;
		}
	});
});
</script>

<%@ include file="../common/footer.jsp" %>