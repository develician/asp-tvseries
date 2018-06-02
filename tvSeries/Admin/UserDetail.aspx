<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="UserDetail.aspx.cs" Inherits="tvSeries.Admin.UserDetail" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/Styles/Admin/UserDetail.css" runat="server" />

    <script runat="server">
        int id = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] == null)
            {
                id = 0;
            }
            else
            {
                id = Int32.Parse(Request.QueryString["id"].ToString());
            }


            if(!Page.IsPostBack)
            {
                GetUserDetail(id);
            }
        }

        protected void GetUserDetail(int id)
        {
            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");

            String SQL = "SELECT * FROM tvseries.dbo.Account WHERE id = @UserID";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@UserID", id);


            String username = "";
            String email = "";

            try
            {

                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                while(rd.Read())
                {
                    username = rd["username"].ToString();
                    email = rd["email"].ToString();
                }

                IDContentLabel.Text = username;
                EmailContentLabel.Text = email;

                rd.Close();

            } catch(Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }
        }


        protected void RemoveUser(object sender, EventArgs e)
        {
            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");

            String SQL = "DELETE FROM tvseries.dbo.Account WHERE id = @UserID";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@UserID", id);

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

            Response.Redirect("/Admin/UserManagement.aspx");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="UserDetailPanel" CssClass="UserDetailPanel" runat="server">
        <div class="Line">
            <asp:Label CssClass="Label" ID="IDLabel" runat="server" Text="아이디"></asp:Label>
            <asp:Label CssClass="LabelContent" ID="IDContentLabel" runat="server" Text="SomeID"></asp:Label>
        </div>
        <div class="Line">
            <asp:Label CssClass="Label" ID="EmailLabel" runat="server" Text="이메일"></asp:Label>
            <asp:Label CssClass="LabelContent" ID="EmailContentLabel" runat="server" Text="SomeEmail"></asp:Label>
        </div>
        <div class="ButtonWrapper">
            <asp:Button CssClass="Button" ID="Button" runat="server" Text="탈퇴시키기" OnClick="RemoveUser" />
        </div>
    </asp:Panel>
</asp:Content>
