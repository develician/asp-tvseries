<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="tvSeries.Auth.LoginPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Auth/LoginPage.css"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:panel CssClass="LoginPanel" runat="server" ID="LoginPanel">
        <div class="Logo">로그인</div>
        <div class="Line">
            <div class="Label">
                아이디
            </div>
            <div class="InputWrapper">
                <asp:TextBox CssClass="Input" runat="server" ID="IDTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="Line">
            <div class="Label">
                비밀번호
            </div>
            <div class="InputWrapper">
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="TextBox1"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonWrapper">
            <asp:Button CssClass="LoginButton" runat="server" Text="Login" ID="LoginButton"/>
        </div>
        <div class="Description">
            아직 가입하지 않으셨나요? <a href="/Auth/RegisterPage.aspx">가입하러가기</a>
        </div>
    </asp:panel>
</asp:Content>
