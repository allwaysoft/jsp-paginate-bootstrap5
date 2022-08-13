<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java"%>
<%@ page import="java.sql.*"%>
<%!public int nullIntconvert(String str) {
        int num = 0;
        if (str == null) {
            str = "0";
        } else if ((str.trim()).equals("null")) {
            str = "0";
        } else if (str.equals("")) {
            str = "0";
        }
        try {
            num = Integer.parseInt(str);
        } catch (Exception e) {
        }
        return num;
    }%>
<%
    Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/jpetstore", "root", "root");
    ResultSet rs1 = null;
    ResultSet rs2 = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;

    int showRows = 2;
    int totalRecords = 5;
    int totalRows = nullIntconvert(request.getParameter("totalRows"));
    int totalPages = nullIntconvert(request.getParameter("totalPages"));
    int iPageNo = nullIntconvert(request.getParameter("iPageNo"));
    int cPageNo = nullIntconvert(request.getParameter("cPageNo"));

    int startResult = 0;
    int endResult = 0;
    if (iPageNo == 0) {
        iPageNo = 0;
    } else {
        iPageNo = Math.abs((iPageNo - 1) * showRows);
    }
    String query1 = "SELECT SQL_CALC_FOUND_ROWS * FROM jpetstore.item  LIMIT "
            + iPageNo + "," + showRows + "";
    ps1 = conn.prepareStatement(query1);
    rs1 = ps1.executeQuery();

    String query2 = "SELECT FOUND_ROWS() as cnt";
    ps2 = conn.prepareStatement(query2);
    rs2 = ps2.executeQuery();
    if (rs2.next()) {
        totalRows = rs2.getInt("cnt");
    }
%>
<html>
    <head>
        <title>JSP分页</title>
        <link href="bootstrap-5.1.3-dist/css/bootstrap.min.css" rel="stylesheet" >
        <script src="bootstrap-5.1.3-dist/js/bootstrap.bundle.min.js"></script>
        <link href="bootstrap-icons-1.8.3/bootstrap-icons.css" rel="stylesheet">
        <style>
            .panel-table .panel-body{
                padding:0;
            }

            .panel-table .panel-body .table-bordered{
                border-style: none;
                margin:0;
            }

            .panel-table .panel-body .table-bordered > thead > tr > th:first-of-type {
                text-align:center;
                width: 100px;
            }

            .panel-table .panel-body .table-bordered > thead > tr > th:last-of-type,
            .panel-table .panel-body .table-bordered > tbody > tr > td:last-of-type {
                border-right: 0px;
            }

            .panel-table .panel-body .table-bordered > thead > tr > th:first-of-type,
            .panel-table .panel-body .table-bordered > tbody > tr > td:first-of-type {
                border-left: 0px;
            }

            .panel-table .panel-body .table-bordered > tbody > tr:first-of-type > td{
                border-bottom: 0px;
            }

            .panel-table .panel-body .table-bordered > thead > tr:first-of-type > th{
                border-top: 0px;
            }

            .panel-table .panel-footer .pagination{
                margin:0;
            }

            /*
            used to vertically center elements, may need modification if you're not using default sizes.
            */
            .panel-table .panel-footer .col{
                line-height: 34px;
                height: 34px;
            }

            .panel-table .panel-heading .col h3{
                line-height: 30px;
                height: 30px;
            }

            .panel-table .panel-body .table-bordered > tbody > tr > td{
                line-height: 34px;
            }


        </style>

    </head>

    <body>
        <h3>Pagination of JSP page</h3>
        <form>
            <input type="hidden" name="iPageNo" value="<%=iPageNo%>"> <input
                type="hidden" name="cPageNo" value="<%=cPageNo%>"> <input
                type="hidden" name="showRows" value="<%=showRows%>">
            <div class="panel-body">
                <table class="table table-striped table-bordered table-list">
                    <thead>
                        <tr>
                            <td>ItemID</td>
                            <td>ProductID</td>
                            <td>listPrice</td>
                            <td>unitCost</td>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            while (rs1.next()) {
                        %>
                        <tr>
                            <td><%=rs1.getString("itemid")%></td>
                            <td><%=rs1.getString("productId")%></td>
                            <td><%=rs1.getDouble("listprice")%></td>
                            <td><%=rs1.getDouble("unitcost")%></td>
                        </tr>
                        <%
                            }
                        %>

                    </tbody>
                </table>
            </div>
            <div class="panel-footer">
                <div class="row">


                    <div class="col col-xs-4">
                        <%
                            try {
                                if (totalRows < (iPageNo + showRows)) {
                                    endResult = totalRows;
                                } else {
                                    endResult = (iPageNo + showRows);
                                }
                                startResult = (iPageNo + 1);
                                totalPages = ((int) (Math.ceil((double) totalRows / showRows)));
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                        第 <%=startResult%> - <%=endResult%> 行，共 <%=totalRows%> 行

                    </div>
                    <div class="col col-xs-8">
                        <nav aria-label="Page navigation example">
                            <ul class="pagination pagination-sm justify-content-end">
                                <%
                                    int i = 0;
                                    int cPage = 0;
                                    if (totalRows != 0) {
                                        cPage = ((int) (Math.ceil((double) endResult
                                                / (totalRecords * showRows))));

                                        int prePageNo = (cPage * totalRecords)
                                                - ((totalRecords - 1) + totalRecords);
                                        if ((cPage * totalRecords) - (totalRecords) > 0) {
                                %>


                                <li class="page-item">
                                    <a class="page-link"
                                       href="pagination.jsp?iPageNo=<%=prePageNo%>&cPageNo=<%=prePageNo%>">
                                        &lt; 前一页</a>
                                </li>
                                <%
                                    }
                                    for (i = ((cPage * totalRecords) - (totalRecords - 1)); i <= (cPage * totalRecords); i++) {
                                        if (i == ((iPageNo / showRows) + 1)) {
                                %>
                                <li class="page-item">
                                    <a class="page-link" href="pagination.jsp?iPageNo=<%=i%>"
                                       style="cursor: pointer; color: red"><b><%=i%></b> </a>
                                </li>
                                <%
                                } else if (i <= totalPages) {
                                %>
                                <li class="page-item">
                                    <a class="page-link" href="pagination.jsp?iPageNo=<%=i%>"><%=i%></a>
                                </li>
                                <%
                                        }
                                    }
                                    if (totalPages > totalRecords && i < totalPages) {
                                %>
                                <li class="page-item">
                                    <a class="page-link" href="pagination.jsp?iPageNo=<%=i%>&cPageNo=<%=i%>">
                                        后一页 &gt;</a>
                                </li>
                                <%
                                        }
                                    }
                                %>
                            </ul>
                        </nav>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
<%
    try {
        if (ps1 != null) {
            ps1.close();
        }
        if (rs1 != null) {
            rs1.close();
        }

        if (ps2 != null) {
            ps2.close();
        }
        if (rs2 != null) {
            rs2.close();
        }

        if (conn != null) {
            conn.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

