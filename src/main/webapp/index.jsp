<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
    <%--    当前页面，设置域
            request.getContextPath(),获得的项目名有/开始，没有/结束
    --%>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <%--    web路径问题
        不以/开始的相对路径，以当前资源的路径为基准，经常容易出问题
        以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306/),需要加上项目名
    --%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <%-- 引入样式--%>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<%--员工修改的模块框--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="12345@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-5">
                            <select class="form-control" name="dId" id="dept_update_select">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>

<%--员工添加的模块框--%>
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加英雄</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="奥特曼">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="12345@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-5">
                            <select class="form-control" name="dId" id="dept_add_select">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--    搭建显示页面--%>
<%--主页面--%>
<div class="container">
    <%--页面分为四行--%>
    <!-- 标题行-->
    <div class="row">
        <div class="col-md-12">
            <h3>SSM-CRUD</h3>
        </div>
    </div>
    <!-- 按钮行-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_model_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <!-- 表格数据行-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>编号</th>
                    <th>姓名</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <!-- 分页信息行-->
    <div class="row">
        <div class="col-md-6" id="page_info_area">

        </div>

        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>

    <script type="text/javascript">
      var totalRecord,currentPage;
        //我们应该页面加载完成以后，发送ajax请求，要到分页数据
       $(function () {
          to_page(1);
       });

        function to_page(pn) {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result) {
                    //console.log(result);
                    build_emps_table(result);
                    build_page_info(result);
                    build_page_nav(result);
                }
            });
        }

            // 表格信息
            function build_emps_table(result) {
                //清空表格
                $("#emps_table tbody").empty();
                var emps = result.extend.pageInfo.list;
                $.each(emps,function (index,item) {
                    var checkBoxTd = $("<td><input type='checkbox' class='check_item'<td/> />")
                    var empIdTd = $("<td></td>").append(item.empId);
                    var empNameTd = $("<td></td>").append(item.empName);
                    var genderTd = $("<td></td>").append(item.gender == 'M'?"男":"女");
                    var emailTd = $("<td></td>").append(item.email);
                    var deptNameTd = $("<td></td>").append(item.department.deptName);
                    var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-grain")).append("编辑");
                    //为编辑按钮添加自定义属性，表示员工id
                    editBtn.attr("edit-id",item.empId);
                    var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                        .append($("<span></span>").addClass("glyphicon glyphicon-scissors")).append("删除");
                    //为删除按钮添加自定义属性，表示员工id
                    delBtn.attr("del-id",item.empId);
                    var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
                    $("<tr></tr>")
                        .append(checkBoxTd)
                        .append(empIdTd)
                        .append(empNameTd)
                        .append(genderTd)
                        .append(emailTd)
                        .append(deptNameTd)
                        .append(btnTd)
                        .appendTo("#emps_table tbody");
                });
            }
            // 分页信息
            function build_page_info(result) {
                $("#page_info_area").empty();
                $("#page_info_area").append("当前第"+result.extend.pageInfo.pageNum+"页,总共"+
                    result.extend.pageInfo.pages+
                    "页,总共"+result.extend.pageInfo.total+"条记录");
                totalRecord = result.extend.pageInfo.total;
                currentPage = result.extend.pageInfo.pageNum;
            }

            // 分页条
            function build_page_nav(result) {
                $("#page_nav_area").empty();
                //page_nav_area
                var ul = $("<ul></ul>").addClass("pagination");
                var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
                var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
                //如果没有上一页
                if(result.extend.pageInfo.hasPreviousPage == false) {
                    firstPageLi.addClass("disabled");
                    prePageLi.addClass("disabled");
                }else {
                    //为元素添加翻页的事件
                    firstPageLi.click(function(){
                        to_page(1);
                    });
                    prePageLi.click(function () {
                        to_page(result.extend.pageInfo.pageNum -1);
                    });
                }
                var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
                var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
                //如果没有下一页
                if(result.extend.pageInfo.hasNextPage == false) {
                    nextPageLi.addClass("disabled");
                    lastPageLi.addClass("disabled");
                }else{
                    nextPageLi.click(function () {
                        to_page(result.extend.pageInfo.pageNum +1);
                    });
                    lastPageLi.click(function () {
                        to_page(result.extend.pageInfo.pages);
                    });
                }

                ul.append(firstPageLi).append(prePageLi);
                $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                    var numLi = $("<li></li>").append($("<a></a>").append(item));
                    if(result.extend.pageInfo.pageNum == item){
                        numLi.addClass("active");
                    }
                    numLi.click(function(){
                       to_page(item);
                    });
                    ul.append(numLi);
                });
                ul.append(nextPageLi).append(lastPageLi);
                var navEle = $("<nav></nav>").append(ul);
                navEle.appendTo("#page_nav_area");
            }
            //清空表单样式
            function reset_form(ele){
                $(ele)[0].reset();
                $(ele).find("*").removeClass("has-error has-success");
                $(ele).find(".help-block").text("");
            }
            //点击新增弹出模态框
            $("#emp_add_model_btn").click(function () {
                //每一次点击都要先清除之前的表单数据
                reset_form("#empAddModal form");
                //$("#empAddModal form")[0].reset();
                //发送ajax请求
                getDepts("#dept_add_select");
                //弹出模态框
                $("#empAddModal").modal({
                    backdrop:"static"
                });
            });
        //查出所有部门信息并显示下拉列表
        function getDepts(ele) {
            $(ele).empty();
            $.ajax({
                url:"${APP_PATH}/depts",
                type:"GET",
                success:function (result) {
                    //$("#dept_add_select")
                    $.each(result.extend.depts,function () {
                        var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                        optionEle.appendTo(ele);
                    })
                }
            });
        }
        //校验表单数据
        function validate_add_form(){
            //先拿到表单数据，使用正则表达式校验
            var empName = $("#empName_add_input").val();
            var regName =/(^[a-zA-Z0-9_-]{5,16}$)|(^[\u2E80-\u9FFF]{3,5})/;
            if(!regName.test(empName)){
                //alert("英文或数字组合长度5-16位，中文为3-5")
                show_validate_msg("#empName_add_input","error","英文或数字组合长度5-16位，中文为3-5");
                return false;
            }else{
                show_validate_msg("#empName_add_input","success","");
            }
            //校验邮箱
            var email=$("#email_add_input").val();
            var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                //alert("请不要搞事情，请输入正确的邮箱格式")
                show_validate_msg("#email_add_input","error","请不要搞事情，请输入正确的邮箱格式");
                return false;
            }else{
                show_validate_msg("#email_add_input","success","")
            }
            return true;
        }

        function show_validate_msg(ele,status,msg){
            //清除之前的状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if("success" == status){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if ("error" == status) {
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //姓名输入框改变后，发送ajax请求
        $("#empName_add_input").change(function() {
           //校验用户名是否可用
            var empName = this.value;
            $.ajax({
                url:"${APP_PATH}/checkuser",
                data:"empName="+empName,
                type:"POST",
                success:function(result){
                    if(result.code==100){
                        show_validate_msg("#empName_add_input","success","用户名可用");
                        $("#emp_save_btn").attr("ajax-va","success");
                    }else{
                        show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va","error");
                    }
                }
            });
        });

        //保存用户的单击事件
        $("#emp_save_btn").click(function () {
            //先对表达那数据校验
            if(!validate_add_form()){
                return false;
            }
            //判断用户名是否重复，如果重复，不给提交
            if($(this).attr("ajax-va")=="error"){
                return false;
            }
            //发送ajax请求保存员工
            //把表单的数据序列化提交
            //$("#empAddModal form").serialize();
            $.ajax({
                url:"${APP_PATH}/emp",
                type:"POST",
                data:$("#empAddModal form").serialize(),
                success:function (result) {
                    if(result.code == 100){
                        //关闭模态框
                        $("#empAddModal").modal('hide');
                        //发送ajax请求显示最后一页的数据
                        to_page(9999)
                    }else {

                        if(undefined != result.extend.errorFields.email){
                            show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                        }
                        if(undefined != result.extend.errorFields.empName){
                            show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                        }
                    }

                }
            });
        });

        //编辑按钮
        $(document).on("click",".edit_btn",function () {
            //查出部门信息
            getDepts("#empUpdateModal select");
            //查出员工信息
            getEep($(this).attr("edit-id"));
            //把员工的ID传递给更新按钮
            $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
            //弹出模态框
            $("#empUpdateModal").modal({
                backdrop:"static"
            });
        });

        function getEep(id){
            $.ajax({
                url:"${APP_PATH}/emp/"+id,
                type:"GET",
                success:function (result) {
                    var empData = result.extend.emp;
                    $("#empName_update_static").text(empData.empName);
                    $("#email_update_input").val(empData.email);
                    $("#empUpdateModal input[name=gender]").val([empData.gender]);
                    $("#empUpdateModal select").val([empData.dId]);
                }
            });
        }

        //点击更新，更新员工信息
        $("#emp_update_btn").click(function () {
            //验证邮箱
            var email=$("#email_update_input").val();
            var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if(!regEmail.test(email)){
                //alert("请不要搞事情，请输入正确的邮箱格式")
                show_validate_msg("#email_update_input","error","请不要搞事情，请输入正确的邮箱格式");
                return false;
            }else{
                show_validate_msg("#email_update_input","success","")
            }

            //发送ajax请求,保存更新
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
                type:"PUT",
                data:$("#empUpdateModal form").serialize(),
                success:function (result) {
                    //alert(result.msg);
                    //关闭模态框
                    $("#empUpdateModal").modal("hide");
                    //回到本页面
                    to_page(currentPage);
                }
            });
        });

      //删除按钮
      $(document).on("click",".delete_btn",function () {
            //弹出是否删除确认
          var empName = $(this).parents("tr").find("td:eq(2)").text();
          var empId = $(this).prop("del-id");
          if(confirm("确认要删除"+empName+"吗")){
              $.ajax({
                  url:"${APP_PATH}/emp/"+empId,
                  type:"DELETE",
                  success:function(result){
                      alert(result.msg);
                      to_page(currentPage);
                  }
              });
          }
      });

      //完成全选/全不选功能
        $("#check_all").click(function () {
            $(".check_item").prop("checked",$(this).prop("checked"))
        })

      $(document).on("click", ".check_item", function () {
          var isAllChecked = $(".check_item:checked").length === $(".check_item").length;
          $("#check_all").prop("checked", isAllChecked);
      });

        //点击全部删除就批量删除
        $("#emp_delete_all_btn").click(function () {
            var empNames = "";
            var del_idstr="";
            $.each($(".check_item:checked"),function () {
                    empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
                    del_idstr +=  $(this).parents("tr").find("td:eq(1)").text()+"-";
            });
            empNames=empNames.substring(0,empNames.length-1);
            del_idstr= del_idstr.substring(0,del_idstr.length-1);
            if(confirm("确认删除"+empNames+"吗")){
                $.ajax({
                    url:"${APP_PATH}/emp/"+del_idstr,
                    type:"DELETE",
                    success:function (result) {
                        alert(result.msg);
                        to_page(currentPage);
                    }
                });
            }
        });
    </script>
</body>
</html>
