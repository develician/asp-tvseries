<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="UserManagement.aspx.cs" Inherits="tvSeries.Admin.UserManagement" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" runat="server" href="/Styles/Admin/UserManagement.css" />
    <script runat="server">
        int CurrentPage = 1;
        PagedDataSource pagedDataSource;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["page"] == null)
            {
                CurrentPage = 1;
            }
            else
            {
                CurrentPage = Int32.Parse(Request.QueryString["page"].ToString());
            }



            if (!Page.IsPostBack)
            {
                GetUserList(CurrentPage);
            }
        }

        protected void GetUserList(int currentPage)
        {
            SqlConnection conn =
                new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=tvseries; Integrated Security=False; uid=killi8n; pwd=admin1234");

            String SQL = "SELECT * FROM tvseries.dbo.Account WHERE isAdmin = 0 ORDER BY id DESC";
            SqlCommand command = new SqlCommand(SQL, conn);

            try
            {
                conn.Open();



                //SqlDataReader rd = command.ExecuteReader();
                DataSet dataSet = new DataSet();
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(SQL, conn);
                sqlDataAdapter.Fill(dataSet);
                pagedDataSource = new PagedDataSource();



                pagedDataSource.AllowPaging = true;
                pagedDataSource.DataSource = dataSet.Tables[0].DefaultView;
                pagedDataSource.PageSize = 10;


                pagedDataSource.CurrentPageIndex = currentPage - 1;
                UserDataList.DataSource = pagedDataSource;
                UserDataList.DataBind();
                PageLabel.Text = "Page " + (CurrentPage).ToString();



                //rd.Close();
            }
            catch (Exception exception)
            {
                Response.Write("에러: " + exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }
        }

        protected void pageNext(object sender, EventArgs e)
        {


            GetUserList(CurrentPage);

            

            PageLabel.Text = "Page " + (CurrentPage).ToString();

            if (pagedDataSource.IsLastPage)
            {
                Response.Redirect("/Admin/UserManagement.aspx?page=" + (CurrentPage));
                return;
            }

            Response.Redirect("/Admin/UserManagement.aspx?page=" + (CurrentPage + 1));
        }
        protected void pagePrev(object sender, EventArgs e)
        {
            GetUserList(CurrentPage);
            PageLabel.Text = "Page " + (CurrentPage).ToString();
            if (pagedDataSource.IsFirstPage)
            {
                Response.Redirect("/Admin/UserManagement.aspx?page=" + (CurrentPage));
                return;
            }
            Response.Redirect("/Admin/UserManagement.aspx?page=" + (CurrentPage - 1));
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="DataListWrapper">
        <asp:DataList CssClass="UserDataList" runat="server" ID="UserDataList" RepeatDirection="Vertical">
            <ItemStyle CssClass="Line" />
            <ItemTemplate>
                <div class="AWrapper">
                    <a href="/Admin/UserDetail.aspx?id=<%#Eval ("id") %>">
                        <div class="Text">
                            id: <%# Eval("id") %>
                        </div>
                    </a>
                    <a href="/Admin/UserDetail.aspx?id=<%#Eval ("id") %>">
                        <div class="Text">
                            아이디: <%# Eval("username") %>
                        </div>
                    </a>
                    <a href="/Admin/UserDetail.aspx?id=<%#Eval ("id") %>">
                        <div class="Text">
                            이메일: <%# Eval("email") %>
                        </div>
                    </a>
                </div>
            </ItemTemplate>
        </asp:DataList>

    </div>
    <asp:Panel CssClass="Pagination" runat="server" ID="PaginationPanel">
        <asp:Button CssClass="Button" runat="server" ID="PrevButton" Text="Prev" OnClick="pagePrev" />
        <asp:Label ID="PageLabel" CssClass="PageLabel" runat="server" Text="Page" />
        <asp:Button CssClass="Button" runat="server" ID="NextButton" Text="Next" OnClick="pageNext" />
    </asp:Panel>
</asp:Content>
