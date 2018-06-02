<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="RegisterPage.aspx.cs" Inherits="tvSeries.Auth.RegisterPage" %>

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

        protected void Register(object sender, EventArgs e)
        {
            CheckExisitng();
            RegisterAction();
        }



        protected void RegisterAction()
        {
            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");

            String SQL = "SELECT COUNT(*) as count FROM tvseries.dbo.Account;";
            SqlCommand command = new SqlCommand(SQL, conn);

            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();
                int count = 0;
                while (rd.Read())
                {
                    count = Int32.Parse(rd["count"].ToString());
                }

                rd.Close();

                SQL = "INSERT INTO tvseries.dbo.Account (username, password, email, isAdmin) VALUES (@UserName, @Password, @Email, @IsAdmin)";
                command = new SqlCommand(SQL, conn);
                command.Parameters.AddWithValue("@UserName", IDTextBox.Text.ToString());
                command.Parameters.AddWithValue("@Password", PasswordTextBox.Text.ToString());
                command.Parameters.AddWithValue("@Email", EmailTextBox.Text.ToString());
                if (count == 0)

                {


                    command.Parameters.AddWithValue("@IsAdmin", 1);

                    command.ExecuteNonQuery();

                }
                else
                {
                    command.Parameters.AddWithValue("@IsAdmin", 0);

                    command.ExecuteNonQuery();
                }

                Response.Redirect("/Auth/LoginPage.aspx");

            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

        }


        protected void CheckExisitng()
        {
            SqlConnection conn =
                 new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");

            String SQL = "SELECT * FROM tvseries.dbo.Account WHERE username = @UserName";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@UserName", IDTextBox.Text.ToString());

            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                int i = 0;
                while (rd.Read())
                {
                    i++;
                }

                if (i != 0)
                {
                    ErrorLabel.Text = "이미 존재하는 아이디 입니다.";
                    ErrorLabel.Visible = true;
                    return;
                }



            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel CssClass="LoginPanel" runat="server" ID="LoginPanel">
        <div class="Logo">회원가입</div>
        <div class="Errors">
            <asp:Label runat="server" CssClass="ErrorLabel" Visible="false" ID="ErrorLabel"></asp:Label>
        </div>
        <div class="Line">
            <div class="Label">
                아이디
            </div>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="Validation" ID="IDValidator" runat="server" ControlToValidate="IDTextBox" ErrorMessage="아이디를 입력해주세요.">
            </asp:RequiredFieldValidator>
            <div class="InputWrapper">
                <asp:TextBox CssClass="Input" runat="server" ID="IDTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="Line">
            <div class="Label">
                비밀번호
            </div>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="Validation" ID="PasswordValidator" runat="server" ControlToValidate="PasswordTextBox" ErrorMessage="패스워드를 입력해주세요." />
            <asp:CompareValidator ID="PasswordCompareValidator" CssClass="Validation" runat="server" ControlToValidate="PasswordTextBox" ControlToCompare="PasswordCheckTextBox" ErrorMessage="두 패스워드가 같지않습니다." Display="Dynamic" /></asp:CompareValidator>
            <div class="InputWrapper">
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="PasswordTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="Line">
            <div class="Label">
                비밀번호 확인
            </div>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="Validation" ID="PasswordCheckValidator" runat="server" ControlToValidate="PasswordCheckTextBox" ErrorMessage="패스워드를 입력해주세요." />

            <div class="InputWrapper">
                <asp:TextBox TextMode="Password" CssClass="Input" runat="server" ID="PasswordCheckTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="Line">
            <div class="Label">
                이메일
            </div>
            <asp:RequiredFieldValidator Display="Dynamic" CssClass="Validation" runat="server" ID="EmailEmptyValidator" ErrorMessage="이메일을 입력해주세요" ControlToValidate="EmailTextBox" />
            <asp:RegularExpressionValidator Display="Dynamic" CssClass="Validation" runat="server" ID="EmailValidator" ErrorMessage="정확한 형식의 이메일을 입력해주세요." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="EmailTextBox"></asp:RegularExpressionValidator>
            <div class="InputWrapper">
                <asp:TextBox CssClass="Input" runat="server" ID="EmailTextBox"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonWrapper">
            <asp:Button CssClass="LoginButton" runat="server" Text="회원가입" OnClick="Register" ID="RegisterButton" />
        </div>
        <div class="Description">
            이미 가입하셨나요? <a href="/Auth/LoginPage.aspx">로그인 하러가기</a>
        </div>
    </asp:Panel>
</asp:Content>
