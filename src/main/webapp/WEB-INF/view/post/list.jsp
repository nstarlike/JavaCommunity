<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/header.jsp" %>

<h3>Post List</h3>

<form class="d-flex">
	<select name="search" class="form-control me-2" style="max-width:100px;">
		<option value="">All</option>
		<option value="title" <c:if test="${ param.search == 'title' }">selected</c:if>>Title</option>
		<option value="content" <c:if test="${ param.search == 'content' }">selected</c:if>>Content</option>
	</select>
	<input name="keyword" class="form-control me-2" type="search" placeholder="Search" value="<c:out value="${ param.keyword }" />" style="max-width:150px;">
	<button class="btn btn-outline-success" type="submit">Search</button>
</form>

<table class="table">
	<thead>
		<th>No.</th>
		<th>title</th>
		<th>Date</th>
	</thead>
	<tbody>
		<c:forEach var="post" items="${ list }">
			<tr>
				<td>${ post.id }</td>
				<td><a href="./view?id=${ post.id}<c:out value="${ listQueryString }" />"><c:out value="${ post.title }" /></a></td>
				<td><c:out value="${ post.written }" /></td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<c:if test="${ pagination.totalPage > 0 }">
<nav>
	<ul class="pagination justify-content-center">
		<c:if test="${ pagination.startPage != 1 }">
		<li class="page-item"><a class="page-link" href="./list?pageNo=${ pagination.firstPage }<c:out value="${ pageQueryString }" />">&laquo;</a></li>
		<li class="page-item"><a class="page-link" href="./list?pageNo=${ pagination.prevPage }<c:out value="${ pageQueryString }" />">Prev</a></li>
		</c:if>
		
		<c:forEach var="pageNo" begin="${ pagination.startPage }" end="${ pagination.endPage }">
			<c:set var="active" value="" />
			<c:if test="${ pageNo == param.pageNo || (pageNo == 1 && empty param.pageNo) }">
				<c:set var="active" value="active" />
			</c:if>
		<li class="page-item ${ active }"><a class="page-link" href="./list?pageNo=${ pageNo }<c:out value="${ pageQueryString }" />">${ pageNo }</a></li>
		</c:forEach>
		
		<c:if test="${ pagination.endPage < pagination.lastPage }">
		<li class="page-item"><a class="page-link" href="./list?pageNo=${ pagination.nextPage }<c:out value="${ pageQueryString }" />">Next</a></li>
		<li class="page-item"><a class="page-link" href="./list?pageNo=${ pagination.lastPage }<c:out value="${ pageQueryString }" />">&raquo;</a></li>
		</c:if>
	</ul>
</nav>
</c:if>

<div>
	<a href="./write<c:out value="${ queryString }" />" class="btn">Write</a>
	<a href="./export<c:out value="${ queryString }" />" class="btn">Export</a>
	
</div>
<div>
<form action="./import" method="POST" enctype="multipart/form-data">
	<input type="file" name="file" />
	<button type="submit">Upload</button>
</form>
</div>

<%@ include file="../common/footer.jsp" %>