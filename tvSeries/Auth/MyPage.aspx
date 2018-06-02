<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="MyPage.aspx.cs" Inherits="tvSeries.Auth.MyPage" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/Styles/Auth/MyPage.css" runat="server"/>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if(Session["username"] == null)
                {
                    Response.Redirect("/HomePage.aspx");
                    return;
                }
            }
        }

        protected void GetUserDetail()
        {
            String username = Session["username"].ToString();

            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Account WHERE username = @UserName";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@UserName", username);




            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                while(rd.Read())
                {

                }

            } catch(Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

        }

        protected void ShowUpdateView(object sender, EventArgs e)
        {
            UserMultiView.ActiveViewIndex = 1;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:MultiView runat="server" ID="UserMultiView" ActiveViewIndex="0">
        <asp:View runat="server" ID="NonUpdateView">
            <div class="MyInfoForm">
                <div class="Line">
                    <asp:Label CssClass="Label" ID="IDLabel" runat="server" Text="아이디"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="IDContentLabel" runat="server" Text="SomeID"></asp:Label>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="EmailLabel" runat="server" Text="이메일"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="EmailContentLabel" runat="server" Text="SomeEmail"></asp:Label>
                </div>
                <div class="ButtonWrapper">
                    <asp:Button OnClick="ShowUpdateView" ID="UpdateViewButton" runat="server" CssClass="UpdateButton" Text="정보수정하기"/>
                </div>
            </div>
        </asp:View>
        <asp:View runat="server" ID="UpdateView">
            <div class="MyInfoForm">
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label1" runat="server" Text="아이디"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="IDUpdateViewLabel" runat="server" Text="MyID"></asp:Label>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label3" runat="server" Text="이메일"></asp:Label>
                    <asp:TextBox ID="EmailTextBox" runat="server" CssClass="Input"></asp:TextBox>
                </div>
                <div class="ButtonWrapper">
                    <asp:Button OnClick="ShowUpdateView" ID="Button1" runat="server" CssClass="UpdateButton" Text="정보수정하기"/>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
