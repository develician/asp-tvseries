<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="tvSeries.Admin.AdminHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Admin/AdminMenu.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ButtonWrapper">
        <div class="Contents">
            <a href="/Admin/UserManagement.aspx" class="Button">유저관리</a>
            <a href="/Admin/UserManagement.aspx" class="Button">포스팅</a>
            <a href="/Admin/UserManagement.aspx" class="Button">포스트 관리</a>
        </div>
    </div>
</asp:Content>
