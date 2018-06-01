﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="RegisterPage.aspx.cs" Inherits="tvSeries.Auth.RegisterPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Auth/LoginPage.css"/>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:panel CssClass="LoginPanel" runat="server" ID="LoginPanel">
        <div class="Logo">회원가입</div>
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
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="PasswordTextBox"></asp:TextBox>
            </div>
        </div>
         <div class="Line">
            <div class="Label">
                비밀번호 확인
            </div>
            <div class="InputWrapper">
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="PasswordCheckTextBox"></asp:TextBox>
            </div>
        </div>
         <div class="Line">
            <div class="Label">
                이메일
            </div>
            <div class="InputWrapper">
                <asp:TextBox CssClass="Input" runat="server" ID="EmailTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonWrapper">
            <asp:Button CssClass="LoginButton" runat="server" Text="회원가입" ID="RegisterButton"/>
        </div>
        <div class="Description">
            이미 가입하셨나요? <a href="/Auth/LoginPage.aspx">로그인 하러가기</a>
        </div>
    </asp:panel>
</asp:Content>