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
                GetUserDetail();
            }
        }

        protected void UpdateEmailAction(object sender, EventArgs e)
        {

            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "UPDATE tvseries.dbo.Account SET email = @Email WHERE username = @UserName";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Email", EmailTextBox.Text.ToString());
            command.Parameters.AddWithValue("@UserName", Session["username"].ToString());

            try
            {
                conn.Open();

                command.ExecuteNonQuery();



            } catch(Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

            GetUserDetail();

            UserMultiView.ActiveViewIndex = 0;
        }

        protected void UpdatePasswordAction(object sender, EventArgs e)
        {
            if(!PasswordCheckTextBox.Text.ToString().Equals(PasswordTextBox.Text.ToString()))
            {

                ErrorLabel.Text = "두 비밀번호가 일치하지 않습니다.";
                ErrorLabel.Visible = true;
                return;
            }

            if(PasswordTextBox.Text.Length == 0 || PasswordTextBox.Text.Equals("") ||
                PasswordCheckTextBox.Text.Length == 0 || PasswordCheckTextBox.Text.Equals(""))
            {
                ErrorLabel.Text = "비밀번호를 모두 입력해주세요.";
                ErrorLabel.Visible = true;
                return;
            }

            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "UPDATE tvseries.dbo.Account SET password = @Password WHERE username = @UserName";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Password", PasswordCheckTextBox.Text.ToString());
            command.Parameters.AddWithValue("@UserName", Session["username"].ToString());

            try
            {
                conn.Open();

                command.ExecuteNonQuery();

            } catch(Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

            GetUserDetail();
            UserMultiView.ActiveViewIndex = 0;

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
                    IDContentLabel.Text = rd["username"].ToString();
                    EmailContentLabel.Text = rd["email"].ToString();
                    IDUpdateViewLabel.Text = rd["username"].ToString();
                    EmailTextBox.Text = rd["email"].ToString();
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
        protected void ShowPasswordUpdateView(object sender, EventArgs e)
        {
            UserMultiView.ActiveViewIndex = 2;
        }

        protected void CancelButtonAction(object sender, EventArgs e)
        {
            UserMultiView.ActiveViewIndex = 0;
        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:MultiView runat="server" ID="UserMultiView" ActiveViewIndex="0">
        <asp:View runat="server" ID="NonUpdateView">
            <div class="MyInfoForm">
                <div class="Line">
                    <asp:Label CssClass="Label" ID="IDLabel" runat="server" Text="아이디"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="IDContentLabel" runat="server"></asp:Label>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="EmailLabel" runat="server" Text="이메일"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="EmailContentLabel" runat="server"></asp:Label>
                </div>
                <div class="ButtonWrapper">
                    <asp:Button OnClick="ShowUpdateView" ID="UpdateViewButton" runat="server" CssClass="UpdateButton" Text="이메일 변경하기"/>
                    <asp:Button OnClick="ShowPasswordUpdateView" ID="UpdatePasswordButton" runat="server" CssClass="UpdateButton" Text="비밀번호 변경하기"/>
                </div>
            </div>
        </asp:View>
        <asp:View runat="server" ID="UpdateView">
            <div class="MyInfoForm">
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label1" runat="server" Text="아이디"></asp:Label>
                    <asp:Label CssClass="ContentLabel" ID="IDUpdateViewLabel" runat="server"></asp:Label>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label3" runat="server" Text="이메일"></asp:Label>
                    <asp:TextBox ID="EmailTextBox" runat="server" CssClass="ContentInput"></asp:TextBox>
                </div>
                <div class="ButtonWrapper">
                    <asp:Button OnClick="UpdateEmailAction" ID="Button1" runat="server" CssClass="UpdateButton" Text="변경사항 저장"/>
                    <asp:Button OnClick="CancelButtonAction" ID="Button3" runat="server" CssClass="UpdateButton" Text="취소"/>
                </div>
            </div>
        </asp:View>
        <asp:View runat="server" ID="UpdatePasswordView">
            <div class="MyInfoForm">
                <div class="ErrorMessage">
                    <asp:Label CssClass="ErrorContent" runat="server" ID="ErrorLabel" Visible="false"/>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label2" runat="server" Text="비밀번호"></asp:Label>
                    <asp:TextBox CssClass="ContentInput" TextMode="Password" ID="PasswordTextBox" runat="server"></asp:TextBox>
                </div>
                <div class="Line">
                    <asp:Label CssClass="Label" ID="Label5" runat="server" Text="비밀번호 확인"></asp:Label>
                    <asp:TextBox ID="PasswordCheckTextBox" TextMode="Password" runat="server" CssClass="ContentInput"></asp:TextBox>
                </div>
                <div class="ButtonWrapper">
                    <asp:Button OnClick="UpdatePasswordAction" ID="Button2" runat="server" CssClass="UpdateButton" Text="변경사항 저장"/>
                    <asp:Button OnClick="CancelButtonAction" ID="Button4" runat="server" CssClass="UpdateButton" Text="취소"/>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>
