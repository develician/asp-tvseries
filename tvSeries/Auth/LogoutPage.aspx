<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="LogoutPage.aspx.cs" Inherits="tvSeries.Auth.LogoutPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Auth/LogoutPage.css" />
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["username"] == null)
            {
                Response.Redirect("/HomePage.aspx");
            }
        }

        protected void Logout(object sender, EventArgs e)
        {
            Session.Remove("username");
            Session.Remove("admin");
            Response.Redirect("/HomePage.aspx");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:panel runat="server" id="LogoutPanel" cssclass="LogoutPanel">
        <div class="Contents">
            <div class="Label">
            정말로 로그아웃 하시겠습니까?
        </div>
        <div class="ButtonWrapper">
            <asp:Button runat="server" ID="LogoutButton" CssClass="LogoutButton" Text="로그아웃" OnClick="Logout"/>
            <a href='javascript:history.go(-1)' class="BackButton">돌아가기</a>
        </div>
        </div>
    </asp:panel>
</asp:Content>
