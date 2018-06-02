<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="tvSeries.Auth.LoginPage" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Auth/LoginPage.css" />
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session["username"] != null)
                {
                    Response.Redirect("/Home.aspx");
                }
            }
        }

        protected void Login(object sender, EventArgs e)
        {
            LoginAction();
        }

        protected void LoginAction()
        {
            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Account WHERE username = @UserName;";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@UserName", IDTextBox.Text.ToString());

            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                int i = 0;

                String password = "";
                int isAdmin = 0;
                while(rd.Read())
                {
                    password = rd["password"].ToString();
                    isAdmin = Int32.Parse(rd["isAdmin"].ToString());
                    i++;
                }

                rd.Close();

                if(i == 0)
                {
                    ErrorLabel.Text = "없는 아이디 입니다.";
                    ErrorLabel.Visible = true;
                    return;
                }

                if(!password.Equals(PasswordTextBox.Text.ToString()))
                {
                    ErrorLabel.Text = "비밀번호가 일치하지 않습니다.";
                    ErrorLabel.Visible = true;
                    return;
                }

                Session.Add("username", IDTextBox.Text.ToString());
                if(isAdmin == 1)
                {
                    Session.Add("admin", true);
                } else
                {
                    Session.Add("admin", false);
                }

                Response.Redirect("/HomePage.aspx");

            } catch(Exception exception)
            {
                Response.Write(exception.Message.ToString());
            } finally
            {
                conn.Close();
            }


        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel CssClass="LoginPanel" runat="server" ID="LoginPanel">
        <div class="Logo">로그인</div>
        <div class="Errors">
            <asp:Label runat="server" CssClass="ErrorLabel" Visible="false" ID="ErrorLabel"></asp:Label>
        </div>
        <div class="Line">
            <div class="Label">
                아이디
            </div>
            <asp:RequiredFieldValidator ErrorMessage="아이디를 입력하여 주세요" Display="Dynamic" ID="IDValidator" runat="server" CssClass="Validation" ControlToValidate="IDTextBox"></asp:RequiredFieldValidator>
            <div class="InputWrapper">
                <asp:TextBox CssClass="Input" runat="server" ID="IDTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="Line">
            <div class="Label">
                비밀번호
            </div>
            <asp:RequiredFieldValidator ErrorMessage="비밀번호를 입력하여 주세요" Display="Dynamic" ID="PasswordValidator" runat="server" CssClass="Validation" ControlToValidate="PasswordTextBox"></asp:RequiredFieldValidator>

            <div class="InputWrapper">
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="PasswordTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonWrapper">
            <asp:Button CssClass="LoginButton" runat="server" OnClick="Login" Text="Login" ID="LoginButton" />
        </div>
        <div class="Description">
            아직 가입하지 않으셨나요? <a href="/Auth/RegisterPage.aspx">가입하러가기</a>
        </div>
    </asp:Panel>
</asp:Content>
